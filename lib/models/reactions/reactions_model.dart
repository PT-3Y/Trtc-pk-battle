class ReactionsModel {
  String? id;
  String? imageUrl;
  String? name;
  String? defaultImageUrl;


  ReactionsModel({this.id, this.imageUrl, this.name,this.defaultImageUrl});

  factory ReactionsModel.fromJson(Map<String, dynamic> json) {
    return ReactionsModel(
      id: json['id'],
      imageUrl: json['image_url'],
      name: json['name'],
      defaultImageUrl: json['default_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image_url'] = this.imageUrl;
    data['name'] = this.name;
    data['default_image_url'] = this.defaultImageUrl;
    return data;
  }
}
