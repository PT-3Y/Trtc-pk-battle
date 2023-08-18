import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/file_picker_dialog_component.dart';
import 'package:socialv/models/messages/mentions_model.dart';
import 'package:socialv/screens/messages/functions.dart';
import 'package:socialv/screens/messages/screens/message_media_screen.dart';
import 'package:socialv/screens/messages/screens/message_screen.dart';
import 'package:socialv/utils/app_constants.dart';

import '../../../../main.dart';
import '../../../../models/messages/messages_model.dart';
import '../../../../network/messages_repository.dart';
import '../../../../utils/cached_network_image.dart';

enum WriteMessageCallbacks { ClearReplyMessage, GetThread, SendingMessage, SendingMessageRejected }

// ignore: must_be_immutable
class WriteMessageComponent extends StatefulWidget {
  Messages? replyMessage;
  bool? isEditMessage;
  final bool canUpload;
  final Function(WriteMessageCallbacks)? callback;
  final int threadId;
  final String threadSecretKey;
  final List<Map<String, dynamic>>? users;
  final Function(Messages messageId)? onAddMessage;

  WriteMessageComponent({this.replyMessage, this.isEditMessage, this.callback, required this.threadId, this.users, required this.canUpload, required this.threadSecretKey, this.onAddMessage});

  @override
  State<WriteMessageComponent> createState() => _WriteMessageComponentState();
}

class _WriteMessageComponentState extends State<WriteMessageComponent> {
  GlobalKey<FlutterMentionsState> messageContentKey = GlobalKey<FlutterMentionsState>();
  bool showReply = false;
  String? appendedText;
  String? tempText;

  @override
  void initState() {
    super.initState();

    LiveStream().on(SendMessage, (p0) {
      getAppendedText();

      String tmpId = LiveStream().getValue(SendMessage).toString();

      sendMessage(
        tmpId: tmpId,
        threadId: widget.threadId,
        message: tempText.validate(),
        messageId: widget.replyMessage != null ? widget.replyMessage!.messageId.validate() : null,
      ).then((value) {
        tempText = null;
      }).catchError((error) {
        tempText = null;

        widget.callback?.call(WriteMessageCallbacks.SendingMessageRejected);
      });
    });
  }

  Future<void> pickFiles() async {
    FileTypes? file = await showInDialog(
      context,
      contentPadding: EdgeInsets.symmetric(vertical: 16),
      title: Text(language.chooseAnAction, style: boldTextStyle()),
      builder: (p0) {
        return FilePickerDialog(isSelected: true);
      },
    );

    if (file != null) {
      if (file == FileTypes.CAMERA) {
        await getImageSource(isCamera: true).then((value) {
          appStore.setLoading(false);
          MessageMediaScreen(
            cameraImage: value,
            message: messageContentKey.currentState!.controller!.text,
            threadId: widget.threadId,
            messageId: widget.replyMessage != null ? widget.replyMessage!.messageId : null,
            isEdit: widget.isEditMessage.validate(),
          ).launch(context).then((value) {
            if (value ?? false) {
              if (appStore.isWebsocketEnable != 1) {
                widget.callback?.call(WriteMessageCallbacks.GetThread);
              }
            }
            showReply = false;
            setState(() {});
            if (widget.replyMessage != null) widget.callback?.call(WriteMessageCallbacks.ClearReplyMessage);

            messageContentKey.currentState!.controller!.clear();
          });
        }).catchError((e) {
          appStore.setLoading(false);
        });
      } else {
        await getMultipleImages().then((value) {
          appStore.setLoading(false);

          if (value.isNotEmpty) {
            MessageMediaScreen(
              mediaList: value,
              message: messageContentKey.currentState!.controller!.text,
              threadId: widget.threadId,
              messageId: widget.replyMessage != null ? widget.replyMessage!.messageId : null,
              isEdit: widget.isEditMessage.validate(),
            ).launch(context).then((value) async {
              if (value ?? false) {
                if (appStore.isWebsocketEnable != 1) {
                  widget.callback?.call(WriteMessageCallbacks.GetThread);
                }
              }
              showReply = false;
              if (widget.replyMessage != null) widget.callback?.call(WriteMessageCallbacks.ClearReplyMessage);

              messageContentKey.currentState!.controller!.clear();

              setState(() {});
            });
          }
        }).catchError((e) {
          toast(e.toString());
          appStore.setLoading(false);
        });
      }
    }
  }

  String getAppendedText() {
    String appendedText = messageContentKey.currentState!.controller!.text;

    if (appendedText.contains('@')) {
      widget.users!.forEach((element) {
        FlutterMentionsModel temp = FlutterMentionsModel.fromJson(element);

        if (appendedText.contains('@${temp.display}')) {
          appendedText = appendedText.validate().replaceAll('@${temp.display}', '<span class="bm-mention" data-user-id="${temp.id}">@${temp.display}</span>');
        }
      });
    }

    log('appendedText: $appendedText');
    return appendedText;
  }

  @override
  void dispose() {
    LiveStream().dispose(SendMessage);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      color: context.cardColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.replyMessage != null)
            Container(
              decoration: BoxDecoration(color: context.cardColor, border: Border.symmetric(horizontal: BorderSide(color: context.dividerColor))),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.replyMessage = null;
                      showReply = false;
                      setState(() {});
                      widget.callback?.call(WriteMessageCallbacks.ClearReplyMessage);
                    },
                    icon: Icon(Icons.cancel_outlined, color: context.iconColor),
                  ),
                  SizedBox(
                    width: context.width() * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.isEditMessage.validate() ? language.editMessage : language.replyToMessage, style: boldTextStyle(size: 14), overflow: TextOverflow.ellipsis, maxLines: 1),
                        Text(widget.replyMessage!.message.validate(), style: secondaryTextStyle(size: 12), overflow: TextOverflow.ellipsis, maxLines: 1),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          8.width,
          Row(
            children: [
              if (widget.canUpload)
                IconButton(
                  icon: cachedImage(ic_hyperlink, height: 24, width: 24, fit: BoxFit.cover, color: context.iconColor),
                  onPressed: () {
                    pickFiles();
                  },
                ),
              FlutterMentions(
                appendSpaceOnAdd: true,
                key: messageContentKey,
                suggestionPosition: SuggestionPosition.Top,
                decoration: inputDecorationFilled(
                  context,
                  fillColor: context.cardColor,
                  hint: language.writeAMessage,
                ),
                onChanged: (text) {
                  String message = '42["${SocketEvents.writing}",${widget.threadId},""]';
                  log('$message');
                  channel?.sink.add(message);
                },
                suggestionListDecoration: BoxDecoration(color: context.cardColor, border: Border.all(color: context.dividerColor)),
                mentions: [
                  Mention(
                    trigger: "@",
                    matchAll: true,
                    data: widget.users.validate(),
                    suggestionBuilder: (data) {
                      return Container(
                        constraints: BoxConstraints(maxHeight: 200),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
                        child: Row(
                          children: [
                            Text('@' + data["display"], style: boldTextStyle(size: 14, color: context.primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
                            TextIcon(
                              text: data["full_name"],
                              textStyle: secondaryTextStyle(),
                              suffix: cachedImage(data["photo"], height: 20, width: 20, fit: BoxFit.cover).cornerRadiusWithClipRRect(4),
                              maxLine: 1,
                              expandedText: true,
                            ).expand(),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ).expand(),
              IconButton(
                onPressed: () {
                  ifNotTester(() async {
                    if (messageContentKey.currentState!.controller!.text.isNotEmpty) {
                      widget.callback?.call(WriteMessageCallbacks.SendingMessage);
                      showReply = false;
                      setState(() {});

                      if (widget.isEditMessage.validate() && widget.replyMessage != null) {
                        editMessage(
                          messageId: widget.replyMessage!.messageId.validate(),
                          message: getAppendedText(),
                          threadId: widget.threadId,
                        ).then((value) {
                          if (appStore.isWebsocketEnable != 1) {
                            Messages message = Messages(
                              threadId: widget.threadId,
                              dateSent: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc()).toString(),
                              message: getAppendedText(),
                              senderId: appStore.loginUserId.validate().toInt(),
                              messageId: widget.replyMessage!.messageId.validate(),
                            );
                            widget.onAddMessage?.call(message);
                          }
                          messageContentKey.currentState!.controller!.clear();
                          widget.callback?.call(WriteMessageCallbacks.ClearReplyMessage);
                        }).catchError((e) {
                          messageContentKey.currentState!.controller!.clear();
                        });
                      } else {
                        if (widget.replyMessage != null) {
                          sendMessage(
                            threadId: widget.threadId,
                            message: getAppendedText(),
                            messageId: widget.replyMessage != null ? widget.replyMessage!.messageId.validate() : null,
                          ).then((value) {
                            if (appStore.isWebsocketEnable != 1) {
                              Messages message = Messages(
                                threadId: widget.threadId,
                                dateSent: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc()).toString(),
                                message: getAppendedText(),
                                senderId: appStore.loginUserId.validate().toInt(),
                                messageId: value.messageId,
                                meta: {"replyTo": widget.replyMessage != null ? widget.replyMessage!.messageId.validate() : null},
                              );
                              widget.onAddMessage?.call(message);
                            }
                            messageContentKey.currentState!.controller!.clear();
                            widget.callback?.call(WriteMessageCallbacks.ClearReplyMessage);
                          }).catchError((error) {
                            widget.callback?.call(WriteMessageCallbacks.SendingMessageRejected);
                          });
                        } else {
                          tempText = getAppendedText();

                          if (appStore.isWebsocketEnable == 1) {
                            String message =
                                '423["${SocketEvents.v3fastMsg}",${widget.threadId},"${messageContentKey.currentState!.controller!.text}",{"user_id":0,"name":"${appStore.loginFullName}","avatar":"${appStore.loginAvatarUrl}"},"${DateTime.now().toUtc()}"]';
                            log('Send Message: $message');
                            messageContentKey.currentState!.controller!.clear();

                            channel?.sink.add(message);
                          } else {
                            if (await isNetworkAvailable()) messageContentKey.currentState!.controller!.clear();
                            String tempId = generateTempId(threadId: widget.threadId);

                            Messages message = Messages(
                              threadId: widget.threadId,
                              dateSent: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc()).toString(),
                              message: tempText.validate(),
                              senderId: appStore.loginUserId.validate().toInt(),
                              tmpId: tempId,
                            );
                            widget.onAddMessage?.call(message);
                            sendMessage(
                              threadId: widget.threadId,
                              message: tempText.validate(),
                              messageId: widget.replyMessage != null ? widget.replyMessage!.messageId.validate() : null,
                            ).then((value) {
                              Messages message = Messages(
                                threadId: widget.threadId,
                                dateSent: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc()).toString(),
                                message: tempText.validate(),
                                senderId: appStore.loginUserId.validate().toInt(),
                                messageId: value.messageId,
                                tmpId: tempId,
                              );
                              widget.onAddMessage?.call(message);
                              tempText = null;
                            }).catchError((error) {
                              toast(error);
                              tempText = null;
                              widget.callback?.call(WriteMessageCallbacks.SendingMessageRejected);
                            });
                          }
                        }
                      }

                      hideKeyboard(context);
                    }
                  });
                },
                icon: cachedImage(ic_send, color: appStore.isDarkMode ? bodyDark : bodyWhite, width: 24, height: 24, fit: BoxFit.cover),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
