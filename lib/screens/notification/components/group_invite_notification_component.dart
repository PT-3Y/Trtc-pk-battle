import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/notifications/notification_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class GroupInviteNotificationComponent extends StatelessWidget {
  final NotificationModel element;
  final VoidCallback? callback;

  const GroupInviteNotificationComponent({required this.element, this.callback});

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
      children: [
        cachedImage(element.itemImage, height: 40, width: 40, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
        8.width,
        Column(
          children: [
            Text('${language.inviteFrom} ${element.itemName}', style: secondaryTextStyle()),
            6.height,
            Text(convertToAgo(element.date.validate()), style: secondaryTextStyle(size: 12)),
            16.height,
            Row(
              children: [
                AppButton(
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                  text: language.confirm,
                  textStyle: secondaryTextStyle(color: Colors.white, size: 14),
                  onTap: () async {
                    ifNotTester(() async {
                      appStore.setLoading(true);

                      await acceptGroupInvite(id: element.secondaryItemId.validate().toString()).then((value) async {
                        callback?.call();
                      }).catchError((e) {
                        if (e.toString() != errorInternetNotAvailable) {
                          delete();
                        }
                        appStore.setLoading(false);

                        log(e.toString());
                      });
                    });
                  },
                  elevation: 0,
                  color: appColorPrimary,
                  height: 32,
                ),
                16.width,
                AppButton(
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                  text: language.delete,
                  textStyle: secondaryTextStyle(color: appColorPrimary, size: 14),
                  onTap: () async {
                    ifNotTester(() async {
                      appStore.setLoading(true);

                      await rejectGroupInvite(id: element.secondaryItemId.validate()).then((value) async {
                        delete();
                      }).catchError((e) {
                        if (e.toString() != errorInternetNotAvailable) {
                          delete();
                        }

                        appStore.setLoading(false);
                        log(e.toString());
                      });
                    });
                  },
                  elevation: 0,
                  color: element.isNew.validate() == 1 ? context.scaffoldBackgroundColor : context.cardColor,
                  height: 32,
                ),
              ],
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ],
    ).paddingAll(16);
  }
}
