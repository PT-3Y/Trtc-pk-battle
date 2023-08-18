import 'package:socialv/models/forums/common_models.dart';

class TopicModel {
  String? createdAtDate;
  String? createdById;
  String? createdByName;
  String? description;
  int? forumId;
  String? forumName;
  int? id;
  bool? isFavorites;
  bool? isSubscribed;
  String? postCount;
  List<TopicReplyModel>? postList;
  String? title;
  String? voicesCount;
  List<FreshnessModel>? freshness;
  String? lastUpdate;
  List<TagsModel>? tags;
  bool? isUserVerified;

  TopicModel({
    this.createdAtDate,
    this.createdById,
    this.createdByName,
    this.description,
    this.forumId,
    this.forumName,
    this.id,
    this.isFavorites,
    this.isSubscribed,
    this.postCount,
    this.postList,
    this.title,
    this.voicesCount,
    this.freshness,
    this.lastUpdate,
    this.tags,
    this.isUserVerified,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      createdAtDate: json['created_at_date'],
      createdById: json['created_by_id'].toString(),
      createdByName: json['created_by_name'],
      description: json['description'],
      forumId: json['forum_id'],
      forumName: json['forum_name'],
      id: json['id'],
      isFavorites: json['is_favorites'],
      isSubscribed: json['is_subscribed'],
      postCount: json['post_count'].toString(),
      postList: json['post_list'] != null ? (json['post_list'] as List).map((i) => TopicReplyModel.fromJson(i)).toList() : null,
      title: json['title'],
      voicesCount: json['voices_count'].toString(),
      freshness: json['freshness'] != null ? (json['freshness'] as List).map((i) => FreshnessModel.fromJson(i)).toList() : null,
      lastUpdate: json['last_update'],
      isUserVerified: json['is_user_verified'],
      tags: json['tags'] != null ? (json['tags'] as List).map((i) => TagsModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at_date'] = this.createdAtDate;
    data['created_by_id'] = this.createdById;
    data['created_by_name'] = this.createdByName;
    data['description'] = this.description;
    data['forum_id'] = this.forumId;
    data['forum_name'] = this.forumName;
    data['id'] = this.id;
    data['is_favorites'] = this.isFavorites;
    data['is_subscribed'] = this.isSubscribed;
    data['post_count'] = this.postCount;
    data['title'] = this.title;
    data['voices_count'] = this.voicesCount;
    data['is_user_verified'] = this.isUserVerified;
    if (this.postList != null) {
      data['post_list'] = this.postList!.map((v) => v.toJson()).toList();
    }
    if (this.freshness != null) {
      data['freshness'] = this.freshness!.map((v) => v.toJson()).toList();
    }
    data['last_update'] = this.lastUpdate;

    return data;
  }
}
