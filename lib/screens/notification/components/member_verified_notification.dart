import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/notifications/notification_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class MemberVerifiedNotification extends StatelessWidget {
  final NotificationModel element;
  final VoidCallback? callback;

  const MemberVerifiedNotification({required this.element, this.callback});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cachedImage(appStore.loginAvatarUrl, height: 40, width: 40, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Text('${appStore.loginFullName} ', style: boldTextStyle(size: 14,fontFamily: fontFamily)).onTap(() {
                      MemberProfileScreen(memberId: appStore.loginUserId.toInt()).launch(context);
                    }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  ),
                  TextSpan(
                    text: element.action == NotificationAction.memberVerified ? ' ${language.yourAccountIsVerifiedNow}' : ' ${language.verificationRequestRejectedText}',
                    style: secondaryTextStyle(fontFamily: fontFamily),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
            6.height,
            Text(convertToAgo(element.date.validate()), style: secondaryTextStyle(size: 12)),
          ],
        ).expand(),
        Observer(
          builder: (_) => IconButton(
            onPressed: () async {
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
