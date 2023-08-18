import 'package:socialv/models/woo_commerce/billing_address_model.dart';
import 'package:socialv/models/woo_commerce/shipping_lines.dart';

import '../common_models/links.dart';

class OrderModel {
  Links? links;
  BillingAddressModel? billing;
  String? cartHash;
  String? cartTax;
  List<dynamic>? couponLines;
  String? createdVia;
  String? currency;
  String? currencySymbol;
  int? customerId;
  String? customerIpAddress;
  String? customerNote;
  String? customerUserAgent;
  String? dateCompleted;
  String? dateCompletedGmt;
  String? dateCreated;
  String? dateCreatedGmt;
  String? dateModified;
  String? dateModifiedGmt;
  String? datePaid;
  String? datePaidGmt;
  String? discountTax;
  String? discountTotal;
  List<dynamic>? feeLines;
  int? id;
  bool? isEditable;
  List<LineItem>? lineItems;
  bool? needsPayment;
  bool? needsProcessing;
  String? number;
  String? orderKey;
  int? parentId;
  String? paymentMethod;
  String? paymentMethodTitle;
  String? paymentUrl;
  bool? pricesIncludeTax;
  List<dynamic>? refunds;
  BillingAddressModel? shipping;
  String? shippingTax;
  String? shippingTotal;
  String? status;
  List<dynamic>? taxLines;
  String? total;
  String? totalTax;
  String? transactionId;
  String? version;
  List<ShippingLinesModel>? shippingLines;

  OrderModel({
    this.links,
    this.billing,
    this.cartHash,
    this.cartTax,
    this.couponLines,
    this.createdVia,
    this.currency,
    this.currencySymbol,
    this.customerId,
    this.customerIpAddress,
    this.customerNote,
    this.customerUserAgent,
    this.dateCompleted,
    this.dateCompletedGmt,
    this.dateCreated,
    this.dateCreatedGmt,
    this.dateModified,
    this.dateModifiedGmt,
    this.datePaid,
    this.datePaidGmt,
    this.discountTax,
    this.discountTotal,
    this.feeLines,
    this.id,
    this.isEditable,
    this.lineItems,
    this.needsPayment,
    this.needsProcessing,
    this.number,
    this.orderKey,
    this.parentId,
    this.paymentMethod,
    this.paymentMethodTitle,
    this.paymentUrl,
    this.pricesIncludeTax,
    this.refunds,
    this.shipping,
    this.shippingTax,
    this.shippingTotal,
    this.status,
    this.taxLines,
    this.total,
    this.totalTax,
    this.transactionId,
    this.version,
    this.shippingLines,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
      billing: json['billing'] != null ? BillingAddressModel.fromJson(json['billing']) : null,
      cartHash: json['cart_hash'],
      cartTax: json['cart_tax'],
      couponLines: json['coupon_lines'] != null ? (json['coupon_lines'] as List).map((i) => i.fromJson(i)).toList() : null,
      createdVia: json['created_via'],
      currency: json['currency'],
      currencySymbol: json['currency_symbol'],
      customerId: json['customer_id'],
      customerIpAddress: json['customer_ip_address'],
      customerNote: json['customer_note'],
      customerUserAgent: json['customer_user_agent'],
      dateCompleted: json['date_completed'],
      dateCompletedGmt: json['date_completed_gmt'],
      dateCreated: json['date_created'],
      dateCreatedGmt: json['date_created_gmt'],
      dateModified: json['date_modified'],
      dateModifiedGmt: json['date_modified_gmt'],
      datePaid: json['date_paid'],
      datePaidGmt: json['date_paid_gmt'],
      discountTax: json['discount_tax'],
      discountTotal: json['discount_total'],
      feeLines: json['fee_lines'] != null ? (json['fee_lines'] as List).map((i) => i.fromJson(i)).toList() : null,
      id: json['id'],
      isEditable: json['is_editable'],
      lineItems: json['line_items'] != null ? (json['line_items'] as List).map((i) => LineItem.fromJson(i)).toList() : null,
      needsPayment: json['needs_payment'],
      needsProcessing: json['needs_processing'],
      number: json['number'],
      orderKey: json['order_key'],
      parentId: json['parent_id'],
      paymentMethod: json['payment_method'],
      paymentMethodTitle: json['payment_method_title'],
      paymentUrl: json['payment_url'],
      pricesIncludeTax: json['prices_include_tax'],
      refunds: json['refunds'] != null ? (json['refunds'] as List).map((i) => i.fromJson(i)).toList() : null,
      shipping: json['shipping'] != null ? BillingAddressModel.fromJson(json['shipping']) : null,
      shippingTax: json['shipping_tax'],
      shippingTotal: json['shipping_total'],
      status: json['status'],
      taxLines: json['tax_lines'] != null ? (json['tax_lines'] as List).map((i) => i.fromJson(i)).toList() : null,
      total: json['total'],
      totalTax: json['total_tax'],
      transactionId: json['transaction_id'],
      version: json['version'],
      shippingLines: json['shipping_lines'] != null ? (json['shipping_lines'] as List).map((i) => ShippingLinesModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_hash'] = this.cartHash;
    data['cart_tax'] = this.cartTax;
    data['created_via'] = this.createdVia;
    data['currency'] = this.currency;
    data['currency_symbol'] = this.currencySymbol;
    data['customer_id'] = this.customerId;
    data['customer_ip_address'] = this.customerIpAddress;
    data['customer_note'] = this.customerNote;
    data['customer_user_agent'] = this.customerUserAgent;
    data['date_created'] = this.dateCreated;
    data['date_created_gmt'] = this.dateCreatedGmt;
    data['date_modified'] = this.dateModified;
    data['date_modified_gmt'] = this.dateModifiedGmt;
    data['discount_tax'] = this.discountTax;
    data['discount_total'] = this.discountTotal;
    data['id'] = this.id;
    data['is_editable'] = this.isEditable;
    data['needs_payment'] = this.needsPayment;
    data['needs_processing'] = this.needsProcessing;
    data['number'] = this.number;
    data['order_key'] = this.orderKey;
    data['parent_id'] = this.parentId;
    data['payment_method'] = this.paymentMethod;
    data['payment_method_title'] = this.paymentMethodTitle;
    data['payment_url'] = this.paymentUrl;
    data['prices_include_tax'] = this.pricesIncludeTax;
    data['shipping_tax'] = this.shippingTax;
    data['shipping_total'] = this.shippingTotal;
    data['status'] = this.status;
    data['total'] = this.total;
    data['total_tax'] = this.totalTax;
    data['transaction_id'] = this.transactionId;
    data['version'] = this.version;
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    if (this.billing != null) {
      data['billing'] = this.billing!.toJson();
    }
    if (this.couponLines != null) {
      data['coupon_lines'] = this.couponLines!.map((v) => v.toJson()).toList();
    }
    if (this.dateCompleted != null) {
      data['date_completed'] = this.dateCompleted;
    }
    if (this.dateCompletedGmt != null) {
      data['date_completed_gmt'] = this.dateCompletedGmt;
    }
    if (this.datePaid != null) {
      data['date_paid'] = this.datePaid;
    }
    if (this.datePaidGmt != null) {
      data['date_paid_gmt'] = this.datePaidGmt;
    }
    if (this.feeLines != null) {
      data['fee_lines'] = this.feeLines!.map((v) => v.toJson()).toList();
    }
    if (this.lineItems != null) {
      data['line_items'] = this.lineItems!.map((v) => v.toJson()).toList();
    }
    if (this.shippingLines != null) {
      data['shipping_lines'] = this.shippingLines!.map((v) => v.toJson()).toList();
    }
    if (this.refunds != null) {
      data['refunds'] = this.refunds!.map((v) => v.toJson()).toList();
    }
    if (this.shipping != null) {
      data['shipping'] = this.shipping!.toJson();
    }

    if (this.taxLines != null) {
      data['tax_lines'] = this.taxLines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LineItem {
  int? id;
  ImageModel? image;
  String? name;
  String? parentName;
  int? price;
  int? productId;
  int? quantity;
  String? sku;
  String? subtotal;
  String? subtotalTax;
  String? taxClass;
  List<dynamic>? taxes;
  String? total;
  String? totalTax;
  int? variationId;

  LineItem({this.id, this.image, this.name, this.parentName, this.price, this.productId, this.quantity, this.sku, this.subtotal, this.subtotalTax, this.taxClass, this.taxes, this.total, this.totalTax, this.variationId});

  factory LineItem.fromJson(Map<String, dynamic> json) {
    return LineItem(
      id: json['id'],
      image: json['image'] != null ? ImageModel.fromJson(json['image']) : null,
      name: json['name'],
      parentName: json['parent_name'],
      price: json['price'],
      productId: json['product_id'],
      quantity: json['quantity'],
      sku: json['sku'],
      subtotal: json['subtotal'],
      subtotalTax: json['subtotal_tax'],
      taxClass: json['tax_class'],
      taxes: json['taxes'] != null ? (json['taxes'] as List).map((i) => i.fromJson(i)).toList() : null,
      total: json['total'],
      totalTax: json['total_tax'],
      variationId: json['variation_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['sku'] = this.sku;
    data['subtotal'] = this.subtotal;
    data['subtotal_tax'] = this.subtotalTax;
    data['tax_class'] = this.taxClass;
    data['total'] = this.total;
    data['total_tax'] = this.totalTax;
    data['variation_id'] = this.variationId;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }

    if (this.parentName != null) {
      data['parent_name'] = this.parentName;
    }
    if (this.taxes != null) {
      data['taxes'] = this.taxes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageModel {
  String? id;
  String? src;

  ImageModel({this.id, this.src});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'].toString(),
      src: json['src'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['src'] = this.src;
    return data;
  }
}
