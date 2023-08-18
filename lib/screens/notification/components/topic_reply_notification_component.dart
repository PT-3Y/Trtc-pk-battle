import 'package:flutter/material.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/notifications/notification_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/screens/forums/screens/topic_detail_screen.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class TopicReplyNotificationComponent extends StatelessWidget {
  final NotificationModel element;
  final VoidCallback? callback;

  const TopicReplyNotificationComponent({required this.element, this.callback});

  Future<void> delete() async {
    appStore.setLoading(true);
    await deleteNotification(notificationId: element.id.toString().validate()).then((value) {
      callback?.call();
    }).catchError((e) {
      appStore.setLoading(false);
      log(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cachedImage(element.secondaryItemImage, height: 40, width: 40, fit: BoxFit.cover).cornerRadiusWithClipRRect(20).onTap((){
              MemberProfileScreen(memberId: element.secondaryItemId.validate()).launch(context);
            },highlightColor: Colors.transparent,splashColor: Colors.transparent),
            8.width,
            Column(
              children: [
                RichText(
                  text: TextSpan(
                    text: '${element.secondaryItemName.validate()} ',
                    style: boldTextStyle(size: 14, fontFamily: fontFamily),
                    children: [
                      if (element.isUserVerified.validate()) WidgetSpan(child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover)),

                      TextSpan(text: ' ${language.repliedInTopic} ', style: secondaryTextStyle(fontFamily: fontFamily)),
                      TextSpan(text: '${element.itemName} ', style: boldTextStyle(size: 14,fontFamily: fontFamily)),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
                8.height,
                Text(convertToAgo(element.date.validate()), style: secondaryTextStyle(size: 12)),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ).expand(),
          ],
        ).onTap((){
          TopicDetailScreen(topicId: element.topicId.validate()).launch(context);
        }).expand(),
        IconButton(
          onPressed: () async {
            showConfirmDialogCustom(
              context,
              onAccept: (c) {
                ifNotTester(() {
                  appStore.setLoading(true);

                  deleteNotification(notificationId: element.id.toString()).then((value) {
                    if (value.deleted.validate()) {
                      callback?.call();
                    }
                  }).catchError((e) {
                    appStore.setLoading(false);
                    toast(e.toString(), print: true);
                  });
                });
              },
              dialogType: DialogType.CONFIRMATION,
              title: language.deleteNotificationConfirmation,
              positiveText: language.remove,
            );
          },
          icon: Icon(Icons.delete_outline, color: appStore.isDarkMode ? bodyDark : bodyWhite),
        )
      ],
    ).paddingAll(16);
  }
}
