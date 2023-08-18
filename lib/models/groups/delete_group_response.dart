import 'package:socialv/models/groups/admin.dart';
import 'package:socialv/models/common_models/avatar_urls.dart';
import 'package:socialv/models/common_models/description.dart';

class DeleteGroupResponse {
  bool? deleted;
  Previous? previous;

  DeleteGroupResponse({this.deleted, this.previous});

  factory DeleteGroupResponse.fromJson(Map<String, dynamic> json) {
    return DeleteGroupResponse(
      deleted: json['deleted'],
      previous: json['previous'] != null ? Previous.fromJson(json['previous']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deleted'] = this.deleted;
    if (this.previous != null) {
      data['previous'] = this.previous!.toJson();
    }
    return data;
  }
}

class Previous {
  List<Admin>? admins;
  AvatarUrls? avatarUrls;
  String? createdSince;
  int? creatorId;
  String? dateCreated;
  String? dateCreatedGmt;
  Description? description;
  bool? enableForum;
  int? id;
  String? lastActivity;
  String? lastActivityDiff;
  String? lastActivityGmt;
  String? link;
  List<dynamic>? mods;
  String? name;
  int? parentId;
  String? slug;
  String? status;
  int? totalMemberCount;
  List<dynamic>? types;

  Previous(
      {this.admins,
      this.avatarUrls,
      this.createdSince,
      this.creatorId,
      this.dateCreated,
      this.dateCreatedGmt,
      this.description,
      this.enableForum,
      this.id,
      this.lastActivity,
      this.lastActivityDiff,
      this.lastActivityGmt,
      this.link,
      this.mods,
      this.name,
      this.parentId,
      this.slug,
      this.status,
      this.totalMemberCount,
      this.types});

  factory Previous.fromJson(Map<String, dynamic> json) {
    return Previous(
      admins: json['admins'] != null ? (json['admins'] as List).map((i) => Admin.fromJson(i)).toList() : null,
      avatarUrls: json['avatar_urls'] != null ? AvatarUrls.fromJson(json['avatar_urls']) : null,
      createdSince: json['created_since'],
      creatorId: json['creator_id'],
      dateCreated: json['date_created'],
      dateCreatedGmt: json['date_created_gmt'],
      description: json['description'] != null ? Description.fromJson(json['description']) : null,
      enableForum: json['enable_forum'],
      id: json['id'],
      lastActivity: json['last_activity'],
      lastActivityDiff: json['last_activity_diff'],
      lastActivityGmt: json['last_activity_gmt'],
      link: json['link'],
      mods: json['mods'] != null ? (json['mods'] as List).map((i) => i.fromJson(i)).toList() : null,
      name: json['name'],
      parentId: json['parent_id'],
      slug: json['slug'],
      status: json['status'],
      totalMemberCount: json['total_member_count'],
      types: json['types'] != null ? (json['types'] as List).map((i) => i.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_since'] = this.createdSince;
    data['creator_id'] = this.creatorId;
    data['date_created'] = this.dateCreated;
    data['date_created_gmt'] = this.dateCreatedGmt;
    data['enable_forum'] = this.enableForum;
    data['id'] = this.id;
    data['last_activity'] = this.lastActivity;
    data['last_activity_diff'] = this.lastActivityDiff;
    data['last_activity_gmt'] = this.lastActivityGmt;
    data['link'] = this.link;
    data['name'] = this.name;
    data['parent_id'] = this.parentId;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['total_member_count'] = this.totalMemberCount;
    if (this.admins != null) {
      data['admins'] = this.admins!.map((v) => v.toJson()).toList();
    }
    if (this.avatarUrls != null) {
      data['avatar_urls'] = this.avatarUrls!.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description!.toJson();
    }
    if (this.mods != null) {
      data['mods'] = this.mods!.map((v) => v.toJson()).toList();
    }
    if (this.types != null) {
      data['types'] = this.types!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
