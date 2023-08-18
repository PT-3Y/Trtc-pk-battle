import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/messages/message_users.dart';
import 'package:socialv/models/messages/messages_model.dart';
import 'package:socialv/models/messages/threads_model.dart';
import 'package:socialv/network/messages_repository.dart';
import 'package:socialv/screens/messages/functions.dart';
import 'package:socialv/screens/messages/screens/chat_screen.dart';
import 'package:socialv/screens/messages/screens/message_screen.dart';

import '../../../utils/app_constants.dart';
import 'chat_screen_components/chat_screen_profile_image_component.dart';

int? threadOpened;

class RecentMessageComponent extends StatelessWidget {
  final Threads thread;
  final MessagesUsers user;
  final Messages message;
  final VoidCallback callback;
  final VoidCallback refreshThread;
  final VoidCallback onDeleteConvo;
  final VoidCallback? doRefresh;
  final List<MessagesUsers>? participantUsers;

  const RecentMessageComponent({
    required this.thread,
    required this.user,
    required this.message,
    required this.callback,
    this.participantUsers,
    required this.refreshThread,
    required this.onDeleteConvo,
    this.doRefresh,
  });

  String messagesTitle() {
    if (thread.participantsCount.validate() > 2) {
      if (thread.subject.validate().isNotEmpty)
        return thread.subject.validate();
      else
        return '${thread.participantsCount} ${language.participants}';
    } else if (thread.type == ThreadType.group) {
      if (thread.subject.validate().isNotEmpty)
        return thread.subject.validate();
      else
        return '${thread.participantsCount} ${language.participants}';
    } else {
      return user.name.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            if (messageStore.unreadThreads.any((element) => element.threadId == thread.threadId.validate())) {
              messageStore.removeUnReads(messageStore.unreadThreads.firstWhere((element) => element.threadId == thread.threadId.validate()));
            }

            String message = '42["${SocketEvents.threadOpen}",${thread.threadId.validate()}]';
            String messageOne = '421["${SocketEvents.v3GetStatuses}",[${thread.threadId.validate()}]]';

            log('Send Message = $message');
            log('Send Message = $messageOne');
            channel?.sink.add(message);
            channel?.sink.add(messageOne);

            threadOpened = thread.threadId.validate();

            messageStore.setRefreshRecentMessages(false);

            ChatScreen(
              onDeleteThread: () {
                finish(context);

                onDeleteConvo.call();
              },
              threadId: thread.threadId.validate(),
              user: user,
              thread: thread,
              callback: () {
                refreshThread.call();
              },
            ).launch(context).then((value) {
              if (value ?? false) {
                refreshThread.call();
              }
              doRefresh?.call();
            });
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ChatScreenProfileImageComponent(
                      users: participantUsers.validate(),
                      imageSizeWhenParticipant: 42,
                      imageSize: 48,
                      user: user,
                      thread: thread,
                      imageSpacing: 12,
                    ),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: messagesTitle(), style: boldTextStyle(fontFamily: fontFamily)),
                              if (thread.type == ThreadType.group && user.verified.validate() == 1)
                                WidgetSpan(
                                  child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover),
                                ),
                              if (thread.isPinned.validate() == 1)
                                WidgetSpan(
                                  child: Image.asset(ic_pin, height: 14, width: 14, color: context.iconColor, fit: BoxFit.cover).paddingOnly(bottom: 4, left: 4, right: 2),
                                ),
                              if (thread.permissions!.isMuted.validate())
                                WidgetSpan(
                                  child: Image.asset(ic_volume_mute, height: 12, width: 12, color: context.iconColor, fit: BoxFit.cover).paddingOnly(bottom: 4, left: 2),
                                ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Observer(builder: (ctx) {
                          if (messageStore.typingList.any((element) => element.threadId == thread.threadId)) {
                            return Text('${language.typing}', style: secondaryTextStyle(size: 12));
                          } else {
                            return SizedBox(
                              width: context.width() * 0.36,
                              child: Text(
                                message.message.validate() == MessageText.onlyFiles
                                    ? language.attachments.capitalizeFirstLetter()
                                    : user.blocked == 0 || user.blocked == null
                                        ? message.message.validate().contains('href')
                                            ? language.link
                                            : parseHtmlString(message.message.validate())
                                        : language.messageHidden,
                                style: secondaryTextStyle(size: 12),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                  ],
                ),
                Text(
                  message.lastUpdate.validate() == 0 ? timeOfMessage(message.dateSent.validate()) : timeStampToDateMessage(message.lastUpdate.validate()),
                  style: secondaryTextStyle(),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Theme(
            data: Theme.of(context).copyWith(useMaterial3: false),
            child: PopupMenuButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonRadius)),
              onSelected: (val) async {
                if (val == 1) {
                  if (thread.isPinned == 1) {
                    thread.isPinned = 0;
                    await unPinThread(threadId: thread.threadId.validate()).then((value) {}).catchError(onError);
                  } else {
                    thread.isPinned = 1;
                    await pinThread(threadId: thread.threadId.validate()).then((value) {}).catchError(onError);
                  }
                  refreshThread.call();
                } else if (val == 2) {
                  thread.permissions!.isMuted = !thread.permissions!.isMuted.validate();
                  callback.call();
                  if (thread.permissions!.isMuted.validate()) {
                    await unMuteThread(threadId: thread.threadId.validate()).then((value) {}).catchError(onError);
                  } else {
                    await muteThread(threadId: thread.threadId.validate()).then((value) {}).catchError(onError);
                  }
                } else {
                  showConfirmDialogCustom(
                    context,
                    onAccept: (c) {
                      ifNotTester(() async {
                        onDeleteConvo.call();

                        await deleteThread(threadId: thread.threadId.validate()).then((value) {
                          onDeleteConvo.call();
                        }).catchError(onError);
                      });
                    },
                    dialogType: DialogType.CONFIRMATION,
                    title: language.deleteChatConfirmation,
                    positiveText: language.delete,
                  );
                }
              },
              icon: Icon(Icons.more_horiz),
              itemBuilder: (context) => <PopupMenuEntry>[
                PopupMenuItem(
                  value: 1,
                  child: TextIcon(
                    text: thread.isPinned == 1 ? language.unpin : language.pinToTop,
                    textStyle: secondaryTextStyle(),
                  ),
                ),
                if (thread.permissions!.canMuteThread.validate())
                  PopupMenuItem(
                    value: 2,
                    child: TextIcon(
                      text: thread.permissions!.isMuted.validate() ? language.unMuteConversation : language.muteConversation,
                      textStyle: secondaryTextStyle(),
                    ),
                  ),
                if (thread.permissions!.deleteAllowed.validate())
                  PopupMenuItem(
                    value: 3,
                    child: TextIcon(
                      text: language.deleteConversation,
                      textStyle: secondaryTextStyle(),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Observer(
          builder: (ctx) {
            if (messageStore.unreadThreads.any((element) => element.threadId == thread.threadId)) {
              int unreadCount = messageStore.unreadThreads.firstWhere((element) => element.threadId == thread.threadId).unreadCount.validate();

              return Positioned(
                top: 14,
                left: 6,
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                  child: FittedBox(child: Text(unreadCount.toString(), style: secondaryTextStyle(color: Colors.white))),
                ),
              );
            } else {
              return Offstage();
            }
          },
        ),
      ],
    );
  }
}
