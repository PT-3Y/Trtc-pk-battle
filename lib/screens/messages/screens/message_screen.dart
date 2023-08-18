import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models.dart';
import 'package:socialv/models/messages/search_message_response.dart';
import 'package:socialv/screens/messages/components/recent_message_component.dart';
import 'package:socialv/screens/messages/components/restore_component.dart';
import 'package:socialv/screens/messages/components/search_message_component.dart';
import 'package:socialv/screens/messages/functions.dart';
import 'package:socialv/screens/messages/screens/favourite_message_screen.dart';
import 'package:socialv/screens/messages/screens/new_chat_screen.dart';
import 'package:socialv/screens/messages/screens/user_settings_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';

import '../../../models/messages/emoji.dart';
import '../../../network/messages_repository.dart';

WebSocketChannel? channel;

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

List<Emojis> emojiList = [];

class _MessageScreenState extends State<MessageScreen> {
  List<DrawerModel> tabs = messageTabs();
  int selectedTab = 0;
  bool hasShowClearTextIcon = false;
  TextEditingController searchController = TextEditingController();

  SearchMessageResponse? searchResponse;
  bool isError = false;
  bool isSearchPerformed = false;
  bool showRestore = false;
  int? deletedThreadId;

  int mPage = 1;

  @override
  void initState() {
    super.initState();
    getEmojisList();
    getSettings();
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        showClearTextIcon();
      } else {
        hasShowClearTextIcon = false;
        searchResponse = null;
        setState(() {});
      }
    });

    final message = '40["$WEB_SOCKET_DOMAIN",${appStore.loginUserId},"${messageStore.bmSecretKey}"]';

    channel = IOWebSocketChannel.connect(WEB_SOCKET_URL);

    channel?.ready.then((value) {
      messageStore.clearTyping();
      log('*=*=*=*=*=*=*=*=*=*=*=*= READY =*=*=*=*=*=*=*=*=*=*=*=*');
      log('Message: $message');

      channel?.sink.add(message);
    }).catchError((e) {
      log('Error: ${e.toString()}');
    });

    channel?.stream.listen((message) {
      handleResponse(message);
    }, onError: (error) {
      print('WebSocket error: $error');
    }, onDone: () {
      messageStore.clearOnlineUser();
      print('WebSocket connection closed');
    });

    channel?.closeReason;
  }

  void handleResponse(String message) {
    if (message == '2') {
      log('Pong----------');
      messageStore.clearTyping();

      channel?.sink.add('3');

      if (threadOpened != null) {
        String message = '42["${SocketEvents.threadOpen}",$threadOpened]';
        channel?.sink.add(message);
      }
    } else {
      handleSocketEvents(message);
    }
  }

  void showClearTextIcon() {
    if (!hasShowClearTextIcon) {
      hasShowClearTextIcon = true;
      setState(() {});
    }
  }

  Future<List<Emojis>> getEmojisList() async {
    emojiList.clear();
    await getChatReactionList().then((value) {
      emojiList.addAll(value);
    }).catchError((e) {
      toast(
        e.toString(),
      );
      appStore.setLoading(false);
    });
    return emojiList;
  }

  Future<void> search() async {
    appStore.setLoading(true);
    await searchMessage(searchText: searchController.text.validate()).then((value) {
      searchResponse = value;
      isError = false;
      appStore.setLoading(false);
    }).catchError((e) {
      isError = true;
      appStore.setLoading(false);
    });

    setState(() {});
  }

  Future<void> getSettings() async {
    messageSettings().then((value) {
      if (value.allowUsersBlock == '1') {
        messageStore.setAllowBlock(true);

        log('=========================== ${messageStore.allowBlock} ======================');
      } else {
        messageStore.setAllowBlock(false);
      }
    }).catchError((e) {
      log('Error: ${e.toString()}');
    });

    userSettings().then((value) {
      if (value.chatBackground != null && value.chatBackground!.url.validate().isNotEmpty) {
        messageStore.setGlobalChatBackground(value.chatBackground!.url.validate());
      }
    }).catchError((e) {
      log('Error: ${e.toString()}');
    });

    setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(RefreshRecentMessage);

    messageStore.setRefreshRecentMessages(false);
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.messages, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
        actions: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              NewChatScreen().launch(context);
            },
            child: cachedImage(ic_new_chat, color: context.iconColor, width: 26, height: 26, fit: BoxFit.contain),
          ),
          8.width,
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              FavouriteMessageScreen().launch(context).then((value) {
                if (value ?? false) {
                  if (selectedTab == 0) {
                    LiveStream().emit(RefreshRecentMessages);
                  } else {
                    setState(() {});
                  }
                }
              });
            },
            child: cachedImage(ic_star, color: context.iconColor, width: 26, height: 26, fit: BoxFit.contain),
          ),
          IconButton(
            onPressed: () {
              UserSettingsScreen().launch(context);
            },
            icon: cachedImage(ic_setting, color: context.iconColor, width: 24, height: 24, fit: BoxFit.cover),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                AppTextField(
                  controller: searchController,
                  textFieldType: TextFieldType.USERNAME,
                  onFieldSubmitted: (text) {
                    if (searchController.text.trim().isNotEmpty) {
                      isSearchPerformed = true;
                      search();
                    } else {
                      isSearchPerformed = false;
                      setState(() {});
                    }
                  },
                  onChanged: (p0) {
                    if (searchController.text.trim().isEmpty) {
                      isSearchPerformed = false;
                      setState(() {});
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: context.cardColor,
                    border: InputBorder.none,
                    hintText: language.searchHere,
                    hintStyle: secondaryTextStyle(),
                    prefixIcon: Image.asset(
                      ic_search,
                      height: 16,
                      width: 16,
                      fit: BoxFit.cover,
                      color: appStore.isDarkMode ? bodyDark : bodyWhite,
                    ).paddingAll(16),
                    suffixIcon: hasShowClearTextIcon
                        ? IconButton(
                            icon: Icon(Icons.cancel, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 18),
                            onPressed: () {
                              hideKeyboard(context);
                              hasShowClearTextIcon = false;
                              searchController.clear();
                              searchResponse = null;
                              isSearchPerformed = false;
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                ).cornerRadiusWithClipRRect(commonRadius).paddingAll(16),
                HorizontalList(
                  itemCount: tabs.length,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    DrawerModel item = tabs[index];
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: selectedTab == index ? context.primaryColor : context.cardColor,
                        borderRadius: BorderRadius.all(radiusCircular()),
                      ),
                      child: TextIcon(
                        text: item.title.validate(),
                        textStyle: boldTextStyle(size: 14, color: selectedTab == index ? Colors.white : context.primaryColor),
                        onTap: () {
                          selectedTab = index;
                          setState(() {});
                        },
                        prefix: cachedImage(item.image, height: 16, width: 16, fit: BoxFit.cover, color: selectedTab == index ? Colors.white : context.primaryColor),
                      ),
                    );
                  },
                ),
                if (isSearchPerformed)
                  if (searchResponse == null)
                    SizedBox(
                      height: context.height() * 0.65,
                      child: NoDataWidget(
                        imageWidget: NoDataLottieWidget(),
                        title: language.noDataFound,
                        onRetry: () {
                          search();
                        },
                        retryText: '   ${language.clickToRefresh}   ',
                      ),
                    )
                  else
                    SearchMessageComponent(
                      onDeleteConvo: (int value) {
                        deletedThreadId = value;
                        showRestore = true;
                        setState(() {});
                      },
                      searchResponse: searchResponse!,
                      refreshThread: () {
                        search();
                        setState(() {});
                      },
                    )
                else if (isError)
                  SizedBox(
                    height: context.height() * 0.65,
                    child: NoDataWidget(
                      imageWidget: NoDataLottieWidget(),
                      title: isError ? language.somethingWentWrong : language.noDataFound,
                      onRetry: () {
                        hasShowClearTextIcon = false;
                        searchController.clear();
                        searchResponse = null;
                        isError = false;
                        setState(() {});
                      },
                      retryText: '   ${language.clickToRefresh}   ',
                    ),
                  )
                else
                  tabs[selectedTab].attachedScreen.validate(),
              ],
            ),
          ),
          if (showRestore)
            Positioned(
              top: context.height() / 1.4,
              right: 16,
              child: RestoreComponent(
                threadId: deletedThreadId.validate(),
                callback: (bool value) {
                  if (!value) {
                    search();
                  }
                  showRestore = false;
                  deletedThreadId = null;
                  setState(() {});
                },
              ),
            ),
          Observer(builder: (_) => LoadingWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
