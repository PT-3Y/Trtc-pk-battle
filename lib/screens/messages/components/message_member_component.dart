import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/messages/message_users.dart';
import 'package:socialv/network/messages_repository.dart';
import 'package:socialv/screens/messages/components/recent_message_component.dart';
import 'package:socialv/screens/messages/screens/chat_screen.dart';
import 'package:socialv/screens/messages/screens/message_screen.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class MessageMemberComponent extends StatefulWidget {
  final MessagesUsers user;

  const MessageMemberComponent({required this.user});

  @override
  State<MessageMemberComponent> createState() => _MessageMemberComponentState();
}

class _MessageMemberComponentState extends State<MessageMemberComponent> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        appStore.setLoading(true);
        await privateThread(userId: widget.user.userId.validate()).then((value) {
          appStore.setLoading(false);

          String message = '42["${SocketEvents.threadOpen}",${value.threadId.validate()}]';
          String messageOne = '421["${SocketEvents.v3GetStatuses}",[${value.threadId.validate()}]]';

          log('Send Message = $message');
          log('Send Message = $messageOne');
          channel?.sink.add(message);
          channel?.sink.add(messageOne);

          threadOpened = value.threadId.validate();

          ChatScreen(
            threadId: value.threadId.validate(),
            user: widget.user,
            onDeleteThread: () {
              finish(context);
            },
          ).launch(context);
        }).catchError((onError) {
          appStore.setLoading(false);
        });
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
        child: TextIcon(
          prefix: cachedImage(widget.user.avatar, fit: BoxFit.cover, height: 30, width: 30).cornerRadiusWithClipRRect(25),
          text: widget.user.name.validate(),
          textStyle: boldTextStyle(),
          spacing: 16,
          expandedText: true,
          suffix: Tooltip(
            richMessage: TextSpan(text: language.userProfile, style: secondaryTextStyle(color: Colors.white)),
            child: IconButton(
              icon: cachedImage(ic_profile, color: context.primaryColor, width: 20, height: 20, fit: BoxFit.cover),
              onPressed: () {
                MemberProfileScreen(memberId: widget.user.userId.validate()).launch(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
