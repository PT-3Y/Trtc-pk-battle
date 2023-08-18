import 'package:nb_utils/nb_utils.dart';

//type 'int' is not a subtype of type 'String?'
class CourseReviewModel {
  Data? data;
  String? message;
  String? status;

  CourseReviewModel({this.data, this.message, this.status});

  factory CourseReviewModel.fromJson(Map<String, dynamic> json) {
    return CourseReviewModel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? can_review;
  Map<String, dynamic>? items;
  String? rated;
  Reviews? reviews;
  int? total;

  Data({this.can_review, this.items, this.rated, this.reviews, this.total});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      can_review: json['can_review'],
      items: json['items'],
      rated: json['rated'].toString(),
      reviews: json['reviews'] != null ? Reviews.fromJson(json['reviews']) : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['can_review'] = this.can_review;
    data['rated'] = this.rated;
    data['total'] = this.total;
    if (this.items != null) {
      data['items'] = this.items;
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.toJson();
    }
    return data;
  }
}

class SingleRatingItem {
  int? percent;
  double? percent_float;
  var rated;
  var total;

  SingleRatingItem({this.percent, this.percent_float, this.rated, this.total});

  factory SingleRatingItem.fromJson(Map<String, dynamic> json) {
    return SingleRatingItem(
      percent: json['percent'],
      percent_float: json['percent_float'].toString().toDouble(),
      rated: json['rated'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['percent'] = this.percent;
    data['percent_float'] = this.percent_float;
    data['rated'] = this.rated;
    data['total'] = this.total;
    return data;
  }
}

class Reviews {
  bool? finish;
  int? paged;
  int? per_page;
  List<Review>? reviews;
  int? total;

  Reviews({this.finish, this.paged, this.per_page, this.reviews, this.total});

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      finish: json['finish'],
      paged: json['paged'],
      per_page: json['per_page'],
      reviews: json['reviews'] != null ? (json['reviews'] as List).map((i) => Review.fromJson(i)).toList() : null,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['finish'] = this.finish;
    data['paged'] = this.paged;
    data['per_page'] = this.per_page;
    data['total'] = this.total;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Review {
  String? comment_id;
  String? content;
  String? display_name;
  String? rate;
  String? title;
  String? user_email;

  Review({this.comment_id, this.content, this.display_name, this.rate, this.title, this.user_email});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      comment_id: json['comment_id'],
      content: json['content'],
      display_name: json['display_name'],
      rate: json['rate'],
      title: json['title'],
      user_email: json['user_email'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_id'] = this.comment_id;
    data['content'] = this.content;
    data['display_name'] = this.display_name;
    data['rate'] = this.rate;
    data['title'] = this.title;
    data['user_email'] = this.user_email;
    return data;
  }
}
