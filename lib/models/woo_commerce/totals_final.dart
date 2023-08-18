class TotalsFinal {
  String? currencyCode;
  String? currencyDecimalSeparator;
  int? currencyMinorUnit;
  String? currencyPrefix;
  String? currencySuffix;
  String? currencySymbol;
  String? currencyThousandSeparator;
  List<dynamic>? taxLines;
  String? totalDiscount;
  String? totalDiscountTax;
  String? totalFees;
  String? totalFeesTax;
  String? totalItems;
  String? totalItemsTax;
  String? totalPrice;
  String? totalShipping;
  String? totalShippingTax;
  String? totalTax;

  TotalsFinal(
      {this.currencyCode,
      this.currencyDecimalSeparator,
      this.currencyMinorUnit,
      this.currencyPrefix,
      this.currencySuffix,
      this.currencySymbol,
      this.currencyThousandSeparator,
      this.taxLines,
      this.totalDiscount,
      this.totalDiscountTax,
      this.totalFees,
      this.totalFeesTax,
      this.totalItems,
      this.totalItemsTax,
      this.totalPrice,
      this.totalShipping,
      this.totalShippingTax,
      this.totalTax});

  factory TotalsFinal.fromJson(Map<String, dynamic> json) {
    return TotalsFinal(
      currencyCode: json['currency_code'],
      currencyDecimalSeparator: json['currency_decimal_separator'],
      currencyMinorUnit: json['currency_minor_unit'],
      currencyPrefix: json['currency_prefix'],
      currencySuffix: json['currency_suffix'],
      currencySymbol: json['currency_symbol'],
      currencyThousandSeparator: json['currency_thousand_separator'],
      taxLines: json['tax_lines'] != null ? (json['tax_lines'] as List).map((i) => i.fromJson(i)).toList() : null,
      totalDiscount: json['total_discount'],
      totalDiscountTax: json['total_discount_tax'],
      totalFees: json['total_fees'],
      totalFeesTax: json['total_fees_tax'],
      totalItems: json['total_items'],
      totalItemsTax: json['total_items_tax'],
      totalPrice: json['total_price'],
      totalShipping: json['total_shipping'],
      totalShippingTax: json['total_shipping_tax'],
      totalTax: json['total_tax'],
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
    data['total_fees'] = this.totalFees;
    data['total_fees_tax'] = this.totalFeesTax;
    data['total_items'] = this.totalItems;
    data['total_items_tax'] = this.totalItemsTax;
    data['total_price'] = this.totalPrice;
    data['total_shipping'] = this.totalShipping;
    data['total_shipping_tax'] = this.totalShippingTax;
    data['total_tax'] = this.totalTax;
    if (this.taxLines != null) {
      data['tax_lines'] = this.taxLines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
