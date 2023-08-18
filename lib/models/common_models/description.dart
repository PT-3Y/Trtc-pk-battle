class Description {
  String? raw;
  String? rendered;

  Description({this.raw, this.rendered});

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      raw: json['raw'],
      rendered: json['rendered'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['raw'] = this.raw;
    data['rendered'] = this.rendered;
    return data;
  }
}