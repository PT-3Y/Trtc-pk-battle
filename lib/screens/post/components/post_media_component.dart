import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/components/youtube_player_component.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models/post_mdeia_model.dart';
import 'package:socialv/screens/post/components/audio_component.dart';
import 'package:socialv/screens/post/components/video_post_component.dart';
import 'package:socialv/screens/post/screens/audio_post_screen.dart';
import 'package:socialv/screens/post/screens/image_screen.dart';
import 'package:socialv/screens/post/screens/pdf_screen.dart';
import 'package:socialv/screens/post/screens/video_post_screen.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';

class PostMediaComponent extends StatefulWidget {
  final String? mediaType;
  final List<PostMediaModel>? mediaList;
  final bool isFromPostDetail;
  final bool isFromQuickViewDetail;
  final String mediaTitle;
  final Function(int)? onPageChange;
  final int initialPageIndex;

  PostMediaComponent({
    this.isFromQuickViewDetail = false,
    required this.mediaTitle,
    this.mediaType,
    this.mediaList,
    this.isFromPostDetail = false,
    this.onPageChange,
    this.initialPageIndex = 0,
  });

  @override
  State<PostMediaComponent> createState() => _PostMediaComponentState();
}

class _PostMediaComponentState extends State<PostMediaComponent> {
  late PageController pageController;
  late int selectedIndex;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialPageIndex);
    selectedIndex = widget.initialPageIndex;
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaList.validate().isNotEmpty)
      return Stack(
        children: [
          SizedBox(
            height: widget.mediaType == MediaTypes.photo
                ? 300
                : widget.mediaType == MediaTypes.video
                    ? 250
                    : 200,
            width: context.width(),
            child: PageView.builder(
              controller: pageController,
              itemCount: widget.mediaList.validate().length,
              itemBuilder: (context, index) {
                if (widget.mediaType == MediaTypes.photo) {
                  return cachedImage(
                    widget.mediaList.validate()[index].url,
                    height: 300,
                    width: context.width() - 32,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(defaultAppButtonRadius).paddingSymmetric(horizontal: 8).onTap(() {
                    ImageScreen(imageURl: widget.mediaList.validate()[index].url.validate()).launch(context);
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent);
                } else if (widget.mediaType == MediaTypes.audio) {
                  return widget.isFromPostDetail
                      ? AudioPostComponent(audioURl: widget.mediaList.validate()[index].url.validate())
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          padding: EdgeInsets.symmetric(vertical: 40),
                          decoration: BoxDecoration(borderRadius: radius(defaultAppButtonRadius)),
                          child: cachedImage(ic_voice, color: appStore.isDarkMode ? bodyDark : bodyWhite),
                        ).onTap(() {
                          AudioPostScreen(widget.mediaList.validate()[index].url.validate()).launch(context);
                        }, splashColor: Colors.transparent, highlightColor: Colors.transparent);
                } else if (widget.mediaType == MediaTypes.doc) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(borderRadius: radius(defaultAppButtonRadius)),
                    child: cachedImage(
                      ic_document,
                      color: appStore.isDarkMode ? bodyDark : bodyWhite,
                    ),
                  ).onTap(() {
                    PDFScreen(docURl: widget.mediaList.validate()[index].url.validate()).launch(context);
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent);
                } else if (widget.mediaType == MediaTypes.video) {
                  if (widget.mediaList.validate()[index].source.validate() == 'youtube') {
                    return YoutubePlayerComponent(id: widget.mediaList.validate()[index].url.validate().toYouTubeId()).paddingSymmetric(horizontal: 8);
                  } else {
                    return widget.isFromPostDetail
                        ? VideoPostComponent(
                            videoURl: widget.mediaList.validate()[index].url.validate(),
                            isShowControllers: widget.isFromQuickViewDetail,
                          ).cornerRadiusWithClipRRect(10).paddingSymmetric(horizontal: 8)
                        : VideoPostComponent(videoURl: widget.mediaList.validate()[index].url.validate()).onTap(() {
                            VideoPostScreen(widget.mediaList.validate()[index].url.validate()).launch(context);
                          }, splashColor: Colors.transparent, highlightColor: Colors.transparent).cornerRadiusWithClipRRect(10).paddingSymmetric(horizontal: 8);
                  }
                } else if (widget.mediaType == MediaTypes.gif) {
                  return cachedImage(
                    widget.mediaList.validate()[index].url,
                    width: context.width() - 32,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(defaultAppButtonRadius).paddingSymmetric(horizontal: 8);
                } else {
                  return Offstage();
                }
              },
              onPageChanged: (i) {
                widget.onPageChange?.call(i);
                selectedIndex = pageController.page!.round();
                setState(() {});
              },
            ),
          ),
          if (widget.mediaList.validate().length > 1)
            Positioned(
              bottom: widget.mediaType == MediaTypes.photo ? 4 : 0,
              right: 0,
              left: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: widget.mediaList.validate().map((e) {
                  return Icon(
                    Icons.circle,
                    size: selectedIndex == widget.mediaList!.indexOf(e) ? 12 : 8,
                    color: selectedIndex == widget.mediaList!.indexOf(e) ? context.primaryColor : Colors.grey.shade500,
                  ).paddingSymmetric(horizontal: 2);
                }).toList(),
              ),
            ),
        ],
      );
    else
      return Offstage();
  }
}
