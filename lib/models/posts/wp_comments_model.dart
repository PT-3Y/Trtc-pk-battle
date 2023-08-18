import 'package:socialv/models/common_models/content.dart';
import 'package:socialv/models/common_models/wp_embedded_model.dart';

class WpCommentModel {
  int? author;
  AvatarUrls? author_avatar_urls;
  String? author_name;
  String? author_url;
  Content? content;
  String? date;
  int? id;
  int? parent;
  int? post;
  String? status;
  String? type;

  WpCommentModel({
    this.author,
    this.author_avatar_urls,
    this.author_name,
    this.author_url,
    this.content,
    this.date,
    this.id,
    this.parent,
    this.post,
    this.status,
    this.type,
  });

  factory WpCommentModel.fromJson(Map<String, dynamic> json) {
    return WpCommentModel(
      author: json['author'],
      author_avatar_urls: json['author_avatar_urls'] != null ? AvatarUrls.fromJson(json['author_avatar_urls']) : null,
      author_name: json['author_name'],
      author_url: json['author_url'],
      content: json['content'] != null ? Content.fromJson(json['content']) : null,
      date: json['date'],
      id: json['id'],
      parent: json['parent'],
      post: json['post'],
      status: json['status'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['author_name'] = this.author_name;
    data['author_url'] = this.author_url;
    data['date'] = this.date;
    data['id'] = this.id;
    data['parent'] = this.parent;
    data['post'] = this.post;
    data['status'] = this.status;
    data['type'] = this.type;
    if (this.author_avatar_urls != null) {
      data['author_avatar_urls'] = this.author_avatar_urls!.toJson();
    }
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    return data;
  }
}
