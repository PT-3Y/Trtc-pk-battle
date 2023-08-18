import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/groups/group_model.dart';
import 'package:socialv/screens/groups/screens/group_member_request_screen.dart';
import 'package:socialv/screens/groups/screens/group_member_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class GroupCardComponent extends StatefulWidget {
  final GroupModel data;
  final VoidCallback? callback;

  const GroupCardComponent({required this.data, this.callback});

  @override
  State<GroupCardComponent> createState() => _GroupCardComponentState();
}

class _GroupCardComponentState extends State<GroupCardComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: radius(defaultAppButtonRadius), color: context.cardColor),
      child: Column(
        children: [
          SizedBox(
            height: 170,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                widget.data.groupCoverImage.validate().isNotEmpty
                    ? cachedImage(
                        widget.data.groupCoverImage,
                        height: 120,
                        width: context.width() - 32,
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRectOnly(topLeft: defaultAppButtonRadius.toInt(), topRight: defaultAppButtonRadius.toInt())
                    : Image.asset(
                        AppImages.profileBackgroundImage,
                        height: 120,
                        width: context.width() - 32,
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRectOnly(topLeft: defaultAppButtonRadius.toInt(), topRight: defaultAppButtonRadius.toInt()),
                Positioned(
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: context.cardColor, width: 2), shape: BoxShape.circle),
                    child: cachedImage(
                      widget.data.groupAvatarImage,
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    ).cornerRadiusWithClipRRect(100),
                  ),
                ),
              ],
            ),
          ),
          16.height,
          RichText(
            text: TextSpan(
              text: '${parseHtmlString(widget.data.name.validate())}',
              style: boldTextStyle(size: 20,fontFamily: fontFamily),
              children: <TextSpan>[
                TextSpan(
                  text:
                      ' ${widget.data.isGroupAdmin.validate() ? '(${language.organizer})' : widget.data.isGroupMember.validate() ? '(${language.member})' : ''}',
                  style: boldTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 14,fontFamily: fontFamily),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ).paddingSymmetric(horizontal: 8),
          12.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.data.groupType == AccountType.private ? ic_lock : ic_globe_antarctic,
                height: 16,
                width: 16,
                fit: BoxFit.cover,
                color: context.iconColor,
              ),
              4.width,
              Text(widget.data.groupType.validate(), style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
              Text('•', style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)).paddingSymmetric(horizontal: 8),
              Image.asset(ic_two_user, height: 16, width: 16, fit: BoxFit.cover, color: context.iconColor),
              4.width,
              TextButton(
                onPressed: () {
                  if (widget.data.isGroupAdmin.validate() && widget.data.groupType == AccountType.privateGroup) {
                    GroupMemberRequestScreen(
                      creatorId: widget.data.groupCreatedById.validate(),
                      groupId: widget.data.id.validate(),
                      isAdmin: widget.data.isGroupAdmin.validate(),
                    ).launch(context).then((value) {
                      if (value ?? false) {
                        widget.callback!.call();
                      }
                    });
                  } else if (widget.data.groupType == AccountType.public || widget.data.isGroupMember.validate()) {
                    GroupMemberScreen(
                      creatorId: widget.data.groupCreatedById.validate(),
                      groupId: widget.data.id.validate(),
                      isAdmin: widget.data.isGroupAdmin.validate(),
                    ).launch(context).then((value) {
                      if (value ?? false) {
                        widget.callback!.call();
                      }
                    });
                  } else {
                    toast(language.cShowGroupMembers);
                  }
                },
                child: Text(
                  '${widget.data.memberCount} ${language.members}',
                  style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
                ),
              ),
            ],
          ).paddingOnly(bottom: 16),
        ],
      ),
    );
  }
}
