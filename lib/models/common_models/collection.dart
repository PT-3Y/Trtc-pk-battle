class Collection {
  String? href;

  Collection({this.href});

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      href: json['href'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}
