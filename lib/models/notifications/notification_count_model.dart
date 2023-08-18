class NotificationCountModel {
  int? notificationCount;
  int? unreadMessagesCount;

  NotificationCountModel({this.notificationCount, this.unreadMessagesCount});

  factory NotificationCountModel.fromJson(Map<String, dynamic> json) {
    return NotificationCountModel(
      notificationCount: json['notification_count'],
      unreadMessagesCount: json['unread_messages_count'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_count'] = this.notificationCount;
    data['unread_messages_count'] = this.unreadMessagesCount;
    return data;
  }
}
