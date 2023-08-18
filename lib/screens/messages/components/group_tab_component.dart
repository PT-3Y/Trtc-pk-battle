import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/messages/message_groups.dart';
import 'package:socialv/network/messages_repository.dart';
import 'package:socialv/screens/groups/screens/group_detail_screen.dart';
import 'package:socialv/screens/messages/components/initial_message_component.dart';
import 'package:socialv/screens/messages/components/recent_message_component.dart';
import 'package:socialv/screens/messages/screens/chat_screen.dart';
import 'package:socialv/screens/messages/screens/message_screen.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class GroupTabComponent extends StatefulWidget {
  const GroupTabComponent({Key? key}) : super(key: key);

  @override
  State<GroupTabComponent> createState() => _GroupTabComponentState();
}

class _GroupTabComponentState extends State<GroupTabComponent> {
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
    return SnapHelperWidget<List<MessageGroups>>(
      future: getGroups(),
      onSuccess: (snap) {
        if (snap.isNotEmpty)
          return AnimatedListView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: snap.validate().length,
            slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
            itemBuilder: (context, index) {
              MessageGroups group = snap[index];

              return InkWell(
                onTap: () {
                  String message = '42["${SocketEvents.threadOpen}",${group.threadId.validate()}]';
                  String messageOne = '421["${SocketEvents.v3GetStatuses}",[${group.threadId.validate()}]]';

                  log('Send Message = $message');
                  log('Send Message = $messageOne');
                  channel?.sink.add(message);
                  channel?.sink.add(messageOne);

                  threadOpened = group.threadId.validate();

                  ChatScreen(
                    threadId: group.threadId.validate(),
                    onDeleteThread: () {
                      finish(context);
                    },
                  ).launch(context);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.only(left: 8),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(commonRadius)),
                  child: TextIcon(
                    prefix: cachedImage(group.image, fit: BoxFit.cover, height: 30, width: 30).cornerRadiusWithClipRRect(25),
                    text: group.name.validate(),
                    textStyle: boldTextStyle(),
                    spacing: 12,
                    expandedText: true,
                    suffix: Tooltip(
                      richMessage: TextSpan(text: language.groupHomepage, style: secondaryTextStyle(color: Colors.white)),
                      child: IconButton(
                        icon: cachedImage(ic_home, color: context.primaryColor, width: 20, height: 20, fit: BoxFit.cover),
                        onPressed: () {
                          GroupDetailScreen(
                            groupId: group.groupId,
                          ).launch(context);
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
            shrinkWrap: true,
          );
        else
          return InitialMessageComponent(title: language.noGroupsAddedYet);
      },
      errorWidget: SizedBox(
        height: context.height() * 0.65,
        child: NoDataWidget(
          imageWidget: NoDataLottieWidget(),
          title: language.somethingWentWrong,
          onRetry: () {
            //
          },
          retryText: '   ${language.clickToRefresh}   ',
        ).center(),
      ),
      loadingWidget: SizedBox(
        height: context.height() * 0.65,
        child: ThreeBounceLoadingWidget(),
      ),
    );
  }
}
