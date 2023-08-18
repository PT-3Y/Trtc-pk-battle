import 'threads_model.dart';
import 'message_users.dart';
import 'messages_model.dart';

class ThreadsListModel {
  ThreadsListModel({
    this.threads,
    this.users,
    this.messages,
    this.serverTime,
  });

  ThreadsListModel.fromJson(dynamic json) {
    if (json['threads'] != null) {
      threads = [];
      json['threads'].forEach((v) {
        threads!.add(Threads.fromJson(v));
      });
    }
    if (json['users'] != null) {
      users = [];
      json['users'].forEach((v) {
        users!.add(MessagesUsers.fromJson(v));
      });
    }
    if (json['messages'] != null) {
      messages = [];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
    serverTime = json['serverTime'];
  }

  List<Threads>? threads;
  List<MessagesUsers>? users;
  List<Messages>? messages;
  int? serverTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (threads != null) {
      map['threads'] = threads!.map((v) => v.toJson()).toList();
    }
    if (users != null) {
      map['users'] = users!.map((v) => v.toJson()).toList();
    }
    if (messages != null) {
      map['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    map['serverTime'] = serverTime;
    return map;
  }
}
