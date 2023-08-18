class Admin {
  String? comments;
  String? dateModified;
  String? displayName;
  String? friendshipStatus;
  String? fullName;
  int? iD;
  int? id;
  int? inviteSent;
  int? inviterId;
  int? isAdmin;
  int? isBanned;
  int? isConfirmed;
  int? isMod;
  String? lastActivity;
  int? membershipId;
  String? totalFriendCount;
  int? userId;
  String? userLogin;
  String? userNiceName;
  String? userRegistered;
  int? userStatus;
  String? userTitle;
  String? userUrl;

  Admin({
    this.comments,
    this.dateModified,
    this.displayName,
    this.friendshipStatus,
    this.fullName,
    this.iD,
    this.id,
    this.inviteSent,
    this.inviterId,
    this.isAdmin,
    this.isBanned,
    this.isConfirmed,
    this.isMod,
    this.lastActivity,
    this.membershipId,
    this.totalFriendCount,
    this.userId,
    this.userLogin,
    this.userNiceName,
    this.userRegistered,
    this.userStatus,
    this.userTitle,
    this.userUrl,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      comments: json['comments'],
      dateModified: json['date_modified'],
      displayName: json['display_name'],
      friendshipStatus: json['friendship_status'],
      fullName: json['fullname'],
      iD: json['iD'],
      id: json['id'],
      inviteSent: json['invite_sent'],
      inviterId: json['inviter_id'],
      isAdmin: json['is_admin'],
      isBanned: json['is_banned'],
      isConfirmed: json['is_confirmed'],
      isMod: json['is_mod'],
      lastActivity: json['last_activity'],
      membershipId: json['membership_id'],
      totalFriendCount: json['total_friend_count'],
      userId: json['user_id'],
      userLogin: json['user_login'],
      userNiceName: json['user_nicename'],
      userRegistered: json['user_registered'],
      userStatus: json['user_status'],
      userTitle: json['user_title'],
      userUrl: json['user_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comments'] = this.comments;
    data['date_modified'] = this.dateModified;
    data['display_name'] = this.displayName;
    data['friendship_status'] = this.friendshipStatus;
    data['fullname'] = this.fullName;
    data['iD'] = this.iD;
    data['id'] = this.id;
    data['invite_sent'] = this.inviteSent;
    data['inviter_id'] = this.inviterId;
    data['is_admin'] = this.isAdmin;
    data['is_banned'] = this.isBanned;
    data['is_confirmed'] = this.isConfirmed;
    data['is_mod'] = this.isMod;
    data['last_activity'] = this.lastActivity;
    data['membership_id'] = this.membershipId;
    data['total_friend_count'] = this.totalFriendCount;
    data['user_id'] = this.userId;
    data['user_login'] = this.userLogin;
    data['user_nicename'] = this.userNiceName;
    data['user_registered'] = this.userRegistered;
    data['user_status'] = this.userStatus;
    data['user_title'] = this.userTitle;
    data['user_url'] = this.userUrl;
    return data;
  }
}
