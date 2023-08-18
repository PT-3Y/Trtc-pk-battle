class FriendRequestModel {
  int? requestId;
  int? userId;
  String? userImage;
  String? userMentionName;
  String? userName;
  bool? isUserVerified;
  bool? isRequested;

  FriendRequestModel({this.requestId, this.userId, this.userImage, this.userMentionName, this.userName,this.isUserVerified,this.isRequested = false});

  /// todo : use this model for any user list

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      requestId: json['request_id'],
      userId: json['user_id'],
      userImage: json['user_image'],
      userMentionName: json['user_mention_name'],
      userName: json['user_name'],
      isUserVerified: json['is_user_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.requestId;
    data['user_id'] = this.userId;
    data['user_image'] = this.userImage;
    data['user_mention_name'] = this.userMentionName;
    data['user_name'] = this.userName;
    data['is_user_verified'] = this.isUserVerified;
    return data;
  }
}
