import 'package:socialv/models/messages/message_users.dart';
import 'package:socialv/models/messages/threads_list_model.dart';

class SearchMessageResponse {
  SearchMessageResponse({
    this.users,
    this.friends,
    this.messages,
    this.updateData,
  });

  SearchMessageResponse.fromJson(dynamic json) {
    users = json['users'] != null ? (json['users'] as List).map((i) => MessagesUsers.fromJson(i)).toList() : null;
    friends = json['friends'] != null ? (json['friends'] as List).map((i) => MessagesUsers.fromJson(i)).toList() : null;
    messages = json['messages'] != null ? (json['messages'] as List).map((i) => SearchMessage.fromJson(i)).toList() : null;
    updateData = json['updateData'] != null ? ThreadsListModel.fromJson(json['updateData']) : null;
  }

  List<MessagesUsers>? users;
  List<MessagesUsers>? friends;
  List<SearchMessage>? messages;
  ThreadsListModel? updateData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (users != null) {
      map['users'] = users!.map((v) => v.toJson()).toList();
    }
    if (friends != null) {
      map['friends'] = friends!.map((v) => v.toJson()).toList();
    }
    if (messages != null) {
      map['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    if (this.updateData != null) {
      map['updateData'] = this.updateData!.toJson();
    }

    return map;
  }
}

class SearchMessage {
  SearchMessage({
    this.threadId,
    this.count,
    this.messageId,
  });

  SearchMessage.fromJson(dynamic json) {
    threadId = json['thread_id'];
    count = json['count'];
    messageId = json['message_id'];
  }

  int? threadId;
  int? count;
  int? messageId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['thread_id'] = threadId;
    map['count'] = count;
    map['message_id'] = messageId;

    return map;
  }
}
