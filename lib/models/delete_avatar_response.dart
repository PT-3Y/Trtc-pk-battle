import 'package:socialv/models/common_models/avatar_urls.dart';

class DeleteAvatarResponse {
  bool? deleted;
  AvatarUrls? previous;

  DeleteAvatarResponse({this.deleted, this.previous});

  factory DeleteAvatarResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAvatarResponse(
      deleted: json['deleted'],
      previous: json['previous'] != null ? AvatarUrls.fromJson(json['previous']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deleted'] = this.deleted;
    if (this.previous != null) {
      data['previous'] = this.previous!.toJson();
    }
    return data;
  }
}


