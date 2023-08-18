import 'package:flutter/material.dart';

class StoryResponseModel {
  String? avatarUrl;
  List<StoryItem>? items;
  int? lastUpdated;
  String? name;
  bool? seen;
  int? userId;
  bool? isUserVerified;

  AnimationController? animationController;
  bool? showBorder;

  StoryResponseModel({
    this.avatarUrl,
    this.items,
    this.lastUpdated,
    this.name,
    this.seen,
    this.userId,
    this.animationController,
    this.showBorder = true,
    this.isUserVerified,
  });

  factory StoryResponseModel.fromJson(Map<String, dynamic> json) {
    return StoryResponseModel(
      avatarUrl: json['avarat_url'],
      items: json['items'] != null ? (json['items'] as List).map((i) => StoryItem.fromJson(i)).toList() : null,
      lastUpdated: json['lastUpdated'],
      name: json['name'],
      seen: json['seen'],
      userId: json['user_id'],
      isUserVerified: json['is_user_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avarat_url'] = this.avatarUrl;
    data['lastUpdated'] = this.lastUpdated;
    data['name'] = this.name;
    data['seen'] = this.seen;
    data['is_user_verified'] = this.isUserVerified;
    data['user_id'] = this.userId;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

//type 'int' is not a subtype of type 'String?'
class StoryItem {
  String? duration;
  int? id;
  String? mediaType;
  bool? seen;
  String? storyLink;
  String? storyMedia;
  String? storyText;
  int? time;
  int? viewCount;
  String? seenByKey;

  StoryItem({
    this.duration,
    this.id,
    this.mediaType,
    this.seen,
    this.storyLink,
    this.storyMedia,
    this.storyText,
    this.time,
    this.viewCount,
    this.seenByKey,
  });

  factory StoryItem.fromJson(Map<String, dynamic> json) {
    return StoryItem(
      duration: json['duration'].toString(),
      id: json['id'],
      mediaType: json['media_type'],
      seen: json['seen'],
      storyLink: json['story_link'],
      storyMedia: json['story_media'],
      storyText: json['story_text'],
      time: json['time'],
      viewCount: json['view_count'],
      seenByKey: json['seen_by_key'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['id'] = this.id;
    data['media_type'] = this.mediaType;
    data['seen'] = this.seen;
    data['story_link'] = this.storyLink;
    data['story_media'] = this.storyMedia;
    data['story_text'] = this.storyText;
    data['time'] = this.time;
    data['view_count'] = this.viewCount;
    data['seen_by_key'] = this.seenByKey;
    return data;
  }
}
