class QuizAnswers {
  int quizId;
  List<Answers>? answers;
  String startQuizTime;
  bool isHours;

  QuizAnswers({required this.quizId, required this.answers, required this.isHours, required this.startQuizTime});

  factory QuizAnswers.fromJson(Map<String, dynamic> json) {
    return QuizAnswers(
      quizId: json['quizId'],
      startQuizTime: json['secondsTimer'],
      isHours: json['isHours'],
      answers: json['answers'] != null ? (json['answers'] as List).map((i) => Answers.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quizId'] = this.quizId;
    data['secondsTimer'] = this.startQuizTime;
    data['isHours'] = this.isHours;

    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Answers {
  String? questionId;
  String? value;

  Answers({this.questionId, this.value});

  factory Answers.fromJson(Map<String, dynamic> json) {
    return Answers(
      questionId: json['questionId'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionId'] = this.questionId;
    data['value'] = this.value;

    return data;
  }
}
