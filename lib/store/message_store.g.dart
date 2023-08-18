// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MessageStore on MessageStoreBase, Store {
  late final _$globalChatBackgroundAtom =
      Atom(name: 'MessageStoreBase.globalChatBackground', context: context);

  @override
  String get globalChatBackground {
    _$globalChatBackgroundAtom.reportRead();
    return super.globalChatBackground;
  }

  @override
  set globalChatBackground(String value) {
    _$globalChatBackgroundAtom.reportWrite(value, super.globalChatBackground,
        () {
      super.globalChatBackground = value;
    });
  }

  late final _$messageCountAtom =
      Atom(name: 'MessageStoreBase.messageCount', context: context);

  @override
  int get messageCount {
    _$messageCountAtom.reportRead();
    return super.messageCount;
  }

  @override
  set messageCount(int value) {
    _$messageCountAtom.reportWrite(value, super.messageCount, () {
      super.messageCount = value;
    });
  }

  late final _$userNameKeyAtom =
      Atom(name: 'MessageStoreBase.userNameKey', context: context);

  @override
  String get userNameKey {
    _$userNameKeyAtom.reportRead();
    return super.userNameKey;
  }

  @override
  set userNameKey(String value) {
    _$userNameKeyAtom.reportWrite(value, super.userNameKey, () {
      super.userNameKey = value;
    });
  }

  late final _$userAvatarKeyAtom =
      Atom(name: 'MessageStoreBase.userAvatarKey', context: context);

  @override
  String get userAvatarKey {
    _$userAvatarKeyAtom.reportRead();
    return super.userAvatarKey;
  }

  @override
  set userAvatarKey(String value) {
    _$userAvatarKeyAtom.reportWrite(value, super.userAvatarKey, () {
      super.userAvatarKey = value;
    });
  }

  late final _$bmSecretKeyAtom =
      Atom(name: 'MessageStoreBase.bmSecretKey', context: context);

  @override
  String get bmSecretKey {
    _$bmSecretKeyAtom.reportRead();
    return super.bmSecretKey;
  }

  @override
  set bmSecretKey(String value) {
    _$bmSecretKeyAtom.reportWrite(value, super.bmSecretKey, () {
      super.bmSecretKey = value;
    });
  }

  late final _$refreshRecentMessageAtom =
      Atom(name: 'MessageStoreBase.refreshRecentMessage', context: context);

  @override
  bool get refreshRecentMessage {
    _$refreshRecentMessageAtom.reportRead();
    return super.refreshRecentMessage;
  }

  @override
  set refreshRecentMessage(bool value) {
    _$refreshRecentMessageAtom.reportWrite(value, super.refreshRecentMessage,
        () {
      super.refreshRecentMessage = value;
    });
  }

  late final _$refreshChatAtom =
      Atom(name: 'MessageStoreBase.refreshChat', context: context);

  @override
  bool get refreshChat {
    _$refreshChatAtom.reportRead();
    return super.refreshChat;
  }

  @override
  set refreshChat(bool value) {
    _$refreshChatAtom.reportWrite(value, super.refreshChat, () {
      super.refreshChat = value;
    });
  }

  late final _$allowBlockAtom =
      Atom(name: 'MessageStoreBase.allowBlock', context: context);

  @override
  bool get allowBlock {
    _$allowBlockAtom.reportRead();
    return super.allowBlock;
  }

  @override
  set allowBlock(bool value) {
    _$allowBlockAtom.reportWrite(value, super.allowBlock, () {
      super.allowBlock = value;
    });
  }

  late final _$onlineUsersAtom =
      Atom(name: 'MessageStoreBase.onlineUsers', context: context);

  @override
  List<int> get onlineUsers {
    _$onlineUsersAtom.reportRead();
    return super.onlineUsers;
  }

  @override
  set onlineUsers(List<int> value) {
    _$onlineUsersAtom.reportWrite(value, super.onlineUsers, () {
      super.onlineUsers = value;
    });
  }

  late final _$unreadThreadsAtom =
      Atom(name: 'MessageStoreBase.unreadThreads', context: context);

  @override
  ObservableList<UnreadThreadModel> get unreadThreads {
    _$unreadThreadsAtom.reportRead();
    return super.unreadThreads;
  }

  @override
  set unreadThreads(ObservableList<UnreadThreadModel> value) {
    _$unreadThreadsAtom.reportWrite(value, super.unreadThreads, () {
      super.unreadThreads = value;
    });
  }

  late final _$typingListAtom =
      Atom(name: 'MessageStoreBase.typingList', context: context);

  @override
  ObservableList<UnreadThreadModel> get typingList {
    _$typingListAtom.reportRead();
    return super.typingList;
  }

  @override
  set typingList(ObservableList<UnreadThreadModel> value) {
    _$typingListAtom.reportWrite(value, super.typingList, () {
      super.typingList = value;
    });
  }

  late final _$setUserNameKeyAsyncAction =
      AsyncAction('MessageStoreBase.setUserNameKey', context: context);

  @override
  Future<void> setUserNameKey(String val, {bool isInitializing = false}) {
    return _$setUserNameKeyAsyncAction
        .run(() => super.setUserNameKey(val, isInitializing: isInitializing));
  }

  late final _$setUserAvatarKeyAsyncAction =
      AsyncAction('MessageStoreBase.setUserAvatarKey', context: context);

  @override
  Future<void> setUserAvatarKey(String val, {bool isInitializing = false}) {
    return _$setUserAvatarKeyAsyncAction
        .run(() => super.setUserAvatarKey(val, isInitializing: isInitializing));
  }

  late final _$setBmSecretKeyAsyncAction =
      AsyncAction('MessageStoreBase.setBmSecretKey', context: context);

  @override
  Future<void> setBmSecretKey(String val, {bool isInitializing = false}) {
    return _$setBmSecretKeyAsyncAction
        .run(() => super.setBmSecretKey(val, isInitializing: isInitializing));
  }

  late final _$setGlobalChatBackgroundAsyncAction =
      AsyncAction('MessageStoreBase.setGlobalChatBackground', context: context);

  @override
  Future<void> setGlobalChatBackground(String val) {
    return _$setGlobalChatBackgroundAsyncAction
        .run(() => super.setGlobalChatBackground(val));
  }

  late final _$MessageStoreBaseActionController =
      ActionController(name: 'MessageStoreBase', context: context);

  @override
  void setRefreshRecentMessages(bool val) {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.setRefreshRecentMessages');
    try {
      return super.setRefreshRecentMessages(val);
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRefreshChat(bool val) {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.setRefreshChat');
    try {
      return super.setRefreshChat(val);
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAllowBlock(bool val) {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.setAllowBlock');
    try {
      return super.setAllowBlock(val);
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addOnlineUsers(int data) {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.addOnlineUsers');
    try {
      return super.addOnlineUsers(data);
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeOnlineUser(int data) {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.removeOnlineUser');
    try {
      return super.removeOnlineUser(data);
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearOnlineUser() {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.clearOnlineUser');
    try {
      return super.clearOnlineUser();
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addUnReads(UnreadThreadModel data) {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.addUnReads');
    try {
      return super.addUnReads(data);
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeUnReads(UnreadThreadModel data) {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.removeUnReads');
    try {
      return super.removeUnReads(data);
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearUnReads() {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.clearUnReads');
    try {
      return super.clearUnReads();
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addTyping(UnreadThreadModel data) {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.addTyping');
    try {
      return super.addTyping(data);
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTyping(UnreadThreadModel data) {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.removeTyping');
    try {
      return super.removeTyping(data);
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearTyping() {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.clearTyping');
    try {
      return super.clearTyping();
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMessageCount(int value) {
    final _$actionInfo = _$MessageStoreBaseActionController.startAction(
        name: 'MessageStoreBase.setMessageCount');
    try {
      return super.setMessageCount(value);
    } finally {
      _$MessageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
globalChatBackground: ${globalChatBackground},
messageCount: ${messageCount},
userNameKey: ${userNameKey},
userAvatarKey: ${userAvatarKey},
bmSecretKey: ${bmSecretKey},
refreshRecentMessage: ${refreshRecentMessage},
refreshChat: ${refreshChat},
allowBlock: ${allowBlock},
onlineUsers: ${onlineUsers},
unreadThreads: ${unreadThreads},
typingList: ${typingList}
    ''';
  }
}
