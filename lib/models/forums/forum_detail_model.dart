import 'package:socialv/models/forums/common_models.dart';
import 'package:socialv/models/forums/forum_model.dart';
import 'package:socialv/models/forums/topic_model.dart';

class ForumDetailModel {
  String? description;
  int? id;
  String? image;
  bool? isSubscribed;
  String? lastUpdate;
  String? title;
  List<TopicModel>? topicList;
  List<ForumModel>? forumList;
  GroupDetail? groupDetails;
  int? isPrivate;

  ForumDetailModel({
    this.description,
    this.id,
    this.image,
    this.isSubscribed,
    this.lastUpdate,
    this.title,
    this.topicList,
    this.forumList,
    this.groupDetails,
    this.isPrivate,
  });

  factory ForumDetailModel.fromJson(Map<String, dynamic> json) {
    return ForumDetailModel(
      description: json['description'],
      id: json['id'],
      image: json['image'] == false ? '': json['image'],
      isSubscribed: json['is_subscribed'],
      lastUpdate: json['last_update'],
      title: json['title'],
      topicList: json['topic_list'] != null ? (json['topic_list'] as List).map((i) => TopicModel.fromJson(i)).toList() : null,
      forumList: json['forum_list'] != null ? (json['forum_list'] as List).map((i) => ForumModel.fromJson(i)).toList() : null,
      groupDetails: json['group_details'] != null ? GroupDetail.fromJson(json['group_details']) : null,
      isPrivate: json['is_private'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    data['image'] = this.image;
    data['is_subscribed'] = this.isSubscribed;
    data['last_update'] = this.lastUpdate;
    data['title'] = this.title;
    data['is_private'] = this.isPrivate;
    if (this.topicList != null) {
      data['topic_list'] = this.topicList!.map((v) => v.toJson()).toList();
    }
    if (this.forumList != null) {
      data['forum_list'] = this.forumList!.map((v) => v.toJson()).toList();
    }
    if (this.groupDetails != null) {
      data['group_details'] = this.groupDetails!.toJson();
    }
    return data;
  }
}
