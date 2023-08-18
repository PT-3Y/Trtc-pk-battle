import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/messages/fast_message_model.dart';
import 'package:socialv/models/messages/messages_model.dart';
import 'package:socialv/models/messages/message_users.dart';
import 'package:socialv/models/messages/permissions.dart';
import 'package:socialv/models/messages/stream_message.dart';
import 'package:socialv/models/messages/threads_model.dart';
import 'package:socialv/network/messages_repository.dart';
import 'package:socialv/screens/messages/components/chat_screen_components/chat_screen_popup_menu_component.dart';
import 'package:socialv/screens/messages/components/no_message_component.dart';
import 'package:socialv/screens/messages/components/reaction_bottom_sheet.dart';
import 'package:socialv/screens/messages/components/recent_message_component.dart';
import 'package:socialv/screens/messages/functions.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';
import '../../../utils/sv_reactions/sv_reaction.dart';
import '../components/chat_screen_components/write_message_component.dart';
import '../components/chat_screen_components/chat_screen_message_component.dart';
import '../components/chat_screen_components/chat_screen_title_component.dart';
import 'message_screen.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  final int threadId;
  MessagesUsers? user;
  final Threads? thread;
  final VoidCallback? callback;
  final VoidCallback onDeleteThread;

  ChatScreen({required this.threadId, this.user, this.thread, this.callback, required this.onDeleteThread});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Messages> messages = [];
  List<MessagesUsers> users = [];
  List<Reaction> reactionList = [];
  List<int> messageIds = [];
  List<Map<String, dynamic>> userNameForMention = [];

  Messages? selectedMessage;
  Messages? replyMessage;
  Threads? thread;
  CanReplyMsg? canReplyMsg;
  bool isEditMessage = false;

  bool doRefresh = false;
  bool sendingMessage = false;
  bool isLastPage = false;
  bool showPaginationLoader = false;
  bool isError = false;
  String errorText = '';

  ScrollController _controller = ScrollController();

  String? wallpaper;
  File? wallpaperFile;

  @override
  void initState() {
    super.initState();
    addReactionList();
    init();

    _controller.addListener(() {
      /// pagination
      if (_controller.position.pixels == _controller.position.minScrollExtent) {
        if (!isLastPage) loadMore();
      }
    });

    LiveStream().on(ThreadMessageReceived, (p0) {
      int messageId = LiveStream().getValue(ThreadMessageReceived).toString().toInt();

      addMessage(messageId: messageId);
    });

    LiveStream().on(FastMessage, (p0) {
      FastMessageModel message = FastMessageModel.fromJson(jsonDecode(LiveStream().getValue(FastMessage).toString()));

      addMessage(fastMessage: message);
    });

    LiveStream().on(AbortFastMessage, (p0) {
      AbortMessageModel message = AbortMessageModel.fromJson(jsonDecode(LiveStream().getValue(AbortFastMessage).toString()));

      removeMessage(tmpId: message.messageId);
    });

    LiveStream().on(ThreadStatusChanged, (p0) {
      Threads object = LiveStream().getValue(ThreadStatusChanged) as Threads;

      if (object.participantsCount != thread!.participantsCount) {
        getThread();
      } else if (object.subject != thread!.subject) {
        thread!.subject = object.subject;
        setState(() {});
      } else if (object.meta!.allowInvite != thread!.meta!.allowInvite) {
        thread!.meta!.allowInvite = object.meta!.allowInvite;
        setState(() {});
      }
    });

    LiveStream().on(MetaChanged, (p0) {
      StreamMessage object = LiveStream().getValue(MetaChanged) as StreamMessage;

      messages.forEach((element) {
        if (element.messageId == object.messageId) {
          element.meta = object.meta;
          setState(() {});
        }
      });
    });

    LiveStream().on(DeleteMessage, (p0) {
      int? index;

      int object = LiveStream().getValue(DeleteMessage).toString().toInt();
      if (messages.isNotEmpty) {
        if (messages.any((element) => element.messageId == object)) {
          index = messages.indexWhere((element) => element.messageId == object);
        }
      }

      if (index != null) {
        messages.removeAt(index.validate());
        setState(() {});
      }
    });
  }

  void init() async {
    await getThread().then((value) {
      if (widget.thread != null) {
        thread = widget.thread!;
      }
    });
    messageStore.setRefreshChat(true);
    refreshThread();
  }

  Future<void> getThread({bool showLoader = true}) async {
    if (showLoader) {
      appStore.setLoading(true);
    }

    isError = false;

    await getSpecificThread(threadId: widget.threadId).then((value) async {
      messages.clear();
      messages = value.messages.validate().reversed.validate();
      thread = value.threads.validate().first;
      widget.user = value.users!.firstWhere((element) => element.userId == thread!.participants!.first);
      users = value.users.validate();
      getMentionsMembers();
      addMessageIds();
      if (thread!.permissions!.canReplyMsg.toString() != '[]' && thread!.permissions!.canReplyMsg != null) {
        canReplyMsg = CanReplyMsg.fromJson(thread!.permissions!.canReplyMsg);
      } else {
        canReplyMsg = null;
      }

      if (thread!.chatBackground != null && thread!.chatBackground!.url.validate().isNotEmpty) {
        wallpaper = thread!.chatBackground!.url.validate();
      } else if (messageStore.globalChatBackground.isNotEmpty) {
        wallpaper = messageStore.globalChatBackground;
      } else {
        wallpaper = null;
      }

      setState(() {});
      appStore.setLoading(false);
      await 1.seconds.delay;
      _scrollDown();
    }).catchError((e) {
      isError = true;
      errorText = e.toString();
      setState(() {});
      appStore.setLoading(false);
      log('Error: ${e.toString()}');
    });
  }

  Future<void> refreshThread() async {
    if (appStore.isWebsocketEnable != 1 && messageStore.refreshChat) {
      Future.delayed(Duration(seconds: 15), () {
        getThread(showLoader: false);
        refreshThread();
      });
    }
  }

  Future<void> addMessage({int? messageId, FastMessageModel? fastMessage}) async {
    if (fastMessage != null) {
      sendingMessage = false;
      setState(() {});

      messages.add(
        Messages(
          tmpId: fastMessage.tempId,
          threadId: fastMessage.threadId,
          dateSent: fastMessage.time.validate(),
          message: fastMessage.message,
          senderId: fastMessage.senderId,
        ),
      );
      setState(() {});

      _scrollDown();
    } else {
      await getMessage(messageId: messageId.validate()).then((value) async {
        if (messages.any((element) => element.messageId == messageId)) {
          messages[messages.indexWhere((element) => element.messageId == messageId)] = value;
          sendingMessage = false;

          setState(() {});
        } else if (messages.any((element) => element.tmpId == value.tmpId) && value.tmpId.validate().isNotEmpty) {
          messages[messages.indexWhere((element) => element.messageId == messageId)] = value;
          sendingMessage = false;

          setState(() {});

          _scrollDown();
        } else {
          sendingMessage = false;
          messages.add(value);
          setState(() {});

          _scrollDown();
        }
      }).catchError((e) {
        log('Error: ${e.toString()}');
      });
    }

    setState(() {});
  }

  void removeMessage({String? tmpId}) {
    messages.removeWhere((element) => element.tmpId == tmpId);
    setState(() {});
  }

  void _scrollDown() {
    if (_controller.hasClients) {
      final position = _controller.position.maxScrollExtent;
      _controller.jumpTo(position);
    }
  }

  Future<void> addReactionList() async {
    for (int i = 0; i <= emojiList.length - 1; i++) {
      reactionList.add(Reaction(icon: Text(emojiList[i].skins.validate().first.native.validate(), style: TextStyle(fontSize: 20)), emojiId: emojiList[i].skins.validate().first.unified.validate()));
    }
    setState(() {});
  }

  void addMessageIds() {
    messages.forEach((element) {
      if (!messageIds.contains(element.messageId.validate())) {
        messageIds.add(element.messageId.validate());
      }
    });
  }

  Future<void> getMentionsMembers({String? mentionText}) async {
    users.validate().forEach((element) {
      userNameForMention.add({"id": element.id, "full_name": element.name, "display": element.name, "photo": element.avatar});
    });
    setState(() {});
  }

  Future<void> loadMore() async {
    showPaginationLoader = true;
    setState(() {});
    await loadMoreMessages(threadId: thread!.threadId.validate(), messageIds: messageIds).then((value) {
      List<Messages> temp = value.messages!.sublist(1);
      if (temp.isEmpty) {
        isLastPage = true;
      } else {
        messages.insertAll(0, temp.reversed.validate());
        addMessageIds();
      }
      showPaginationLoader = false;
      setState(() {});
    }).catchError((e) {
      showPaginationLoader = false;
      setState(() {});
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(ThreadMessageReceived);
    LiveStream().dispose(ThreadStatusChanged);
    LiveStream().dispose(MetaChanged);
    LiveStream().dispose(FastMessage);
    LiveStream().dispose(AbortFastMessage);

    if (appStore.isLoading) appStore.setLoading(false);
    messageStore.setRefreshChat(false);

    threadOpened = null;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        finish(context, doRefresh ? true : null);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.scaffoldBackgroundColor,
          leadingWidth: 24,
          actions: [
            if (selectedMessage != null)
              Row(
                children: [
                  if (thread!.permissions!.canReply.validate() && selectedMessage!.senderId.toString() != appStore.loginUserId)
                    InkWell(
                      onTap: () {
                        replyMessage = selectedMessage;
                        selectedMessage = null;
                        setState(() {});
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Icon(Icons.reply, size: 20, color: context.iconColor),
                    ).paddingSymmetric(horizontal: 6),
                  if (thread!.permissions!.canFavorite.validate())
                    InkWell(
                      onTap: () {
                        if (selectedMessage!.favorited == 0) {
                          selectedMessage!.favorited = 1;
                          starMessage(threadId: widget.threadId, messageId: selectedMessage!.messageId.validate(), type: FavouriteType.star);
                        } else {
                          selectedMessage!.favorited = 0;
                          starMessage(threadId: widget.threadId, messageId: selectedMessage!.messageId.validate(), type: FavouriteType.unStar);
                        }
                        selectedMessage = null;
                        setState(() {});
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: cachedImage(
                        selectedMessage!.favorited == 0 ? ic_star_filled : ic_unstar,
                        color: context.iconColor,
                        height: 20,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
                    ).paddingSymmetric(horizontal: 6),
                  InkWell(
                    onTap: () {
                      toast(language.copiedToClipboard);
                      Clipboard.setData(new ClipboardData(text: selectedMessage!.message.validate()));
                      selectedMessage = null;
                      setState(() {});
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Icon(Icons.copy, size: 20, color: context.iconColor),
                  ).paddingSymmetric(horizontal: 6),
                  if (thread!.permissions!.canEditOwnMessages.validate() && selectedMessage!.senderId.toString() == appStore.loginUserId)
                    InkWell(
                      onTap: () {
                        replyMessage = selectedMessage;
                        isEditMessage = true;
                        selectedMessage = null;
                        setState(() {});
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Icon(Icons.edit, size: 20, color: context.iconColor),
                    ).paddingSymmetric(horizontal: 6),
                  if (thread!.permissions!.canDeleteAllMessages.validate() || (thread!.permissions!.canDeleteOwnMessages.validate() && selectedMessage!.senderId.toString() == appStore.loginUserId))
                    InkWell(
                      onTap: () {
                        messages.removeWhere((element) => element == selectedMessage);

                        if (appStore.isWebsocketEnable != 1) {
                          messages.removeWhere((element) => element.messageId == selectedMessage!.messageId.validate());
                          setState(() {});
                        }

                        deleteMessage(messageId: selectedMessage!.messageId.validate(), threadId: widget.threadId.validate()).then((value) {
                          //
                        });
                        selectedMessage = null;
                        setState(() {});
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Icon(Icons.delete, size: 20, color: context.iconColor),
                    ).paddingSymmetric(horizontal: 8),
                ],
              )
            else
              ChatScreenPopUpMenuComponent(
                thread: thread,
                threadId: widget.threadId,
                user: widget.user,
                users: users,
                doRefresh: doRefresh,
                wallpaper: wallpaper,
                callback: (p0) async {
                  switch (p0) {
                    case ChatScreenPopUpMenuComponentCallbacks.MuteOrUnMute:
                      widget.callback?.call();
                      break;
                    case ChatScreenPopUpMenuComponentCallbacks.GetThread:
                      doRefresh = true;
                      getThread();
                      break;
                    case ChatScreenPopUpMenuComponentCallbacks.SetState:
                      setState(() {});
                      break;
                    case ChatScreenPopUpMenuComponentCallbacks.DeleteThread:
                      widget.onDeleteThread.call();

                      break;
                  }
                },
                sendFile: (file) {
                  wallpaperFile = file;

                  if (file == null) {
                    if (messageStore.globalChatBackground.isNotEmpty) {
                      wallpaper = messageStore.globalChatBackground;
                    } else {
                      wallpaper = null;
                    }
                  }
                  setState(() {});
                },
              ),
          ],
          title: ChatScreenTitleComponent(users: users, thread: thread, user: widget.user),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.iconColor),
            onPressed: () {
              finish(context, doRefresh ? true : null);
            },
          ),
        ),
        body: SizedBox(
          height: context.height(),
          child: Stack(
            children: [
              if (wallpaperFile != null)
                Image.file(
                  File(wallpaperFile!.path.validate()),
                  height: context.height(),
                  width: context.width(),
                  fit: BoxFit.cover,
                )
              else if (wallpaper != null && wallpaper.validate().isNotEmpty)
                cachedImage(
                  wallpaper,
                  height: context.height(),
                  width: context.width(),
                  fit: BoxFit.cover,
                ),
              if (messages.isNotEmpty)
                SizedBox(
                  height: context.height() * 0.8,
                  child: ListView.builder(
                    controller: _controller,
                    padding: EdgeInsets.only(top: 16, bottom: selectedMessage != null || isEditMessage ? 120 : 80),
                    itemCount: messages.validate().length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Messages message = messages.validate()[index];
                      MessageMeta? meta;
                      bool isLoggedInUser = message.senderId.toString() == appStore.loginUserId;
                      Messages? repliedMessage;
                      MessagesUsers? repliedUser;

                      String lastDate = index != 0 ? getChatDate(date: messages.validate()[index - 1].dateSent.validate()) : "";
                      String date = getChatDate(date: message.dateSent.validate());

                      String reactionIcon = "";
                      String emoji = "";

                      if (message.meta.toString() != '[]' && message.meta != null) {
                        meta = MessageMeta.fromJson(message.meta);
                        if (meta.reactions != null && meta.reactions.validate().isNotEmpty) {
                          if (thread!.type == 'group' || thread!.participantsCount.validate() > 2) {
                            meta.reactions.validate().forEach((element) {
                              if (element.users.validate().contains(appStore.loginUserId.toInt())) {
                                int index = meta!.reactions.validate().indexWhere((e) => e.users.validate().contains(appStore.loginUserId.toInt()));

                                reactionList.validate().forEach(
                                  (element) {
                                    if (element.emojiId.validate() == meta!.reactions.validate()[index].reaction.validate()) {
                                      int iconIndex = emojiList.indexWhere((e) => e.skins.validate().first.unified.validate() == element.emojiId.validate());
                                      reactionIcon = emojiList[iconIndex].skins.validate().first.native.validate();
                                      emoji = element.emojiId.validate();
                                    }
                                  },
                                );
                              }
                            });
                          } else {
                            reactionList.validate().forEach(
                              (element) {
                                if (element.emojiId.validate() == meta!.reactions.validate().first.reaction.validate()) {
                                  int iconIndex = emojiList.indexWhere((e) => e.skins.validate().first.unified.validate() == element.emojiId.validate());
                                  reactionIcon = emojiList[iconIndex].skins.validate().first.native.validate();
                                  emoji = element.emojiId.validate();
                                }
                              },
                            );
                          }
                        }

                        if (meta.replyTo != null) {
                          messages.forEach((element) {
                            if (element.messageId == meta!.replyTo.validate()) {
                              repliedMessage = element;
                              repliedUser = users.firstWhere((e) => e.userId == element.senderId);
                            }
                          });
                        }
                      }

                      if (thread != null)
                        return Column(
                          children: [
                            if (index == 0 && showPaginationLoader) ThreeBounceLoadingWidget(),
                            ChatScreenMessagesComponent(
                              participantCount: thread!.participantsCount.validate(),
                              isDateVisible: date != lastDate,
                              repliedUser: repliedUser,
                              repliedMessage: repliedMessage,
                              user: widget.user,
                              selectedMessage: selectedMessage,
                              date: date,
                              isLoggedInUser: isLoggedInUser,
                              message: message,
                              meta: meta,
                              time: message.lastUpdate.validate() == 0 ? timeOfMessage(message.dateSent.validate()) : timeStampToDateMessage(message.lastUpdate.validate()),
                              threadType: thread!.type,
                              reactionList: reactionList,
                              emojiId: emoji,
                              reactionIcon: reactionIcon,
                              callback: (value, String? emoji, int? messageId, bool? isReactionRemoved) async {
                                switch (value) {
                                  case ChatScreenMessagesComponentCallbacks.onTap:
                                    if (selectedMessage != null) {
                                      selectedMessage = null;
                                      setState(() {});
                                    }
                                    break;
                                  case ChatScreenMessagesComponentCallbacks.onLongPress:
                                    selectedMessage = message;
                                    setState(() {});
                                    break;
                                  case ChatScreenMessagesComponentCallbacks.saveReaction:
                                    sendingMessage = true;
                                    setState(() {});

                                    if (selectedMessage != null) {
                                      selectedMessage = null;
                                      setState(() {});
                                    }
                                    await saveReaction(messageId: messageId.validate(), emoji: emoji.validate()).then((value) async {
                                      value.messages.validate().forEach((element) {
                                        if (element.messageId == message.messageId) {
                                          message.meta = element.meta;
                                        }
                                      });
                                      sendingMessage = false;
                                      setState(() {});
                                    }).catchError((e) {
                                      toast(e.toString());
                                      appStore.setLoading(false);
                                    });
                                    break;
                                  case ChatScreenMessagesComponentCallbacks.openReactionBottomSheet:
                                    if (message.meta != '[]')
                                      showModalBottomSheet(
                                        elevation: 0,
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.6,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 45,
                                                  height: 5,
                                                  //clipBehavior: Clip.hardEdge,
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
                                                ),
                                                8.height,
                                                Container(
                                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                                  decoration: BoxDecoration(
                                                    color: context.cardColor,
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                                  ),
                                                  child: ReactionBottomSheet(users: users, meta: meta),
                                                ).expand(),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    break;
                                }
                              },
                            ),
                            if (index == messages.length - 1 && sendingMessage) ThreeBounceLoadingWidget()
                          ],
                        );
                      else
                        return Offstage();
                    },
                  ),
                )
              else if (messages.isEmpty && !appStore.isLoading && !isError)
                SizedBox(width: context.width(), child: NoMessageComponent().paddingSymmetric(horizontal: 16))
              else if (isError && !appStore.isLoading)
                SizedBox(width: context.width(), child: NoMessageComponent(errorText: errorText).paddingSymmetric(horizontal: 16)),
              if (canReplyMsg != null && canReplyMsg!.userBlockedMessages != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: context.width(),
                    decoration: BoxDecoration(color: context.cardColor, border: Border(top: BorderSide(color: context.dividerColor))),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text(
                      canReplyMsg!.userBlockedMessages.validate().isNotEmpty ? canReplyMsg!.userBlockedMessages.validate() : '',
                      style: secondaryTextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else if (widget.user != null && widget.user!.blocked != null && widget.user!.blocked != 0)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: context.width(),
                    decoration: BoxDecoration(color: context.cardColor, border: Border(top: BorderSide(color: context.dividerColor))),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Text(
                      language.youCanTSendMessage,
                      style: secondaryTextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Positioned(
                  bottom: context.navigationBarHeight,
                  child: WriteMessageComponent(
                    threadSecretKey: thread != null ? thread!.secretKey.validate() : "",
                    users: userNameForMention,
                    threadId: widget.threadId,
                    replyMessage: replyMessage,
                    isEditMessage: isEditMessage,
                    canUpload: thread != null
                        ? thread!.permissions!.canUpload.runtimeType == int
                            ? thread!.permissions!.canUpload == 1
                                ? true
                                : false
                            : thread!.permissions!.canUpload
                        : false,
                    callback: (p0) {
                      switch (p0) {
                        case WriteMessageCallbacks.ClearReplyMessage:
                          replyMessage = null;
                          setState(() {});
                          break;

                        case WriteMessageCallbacks.GetThread:
                          doRefresh = true;
                          getThread();
                          break;
                        case WriteMessageCallbacks.SendingMessage:
                          sendingMessage = true;
                          setState(() {});
                          break;
                        case WriteMessageCallbacks.SendingMessageRejected:
                          getThread();
                          sendingMessage = false;
                          setState(() {});
                          break;
                      }
                    },
                    onAddMessage: (value) {
                      if (messages.any((element) => element.messageId == value.messageId)) {
                        messages[messages.indexWhere((element) => element.messageId == value.messageId)] = value;
                        sendingMessage = false;

                        setState(() {});
                      } else if (messages.any((element) => element.tmpId == value.tmpId)) {
                        messages[messages.indexWhere((element) => element.tmpId == value.tmpId)] = value;
                        sendingMessage = false;

                        setState(() {});
                      } else {
                        sendingMessage = false;
                        messages.add(value);
                        setState(() {});

                        _scrollDown();
                      }
                    },
                  ),
                ),
              Observer(builder: (_) => LoadingWidget().visible(appStore.isLoading))
            ],
          ),
        ),
      ),
    );
  }
}
