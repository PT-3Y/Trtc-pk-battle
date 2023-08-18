import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/screens/post/components/video_post_component.dart';

class VideoPostScreen extends StatelessWidget {
  final String videoUrl;

  const VideoPostScreen(this.videoUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.iconColor),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.iconColor),
          onPressed: () {
            finish(context);
          },
        ),
      ),
      body: VideoPostComponent(videoURl: videoUrl),
    );
  }
}
