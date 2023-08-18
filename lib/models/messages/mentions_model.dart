class MentionsModel {
  MentionsModel({
    this.userId,
    this.label,
  });

  MentionsModel.fromJson(dynamic json) {
    userId = json['user_id'];
    label = json['label'];
  }

  int? userId;
  String? label;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['label'] = label;
    return map;
  }
}

class FlutterMentionsModel {
  FlutterMentionsModel({
    this.id,
    this.full_name,
    this.display,
    this.photo,
  });

  FlutterMentionsModel.fromJson(dynamic json) {
    id = json['id'];
    full_name = json['full_name'];
    display = json['display'];
    photo = json['photo'];
  }

  String? id;
  String? full_name;
  String? display;
  String? photo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['full_name'] = full_name;
    map['display'] = display;
    map['photo'] = photo;
    return map;
  }
}
