import 'package:socialv/models/woo_commerce/common_models.dart';

class ShippingLinesModel {
  int? id;
  String? instanceId;
  List<MetaData>? metaData;
  String? methodId;
  String? methodTitle;
  List<dynamic>? taxes;
  String? total;
  String? totalTax;

  ShippingLinesModel({this.id, this.instanceId, this.metaData, this.methodId, this.methodTitle, this.taxes, this.total, this.totalTax});

  factory ShippingLinesModel.fromJson(Map<String, dynamic> json) {
    return ShippingLinesModel(
      id: json['id'],
      instanceId: json['instance_id'],
      metaData: json['meta_data'] != null ? (json['meta_data'] as List).map((i) => MetaData.fromJson(i)).toList() : null,
      methodId: json['method_id'],
      methodTitle: json['method_title'],
      taxes: json['taxes'] != null ? (json['taxes'] as List).map((i) => i.fromJson(i)).toList() : null,
      total: json['total'],
      totalTax: json['total_tax'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['instance_id'] = this.instanceId;
    data['method_id'] = this.methodId;
    data['method_title'] = this.methodTitle;
    data['total'] = this.total;
    data['total_tax'] = this.totalTax;
    if (this.metaData != null) {
      data['meta_data'] = this.metaData!.map((v) => v.toJson()).toList();
    }
    if (this.taxes != null) {
      data['taxes'] = this.taxes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
