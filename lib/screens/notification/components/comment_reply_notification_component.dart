import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/notifications/notification_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/post/screens/single_post_screen.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class CommentReplyNotificationComponent extends StatelessWidget {
  final NotificationModel element;
  final VoidCallback? callback;

  CommentReplyNotificationComponent({required this.element, this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        SinglePostScreen(postId: element.itemId.validate()).launch(context);
      },
      onLongPress: () {
        if (element.action == NotificationAction.actionActivityLiked && element.itemImage!.isNotEmpty) {
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
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      children: [
                        WidgetSpan(
                          child: Text('${element.secondaryItemName.validate()} ', style: boldTextStyle(size: 14,fontFamily: fontFamily)).onTap(() {
                            MemberProfileScreen(memberId: element.secondaryItemId.validate()).launch(context);
                          }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                        ),
                        if (element.isUserVerified.validate()) WidgetSpan(child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover)),
                        TextSpan(
                          text: element.action == NotificationAction.actionActivityLiked
                              ? ' ${language.likedPost} '
                              : element.action == NotificationAction.updateReply
                                  ? ' ${language.commentedPost} '
                                  : ' ${language.repliedYourComment} ',
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
                crossAxisAlignment: CrossAxisAlignment.start,
              ).expand(),
            ],
          ).expand(),
          element.action == NotificationAction.actionActivityLiked && element.itemImage!.isNotEmpty
              ? cachedImage(element.itemImage, height: 40, width: 40, fit: BoxFit.cover).cornerRadiusWithClipRRect(commonRadius)
              : Observer(
                  builder: (_) => IconButton(
                    onPressed: () {
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
      ).paddingAll(16),
    );
  }
}
