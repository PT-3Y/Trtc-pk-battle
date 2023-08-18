import 'package:flutter/cupertino.dart';

class CustomSignalingType {
  static const int audienceApplyToBecomeCoHost = 10000;
  static const int audienceCancelCoHostApply = 10001;
  static const int hostRefuseAudienceCoHostApply = 10002;
  static const int hostAcceptAudienceCoHostApply = 10003;

  static const int inRoomMessage = 10004;
  static const int virtualGifts = 10005;
  static const int startPkBattle = 10006;
  static const int finishPkBattle = 10007;

}

class UserInfo {
  UserInfo({
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.diamonds,
    required this.coins
  });

  late String userId;
  late String userName;
  late String userAvatar;
  late int diamonds;
  late int coins;
}

enum ZegoLiveRole {
  audience,
  host,
  coHost,
}

enum TCLiveRole {
  audience,
  host,
  coHost,
}

enum ZegoPkRole {
  audience,
  host,
  coHost,
}

class ButtonIcon {
  Widget? icon;
  Color? backgroundColor;

  ButtonIcon({this.icon, this.backgroundColor});
}

final List<Map<String, dynamic>> buttonData = [
  {
    "title": "Invite to pk battle",
    "route": "/invitepkbattle",
  },
  {
    "title": "Random pk battle",
    "route": "/randompk",
  },
  {
    "title": "Group Streaming",
    "route": "/groupstreaming",
  },
  {
    "title": "Singalong",
    "route": "/singalong",
  },
  // {
  //   "title": "PK Battle Test1",
  //   "route": "/pktest1",
  // },
  // {
  //   "title": "PK Battle Test2",
  //   "route": "/pktest2",
  // },
];
