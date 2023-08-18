import 'package:socialv/models/common_models/description.dart';

class RejectGroupInviteResponse {
  bool? deleted;
  Previous? previous;

  RejectGroupInviteResponse({this.deleted, this.previous});

  factory RejectGroupInviteResponse.fromJson(Map<String, dynamic> json) {
    return RejectGroupInviteResponse(
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
  String? dateModified;
  String? dateModifiedGmt;
  int? groupId;
  int? id;
  int? inviteSent;
  int? inviterId;
  Description? message;
  String? type;
  int? userId;

  Previous({this.dateModified, this.dateModifiedGmt, this.groupId, this.id, this.inviteSent, this.inviterId, this.message, this.type, this.userId});

  factory Previous.fromJson(Map<String, dynamic> json) {
    return Previous(
      dateModified: json['date_modified'],
      dateModifiedGmt: json['date_modified_gmt'],
      groupId: json['group_id'],
      id: json['id'],
      inviteSent: json['invite_sent'],
      inviterId: json['inviter_id'],
      message: json['message'] != null ? Description.fromJson(json['message']) : null,
      type: json['type'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_modified'] = this.dateModified;
    data['date_modified_gmt'] = this.dateModifiedGmt;
    data['group_id'] = this.groupId;
    data['id'] = this.id;
    data['invite_sent'] = this.inviteSent;
    data['inviter_id'] = this.inviterId;
    data['type'] = this.type;
    data['user_id'] = this.userId;
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}
