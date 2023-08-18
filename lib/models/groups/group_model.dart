import 'package:socialv/models/members/member_model.dart';

class GroupModel {
  String? dateCreated;
  String? description;
  String? groupAvatarImage;
  String? groupCoverImage;
  String? groupCreatedBy;
  int? groupCreatedById;
  String? groupType;
  int? id;
  bool? isGroupAdmin;
  bool? isGroupMember;
  int? isMod;
  int? isBanned;
  int? isGalleryEnabled;
  int? isRequestSent;
  int? hasInvite;
  String? memberCount;
  List<MemberModel>? memberList;
  String? name;
  String? postCount;
  bool? canInvite;
  String? inviteStatus;

  GroupModel({
    this.isBanned,
    this.isMod,
    this.isGalleryEnabled,
    this.dateCreated,
    this.description,
    this.groupAvatarImage,
    this.groupCoverImage,
    this.groupCreatedBy,
    this.groupCreatedById,
    this.groupType,
    this.id,
    this.isGroupAdmin,
    this.isGroupMember,
    this.isRequestSent,
    this.memberCount,
    this.memberList,
    this.name,
    this.postCount,
    this.hasInvite,
    this.canInvite,
    this.inviteStatus,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      dateCreated: json['date_created'],
      description: json['description'],
      groupAvatarImage: json['group_avtar_image'] == false ? '' : json['group_avtar_image'],
      groupCoverImage: json['group_cover_image'],
      groupCreatedBy: json['group_created_by'],
      groupCreatedById: json['group_created_by_id'],
      groupType: json['group_type'],
      id: json['id'],
      isGalleryEnabled: json['is_gallery_enabled'],
      isGroupAdmin: json['is_group_admin'],
      isGroupMember: json['is_group_member'],
      isBanned: json['is_banned'],
      isMod: json['is_mod'],
      isRequestSent: json['is_request_sent'],
      hasInvite: json['has_invite'],
      memberCount: json['member_count'],
      memberList: json['member_list'] != null ? (json['member_list'] as List).map((i) => MemberModel.fromJson(i)).toList() : null,
      name: json['name'],
      postCount: json['post_count'],
      canInvite: json['can_invite'],
      inviteStatus: json['invite_status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_gallery_enabled'] = this.isGalleryEnabled;
    data['date_created'] = this.dateCreated;
    data['description'] = this.description;
    data['group_avtar_image'] = this.groupAvatarImage;
    data['group_cover_image'] = this.groupCoverImage;
    data['group_created_by'] = this.groupCreatedBy;
    data['group_created_by_id'] = this.groupCreatedById;
    data['group_type'] = this.groupType;
    data['id'] = this.id;
    data['is_group_admin'] = this.isGroupAdmin;
    data['is_mod'] = this.isMod;
    data['is_banned'] = this.isBanned;
    data['is_group_member'] = this.isGroupMember;
    data['is_request_sent'] = this.isRequestSent;
    data['has_invite'] = this.hasInvite;
    data['member_count'] = this.memberCount;
    data['name'] = this.name;
    data['post_count'] = this.postCount;
    data['invite_status'] = this.inviteStatus;
    if (this.memberList != null) {
      data['member_list'] = this.memberList!.map((v) => v.toJson()).toList();
    }
    data['can_invite'] = this.canInvite;

    return data;
  }
}
