class MediaActiveStatusesModel {
  MediaActiveStatusesModel({
      this.id, 
      this.label, 
      this.singularName, 
      this.pluralName, 
      this.ttId, 
      this.slug, 
      this.callback, 
      this.activityPrivacy,});

  MediaActiveStatusesModel.fromJson(dynamic json) {
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