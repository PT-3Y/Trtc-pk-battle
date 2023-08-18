import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/utils/app_constants.dart';

class CreateVideoStory extends StatefulWidget {
  final File videoFile;
  final bool isShowControllers;

  CreateVideoStory({required this.videoFile, this.isShowControllers = true});

  @override
  State<CreateVideoStory> createState() => _CreateVideoStoryState();
}

class _CreateVideoStoryState extends State<CreateVideoStory> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  @override
  void initState() {
    super.initState();

    videoPlayerController = VideoPlayerController.file(widget.videoFile)..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return CustomVideoPlayer(
      customVideoPlayerController: _customVideoPlayerController,
    );
  }
}

class CreateVideoThumbnail extends StatefulWidget {
  final File? videoFile;

  const CreateVideoThumbnail({this.videoFile});

  @override
  State<CreateVideoThumbnail> createState() => _CreateVideoThumbnailState();
}

class _CreateVideoThumbnailState extends State<CreateVideoThumbnail> {
  late VideoPlayerController controller;

  @override
  void initState() {
    controller = VideoPlayerController.file(widget.videoFile!)
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return controller.value.isInitialized ? VideoPlayer(controller).cornerRadiusWithClipRRect(defaultAppButtonRadius) : Image.asset(ic_video, height: 20, width: 20, fit: BoxFit.cover);
  }
}

class ShowVideoThumbnail extends StatefulWidget {
  final String? videoUrl;

  const ShowVideoThumbnail({this.videoUrl});

  @override
  State<ShowVideoThumbnail> createState() => ShowVideoThumbnailState();
}

class ShowVideoThumbnailState extends State<ShowVideoThumbnail> {
  late VideoPlayerController controller;

  @override
  void initState() {
    controller = VideoPlayerController.network(widget.videoUrl!)
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return controller.value.isInitialized ? VideoPlayer(controller).cornerRadiusWithClipRRect(24) : Image.asset(ic_video, height: 18, width: 18, fit: BoxFit.cover).paddingAll(8);
  }
}
