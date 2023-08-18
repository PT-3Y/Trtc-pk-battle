import 'package:socialv/models/lms/lms_common_models/course_data.dart';

class LessonModel {
  Assigned? assigned;
  bool? can_finish_course;
  String? content;
  String? date_created;
  String? date_created_gmt;
  String? date_modified;
  String? date_modified_gmt;
  String? duration;
  String? excerpt;
  int? id;
  MetaData? meta_data;
  String? name;
  String? permalink;
  Results? results;
  String? slug;
  String? status;
  String? video_intro;

  LessonModel(
      {this.assigned,
      this.can_finish_course,
      this.content,
      this.date_created,
      this.date_created_gmt,
      this.date_modified,
      this.date_modified_gmt,
      this.duration,
      this.excerpt,
      this.id,
      this.meta_data,
      this.name,
      this.permalink,
      this.results,
      this.slug,
      this.status,
      this.video_intro});

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      assigned: json['assigned'] != null ? Assigned.fromJson(json['assigned']) : null,
      can_finish_course: json['can_finish_course'],
      content: json['content'],
      date_created: json['date_created'],
      date_created_gmt: json['date_created_gmt'],
      date_modified: json['date_modified'],
      date_modified_gmt: json['date_modified_gmt'],
      duration: json['duration'],
      excerpt: json['excerpt'],
      id: json['id'],
      meta_data: json['meta_data'] != null ? MetaData.fromJson(json['meta_data']) : null,
      name: json['name'],
      permalink: json['permalink'],
      results: json['results'] != null ? Results.fromJson(json['results']) : null,
      slug: json['slug'],
      status: json['status'],
      video_intro: json['video_intro'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['can_finish_course'] = this.can_finish_course;
    data['content'] = this.content;
    data['date_created'] = this.date_created;
    data['date_created_gmt'] = this.date_created_gmt;
    data['date_modified'] = this.date_modified;
    data['date_modified_gmt'] = this.date_modified_gmt;
    data['duration'] = this.duration;
    data['excerpt'] = this.excerpt;
    data['id'] = this.id;
    data['name'] = this.name;
    data['permalink'] = this.permalink;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['video_intro'] = this.video_intro;
    if (this.assigned != null) {
      data['assigned'] = this.assigned!.toJson();
    }
    if (this.meta_data != null) {
      data['meta_data'] = this.meta_data!.toJson();
    }
    if (this.results != null) {
      data['results'] = this.results!.toJson();
    }
    return data;
  }
}

class Results {
  String? status;

  Results({this.status});

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}

class MetaData {
  String? lp_duration;
  String? lp_preview;

  MetaData({this.lp_duration, this.lp_preview});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      lp_duration: json['_lp_duration'],
      lp_preview: json['_lp_preview'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_lp_duration'] = this.lp_duration;
    data['_lp_preview'] = this.lp_preview;
    return data;
  }
}
