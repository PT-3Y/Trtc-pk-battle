class GeneralSettingsModel {
  GeneralSettingsModel({
    this.isAccountVerificationRequire,
  });

  GeneralSettingsModel.fromJson(dynamic json) {
    isAccountVerificationRequire = json['is_account_verification_require'];
  }

  int? isAccountVerificationRequire;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_account_verification_require'] = isAccountVerificationRequire;
    return map;
  }
}
