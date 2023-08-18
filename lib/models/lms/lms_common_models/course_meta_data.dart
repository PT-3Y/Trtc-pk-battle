class CourseMetaData {
  String? lp_allow_course_repurchase;
  String? lp_block_expire_duration;
  String? lp_block_finished;
  String? lp_course_author;
  String? lp_course_repurchase_option;
  String? lp_course_result;
  String? lp_duration;
  String? lp_external_link_buy_course;
  List<List<dynamic>>? lp_faqs;
  String? lp_featured;
  String? lp_featured_review;
  String? lp_has_finish;
  List<String>? lp_key_features;
  String? lp_level;
  String? lp_max_students;
  String? lp_no_required_enroll;
  String? lp_passing_condition;
  String? lp_regular_price;
  List<String>? lp_requirements;
  String? lp_retake_count;
  String? lp_sale_end;
  String? lp_sale_price;
  String? lp_sale_start;
  String? lp_students;
  List<String>? lp_target_audiences;

  CourseMetaData(
      {this.lp_allow_course_repurchase,
      this.lp_block_expire_duration,
      this.lp_block_finished,
      this.lp_course_author,
      this.lp_course_repurchase_option,
      this.lp_course_result,
      this.lp_duration,
      this.lp_external_link_buy_course,
      this.lp_faqs,
      this.lp_featured,
      this.lp_featured_review,
      this.lp_has_finish,
      this.lp_key_features,
      this.lp_level,
      this.lp_max_students,
      this.lp_no_required_enroll,
      this.lp_passing_condition,
      this.lp_regular_price,
      this.lp_requirements,
      this.lp_retake_count,
      this.lp_sale_end,
      this.lp_sale_price,
      this.lp_sale_start,
      this.lp_students,
      this.lp_target_audiences});

  factory CourseMetaData.fromJson(Map<String, dynamic> json) {
    return CourseMetaData(
      lp_allow_course_repurchase: json['_lp_allow_course_repurchase'],
      lp_block_expire_duration: json['_lp_block_expire_duration'],
      lp_block_finished: json['_lp_block_finished'],
      lp_course_author: json['_lp_course_author'],
      lp_course_repurchase_option: json['_lp_course_repurchase_option'],
      lp_course_result: json['_lp_course_result'],
      lp_duration: json['_lp_duration'],
      lp_external_link_buy_course: json['_lp_external_link_buy_course'],
      lp_faqs: json['_lp_faqs'] != null ? (json['_lp_faqs'] as List).map((i) => (i as List).toList()).toList() : null,
      lp_featured: json['_lp_featured'],
      lp_featured_review: json['_lp_featured_review'],
      lp_has_finish: json['_lp_has_finish'],
      lp_key_features: json['_lp_key_features'] != null ? new List<String>.from(json['_lp_key_features']) : null,
      lp_level: json['_lp_level'],
      lp_max_students: json['_lp_max_students'],
      lp_no_required_enroll: json['_lp_no_required_enroll'],
      lp_passing_condition: json['_lp_passing_condition'],
      lp_regular_price: json['_lp_regular_price'],
      lp_requirements: json['_lp_requirements'] != null ? new List<String>.from(json['_lp_requirements']) : null,
      lp_retake_count: json['_lp_retake_count'],
      lp_sale_end: json['_lp_sale_end'],
      lp_sale_price: json['_lp_sale_price'],
      lp_sale_start: json['_lp_sale_start'],
      lp_students: json['_lp_students'],
      lp_target_audiences: json['_lp_target_audiences'] != null ? new List<String>.from(json['_lp_target_audiences']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_lp_allow_course_repurchase'] = this.lp_allow_course_repurchase;
    data['_lp_block_expire_duration'] = this.lp_block_expire_duration;
    data['_lp_block_finished'] = this.lp_block_finished;
    data['_lp_course_author'] = this.lp_course_author;
    data['_lp_course_repurchase_option'] = this.lp_course_repurchase_option;
    data['_lp_course_result'] = this.lp_course_result;
    data['_lp_duration'] = this.lp_duration;
    data['_lp_external_link_buy_course'] = this.lp_external_link_buy_course;
    data['_lp_featured'] = this.lp_featured;
    data['_lp_featured_review'] = this.lp_featured_review;
    data['_lp_has_finish'] = this.lp_has_finish;
    data['_lp_level'] = this.lp_level;
    data['_lp_max_students'] = this.lp_max_students;
    data['_lp_no_required_enroll'] = this.lp_no_required_enroll;
    data['_lp_passing_condition'] = this.lp_passing_condition;
    data['_lp_regular_price'] = this.lp_regular_price;
    data['_lp_retake_count'] = this.lp_retake_count;
    data['_lp_sale_end'] = this.lp_sale_end;
    data['_lp_sale_price'] = this.lp_sale_price;
    data['_lp_sale_start'] = this.lp_sale_start;
    data['_lp_students'] = this.lp_students;
    if (this.lp_faqs != null) {
      data['_lp_faqs'] = this.lp_faqs;
    }
    if (this.lp_key_features != null) {
      data['_lp_key_features'] = this.lp_key_features;
    }
    if (this.lp_requirements != null) {
      data['_lp_requirements'] = this.lp_requirements;
    }
    if (this.lp_target_audiences != null) {
      data['_lp_target_audiences'] = this.lp_target_audiences;
    }
    return data;
  }
}
