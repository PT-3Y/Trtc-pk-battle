class GetPostLikesModel {
  String? userId;
  String? userName;
  String? userMentionName;
  String? userAvatar;
  bool? isUserVerified;

  GetPostLikesModel({this.userId, this.userMentionName, this.userName, this.userAvatar, this.isUserVerified});

  factory GetPostLikesModel.fromJson(Map<String, dynamic> json) {
    return GetPostLikesModel(
      userId: json['user_id'],
      userName: json['user_name'],
      userMentionName: json['user_mention_name'],
      userAvatar: json['user_avatar'],
      isUserVerified: json['is_user_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_mention_name'] = this.userMentionName;
    data['user_avatar'] = this.userAvatar;
    data['is_user_verified'] = this.isUserVerified;

    return data;
  }
}
