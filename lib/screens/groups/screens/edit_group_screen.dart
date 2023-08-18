import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/file_picker_dialog_component.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/groups/group_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/groups/components/create_group_step_one.dart';
import 'package:socialv/screens/groups/screens/create_group_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

import 'edit_group_settings_screen.dart';

class EditGroupScreen extends StatefulWidget {
  final int groupId;

  const EditGroupScreen({required this.groupId});

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  String avatarUrl = AppImages.placeHolderImage;
  String coverImage = AppImages.profileBackgroundImage;
  GroupModel group = GroupModel();

  GroupType? groupType = GroupType.PUBLIC;

  TextEditingController nameCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode name = FocusNode();
  FocusNode description = FocusNode();

  File? avatarImage;
  File? cover;

  bool isChange = false;
  bool detailsChanged = false;
  bool enableForum = false;

  List<List<String>> get groupTypeRule => [
        [
          language.createGroupPublicA,
          language.createGroupPublicB,
          language.createGroupPublicC,
        ],
        [
          language.createGroupPrivateA,
          language.createGroupPrivateB,
          language.createGroupPrivateC,
        ],
        [
          language.createGroupHiddenA,
          language.createGroupHiddenB,
          language.createGroupHiddenC,
        ],
      ];

  @override
  void initState() {
    setStatusBarColor(Colors.transparent);
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    appStore.setLoading(true);

    await getGroupDetail(groupId: widget.groupId.validate(), userId: appStore.loginUserId).then((value) {
      group = value.first;
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });

    coverImage = group.groupCoverImage.validate().isNotEmpty ? group.groupCoverImage.validate() : AppImages.profileBackgroundImage;
    if (group.groupAvatarImage.validate().isNotEmpty) avatarUrl = group.groupAvatarImage.validate();
    nameCont.text = group.name.validate();
    descriptionCont.text = group.description!.validate();

    log('group.groupType: ${group.groupType}');

    if (group.groupType.validate() == AccountType.public) {
      groupType = GroupType.PUBLIC;
    } else if (group.groupType.validate() == AccountType.private) {
      groupType = GroupType.PRIVATE;
    } else {
      groupType = GroupType.HIDDEN;
    }

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        finish(context, isChange);
        return Future.value(true);
      },
      child: Observer(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(language.editGroup, style: boldTextStyle(size: 20)),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: context.iconColor),
              onPressed: () {
                finish(context);
              },
            ),
            elevation: 0,
            centerTitle: true,
            actions: [
              cachedImage(
                ic_setting,
                color: appStore.isDarkMode ? bodyDark : bodyWhite,
                height: 22,
                width: 22,
              ).paddingAll(8).onTap(
                () {
                  groupId = group.id.validate();

                  log('group: ${group.id.validate()}');
                  EditGroupSettingsScreen(
                    groupId: group.id.validate(),
                    groupInviteStatus: group.inviteStatus,
                    isGalleryEnabled: group.isGalleryEnabled,
                  ).launch(context).then(
                    (value) {
                      if (value ?? false) {
                        isChange = true;
                      }
                    },
                  );
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              IconButton(
                onPressed: () {
                  if (!appStore.isLoading)
                    showConfirmDialogCustom(
                      context,
                      onAccept: (c) {
                        ifNotTester(() {
                          appStore.setLoading(true);
                          deleteGroup(id: widget.groupId.toString().validate()).then((value) {
                            finish(context);
                            finish(context, true);
                          }).catchError((e) {
                            appStore.setLoading(false);
                            toast(e.toString(), print: true);
                          });
                        });
                      },
                      dialogType: DialogType.DELETE,
                      title: language.doYouWantTo,
                    );
                },
                icon: Icon(Icons.delete_outline, color: appStore.isDarkMode ? bodyDark : bodyWhite),
              )
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          cover == null
                              ? cachedImage(
                                  coverImage,
                                  width: context.width(),
                                  height: 220,
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRectOnly(topLeft: defaultRadius.toInt(), topRight: defaultRadius.toInt())
                              : Image.file(
                                  File(cover!.path.validate()),
                                  width: context.width(),
                                  height: 220,
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRectOnly(topLeft: defaultRadius.toInt(), topRight: defaultRadius.toInt()),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: GestureDetector(
                              onTap: () async {
                                FileTypes? file = await showInDialog(
                                  context,
                                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                                  title: Text(language.chooseAnAction, style: boldTextStyle()),
                                  builder: (p0) {
                                    return FilePickerDialog(isSelected: coverImage == AppImages.profileBackgroundImage);
                                  },
                                );

                                if (file != null) {
                                  if (file == FileTypes.CANCEL) {
                                    ifNotTester(() async {
                                      appStore.setLoading(true);
                                      await deleteGroupCoverImage(id: widget.groupId.validate()).then((value) {
                                        toast(language.coverImageRemovedSuccessfully);
                                        isChange = true;
                                        init();
                                      }).catchError((e) {
                                        appStore.setLoading(false);
                                        toast(language.cRemoveCoverImage);
                                      });
                                    });
                                  } else {
                                    cover = await getImageSource(isCamera: file == FileTypes.CAMERA ? true : false);
                                    setState(() {});
                                    appStore.setLoading(false);
                                  }
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(color: appColorPrimary, borderRadius: radius(100)),
                                child: Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), shape: BoxShape.circle),
                                  child: avatarImage == null
                                      ? cachedImage(
                                          avatarUrl,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ).cornerRadiusWithClipRRect(100)
                                      : Image.file(
                                          File(avatarImage!.path.validate()),
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ).cornerRadiusWithClipRRect(100),
                                ),
                                Positioned(
                                  bottom: 2,
                                  right: -2,
                                  child: GestureDetector(
                                    onTap: () async {
                                      FileTypes? file = await showInDialog(
                                        context,
                                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                                        title: Text(language.chooseAnAction, style: boldTextStyle()),
                                        builder: (p0) {
                                          return FilePickerDialog(isSelected: getSourceLink(avatarUrl) == AppImages.defaultAvatarUrl);
                                        },
                                      );

                                      if (file != null) {
                                        if (file == FileTypes.CANCEL) {
                                          ifNotTester(() async {
                                            appStore.setLoading(true);
                                            await deleteAvatarImage(id: widget.groupId.toString().validate(), isGroup: true).then((value) {
                                              isChange = true;
                                              init();
                                            }).catchError((e) {
                                              appStore.setLoading(true);
                                              toast(e.toString());
                                            });
                                          });
                                        } else {
                                          avatarImage = await getImageSource(isCamera: file == FileTypes.CAMERA ? true : false);
                                          setState(() {});
                                          appStore.setLoading(false);
                                        }
                                      }
                                    },
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(color: appColorPrimary, shape: BoxShape.circle),
                                      child: Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      height: 280,
                    ),
                    66.height,
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: AppTextField(
                        enabled: !appStore.isLoading,
                        controller: nameCont,
                        focus: name,
                        nextFocus: description,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        textFieldType: TextFieldType.NAME,
                        textStyle: boldTextStyle(),
                        decoration: inputDecoration(
                          context,
                          label: language.name,
                          labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                        ),
                        onChanged: (x) {
                          detailsChanged = true;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: AppTextField(
                        enabled: !appStore.isLoading,
                        controller: descriptionCont,
                        focus: description,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        textFieldType: TextFieldType.NAME,
                        textStyle: boldTextStyle(),
                        decoration: inputDecoration(
                          context,
                          label: language.description,
                          labelStyle: secondaryTextStyle(weight: FontWeight.w600),
                        ),
                        onChanged: (x) {
                          detailsChanged = true;
                        },
                      ),
                    ),
                    24.height,
                    Text(
                      language.privacyOptions,
                      style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 18),
                    ).paddingSymmetric(horizontal: 16),
                    16.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Radio(
                          value: GroupType.PUBLIC,
                          groupValue: groupType,
                          onChanged: (GroupType? value) {
                            if (!appStore.isLoading)
                              setState(() {
                                groupType = value;
                              });
                          },
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(language.thisIsAPublic, style: boldTextStyle()).paddingTop(12),
                            6.height,
                            Column(
                              children: groupTypeRule[0].map((e) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.circle, color: Colors.grey.shade500, size: 8).paddingTop(4),
                                    8.width,
                                    Text(e.validate(), style: secondaryTextStyle(size: 12)).expand(),
                                  ],
                                ).paddingSymmetric(vertical: 2);
                              }).toList(),
                            ).paddingOnly(right: 16),
                          ],
                        ).expand(),
                      ],
                    ).onTap(() {
                      detailsChanged = true;

                      setState(() {
                        groupType = GroupType.PUBLIC;
                      });
                    }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                    16.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Radio(
                          value: GroupType.PRIVATE,
                          groupValue: groupType,
                          onChanged: (GroupType? value) {
                            detailsChanged = true;
                            setState(() {
                              groupType = value;
                            });
                          },
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(language.thisIsAPrivate, style: boldTextStyle()).paddingTop(12),
                            6.height,
                            Column(
                              children: groupTypeRule[1].map((e) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.circle, color: Colors.grey.shade500, size: 8).paddingTop(4),
                                    8.width,
                                    Text(e.validate(), style: secondaryTextStyle(size: 12)).expand(),
                                  ],
                                ).paddingSymmetric(vertical: 2);
                              }).toList(),
                            ).paddingOnly(right: 16),
                          ],
                        ).expand(),
                      ],
                    ).onTap(() {
                      detailsChanged = true;
                      setState(() {
                        groupType = GroupType.PRIVATE;
                      });
                    }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                    16.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Radio(
                          value: GroupType.HIDDEN,
                          groupValue: groupType,
                          onChanged: (GroupType? value) {
                            detailsChanged = true;

                            setState(() {
                              groupType = value;
                            });
                          },
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(language.thisIsAHidden, style: boldTextStyle()).paddingTop(12),
                            6.height,
                            Column(
                              children: groupTypeRule[2].map((e) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.circle, color: Colors.grey.shade500, size: 8).paddingTop(4),
                                    8.width,
                                    Text(e.validate(), style: secondaryTextStyle(size: 12)).expand(),
                                  ],
                                ).paddingSymmetric(vertical: 2);
                              }).toList(),
                            ).paddingOnly(right: 16),
                          ],
                        ).expand(),
                      ],
                    ).onTap(() {
                      detailsChanged = true;

                      setState(() {
                        groupType = GroupType.HIDDEN;
                      });
                    }),
                    16.height,
                    Text(language.groupForum, style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite, size: 18)).paddingSymmetric(horizontal: 16),
                    10.height,
                    Text(language.groupAsForumText, style: secondaryTextStyle()).paddingSymmetric(horizontal: 16),
                    16.height,
                    Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: radius(2)),
                          activeColor: context.primaryColor,
                          value: enableForum,
                          onChanged: (val) {
                            enableForum = !enableForum;
                            setState(() {});
                          },
                        ),
                        Text(language.wantGroupAsForum, style: secondaryTextStyle()).onTap(() {
                          enableForum = !enableForum;
                          setState(() {});
                        }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                      ],
                    ),
                  ],
                ),
              ),
              LoadingWidget().visible(appStore.isLoading).center(),
            ],
          ),
          bottomNavigationBar: appStore.isLoading
              ? Offstage()
              : Padding(
                  padding: EdgeInsets.all(16),
                  child: appButton(
                    context: context,
                    text: language.update.capitalizeFirstLetter(),
                    onTap: () async {
                      ifNotTester(() async {
                        if (nameCont.text.isNotEmpty && detailsChanged) {
                          Map request = {
                            "name": nameCont.text,
                            "description": descriptionCont.text,
                            "status": groupType == GroupType.PUBLIC
                                ? AccountType.public
                                : groupType == GroupType.PRIVATE
                                    ? AccountType.private
                                    : AccountType.hidden,
                          };

                          await updateGroup(request: request, groupId: widget.groupId.validate()).then((value) {
                            toast(language.groupUpdatedSuccessfully, print: true);
                          }).catchError((e) {
                            toast(e.toString(), print: true);
                          });
                        }

                        if (avatarImage != null) {
                          await groupAttachImage(id: widget.groupId.validate(), image: avatarImage).then((value) => init());
                        }

                        if (cover != null) {
                          await groupAttachImage(id: widget.groupId.validate(), image: cover, isCoverImage: true).then((value) => init());
                        }

                        finish(context, true);
                      });
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
