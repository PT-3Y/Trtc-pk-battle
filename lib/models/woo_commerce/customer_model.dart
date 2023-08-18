import 'package:socialv/models/woo_commerce/billing_address_model.dart';

import '../common_models/links.dart';

class CustomerModel {
  Links? links;
  String? avatarUrl;
  BillingAddressModel? billing;
  String? dateCreated;
  String? dateCreatedGmt;
  String? dateModified;
  String? dateModifiedGmt;
  String? email;
  String? firstName;
  int? id;
  bool? isPayingCustomer;
  String? lastName;
  String? role;
  BillingAddressModel? shipping;
  String? username;

  CustomerModel(
      {this.links,
      this.avatarUrl,
      this.billing,
      this.dateCreated,
      this.dateCreatedGmt,
      this.dateModified,
      this.dateModifiedGmt,
      this.email,
      this.firstName,
      this.id,
      this.isPayingCustomer,
      this.lastName,
      this.role,
      this.shipping,
      this.username});

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
      avatarUrl: json['avatar_url'],
      billing: json['billing'] != null ? BillingAddressModel.fromJson(json['billing']) : null,
      dateCreated: json['date_created'],
      dateCreatedGmt: json['date_created_gmt'],
      dateModified: json['date_modified'],
      dateModifiedGmt: json['date_modified_gmt'],
      email: json['email'],
      firstName: json['first_name'],
      id: json['id'],
      isPayingCustomer: json['is_paying_customer'],
      lastName: json['last_name'],
      role: json['role'],
      shipping: json['shipping'] != null ? BillingAddressModel.fromJson(json['shipping']) : null,
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar_url'] = this.avatarUrl;
    data['date_created'] = this.dateCreated;
    data['date_created_gmt'] = this.dateCreatedGmt;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['id'] = this.id;
    data['is_paying_customer'] = this.isPayingCustomer;
    data['last_name'] = this.lastName;
    data['role'] = this.role;
    data['username'] = this.username;
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    if (this.billing != null) {
      data['billing'] = this.billing!.toJson();
    }
    if (this.dateModified != null) {
      data['date_modified'] = this.dateModified;
    }
    if (this.dateModifiedGmt != null) {
      data['date_modified_gmt'] = this.dateModifiedGmt;
    }

    if (this.shipping != null) {
      data['shipping'] = this.shipping!.toJson();
    }
    return data;
  }
}
