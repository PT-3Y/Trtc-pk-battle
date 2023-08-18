class BlockedAccountsModel {
  String? userId;
  String? userImage;
  String? userMentionName;
  String? userName;
  bool? isUserVerified;

  BlockedAccountsModel({this.userId, this.userImage, this.userMentionName, this.userName, this.isUserVerified});

  factory BlockedAccountsModel.fromJson(Map<String, dynamic> json) {
    return BlockedAccountsModel(
      userId: json['user_id'],
      userImage: json['user_image'],
      userMentionName: json['user_mention_name'],
      userName: json['user_name'],
      isUserVerified: json['is_user_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_image'] = this.userImage;
    data['user_mention_name'] = this.userMentionName;
    data['user_name'] = this.userName;
    data['is_user_verified'] = this.isUserVerified;
    return data;
  }
}
