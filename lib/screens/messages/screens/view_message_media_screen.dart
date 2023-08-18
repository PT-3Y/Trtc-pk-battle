import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:socialv/models/messages/messages_model.dart';
import 'package:socialv/screens/post/components/video_post_component.dart';
import 'package:socialv/utils/app_constants.dart';

class ViewMessageMediaScreen extends StatefulWidget {
  final List<MessageFiles>? files;

  const ViewMessageMediaScreen({Key? key, this.files}) : super(key: key);

  @override
  State<ViewMessageMediaScreen> createState() => _ViewMessageMediaScreenState();
}

class _ViewMessageMediaScreenState extends State<ViewMessageMediaScreen> {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: widget.files.validate().length,
            itemBuilder: (ctx, index) {
              MessageFiles file = widget.files.validate()[index];
              String type = file.mimeType.validate().substring(0, file.mimeType.validate().indexOf('/'));

              if (type == MediaTypes.video) {
                return VideoPostComponent(videoURl: file.url.validate());
              } else {
                return PhotoView(
                  imageProvider: NetworkImage(file.url.validate()),
                  minScale: PhotoViewComputedScale.contained,
                );
              }
            },
          ),
          Positioned(
            bottom: 20,
            child: DotIndicator(
              unselectedIndicatorColor: Colors.grey,
              indicatorColor: context.primaryColor,
              pageController: pageController,
              pages: widget.files.validate(),
            ),
          ),
        ],
      ),
    );
  }
}
