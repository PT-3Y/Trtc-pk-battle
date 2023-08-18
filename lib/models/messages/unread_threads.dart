class UnreadThreads {
  UnreadThreads({
    this.total,
    this.threads,
  });

  UnreadThreads.fromJson(dynamic json) {
    total = json['total'];
    threads = json['threads'];
  }

  int? total;
  Map<String, dynamic>? threads;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = this.total;
    map['threads'] = this.threads;

    return map;
  }
}

class UnreadThreadModel {
  int? threadId;
  int? unreadCount;
  List<String>? typingIds;

  UnreadThreadModel({
    this.threadId,
    this.unreadCount,
    this.typingIds,
  });
}
