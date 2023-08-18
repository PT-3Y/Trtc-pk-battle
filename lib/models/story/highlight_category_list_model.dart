class HighlightCategoryListModel {
  int? id;
  String? name;

  HighlightCategoryListModel({this.id, this.name});

  factory HighlightCategoryListModel.fromJson(Map<String, dynamic> json) {
    return HighlightCategoryListModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
