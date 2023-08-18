import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/notifications/notification_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class RequestNotificationComponent extends StatelessWidget {
  final NotificationModel element;
  final VoidCallback? callback;

  RequestNotificationComponent({this.callback, required this.element});

  Future<void> delete() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cachedImage(element.itemImage.validate(), height: 40, width: 40, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
        8.width,
        Column(
          children: [
            RichText(
              text: TextSpan(
                text: '${element.itemName.validate()} ',
                style: boldTextStyle(size: 14, fontFamily: fontFamily),
                children: [
                  if (element.isUserVerified.validate()) WidgetSpan(child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover)),
                  TextSpan(
                    text: ' ${language.sendRequestToFollowYou}',
                    style: secondaryTextStyle(fontFamily: fontFamily),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
            6.height,
            Text(convertToAgo(element.date.validate()), style: secondaryTextStyle()),
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
                      await acceptFriendRequest(id: element.itemId.validate()).then((value) {
                        callback?.call();
                      }).catchError((e) {
                        appStore.setLoading(false);

                        if (e.toString() != errorInternetNotAvailable) {
                          delete();
                        }
                        toast(e.toString(), print: true);
                      });
                    });
                  },
                  color: appColorPrimary,
                  height: 32,
                  elevation: 0,
                ),
                16.width,
                AppButton(
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                  text: language.delete,
                  textStyle: secondaryTextStyle(color: appColorPrimary, size: 14),
                  onTap: () {
                    ifNotTester(() {
                      appStore.setLoading(true);
                      removeExistingFriendConnection(friendId: element.itemId.validate().toString(), passRequest: false).then((value) {
                        callback?.call();
                      }).catchError((e) {
                        appStore.setLoading(false);
                        if (e.toString() != errorInternetNotAvailable) {
                          delete();
                        }
                        toast(e.toString(), print: true);
                      });
                    });
                  },
                  elevation: 0,
                  color: element.isNew.validate() == 1 ? context.scaffoldBackgroundColor : context.cardColor,
                  height: 32,
                ),
              ],
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ).expand(),
      ],
    ).paddingAll(16);
  }
}
