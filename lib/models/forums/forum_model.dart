import 'package:socialv/models/forums/common_models.dart';

class ForumModel {
  String? description;
  List<FreshnessModel>? freshness;
  List<GroupDetail>? groupDetails;
  int? id;
  String? postCount;
  String? title;
  String? topicCount;
  String? type;
  int? isPrivate;

  ForumModel({
    this.description,
    this.freshness,
    this.groupDetails,
    this.id,
    this.postCount,
    this.title,
    this.topicCount,
    this.type,
    this.isPrivate,
  });

  factory ForumModel.fromJson(Map<String, dynamic> json) {
    return ForumModel(
      description: json['description'],
      freshness: json['freshness'] != null ? (json['freshness'] as List).map((i) => FreshnessModel.fromJson(i)).toList() : null,
      groupDetails: json['group_details'] != null ? (json['group_details'] as List).map((i) => GroupDetail.fromJson(i)).toList() : null,
      id: json['id'],
      postCount: json['post_count'],
      title: json['title'],
      topicCount: json['topic_count'],
      type: json['type'],
      isPrivate: json['is_private'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    data['post_count'] = this.postCount;
    data['title'] = this.title;
    data['topic_count'] = this.topicCount;
    data['type'] = this.type;
    data['is_private'] = this.isPrivate;
    if (this.freshness != null) {
      data['freshness'] = this.freshness!.map((v) => v.toJson()).toList();
    }
    if (this.groupDetails != null) {
      data['group_details'] = this.groupDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
