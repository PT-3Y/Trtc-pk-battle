class Social {
  String? facebook;
  String? linkedin;
  String? twitter;
  String? youtube;

  Social({this.facebook, this.linkedin, this.twitter, this.youtube});

  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      facebook: json['facebook'],
      linkedin: json['linkedin'],
      twitter: json['twitter'],
      youtube: json['youtube'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facebook'] = this.facebook;
    data['linkedin'] = this.linkedin;
    data['twitter'] = this.twitter;
    data['youtube'] = this.youtube;
    return data;
  }
}
