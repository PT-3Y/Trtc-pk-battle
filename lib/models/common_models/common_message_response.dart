class CommonMessageResponse {
  String? message;
  int? commentId;
  int? albumId;

  CommonMessageResponse({this.message, this.commentId,this.albumId});

  factory CommonMessageResponse.fromJson(Map<String, dynamic> json) {
    return CommonMessageResponse(
      message: json['message'],
      commentId: json['comment_id'],
      albumId: json['album_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['comment_id'] = this.commentId;
    data['album_id'] = this.albumId;

    return data;
  }
}
