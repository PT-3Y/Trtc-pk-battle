class AlbumMediaListModel {
  AlbumMediaListModel({
    this.id,
    this.url,
    this.type,
    this.canDelete,
    this.galleryId,
  });

  AlbumMediaListModel.fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
    canDelete = json['can_delete'];
    type = json['type'];
    galleryId = json['gallery_id'];
  }

  num? id;
  String? url;
  String? type;
  String? galleryId;
  bool? canDelete;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['can_delete'] = canDelete;
    map['url'] = url;
    map['type'] = type;
    map['gallery_id'] = galleryId;
    return map;
  }
}
