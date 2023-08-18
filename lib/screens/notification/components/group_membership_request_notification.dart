import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/notifications/notification_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../utils/app_constants.dart';

class GroupMembershipRequestNotification extends StatelessWidget {
  final NotificationModel element;
  final VoidCallback? callback;

  GroupMembershipRequestNotification({this.callback, required this.element});

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
    return Observer(
      builder: (_) => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cachedImage(element.secondaryItemImage, height: 40, width: 40, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
              8.width,
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      text: '${element.secondaryItemName} ',
                      style: boldTextStyle(size: 14, fontFamily: fontFamily),
                      children: [
                        if (element.isUserVerified.validate()) WidgetSpan(child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover)),
                        TextSpan(text: ' ${language.sendRequestToFollow}', style: secondaryTextStyle(fontFamily: fontFamily)),
                        TextSpan(text: '  ${element.itemName.validate()}', style: boldTextStyle(size: 14, color: appStore.isDarkMode ? bodyDark : bodyWhite, fontFamily: fontFamily)),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  6.height,
                  Text(convertToAgo(element.date.validate()), style: secondaryTextStyle(size: 12)),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ).expand(),
              IconButton(
                onPressed: () async {
                  if (!appStore.isLoading)
                    showConfirmDialogCustom(
                      context,
                      onAccept: (c) {
                        delete();
                      },
                      dialogType: DialogType.CONFIRMATION,
                      title: language.deleteNotificationConfirmation,
                      positiveText: language.remove,
                    );
                },
                icon: Icon(Icons.delete_outline, color: appStore.isDarkMode ? bodyDark : bodyWhite),
              ),
            ],
          ).paddingAll(16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                text: language.confirm,
                textStyle: secondaryTextStyle(color: Colors.white, size: 14),
                onTap: () async {
                  ifNotTester(() async {
                    if (element.requestId.validate() != 'false') {
                      //
                    } else {
                      appStore.setLoading(true);
                      await acceptGroupMembershipRequest(requestId: element.requestId.validate().toInt()).then((value) {
                        callback?.call();
                      }).catchError((e) {
                        appStore.setLoading(false);

                        if (e.toString() != errorInternetNotAvailable) {
                          // delete();
                        }
                        toast(e.toString(), print: true);
                      });
                    }
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
                    if (element.requestId.validate() != 'false') {
                      //
                    } else {
                      appStore.setLoading(true);
                      rejectGroupMembershipRequest(requestId: element.requestId.validate().toInt()).then((value) {
                        callback?.call();
                      }).catchError((e) {
                        appStore.setLoading(false);

                        toast(e.toString(), print: true);
                      });
                    }
                  });
                },
                elevation: 0,
                color: element.isNew.validate() == 1 ? context.scaffoldBackgroundColor : context.cardColor,
                height: 32,
              ),
            ],
          ).center(),
        ],
      ),
    );
  }
}
