import 'package:flutter/material.dart';
import 'package:socialv/Trtc/TRTCCallingDemo/ui/base/CallingScenes.dart';
import 'package:socialv/Trtc/TRTCLiveRoomDemo/ui/list/LiveRoomList.dart';
import 'package:socialv/Trtc/TRTCLiveRoomDemo/ui/room/LiveRoomPage.dart';
import 'package:socialv/Trtc/TRTCChatSalonDemo/ui/list/VoiceRoomList.dart';
import 'package:socialv/Trtc/TRTCChatSalonDemo/ui/list/VoiceRoomCreate.dart';
import 'package:socialv/Trtc/TRTCChatSalonDemo/ui/room/VoiceRoomPage.dart';
import '../index.dart';
import '../login/LoginPage.dart';
import 'package:socialv/Trtc/TRTCChatSalonDemo/ui/base/UserEnum.dart';
import 'package:socialv/Trtc/TRTCCallingDemo/ui/TRTCCallingContact.dart';
import 'package:socialv/Trtc/TRTCCallingDemo/ui/VideoCall/TRTCCallingVideo.dart';
import 'package:socialv/Trtc/TRTCMeeting/ui/TRTCMeetingIndex.dart';
import 'package:socialv/Trtc/TRTCMeeting/ui/TRTCMeetingRoom.dart';

final String initialRoute = "/";
final Map<String, WidgetBuilder> routes = {
  "/": (context) => IndexPage(),
  "/index": (context) => IndexPage(),
  "/login": (context) => LoginPage(),
  "/chatSalon/list": (context) => VoiceRoomListPage(),
  "/chatSalon/roomCreate": (context) => VoiceRoomCreatePage(),
  "/chatSalon/roomAnchor": (context) => VoiceRoomPage(UserType.Anchor),
  "/chatSalon/roomAudience": (context) => VoiceRoomPage(UserType.Audience),
  "/calling/videoContact": (context) =>
      TRTCCallingContact(CallingScenes.VideoOneVOne),
  "/calling/audioContact": (context) =>
      TRTCCallingContact(CallingScenes.AudioOneVOne),
  "/calling/callingView": (context) => TRTCCallingVideo(),
  "/liveRoom/roomAudience": (context) => LiveRoomPage(role: false),
  "/liveRoom/roomAnchor": (context) => LiveRoomPage(role: true),
  "/liveRoom/list": (context) => LiveRoomListPage(),
  "/meeting/meetingIndex": (context) => TRTCMeetingIndex(),
  "/meeting/meetingRoom": (context) => TRTCMeetingRoom(),
};
