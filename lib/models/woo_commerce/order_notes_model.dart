class OrderNotesModel {
  String? author;
  bool? customerNote;
  String? dateCreated;
  String? dateCreatedGmt;
  int? id;
  String? note;

  OrderNotesModel({this.author, this.customerNote, this.dateCreated, this.dateCreatedGmt, this.id, this.note});

  factory OrderNotesModel.fromJson(Map<String, dynamic> json) {
    return OrderNotesModel(
      author: json['author'],
      customerNote: json['customer_note'],
      dateCreated: json['date_created'],
      dateCreatedGmt: json['date_created_gmt'],
      id: json['id'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['customer_note'] = this.customerNote;
    data['date_created'] = this.dateCreated;
    data['date_created_gmt'] = this.dateCreatedGmt;
    data['id'] = this.id;
    data['note'] = this.note;
    return data;
  }
}
