import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/messages/message_users.dart';
import 'package:socialv/network/messages_repository.dart';
import 'package:socialv/screens/messages/components/initial_message_component.dart';
import 'package:socialv/screens/messages/components/message_member_component.dart';

class FriendsTabComponent extends StatefulWidget {
  const FriendsTabComponent({Key? key}) : super(key: key);

  @override
  State<FriendsTabComponent> createState() => _FriendsTabComponentState();
}

class _FriendsTabComponentState extends State<FriendsTabComponent> {
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
    return SnapHelperWidget<List<MessagesUsers>>(
      future: getFriends(),
      onSuccess: (snap) {
        if (snap.isNotEmpty)
          return AnimatedListView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: snap.validate().length,
            slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
            itemBuilder: (context, index) {
              MessagesUsers user = snap[index];

              return MessageMemberComponent(user: user).paddingSymmetric(vertical: 8);
            },
            shrinkWrap: true,
          );
        else
          return InitialMessageComponent(title: language.noFriendsAddedYet);
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
