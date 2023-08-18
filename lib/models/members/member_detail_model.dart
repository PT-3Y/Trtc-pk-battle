import 'package:socialv/models/story/highlight_stories_model.dart';

class MemberDetailModel {
  String? email;
  int? friendsCount;
  String? friendshipStatus;
  int? groupsCount;
  String? id;
  String? memberAvatarImage;
  String? memberCoverImage;
  String? mentionName;
  String? name;
  int? postCount;
  List<ProfileInfo>? profileInfo;
  bool? blockedByMe;
  bool? blockedBy;
  bool? isUserVerified;
  String? accountType;
  List<HighlightStoriesModel>? highlightStory;

  MemberDetailModel(
      {this.email,
      this.friendsCount,
      this.friendshipStatus,
      this.groupsCount,
      this.id,
      this.memberAvatarImage,
      this.memberCoverImage,
      this.mentionName,
      this.name,
      this.postCount,
      this.profileInfo,
      this.blockedBy,
      this.blockedByMe,
      this.isUserVerified,
      this.accountType,
      this.highlightStory});

  factory MemberDetailModel.fromJson(Map<String, dynamic> json) {
    return MemberDetailModel(
      email: json['email'],
      friendsCount: json['friends_count'],
      friendshipStatus: json['friendship_status'],
      groupsCount: json['groups_count'],
      id: json['id'],
      memberAvatarImage: json['member_avtar_image'],
      memberCoverImage: json['member_cover_image'],
      mentionName: json['mention_name'],
      name: json['name'],
      postCount: json['post_count'],
      profileInfo: json['profile_info'] != null ? (json['profile_info'] as List).map((i) => ProfileInfo.fromJson(i)).toList() : null,
      blockedByMe: json['blocked_by_me'],
      blockedBy: json['blocked_by'],
      isUserVerified: json['is_user_verified'],
      accountType: json['account_type'],
      highlightStory: json['highlight_story'] != null ? (json['highlight_story'] as List).map((i) => HighlightStoriesModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['friends_count'] = this.friendsCount;
    data['friendship_status'] = this.friendshipStatus;
    data['groups_count'] = this.groupsCount;
    data['id'] = this.id;
    data['member_avtar_image'] = this.memberAvatarImage;
    data['member_cover_image'] = this.memberCoverImage;
    data['mention_name'] = this.mentionName;
    data['name'] = this.name;
    data['post_count'] = this.postCount;
    data['is_user_verified'] = this.isUserVerified;
    if (this.profileInfo != null) {
      data['profile_info'] = this.profileInfo!.map((v) => v.toJson()).toList();
    }
    data['blocked_by_me'] = this.blockedByMe;
    data['blocked_by'] = this.blockedBy;
    data['account_type'] = this.accountType;
    if (this.highlightStory != null) {
      data['highlight_story'] = this.highlightStory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfileInfo {
  List<Field>? fields;
  int? id;
  String? name;

  ProfileInfo({this.fields, this.id, this.name});

  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
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
  String? value;

  Field({this.id, this.name, this.value});

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      name: json['name'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
