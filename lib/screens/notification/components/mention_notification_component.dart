import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/notifications/notification_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class MentionNotificationComponent extends StatelessWidget {
  final NotificationModel element;
  final VoidCallback? callback;

  MentionNotificationComponent({required this.element, this.callback});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            cachedImage(element.secondaryItemImage, height: 40, width: 40, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
            8.width,
            Column(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Text('${element.secondaryItemName.validate()} ', style: boldTextStyle(size: 14,fontFamily: fontFamily)).onTap(() {
                          MemberProfileScreen(memberId: element.secondaryItemId.validate()).launch(context);
                        }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                      ),
                      if (element.isUserVerified.validate()) WidgetSpan(child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover)),
                      TextSpan(text: ' ${language.mentionedYou}', style: secondaryTextStyle(fontFamily: fontFamily)),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
                6.height,
                Text(convertToAgo(element.date.validate()), style: secondaryTextStyle(size: 12)),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ).expand(),
          ],
        ).expand(),
        Observer(
          builder: (_) => IconButton(
            onPressed: () {
              if (!appStore.isLoading)
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
          ),
        ),
      ],
    ).paddingAll(16);
  }
}
