import 'dart:math';

class Messages {
  Messages({
    this.threadId,
    this.senderId,
    this.message,
    this.dateSent,
    this.messageId,
    this.favorited,
    this.lastUpdate,
    this.createdAt,
    this.tmpId,
    this.meta,
  });

  Messages.fromJson(dynamic json) {
    threadId = json['thread_id'];
    senderId = json['sender_id'];
    message = json['message'];
    dateSent = json['date_sent'];
    messageId = json['message_id'];
    favorited = json['favorited'];
    lastUpdate = json['lastUpdate'];
    createdAt = json['createdAt'];
    tmpId = json['tmpId'];
    meta = json['meta'] != [] ? json['meta'] : null;
  }

  int? threadId;
  int? senderId;
  String? message;
  String? dateSent;
  int? messageId;
  int? favorited;
  int? lastUpdate;
  int? createdAt;
  String? tmpId;
  var meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['thread_id'] = threadId;
    map['sender_id'] = senderId;
    map['message'] = message;
    map['date_sent'] = dateSent;
    map['message_id'] = messageId;
    map['favorited'] = favorited;
    map['lastUpdate'] = lastUpdate;
    map['createdAt'] = createdAt;
    map['tmpId'] = tmpId;
    if (meta != null) {
      map['meta'] = meta!.toJson();
    }
    return map;
  }
}

class MessageMeta {
  MessageMeta({this.files, this.replyTo, this.encryptedMessage, this.reactions});

  MessageMeta.fromJson(dynamic json) {
    if (json['files'] != null) {
      files = [];
      json['files'].forEach((v) {
        files!.add(MessageFiles.fromJson(v));
      });
    }
    if (json['reactions'] != null) {
      reactions = [];
      json['reactions'].forEach((v) {
        reactions!.add(ReactionForChat.fromJson(v));
      });
    }
    replyTo = json['replyTo'];
    encryptedMessage = json['encrypted_message'];
  }

  List<MessageFiles>? files;
  int? replyTo;
  List<ReactionForChat>? reactions;
  String? encryptedMessage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (files != null) {
      map['files'] = files!.map((v) => v.toJson()).toList();
    }
    if (reactions != null) {
      map['reactions'] = reactions!.map((v) => v.toJson()).toList();
    }
    map['replyTo'] = replyTo;
    map['encrypted_message'] = encryptedMessage;
    return map;
  }
}

class MessageFiles {
  MessageFiles({
    this.id,
    this.thumb,
    this.url,
    this.mimeType,
    this.name,
    this.size,
    this.ext,
  });

  MessageFiles.fromJson(dynamic json) {
    id = json['id'];
    thumb = json['thumb'].toString();
    url = json['url'];
    mimeType = json['mimeType'];
    name = json['name'];
    size = json['size'];
    ext = json['ext'];
  }

  int? id;
  String? thumb;
  String? url;
  String? mimeType;
  String? name;
  int? size;
  String? ext;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['thumb'] = thumb;
    map['url'] = url;
    map['mimeType'] = mimeType;
    map['name'] = name;
    map['size'] = size;
    map['ext'] = ext;
    return map;
  }
}

class ReactionForChat {
  String? reaction;
  List<int>? users;

  ReactionForChat({
    this.reaction,
    this.users,
  });

  factory ReactionForChat.fromJson(Map<String, dynamic> json) => ReactionForChat(
        reaction: json["reaction"],
        users: json["users"] == null ? [] : List<int>.from(json["users"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "reaction": reaction,
        "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x)),
      };
}
