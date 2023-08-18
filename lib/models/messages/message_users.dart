class MessagesUsers {
  MessagesUsers({
    this.id,
    this.userId,
    this.name,
    this.avatar,
    //this.url,
    this.verified,
    this.lastActive,
    this.isFriend,
    this.canVideo,
    this.canAudio,
    this.blocked,
    this.canBlock,
  });

  MessagesUsers.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    avatar = json['avatar'];
    //url = json['url'];
    verified = json['verified'];
    lastActive = json['lastActive'];
    isFriend = json['isFriend'];
    canVideo = json['canVideo'];
    canAudio = json['canAudio'];
    blocked = json['blocked'];
    canBlock = json['canBlock'];
  }

  String? id;
  int? userId;
  String? name;
  String? avatar;
  //String? url;
  int? verified;
  String? lastActive;
  int? isFriend;
  int? canVideo;
  int? canAudio;
  int? blocked;
  int? canBlock;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['name'] = name;
    map['avatar'] = avatar;
    //map['url'] = url;
    map['verified'] = verified;
    map['lastActive'] = lastActive;
    map['isFriend'] = isFriend;
    map['canVideo'] = canVideo;
    map['canAudio'] = canAudio;
    map['blocked'] = blocked;
    map['canBlock'] = canBlock;
    return map;
  }
}
