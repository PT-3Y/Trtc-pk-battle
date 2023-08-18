import 'package:socialv/models/woo_commerce/common_models.dart';

import '../common_models/links.dart';

class ProductModel {
  Links? links;
  List<Attribute>? attributes;
  String? averageRating;
  bool? backOrdered;
  String? backorders;
  bool? backordersAllowed;
  String? buttonText;
  String? catalogVisibility;
  List<Category>? categories;
  List<dynamic>? crossSellIds;
  String? dateCreated;
  String? dateCreatedGmt;
  String? dateModified;
  String? dateModifiedGmt;
  String? dateOnSaleFrom;
  String? dateOnSaleFromGmt;
  String? dateOnSaleTo;
  String? dateOnSaleToGmt;
  List<dynamic>? defaultAttributes;
  String? description;
  Dimensions? dimensions;
  int? downloadExpiry;
  int? downloadLimit;
  bool? downloadable;
  List<Downloads>? downloads;
  String? externalUrl;
  bool? featured;
  List<int>? groupedProducts;
  bool? hasOptions;
  int? id;
  List<ImageModel>? images;
  String? lowStockAmount;
  bool? manageStock;
  int? menuOrder;
  List<MetaData>? metaData;
  String? name;
  bool? onSale;
  int? parentId;
  String? permalink;
  String? price;
  String? priceHtml;
  bool? purchasable;
  String? purchaseNote;
  int? ratingCount;
  String? regularPrice;
  List<int>? relatedIds;
  bool? reviewsAllowed;
  String? salePrice;
  String? shippingClass;
  int? shippingClassId;
  bool? shippingRequired;
  bool? shippingTaxable;
  String? shortDescription;
  String? sku;
  String? slug;
  bool? soldIndividually;
  String? status;

  //Object? stock_quantity;
  String? stockStatus;
  List<dynamic>? tags;
  String? taxClass;
  String? taxStatus;
  int? totalSales;
  String? type;
  List<dynamic>? upsellIds;
  List<int>? variations;
  bool? virtual;
  String? weight;

  ProductModel(
      {this.links,
      this.attributes,
      this.averageRating,
      this.backOrdered,
      this.backorders,
      this.backordersAllowed,
      this.buttonText,
      this.catalogVisibility,
      this.categories,
      this.crossSellIds,
      this.dateCreated,
      this.dateCreatedGmt,
      this.dateModified,
      this.dateModifiedGmt,
      this.dateOnSaleFrom,
      this.dateOnSaleFromGmt,
      this.dateOnSaleTo,
      this.dateOnSaleToGmt,
      this.defaultAttributes,
      this.description,
      this.dimensions,
      this.downloadExpiry,
      this.downloadLimit,
      this.downloadable,
      this.downloads,
      this.externalUrl,
      this.featured,
      this.groupedProducts,
      this.hasOptions,
      this.id,
      this.images,
      this.lowStockAmount,
      this.manageStock,
      this.menuOrder,
      this.metaData,
      this.name,
      this.onSale,
      this.parentId,
      this.permalink,
      this.price,
      this.priceHtml,
      this.purchasable,
      this.purchaseNote,
      this.ratingCount,
      this.regularPrice,
      this.relatedIds,
      this.reviewsAllowed,
      this.salePrice,
      this.shippingClass,
      this.shippingClassId,
      this.shippingRequired,
      this.shippingTaxable,
      this.shortDescription,
      this.sku,
      this.slug,
      this.soldIndividually,
      this.status,
      // this.stock_quantity,
      this.stockStatus,
      this.tags,
      this.taxClass,
      this.taxStatus,
      this.totalSales,
      this.type,
      this.upsellIds,
      this.variations,
      this.virtual,
      this.weight});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
      attributes: json['attributes'] != null ? (json['attributes'] as List).map((i) => Attribute.fromJson(i)).toList() : null,
      averageRating: json['average_rating'],
      backOrdered: json['backordered'],
      backorders: json['backorders'],
      backordersAllowed: json['backorders_allowed'],
      buttonText: json['button_text'],
      catalogVisibility: json['catalog_visibility'],
      categories: json['categories'] != null ? (json['categories'] as List).map((i) => Category.fromJson(i)).toList() : null,
      crossSellIds: json['cross_sell_ids'] != null ? (json['cross_sell_ids'] as List).map((i) => i.fromJson(i)).toList() : null,
      dateCreated: json['date_created'],
      dateCreatedGmt: json['date_created_gmt'],
      dateModified: json['date_modified'],
      dateModifiedGmt: json['date_modified_gmt'],
      dateOnSaleFrom: json['date_on_sale_from'] != null ? json['date_on_sale_from'] : null,
      dateOnSaleFromGmt: json['date_on_sale_from_gmt'] != null ? json['date_on_sale_from_gmt'] : null,
      dateOnSaleTo: json['date_on_sale_to'] != null ? json['date_on_sale_to'] : null,
      dateOnSaleToGmt: json['date_on_sale_to_gmt'] != null ? json['date_on_sale_to_gmt'] : null,
      defaultAttributes: json['default_attributes'] != null ? (json['default_attributes'] as List).map((i) => i.fromJson(i)).toList() : null,
      description: json['description'],
      dimensions: json['dimensions'] != null ? Dimensions.fromJson(json['dimensions']) : null,
      downloadExpiry: json['download_expiry'],
      downloadLimit: json['download_limit'],
      downloadable: json['downloadable'],
      downloads: json['downloads'] != null ? (json['downloads'] as List).map((i) => Downloads.fromJson(i)).toList() : null,
      externalUrl: json['external_url'],
      featured: json['featured'],
      groupedProducts: json['grouped_products'] != null ? new List<int>.from(json['grouped_products']) : null,
      hasOptions: json['has_options'],
      id: json['id'],
      images: json['images'] != null ? (json['images'] as List).map((i) => ImageModel.fromJson(i)).toList() : null,
      lowStockAmount: json['low_stock_amount'] != null ? json['low_stock_amount'] : null,
      manageStock: json['manage_stock'],
      menuOrder: json['menu_order'],
      metaData: json['meta_data'] != null ? (json['meta_data'] as List).map((i) => MetaData.fromJson(i)).toList() : null,
      name: json['name'],
      onSale: json['on_sale'],
      parentId: json['parent_id'],
      permalink: json['permalink'],
      price: json['price'].toString(),
      priceHtml: json['price_html'],
      purchasable: json['purchasable'],
      purchaseNote: json['purchase_note'],
      ratingCount: json['rating_count'],
      regularPrice: json['regular_price'],
      relatedIds: json['related_ids'] != null ? new List<int>.from(json['related_ids']) : null,
      reviewsAllowed: json['reviews_allowed'],
      salePrice: json['sale_price'],
      shippingClass: json['shipping_class'],
      shippingClassId: json['shipping_class_id'],
      shippingRequired: json['shipping_required'],
      shippingTaxable: json['shipping_taxable'],
      shortDescription: json['short_description'],
      sku: json['sku'],
      slug: json['slug'],
      soldIndividually: json['sold_individually'],
      status: json['status'],
      //stock_quantity: json['stock_quantity'] != null ? json['stock_quantity'] : null,
      stockStatus: json['stock_status'],
      tags: json['tags'] != null ? (json['tags'] as List).map((i) => i.fromJson(i)).toList() : null,
      taxClass: json['tax_class'],
      taxStatus: json['tax_status'],
      totalSales: json['total_sales'],
      type: json['type'],
      upsellIds: json['upsell_ids'] != null ? (json['upsell_ids'] as List).map((i) => i.fromJson(i)).toList() : null,
      variations: json['variations'] != null ? List<int>.from(json['variations']) : null,
      virtual: json['virtual'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average_rating'] = this.averageRating;
    data['backordered'] = this.backOrdered;
    data['backorders'] = this.backorders;
    data['backorders_allowed'] = this.backordersAllowed;
    data['button_text'] = this.buttonText;
    data['catalog_visibility'] = this.catalogVisibility;
    data['date_created'] = this.dateCreated;
    data['date_created_gmt'] = this.dateCreatedGmt;
    data['date_modified'] = this.dateModified;
    data['date_modified_gmt'] = this.dateModifiedGmt;
    data['description'] = this.description;
    data['download_expiry'] = this.downloadExpiry;
    data['download_limit'] = this.downloadLimit;
    data['downloadable'] = this.downloadable;
    data['external_url'] = this.externalUrl;
    data['featured'] = this.featured;
    data['has_options'] = this.hasOptions;
    data['id'] = this.id;
    data['manage_stock'] = this.manageStock;
    data['menu_order'] = this.menuOrder;
    data['name'] = this.name;
    data['on_sale'] = this.onSale;
    data['parent_id'] = this.parentId;
    data['permalink'] = this.permalink;
    data['price'] = this.price;
    data['price_html'] = this.priceHtml;
    data['purchasable'] = this.purchasable;
    data['purchase_note'] = this.purchaseNote;
    data['rating_count'] = this.ratingCount;
    data['regular_price'] = this.regularPrice;
    data['reviews_allowed'] = this.reviewsAllowed;
    data['sale_price'] = this.salePrice;
    data['shipping_class'] = this.shippingClass;
    data['shipping_class_id'] = this.shippingClassId;
    data['shipping_required'] = this.shippingRequired;
    data['shipping_taxable'] = this.shippingTaxable;
    data['short_description'] = this.shortDescription;
    data['sku'] = this.sku;
    data['slug'] = this.slug;
    data['sold_individually'] = this.soldIndividually;
    data['status'] = this.status;
    data['stock_status'] = this.stockStatus;
    data['tax_class'] = this.taxClass;
    data['tax_status'] = this.taxStatus;
    data['total_sales'] = this.totalSales;
    data['type'] = this.type;
    data['virtual'] = this.virtual;
    data['weight'] = this.weight;
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.crossSellIds != null) {
      data['cross_sell_ids'] = this.crossSellIds!.map((v) => v.toJson()).toList();
    }
    if (this.dateOnSaleFrom != null) {
      data['date_on_sale_from'] = this.dateOnSaleFrom;
    }
    if (this.dateOnSaleFromGmt != null) {
      data['date_on_sale_from_gmt'] = this.dateOnSaleFromGmt;
    }
    if (this.dateOnSaleTo != null) {
      data['date_on_sale_to'] = this.dateOnSaleTo;
    }
    if (this.dateOnSaleToGmt != null) {
      data['date_on_sale_to_gmt'] = this.dateOnSaleToGmt;
    }
    if (this.defaultAttributes != null) {
      data['default_attributes'] = this.defaultAttributes!.map((v) => v.toJson()).toList();
    }
    if (this.dimensions != null) {
      data['dimensions'] = this.dimensions!.toJson();
    }
    if (this.downloads != null) {
      data['downloads'] = this.downloads!.map((v) => v.toJson()).toList();
    }
    if (this.groupedProducts != null) {
      data['grouped_products'] = this.groupedProducts;
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.lowStockAmount != null) {
      data['low_stock_amount'] = this.lowStockAmount;
    }
    if (this.metaData != null) {
      data['meta_data'] = this.metaData!.map((v) => v.toJson()).toList();
    }
    if (this.relatedIds != null) {
      data['related_ids'] = this.relatedIds;
    }
    /* if (this.stock_quantity != null) {
        data['stock_quantity'] = this.stock_quantity;
      }*/
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    if (this.upsellIds != null) {
      data['upsell_ids'] = this.upsellIds!.map((v) => v.toJson()).toList();
    }
    if (this.variations != null) {
      data['variations'] = this.variations;
    }
    return data;
  }
}
