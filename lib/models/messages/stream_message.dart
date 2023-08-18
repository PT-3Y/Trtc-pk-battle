import 'package:socialv/models/messages/threads_model.dart';

class StreamMessage {
  StreamMessage({
    this.thread,
    this.threadId,
    this.messageId,
    this.meta,
  });

  StreamMessage.fromJson(dynamic json) {
    thread = json['thread'] != null ? Threads.fromJson(json['thread']) : null;
    threadId = json['thread_id'];
    messageId = json['message_id'];
    meta = json['meta'] != [] ? json['meta'] : null;
  }

  Threads? thread;
  int? threadId;
  int? messageId;
  var meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (thread != null) {
      map['thread'] = thread!.toJson();
    }
    if (meta != null) {
      map['meta'] = meta!.toJson();
    }
    map['thread_id'] = threadId;
    map['message_id'] = messageId;

    return map;
  }
}
