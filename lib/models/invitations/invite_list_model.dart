class InviteListModel {
  InviteListModel({
      this.id, 
      this.email, 
      this.message, 
      this.inviteSent, 
      this.accepted, 
      this.dateModified,});

  InviteListModel.fromJson(dynamic json) {
    id = json['id'];
    email = json['email'];
    message = json['message'];
    inviteSent = json['invite_sent'];
    accepted = json['accepted'];
    dateModified = json['date_modified'];
  }
  num? id;
  String? email;
  String? message;
  num? inviteSent;
  num? accepted;
  String? dateModified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['email'] = email;
    map['message'] = message;
    map['invite_sent'] = inviteSent;
    map['accepted'] = accepted;
    map['date_modified'] = dateModified;
    return map;
  }

}