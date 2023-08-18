class ChatBackgroundModel {
  ChatBackgroundModel({
    this.id,
    this.attachmentId,
    this.url,
  });

  ChatBackgroundModel.fromJson(dynamic json) {
    id = json['id'];
    attachmentId = json['attachment_id'];
    url = json['url'];
  }

  String? id;
  int? attachmentId;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['attachment_id'] = attachmentId;
    map['url'] = url;
    return map;
  }
}
