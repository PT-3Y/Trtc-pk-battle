class NotificationSettingsModel {
  String? key;
  String? name;
  bool? value;

  NotificationSettingsModel({this.key, this.name, this.value});

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      key: json['key'],
      name: json['name'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
