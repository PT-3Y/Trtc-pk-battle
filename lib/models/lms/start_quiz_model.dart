import 'package:socialv/models/lms/quiz_model.dart';

class StartQuizModel {
  String? message;
  Results? results;
  String? status;

  StartQuizModel({this.message, this.results, this.status});

  factory StartQuizModel.fromJson(Map<String, dynamic> json) {
    return StartQuizModel(
      message: json['message'],
      results: json['results'] != null ? Results.fromJson(json['results']) : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.results != null) {
      data['results'] = this.results!.toJson();
    }
    return data;
  }
}

class Results {
  List<Object>? attempts;
  int? duration;
  List<String>? question_ids;
  List<Question>? questions;
  int? retaken;
  String? status;
  int? total_time;
  int? user_item_id;

  Results({this.attempts, this.duration, this.question_ids, this.questions, this.retaken, this.status, this.total_time, this.user_item_id});

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      attempts: json['attempts'] != null ? (json['attempts'] as List).map((i) => Object.fromJson(i)).toList() : null,
      duration: json['duration'],
      question_ids: json['question_ids'] != null ? new List<String>.from(json['question_ids']) : null,
      questions: json['questions'] != null ? (json['questions'] as List).map((i) => Question.fromJson(i)).toList() : null,
      retaken: json['retaken'],
      status: json['status'],
      total_time: json['total_time'],
      user_item_id: json['user_item_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['retaken'] = this.retaken;
    data['status'] = this.status;
    data['total_time'] = this.total_time;
    data['user_item_id'] = this.user_item_id;
    if (this.attempts != null) {
      data['attempts'] = this.attempts!.map((v) => v.toJson()).toList();
    }
    if (this.question_ids != null) {
      data['question_ids'] = this.question_ids;
    }
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
