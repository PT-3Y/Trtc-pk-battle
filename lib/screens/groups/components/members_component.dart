import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/members/member_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/profile/screens/member_profile_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

// ignore: must_be_immutable
class MembersComponent extends StatefulWidget {
  bool isAdmin;
  final MemberModel member;
  final int groupId;
  final VoidCallback? callback;
  final int creatorId;

  MembersComponent({
    required this.member,
    required this.groupId,
    this.callback,
    required this.isAdmin,
    required this.creatorId,
  });

  @override
  State<MembersComponent> createState() => _MembersComponentState();
}

class _MembersComponentState extends State<MembersComponent> {
  bool isMember = true;

  @override
  void initState() {
    super.initState();
    isMember = !widget.member.isAdmin.validate() && widget.member.isMod == 0;
    setState(() {});
  }

  void popUpMenuButtonActions({required String role, required String action}) {
    return ifNotTester(() {
      appStore.setLoading(true);
      groupMemberRoles(groupId: widget.groupId, memberId: widget.member.userId.validate(), role: role, action: action).then((value) {

        if (action == GroupActions.demote && widget.member.userId.toString() == appStore.loginUserId) {
          finish(context);
          finish(context, true);
        }

        appStore.setLoading(false);
        widget.callback?.call();
      }).catchError((e) {
        if (widget.member.userId.toString() == appStore.loginUserId) {
          widget.isAdmin = !widget.isAdmin;
          isMember = false;
          setState(() {});
        }
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            cachedImage(
              widget.member.userAvatar.validate(),
              height: 56,
              width: 56,
              fit: BoxFit.cover,
            ).cornerRadiusWithClipRRect(100),
            20.width,
            Column(
              children: [
                SizedBox(
                  width: context.width() * 0.56,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.member.userName.validate(), style: boldTextStyle(), overflow: TextOverflow.ellipsis).flexible(),
                      if (widget.member.isUserVarified.validate()) Image.asset(ic_tick_filled, width: 18, height: 18, color: blueTickColor).paddingSymmetric(horizontal: 4),
                      if (widget.member.isAdmin.validate())
                        Container(
                          decoration: BoxDecoration(color: appGreenColor.withAlpha(30), borderRadius: radius()),
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(language.admin, style: secondaryTextStyle(color: appGreenColor, size: 10)),
                        ),
                      if (widget.member.isMod == 1) Icon(Icons.star, size: 18, color: Colors.amber).paddingSymmetric(horizontal: 4),
                    ],
                  ),
                ),
                6.height,
                Text(widget.member.mentionName.validate(), style: secondaryTextStyle()),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ],
        ).expand(),
        if (widget.isAdmin)
          Theme(
            data: Theme.of(context).copyWith(useMaterial3: false),
            child: PopupMenuButton(
              position: PopupMenuPosition.under,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonRadius)),
              onSelected: (val) {
                if (val == 2) {
                  showConfirmDialogCustom(
                    context,
                    onAccept: (c) {
                      ifNotTester(() {
                        removeGroupMember(groupId: widget.groupId, memberId: widget.member.userId.validate()).then((value) {
                          appStore.setLoading(false);
                          widget.callback?.call();
                        }).catchError((e) {
                          appStore.setLoading(false);
                          toast(e.toString(), print: true);
                        });
                      });
                    },
                    dialogType: DialogType.CONFIRMATION,
                    title: language.removeGroupMemberConfirmation,
                    positiveText: language.remove,
                  );
                } else if (val == 3) {
                  popUpMenuButtonActions(action: GroupActions.promote, role: Roles.mod);
                } else if (val == 4) {
                  popUpMenuButtonActions(action: widget.member.isBanned == 1 ? GroupActions.unban : GroupActions.ban, role: Roles.member);
                } else if (val == 5) {
                  popUpMenuButtonActions(action: GroupActions.demote, role: Roles.member);
                } else {
                  popUpMenuButtonActions(action: GroupActions.promote, role: Roles.admin);
                }
              },
              icon: Icon(Icons.more_horiz, color: context.iconColor),
              itemBuilder: (context) => <PopupMenuEntry>[
                if (!widget.member.isAdmin.validate())
                  PopupMenuItem(
                    value: 1,
                    child: Text(language.makeGroupAdmin),
                    textStyle: primaryTextStyle(),
                  ),
                if (isMember)
                  PopupMenuItem(
                    value: 2,
                    child: Text(language.removeFromGroup),
                    textStyle: primaryTextStyle(),
                  ),
                if (isMember)
                  PopupMenuItem(
                    value: 3,
                    child: Text(language.promoteToMod),
                    textStyle: primaryTextStyle(),
                  ),
                if (isMember)
                  PopupMenuItem(
                    value: 4,
                    child: Text(widget.member.isBanned != 1 ? language.ban : language.unban),
                    textStyle: primaryTextStyle(),
                  ),
                if (widget.member.isAdmin.validate() || widget.member.isMod == 1)
                  PopupMenuItem(
                    value: 5,
                    child: Text(language.demoteToMember),
                    textStyle: primaryTextStyle(),
                  ),
              ],
            ),
          ),
      ],
    ).onTap(() async {
      MemberProfileScreen(memberId: widget.member.userId.validate()).launch(context);
    }, splashColor: Colors.transparent, highlightColor: Colors.transparent);
  }
}
