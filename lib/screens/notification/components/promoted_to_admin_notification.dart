import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/notifications/notification_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class PromotedToAdminNotification extends StatelessWidget {
  final NotificationModel element;
  final VoidCallback? callback;

  PromotedToAdminNotification({this.callback, required this.element});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cachedImage(element.itemImage, height: 40, width: 40, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${language.promotedToAdmin} ${element.itemName}',
              style: secondaryTextStyle(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
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
