import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/story/highlight_category_list_model.dart';
import 'package:socialv/models/story/highlight_stories_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/dashboard_screen.dart';
import 'package:socialv/screens/stories/component/new_story_highlight_dialog.dart';
import 'package:socialv/screens/stories/screen/highlight_story_page.dart';
import 'package:socialv/utils/cached_network_image.dart';

import '../../../../utils/app_constants.dart';

class StoryHighlightsComponent extends StatefulWidget {
  final List<HighlightStoriesModel>? highlightsList;
  final List<HighlightCategoryListModel>? categoryList;
  final String? avatarImage;
  final bool showAddOption;
  final VoidCallback? callback;

  StoryHighlightsComponent({this.highlightsList, this.avatarImage, this.categoryList, this.showAddOption = true, this.callback});

  @override
  State<StoryHighlightsComponent> createState() => _StoryHighlightsComponentState();
}

class _StoryHighlightsComponentState extends State<StoryHighlightsComponent> with TickerProviderStateMixin {
  List<HighlightStoriesModel> list = [];

  @override
  void initState() {
    super.initState();
    list = widget.highlightsList.validate();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    list = widget.highlightsList.validate();

    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.showAddOption && list.isNotEmpty) Text(language.storyHighlights, style: boldTextStyle()).paddingSymmetric(horizontal: 16),
            Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.showAddOption)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(color: appColorPrimary, shape: BoxShape.circle),
                                  child: cachedImage(appStore.loginAvatarUrl, height: 60, width: 60, fit: BoxFit.cover).cornerRadiusWithClipRRect(100),
                                ),
                                Positioned(
                                  bottom: -6,
                                  right: 10,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: appColorPrimary,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: context.scaffoldBackgroundColor, width: 2),
                                    ),
                                    child: Icon(Icons.add, color: Colors.white, size: 16),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return NewStoryHighlightDialog(
                                    highlightList: widget.categoryList.validate(),
                                    callback: () {
                                      widget.callback?.call();
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          10.height,
                          Text(language.highlights, style: secondaryTextStyle(size: 12, color: appColorPrimary, weight: FontWeight.w500)),
                        ],
                      ),
                    if (list.isNotEmpty)
                      HorizontalList(
                        padding: EdgeInsets.only(left: widget.showAddOption ? 0 : 8, top: 8, bottom: 8, right: 8),
                        spacing: 4,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          HighlightStoriesModel story = list[index];

                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              HighlightStoryPage(
                                showDelete: widget.showAddOption,
                                avatarImage: widget.avatarImage.validate(),
                                initialIndex: index,
                                stories: list,
                                callback: () {
                                  widget.callback?.call();
                                },
                              ).launch(context);
                            },
                            onLongPress: () async {
                              if (widget.showAddOption && storyActions.validate().isNotEmpty)
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: Container(
                                        decoration: BoxDecoration(color: context.cardColor, borderRadius: radius()),
                                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (storyActions.validate().any((element) => element.action == StoryHighlightOptions.delete))
                                              TextIcon(
                                                text: language.deletePermanently,
                                                prefix: cachedImage(ic_delete, height: 20, width: 20, fit: BoxFit.cover, color: Colors.red),
                                                textStyle: primaryTextStyle(color: Colors.red),
                                                onTap: () {
                                                  finish(context);
                                                  showConfirmDialogCustom(
                                                    context,
                                                    onAccept: (c) {
                                                      ifNotTester(() {
                                                        appStore.setLoading(true);

                                                        deleteStory(storyId: story.categoryId.validate(), type: StoryHighlightOptions.category, status: StoryHighlightOptions.delete).then((value) {
                                                          toast(value.message);
                                                          appStore.setLoading(false);
                                                          LiveStream().emit(OnAddPostProfile);
                                                          widget.callback?.call();
                                                        }).catchError((e) {
                                                          appStore.setLoading(false);

                                                          toast(e.toString());
                                                        });
                                                      });
                                                    },
                                                    dialogType: DialogType.DELETE,
                                                    title: language.deleteStoryConfirmation,
                                                    positiveText: language.delete,
                                                  );
                                                },
                                              ),
                                            Divider(),
                                            if (storyActions.validate().any((element) => element.action == StoryHighlightOptions.trash))
                                              TextIcon(
                                                text: language.moveToTrash,
                                                prefix: cachedImage(ic_delete, height: 20, width: 20, fit: BoxFit.cover, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                                                textStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
                                                onTap: () {
                                                  finish(context);
                                                  showConfirmDialogCustom(
                                                    context,
                                                    onAccept: (c) {
                                                      ifNotTester(() {
                                                        appStore.setLoading(true);

                                                        deleteStory(storyId: story.categoryId.validate(), status: StoryHighlightOptions.trash, type: StoryHighlightOptions.category).then((value) {
                                                          toast(value.message);
                                                          appStore.setLoading(false);
                                                          LiveStream().emit(OnAddPostProfile);
                                                          widget.callback?.call();
                                                        }).catchError((e) {
                                                          appStore.setLoading(false);

                                                          toast(e.toString());
                                                        });
                                                      });
                                                    },
                                                    dialogType: DialogType.DELETE,
                                                    title: language.trashConfirmationText,
                                                    positiveText: language.delete,
                                                  );
                                                },
                                              ),
                                            Divider(),
                                            TextIcon(
                                              text: language.cancel,
                                              textStyle: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite),
                                              prefix: cachedImage(ic_close_square, height: 18, width: 18, fit: BoxFit.cover, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                            },
                            child: SizedBox(
                              width: 70,
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Hero(
                                        tag: "${story.categoryName}",
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: context.scaffoldBackgroundColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.grey.withOpacity(0.5), width: 2),
                                          ),
                                          padding: EdgeInsets.all(2),
                                          child: story.categoryImage != null
                                              ? cachedImage(
                                                  story.categoryImage,
                                                  height: 54,
                                                  width: 54,
                                                  fit: BoxFit.cover,
                                                ).cornerRadiusWithClipRRect(100)
                                              : story.items.validate().first.mediaType.validate() == MediaTypes.video
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: context.cardColor,
                                                      ),
                                                      padding: EdgeInsets.all(10),
                                                      child: cachedImage(
                                                        ic_video,
                                                        height: 32,
                                                        width: 32,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : cachedImage(
                                                      story.items.validate().first.storyMedia.validate(),
                                                      height: 54,
                                                      width: 54,
                                                      fit: BoxFit.cover,
                                                    ).cornerRadiusWithClipRRect(100),
                                        ),
                                      ),
                                    ],
                                  ),
                                  10.height,
                                  Text(
                                    story.categoryName.validate(),
                                    style: secondaryTextStyle(size: 12, color: context.iconColor, weight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
