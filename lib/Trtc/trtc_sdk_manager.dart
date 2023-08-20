// import 'package:socialv/Trtc/TRTCLiveRoomDemo/model/TRTCLiveRoomDef.dart';

// import 'socialv//zego_express_service.dart';
import 'package:socialv/Trtc/TRTCLiveRoom/model/TRTCLiveRoomDef.dart';
import 'package:socialv/Trtc/Trtc_userinfo/Trtc_userinfo.dart';


class TrtcSDKManager {
  TrtcSDKManager._internal();
  factory TrtcSDKManager() => instance;
  static final TrtcSDKManager instance = TrtcSDKManager._internal();


  TrtcUserInfo? localUser;
  List<TrtcUserInfo> userInfoList = [];

  Future<void> connectUser(String id, String name, {String? token}) async {
    localUser = TrtcUserInfo(userId: id, userName: name);
  }


Future<void> disconnectUser() async {
    localUser = null;
  }

  TrtcUserInfo? getUserInfo(String userID) {
    for (var user in userInfoList) {
      if (user.userId == userID) {
        return user;
      }
    }
    return null;
  }

  // TrtcUserInfo?  localUser => localUser;
  // TrtcUserInfo? getUser(String userID) {
  //   for (var user in userInfoList) {
  //     if (userID == user.userId) {
  //       return user;
  //     }
  //   }
  //   return null;
  // }


  
}
