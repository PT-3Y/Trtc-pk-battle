// To parse this JSON data, do
//
//     final courseCategory = courseCategoryFromJson(jsonString);

import 'dart:convert';

List<CourseCategory> courseCategoryFromJson(String str) => List<CourseCategory>.from(json.decode(str).map((x) => CourseCategory.fromJson(x)));

String courseCategoryToJson(List<CourseCategory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CourseCategory {
  int? id;
  int? count;
  Description? description;
  String? link;
  String? name;
  String? slug;
  Taxonomy? taxonomy;
  int? parent;
  List<dynamic>? meta;
  List<dynamic>? acf;
  Links? links;

  CourseCategory({
    this.id,
    this.count,
    this.description,
    this.link,
    this.name,
    this.slug,
    this.taxonomy,
    this.parent,
    this.meta,
    this.acf,
    this.links,
  });

  factory CourseCategory.fromJson(Map<String, dynamic> json) => CourseCategory(
    id: json["id"],
    count: json["count"],
    description: descriptionValues.map[json["description"]]!,
    link: json["link"],
    name: json["name"],
    slug: json["slug"],
    taxonomy: taxonomyValues.map[json["taxonomy"]]!,
    parent: json["parent"],
    meta: json["meta"] == null ? [] : List<dynamic>.from(json["meta"]!.map((x) => x)),
    acf: json["acf"] == null ? [] : List<dynamic>.from(json["acf"]!.map((x) => x)),
    links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "count": count,
    "description": descriptionValues.reverse[description],
    "link": link,
    "name": name,
    "slug": slug,
    "taxonomy": taxonomyValues.reverse[taxonomy],
    "parent": parent,
    "meta": meta == null ? [] : List<dynamic>.from(meta!.map((x) => x)),
    "acf": acf == null ? [] : List<dynamic>.from(acf!.map((x) => x)),
    "_links": links?.toJson(),
  };
}

enum Description { EMPTY, WE_DENOUNCE_WITH_RIGHTEOUS_INDIGE_NATION_AND_DISLIKE, DESCRIPTION }

final descriptionValues = EnumValues({
  "  ": Description.DESCRIPTION,
  " ": Description.EMPTY,
  "  We denounce with righteous indige nation and dislike.": Description.WE_DENOUNCE_WITH_RIGHTEOUS_INDIGE_NATION_AND_DISLIKE
});

class Links {
  List<About>? self;
  List<About>? collection;
  List<About>? about;
  List<About>? wpPostType;
  List<Cury>? curies;

  Links({
    this.self,
    this.collection,
    this.about,
    this.wpPostType,
    this.curies,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    self: json["self"] == null ? [] : List<About>.from(json["self"]!.map((x) => About.fromJson(x))),
    collection: json["collection"] == null ? [] : List<About>.from(json["collection"]!.map((x) => About.fromJson(x))),
    about: json["about"] == null ? [] : List<About>.from(json["about"]!.map((x) => About.fromJson(x))),
    wpPostType: json["wp:post_type"] == null ? [] : List<About>.from(json["wp:post_type"]!.map((x) => About.fromJson(x))),
    curies: json["curies"] == null ? [] : List<Cury>.from(json["curies"]!.map((x) => Cury.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "self": self == null ? [] : List<dynamic>.from(self!.map((x) => x.toJson())),
    "collection": collection == null ? [] : List<dynamic>.from(collection!.map((x) => x.toJson())),
    "about": about == null ? [] : List<dynamic>.from(about!.map((x) => x.toJson())),
    "wp:post_type": wpPostType == null ? [] : List<dynamic>.from(wpPostType!.map((x) => x.toJson())),
    "curies": curies == null ? [] : List<dynamic>.from(curies!.map((x) => x.toJson())),
  };
}

class About {
  String? href;

  About({
    this.href,
  });

  factory About.fromJson(Map<String, dynamic> json) => About(
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "href": href,
  };
}

class Cury {
  Name? name;
  Href? href;
  bool? templated;

  Cury({
    this.name,
    this.href,
    this.templated,
  });

  factory Cury.fromJson(Map<String, dynamic> json) => Cury(
    name: nameValues.map[json["name"]]!,
    href: hrefValues.map[json["href"]]!,
    templated: json["templated"],
  );

  Map<String, dynamic> toJson() => {
    "name": nameValues.reverse[name],
    "href": hrefValues.reverse[href],
    "templated": templated,
  };
}

enum Href { HTTPS_API_W_ORG_REL }

final hrefValues = EnumValues({
  "https://api.w.org/{rel}": Href.HTTPS_API_W_ORG_REL
});

enum Name { WP }

final nameValues = EnumValues({
  "wp": Name.WP
});

enum Taxonomy { COURSE_CATEGORY }

final taxonomyValues = EnumValues({
  "course_category": Taxonomy.COURSE_CATEGORY
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
