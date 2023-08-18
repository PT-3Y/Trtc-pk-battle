class ReactionCountModel {
  List<Reactions>? reactions;
  List<Reactions>? count;

  ReactionCountModel({
    this.reactions,
    this.count,
  });

  ReactionCountModel.fromJson(dynamic json) {
    reactions = json['reactions'] != null ? (json['reactions'] as List).map((i) => Reactions.fromJson(i)).toList() : null;
    count = json['count'] != null ? (json['count'] as List).map((i) => Reactions.fromJson(i)).toList() : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (this.reactions != null) {
      map['reactions'] = this.reactions!.map((v) => v.toJson()).toList();
    }
    if (this.count != null) {
      map['count'] = this.count!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Reactions {
  String? id;
  String? icon;
  String? reaction;
  String? title;
  int? count;
  ReactedUser? user;

  Reactions({
    this.id,
    this.icon,
    this.reaction,
    this.title,
    this.count,
    this.user,
  });

  Reactions.fromJson(dynamic json) {
    id = json['id'].toString();
    icon = json['icon'];
    reaction = json['reaction'];
    title = json['title'];
    count = json['count'];
    user = json['user'] != null ? ReactedUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['icon'] = icon;
    map['reaction'] = reaction;
    map['title'] = title;
    map['count'] = count;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }
}

class ReactedUser {
  ReactedUser({
    this.id,
    this.displayName,
    this.userName,
    this.avatar,
    this.isVerified,
  });

  ReactedUser.fromJson(dynamic json) {
    id = json['id'];
    displayName = json['display_name'];
    userName = json['user_name'];
    avatar = json['avatar'];
    isVerified = json['is_verified'];
  }

  num? id;
  String? displayName;
  String? userName;
  String? avatar;
  bool? isVerified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['display_name'] = displayName;
    map['user_name'] = userName;
    map['avatar'] = avatar;
    map['is_verified'] = isVerified;
    return map;
  }
}
