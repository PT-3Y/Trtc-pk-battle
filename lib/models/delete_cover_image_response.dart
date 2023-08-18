class DeleteCoverImageResponse {
  bool? deleted;
  String? previous;

  DeleteCoverImageResponse({this.deleted, this.previous});

  factory DeleteCoverImageResponse.fromJson(Map<String, dynamic> json) {
    return DeleteCoverImageResponse(
      deleted: json['deleted'],
      previous: json['previous'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deleted'] = this.deleted;
    data['previous'] = this.previous;
    return data;
  }
}
