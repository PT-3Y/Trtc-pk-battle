import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/app_constants.dart';

class FilePickerDialog extends StatelessWidget {
  final bool isSelected;
  final bool showCameraVideo;

  FilePickerDialog({this.isSelected = false, this.showCameraVideo = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingItemWidget(
            title: language.removeImage,
            titleTextStyle: primaryTextStyle(),
            leading: Icon(Icons.close, color: context.iconColor),
            onTap: () {
              finish(context, FileTypes.CANCEL);
            },
          ).visible(!isSelected),
          SettingItemWidget(
            title: language.camera,
            titleTextStyle: primaryTextStyle(),
            leading: Icon(LineIcons.camera, color: context.iconColor),
            onTap: () {
              finish(context, FileTypes.CAMERA);
            },
          ),
          SettingItemWidget(
            title: language.videoCamera,
            titleTextStyle: primaryTextStyle(),
            leading: Icon(LineIcons.video_1, color: context.iconColor),
            onTap: () {
              finish(context, FileTypes.CAMERA_VIDEO);
            },
          ).visible(showCameraVideo),
          SettingItemWidget(
            title: language.gallery,
            titleTextStyle: primaryTextStyle(),
            leading: Icon(LineIcons.image_1, color: context.iconColor),
            onTap: () {
              finish(context, FileTypes.GALLERY);
            },
          ),
        ],
      ),
    );
  }
}
