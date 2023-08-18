class ProfileVisibilityModel {
  List<Field>? fields;
  String? groupName;
  String? groupType;
  bool isChange;

  ProfileVisibilityModel({this.fields, this.groupName,this.isChange = false,this.groupType});

  factory ProfileVisibilityModel.fromJson(Map<String, dynamic> json) {
    return ProfileVisibilityModel(
      fields: json['fields'] != null ? (json['fields'] as List).map((i) => Field.fromJson(i)).toList() : null,
      groupName: json['group_name'],
      groupType: json['group_type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_name'] = this.groupName;
    data['group_type'] = this.groupType;
    if (this.fields != null) {
      data['fields'] = this.fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Field {
  bool? canChange;
  int? id;
  String? level;
  String? name;
  String? visibility;
  String? key;

  Field({this.canChange, this.id, this.level, this.name, this.visibility,this.key});

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      canChange: json['can_change'],
      id: json['id'],
      level: json['level'],
      name: json['name'],
      visibility: json['visibility'],
      key: json['key'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['can_change'] = this.canChange;
    data['id'] = this.id;
    data['level'] = this.level;
    data['name'] = this.name;
    data['visibility'] = this.visibility;
    data['key'] = this.key;
    return data;
  }
}
