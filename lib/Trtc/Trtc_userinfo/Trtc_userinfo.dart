
class TrtcUserInfo {
  /// 用户唯一标识
  String userId;

  /// 用户昵称
  String? userName;

  /// 用户头像
  String? userAvatar;

  TrtcUserInfo({
    required this.userId,
    this.userName,
    this.userAvatar,
  });
}
