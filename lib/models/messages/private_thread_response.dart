import 'package:socialv/models/messages/message_users.dart';
import 'package:socialv/models/messages/messages_model.dart';
import 'package:socialv/models/messages/threads_model.dart';

class PrivateThreadResponse {
  PrivateThreadResponse({
    this.result,
    this.threadId,
    this.threads,
    this.users,
    this.messages,
  });

  PrivateThreadResponse.fromJson(dynamic json) {
    result = json['result'];
    threadId = json['thread_id'];
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
  }

  String? result;
  int? threadId;
  List<Threads>? threads;
  List<MessagesUsers>? users;
  List<Messages>? messages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['result'] = result;
    map['thread_id'] = threadId;
    if (threads != null) {
      map['threads'] = threads!.map((v) => v.toJson()).toList();
    }
    if (users != null) {
      map['users'] = users!.map((v) => v.toJson()).toList();
    }
    if (messages != null) {
      map['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
