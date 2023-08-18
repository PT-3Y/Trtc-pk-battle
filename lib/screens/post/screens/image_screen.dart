import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';

import '../../../utils/app_constants.dart';

class ImageScreen extends StatefulWidget {
  final String imageURl;

  ImageScreen({required this.imageURl});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColorBasedOnTheme();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardDarkColor,
      appBar: AppBar(
        backgroundColor: cardDarkColor,
        leading: BackButton(color: Colors.white),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: cardDarkColor,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(widget.imageURl.validate()),
        minScale: PhotoViewComputedScale.contained,
      ),
    );
  }
}
