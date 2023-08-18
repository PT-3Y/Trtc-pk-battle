class MessageGroups {
  MessageGroups({
    this.groupId,
    this.name,
    this.messages,
    this.threadId,
    this.image,
    this.url,
  });

  MessageGroups.fromJson(dynamic json) {
    groupId = json['group_id'];
    name = json['name'];
    messages = json['messages'];
    threadId = json['thread_id'];
    image = json['image'];
    url = json['url'];
  }

  int? groupId;
  String? name;
  int? messages;
  int? threadId;
  String? image;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['group_id'] = groupId;
    map['name'] = name;
    map['messages'] = messages;
    map['thread_id'] = threadId;
    map['image'] = image;
    map['url'] = url;
    return map;
  }
}
