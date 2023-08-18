class WishlistModel {
  String? createdAt;
  String? full;
  List<String>? gallery;
  bool? inStock;
  String? name;
  String? price;
  int? proId;
  String? regularPrice;
  String? salePrice;
  String? sku;
  String? stockQuantity;
  String? thumbnail;
  String? proType;

  WishlistModel({
    this.createdAt,
    this.full,
    this.gallery,
    this.inStock,
    this.name,
    this.price,
    this.proId,
    this.regularPrice,
    this.salePrice,
    this.sku,
    this.stockQuantity,
    this.thumbnail,
    this.proType,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      createdAt: json['created_at'],
      full: json['full'],
      gallery: json['gallery'] != null ? new List<String>.from(json['gallery']) : null,
      inStock: json['in_stock'],
      name: json['name'],
      price: json['price'],
      proId: json['pro_id'],
      regularPrice: json['regular_price'],
      salePrice: json['sale_price'],
      sku: json['sku'],
      stockQuantity: json['stock_quantity'],
      thumbnail: json['thumbnail'],
      proType: json['pro_type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['full'] = this.full;
    data['in_stock'] = this.inStock;
    data['name'] = this.name;
    data['price'] = this.price;
    data['pro_id'] = this.proId;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['sku'] = this.sku;
    data['thumbnail'] = this.thumbnail;
    data['pro_type'] = this.proType;
    if (this.gallery != null) {
      data['gallery'] = this.gallery;
    }
    if (this.stockQuantity != null) {
      data['stock_quantity'] = this.stockQuantity;
    }
    return data;
  }
}
