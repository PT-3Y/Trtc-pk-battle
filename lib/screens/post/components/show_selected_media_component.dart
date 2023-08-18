import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/models/common_models.dart';
import 'package:socialv/models/posts/media_model.dart';
import 'package:socialv/utils/app_constants.dart';
import 'package:socialv/utils/cached_network_image.dart';
import 'package:video_player/video_player.dart';

class ShowSelectedMediaComponent extends StatefulWidget {
  final MediaModel mediaType;
  final List<PostMedia> mediaList;
  final List<VideoPlayerController> videoController;

  const ShowSelectedMediaComponent({required this.mediaType, required this.mediaList, required this.videoController});

  @override
  State<ShowSelectedMediaComponent> createState() => _ShowSelectedMediaComponentState();
}

class _ShowSelectedMediaComponentState extends State<ShowSelectedMediaComponent> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoController.forEach((element) {
      element.dispose();
    });
    widget.videoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaType.type == MediaTypes.photo) {
      return HorizontalList(
        itemCount: widget.mediaList.length,
        itemBuilder: (context, index) {
          PostMedia media = widget.mediaList[index];
          return Padding(
            padding: index == 0 ? EdgeInsets.only(left: 8) : EdgeInsets.all(0),
            child: Stack(
              children: [
                cachedImage(media.isLink ? media.link : media.file!.path.validate(), height: 80, width: 80, fit: BoxFit.cover).cornerRadiusWithClipRRect(commonRadius),
                Positioned(
                  child: Icon(Icons.cancel_outlined, color: context.primaryColor, size: 18).onTap(() {
                    if (!appStore.isLoading) {
                      widget.mediaList.remove(widget.mediaList[index]);
                      setState(() {});
                    }
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  right: 4,
                  top: 4,
                ),
              ],
            ),
          );
        },
      );
    } else if (widget.mediaType.type == MediaTypes.video) {
      return HorizontalList(
        itemCount: widget.videoController.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: index == 0 ? EdgeInsets.only(left: 8) : EdgeInsets.all(0),
            child: Stack(
              children: [
                widget.videoController[index].value.isInitialized
                    ? Container(
                        width: 80,
                        height: 80,
                        child: VideoPlayer(widget.videoController[index]).cornerRadiusWithClipRRect(commonRadius),
                      )
                    : Container(
                        decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
                        height: 80,
                        width: 80,
                        padding: EdgeInsets.all(20),
                        child: Image.asset(ic_video, height: 20, width: 20, fit: BoxFit.cover),
                      ),
                Positioned(
                  child: Icon(Icons.cancel_outlined, color: context.primaryColor, size: 18).onTap(() {
                    if (!appStore.isLoading) {
                      widget.mediaList.remove(widget.mediaList[index]);
                      widget.videoController.removeAt(index);
                      setState(() {});
                    }
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  right: 4,
                  top: 4,
                ),
              ],
            ),
          );
        },
      );
    } else if (widget.mediaType.type == MediaTypes.audio) {
      return HorizontalList(
        itemCount: widget.mediaList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: index == 0 ? EdgeInsets.only(left: 8) : EdgeInsets.all(0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
                  height: 80,
                  width: 80,
                  padding: EdgeInsets.all(20),
                  child: Image.asset(ic_voice, height: 20, width: 20, fit: BoxFit.cover),
                ),
                Positioned(
                  child: Icon(Icons.cancel_outlined, color: context.primaryColor, size: 18).onTap(() {
                    if (!appStore.isLoading) {
                      widget.mediaList.remove(widget.mediaList[index]);
                      setState(() {});
                    }
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  right: 4,
                  top: 4,
                ),
              ],
            ),
          );
        },
      );
    } else {
      return HorizontalList(
        itemCount: widget.mediaList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: index == 0 ? EdgeInsets.only(left: 8) : EdgeInsets.all(0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(commonRadius)),
                  height: 80,
                  width: 80,
                  padding: EdgeInsets.all(20),
                  child: Image.asset(ic_document, height: 20, width: 20, fit: BoxFit.cover),
                ),
                Positioned(
                  child: Icon(Icons.cancel_outlined, color: context.primaryColor, size: 18).onTap(() {
                    if (!appStore.isLoading) {
                      widget.mediaList.remove(widget.mediaList[index]);
                      setState(() {});
                    }
                  }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  right: 4,
                  top: 4,
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
