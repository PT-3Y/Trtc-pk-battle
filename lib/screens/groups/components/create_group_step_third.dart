import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/file_picker_dialog_component.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/groups/screens/create_group_screen.dart';

import '../../../main.dart';
import '../../../utils/app_constants.dart';

class CreateGroupStepThird extends StatefulWidget {
  final Function(int) onNextPage;

  CreateGroupStepThird({required this.onNextPage});

  @override
  State<CreateGroupStepThird> createState() => _CreateGroupStepThirdState();
}

class _CreateGroupStepThirdState extends State<CreateGroupStepThird> {
  File? _coverImage;
  File? _avatarImage;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("3. ${language.chooseAvatarCoverImage}", style: primaryTextStyle(size: 18, color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                  16.height,
                  Container(
                    height: 180,
                    width: context.width(),
                    child: _avatarImage != null
                        ? Stack(
                            children: [
                              Image.file(
                                _avatarImage!,
                                width: context.width(),
                                fit: BoxFit.cover,
                              ).cornerRadiusWithClipRRect(defaultAppButtonRadius),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  margin: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: context.primaryColor.withOpacity(0.5),
                                    border: Border.all(color: context.primaryColor),
                                  ),
                                  child: Icon(Icons.close, color: Colors.white, size: 18),
                                ).onTap(() async {
                                  if (!appStore.isLoading)
                                    await deleteAvatarImage(id: groupId.toString().validate(), isGroup: true).then((value) {
                                      setState(() {
                                        _avatarImage = null;
                                      });
                                    }).catchError((e) {
                                      toast(language.somethingWentWrong);
                                    });
                                }),
                              ),
                            ],
                          )
                        : DottedBorderWidget(
                            radius: defaultAppButtonRadius,
                            dotsWidth: 8,
                            child: TextButton(
                              onPressed: () async {
                                if (!appStore.isLoading) {
                                  FileTypes file = await showInDialog(
                                    context,
                                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                                    title: Text(language.chooseAnAction, style: boldTextStyle()),
                                    builder: (p0) {
                                      return FilePickerDialog(isSelected: true);
                                    },
                                  );
                                  await getImageSource(isCamera: file == FileTypes.CAMERA ? true : false).then((value) async {
                                    ifNotTester(() async {
                                      appStore.setLoading(true);
                                      await groupAttachImage(id: groupId.validate(), image: value).then((_) {
                                        appStore.setLoading(false);
                                        _avatarImage = value;
                                        setState(() {});
                                      }).catchError((e) {
                                        appStore.setLoading(false);
                                        toast(language.somethingWentWrong);
                                      });
                                    });
                                  }).catchError((e) {
                                    setState(() {
                                      _avatarImage = null;
                                    });
                                    log(e.toString());
                                  });
                                }
                              },
                              child: Text(
                                '+ ${language.addAvatarImage}',
                                style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
                              ).center(),
                            ),
                          ),
                  ),
                  16.height,
                  Container(
                    height: 180,
                    width: context.width(),
                    child: _coverImage != null
                        ? Stack(
                            children: [
                              Image.file(
                                _coverImage!,
                                width: context.width(),
                                fit: BoxFit.cover,
                              ).cornerRadiusWithClipRRect(defaultAppButtonRadius),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  margin: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: context.primaryColor.withOpacity(0.5),
                                    border: Border.all(color: context.primaryColor),
                                  ),
                                  child: Icon(Icons.close, color: Colors.white, size: 18),
                                ).onTap(() async {
                                  if (!appStore.isLoading)
                                    await deleteGroupCoverImage(id: groupId.validate()).then((value) {
                                      setState(() {
                                        _coverImage = null;
                                      });
                                    }).catchError((e) {
                                      toast(language.somethingWentWrong);
                                    });
                                }),
                              ),
                            ],
                          )
                        : DottedBorderWidget(
                            radius: defaultAppButtonRadius,
                            dotsWidth: 8,
                            child: TextButton(
                              onPressed: () async {
                                if (!appStore.isLoading) {
                                  FileTypes file = await showInDialog(
                                    context,
                                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                                    title: Text(language.chooseAnAction, style: boldTextStyle()),
                                    builder: (p0) {
                                      return FilePickerDialog(isSelected: true);
                                    },
                                  );
                                  await getImageSource(isCamera: file == FileTypes.CAMERA ? true : false).then((value) async {
                                    ifNotTester(() async {
                                      appStore.setLoading(true);
                                      await groupAttachImage(id: groupId.validate(), image: value, isCoverImage: true).then((_) {
                                        appStore.setLoading(false);
                                        _coverImage = value;
                                        setState(() {});
                                      }).catchError((e) {
                                        appStore.setLoading(false);
                                        toast(language.somethingWentWrong);
                                      });
                                    });
                                  }).catchError((e) {
                                    setState(() {
                                      _coverImage = null;
                                    });
                                    log(e.toString());
                                  });
                                }
                              },
                              child: Text(
                                '+ ${language.addCoverImage}',
                                style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
                              ).center(),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: context.width(),
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                color: context.cardColor,
                child: appButton(
                  onTap: () {
                    widget.onNextPage.call(3);
                  },
                  color: context.primaryColor,
                  text: language.next.capitalizeFirstLetter(),
                  context: context,
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
