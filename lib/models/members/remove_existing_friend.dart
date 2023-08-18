class RemoveExistingFriend {
  bool? deleted;
  Previous? previous;

  RemoveExistingFriend({this.deleted, this.previous});

  factory RemoveExistingFriend.fromJson(Map<String, dynamic> json) {
    return RemoveExistingFriend(
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
  String? dateCreated;
  String? dateCreatedGmt;
  int? friendId;
  int? id;
  int? initiatorId;
  bool? isConfirmed;

  Previous({this.dateCreated, this.dateCreatedGmt, this.friendId, this.id, this.initiatorId, this.isConfirmed});

  factory Previous.fromJson(Map<String, dynamic> json) {
    return Previous(
      dateCreated: json['date_created'],
      dateCreatedGmt: json['date_created_gmt'],
      friendId: json['friend_id'],
      id: json['id'],
      initiatorId: json['initiator_id'],
      isConfirmed: json['is_confirmed'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_created'] = this.dateCreated;
    data['date_created_gmt'] = this.dateCreatedGmt;
    data['friend_id'] = this.friendId;
    data['id'] = this.id;
    data['initiator_id'] = this.initiatorId;
    data['is_confirmed'] = this.isConfirmed;
    return data;
  }
}
