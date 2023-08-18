import 'package:socialv/models/lms/lms_common_models/course_data.dart';

class QuizModel {
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
  List<Question>? questions;
  Results? results;
  String? slug;
  String? status;

  QuizModel(
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
      this.questions,
      this.results,
      this.slug,
      this.status});

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
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
      questions: json['questions'] != null ? (json['questions'] as List).map((i) => Question.fromJson(i)).toList() : null,
      results: json['results'] != null ? Results.fromJson(json['results']) : null,
      slug: json['slug'],
      status: json['status'],
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
    if (this.assigned != null) {
      data['assigned'] = this.assigned!.toJson();
    }
    if (this.meta_data != null) {
      data['meta_data'] = this.meta_data!.toJson();
    }
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    if (this.results != null) {
      data['results'] = this.results!.toJson();
    }
    return data;
  }
}

class Question {
  Object? object;
  String? content;
  int? id;
  List<Option>? options;
  int? point;
  String? title;
  String? type;

  Question({this.object, this.content, this.id, this.options, this.point, this.title, this.type});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      object: json['`object`'] != null ? Object.fromJson(json['`object`']) : null,
      content: json['content'],
      id: json['id'],
      options: json['options'] != null ? (json['options'] as List).map((i) => Option.fromJson(i)).toList() : null,
      point: json['point'],
      title: json['title'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['id'] = this.id;
    data['point'] = this.point;
    data['title'] = this.title;
    data['type'] = this.type;
    if (this.object != null) {
      data['`object`'] = this.object!.toJson();
    }
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Option {
  String? is_true;
  String? title;
  int? uid;
  String? value;
  String? title_api;
  var answers;

  Option({this.is_true, this.title, this.uid, this.value, this.title_api, this.answers});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      is_true: json['is_true'],
      title: json['title'],
      uid: json['uid'],
      value: json['value'],
      title_api: json['title_api'],
      answers: json['answers'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_true'] = this.is_true;
    data['title'] = this.title;
    data['uid'] = this.uid;
    data['value'] = this.value;
    data['title_api'] = this.title_api;
    data['answers'] = this.answers;
    return data;
  }
}

class Object {
  String? object_type;

  Object({this.object_type});

  factory Object.fromJson(Map<String, dynamic> json) {
    return Object(
      object_type: json['object_type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object_type'] = this.object_type;
    return data;
  }
}

class Results {
  List<ResultsX>? attempts;
  List<Object>? checked_questions;
  int? duration;
  bool? instant_check;
  bool? negative_marking;
  bool? page_numbers;
  String? passing_grade;
  List<int>? question_ids;
  int? questions_per_page;
  ResultsX? results;
  int? retake_count;
  int? retaken;
  bool? review_questions;
  String? start_time;
  String? status;
  List<String>? support_options;
  int? total_time;
  Map<String, dynamic>? answered;

  Results(
      {this.attempts,
      this.checked_questions,
      this.duration,
      this.instant_check,
      this.negative_marking,
      this.page_numbers,
      this.passing_grade,
      this.question_ids,
      this.questions_per_page,
      this.results,
      this.retake_count,
      this.retaken,
      this.review_questions,
      this.start_time,
      this.status,
      this.support_options,
      this.total_time,
      this.answered});

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      attempts: json['attempts'] != null ? (json['attempts'] as List).map((i) => ResultsX.fromJson(i)).toList() : null,
      checked_questions: json['checked_questions'] != null ? (json['checked_questions'] as List).map((i) => Object.fromJson(i)).toList() : null,
      duration: json['duration'],
      instant_check: json['instant_check'],
      negative_marking: json['negative_marking'],
      page_numbers: json['page_numbers'],
      passing_grade: json['passing_grade'],
      question_ids: json['question_ids'] != null ? new List<int>.from(json['question_ids']) : null,
      questions_per_page: json['questions_per_page'],
      results: json['results'] != null ? ResultsX.fromJson(json['results']) : null,
      retake_count: json['retake_count'],
      retaken: json['retaken'],
      review_questions: json['review_questions'],
      start_time: json['start_time'],
      status: json['status'],
      support_options: json['support_options'] != null ? new List<String>.from(json['support_options']) : null,
      total_time: json['total_time'],
      answered: json['answered'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['instant_check'] = this.instant_check;
    data['negative_marking'] = this.negative_marking;
    data['page_numbers'] = this.page_numbers;
    data['passing_grade'] = this.passing_grade;
    data['questions_per_page'] = this.questions_per_page;
    data['retake_count'] = this.retake_count;
    data['retaken'] = this.retaken;
    data['review_questions'] = this.review_questions;
    data['start_time'] = this.start_time;
    data['status'] = this.status;
    data['total_time'] = this.total_time;
    data['answered'] = this.answered;
    if (this.attempts != null) {
      data['attempts'] = this.attempts!.map((v) => v.toJson()).toList();
    }
    if (this.checked_questions != null) {
      data['checked_questions'] = this.checked_questions!.map((v) => v.toJson()).toList();
    }
    if (this.question_ids != null) {
      data['question_ids'] = this.question_ids;
    }
    if (this.results != null) {
      data['results'] = this.results!.toJson();
    }
    if (this.support_options != null) {
      data['support_options'] = this.support_options;
    }
    return data;
  }
}

class ResultsX {
  String? graduation;
  String? graduationText;
  int? mark;
  String? passing_grade;
  int? question_answered;
  int? question_correct;
  int? question_count;
  int? question_empty;
  int? question_wrong;
  int? result;
  String? status;
  String? time_spend;
  int? user_item_id;
  int? user_mark;

  //Map<String, dynamic>? questions;

  ResultsX({
    this.graduation,
    this.graduationText,
    //this.interval,
    this.mark,
    this.passing_grade,
    this.question_answered,
    this.question_correct,
    this.question_count,
    this.question_empty,
    this.question_wrong,
    this.result,
    this.status,
    this.time_spend,
    this.user_item_id,
    this.user_mark,
    //this.questions,
  });

  factory ResultsX.fromJson(Map<String, dynamic> json) {
    return ResultsX(
      graduation: json['graduation'],
      graduationText: json['graduationText'],
      // interval: json['interval'] != null ? (json['interval'] as List).map((i) => Any.fromJson(i)).toList() : null,
      mark: json['mark'],
      passing_grade: json['passing_grade'],
      question_answered: json['question_answered'],
      question_correct: json['question_correct'],
      question_count: json['question_count'],
      question_empty: json['question_empty'],
      question_wrong: json['question_wrong'],
      result: json['result'],
      status: json['status'],
      time_spend: json['time_spend'],
      user_item_id: json['user_item_id'],
      user_mark: json['user_mark'],
      //questions: json['questions'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['graduation'] = this.graduation;
    data['graduationText'] = this.graduationText;
    data['mark'] = this.mark;
    data['passing_grade'] = this.passing_grade;
    data['question_answered'] = this.question_answered;
    data['question_correct'] = this.question_correct;
    data['question_count'] = this.question_count;
    data['question_empty'] = this.question_empty;
    data['question_wrong'] = this.question_wrong;
    data['result'] = this.result;
    data['status'] = this.status;
    data['time_spend'] = this.time_spend;
    data['user_item_id'] = this.user_item_id;
    data['user_mark'] = this.user_mark;
    //data['questions'] = this.questions;
    /* if (this.interval != null) {
      data['interval'] = this.interval.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}

class MetaData {
  String? lp_duration;
  String? lp_instant_check;
  String? lp_minus_skip_questions;
  String? lp_negative_marking;
  String? lp_pagination;
  String? lp_passing_grade;
  String? lp_retake_count;
  String? lp_review;
  String? lp_show_correct_review;

  MetaData({this.lp_duration, this.lp_instant_check, this.lp_minus_skip_questions, this.lp_negative_marking, this.lp_pagination, this.lp_passing_grade, this.lp_retake_count, this.lp_review, this.lp_show_correct_review});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      lp_duration: json['_lp_duration'],
      lp_instant_check: json['_lp_instant_check'],
      lp_minus_skip_questions: json['_lp_minus_skip_questions'],
      lp_negative_marking: json['_lp_negative_marking'],
      lp_pagination: json['_lp_pagination'],
      lp_passing_grade: json['_lp_passing_grade'],
      lp_retake_count: json['_lp_retake_count'],
      lp_review: json['_lp_review'],
      lp_show_correct_review: json['_lp_show_correct_review'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_lp_duration'] = this.lp_duration;
    data['_lp_instant_check'] = this.lp_instant_check;
    data['_lp_minus_skip_questions'] = this.lp_minus_skip_questions;
    data['_lp_negative_marking'] = this.lp_negative_marking;
    data['_lp_pagination'] = this.lp_pagination;
    data['_lp_passing_grade'] = this.lp_passing_grade;
    data['_lp_retake_count'] = this.lp_retake_count;
    data['_lp_review'] = this.lp_review;
    data['_lp_show_correct_review'] = this.lp_show_correct_review;
    return data;
  }
}

class QuestionAnsweresModel {
  String? answered;
  bool? correct;
  String? explanation;
  int? mark;
  List<Option>? options;

  QuestionAnsweresModel({this.answered, this.correct, this.explanation, this.mark, this.options});

  factory QuestionAnsweresModel.fromJson(Map<String, dynamic> json) {
    return QuestionAnsweresModel(
      answered: json['answered'],
      correct: json['correct'],
      explanation: json['explanation'],
      mark: json['mark'],
      options: json['options'] != null ? (json['options'] as List).map((i) => Option.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answered'] = this.answered;
    data['correct'] = this.correct;
    data['explanation'] = this.explanation;
    data['mark'] = this.mark;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OptionAnswer {
  bool? is_correct;
  String? answer;
  String? correct;

  OptionAnswer({this.is_correct, this.answer, this.correct});

  factory OptionAnswer.fromJson(Map<String, dynamic> json) {
    return OptionAnswer(
      is_correct: json['is_correct'],
      answer: json['answer'],
      correct: json['correct'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_correct'] = this.is_correct;
    data['answer'] = this.answer;
    data['correct'] = this.correct;
    return data;
  }
}
