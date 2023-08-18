class Permissions {
  Permissions({
    this.isModerator,
    this.isMuted,
    this.deleteAllowed,
    this.canDeleteOwnMessages,
    this.canDeleteAllMessages,
    this.canEditOwnMessages,
    this.canFavorite,
    this.canMuteThread,
    this.canEraseThread,
    this.canClearThread,
    this.canInvite,
    this.canLeave,
    this.canUpload,
    this.canVideoCall,
    this.canAudioCall,
    this.canMaximize,
    this.canMinimize,
    this.canReply,
    this.canReplyMsg,
    this.canBlockUser,
  });

  Permissions.fromJson(dynamic json) {
    isModerator = json['isModerator'];
    isMuted = json['isMuted'];
    deleteAllowed = json['deleteAllowed'];
    canDeleteOwnMessages = json['canDeleteOwnMessages'];
    canDeleteAllMessages = json['canDeleteAllMessages'];
    canEditOwnMessages = json['canEditOwnMessages'];
    canFavorite = json['canFavorite'];
    canMuteThread = json['canMuteThread'];
    canEraseThread = json['canEraseThread'];
    canClearThread = json['canClearThread'];
    canInvite = json['canInvite'];
    canLeave = json['canLeave'];
    canUpload = json['canUpload'];
    canVideoCall = json['canVideoCall'];
    canAudioCall = json['canAudioCall'];
    canMaximize = json['canMaximize'];
    canMinimize = json['canMinimize'];
    canReply = json['canReply'];
    canBlockUser = json['canBlockUser'];
    canReplyMsg = json['canReplyMsg'] != [] ? json['canReplyMsg'] : null;
  }

  bool? isModerator;
  bool? isMuted;
  bool? deleteAllowed;
  bool? canDeleteOwnMessages;
  bool? canDeleteAllMessages;
  bool? canEditOwnMessages;
  bool? canFavorite;
  bool? canMuteThread;
  bool? canEraseThread;
  bool? canClearThread;
  bool? canInvite;
  bool? canLeave;
  var canUpload;
  bool? canVideoCall;
  bool? canAudioCall;
  bool? canMaximize;
  bool? canMinimize;
  bool? canReply;
  bool? canBlockUser;
  var canReplyMsg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isModerator'] = isModerator;
    map['isMuted'] = isMuted;
    map['deleteAllowed'] = deleteAllowed;
    map['canDeleteOwnMessages'] = canDeleteOwnMessages;
    map['canDeleteAllMessages'] = canDeleteAllMessages;
    map['canEditOwnMessages'] = canEditOwnMessages;
    map['canFavorite'] = canFavorite;
    map['canMuteThread'] = canMuteThread;
    map['canEraseThread'] = canEraseThread;
    map['canClearThread'] = canClearThread;
    map['canInvite'] = canInvite;
    map['canLeave'] = canLeave;
    map['canUpload'] = canUpload;
    map['canVideoCall'] = canVideoCall;
    map['canAudioCall'] = canAudioCall;
    map['canMaximize'] = canMaximize;
    map['canMinimize'] = canMinimize;
    map['canReply'] = canReply;
    map['canBlockUser'] = canBlockUser;
    if (canReplyMsg != null) {
      map['canReplyMsg'] = canReplyMsg!.toJson();
    }

    return map;
  }
}

class CanReplyMsg {
  CanReplyMsg({this.userBlockedMessages});

  CanReplyMsg.fromJson(dynamic json) {
    userBlockedMessages = json['user_blocked_messages'];
  }

  String? userBlockedMessages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_blocked_messages'] = userBlockedMessages;

    return map;
  }
}
