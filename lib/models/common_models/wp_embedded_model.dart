import 'package:socialv/models/common_models/content.dart';

class Embedded {
  List<Author>? author;
  List<FeaturedMedia>? featuredMedia;
  List<List<dynamic>>? wpTerms;

  Embedded({this.author, this.featuredMedia, this.wpTerms});

  factory Embedded.fromJson(Map<String, dynamic> json) {
    return Embedded(
      author: json['author'] != null ? (json['author'] as List).map((i) => Author.fromJson(i)).toList() : null,
      featuredMedia: json['wp:featuredmedia'] != null ? (json['wp:featuredmedia'] as List).map((i) => FeaturedMedia.fromJson(i)).toList() : null,
      wpTerms: json['wp:term'] != null ? (json['wp:term'] as List).map((i) => (i as List).toList()).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.author != null) {
      data['author'] = this.author!.map((v) => v.toJson()).toList();
    }
    if (this.wpTerms != null) {
      data['wp:term'] = this.wpTerms;
    }

    return data;
  }
}

class Author {
  List<dynamic>? acf;
  AvatarUrls? avatar_urls;
  String? description;
  int? id;
  bool? is_super_admin;
  String? link;
  String? name;
  String? slug;
  String? url;
  bool? is_user_verified;

  Author({this.acf, this.avatar_urls, this.description, this.id, this.is_super_admin, this.link, this.name, this.slug, this.url, this.is_user_verified});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      acf: json['acf'] != null ? (json['acf'] as List).map((i) => i.fromJson(i)).toList() : null,
      avatar_urls: json['avatar_urls'] != null ? AvatarUrls.fromJson(json['avatar_urls']) : null,
      description: json['description'],
      id: json['id'],
      is_super_admin: json['is_super_admin'],
      link: json['link'],
      name: json['name'],
      slug: json['slug'],
      url: json['url'],
      is_user_verified: json['is_user_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    data['is_super_admin'] = this.is_super_admin;
    data['link'] = this.link;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['url'] = this.url;
    data['is_user_verified'] = this.is_user_verified;

    if (this.acf != null) {
      data['acf'] = this.acf!.map((v) => v.toJson()).toList();
    }
    if (this.avatar_urls != null) {
      data['avatar_urls'] = this.avatar_urls!.toJson();
    }

    return data;
  }
}

class FeaturedMedia {
  List<dynamic>? acf;
  String? alt_text;
  int? author;
  Content? caption;
  String? date;
  int? id;
  String? link;
  String? media_type;
  String? mime_type;
  String? slug;
  String? source_url;
  Content? title;
  String? type;

  FeaturedMedia({this.acf, this.alt_text, this.author, this.caption, this.date, this.id, this.link, this.media_type, this.mime_type, this.slug, this.source_url, this.title, this.type});

  factory FeaturedMedia.fromJson(Map<String, dynamic> json) {
    return FeaturedMedia(
      acf: json['acf'] != null ? (json['acf'] as List).map((i) => i.fromJson(i)).toList() : null,
      alt_text: json['alt_text'],
      author: json['author'],
      caption: json['caption'] != null ? Content.fromJson(json['caption']) : null,
      date: json['date'],
      id: json['id'],
      link: json['link'],
      media_type: json['media_type'],
      mime_type: json['mime_type'],
      slug: json['slug'],
      source_url: json['source_url'],
      title: json['title'] != null ? Content.fromJson(json['title']) : null,
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alt_text'] = this.alt_text;
    data['author'] = this.author;
    data['date'] = this.date;
    data['id'] = this.id;
    data['link'] = this.link;
    data['media_type'] = this.media_type;
    data['mime_type'] = this.mime_type;
    data['slug'] = this.slug;
    data['source_url'] = this.source_url;
    data['type'] = this.type;

    if (this.acf != null) {
      data['acf'] = this.acf!.map((v) => v.toJson()).toList();
    }
    if (this.caption != null) {
      data['caption'] = this.caption!.toJson();
    }

    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    return data;
  }
}

class AvatarUrls {
  String? twentyFour;
  String? fortyEight;
  String? ninetySix;

  AvatarUrls({this.twentyFour, this.fortyEight, this.ninetySix});

  factory AvatarUrls.fromJson(Map<String, dynamic> json) {
    return AvatarUrls(
      twentyFour: json['24'],
      fortyEight: json['48'],
      ninetySix: json['96'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['24'] = this.twentyFour;
    data['48'] = this.fortyEight;
    data['96'] = this.ninetySix;
    return data;
  }
}

class WpTermsModel {
  int? id;
  String? link;
  String? name;
  String? taxonomy;

  WpTermsModel({this.id, this.link, this.name, this.taxonomy});

  factory WpTermsModel.fromJson(Map<String, dynamic> json) {
    return WpTermsModel(
      id: json['id'],
      link: json['link'],
      name: json['name'],
      taxonomy: json['taxonomy'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['link'] = this.link;
    data['name'] = this.name;
    data['taxonomy'] = this.taxonomy;
    return data;
  }
}
