import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/file_picker_dialog_component.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/story/highlight_category_list_model.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class NewHighlightScreen extends StatefulWidget {
  final List<HighlightCategoryListModel> highlightList;

  const NewHighlightScreen({required this.highlightList});

  @override
  State<NewHighlightScreen> createState() => _NewHighlightScreenState();
}

class _NewHighlightScreenState extends State<NewHighlightScreen> {
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

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
        title: Text(language.highlights, style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
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
                  Text(language.selectCategory, style: boldTextStyle()).paddingSymmetric(vertical: 16),
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
            DottedBorderWidget(
              padding: EdgeInsets.symmetric(vertical: 32),
              radius: defaultAppButtonRadius,
              dotsWidth: 8,
              child: SizedBox(
                width: context.width(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppButton(
                      elevation: 0,
                      color: appColorPrimary,
                      text: language.selectFiles,
                      textStyle: boldTextStyle(color: Colors.white),
                      onTap: () async {
                        //
                      },
                    ),
                    16.height,
                  ],
                ),
              ),
            ),
            16.height,
            AppButton(
              width: context.width(),
              onTap: () async {
                if (showNewCategory) {
                  if (categoryName.text.isNotEmpty) {
                    // onAddStory();
                  } else {
                    toast(language.pleaseAddHighlightName);
                  }
                } else {
                  //onAddStory();
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
    );
  }
}
