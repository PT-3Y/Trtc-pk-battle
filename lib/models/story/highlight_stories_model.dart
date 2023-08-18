import 'package:socialv/models/story/story_response_model.dart';
import 'package:flutter/material.dart';

class HighlightStoriesModel {
  String? categoryImage;
  int? categoryId;
  String? categoryName;
  List<StoryItem>? items;

  AnimationController? animationController;

  HighlightStoriesModel({this.categoryImage, this.categoryId, this.categoryName, this.items});

  factory HighlightStoriesModel.fromJson(Map<String, dynamic> json) {
    return HighlightStoriesModel(
      categoryImage: json['category_image'],
      categoryId: json['catgeroy_id'],
      categoryName: json['catgeroy_name'],
      items: json['items'] != null ? (json['items'] as List).map((i) => StoryItem.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catgeroy_id'] = this.categoryId;
    data['catgeroy_name'] = this.categoryName;
    data['category_image'] = this.categoryImage;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
