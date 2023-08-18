import 'package:socialv/models/woo_commerce/common_models.dart';

import '../common_models/links.dart';

class CartItemModel {
  Links? links;
  bool? backordersAllowed;
  String? catalogVisibility;
  String? description;
  Extensions? extensions;
  int? id;
  List<ImageModel>? images;
  List<dynamic>? itemData;
  String? key;
  String? lowStockRemaining;
  String? name;
  String? permalink;
  Prices? prices;
  int? quantity;
  QuantityLimits? quantityLimits;
  String? shortDescription;
  bool? showBackOrderBadge;
  String? sku;
  bool? soldIndividually;
  Totals? totals;
  //List<int>? variation;
  bool? isQuantityChanged;

  CartItemModel({
    this.links,
    this.backordersAllowed,
    this.catalogVisibility,
    this.description,
    this.extensions,
    this.id,
    this.images,
    this.itemData,
    this.key,
    this.lowStockRemaining,
    this.name,
    this.permalink,
    this.prices,
    this.quantity,
    this.quantityLimits,
    this.shortDescription,
    this.showBackOrderBadge,
    this.sku,
    this.soldIndividually,
    this.totals,
    //this.variation,
    this.isQuantityChanged,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
      backordersAllowed: json['backorders_allowed'],
      catalogVisibility: json['catalog_visibility'],
      description: json['description'],
      extensions: json['extensions'] != null ? Extensions.fromJson(json['extensions']) : null,
      id: json['id'],
      images: json['images'] != null ? (json['images'] as List).map((i) => ImageModel.fromJson(i)).toList() : null,
      itemData: json['item_data'] != null ? (json['item_data'] as List).map((i) => i.fromJson(i)).toList() : null,
      key: json['key'],
      lowStockRemaining: json['low_stock_remaining'],
      name: json['name'],
      permalink: json['permalink'],
      prices: json['prices'] != null ? Prices.fromJson(json['prices']) : null,
      quantity: json['quantity'],
      quantityLimits: json['quantity_limits'] != null ? QuantityLimits.fromJson(json['quantity_limits']) : null,
      shortDescription: json['short_description'],
      showBackOrderBadge: json['show_backorder_badge'],
      sku: json['sku'],
      soldIndividually: json['sold_individually'],
      totals: json['totals'] != null ? Totals.fromJson(json['totals']) : null,
      //variation: json['variation'] != null ? List<int>.from(json['variation']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['backorders_allowed'] = this.backordersAllowed;
    data['catalog_visibility'] = this.catalogVisibility;
    data['description'] = this.description;
    data['id'] = this.id;
    data['key'] = this.key;
    data['name'] = this.name;
    data['permalink'] = this.permalink;
    data['quantity'] = this.quantity;
    data['short_description'] = this.shortDescription;
    data['show_backorder_badge'] = this.showBackOrderBadge;
    data['sku'] = this.sku;
    data['sold_individually'] = this.soldIndividually;
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    if (this.extensions != null) {
      data['extensions'] = this.extensions!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.itemData != null) {
      data['item_data'] = this.itemData!.map((v) => v.toJson()).toList();
    }
    if (this.lowStockRemaining != null) {
      data['low_stock_remaining'] = this.lowStockRemaining;
    }
    if (this.prices != null) {
      data['prices'] = this.prices!.toJson();
    }
    if (this.quantityLimits != null) {
      data['quantity_limits'] = this.quantityLimits!.toJson();
    }
    if (this.totals != null) {
      data['totals'] = this.totals!.toJson();
    }
    /*if (this.variation != null) {
      data['variation'] = this.variation;
    }*/
    return data;
  }
}

class Prices {
  String? currencyCode;
  String? currencyDecimalSeparator;
  int? currencyMinorUnit;
  String? currencyPrefix;
  String? currencySuffix;
  String? currencySymbol;
  String? currencyThousandSeparator;
  String? price;
  String? priceRange;
  RawPrices? rawPrices;
  String? regularPrice;
  String? salePrice;

  Prices(
      {this.currencyCode,
      this.currencyDecimalSeparator,
      this.currencyMinorUnit,
      this.currencyPrefix,
      this.currencySuffix,
      this.currencySymbol,
      this.currencyThousandSeparator,
      this.price,
      this.priceRange,
      this.rawPrices,
      this.regularPrice,
      this.salePrice});

  factory Prices.fromJson(Map<String, dynamic> json) {
    return Prices(
      currencyCode: json['currency_code'],
      currencyDecimalSeparator: json['currency_decimal_separator'],
      currencyMinorUnit: json['currency_minor_unit'],
      currencyPrefix: json['currency_prefix'],
      currencySuffix: json['currency_suffix'],
      currencySymbol: json['currency_symbol'],
      currencyThousandSeparator: json['currency_thousand_separator'],
      price: json['price'],
      priceRange: json['price_range'],
      rawPrices: json['raw_prices'] != null ? RawPrices.fromJson(json['raw_prices']) : null,
      regularPrice: json['regular_price'],
      salePrice: json['sale_price'],
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
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    if (this.priceRange != null) {
      data['price_range'] = this.priceRange;
    }
    if (this.rawPrices != null) {
      data['raw_prices'] = this.rawPrices!.toJson();
    }
    return data;
  }
}

class RawPrices {
  int? precision;
  String? price;
  String? regularPrice;
  String? salePrice;

  RawPrices({this.precision, this.price, this.regularPrice, this.salePrice});

  factory RawPrices.fromJson(Map<String, dynamic> json) {
    return RawPrices(
      precision: json['precision'],
      price: json['price'],
      regularPrice: json['regular_price'],
      salePrice: json['sale_price'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['precision'] = this.precision;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    return data;
  }
}

class QuantityLimits {
  bool? editable;
  int? maximum;
  int? minimum;
  int? multipleOf;

  QuantityLimits({this.editable, this.maximum, this.minimum, this.multipleOf});

  factory QuantityLimits.fromJson(Map<String, dynamic> json) {
    return QuantityLimits(
      editable: json['editable'],
      maximum: json['maximum'],
      minimum: json['minimum'],
      multipleOf: json['multiple_of'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['editable'] = this.editable;
    data['maximum'] = this.maximum;
    data['minimum'] = this.minimum;
    data['multiple_of'] = this.multipleOf;
    return data;
  }
}

class Totals {
  String? currencyCode;
  String? currencyDecimalSeparator;
  int? currencyMinorUnit;
  String? currencyPrefix;
  String? currencySuffix;
  String? currencySymbol;
  String? currencyThousandSeparator;
  String? lineSubtotal;
  String? lineSubtotalTax;
  String? lineTotal;
  String? lineTotalTax;

  Totals(
      {this.currencyCode,
      this.currencyDecimalSeparator,
      this.currencyMinorUnit,
      this.currencyPrefix,
      this.currencySuffix,
      this.currencySymbol,
      this.currencyThousandSeparator,
      this.lineSubtotal,
      this.lineSubtotalTax,
      this.lineTotal,
      this.lineTotalTax});

  factory Totals.fromJson(Map<String, dynamic> json) {
    return Totals(
      currencyCode: json['currency_code'],
      currencyDecimalSeparator: json['currency_decimal_separator'],
      currencyMinorUnit: json['currency_minor_unit'],
      currencyPrefix: json['currency_prefix'],
      currencySuffix: json['currency_suffix'],
      currencySymbol: json['currency_symbol'],
      currencyThousandSeparator: json['currency_thousand_separator'],
      lineSubtotal: json['line_subtotal'],
      lineSubtotalTax: json['line_subtotal_tax'],
      lineTotal: json['line_total'],
      lineTotalTax: json['line_total_tax'],
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
    data['line_subtotal'] = this.lineSubtotal;
    data['line_subtotal_tax'] = this.lineSubtotalTax;
    data['line_total'] = this.lineTotal;
    data['line_total_tax'] = this.lineTotalTax;
    return data;
  }
}

class Extensions {
  Extensions();

  factory Extensions.fromJson(Map<String, dynamic> json) {
    return Extensions();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
