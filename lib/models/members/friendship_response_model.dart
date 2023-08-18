import 'package:socialv/models/common_models/collection.dart';
import 'package:socialv/models/common_models/user.dart';

class FriendshipResponseModel {
  Links? links;
  String? dateCreated;
  String? dateCreatedGmt;
  int? friendId;
  int? id;
  int? initiatorId;
  bool? isConfirmed;

  FriendshipResponseModel({this.links, this.dateCreated, this.dateCreatedGmt, this.friendId, this.id, this.initiatorId, this.isConfirmed});

  factory FriendshipResponseModel.fromJson(Map<String, dynamic> json) {
    return FriendshipResponseModel(
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
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
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    return data;
  }
}

class Links {
  List<Collection>? collection;
  List<Friend>? friend;
  List<Initiator>? initiator;
  List<User>? self;

  Links({this.collection, this.friend, this.initiator, this.self});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      collection: json['collection'] != null ? (json['collection'] as List).map((i) => Collection.fromJson(i)).toList() : null,
      friend: json['friend'] != null ? (json['friend'] as List).map((i) => Friend.fromJson(i)).toList() : null,
      initiator: json['initiator'] != null ? (json['initiator'] as List).map((i) => Initiator.fromJson(i)).toList() : null,
      self: json['self'] != null ? (json['self'] as List).map((i) => User.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.collection != null) {
      data['collection'] = this.collection!.map((v) => v.toJson()).toList();
    }
    if (this.friend != null) {
      data['friend'] = this.friend!.map((v) => v.toJson()).toList();
    }
    if (this.initiator != null) {
      data['initiator'] = this.initiator!.map((v) => v.toJson()).toList();
    }
    if (this.self != null) {
      data['self'] = this.self!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Friend {
  bool? embeddable;
  String? href;

  Friend({this.embeddable, this.href});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      embeddable: json['embeddable'],
      href: json['href'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['embeddable'] = this.embeddable;
    data['href'] = this.href;
    return data;
  }
}

class Initiator {
  bool? embeddable;
  String? href;

  Initiator({this.embeddable, this.href});

  factory Initiator.fromJson(Map<String, dynamic> json) {
    return Initiator(
      embeddable: json['embeddable'],
      href: json['href'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['embeddable'] = this.embeddable;
    data['href'] = this.href;
    return data;
  }
}
