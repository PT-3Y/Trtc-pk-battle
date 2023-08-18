import '../common_models/links.dart';

class GroupMembershipRequestsModel {
  Links? links;
  String? dateModified;
  int? groupId;
  int? id;
  int? inviteSent;
  int? inviterId;
  Message? message;
  String? type;
  int? userId;

  GroupMembershipRequestsModel({this.links, this.dateModified, this.groupId, this.id, this.inviteSent, this.inviterId, this.message, this.type, this.userId});

  factory GroupMembershipRequestsModel.fromJson(Map<String, dynamic> json) {
    return GroupMembershipRequestsModel(
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
      dateModified: json['date_modified'],
      groupId: json['group_id'],
      id: json['id'],
      inviteSent: json['invite_sent'],
      inviterId: json['inviter_id'],
      message: json['message'] != null ? Message.fromJson(json['message']) : null,
      type: json['type'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_modified'] = this.dateModified;
    data['group_id'] = this.groupId;
    data['id'] = this.id;
    data['invite_sent'] = this.inviteSent;
    data['inviter_id'] = this.inviterId;
    data['type'] = this.type;
    data['user_id'] = this.userId;
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  String? raw;
  String? rendered;

  Message({this.raw, this.rendered});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      raw: json['raw'],
      rendered: json['rendered'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['raw'] = this.raw;
    data['rendered'] = this.rendered;
    return data;
  }
}
