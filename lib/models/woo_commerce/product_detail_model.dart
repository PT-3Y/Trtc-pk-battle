import 'package:socialv/models/woo_commerce/common_models.dart';
import 'package:socialv/models/woo_commerce/tags_model.dart';

class ProductDetailModel {
  List<Attribute>? attributes;
  String? averageRating;
  bool? backordered;
  String? backorders;
  bool? backordersAllowed;
  String? buttonText;
  String? catalogVisibility;
  List<Category>? categories;
  List<dynamic>? crossSellIds;
  String? dateCreated;
  String? dateModified;
  String? dateOnSaleFrom;
  String? dateOnSaleTo;
  List<Attribute>? defaultAttributes;
  String? description;
  Dimensions? dimensions;
  String? downloadType;
  bool? downloadable;
  String? externalUrl;
  bool? featured;
  List<int>? groupedProducts;
  int? id;
  List<ImageModel>? images;
  bool? inStock;
  bool? isAddedCart;
  bool? isAddedWishlist;
  bool? manageStock;
  String? name;
  bool? onSale;
  String? permalink;
  String? price;
  String? priceHtml;
  bool? purchasable;
  String? purchaseNote;
  int? ratingCount;
  String? regularPrice;
  List<RelatedProductModel>? relatedProductList;
  List<int>? relatedIds;
  bool? reviewsAllowed;
  String? salePrice;
  String? shippingClass;
  bool? shippingRequired;
  bool? shippingTaxable;
  String? shortDescription;
  String? sku;
  String? slug;
  bool? soldIndividually;
  String? status;
  List<Tags>? tags;
  String? taxClass;
  String? taxStatus;
  String? type;
  List<dynamic>? upsellId;
  List<dynamic>? upsellIds;
  List<int>? variations;
  bool? virtual;
  String? weight;
  WoofvVideoEmbed? woofVideoEmbed;

  ProductDetailModel(
      {this.attributes,
      this.averageRating,
      this.backordered,
      this.backorders,
      this.backordersAllowed,
      this.buttonText,
      this.catalogVisibility,
      this.categories,
      this.crossSellIds,
      this.dateCreated,
      this.dateModified,
      this.dateOnSaleFrom,
      this.dateOnSaleTo,
      this.defaultAttributes,
      this.description,
      this.dimensions,
      this.downloadType,
      this.downloadable,
      this.externalUrl,
      this.featured,
      this.groupedProducts,
      this.id,
      this.images,
      this.inStock,
      this.isAddedCart,
      this.isAddedWishlist,
      this.manageStock,
      this.name,
      this.onSale,
      this.permalink,
      this.price,
      this.priceHtml,
      this.purchasable,
      this.purchaseNote,
      this.ratingCount,
      this.regularPrice,
      this.relatedProductList,
      this.relatedIds,
      this.reviewsAllowed,
      this.salePrice,
      this.shippingClass,
      this.shippingRequired,
      this.shippingTaxable,
      this.shortDescription,
      this.sku,
      this.slug,
      this.soldIndividually,
      this.status,
      this.tags,
      this.taxClass,
      this.taxStatus,
      this.type,
      this.upsellId,
      this.upsellIds,
      this.variations,
      this.virtual,
      this.weight,
      this.woofVideoEmbed});

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      attributes: json['attributes'] != null ? (json['attributes'] as List).map((i) => Attribute.fromJson(i)).toList() : null,
      averageRating: json['average_rating'],
      backordered: json['backordered'],
      backorders: json['backorders'],
      backordersAllowed: json['backorders_allowed'],
      buttonText: json['button_text'],
      catalogVisibility: json['catalog_visibility'],
      categories: json['categories'] != null ? (json['categories'] as List).map((i) => Category.fromJson(i)).toList() : null,
      crossSellIds: json['cross_sell_ids'] != null ? (json['cross_sell_ids'] as List).map((i) => i.fromJson(i)).toList() : null,
      dateCreated: json['date_created'],
      dateModified: json['date_modified'],
      dateOnSaleFrom: json['date_on_sale_from'],
      dateOnSaleTo: json['date_on_sale_to'],
      defaultAttributes: json['default_attributes'] != null ? (json['default_attributes'] as List).map((i) => Attribute.fromJson(i)).toList() : null,
      description: json['description'],
      dimensions: json['dimensions'] != null ? Dimensions.fromJson(json['dimensions']) : null,
      downloadType: json['download_type'],
      downloadable: json['downloadable'],
      externalUrl: json['external_url'],
      featured: json['featured'],
      groupedProducts: json['grouped_products'] != null ? new List<int>.from(json['grouped_products']) : null,
      id: json['id'],
      images: json['images'] != null ? (json['images'] as List).map((i) => ImageModel.fromJson(i)).toList() : null,
      inStock: json['in_stock'],
      isAddedCart: json['is_added_cart'],
      isAddedWishlist: json['is_added_wishlist'],
      manageStock: json['manage_stock'],
      name: json['name'],
      onSale: json['on_sale'],
      permalink: json['permalink'],
      price: json['price'].toString(),
      priceHtml: json['price_html'],
      purchasable: json['purchasable'],
      purchaseNote: json['purchase_note'],
      ratingCount: json['rating_count'],
      regularPrice: json['regular_price'],
      relatedIds: json['related_ids'] != null ? new List<int>.from(json['related_ids']) : null,
      relatedProductList: json['related_id'] != null ? (json['related_id'] as List).map((i) => RelatedProductModel.fromJson(i)).toList() : null,
      reviewsAllowed: json['reviews_allowed'],
      salePrice: json['sale_price'],
      shippingClass: json['shipping_class'],
      shippingRequired: json['shipping_required'],
      shippingTaxable: json['shipping_taxable'],
      shortDescription: json['short_description'],
      sku: json['sku'],
      slug: json['slug'],
      soldIndividually: json['sold_individually'],
      status: json['status'],
      tags: json['tags'] != null ? (json['tags'] as List).map((i) => Tags.fromJson(i)).toList() : null,
      taxClass: json['tax_class'],
      taxStatus: json['tax_status'],
      type: json['type'],
      upsellId: json['upsell_id'] != null ? (json['upsell_id'] as List).map((i) => i.fromJson(i)).toList() : null,
      upsellIds: json['upsell_ids'] != null ? (json['upsell_ids'] as List).map((i) => i.fromJson(i)).toList() : null,
      variations: json['variations'] != null ? List<int>.from(json['variations']) : null,
      virtual: json['virtual'],
      weight: json['weight'],
      woofVideoEmbed: json['woofv_video_embed'] != null ? WoofvVideoEmbed.fromJson(json['woofv_video_embed']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average_rating'] = this.averageRating;
    data['backordered'] = this.backordered;
    data['backorders'] = this.backorders;
    data['backorders_allowed'] = this.backordersAllowed;
    data['button_text'] = this.buttonText;
    data['catalog_visibility'] = this.catalogVisibility;
    data['date_created'] = this.dateCreated;
    data['date_modified'] = this.dateModified;
    data['date_on_sale_from'] = this.dateOnSaleFrom;
    data['date_on_sale_to'] = this.dateOnSaleTo;
    data['description'] = this.description;
    data['download_type'] = this.downloadType;
    data['downloadable'] = this.downloadable;
    data['external_url'] = this.externalUrl;
    data['featured'] = this.featured;
    data['id'] = this.id;
    data['in_stock'] = this.inStock;
    data['is_added_cart'] = this.isAddedCart;
    data['is_added_wishlist'] = this.isAddedWishlist;
    data['manage_stock'] = this.manageStock;
    data['name'] = this.name;
    data['on_sale'] = this.onSale;
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
    data['shipping_required'] = this.shippingRequired;
    data['shipping_taxable'] = this.shippingTaxable;
    data['short_description'] = this.shortDescription;
    data['sku'] = this.sku;
    data['slug'] = this.slug;
    data['sold_individually'] = this.soldIndividually;
    data['status'] = this.status;
    data['tax_class'] = this.taxClass;
    data['tax_status'] = this.taxStatus;
    data['type'] = this.type;
    data['virtual'] = this.virtual;
    data['weight'] = this.weight;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.crossSellIds != null) {
      data['cross_sell_ids'] = this.crossSellIds!.map((v) => v.toJson()).toList();
    }
    if (this.defaultAttributes != null) {
      data['default_attributes'] = this.defaultAttributes!.map((v) => v.toJson()).toList();
    }
    if (this.dimensions != null) {
      data['dimensions'] = this.dimensions!.toJson();
    }
    if (this.groupedProducts != null) {
      data['grouped_products'] = this.groupedProducts;
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.relatedProductList != null) {
      data['related_id'] = this.relatedProductList!.map((v) => v.toJson()).toList();
    }
    if (this.relatedIds != null) {
      data['related_ids'] = this.relatedIds;
    }

    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    if (this.upsellId != null) {
      data['upsell_id'] = this.upsellId!.map((v) => v.toJson()).toList();
    }
    if (this.upsellIds != null) {
      data['upsell_ids'] = this.upsellIds!.map((v) => v.toJson()).toList();
    }
    if (this.variations != null) {
      data['variations'] = this.variations;
    }
    if (this.woofVideoEmbed != null) {
      data['woofv_video_embed'] = this.woofVideoEmbed!.toJson();
    }
    return data;
  }
}

class WoofvVideoEmbed {
  WoofvVideoEmbed();

  factory WoofvVideoEmbed.fromJson(Map<String, dynamic> json) {
    return WoofvVideoEmbed();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class RelatedProductModel {
  int? id;
  List<ImageModel>? images;
  String? name;
  String? price;
  String? regularPrice;
  String? salePrice;
  String? slug;

  RelatedProductModel({this.id, this.images, this.name, this.price, this.regularPrice, this.salePrice, this.slug});

  factory RelatedProductModel.fromJson(Map<String, dynamic> json) {
    return RelatedProductModel(
      id: json['id'],
      images: json['images'] != null ? (json['images'] as List).map((i) => ImageModel.fromJson(i)).toList() : null,
      name: json['name'],
      price: json['price'].toString(),
      regularPrice: json['regular_price'],
      salePrice: json['sale_price'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['slug'] = this.slug;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
