class MemberModel {
  bool? isAdmin;
  int? isMod;
  int? isBanned;
  String? userAvatar;
  int? userId;
  String? userName;
  String? mentionName;
  bool? isUserVarified;

  MemberModel({this.isUserVarified,this.isAdmin, this.userAvatar, this.userId, this.userName, this.mentionName,this.isBanned,this.isMod});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      isAdmin: json['is_admin'],
      isUserVarified: json['is_user_verified'],
      isMod: json['is_mod'],
      isBanned: json['is_banned'],
      userAvatar: json['user_avatar'],
      userId: json['user_id'],
      userName: json['user_name'],
      mentionName: json['mention_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_admin'] = this.isAdmin;
    data['is_user_verified'] = this.isUserVarified;
    data['is_banned'] = this.isBanned;
    data['is_mod'] = this.isMod;
    data['user_avatar'] = this.userAvatar;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['mention_name'] = this.mentionName;

    return data;
  }
}
