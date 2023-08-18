import 'package:socialv/models/woo_commerce/billing_address_model.dart';
import 'package:socialv/models/woo_commerce/totals_final.dart';
import 'package:socialv/models/woo_commerce/cart_item_model.dart';

class CartModel {
  BillingAddressModel? billingAddress;
  List<CartCouponModel>? coupons;
  List<dynamic>? crossSells;
  List<dynamic>? errors;
  Extensions? extensions;
  List<dynamic>? fees;
  bool? hasCalculatedShipping;
  List<CartItemModel>? items;
  int? itemsCount;
  int? itemsWeight;
  bool? needsPayment;
  bool? needsShipping;
  List<String>? paymentRequirements;
  BillingAddressModel? shippingAddress;
  TotalsFinal? totals;

  CartModel(
      {this.billingAddress,
      this.coupons,
      this.crossSells,
      this.errors,
      this.extensions,
      this.fees,
      this.hasCalculatedShipping,
      this.items,
      this.itemsCount,
      this.itemsWeight,
      this.needsPayment,
      this.needsShipping,
      this.paymentRequirements,
      this.shippingAddress,
      this.totals});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      billingAddress: json['billing_address'] != null ? BillingAddressModel.fromJson(json['billing_address']) : null,
      coupons: json['coupons'] != null ? (json['coupons'] as List).map((i) => CartCouponModel.fromJson(i)).toList() : null,
      crossSells: json['cross_sells'] != null ? (json['cross_sells'] as List).map((i) => i.fromJson(i)).toList() : null,
      errors: json['errors'] != null ? (json['errors'] as List).map((i) => i.fromJson(i)).toList() : null,
      extensions: json['extensions'] != null ? Extensions.fromJson(json['extensions']) : null,
      fees: json['fees'] != null ? (json['fees'] as List).map((i) => i.fromJson(i)).toList() : null,
      hasCalculatedShipping: json['has_calculated_shipping'],
      items: json['items'] != null ? (json['items'] as List).map((i) => CartItemModel.fromJson(i)).toList() : null,
      itemsCount: json['items_count'],
      itemsWeight: json['items_weight'],
      needsPayment: json['needs_payment'],
      needsShipping: json['needs_shipping'],
      paymentRequirements: json['payment_requirements'] != null ? new List<String>.from(json['payment_requirements']) : null,
      shippingAddress: json['shipping_address'] != null ? BillingAddressModel.fromJson(json['shipping_address']) : null,
      totals: json['totals'] != null ? TotalsFinal.fromJson(json['totals']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['has_calculated_shipping'] = this.hasCalculatedShipping;
    data['items_count'] = this.itemsCount;
    data['items_weight'] = this.itemsWeight;
    data['needs_payment'] = this.needsPayment;
    data['needs_shipping'] = this.needsShipping;
    if (this.billingAddress != null) {
      data['billing_address'] = this.billingAddress!.toJson();
    }
    if (this.coupons != null) {
      data['coupons'] = this.coupons!.map((v) => v.toJson()).toList();
    }
    if (this.crossSells != null) {
      data['cross_sells'] = this.crossSells!.map((v) => v.toJson()).toList();
    }
    if (this.errors != null) {
      data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    }
    if (this.extensions != null) {
      data['extensions'] = this.extensions!.toJson();
    }
    if (this.fees != null) {
      data['fees'] = this.fees!.map((v) => v.toJson()).toList();
    }
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.paymentRequirements != null) {
      data['payment_requirements'] = this.paymentRequirements;
    }
    if (this.shippingAddress != null) {
      data['shipping_address'] = this.shippingAddress!.toJson();
    }

    if (this.totals != null) {
      data['totals'] = this.totals!.toJson();
    }
    return data;
  }
}

class CartCouponModel {
  String? code;
  String? discountType;
  CouponTotalsModel? totals;

  CartCouponModel({this.code, this.discountType, this.totals});

  factory CartCouponModel.fromJson(Map<String, dynamic> json) {
    return CartCouponModel(
      code: json['code'],
      discountType: json['discount_type'],
      totals: json['totals'] != null ? CouponTotalsModel.fromJson(json['totals']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['discount_type'] = this.discountType;
    if (this.totals != null) {
      data['totals'] = this.totals!.toJson();
    }
    return data;
  }
}

class CouponTotalsModel {
  String? currencyCode;
  String? currencyDecimalSeparator;
  int? currencyMinorUnit;
  String? currencyPrefix;
  String? currencySuffix;
  String? currencySymbol;
  String? currencyThousandSeparator;
  String? totalDiscount;
  String? totalDiscountTax;

  CouponTotalsModel({
    this.currencyCode,
    this.currencyDecimalSeparator,
    this.currencyMinorUnit,
    this.currencyPrefix,
    this.currencySuffix,
    this.currencySymbol,
    this.currencyThousandSeparator,
    this.totalDiscount,
    this.totalDiscountTax,
  });

  factory CouponTotalsModel.fromJson(Map<String, dynamic> json) {
    return CouponTotalsModel(
      currencyCode: json['currency_code'],
      currencyDecimalSeparator: json['currency_decimal_separator'],
      currencyMinorUnit: json['currency_minor_unit'],
      currencyPrefix: json['currency_prefix'],
      currencySuffix: json['currency_suffix'],
      currencySymbol: json['currency_symbol'],
      currencyThousandSeparator: json['currency_thousand_separator'],
      totalDiscount: json['total_discount'],
      totalDiscountTax: json['total_discount_tax'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency_code'] = this.currencyCode;
    data['currency_decimal_separator'] = this.currencyDecimalSeparator;
    data['currency_minor_unit'] = this.currencyMinorUnit;
    data['currency_prefix'] = this.currencyPrefix;
    data['currency_suffix'] = this.currencySuffix;
    data['currency_symbol'] = this.currencySymbol;
    data['currency_thousand_separator'] = this.currencyThousandSeparator;
    data['total_discount'] = this.totalDiscount;
    data['total_discount_tax'] = this.totalDiscountTax;
    return data;
  }
}
