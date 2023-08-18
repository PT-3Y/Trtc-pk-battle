class DeleteNotificationResponseModel {
  bool? deleted;
  Previous? previous;

  DeleteNotificationResponseModel({this.deleted, this.previous});

  factory DeleteNotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteNotificationResponseModel(
      deleted: json['deleted'],
      previous: json['previous'] != null ? Previous.fromJson(json['previous']) : null,
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

class Previous {
  String? action;
  String? component;
  String? date;
  String? dateGmt;
  int? id;
  int? isNew;
  int? itemId;
  int? secondaryItemId;
  int? userId;

  Previous({this.action, this.component, this.date, this.dateGmt, this.id, this.isNew, this.itemId, this.secondaryItemId, this.userId});

  factory Previous.fromJson(Map<String, dynamic> json) {
    return Previous(
      action: json['action'],
      component: json['component'],
      date: json['date'],
      dateGmt: json['date_gmt'],
      id: json['id'],
      isNew: json['is_new'],
      itemId: json['item_id'],
      secondaryItemId: json['secondary_item_id'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['component'] = this.component;
    data['date'] = this.date;
    data['date_gmt'] = this.dateGmt;
    data['id'] = this.id;
    data['is_new'] = this.isNew;
    data['item_id'] = this.itemId;
    data['secondary_item_id'] = this.secondaryItemId;
    data['user_id'] = this.userId;
    return data;
  }
}
