import 'package:socialv/models/lms/lms_common_models/social_model.dart';

class Instructor {
  String? avatar;
  String? description;
  int? id;
  String? name;
  Social? social;

  Instructor({this.avatar, this.description, this.id, this.name, this.social});

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      avatar: json['avatar'],
      description: json['description'],
      id: json['id'],
      name: json['name'],
      social: json['social'] != null ? Social.fromJson(json['social']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar'] = this.avatar;
    data['description'] = this.description;
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.social != null) {
      data['social'] = this.social!.toJson();
    }
    return data;
  }
}
