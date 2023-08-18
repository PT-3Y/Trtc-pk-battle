import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/components/no_data_lottie_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/story/highlight_stories_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/stories/screen/highlight_story_page.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class HighlightComponent extends StatefulWidget {
  final VoidCallback? callback;
  final VoidCallback? addStory;
  final List<HighlightStoriesModel> highlightList;
  final String status;

  const HighlightComponent({this.callback, this.addStory, required this.highlightList, required this.status});

  @override
  State<HighlightComponent> createState() => _HighlightComponentState();
}

class _HighlightComponentState extends State<HighlightComponent> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Stack(
        children: [
          if (widget.highlightList.isNotEmpty)
            AnimatedListView(
              disposeScrollController: false,
              shrinkWrap: true,
              slideConfiguration: SlideConfiguration(delay: 80.milliseconds, verticalOffset: 300),
              itemCount: widget.highlightList.validate().length,
              padding: EdgeInsets.only(bottom: 60),
              itemBuilder: (ctx, index) {
                HighlightStoriesModel story = widget.highlightList.validate()[index];
                return InkWell(
                  onTap: () {
                    HighlightStoryPage(
                      showDelete: true,
                      avatarImage: appStore.loginAvatarUrl,
                      initialIndex: index,
                      stories: widget.highlightList,
                      callback: () {
                        widget.callback?.call();
                      },
                    ).launch(context);
                  },
                  child: Row(
                    children: [
                      story.categoryImage != null
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
                      16.width,
                      Text(story.categoryName.validate(), style: primaryTextStyle()).expand(),
                      if (widget.status == StoryHighlightOptions.trash)
                        IconButton(
                          icon: Icon(Icons.restart_alt_outlined, color: context.primaryColor),
                          onPressed: () {
                            ifNotTester(() {
                              appStore.setLoading(true);

                              deleteStory(storyId: story.categoryId.validate(), type: StoryHighlightOptions.category, status: StoryHighlightOptions.publish).then((value) {
                                toast(value.message);
                                appStore.setLoading(false);
                                widget.callback?.call();
                              }).catchError((e) {
                                appStore.setLoading(false);

                                toast(e.toString());
                              });
                            });
                          },
                        ),
                      if (widget.status == StoryHighlightOptions.draft)
                        IconButton(
                          icon: cachedImage(ic_send, color: context.primaryColor, height: 24, width: 24, fit: BoxFit.cover),
                          onPressed: () {
                            ifNotTester(() {
                              appStore.setLoading(true);

                              deleteStory(storyId: story.categoryId.validate(), type: StoryHighlightOptions.category, status: StoryHighlightOptions.publish).then((value) {
                                toast(value.message);
                                appStore.setLoading(false);
                                widget.callback?.call();
                              }).catchError((e) {
                                appStore.setLoading(false);

                                toast(e.toString());
                              });
                            });
                          },
                        ),
                      InkWell(
                        child: cachedImage(ic_delete, color: Colors.red, width: 24, height: 24),
                        onTap: () {
                          if (widget.status == StoryHighlightOptions.publish) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: context.cardColor,
                                      borderRadius: radius(),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
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
                          } else {
                            showConfirmDialogCustom(
                              context,
                              onAccept: (c) {
                                ifNotTester(() {
                                  appStore.setLoading(true);

                                  deleteStory(storyId: story.categoryId.validate(), type: StoryHighlightOptions.category, status: StoryHighlightOptions.delete).then((value) {
                                    toast(value.message);
                                    appStore.setLoading(false);
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
                          }
                        },
                      ),
                    ],
                  ).paddingSymmetric(vertical: 8, horizontal: 16),
                );
              },
            ),
          if ((widget.highlightList.isEmpty || widget.highlightList[0].items!.isEmpty) && !appStore.isLoading)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EmptyPostLottieWidget(),
                Text(
                  language.addStoryText,
                  style: secondaryTextStyle(),
                  textAlign: TextAlign.center,
                ).paddingSymmetric(horizontal: 32),
                16.height,
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                    side: MaterialStateProperty.all(BorderSide(color: appColorPrimary.withOpacity(0.5))),
                  ),
                  onPressed: () {
                    widget.addStory?.call();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 20, color: context.iconColor),
                      4.width,
                      Text(language.addYourStory, style: primaryTextStyle(size: 14)),
                    ],
                  ),
                ),
              ],
            ).center(),
          LoadingWidget().center().visible(appStore.isLoading),
        ],
      ),
    );
  }
}
