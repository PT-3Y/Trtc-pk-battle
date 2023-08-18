import 'package:socialv/models/common_models/post_mdeia_model.dart';

import '../reactions/reactions_count_model.dart';


class CommentModel {
  List<CommentModel>? children;
  String? content;
  String? dateRecorded;
  String? id;
  String? itemId; // post_id
  String? secondaryItemId; // parent comment id
  String? userEmail;
  String? userId;
  String? userImage;
  String? userName;
  int? hasMentions;
  bool? isUserVerified;
  int? reactionCount;
  List<PostMediaModel>? medias;
  List<Reactions>? reactions;
  Reactions? curUserReaction;

  CommentModel({
    this.hasMentions,
    this.children,
    this.content,
    this.dateRecorded,
    this.id,
    this.itemId,
    this.secondaryItemId,
    this.userEmail,
    this.userId,
    this.userImage,
    this.userName,
    this.isUserVerified,
    this.medias,
    this.reactions,
    this.curUserReaction,
    this.reactionCount,

  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      children: json['children'] != null ? (json['children'] as List).map((i) => CommentModel.fromJson(i)).toList() : null,
      content: json['content'],
      dateRecorded: json['date_recorded'],
      id: json['id'],
      hasMentions: json['has_mentions'],
      itemId: json['item_id'],
      secondaryItemId: json['secondary_item_id'],
      userEmail: json['user_email'],
      userId: json['user_id'],
      userImage: json['user_image'],
      userName: json['user_name'],
      reactionCount: json["reaction_count"],
      isUserVerified: json['is_user_verified'],
      medias: json['medias'] != null ? (json['medias'] as List).map((i) => PostMediaModel.fromJson(i)).toList() : null,
      reactions: json['reactions'] != null ? (json['reactions'] as List).map((i) => Reactions.fromJson(i)).toList() : null,
      curUserReaction: json['cur_user_reaction'] != null ? Reactions.fromJson(json['cur_user_reaction']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['date_recorded'] = this.dateRecorded;
    data['id'] = this.id;
    data['has_mentions'] = this.hasMentions;
    data['item_id'] = this.itemId;
    data['secondary_item_id'] = this.secondaryItemId;
    data['user_email'] = this.userEmail;
    data['user_id'] = this.userId;
    data['user_image'] = this.userImage;
    data['user_name'] = this.userName;
    data['is_user_verified'] = this.isUserVerified;
    data['reaction_count'] = this.reactionCount;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    if (this.medias != null) {
      data['medias'] = this.medias!.map((v) => v.toJson()).toList();
    }
    if (this.reactions != null) {
      data['reactions'] = this.reactions!.map((v) => v.toJson()).toList();
    }
    if (this.curUserReaction != null) {
      data['cur_user_reaction'] = this.curUserReaction!.toJson();
    }
    return data;
  }
}
