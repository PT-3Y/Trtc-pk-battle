import 'package:socialv/models/messages/chat_background_model.dart';

import 'bm_notifications.dart';
import 'bm_blocked_users.dart';

class UserSettingsModel {
  UserSettingsModel({
    this.notifications,
    this.bmBlockedUsers,
    this.chatBackground,
  });

  UserSettingsModel.fromJson(dynamic json) {
    notifications = json['notifications'] != null ? Notifications.fromJson(json['notifications']) : null;
    bmBlockedUsers = json['bm_blocked_users'] != null ? BmBlockedUsers.fromJson(json['bm_blocked_users']) : null;
    chatBackground = json['chat_background'] != null ? ChatBackgroundModel.fromJson(json['chat_background']) : null;
  }

  Notifications? notifications;
  BmBlockedUsers? bmBlockedUsers;
  ChatBackgroundModel? chatBackground;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (notifications != null) {
      map['notifications'] = notifications!.toJson();
    }
    if (bmBlockedUsers != null) {
      map['bm_blocked_users'] = bmBlockedUsers!.toJson();
    }
    if (chatBackground != null) {
      map['chat_background'] = chatBackground!.toJson();
    }
    return map;
  }
}
