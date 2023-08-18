import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/screens/groups/screens/create_group_screen.dart';

import '../../../components/loading_widget.dart';
import '../../../main.dart';
import '../../../network/rest_apis.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';

class CreateGroupStepSecond extends StatefulWidget {
  final Function(int)? onNextPage;
  final bool? isAPartOfSteps;
  final String? groupInviteStatus;
  final int? isGalleryEnabled;

  const CreateGroupStepSecond({Key? key, this.onNextPage, this.isAPartOfSteps = true, this.groupInviteStatus, this.isGalleryEnabled}) : super(key: key);

  @override
  State<CreateGroupStepSecond> createState() => _CreateGroupStepSecondState();
}

enum GroupInvitations { members, mods, admins }

enum EnableGallery { yes, no }

class _CreateGroupStepSecondState extends State<CreateGroupStepSecond> {
  GroupInvitations? groupInvitations = GroupInvitations.members;
  String isGalleryEnabled = EnableGallery.no.toString();
  bool enableGallery = false;

  @override
  void initState() {
    super.initState();
    if (widget.isGalleryEnabled != 0) {
      enableGallery = true;
    }

    if (widget.groupInviteStatus == "mods") {
      groupInvitations = GroupInvitations.mods;
    } else if (widget.groupInviteStatus == "admins") {
      groupInvitations = GroupInvitations.admins;
    }
  }

  Future<void> editGroup() async {
    ifNotTester(() async {
      appStore.setLoading(true);
      if (enableGallery) {
        isGalleryEnabled = EnableGallery.yes.toString();
      }
      await editGroupSettings(groupId: groupId, enableGallery: isGalleryEnabled.substring(14), inviteStatus: groupInvitations.toString().substring(17)).then((value) {
        appStore.setLoading(false);
        toast(value.message.toString());
        if (widget.isAPartOfSteps.validate()) {
          widget.onNextPage?.call(2);
        } else {
          finish(context, true);
        }
        setState(() {});
      }).catchError((e) {
        toast(e.toString());
        appStore.setLoading(false);
        setState(() {});
      });
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        decoration: BoxDecoration(
          borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.isAPartOfSteps.validate())
                      Text(
                        "2. ${language.groupSettings}",
                        style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 18),
                      ).paddingTop(16),
                    16.height,
                    Text(language.groupInvites, style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 18)),
                    16.height,
                    Text(language.groupInvitationsSubtitle, style: secondaryTextStyle()),
                    16.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Radio(
                          value: GroupInvitations.members,
                          groupValue: groupInvitations,
                          onChanged: (GroupInvitations? value) {
                            if (!appStore.isLoading)
                              setState(() {
                                groupInvitations = value;
                              });
                          },
                        ),
                        Text(language.allGroupMembers, style: boldTextStyle()).paddingTop(12),
                      ],
                    ).onTap(() {
                      if (!appStore.isLoading)
                        setState(() {
                          groupInvitations = GroupInvitations.members;
                        });
                    }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Radio(
                          value: GroupInvitations.mods,
                          groupValue: groupInvitations,
                          onChanged: (GroupInvitations? value) {
                            if (!appStore.isLoading)
                              setState(() {
                                groupInvitations = value;
                              });
                          },
                        ),
                        Text(language.groupAdminsAndModsOnly, style: boldTextStyle()).paddingTop(12),
                      ],
                    ).onTap(() {
                      if (!appStore.isLoading)
                        setState(() {
                          groupInvitations = GroupInvitations.mods;
                        });
                    }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Radio(
                          value: GroupInvitations.admins,
                          groupValue: groupInvitations,
                          onChanged: (GroupInvitations? value) {
                            if (!appStore.isLoading)
                              setState(() {
                                groupInvitations = value;
                              });
                          },
                        ),
                        Text(language.groupAdminsOnly, style: boldTextStyle()).paddingTop(12),
                      ],
                    ).onTap(() {
                      if (!appStore.isLoading)
                        setState(() {
                          groupInvitations = GroupInvitations.admins;
                        });
                    }),
                    8.height,
                    Text(language.enableGallery, style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 18)),
                    16.height,
                    Text(language.enableGallerySubtitle, style: secondaryTextStyle()),
                    16.height,
                    Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: radius(2)),
                          activeColor: context.primaryColor,
                          value: enableGallery,
                          onChanged: (val) {
                            enableGallery = !enableGallery;
                            setState(() {});
                          },
                        ),
                        Text(language.enableGalleryCheckBoxText, style: secondaryTextStyle()).onTap(() {
                          enableGallery = !enableGallery;
                          setState(() {});
                        }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                      ],
                    ),
                    32.height,
                    appButton(
                      context: context,
                      text: language.submit.capitalizeFirstLetter(),
                      onTap: () {
                        editGroup();
                        /*if (widget.isAPartOfSteps.validate()) {
                          editGroup();
                          widget.onNextPage?.call(2);
                        }else{
                          editGroup();
                        }*/
                      },
                    ),
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => LoadingWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
