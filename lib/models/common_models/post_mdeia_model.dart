class PostMediaModel {
  int? id;
  String? type;
  String? url;
  String? source;

  PostMediaModel({this.id, this.type, this.url, this.source});

  factory PostMediaModel.fromJson(Map<String, dynamic> json) {
    return PostMediaModel(
      id: json['id'],
      type: json['type'],
      url: json['url'],
      source: json['source'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['url'] = this.url;
    data['source'] = this.source;
    return data;
  }
}
