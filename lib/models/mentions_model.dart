class MentionsModel {
  int? id;
  String? display;
  String? fullName;
  String? photo;

  MentionsModel({this.id, this.display, this.fullName, this.photo});

  /// todo : use this model for any user list

  factory MentionsModel.fromJson(Map<String, dynamic> json) {
    return MentionsModel(
      id: json['id'],
      display: json['display'],
      fullName: json['full_name'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['display'] = this.display;
    data['full_name'] = this.fullName;
    data['photo'] = this.photo;
    return data;
  }
}
