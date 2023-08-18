import 'package:socialv/models/common_models/avatar_urls.dart';
import 'package:socialv/models/common_models/collection.dart';
import 'package:socialv/models/common_models/content.dart';
import 'package:socialv/models/common_models/user.dart';

class ActivityResponse {
  Links? links;
  String? bpGiphy;
  String? component;
  Content? content;
  String? date;
  String? dateGmt;
  bool? favorited;
  int? id;
  String? link;
  int? primaryItemId;
  int? secondaryItemId;
  String? status;
  String? title;
  String? type;
  AvatarUrls? userAvatar;
  int? userId;
  String? name;

  ActivityResponse({
    this.links,
    this.bpGiphy,
    this.component,
    this.content,
    this.date,
    this.dateGmt,
    this.favorited,
    this.id,
    this.link,
    this.primaryItemId,
    this.secondaryItemId,
    this.status,
    this.title,
    this.type,
    this.userAvatar,
    this.userId,
    this.name,
  });

  factory ActivityResponse.fromJson(Map<String, dynamic> json) {
    return ActivityResponse(
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
      bpGiphy: json['bp_giphy'],
      component: json['component'],
      content: json['content'] != null ? Content.fromJson(json['content']) : null,
      date: json['date'],
      dateGmt: json['date_gmt'],
      favorited: json['favorited'],
      id: json['id'],
      link: json['link'],
      primaryItemId: json['primary_item_id'],
      secondaryItemId: json['secondary_item_id'],
      status: json['status'],
      title: json['title'],
      type: json['type'],
      userAvatar: json['user_avatar'] != null ? AvatarUrls.fromJson(json['user_avatar']) : null,
      userId: json['user_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bp_giphy'] = this.bpGiphy;
    data['component'] = this.component;
    data['date'] = this.date;
    data['date_gmt'] = this.dateGmt;
    data['favorited'] = this.favorited;
    data['id'] = this.id;
    data['link'] = this.link;
    data['primary_item_id'] = this.primaryItemId;
    data['secondary_item_id'] = this.secondaryItemId;
    data['status'] = this.status;
    data['title'] = this.title;
    data['type'] = this.type;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    if (this.userAvatar != null) {
      data['user_avatar'] = this.userAvatar!.toJson();
    }
    return data;
  }
}

class Links {
  List<Favorite>? bpActionFavorite;
  List<Collection>? collection;
  List<Favorite>? favorite;
  List<User>? self;
  List<User>? user;

  Links({this.bpActionFavorite, this.collection, this.favorite, this.self, this.user});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      bpActionFavorite: json['bp-action-favorite'] != null ? (json['bp-action-favorite'] as List).map((i) => Favorite.fromJson(i)).toList() : null,
      collection: json['collection'] != null ? (json['collection'] as List).map((i) => Collection.fromJson(i)).toList() : null,
      favorite: json['favorite'] != null ? (json['favorite'] as List).map((i) => Favorite.fromJson(i)).toList() : null,
      self: json['self'] != null ? (json['self'] as List).map((i) => User.fromJson(i)).toList() : null,
      user: json['user'] != null ? (json['user'] as List).map((i) => User.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bpActionFavorite != null) {
      data['bp-action-favorite'] = this.bpActionFavorite!.map((v) => v.toJson()).toList();
    }
    if (this.collection != null) {
      data['collection'] = this.collection!.map((v) => v.toJson()).toList();
    }
    if (this.favorite != null) {
      data['favorite'] = this.favorite!.map((v) => v.toJson()).toList();
    }
    if (this.self != null) {
      data['self'] = this.self!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Favorite {
  int? activityId;
  String? href;

  Favorite({this.activityId, this.href});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      activityId: json['activity_id'],
      href: json['href'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activity_id'] = this.activityId;
    data['href'] = this.href;
    return data;
  }
}
