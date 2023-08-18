import '../common_models/links.dart';

class ProductReviewModel {
  Links? links;
  String? dateCreated;
  String? dateCreatedGmt;
  int? id;
  int? productId;
  String? productName;
  String? productPermalink;
  int? rating;
  String? review;
  String? reviewer;
  ReviewerAvatarUrls? reviewerAvatarUrls;
  String? reviewerEmail;
  String? status;
  bool? verified;

  ProductReviewModel(
      {this.links,
      this.dateCreated,
      this.dateCreatedGmt,
      this.id,
      this.productId,
      this.productName,
      this.productPermalink,
      this.rating,
      this.review,
      this.reviewer,
      this.reviewerAvatarUrls,
      this.reviewerEmail,
      this.status,
      this.verified});

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
      dateCreated: json['date_created'],
      dateCreatedGmt: json['date_created_gmt'],
      id: json['id'],
      productId: json['product_id'],
      productName: json['product_name'],
      productPermalink: json['product_permalink'],
      rating: json['rating'],
      review: json['review'],
      reviewer: json['reviewer'],
      reviewerAvatarUrls: json['reviewer_avatar_urls'] != null ? ReviewerAvatarUrls.fromJson(json['reviewer_avatar_urls']) : null,
      reviewerEmail: json['reviewer_email'],
      status: json['status'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_created'] = this.dateCreated;
    data['date_created_gmt'] = this.dateCreatedGmt;
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_permalink'] = this.productPermalink;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['reviewer'] = this.reviewer;
    data['reviewer_email'] = this.reviewerEmail;
    data['status'] = this.status;
    data['verified'] = this.verified;
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    if (this.reviewerAvatarUrls != null) {
      data['reviewer_avatar_urls'] = this.reviewerAvatarUrls!.toJson();
    }
    return data;
  }
}

class ReviewerAvatarUrls {
  String? thumb;
  String? thumbOne;
  String? full;

  ReviewerAvatarUrls({this.thumb, this.thumbOne, this.full});

  factory ReviewerAvatarUrls.fromJson(Map<String, dynamic> json) {
    return ReviewerAvatarUrls(
      thumb: json['24'],
      thumbOne: json['48'],
      full: json['96'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['24'] = this.thumb;
    data['48'] = this.thumbOne;
    data['96'] = this.full;
    return data;
  }
}
