import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/messages/unread_threads.dart';

import '../../../../models/messages/message_users.dart';
import '../../../../models/messages/threads_model.dart';
import '../../../../utils/common.dart';
import '../../../../utils/constants.dart';
import 'chat_screen_profile_image_component.dart';

// ignore: must_be_immutable
class ChatScreenTitleComponent extends StatefulWidget {
  final Threads? thread;
  final MessagesUsers? user;
  List<MessagesUsers> users = [];

  ChatScreenTitleComponent({Key? key, this.thread, this.user, required this.users}) : super(key: key);

  @override
  State<ChatScreenTitleComponent> createState() => _ChatScreenTitleComponentState();
}

class _ChatScreenTitleComponentState extends State<ChatScreenTitleComponent> {
  @override
  void initState() {
    super.initState();
  }

  String appbarTitle() {
    if (widget.thread!.participantsCount.validate() > 2) {
      if (widget.thread!.subject.validate().isNotEmpty)
        return widget.thread!.subject.validate();
      else
        return '${widget.thread!.participantsCount} ${language.participants}';
    } else if (widget.thread!.type == ThreadType.group) {
      if (widget.thread!.subject.validate().isNotEmpty)
        return widget.thread!.subject.validate();
      else
        return '${widget.thread!.participantsCount} ${language.participants}';
    } else {
      return widget.user!.name.validate();
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.thread != null
        ? Row(
            children: [
              ChatScreenProfileImageComponent(
                users: widget.users,
                user: widget.user,
                thread: widget.thread,
                imageSize: 34,
                imageSizeWhenParticipant: 24,
                imageSpacing: 10,
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appbarTitle(), style: boldTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Observer(builder: (_) {
                    if (messageStore.typingList.isNotEmpty) {
                      if (messageStore.typingList.any((element) => element.threadId == widget.thread!.threadId)) {
                        if (widget.thread!.type == ThreadType.group || widget.thread!.participantsCount.validate() > 2) {
                          List<UnreadThreadModel> typingList = messageStore.typingList.where((element) => element.threadId == widget.thread!.threadId).toList();

                          List<String> names = [];

                          typingList.forEach((element) {
                            element.typingIds!.forEach((id) {
                              names.add(widget.users.firstWhere((element) => element.id == id).name.validate().split(" ").first);
                            });
                          });

                          return Text(
                            '${names.toString().replaceAll('[', '').replaceAll(']', '')} ${language.typing}',
                            style: secondaryTextStyle(size: 12),
                          );
                        } else {
                          return Text(
                            ' ${language.typing}',
                            style: secondaryTextStyle(size: 12),
                          );
                        }
                      } else if (messageStore.onlineUsers.isNotEmpty) {
                        int similarElementsCount = widget.thread!.participants.validate().where((element) => messageStore.onlineUsers.contains(element)).toList().length;

                        if (similarElementsCount != 0) {
                          if (widget.thread!.type == ThreadType.group || widget.thread!.participantsCount.validate() > 2) {
                            return Text(
                              '${widget.thread!.participantsCount.toString()} ${language.participants} ($similarElementsCount ${language.online})',
                              style: secondaryTextStyle(size: 12),
                            );
                          } else {
                            return Text(language.online, style: secondaryTextStyle(size: 12, color: Colors.white));
                          }
                        }

                        return Text(
                          widget.thread!.type == ThreadType.group || widget.thread!.participantsCount.validate() > 2
                              ? '${widget.thread!.participantsCount.toString()} ${language.participants}'
                              : convertToAgo(widget.user!.lastActive.validate()),
                          style: secondaryTextStyle(size: 12),
                        );
                      } else {
                        return Text(
                          widget.thread!.type == ThreadType.group || widget.thread!.participantsCount.validate() > 2
                              ? '${widget.thread!.participantsCount.toString()} ${language.participants}'
                              : convertToAgo(widget.user!.lastActive.validate()),
                          style: secondaryTextStyle(size: 12),
                        );
                      }
                    } else if (messageStore.onlineUsers.isNotEmpty) {
                      int similarElementsCount = widget.thread!.participants.validate().where((element) => messageStore.onlineUsers.contains(element)).toList().length;

                      if (similarElementsCount != 0) {
                        if (widget.thread!.type == ThreadType.group || widget.thread!.participantsCount.validate() > 2) {
                          return Text(
                            '${widget.thread!.participantsCount.toString()} ${language.participants} ($similarElementsCount  ${language.online})',
                            style: secondaryTextStyle(size: 12),
                          );
                        } else {
                          return Text(
                            messageStore.onlineUsers.contains(widget.user!.id.validate().toInt()) ? ' ${language.online}' : convertToAgo(widget.user!.lastActive.validate()),
                            style: secondaryTextStyle(size: 12),
                          );
                        }
                      }

                      return Text(
                        widget.thread!.type == ThreadType.group || widget.thread!.participantsCount.validate() > 2
                            ? '${widget.thread!.participantsCount.toString()} ${language.participants}'
                            : convertToAgo(widget.user!.lastActive.validate()),
                        style: secondaryTextStyle(size: 12),
                      );
                    } else {
                      return Text(
                        widget.thread!.type == ThreadType.group || widget.thread!.participantsCount.validate() > 2
                            ? '${widget.thread!.participantsCount.toString()} ${language.participants}'
                            : convertToAgo(widget.user!.lastActive.validate()),
                        style: secondaryTextStyle(size: 12),
                      );
                    }
                  }),
                ],
              ).expand(),
            ],
          )
        : Offstage();
  }
}
