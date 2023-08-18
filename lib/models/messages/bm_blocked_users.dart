class BmBlockedUsers {
  BmBlockedUsers({
    this.id,
    this.title,
    this.type,
    this.user,
  });

  BmBlockedUsers.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    if (json['user'] != null) {
      user = [];
      json['user'].forEach((v) {
        user!.add(UserObject.fromJson(v));
      });
    }
  }

  String? id;
  String? title;
  String? type;
  List<UserObject>? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['type'] = type;
    if (user != null) {
      map['user'] = user!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class UserObject {
  UserObject({
    this.id,
    this.memberAvtarImage,
    this.memberCoverImage,
    this.name,
    this.mentionName,
    this.email,
    this.isUserVerified,
  });

  UserObject.fromJson(dynamic json) {
    id = json['id'];
    memberAvtarImage = json['member_avtar_image'];
    memberCoverImage = json['member_cover_image'];
    name = json['name'];
    mentionName = json['mention_name'];
    email = json['email'];
    isUserVerified = json['is_user_verified'];
  }

  int? id;
  String? memberAvtarImage;
  String? memberCoverImage;
  String? name;
  String? mentionName;
  String? email;
  bool? isUserVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['member_avtar_image'] = memberAvtarImage;
    map['member_cover_image'] = memberCoverImage;
    map['name'] = name;
    map['mention_name'] = mentionName;
    map['email'] = email;
    map['is_user_verified'] = isUserVerified;
    return map;
  }
}
