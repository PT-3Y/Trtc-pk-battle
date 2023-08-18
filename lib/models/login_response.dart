class LoginResponse {
  LoginResponse({
    this.token,
    this.userEmail,
    this.userNicename,
    this.userDisplayName,
    this.bmSecretKey,
    this.isProfileUpdated,
  });

  LoginResponse.fromJson(dynamic json) {
    token = json['token'];
    userEmail = json['user_email'];
    userNicename = json['user_nicename'];
    userDisplayName = json['user_display_name'];
    bmSecretKey = json['bm_secret_key'];
    isProfileUpdated = json['is_profile_updated'];
  }

  String? token;
  String? userEmail;
  String? userNicename;
  String? userDisplayName;
  String? bmSecretKey;
  bool? isProfileUpdated;

  LoginResponse copyWith({
    String? token,
    String? userEmail,
    String? userNicename,
    String? userDisplayName,
    String? bmSecretKey,
  }) =>
      LoginResponse(
        token: token ?? this.token,
        userEmail: userEmail ?? this.userEmail,
        userNicename: userNicename ?? this.userNicename,
        userDisplayName: userDisplayName ?? this.userDisplayName,
        bmSecretKey: bmSecretKey ?? this.bmSecretKey,
        isProfileUpdated: isProfileUpdated ?? this.isProfileUpdated,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['user_email'] = userEmail;
    map['user_nicename'] = userNicename;
    map['user_display_name'] = userDisplayName;
    map['bm_secret_key'] = bmSecretKey;
    map['is_profile_updated'] = isProfileUpdated;

    return map;
  }
}
