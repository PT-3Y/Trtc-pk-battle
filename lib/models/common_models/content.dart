class Content {
  bool? protected;
  String? rendered;

  Content({this.protected, this.rendered});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      protected: json['protected'],
      rendered: json['rendered'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['protected'] = this.protected;
    data['rendered'] = this.rendered;
    return data;
  }
}
