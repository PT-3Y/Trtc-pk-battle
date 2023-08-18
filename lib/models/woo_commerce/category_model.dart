import 'package:socialv/models/woo_commerce/common_models.dart';

import '../common_models/links.dart';

class CategoryModel {
  Links? links;
  int? count;
  String? description;
  String? display;
  int? id;
  ImageModel? image;
  int? menuOrder;
  String? name;
  int? parent;
  String? slug;
  bool isSelected;

  CategoryModel({
    this.links,
    this.count,
    this.description,
    this.display,
    this.id,
    this.image,
    this.menuOrder,
    this.name,
    this.parent,
    this.slug,
    this.isSelected = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
      count: json['count'],
      description: json['description'],
      display: json['display'],
      id: json['id'],
      image: json['image'] != null ? ImageModel.fromJson(json['image']) : null,
      menuOrder: json['menu_order'],
      name: json['name'],
      parent: json['parent'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['description'] = this.description;
    data['display'] = this.display;
    data['id'] = this.id;
    data['menu_order'] = this.menuOrder;
    data['name'] = this.name;
    data['parent'] = this.parent;
    data['slug'] = this.slug;
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}
