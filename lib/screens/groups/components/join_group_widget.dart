import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/network/rest_apis.dart';

import '../../../utils/app_constants.dart';

class JoinGroupWidget extends StatefulWidget {
  final int groupId;
  final bool isGroupMember;
  final bool isPublicGroup;
  final VoidCallback? callback;
  final int isRequestSent;
  final int hasInvite;


  const JoinGroupWidget({
    required this.groupId,
    required this.isGroupMember,
    required this.isPublicGroup,
    this.callback,
    required this.isRequestSent,
    required this.hasInvite,
  });

  @override
  State<JoinGroupWidget> createState() => _JoinGroupWidgetState();
}

class _JoinGroupWidgetState extends State<JoinGroupWidget> {
  bool isRequested = false;

  @override
  void initState() {
    isRequested = widget.isRequestSent.validate() == 0 ? false : true;
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasInvite != 0) {
      return Column(
        children: [
          10.height,
          Text(language.youHaveGroupInvite, style: secondaryTextStyle()),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                elevation: 0,
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                text: language.confirm,
                textStyle: secondaryTextStyle(color: appStore.isDarkMode ? context.primaryColor : Colors.white, size: 14),
                onTap: () async {
                  ifNotTester(() async {
                    appStore.setLoading(true);
                    await acceptGroupInvite(id: widget.hasInvite.validate().toString()).then((value) async {
                      widget.callback?.call();
                    }).catchError((e) {
                      appStore.setLoading(false);
                      log(e.toString());
                    });
                  });
                },
                height: 32,
              ),
              16.width,
              AppButton(
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                text: language.delete,
                textStyle: secondaryTextStyle(color: context.primaryColor, size: 14),
                onTap: () async {
                  ifNotTester(() async {
                    appStore.setLoading(true);
                    await rejectGroupInvite(id: widget.hasInvite.validate()).then((value) async {
                      widget.callback?.call();
                    }).catchError((e) {
                      appStore.setLoading(false);
                      log(e.toString());
                    });
                  });
                },
                color: context.scaffoldBackgroundColor,
                height: 32,
                elevation: 0,
              ),
            ],
          ),
        ],
      );
    } else if (widget.isPublicGroup) {
      return appButton(
        context: context,
        shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
        text: language.joinGroup,
        textStyle: boldTextStyle(color: Colors.white),
        onTap: () {
          ifNotTester(() {
            appStore.setLoading(true);
            joinPublicGroup(groupId: widget.groupId).then((value) {
              widget.callback?.call();
              setState(() {});
            }).catchError((e) {
              appStore.setLoading(false);
              toast(e.toString(), print: true);
            });
          });
        },
        width: context.width() - 64,
      ).paddingSymmetric(vertical: 20);
    } else {
      return appButton(
        context: context,
        shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
        text: isRequested.validate() ? language.requested : language.joinGroup,
        textStyle: boldTextStyle(color: Colors.white),
        onTap: () {
          ifNotTester(() {
            if (widget.isRequestSent.validate() == 0) {
              isRequested = true;
              setState(() {});

              Map request = {"group_id": widget.groupId};
              sendGroupMembershipRequest(request).then((value) {
                widget.callback?.call();
              }).catchError((e) {
                isRequested = false;
                setState(() {});
                toast(e.toString(), print: true);
              });
            } else {
              isRequested = false;
              rejectGroupMembershipRequest(requestId: widget.isRequestSent.validate()).then((value) {
                widget.callback?.call();
              }).catchError((e) {
                toast(e.toString(), print: true);
              });

              setState(() {});
            }
          });
        },
        width: context.width() - 64,
      ).paddingSymmetric(vertical: 20);
    }
  }
}
