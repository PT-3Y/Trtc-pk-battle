import 'package:socialv/models/common_models/avatar_urls.dart';
import 'package:socialv/models/common_models/links.dart';

class MemberResponse {
  Links? links;
  AvatarUrls? avatarUrls;
  bool? friendshipStatus;
  String? friendshipStatusSlug;
  int? id;
  String? link;
  String? mentionName;
  String? name;
  String? userLogin;
  bool? isUserVerified;
  String? lastActive;

  MemberResponse({
    this.links,
    this.avatarUrls,
    this.friendshipStatus,
    this.friendshipStatusSlug,
    this.id,
    this.link,
    this.mentionName,
    this.name,
    this.userLogin,
    this.isUserVerified,
    this.lastActive,
  });

  factory MemberResponse.fromJson(Map<String, dynamic> json) {
    return MemberResponse(
      links: json['links'] != null ? Links.fromJson(json['links']) : null,
      avatarUrls: json['avatar_urls'] != null ? AvatarUrls.fromJson(json['avatar_urls']) : null,
      friendshipStatus: json['friendship_status'],
      friendshipStatusSlug: json['friendship_status_slug'],
      id: json['id'],
      link: json['link'],
      mentionName: json['mention_name'],
      name: json['name'],
      userLogin: json['user_login'],
      isUserVerified: json['is_user_verified'],
      lastActive: json['last_active'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['friendship_status'] = this.friendshipStatus;
    data['friendship_status_slug'] = this.friendshipStatusSlug;
    data['id'] = this.id;
    data['link'] = this.link;
    data['mention_name'] = this.mentionName;
    data['name'] = this.name;
    data['user_login'] = this.userLogin;
    data['is_user_verified'] = this.isUserVerified;
    data['last_active'] = this.lastActive;
    if (this.links != null) {
      data['links'] = this.links!.toJson();
    }
    if (this.avatarUrls != null) {
      data['avatar_urls'] = this.avatarUrls!.toJson();
    }
    return data;
  }
}

class Xprofile {
  List<Group>? groups;

  Xprofile({this.groups});

  factory Xprofile.fromJson(Map<String, dynamic> json) {
    return Xprofile(
      groups: json['groups'] != null ? (json['groups'] as List).map((i) => Group.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.groups != null) {
      data['groups'] = this.groups!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Group {
  List<Field>? fields;
  int? id;
  String? name;

  Group({this.fields, this.id, this.name});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      fields: json['fields'] != null ? (json['fields'] as List).map((i) => Field.fromJson(i)).toList() : null,
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.fields != null) {
      data['fields'] = this.fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Field {
  int? id;
  String? name;
  Value? value;

  Field({this.id, this.name, this.value});

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      name: json['name'],
      value: json['value'] != null ? Value.fromJson(json['value']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    return data;
  }
}

class Value {
  String? raw;
  String? rendered;
  List<String>? unserialized;

  Value({this.raw, this.rendered, this.unserialized});

  factory Value.fromJson(Map<String, dynamic> json) {
    return Value(
      raw: json['raw'],
      rendered: json['rendered'],
      unserialized: json['unserialized'] != null ? new List<String>.from(json['unserialized']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['raw'] = this.raw;
    data['rendered'] = this.rendered;
    if (this.unserialized != null) {
      data['unserialized'] = this.unserialized;
    }
    return data;
  }
}
