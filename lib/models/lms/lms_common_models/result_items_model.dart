class Items {
  ResultLesson? lesson;
  ResultQuiz? quiz;

  Items({this.lesson, this.quiz});

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      lesson: json['lesson'] != null ? ResultLesson.fromJson(json['lesson']) : null,
      quiz: json['quiz'] != null ? ResultQuiz.fromJson(json['quiz']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lesson != null) {
      data['lesson'] = this.lesson!.toJson();
    }
    if (this.quiz != null) {
      data['quiz'] = this.quiz!.toJson();
    }
    return data;
  }
}

class ResultLesson {
  var completed;
  var passed;
  int? total;

  ResultLesson({this.completed, this.passed, this.total});

  factory ResultLesson.fromJson(Map<String, dynamic> json) {
    return ResultLesson(
      completed: json['completed'],
      passed: json['passed'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['completed'] = this.completed;
    data['passed'] = this.passed;
    data['total'] = this.total;
    return data;
  }
}

class ResultQuiz {
  var completed;
  var passed;
  int? total;

  ResultQuiz({this.completed, this.passed, this.total});

  factory ResultQuiz.fromJson(Map<String, dynamic> json) {
    return ResultQuiz(
      completed: json['completed'],
      passed: json['passed'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['completed'] = this.completed;
    data['passed'] = this.passed;
    data['total'] = this.total;
    return data;
  }
}
