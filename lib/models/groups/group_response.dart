import 'package:socialv/models/common_models/avatar_urls.dart';
import 'package:socialv/models/common_models/description.dart';
import 'package:socialv/models/common_models/links.dart';

class GroupResponse {
  Links? links;
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
  String? link;
  String? name;
  int? parentId;
  String? slug;
  String? status;
  int? totalMemberCount;
  List<dynamic>? types;

  GroupResponse(
      {this.links,
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
      this.link,
      this.name,
      this.parentId,
      this.slug,
      this.status,
      this.totalMemberCount,
      this.types});

  factory GroupResponse.fromJson(Map<String, dynamic> json) {
    return GroupResponse(
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
      avatarUrls: json['avatar_urls'] != null ? AvatarUrls.fromJson(json['avatar_urls']) : null,
      createdSince: json['created_since'],
      creatorId: json['creator_id'],
      dateCreated: json['date_created'],
      dateCreatedGmt: json['date_created_gmt'],
      description: json['description'] != null ? Description.fromJson(json['description']) : null,
      enableForum: json['enable_forum'],
      id: json['id'],
      lastActivity: json['last_activity'] != null ? json['last_activity'] : null,
      lastActivityDiff: json['last_activity_diff'] != null ? json['last_activity_diff'] : null,
      link: json['link'],
      name: json['name'],
      parentId: json['parent_id'],
      slug: json['slug'],
      status: json['status'],
      totalMemberCount: json['total_member_count'] != null ? json['total_member_count'] : null,
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
    data['link'] = this.link;
    data['name'] = this.name;
    data['parent_id'] = this.parentId;
    data['slug'] = this.slug;
    data['status'] = this.status;
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    if (this.avatarUrls != null) {
      data['avatar_urls'] = this.avatarUrls!.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description!.toJson();
    }
    if (this.lastActivity != null) {
      data['last_activity'] = this.lastActivity;
    }
    if (this.lastActivityDiff != null) {
      data['last_activity_diff'] = this.lastActivityDiff;
    }
    if (this.totalMemberCount != null) {
      data['total_member_count'] = this.totalMemberCount;
    }
    if (this.types != null) {
      data['types'] = this.types!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
