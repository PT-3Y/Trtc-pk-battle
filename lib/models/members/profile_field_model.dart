class ProfileFieldModel {
  List<Field>? fields;
  int? groupId;
  String? groupName;

  ProfileFieldModel({this.fields, this.groupId, this.groupName});

  factory ProfileFieldModel.fromJson(Map<String, dynamic> json) {
    return ProfileFieldModel(
      fields: json['fields'] != null ? (json['fields'] as List).map((i) => Field.fromJson(i)).toList() : null,
      groupId: json['group_id'],
      groupName: json['group_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['group_name'] = this.groupName;
    if (this.fields != null) {
      data['fields'] = this.fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Field {
  int? id;
  bool? isRequired;
  String? label;
  List<OptionField>? options;
  String? type;
  String? value;

  Field({this.id, this.isRequired, this.label, this.options, this.type, this.value});

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      isRequired: json['is_required'],
      label: json['label'],
      options: json['options'] != null ? (json['options'] as List).map((i) => OptionField.fromJson(i)).toList() : null,
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_required'] = this.isRequired;
    data['label'] = this.label;
    data['type'] = this.type;
    data['value'] = this.value;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OptionField {
  String? id;
  String? name;

  OptionField({this.id, this.name});

  factory OptionField.fromJson(Map<String, dynamic> json) {
    return OptionField(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.id;
    data['group_name'] = this.name;
    return data;
  }
}
