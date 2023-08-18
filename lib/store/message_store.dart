import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/models/messages/unread_threads.dart';
import 'package:socialv/utils/app_constants.dart';

part 'message_store.g.dart';

class MessageStore = MessageStoreBase with _$MessageStore;

abstract class MessageStoreBase with Store {
  @observable
  String globalChatBackground = '';

  @observable
  int messageCount = 0;

  @observable
  String userNameKey = '';

  @observable
  String userAvatarKey = '';

  @observable
  String bmSecretKey = '';

  @observable
  bool refreshRecentMessage = false;

  @observable
  bool refreshChat = false;

  @observable
  bool allowBlock = false;

  @action
  void setRefreshRecentMessages(bool val) {
    refreshRecentMessage = val;
  }

  @action
  void setRefreshChat(bool val) {
    refreshChat = val;
  }

  @action
  void setAllowBlock(bool val) {
    allowBlock = val;
  }

  @action
  Future<void> setUserNameKey(String val, {bool isInitializing = false}) async {
    userNameKey = val;
    if (!isInitializing) await setValue(SharePreferencesKey.USERNAME_KEY, '$val');
  }

  @action
  Future<void> setUserAvatarKey(String val, {bool isInitializing = false}) async {
    userAvatarKey = val;
    if (!isInitializing) await setValue(SharePreferencesKey.USER_AVATAR_KEY, '$val');
  }

  @action
  Future<void> setBmSecretKey(String val, {bool isInitializing = false}) async {
    bmSecretKey = val;
    if (!isInitializing) await setValue(SharePreferencesKey.BM_SECRET_KEY, '$val');
  }

  @observable
  List<int> onlineUsers = ObservableList<int>();

  @action
  void addOnlineUsers(int data) => onlineUsers.add(data);

  @action
  void removeOnlineUser(int data) => onlineUsers.remove(data);

  @action
  void clearOnlineUser() => onlineUsers.clear();

  @observable
  var unreadThreads = ObservableList<UnreadThreadModel>();

  @action
  void addUnReads(UnreadThreadModel data) => unreadThreads.add(data);

  @action
  void removeUnReads(UnreadThreadModel data) => unreadThreads.remove(data);

  @action
  void clearUnReads() => unreadThreads.clear();

  @observable
  var typingList = ObservableList<UnreadThreadModel>();

  @action
  void addTyping(UnreadThreadModel data) => typingList.add(data);

  @action
  void removeTyping(UnreadThreadModel data) => typingList.remove(data);

  @action
  void clearTyping() => typingList.clear();

  @action
  void setMessageCount(int value) {
    messageCount = value;
  }

  @action
  Future<void> setGlobalChatBackground(String val) async {
    globalChatBackground = val;
  }
}
