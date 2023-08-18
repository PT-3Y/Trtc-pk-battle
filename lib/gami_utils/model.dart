class EarningModel {
  final String date;
  final String title;
  final String points;
  final String pointsType;

  EarningModel({
    required this.date,
    required this.title,
    required this.points,
    required this.pointsType,
  });

  factory EarningModel.fromJson(Map<String, dynamic> json) {
    return EarningModel(
      date: json['date'],
      title: json['title'],
      points: json['points'],
      pointsType: json['points_type'],
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String url;
  final String description;
  final String link;
  final String slug;
  final Map<String, String> avatarUrls;
  final Map<String, dynamic> meta;
  final bool isSuperAdmin;
  final Map<String, dynamic> woocommerceMeta;
  final bool isUserVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.url,
    required this.description,
    required this.link,
    required this.slug,
    required this.avatarUrls,
    required this.meta,
    required this.isSuperAdmin,
    required this.woocommerceMeta,
    required this.isUserVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      description: json['description'],
      link: json['link'],
      slug: json['slug'],
      avatarUrls: Map<String, String>.from(json['avatar_urls']),
      meta: Map<String, dynamic>.from(json['meta']),
      isSuperAdmin: json['is_super_admin'],
      woocommerceMeta: Map<String, dynamic>.from(json['woocommerce_meta']),
      isUserVerified: json['is_user_verified'],
    );
  }
}
