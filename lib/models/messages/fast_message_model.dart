class FastMessageModel {
  FastMessageModel({
    this.tempId,
    this.threadId,
    this.message,
    this.user,
    this.time,
    this.senderId,
  });

  FastMessageModel.fromJson(dynamic json) {
    tempId = json['tempId'];
    threadId = json['threadId'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    time = json['time'];
    senderId = json['sender_id'];
  }

  String? tempId;
  int? threadId;
  String? message;
  User? user;
  String? time;
  int? senderId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tempId'] = tempId;
    map['threadId'] = threadId;
    map['message'] = message;
    if (user != null) {
      map['user'] = user!.toJson();
    }
    map['time'] = time;
    map['sender_id'] = senderId;
    return map;
  }
}

class User {
  User({
    this.userId,
    this.name,
    this.avatar,
  });

  User.fromJson(dynamic json) {
    userId = json['user_id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  int? userId;
  String? name;
  String? avatar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['name'] = name;
    map['avatar'] = avatar;
    return map;
  }
}

class AbortMessageModel {
  AbortMessageModel({
    this.threadId,
    this.messageId,
  });

  AbortMessageModel.fromJson(dynamic json) {
    threadId = json['thread_id'];
    messageId = json['message_id'];
  }

  int? threadId;
  String? messageId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['thread_id'] = threadId;
    map['message_id'] = messageId;
    return map;
  }
}
