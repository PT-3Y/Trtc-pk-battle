class AuthVerificationModel {
  AuthVerificationModel({this.isActivated, this.message});

  AuthVerificationModel.fromJson(dynamic json) {
    isActivated = json['is_activated'];
    message = json['message'];
  }

  int? isActivated;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_activated'] = isActivated;
    map['message'] = message;
    return map;
  }
}
