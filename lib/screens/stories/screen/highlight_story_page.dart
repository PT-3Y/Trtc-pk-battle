import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/story/highlight_stories_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/post/components/video_post_component.dart';
import 'package:socialv/screens/post/screens/video_post_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';
import 'package:story_time/story_time.dart';

class HighlightStoryPage extends StatefulWidget {
  final int initialIndex;
  final List<HighlightStoriesModel> stories;
  final String? avatarImage;
  final VoidCallback? callback;
  final bool showDelete;

  HighlightStoryPage({required this.initialIndex, required this.stories, this.avatarImage, this.callback, required this.showDelete});

  @override
  HighlightStoryPageState createState() => HighlightStoryPageState();
}

class HighlightStoryPageState extends State<HighlightStoryPage> {
  TextEditingController messageController = TextEditingController();

  FocusNode message = FocusNode();

  late ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;

  Offset offset = Offset.zero;
  final double height = 200;
  final double width = 200;

  int userIndex = 0;
  int storyIndex = 0;
  int currentStoryIndex = 0;

  bool isStoryLoading = true;
  bool storyViewed = false;

  @override
  void initState() {
    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(IndicatorAnimationCommand(resume: true));

    super.initState();

    afterBuildCreated(() {
      indicatorAnimationController.value = IndicatorAnimationCommand(pause: true);
    });

    userIndex = widget.initialIndex;
    storyIndex = 0;
    setStatusBarColor(Colors.transparent);
  }

  @override
  void dispose() {
    setStatusBarColorBasedOnTheme();
    indicatorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10) {
            finish(context);
          }
        },
        child: StoryPageView(
          onStoryIndexChanged: (int newStoryIndex) async {
            storyIndex = 0;

            indicatorAnimationController.value = IndicatorAnimationCommand(pause: true);
          },
          itemBuilder: (context, pageIndex, storyIndex) {
            userIndex = pageIndex;
            currentStoryIndex = storyIndex;
            final user = widget.stories[pageIndex];
            final story = user.items.validate()[storyIndex];

            return Hero(
              tag: user.categoryName.validate(),
              child: Material(
                type: MaterialType.transparency,
                child: Stack(
                  children: [
                    Positioned.fill(child: Container(color: Colors.black)),
                    Positioned.fill(
                      child: story.mediaType == MediaTypes.image
                          ? CachedNetworkImage(
                              imageUrl: story.storyMedia.validate(),
                              width: context.width(),
                              height: context.height(),
                              imageBuilder: (context, imageProvider) {
                                int duration = widget.stories[userIndex].items.validate()[storyIndex].duration.validate().toInt();

                                indicatorAnimationController.value = IndicatorAnimationCommand(duration: Duration(seconds: duration), resume: true);
                                return Container(
                                  width: context.width(),
                                  height: context.height(),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              },
                              placeholder: (_, x) {
                                return LoadingWidget();
                              },
                            )
                          : StoryVideoPostComponent(
                              videoURl: story.storyMedia.validate(),
                              callBack: () {
                                int duration = widget.stories[userIndex].items.validate()[storyIndex].duration.validate().toInt();

                                indicatorAnimationController.value = IndicatorAnimationCommand(duration: Duration(seconds: duration), resume: true);
                              },
                            ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            ...List<Color>.generate(20, (index) => Colors.grey.shade700.withAlpha(index * 10)).reversed,
                            Colors.transparent,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.only(top: 46, left: 16, bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          cachedImage(user.categoryImage != null ? user.categoryImage : widget.avatarImage, fit: BoxFit.cover, height: 48, width: 48).cornerRadiusWithClipRRect(24),
                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${user.categoryName.validate()} ',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),
                              Text(timeStampToDate(story.time.validate()), style: secondaryTextStyle(color: Colors.white)),
                            ],
                          ).expand(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          gestureItemBuilder: (context, pageIndex, storyIndex) {
            final user = widget.stories[pageIndex];
            final story = user.items.validate()[storyIndex];
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          color: Colors.white,
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        if (widget.showDelete)
                          Theme(
                            data: Theme.of(context).copyWith(useMaterial3: false),
                            child: PopupMenuButton(
                              enabled: !appStore.isLoading,
                              position: PopupMenuPosition.under,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(commonRadius)),
                              onSelected: (val) async {
                                finish(context);

                                showConfirmDialogCustom(
                                  context,
                                  onAccept: (c) async {
                                    ifNotTester(() {
                                      appStore.setLoading(true);

                                      deleteStory(
                                        storyId: story.id.validate(),
                                        type: StoryHighlightOptions.story,
                                        status: val == 1 ? StoryHighlightOptions.trash : StoryHighlightOptions.delete,
                                      ).then((value) {
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
                                  title: val == 1 ? language.trashConfirmationText : language.deleteStoryConfirmation,
                                  positiveText: language.delete,
                                );
                              },
                              icon: Icon(Icons.more_horiz, color: Colors.white),
                              itemBuilder: (context) => <PopupMenuEntry>[
                                PopupMenuItem(
                                  value: 1,
                                  child: Text(language.moveToTrash, style: primaryTextStyle(color: appStore.isDarkMode ? bodyDark : bodyWhite)),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Text(language.deletePermanently, style: primaryTextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ),
                        8.width,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: Column(
                    children: [
                      if (story.storyText.validate().isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          width: context.width(),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
                          child: Text(story.storyText.validate(), style: boldTextStyle(color: Colors.white), textAlign: TextAlign.center),
                        ),
                      16.height,
                      if (story.storyLink.validate().isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: radius(defaultRadius)),
                          child: Text(language.visitLink, style: boldTextStyle(color: Colors.white)),
                        ).onTap(() {
                          openWebPage(context, url: story.storyLink.validate());
                        }, borderRadius: radius(defaultRadius)),
                      if (story.mediaType == MediaTypes.video)
                        TextButton(
                          onPressed: () {
                            VideoPostScreen(story.storyMedia.validate()).launch(context);
                          },
                          child: Text(language.viewVideo, style: boldTextStyle(color: Colors.white)),
                        ),
                    ],
                  ),
                  bottom: 30,
                ),
              ],
            );
          },
          indicatorAnimationController: indicatorAnimationController,
          initialPage: widget.initialIndex,
          pageLength: widget.stories.length,
          storyLength: (int pageIndex) {
            return widget.stories[pageIndex].items.validate().length;
          },
          initialStoryIndex: (x) {
            return storyIndex;
          },
          onPageLimitReached: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
