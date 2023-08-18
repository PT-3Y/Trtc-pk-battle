import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/loading_widget.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/story/story_response_model.dart';
import 'package:socialv/network/rest_apis.dart';
import 'package:socialv/screens/post/components/video_post_component.dart';
import 'package:socialv/screens/post/screens/video_post_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';
import 'package:story_time/story_time.dart';

class StoryPage extends StatefulWidget {
  final VoidCallback? callback;
  final int initialIndex;
  final int? initialStoryIndex;
  final List<StoryResponseModel> stories;
  final bool fromUserStory;

  StoryPage({required this.initialIndex, this.initialStoryIndex, required this.stories, this.callback, this.fromUserStory = false});

  @override
  StoryPageState createState() => StoryPageState();
}

class StoryPageState extends State<StoryPage> {
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
      if (!widget.fromUserStory) indicatorAnimationController.value = IndicatorAnimationCommand(pause: true);
    });

    userIndex = widget.initialIndex;
    storyIndex = widget.initialStoryIndex ?? 0;
    setStatusBarColor(Colors.transparent);
  }

  @override
  void dispose() {
    if (widget.fromUserStory && storyViewed) widget.callback?.call();
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

            if (!widget.stories[userIndex].items!.validate()[storyIndex].seen.validate())
              viewStory(storyId: widget.stories[userIndex].items![storyIndex].id.validate()).then((value) {
                if (!storyViewed) storyViewed = true;
              }).catchError((e) {
                toast(e.toString());
              });

            return Hero(
              tag: user.name.validate(),
              child: Material(
                type: MaterialType.transparency,
                child: Stack(
                  children: [
                    Positioned.fill(child: Container(color: Colors.black)),
                    Positioned.fill(
                      child: story.mediaType == MediaTypes.photo
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
                          cachedImage(user.avatarUrl, fit: BoxFit.cover, height: 48, width: 48).cornerRadiusWithClipRRect(24),
                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${user.name.validate()} ',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: fontFamily,
                                      ),
                                    ),
                                    if (user.isUserVerified.validate()) WidgetSpan(child: Image.asset(ic_tick_filled, height: 18, width: 18, color: blueTickColor, fit: BoxFit.cover)),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),
                              Text(timeStampToDate(story.time.validate()), style: secondaryTextStyle(color: Colors.white)),
                            ],
                          ).flexible(flex: 1),
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
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      color: Colors.white,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
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
