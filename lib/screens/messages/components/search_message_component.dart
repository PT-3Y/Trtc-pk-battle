import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/messages/message_users.dart';
import 'package:socialv/models/messages/messages_model.dart';
import 'package:socialv/models/messages/threads_model.dart';
import 'package:socialv/models/messages/search_message_response.dart';
import 'package:socialv/screens/messages/components/message_member_component.dart';
import 'package:socialv/screens/messages/components/recent_message_component.dart';

class SearchMessageComponent extends StatefulWidget {
  final SearchMessageResponse searchResponse;
  final VoidCallback refreshThread;
  final Function(int) onDeleteConvo;

  const SearchMessageComponent({required this.searchResponse, required this.refreshThread, required this.onDeleteConvo});

  @override
  State<SearchMessageComponent> createState() => _SearchMessageComponentState();
}

class _SearchMessageComponentState extends State<SearchMessageComponent> {
  @override
  void initState() {
    super.initState();

    messageStore.setRefreshRecentMessages(false);
  }

  @override
  void dispose() {
    super.dispose();
    messageStore.setRefreshRecentMessages(true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.searchResponse.friends.validate().isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language.friends, style: boldTextStyle()),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.searchResponse.friends.validate().length,
                itemBuilder: (ctx, index) {
                  return MessageMemberComponent(user: widget.searchResponse.friends.validate()[index]).paddingSymmetric(vertical: 8);
                },
              ),
            ],
          ),
        if (widget.searchResponse.users.validate().isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language.members, style: boldTextStyle()),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.searchResponse.users.validate().length,
                itemBuilder: (ctx, index) {
                  return MessageMemberComponent(user: widget.searchResponse.users.validate()[index]).paddingSymmetric(vertical: 8);
                },
              ),
            ],
          ),
        if (widget.searchResponse.messages.validate().isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language.conversations, style: boldTextStyle()),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.searchResponse.messages.validate().length,
                itemBuilder: (ctx, index) {
                  SearchMessage msg = widget.searchResponse.messages.validate()[index];

                  Threads thread = widget.searchResponse.updateData!.threads.validate().firstWhere((element) => element.threadId == msg.threadId);
                  MessagesUsers user = widget.searchResponse.updateData!.users.validate().firstWhere((element) => element.userId == thread.participants!.first);
                  Messages message = widget.searchResponse.updateData!.messages.validate().firstWhere((element) => element.messageId.validate() == msg.messageId.validate());

                  return RecentMessageComponent(
                    thread: thread,
                    user: user,
                    message: message,
                    callback: () {
                      setState(() {});
                    },
                    refreshThread: () {
                      widget.refreshThread.call();
                    },
                    onDeleteConvo: () {
                      widget.onDeleteConvo.call(thread.threadId.validate());
                    },
                  );
                },
              ),
            ],
          ),
      ],
    ).paddingAll(16);
  }
}
