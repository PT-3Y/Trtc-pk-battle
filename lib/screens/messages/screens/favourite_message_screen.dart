import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/messages/message_users.dart';
import 'package:socialv/models/messages/messages_model.dart';
import 'package:socialv/models/messages/threads_model.dart';
import 'package:socialv/models/messages/threads_list_model.dart';
import 'package:socialv/network/messages_repository.dart';
import 'package:socialv/screens/messages/components/message_media_component.dart';
import 'package:socialv/screens/messages/components/recent_message_component.dart';
import 'package:socialv/screens/messages/components/restore_component.dart';
import 'package:socialv/screens/messages/screens/chat_screen.dart';
import 'package:socialv/screens/messages/screens/message_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class FavouriteMessageScreen extends StatefulWidget {
  const FavouriteMessageScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteMessageScreen> createState() => _FavouriteMessageScreenState();
}

class _FavouriteMessageScreenState extends State<FavouriteMessageScreen> {
  bool showRestore = false;
  int? deletedThreadId;

  bool doRefresh = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        finish(context, doRefresh);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(language.starredMessages, style: boldTextStyle(size: 20)),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.iconColor),
            onPressed: () {
              finish(context, doRefresh);
            },
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SnapHelperWidget(
              future: getFavorites(),
              onSuccess: (ThreadsListModel snap) {
                if (snap.messages.validate().isNotEmpty) {
                  return ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: snap.messages.validate().length,
                    itemBuilder: (ctx, index) {
                      Messages message = snap.messages.validate()[index];
                      Threads thread = snap.threads.validate().firstWhere((element) => element.threadId == message.threadId);
                      MessagesUsers user = snap.users.validate().firstWhere((element) => element.userId == thread.participants!.first);

                      DateTime dateTime = DateTime.parse(message.dateSent.validate());
                      String date = DateFormat.Hm().format(dateTime).toString();

                      MessageMeta? meta;

                      if (message.meta.toString() != '[]') {
                        meta = MessageMeta.fromJson(message.meta);
                      }

                      return InkWell(
                        onTap: () {
                          String message = '42["${SocketEvents.threadOpen}",${thread.threadId.validate()}]';
                          String messageOne = '421["${SocketEvents.v3GetStatuses}",[${thread.threadId.validate()}]]';

                          log('Send Message = $message');
                          log('Send Message = $messageOne');
                          channel?.sink.add(message);
                          channel?.sink.add(messageOne);

                          threadOpened = thread.threadId.validate();

                          ChatScreen(
                            onDeleteThread: () {
                              finish(context);
                              deletedThreadId = thread.threadId.validate();
                              showRestore = true;
                              setState(() {});
                            },
                            threadId: thread.threadId.validate(),
                            thread: thread,
                            user: user,
                          ).launch(context);
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: context.width() * 0.85,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      cachedImage(
                                        thread.type == ThreadType.group ? thread.image : user.avatar,
                                        fit: BoxFit.cover,
                                        height: 40,
                                        width: 40,
                                      ).cornerRadiusWithClipRRect(20),
                                      12.width,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(text: '${thread.type == ThreadType.group ? thread.title.validate() : user.name.validate()} ', style: boldTextStyle(fontFamily: fontFamily)),
                                                if (thread.type == ThreadType.group && user.verified.validate() == 1)
                                                  WidgetSpan(
                                                    child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover),
                                                  ),
                                              ],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(date, style: secondaryTextStyle()),
                                        ],
                                      ),
                                    ],
                                  ),
                                  16.height,
                                  if (meta != null && meta.files.validate().isNotEmpty) MessageMediaComponent(files: meta.files.validate()).paddingOnly(bottom: 8),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: context.cardColor,
                                      borderRadius: radius(commonRadius),
                                    ),
                                    child: Text(parseHtmlString(message.message.validate()), style: primaryTextStyle()),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_outlined, color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 20)
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(color: context.dividerColor);
                    },
                  );
                } else {
                  return NoDataWidget(
                    imageWidget: NoDataLottieWidget(),
                    title: language.noDataFound,
                    onRetry: () {
                      setState(() {});
                    },
                  ).center();
                }
              },
              loadingWidget: LoadingWidget(),
              errorWidget: NoDataWidget(
                imageWidget: NoDataLottieWidget(),
                title: language.somethingWentWrong,
                onRetry: () {
                  setState(() {});
                },
              ).center(),
            ),
            if (showRestore)
              Positioned(
                right: 16,
                bottom: 20,
                child: RestoreComponent(
                  threadId: deletedThreadId.validate(),
                  callback: (bool value) {
                    if (!value) {
                      doRefresh = true;
                    }

                    showRestore = false;
                    deletedThreadId = null;
                    setState(() {});
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
