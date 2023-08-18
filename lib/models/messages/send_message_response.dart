import 'package:socialv/models/messages/messages_model.dart';
import 'package:socialv/models/messages/message_users.dart';

class SendMessageResponse {
  SendMessageResponse({
    this.result,
    this.messageId,
    this.update,
    this.redirect,
  });

  SendMessageResponse.fromJson(dynamic json) {
    result = json['result'];
    messageId = json['message_id'];
    update = json['update'] != null ? Update.fromJson(json['update']) : null;
    redirect = json['redirect'];
  }

  bool? result;
  int? messageId;
  Update? update;
  bool? redirect;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['result'] = result;
    map['message_id'] = messageId;
    if (update != null) {
      map['update'] = update!.toJson();
    }
    map['redirect'] = redirect;
    return map;
  }
}

class Update {
  Update({
    this.users,
    this.messages,
  });

  Update.fromJson(dynamic json) {
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

  List<MessagesUsers>? users;
  List<Messages>? messages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (users != null) {
      map['users'] = users!.map((v) => v.toJson()).toList();
    }
    if (messages != null) {
      map['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
