import 'package:socialv/models/common_models/avatar_urls.dart';

class RemoveGroupMember {
  Previous? previous;
  bool? removed;

  RemoveGroupMember({this.previous, this.removed});

  factory RemoveGroupMember.fromJson(Map<String, dynamic> json) {
    return RemoveGroupMember(
      previous: json['previous'] != null ? Previous.fromJson(json['previous']) : null,
      removed: json['removed'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['removed'] = this.removed;
    if (this.previous != null) {
      data['previous'] = this.previous!.toJson();
    }
    return data;
  }
}

class Previous {
  AvatarUrls? avatar_urls;
  List<String>? capabilities;
  String? date_modified;
  String? date_modified_gmt;
  List<String>? extra_capabilities;
  bool? friendship_status;
  String? friendship_status_slug;
  int? group;
  int? id;
  bool? is_admin;
  bool? is_banned;
  bool? is_confirmed;
  bool? is_mod;
  String? link;
  String? mention_name;
  String? name;
  String? registered_date;
  String? registered_date_gmt;
  List<String>? roles;
  String? user_login;

  Previous({
    this.avatar_urls,
    this.capabilities,
    this.date_modified,
    this.date_modified_gmt,
    this.extra_capabilities,
    this.friendship_status,
    this.friendship_status_slug,
    this.group,
    this.id,
    this.is_admin,
    this.is_banned,
    this.is_confirmed,
    this.is_mod,
    this.link,
    this.mention_name,
    this.name,
    this.registered_date,
    this.registered_date_gmt,
    this.roles,
    this.user_login,
  });

  factory Previous.fromJson(Map<String, dynamic> json) {
    return Previous(
      avatar_urls: json['avatar_urls'] != null ? AvatarUrls.fromJson(json['avatar_urls']) : null,
      capabilities: json['capabilities'] != null ? new List<String>.from(json['capabilities']) : null,
      date_modified: json['date_modified'],
      date_modified_gmt: json['date_modified_gmt'],
      extra_capabilities: json['extra_capabilities'] != null ? new List<String>.from(json['extra_capabilities']) : null,
      friendship_status: json['friendship_status'],
      friendship_status_slug: json['friendship_status_slug'],
      group: json['group'],
      id: json['id'],
      is_admin: json['is_admin'],
      is_banned: json['is_banned'],
      is_confirmed: json['is_confirmed'],
      is_mod: json['is_mod'],
      link: json['link'],
      mention_name: json['mention_name'],
      name: json['name'],
      registered_date: json['registered_date'] != null ? json['registered_date'] : null,
      registered_date_gmt: json['registered_date_gmt'] != null ? json['registered_date_gmt'] : null,
      roles: json['roles'] != null ? new List<String>.from(json['roles']) : null,
      user_login: json['user_login'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_modified'] = this.date_modified;
    data['date_modified_gmt'] = this.date_modified_gmt;
    data['friendship_status'] = this.friendship_status;
    data['friendship_status_slug'] = this.friendship_status_slug;
    data['group'] = this.group;
    data['id'] = this.id;
    data['is_admin'] = this.is_admin;
    data['is_banned'] = this.is_banned;
    data['is_confirmed'] = this.is_confirmed;
    data['is_mod'] = this.is_mod;
    data['link'] = this.link;
    data['mention_name'] = this.mention_name;
    data['name'] = this.name;
    data['user_login'] = this.user_login;
    if (this.avatar_urls != null) {
      data['avatar_urls'] = this.avatar_urls!.toJson();
    }
    if (this.capabilities != null) {
      data['capabilities'] = this.capabilities;
    }
    if (this.extra_capabilities != null) {
      data['extra_capabilities'] = this.extra_capabilities;
    }

    if (this.registered_date != null) {
      data['registered_date'] = this.registered_date;
    }
    if (this.registered_date_gmt != null) {
      data['registered_date_gmt'] = this.registered_date_gmt;
    }
    if (this.roles != null) {
      data['roles'] = this.roles;
    }
    return data;
  }
}
