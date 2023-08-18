class MediaModel {
  List<String>? allowedType;
  bool? isActive;
  String? title;
  String? type;

  MediaModel({this.allowedType, this.isActive, this.title, this.type});

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      allowedType: json['allowed_type'] != null ? new List<String>.from(json['allowed_type']) : null,
      isActive: json['is_active'],
      title: json['title'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_active'] = this.isActive;
    data['title'] = this.title;
    data['type'] = this.type;
    if (this.allowedType != null) {
      data['allowed_type'] = this.allowedType;
    }
    return data;
  }
}
