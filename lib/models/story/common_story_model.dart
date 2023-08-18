import 'dart:io';

/// Common Story Models

List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
List<String> allowedVideoExtensions = ['mp4', 'mov', 'wmv', 'avi', 'mpg', '3gp'];

class CreateStoryModel {
  String? storyText;
  String? storyLink;
  String storyDuration;

  CreateStoryModel({this.storyText, this.storyLink,required this.storyDuration});
}

class MediaSourceModel {
  File mediaFile;
  String extension;
  String mediaType;

  MediaSourceModel({required this.mediaFile, required this.extension, required this.mediaType});
}
