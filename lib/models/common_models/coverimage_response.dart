class CoverImageResponse {
  String? image;

  CoverImageResponse({this.image});

  factory CoverImageResponse.fromJson(Map<String, dynamic> json) {
    return CoverImageResponse(
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}
