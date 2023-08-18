import 'package:socialv/models/lms/lms_common_models/result_items_model.dart';

class Result {
  int? completed_items;
  int? count_items;
  String? evaluate_type;
  Items? items;
  int? pass;
  int? result;

  Result({this.completed_items, this.count_items, this.evaluate_type, this.items, this.pass, this.result});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      completed_items: json['completed_items'],
      count_items: json['count_items'],
      evaluate_type: json['evaluate_type'],
      items: json['items'] != null ? Items.fromJson(json['items']) : null,
      pass: json['pass'],
      result: json['result'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['completed_items'] = this.completed_items;
    data['count_items'] = this.count_items;
    data['evaluate_type'] = this.evaluate_type;
    data['pass'] = this.pass;
    data['result'] = this.result;
    if (this.items != null) {
      data['items'] = this.items!.toJson();
    }
    return data;
  }
}
