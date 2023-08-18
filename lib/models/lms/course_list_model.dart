import 'package:socialv/models/lms/lms_common_models/course_data.dart';
import 'package:socialv/models/lms/lms_common_models/course_meta_data.dart';
import 'package:socialv/models/lms/lms_common_models/instrustor_model.dart';
import 'package:socialv/models/lms/lms_common_models/lms_category.dart';
import 'package:socialv/models/lms/lms_common_models/section.dart';

//type 'double' is not a subtype of type 'int?'

class CourseListModel {
  bool? can_finish;
  bool? can_retake;
  List<Category>? categories;
  String? content;
  int? count_students;
  CourseData? course_data;
  String? date_created;
  String? date_created_gmt;
  String? date_modified;
  String? date_modified_gmt;
  String? duration;
  String? excerpt;
  int? id;
  String? image;
  Instructor? instructor;
  CourseMetaData? meta_data;
  String? name;
  bool? on_sale;
  int? origin_price;
  String? origin_price_rendered;
  String? permalink;
  int? price;
  String? price_rendered;
  int? ratake_count;
  int? rataken;
  var rating;
  int? sale_price;
  String? sale_price_rendered;
  List<Section>? sections;
  String? slug;
  String? status;
  bool? in_cart;
  String? order_status;

  //List<dynamic>? tags;

  CourseListModel({
    this.can_finish,
    this.can_retake,
    this.categories,
    this.content,
    this.count_students,
    this.course_data,
    this.date_created,
    this.date_created_gmt,
    this.date_modified,
    this.date_modified_gmt,
    this.duration,
    this.excerpt,
    this.id,
    this.image,
    this.instructor,
    this.meta_data,
    this.name,
    this.on_sale,
    this.origin_price,
    this.origin_price_rendered,
    this.permalink,
    this.price,
    this.price_rendered,
    this.ratake_count,
    this.rataken,
    this.rating,
    this.sale_price,
    this.sale_price_rendered,
    this.sections,
    this.slug,
    this.status,
    this.in_cart,
    this.order_status,
    //this.tags,
  });

  factory CourseListModel.fromJson(Map<String, dynamic> json) {
    return CourseListModel(
      can_finish: json['can_finish'],
      can_retake: json['can_retake'],
      categories: json['categories'] != null ? (json['categories'] as List).map((i) => Category.fromJson(i)).toList() : null,
      content: json['content'],
      count_students: json['count_students'],
      course_data: json['course_data'] != null ? CourseData.fromJson(json['course_data']) : null,
      date_created: json['date_created'],
      date_created_gmt: json['date_created_gmt'],
      date_modified: json['date_modified'],
      date_modified_gmt: json['date_modified_gmt'],
      duration: json['duration'],
      excerpt: json['excerpt'],
      id: json['id'],
      image: json['image'],
      instructor: json['instructor'] != null ? Instructor.fromJson(json['instructor']) : null,
      meta_data: json['meta_data'] != null ? CourseMetaData.fromJson(json['meta_data']) : null,
      name: json['name'],
      on_sale: json['on_sale'],
      origin_price: json['origin_price'],
      origin_price_rendered: json['origin_price_rendered'],
      permalink: json['permalink'],
      price: json['price'],
      price_rendered: json['price_rendered'],
      ratake_count: json['ratake_count'],
      rataken: json['rataken'],
      rating: json['rating'],
      sale_price: json['sale_price'],
      sale_price_rendered: json['sale_price_rendered'],
      sections: json['sections'] != null ? (json['sections'] as List).map((i) => Section.fromJson(i)).toList() : null,
      slug: json['slug'],
      status: json['status'],
      in_cart: json['in_cart'],
      order_status: json['order_status'],
      //tags: json['tags'] != null ? (json['tags'] as List).map((i) => i.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['can_finish'] = this.can_finish;
    data['can_retake'] = this.can_retake;
    data['content'] = this.content;
    data['count_students'] = this.count_students;
    data['date_created'] = this.date_created;
    data['date_created_gmt'] = this.date_created_gmt;
    data['date_modified'] = this.date_modified;
    data['date_modified_gmt'] = this.date_modified_gmt;
    data['duration'] = this.duration;
    data['excerpt'] = this.excerpt;
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['on_sale'] = this.on_sale;
    data['origin_price'] = this.origin_price;
    data['origin_price_rendered'] = this.origin_price_rendered;
    data['permalink'] = this.permalink;
    data['price'] = this.price;
    data['price_rendered'] = this.price_rendered;
    data['ratake_count'] = this.ratake_count;
    data['rataken'] = this.rataken;
    data['rating'] = this.rating;
    data['sale_price'] = this.sale_price;
    data['sale_price_rendered'] = this.sale_price_rendered;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['in_cart'] = this.in_cart;
    data['order_status'] = this.order_status;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.course_data != null) {
      data['course_data'] = this.course_data!.toJson();
    }
    if (this.instructor != null) {
      data['instructor'] = this.instructor!.toJson();
    }
    if (this.meta_data != null) {
      data['meta_data'] = this.meta_data!.toJson();
    }
    if (this.sections != null) {
      data['sections'] = this.sections!.map((v) => v.toJson()).toList();
    }
    /* if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}
