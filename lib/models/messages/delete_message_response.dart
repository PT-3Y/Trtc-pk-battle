class DeleteMessageResponse {
  DeleteMessageResponse({this.deleted, this.errors});

  DeleteMessageResponse.fromJson(dynamic json) {
    deleted = json['deleted'] != null ? json['deleted'].cast<int>() : [];
    errors = json['errors'] != null ? (json['errors'] as List).map((i) => i.fromJson(i)).toList() : null;
  }

  List<int>? deleted;
  List<dynamic>? errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['deleted'] = deleted;
    if (errors != null) {
      map['errors'] = errors!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
