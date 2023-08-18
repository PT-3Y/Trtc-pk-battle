
class Notifications {
  Notifications({
      this.id, 
      this.title, 
      this.type, 
      this.options,});

  Notifications.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    if (json['options'] != null) {
      options = [];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }
  String? id;
  String? title;
  String? type;
  List<Options>? options;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['type'] = type;
    if (options != null) {
      map['options'] = options!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


class Options {
  Options({
    this.id,
    this.label,
    this.value,
    this.checked,
    this.desc,});

  Options.fromJson(dynamic json) {
    id = json['id'];
    label = json['label'];
    value = json['value'];
    checked = json['checked'];
    desc = json['desc'];
  }
  String? id;
  String? label;
  String? value;
  bool? checked;
  String? desc;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['label'] = label;
    map['value'] = value;
    map['checked'] = checked;
    map['desc'] = desc;
    return map;
  }

}