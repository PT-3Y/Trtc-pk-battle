import 'package:socialv/models/lms/lms_common_models/result_model.dart';

class CourseData {
  String? end_time;
  String? expiration_time;
  String? graduation;
  Result? result;
  String? start_time;
  String? status;

  CourseData({this.end_time, this.expiration_time, this.graduation, this.result, this.start_time, this.status});

  factory CourseData.fromJson(Map<String, dynamic> json) {
    return CourseData(
      end_time: json['end_time'],
      expiration_time: json['expiration_time'],
      graduation: json['graduation'],
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
      start_time: json['start_time'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['end_time'] = this.end_time;
    data['expiration_time'] = this.expiration_time;
    data['graduation'] = this.graduation;
    data['start_time'] = this.start_time;
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Assigned {
  Course? course;

  Assigned({this.course});

  factory Assigned.fromJson(Map<String, dynamic> json) {
    return Assigned(
      course: json['course'] != null ? Course.fromJson(json['course']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.course != null) {
      data['course'] = this.course!.toJson();
    }
    return data;
  }
}

class Course {
  String? author;
  String? content;
  String? id;
  String? slug;
  String? title;

  Course({this.author, this.content, this.id, this.slug, this.title});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      author: json['author'],
      content: json['content'],
      id: json['id'],
      slug: json['slug'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['content'] = this.content;
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['title'] = this.title;
    return data;
  }
}
