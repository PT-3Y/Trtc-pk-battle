import 'package:socialv/models/forums/forum_model.dart';
import 'package:socialv/models/forums/topic_model.dart';

class SubscriptionListModel {
  List<ForumModel>? forums;
  List<TopicModel>? topics;

  SubscriptionListModel({this.forums, this.topics});

  factory SubscriptionListModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionListModel(
      forums: json['forums'] != null ? (json['forums'] as List).map((i) => ForumModel.fromJson(i)).toList() : null,
      topics: json['topics'] != null ? (json['topics'] as List).map((i) => TopicModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.forums != null) {
      data['forums'] = this.forums!.map((v) => v.toJson()).toList();
    }
    if (this.topics != null) {
      data['topics'] = this.topics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
