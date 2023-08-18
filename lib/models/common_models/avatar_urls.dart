class AvatarUrls {
  String? full;
  String? thumb;

  AvatarUrls({this.full, this.thumb});

  factory AvatarUrls.fromJson(Map<String, dynamic> json) {
    return AvatarUrls(
      full: json['full'].toString(),
      thumb: json['thumb'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full'] = this.full;
    data['thumb'] = this.thumb;
    return data;
  }
}
