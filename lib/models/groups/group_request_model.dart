class GroupRequestModel {
  int? requestId;
  int? userId;
  String? userImage;
  String? userMentionName;
  String? userName;
  bool? isInvited;
  bool? isUserVerified;

  GroupRequestModel({
    this.requestId,
    this.userId,
    this.userImage,
    this.userMentionName,
    this.userName,
    this.isInvited,
    this.isUserVerified,
  });

  factory GroupRequestModel.fromJson(Map<String, dynamic> json) {
    return GroupRequestModel(
      requestId: json['request_Id'],
      userId: json['user_id'],
      userImage: json['user_image'],
      userMentionName: json['user_mention_name'],
      userName: json['user_name'],
      isInvited: json['is_invited'],
      isUserVerified: json['is_user_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_Id'] = this.requestId;
    data['user_id'] = this.userId;
    data['user_image'] = this.userImage;
    data['user_mention_name'] = this.userMentionName;
    data['user_name'] = this.userName;
    data['is_invited'] = this.isInvited;
    data['is_user_verified'] = this.isUserVerified;

    return data;
  }
}

class GroupInviteModel {
  int? requestId;
  int? userid;
  int? userId;
  String? userImage;
  String? userMentionName;
  String? userName;
  bool? isInvited;
  bool? isUserVerified;

  GroupInviteModel({
    this.requestId,
    this.userId,
    this.userid,
    this.userImage,
    this.userMentionName,
    this.userName,
    this.isInvited,
    this.isUserVerified,
  });

  factory GroupInviteModel.fromJson(Map<String, dynamic> json) {
    return GroupInviteModel(
      requestId: json['request_Id'],
      userId: json['user_Id'],
      userImage: json['user_image'],
      userMentionName: json['user_mention_name'],
      userName: json['user_name'],
      isInvited: json['is_invited'],
      isUserVerified: json['is_user_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_Id'] = this.requestId;
    data['user_Id'] = this.userId;
    data['user_image'] = this.userImage;
    data['user_mention_name'] = this.userMentionName;
    data['user_name'] = this.userName;
    data['is_invited'] = this.isInvited;
    data['is_user_verified'] = this.isUserVerified;

    return data;
  }
}
