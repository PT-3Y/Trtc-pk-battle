class PostInListModel {
  int? id;
  String? title;

  PostInListModel({this.id, this.title});

  factory PostInListModel.fromJson(Map<String, dynamic> json) {
    return PostInListModel(
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}
