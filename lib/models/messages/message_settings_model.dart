class MessageSettingsModel {
  MessageSettingsModel({
    this.allowUsersBlock,
  });

  MessageSettingsModel.fromJson(dynamic json) {
    allowUsersBlock = json['allowUsersBlock'];
  }

  String? allowUsersBlock;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['allowUsersBlock'] = allowUsersBlock;

    return map;
  }
}
