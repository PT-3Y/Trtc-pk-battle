class Albums {
  Albums({this.id, this.name, this.description, this.thumbnail, this.type, this.status, this.canDelete});

  Albums.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    thumbnail = json['thumbnail'];
    description = json['description'];
    type = json['type'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    canDelete = json['can_delete'];
  }

  num? id;
  String? name;
  String? thumbnail;
  String? description;
  String? type;
  Status? status;
  bool? canDelete;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['thumbnail'] = thumbnail;
    map['description'] = description;
    map['can_delete'] = canDelete;
    map['type'] = type;
    if (status != null) {
      map['status'] = status?.toJson();
    }
    return map;
  }
}

class Status {
  Status({
    this.id,
    this.label,
    this.singularName,
    this.pluralName,
    this.ttId,
    this.slug,
    this.callback,
    this.activityPrivacy,
  });

  Status.fromJson(dynamic json) {
    id = json['id'];
    label = json['label'];
    singularName = json['singular_name'];
    pluralName = json['plural_name'];
    ttId = json['tt_id'];
    slug = json['slug'];
    callback = json['callback'];
    activityPrivacy = json['activity_privacy'];
  }

  num? id;
  String? label;
  String? singularName;
  String? pluralName;
  num? ttId;
  String? slug;
  String? callback;
  String? activityPrivacy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['label'] = label;
    map['singular_name'] = singularName;
    map['plural_name'] = pluralName;
    map['tt_id'] = ttId;
    map['slug'] = slug;
    map['callback'] = callback;
    map['activity_privacy'] = activityPrivacy;
    return map;
  }
}
