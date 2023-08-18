class FreshnessModel {
  int? userId;
  String? userProfileImage;

  FreshnessModel({this.userId, this.userProfileImage});

  factory FreshnessModel.fromJson(Map<String, dynamic> json) {
    return FreshnessModel(
      userId: json['user_id'],
      userProfileImage: json['user_profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_profile_image'] = this.userProfileImage;
    return data;
  }
}

class GroupDetail {
  String? createdAtDate;
  int? createdById;
  String? createdByName;
  int? groupId;
  bool? isGroupMember;
  String? coverImage;

  GroupDetail({this.createdAtDate, this.createdById, this.createdByName, this.groupId, this.isGroupMember,this.coverImage});

  factory GroupDetail.fromJson(Map<String, dynamic> json) {
    return GroupDetail(
      createdAtDate: json['created_at_date'],
      createdById: json['created_by_id'],
      createdByName: json['created_by_name'],
      groupId: json['group_id'],
      isGroupMember: json['is_group_member'],
      coverImage: json['cover_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at_date'] = this.createdAtDate;
    data['created_by_id'] = this.createdById;
    data['created_by_name'] = this.createdByName;
    data['group_id'] = this.groupId;
    data['is_group_member'] = this.isGroupMember;
    data['cover_image'] = this.coverImage;
    return data;
  }
}

class TopicReplyModel {
  List<TopicReplyModel>? children;
  String? content;
  String? createdAtDate;
  int? createdById;
  String? createdByName;
  int? id;
  String? key;
  int? replyTo;
  String? title;
  int? topicId;
  String? topicName;
  String? profileImage;
  bool? isUserVerified;

  TopicReplyModel({
    this.children,
    this.content,
    this.createdAtDate,
    this.createdById,
    this.createdByName,
    this.id,
    this.key,
    this.replyTo,
    this.title,
    this.topicId,
    this.topicName,
    this.profileImage,
    this.isUserVerified,
  });

  factory TopicReplyModel.fromJson(Map<String, dynamic> json) {
    return TopicReplyModel(
      children: json['children'] != null ? (json['children'] as List).map((i) => TopicReplyModel.fromJson(i)).toList() : null,
      content: json['content'],
      createdAtDate: json['created_at_date'],
      createdById: json['created_by_id'],
      createdByName: json['created_by_name'],
      id: json['id'],
      key: json['key'],
      replyTo: json['reply_to'],
      title: json['title'],
      topicId: json['topic_id'],
      topicName: json['topic_name'],
      profileImage: json['profile_image'],
      isUserVerified: json['is_user_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['created_at_date'] = this.createdAtDate;
    data['created_by_id'] = this.createdById;
    data['created_by_name'] = this.createdByName;
    data['id'] = this.id;
    data['key'] = this.key;
    data['title'] = this.title;
    data['topic_id'] = this.topicId;
    data['topic_name'] = this.topicName;
    data['reply_to'] = this.replyTo;
    data['profile_image'] = this.profileImage;
    data['is_user_verified'] = this.isUserVerified;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TagsModel {
  int? count;
  String? description;
  String? filter;
  String? name;
  int? parent;
  String? slug;
  String? taxonomy;
  int? termGroup;
  int? termId;
  int? termTaxonomyId;

  TagsModel({this.count, this.description, this.filter, this.name, this.parent, this.slug, this.taxonomy, this.termGroup, this.termId, this.termTaxonomyId});

  factory TagsModel.fromJson(Map<String, dynamic> json) {
    return TagsModel(
      count: json['count'],
      description: json['description'],
      filter: json['filter'],
      name: json['name'],
      parent: json['parent'],
      slug: json['slug'],
      taxonomy: json['taxonomy'],
      termGroup: json['term_group'],
      termId: json['term_id'],
      termTaxonomyId: json['term_taxonomy_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['description'] = this.description;
    data['filter'] = this.filter;
    data['name'] = this.name;
    data['parent'] = this.parent;
    data['slug'] = this.slug;
    data['taxonomy'] = this.taxonomy;
    data['term_group'] = this.termGroup;
    data['term_id'] = this.termId;
    data['term_taxonomy_id'] = this.termTaxonomyId;
    return data;
  }
}
