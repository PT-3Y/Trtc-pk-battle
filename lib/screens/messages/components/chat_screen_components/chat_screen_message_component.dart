import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/messages/functions.dart';
import 'package:socialv/screens/messages/screens/message_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/html_widget.dart';

import '../../../../models/messages/message_users.dart';
import '../../../../models/messages/messages_model.dart';
import '../../../../utils/cached_network_image.dart';
import '../../../../utils/sv_reactions/sv_reaction.dart';
import '../../../../utils/sv_reactions/sv_reation_button.dart';
import '../message_media_component.dart';
import 'chat_screen_replied_messages_component.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

enum ChatScreenMessagesComponentCallbacks { onTap, onLongPress, saveReaction, openReactionBottomSheet }

// ignore: must_be_immutable
class ChatScreenMessagesComponent extends StatefulWidget {
  final bool? isDateVisible;
  final String? date;
  final bool? isLoggedInUser;
  Messages? selectedMessage;
  Messages? message;
  final MessageMeta? meta;
  final Messages? repliedMessage;
  final MessagesUsers? repliedUser;
  final MessagesUsers? user;
  final String? time;
  final String? threadType;
  final List<Reaction>? reactionList;
  final String emojiId;
  String? reactionIcon;
  final int participantCount;
  final Function(ChatScreenMessagesComponentCallbacks, String? emoji, int? messageId, bool? isReactionRemoved)? callback;

  ChatScreenMessagesComponent({
    Key? key,
    required this.isDateVisible,
    this.date,
    this.selectedMessage,
    this.message,
    this.isLoggedInUser,
    this.meta,
    this.repliedMessage,
    this.repliedUser,
    this.user,
    this.time,
    this.callback,
    this.threadType,
    this.reactionList,
    required this.emojiId,
    this.reactionIcon,
    required this.participantCount,
  }) : super(key: key);

  @override
  State<ChatScreenMessagesComponent> createState() => _ChatScreenMessagesComponentState();
}

class _ChatScreenMessagesComponentState extends State<ChatScreenMessagesComponent> {
  final parser = EmojiParser();

  String? reactionIcon;

  @override
  void initState() {
    super.initState();
  }

  String getReactionCount() {
    int count = 0;

    if (widget.meta != null && widget.meta!.reactions != null) {
      widget.meta!.reactions.validate().forEach((element) {
        count = count + element.users.validate().length;
      });
    }

    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    String textDate = widget.date == getChatDate(date: DateTime.now().toString()) ? language.today : widget.date.validate();

    return Column(
      children: [
        if (widget.isDateVisible.validate())
          Row(
            children: [
              Divider(indent: 16, height: 32, color: context.dividerColor).expand(),
              Text(textDate.validate(), style: secondaryTextStyle(size: 12)).paddingSymmetric(horizontal: 8),
              Divider(endIndent: 16, height: 32, color: context.dividerColor).expand(),
            ],
          ),
        InkWell(
          onTap: () {
            widget.callback?.call(ChatScreenMessagesComponentCallbacks.onTap, null, null, null);
          },
          onLongPress: () {
            widget.callback?.call(ChatScreenMessagesComponentCallbacks.onLongPress, null, null, null);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: ColoredBox(
            color: widget.selectedMessage != null && widget.message!.messageId == widget.selectedMessage!.messageId ? context.primaryColor.withAlpha(40) : Colors.transparent,
            child: Align(
              alignment: widget.isLoggedInUser.validate() ? Alignment.topRight : Alignment.topLeft,
              child: Column(
                crossAxisAlignment: widget.isLoggedInUser.validate() ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (widget.meta != null && widget.meta!.files.validate().isNotEmpty) MessageMediaComponent(files: widget.meta!.files.validate()).paddingOnly(left: 16, top: 8, right: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.message!.favorited == 1 && widget.isLoggedInUser.validate()) cachedImage(ic_star_filled, color: Colors.amber, width: 20, height: 20, fit: BoxFit.cover),
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            constraints: BoxConstraints(maxWidth: context.width() * 0.65),
                            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                            decoration: BoxDecoration(
                              color: widget.isLoggedInUser.validate() ? context.primaryColor : context.cardColor,
                              borderRadius: radius(commonRadius),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.meta != null && widget.meta!.replyTo != null)
                                  ChatScreenRepliedMessagesComponent(
                                    isLoggedInUser: widget.isLoggedInUser.validate(),
                                    repliedMessage: widget.repliedMessage,
                                    repliedUser: widget.repliedUser,
                                  ),
                                Text(widget.user!.name.validate(), style: boldTextStyle(color: context.primaryColor, size: 14)).visible(!widget.isLoggedInUser.validate()),
                                MessageWidget(
                                  isLoggedInUser: widget.isLoggedInUser.validate(),
                                  messageText: widget.message!.message.validate(),
                                  threadType: widget.threadType.validate(),
                                  notBlocked: widget.user!.blocked == 0 || widget.user!.blocked == null,
                                ),
                                4.height,
                                Text(
                                  widget.time.validate(),
                                  style: secondaryTextStyle(color: widget.isLoggedInUser.validate() ? Colors.white : context.iconColor, size: 10),
                                ),
                                if (widget.meta != null && widget.meta!.reactions != null && widget.threadType == 'group' && widget.participantCount > 2)
                                  Wrap(
                                    children: [
                                      ...widget.meta!.reactions.validate().map((a) {
                                        int iconIndex = emojiList.indexWhere((e) => e.skins.validate().first.unified.validate() == a.reaction.validate());
                                        String x = emojiList[iconIndex].skins.validate().first.native.validate();

                                        return Text(parser.emojify(x), style: TextStyle(fontSize: 16));
                                      }).toList(),
                                      6.width,
                                      Text(getReactionCount(), style: secondaryTextStyle()),
                                    ],
                                  ).paddingTop(4).onTap(() {
                                    widget.callback?.call(ChatScreenMessagesComponentCallbacks.openReactionBottomSheet, null, null, null);
                                  }),
                                if (widget.isLoggedInUser.validate() && widget.reactionIcon.validate().isNotEmpty) Text(parser.emojify(widget.reactionIcon.validate()), style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          ),
                          if (!widget.isLoggedInUser.validate() && (widget.selectedMessage == widget.message || widget.reactionIcon.validate().isNotEmpty))
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                decoration: boxDecorationDefault(color: context.cardColor, shape: BoxShape.circle),
                                padding: EdgeInsets.all(6),
                                child: FlutterReactionButton(
                                  boxColor: context.cardColor,
                                  boxPadding: EdgeInsets.all(6),
                                  boxItemsSpacing: 4,
                                  boxPosition: Position.TOP,
                                  boxAlignment: Alignment.topCenter,
                                  splashColor: Colors.transparent,
                                  initialReaction: Reaction(
                                    icon: widget.reactionIcon.validate().isEmpty
                                        ? cachedImage(ic_like, height: 18, width: 18, color: context.iconColor).paddingAll(4)
                                        : Text(parser.emojify(widget.reactionIcon.validate()), style: TextStyle(fontSize: 18)),
                                  ),
                                  reactions: widget.reactionList.validate(),
                                  callback: () {
                                    widget.reactionIcon = "";
                                    setState(() {});
                                    if (widget.selectedMessage != widget.message) {
                                      widget.callback?.call(ChatScreenMessagesComponentCallbacks.saveReaction, widget.emojiId, widget.message!.messageId, true);
                                    }
                                  },
                                  onReactionChanged: (reaction, index) {
                                    widget.callback?.call(ChatScreenMessagesComponentCallbacks.saveReaction, reaction.emojiId.validate(), widget.message!.messageId, false);
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (widget.message!.favorited == 1 && !widget.isLoggedInUser.validate()) cachedImage(ic_star_filled, color: Colors.amber, width: 20, height: 20, fit: BoxFit.cover),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String messageText;
  final String threadType;
  final bool isLoggedInUser;
  final bool notBlocked; //user!.blocked == 0

  const MessageWidget({required this.messageText, required this.threadType, required this.isLoggedInUser, required this.notBlocked});

  @override
  Widget build(BuildContext context) {
    if (messageText.validate() != MessageText.onlyFiles) {
      if (threadType != 'group') {
        if (notBlocked || isLoggedInUser.validate()) {
          if (messageText.contains('href')) {
            return HtmlWidget(postContent: messageText.validate(), color: isLoggedInUser.validate() ? Colors.white : context.iconColor);
          } else {
            return Text(
              parseHtmlString(messageText.validate()),
              style: secondaryTextStyle(color: isLoggedInUser.validate() ? Colors.white : context.iconColor),
            );
          }
        } else {
          return Text(
            language.messageHidden,
            style: secondaryTextStyle(color: isLoggedInUser.validate() ? Colors.white : context.iconColor),
          );
        }
      } else {
        if (messageText.contains('href')) {
          return HtmlWidget(postContent: messageText.validate(), color: isLoggedInUser.validate() ? Colors.white : context.iconColor);
        } else {
          return Text(
            parseHtmlString(messageText.validate()),
            style: secondaryTextStyle(color: isLoggedInUser.validate() ? Colors.white : context.iconColor),
          );
        }
      }
    } else {
      return Offstage();
    }
  }
}
