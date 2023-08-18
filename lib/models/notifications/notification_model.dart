class NotificationModel {
  String? action;
  String? component;
  String? date;
  int? id;
  int? isNew;
  int? itemId;
  String? itemImage;
  String? itemName;
  int? secondaryItemId;
  String? secondaryItemImage;
  String? secondaryItemName;
  bool? isUserVerified;
  int? topicId;
  String? requestId;
  int? groupId;

  NotificationModel({
    this.action,
    this.component,
    this.date,
    this.id,
    this.isNew,
    this.itemId,
    this.itemImage,
    this.itemName,
    this.secondaryItemId,
    this.secondaryItemImage,
    this.secondaryItemName,
    this.isUserVerified,
    this.topicId,
    this.requestId,
    this.groupId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      action: json['action'],
      component: json['component'],
      date: json['date'],
      id: json['id'],
      isNew: json['is_new'],
      itemId: json['item_id'],
      itemImage: json['item_image'],
      itemName: json['item_name'],
      secondaryItemId: json['secondary_item_id'],
      secondaryItemImage: (json['secondary_item_image'] is bool) ? "" : json['secondary_item_image'],
      secondaryItemName: (json['secondary_item_name'] is bool) ? "" : json['secondary_item_name'],
      isUserVerified: json['is_user_verified'],
      topicId: json['topic_id'],
      requestId: json['request_id'].toString(),
      groupId: json['group_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['component'] = this.component;
    data['date'] = this.date;
    data['id'] = this.id;
    data['is_new'] = this.isNew;
    data['item_id'] = this.itemId;
    data['item_image'] = this.itemImage;
    data['item_name'] = this.itemName;
    data['secondary_item_id'] = this.secondaryItemId;
    data['secondary_item_image'] = this.secondaryItemImage;
    data['secondary_item_name'] = this.secondaryItemName;
    data['is_user_verified'] = this.isUserVerified;
    data['topic_id'] = this.topicId;
    data['request_id'] = this.requestId;
    data['group_id'] = this.groupId;
    return data;
  }
}
