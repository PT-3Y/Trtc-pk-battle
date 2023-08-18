import '../common_models/links.dart';

class CouponModel {
  Links? links;
  String? amount;
  String? code;
  String? dateCreated;
  String? dateCreatedGmt;
  String? dateExpires;
  String? dateExpiresGmt;
  String? dateModified;
  String? dateModifiedGmt;
  String? description;
  String? discountType;
  List<dynamic>? emailRestrictions;
  bool? excludeSaleItems;
  List<dynamic>? excludedProductCategories;
  List<dynamic>? excludedProductIds;
  bool? freeShipping;
  int? id;
  bool? individualUse;
  int? limitUsageToXItems;
  String? maximumAmount;
  List<dynamic>? metaData;
  String? minimumAmount;
  List<dynamic>? productCategories;
  List<int>? productIds;
  String? status;
  int? usageCount;
  int? usageLimit;
  int? usageLimitPerUser;
  List<dynamic>? usedBy;

  CouponModel(
      {this.links,
      this.amount,
      this.code,
      this.dateCreated,
      this.dateCreatedGmt,
      this.dateExpires,
      this.dateExpiresGmt,
      this.dateModified,
      this.dateModifiedGmt,
      this.description,
      this.discountType,
      this.emailRestrictions,
      this.excludeSaleItems,
      this.excludedProductCategories,
      this.excludedProductIds,
      this.freeShipping,
      this.id,
      this.individualUse,
      this.limitUsageToXItems,
      this.maximumAmount,
      this.metaData,
      this.minimumAmount,
      this.productCategories,
      this.productIds,
      this.status,
      this.usageCount,
      this.usageLimit,
      this.usageLimitPerUser,
      this.usedBy});

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
      amount: json['amount'],
      code: json['code'],
      dateCreated: json['date_created'],
      dateCreatedGmt: json['date_created_gmt'],
      dateExpires: json['date_expires'],
      dateExpiresGmt: json['date_expires_gmt'],
      dateModified: json['date_modified'],
      dateModifiedGmt: json['date_modified_gmt'],
      description: json['description'],
      discountType: json['discount_type'],
      emailRestrictions: json['email_restrictions'] != null ? (json['email_restrictions'] as List).map((i) => i.fromJson(i)).toList() : null,
      excludeSaleItems: json['exclude_sale_items'],
      excludedProductCategories: json['excluded_product_categories'] != null ? (json['excluded_product_categories'] as List).map((i) => i.fromJson(i)).toList() : null,
      excludedProductIds: json['excluded_product_ids'] != null ? (json['excluded_product_ids'] as List).map((i) => i.fromJson(i)).toList() : null,
      freeShipping: json['free_shipping'],
      id: json['id'],
      individualUse: json['individual_use'],
      limitUsageToXItems: json['limit_usage_to_x_items'],
      maximumAmount: json['maximum_amount'],
      metaData: json['meta_data'] != null ? (json['meta_data'] as List).map((i) => i.fromJson(i)).toList() : null,
      minimumAmount: json['minimum_amount'],
      productCategories: json['product_categories'] != null ? (json['product_categories'] as List).map((i) => i.fromJson(i)).toList() : null,
      productIds: json['product_ids'] != null ? List<int>.from(json['product_ids']) : null,
      status: json['status'],
      usageCount: json['usage_count'],
      usageLimit: json['usage_limit'],
      usageLimitPerUser: json['usage_limit_per_user'],
      usedBy: json['used_by'] != null ? (json['used_by'] as List).map((i) => i.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['code'] = this.code;
    data['date_created'] = this.dateCreated;
    data['date_created_gmt'] = this.dateCreatedGmt;
    data['date_expires'] = this.dateExpires;
    data['date_expires_gmt'] = this.dateExpiresGmt;
    data['date_modified'] = this.dateModified;
    data['date_modified_gmt'] = this.dateModifiedGmt;
    data['description'] = this.description;
    data['discount_type'] = this.discountType;
    data['exclude_sale_items'] = this.excludeSaleItems;
    data['free_shipping'] = this.freeShipping;
    data['id'] = this.id;
    data['individual_use'] = this.individualUse;
    data['maximum_amount'] = this.maximumAmount;
    data['minimum_amount'] = this.minimumAmount;
    data['status'] = this.status;
    data['usage_count'] = this.usageCount;
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    if (this.emailRestrictions != null) {
      data['email_restrictions'] = this.emailRestrictions!.map((v) => v.toJson()).toList();
    }
    if (this.excludedProductCategories != null) {
      data['excluded_product_categories'] = this.excludedProductCategories!.map((v) => v.toJson()).toList();
    }
    if (this.excludedProductIds != null) {
      data['excluded_product_ids'] = this.excludedProductIds!.map((v) => v.toJson()).toList();
    }
    if (this.limitUsageToXItems != null) {
      data['limit_usage_to_x_items'] = this.limitUsageToXItems;
    }
    if (this.metaData != null) {
      data['meta_data'] = this.metaData!.map((v) => v.toJson()).toList();
    }
    if (this.productCategories != null) {
      data['product_categories'] = this.productCategories!.map((v) => v.toJson()).toList();
    }
    if (this.productIds != null) {
      data['product_ids'] = this.productIds;
    }
    if (this.usageLimit != null) {
      data['usage_limit'] = this.usageLimit;
    }
    if (this.usageLimitPerUser != null) {
      data['usage_limit_per_user'] = this.usageLimitPerUser;
    }
    if (this.usedBy != null) {
      data['used_by'] = this.usedBy!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
