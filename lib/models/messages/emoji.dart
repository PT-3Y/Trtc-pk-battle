

import 'emoji.dart';

class Emojis {
  String? id;
  String? name;
  List<String>? keywords;
  List<Skin>? skins;
  double? version;
  List<String>? emoticons;

  Emojis({
    this.id,
    this.name,
    this.keywords,
    this.skins,
    this.version,
    this.emoticons,
  });

  factory Emojis.fromJson(Map<String, dynamic> json) => Emojis(
    id: json["id"],
    name: json["name"],
    keywords: json["keywords"] == null ? [] : List<String>.from(json["keywords"]!.map((x) => x)),
    skins: json["skins"] == null ? [] : List<Skin>.from(json["skins"]!.map((x) => Skin.fromJson(x))),
    version: json["version"]?.toDouble(),
    emoticons: json["emoticons"] == null ? [] : List<String>.from(json["emoticons"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "keywords": keywords == null ? [] : List<dynamic>.from(keywords!.map((x) => x)),
    "skins": skins == null ? [] : List<dynamic>.from(skins!.map((x) => x.toJson())),
    "version": version,
    "emoticons": emoticons == null ? [] : List<dynamic>.from(emoticons!.map((x) => x)),
  };
}

class Skin {
  String? unified;
  String? native;
  int? x;
  int? y;

  Skin({
    this.unified,
    this.native,
    this.x,
    this.y,
  });

  factory Skin.fromJson(Map<String, dynamic> json) => Skin(
    unified: json["unified"],
    native: json["native"],
    x: json["x"],
    y: json["y"],
  );

  Map<String, dynamic> toJson() => {
    "unified": unified,
    "native": native,
    "x": x,
    "y": y,
  };
}
