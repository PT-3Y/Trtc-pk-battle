import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/file_picker_dialog_component.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/story/highlight_category_list_model.dart';
import 'package:socialv/screens/stories/screen/create_story_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class NewStoryHighlightDialog extends StatefulWidget {
  final List<HighlightCategoryListModel> highlightList;
  final VoidCallback? callback;

  NewStoryHighlightDialog({required this.highlightList, this.callback});

  @override
  State<NewStoryHighlightDialog> createState() => _NewStoryHighlightDialogState();
}

class _NewStoryHighlightDialogState extends State<NewStoryHighlightDialog> {
  bool showNewCategory = false;
  TextEditingController categoryName = TextEditingController();

  List<HighlightCategoryListModel> highlightList = [];

  HighlightCategoryListModel dropdownValue = HighlightCategoryListModel();

  File? categoryImage;

  @override
  void initState() {
    super.initState();

    if (widget.highlightList.isNotEmpty) {
      highlightList = widget.highlightList;
      dropdownValue = widget.highlightList.validate().first;
      showNewCategory = false;
      setState(() {});
    } else {
      showNewCategory = true;
      setState(() {});
    }
  }

  Future<void> onAddStory() async {
    FileTypes? file = await showInDialog(
      context,
      contentPadding: EdgeInsets.symmetric(vertical: 16),
      title: Text(language.chooseAnAction, style: boldTextStyle()),
      builder: (p0) {
        return FilePickerDialog(isSelected: true);
      },
    );

    if (file != null) {
      if (file == FileTypes.CAMERA) {
        await getImageSource(isCamera: true).then((value) {
          appStore.setLoading(false);
          finish(context);
          CreateStoryScreen(
            cameraImage: value,
            categoryId: showNewCategory ? '' : dropdownValue.id.validate().toString(),
            categoryName: showNewCategory ? categoryName.text.validate() : dropdownValue.name,
            categoryImage: categoryImage,
            isHighlight: true,
          ).launch(context).then((value) {
            LiveStream().emit(OnAddPostProfile);
            widget.callback?.call();
          });
        }).catchError((e) {
          appStore.setLoading(false);
        });
      } else {
        await getMultipleImages().then((value) {
          appStore.setLoading(false);

          if (value.isNotEmpty) finish(context);

          CreateStoryScreen(
            mediaList: value,
            categoryId: showNewCategory ? '' : dropdownValue.id.validate().toString(),
            categoryName: showNewCategory ? categoryName.text.validate() : dropdownValue.name,
            categoryImage: categoryImage,
            isHighlight: true,
          ).launch(context).then((value) {
            LiveStream().emit(OnAddPostProfile);
            widget.callback?.call();
          });
        }).catchError((e) {
          appStore.setLoading(false);
        });
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius(defaultAppButtonRadius),
          color: context.cardColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (highlightList.isNotEmpty)
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      showNewCategory = !showNewCategory;
                      setState(() {});
                    },
                    child: Text(showNewCategory ? language.selectHighlight : language.createNew, style: primaryTextStyle(color: context.primaryColor)),
                  ),
                ),
              if (highlightList.isEmpty) 16.height,
              if (showNewCategory.validate())
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language.storyHighlightImage, style: boldTextStyle()),
                    16.height,
                    DottedBorderWidget(
                      radius: 60,
                      dotsWidth: 8,
                      color: context.primaryColor,
                      child: categoryImage == null
                          ? InkWell(
                              onTap: () async {
                                FileTypes? file = await showInDialog(
                                  context,
                                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                                  title: Text(language.chooseAnAction, style: boldTextStyle()),
                                  builder: (p0) {
                                    return FilePickerDialog(isSelected: true);
                                  },
                                );

                                if (file != null) {
                                  if (file == FileTypes.CAMERA) {
                                    await getImageSource().then((value) {
                                      appStore.setLoading(false);
                                      categoryImage = value;
                                      setState(() {});
                                    }).catchError((e) {
                                      appStore.setLoading(false);
                                    });
                                  } else {
                                    await getImageSource(isCamera: false).then((value) {
                                      appStore.setLoading(false);
                                      categoryImage = value;
                                      setState(() {});
                                    }).catchError((e) {
                                      appStore.setLoading(false);
                                    });
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: context.cardColor,
                                  shape: BoxShape.circle,
                                ),
                                height: 120,
                                width: 120,
                                child: Text(language.selectImage, style: secondaryTextStyle()).center(),
                              ),
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                cachedImage(
                                  categoryImage!.path,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRect(60),
                                Positioned(
                                  bottom: 8,
                                  child: InkWell(
                                    onTap: () {
                                      categoryImage = null;
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.7), shape: BoxShape.circle),
                                      child: cachedImage(ic_close, color: context.primaryColor, width: 18, height: 18, fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ).center(),
                    8.height,
                    Text(language.recommendedSize, style: secondaryTextStyle(size: 12)).center(),
                    16.height,
                    AppTextField(
                      controller: categoryName,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      textFieldType: TextFieldType.NAME,
                      textStyle: primaryTextStyle(),
                      maxLines: 1,
                      decoration: inputDecorationFilled(context, label: language.highlightName, fillColor: context.scaffoldBackgroundColor),
                    ),
                  ],
                )
              else
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language.selectHighlight, style: boldTextStyle()).paddingSymmetric(vertical: 16),
                    if (dropdownValue.id != null)
                      Container(
                        width: context.width(),
                        decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<HighlightCategoryListModel>(
                              borderRadius: BorderRadius.circular(commonRadius),
                              value: dropdownValue,
                              icon: Icon(Icons.arrow_drop_down, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                              elevation: 8,
                              style: primaryTextStyle(),
                              underline: Container(height: 2, color: appColorPrimary),
                              alignment: Alignment.bottomCenter,
                              isExpanded: true,
                              onChanged: (HighlightCategoryListModel? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: highlightList.map<DropdownMenuItem<HighlightCategoryListModel>>((e) {
                                return DropdownMenuItem<HighlightCategoryListModel>(
                                  value: e,
                                  child: Text(e.name.validate().isNotEmpty ? e.name.validate() : language.untitled, overflow: TextOverflow.ellipsis, maxLines: 1),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              16.height,
              AppButton(
                width: context.width(),
                onTap: () async {
                  if (showNewCategory) {
                    if (categoryName.text.isNotEmpty) {
                      onAddStory();
                    } else {
                      toast(language.pleaseAddCategoryName);
                    }
                  } else {
                    onAddStory();
                  }
                },
                child: Text(language.addStory, style: primaryTextStyle(color: Colors.white)),
                color: context.primaryColor,
                elevation: 0,
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}
