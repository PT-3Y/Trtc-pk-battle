class User {
  bool? embeddable;
  String? href;
  String? taxonomy;
  int? count;
  int? id;
  bool? templated;
  String? name;

  User({this.embeddable, this.href, this.taxonomy, this.count, this.id, this.templated, this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      embeddable: json['embeddable'],
      href: json['href'],
      taxonomy: json['taxonomy'],
      count: json['count'],
      id: json['id'],
      templated: json['templated'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['embeddable'] = this.embeddable;
    data['href'] = this.href;
    data['taxonomy'] = this.taxonomy;
    data['count'] = this.count;
    data['id'] = this.id;
    data['templated'] = this.templated;
    data['name'] = this.name;

    return data;
  }
}
