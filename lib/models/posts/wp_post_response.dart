import 'package:socialv/models/common_models/collection.dart';
import 'package:socialv/models/common_models/content.dart';
import 'package:socialv/models/common_models/user.dart';
import 'package:socialv/models/common_models/wp_embedded_model.dart';

class WpPostResponse {
  Links? links;
  List<dynamic>? acf;
  int? author;
  List<int>? categories;
  String? comment_status;
  Content? content;
  String? date;
  String? date_gmt;
  Content? excerpt;
  int? featured_media;
  String? format;
  Content? guid;
  int? id;
  String? link;
  Meta? meta;
  String? modified;
  String? modified_gmt;
  String? ping_status;
  String? slug;
  String? status;
  bool? sticky;
  List<int>? tags;
  String? template;
  Content? title;
  String? type;
  Embedded? embedded;
  bool? sv_is_comment_open;

  WpPostResponse({
    this.links,
    this.acf,
    this.author,
    this.categories,
    this.comment_status,
    this.content,
    this.date,
    this.date_gmt,
    this.excerpt,
    this.featured_media,
    this.format,
    this.guid,
    this.id,
    this.link,
    this.meta,
    this.modified,
    this.modified_gmt,
    this.ping_status,
    this.slug,
    this.status,
    this.sticky,
    this.tags,
    this.template,
    this.title,
    this.type,
    this.embedded,
    this.sv_is_comment_open,
  });

  factory WpPostResponse.fromJson(Map<String, dynamic> json) {
    return WpPostResponse(
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
      acf: json['acf'] != null ? (json['acf'] as List).map((i) => i.fromJson(i)).toList() : null,
      author: json['author'],
      categories: json['categories'] != null ? new List<int>.from(json['categories']) : null,
      comment_status: json['comment_status'],
      content: json['content'] != null ? Content.fromJson(json['content']) : null,
      date: json['date'],
      date_gmt: json['date_gmt'],
      excerpt: json['excerpt'] != null ? Content.fromJson(json['excerpt']) : null,
      featured_media: json['featured_media'],
      format: json['format'],
      guid: json['guid'] != null ? Content.fromJson(json['guid']) : null,
      id: json['id'],
      link: json['link'],
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      modified: json['modified'],
      modified_gmt: json['modified_gmt'],
      ping_status: json['ping_status'],
      slug: json['slug'],
      status: json['status'],
      sticky: json['sticky'],
      tags: json['tags'] != null ? new List<int>.from(json['tags']) : null,
      template: json['template'],
      title: json['title'] != null ? Content.fromJson(json['title']) : null,
      type: json['type'],
      embedded: json['_embedded'] != null ? Embedded.fromJson(json['_embedded']) : null,
      sv_is_comment_open: json['sv_is_comment_open'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['comment_status'] = this.comment_status;
    data['date'] = this.date;
    data['date_gmt'] = this.date_gmt;
    data['featured_media'] = this.featured_media;
    data['format'] = this.format;
    data['id'] = this.id;
    data['link'] = this.link;
    data['modified'] = this.modified;
    data['modified_gmt'] = this.modified_gmt;
    data['ping_status'] = this.ping_status;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['sticky'] = this.sticky;
    data['template'] = this.template;
    data['type'] = this.type;
    data['sv_is_comment_open'] = this.sv_is_comment_open;

    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    if (this.acf != null) {
      data['acf'] = this.acf!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories;
    }
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    if (this.excerpt != null) {
      data['excerpt'] = this.excerpt!.toJson();
    }
    if (this.guid != null) {
      data['guid'] = this.guid!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    if (this.tags != null) {
      data['tags'] = this.tags;
    }
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    if (this.embedded != null) {
      data['_embedded'] = this.embedded!.toJson();
    }
    return data;
  }
}

class Links {
  List<User>? about;
  List<User>? author;
  List<Collection>? collection;
  List<User>? curies;
  List<User>? predecessorVersion;
  List<User>? replies;
  List<User>? self;
  List<User>? versionHistory;
  List<User>? wpAttachment;
  List<User>? wpFeaturedMedia;
  List<User>? wpTerm;

  Links({
    this.about,
    this.author,
    this.collection,
    this.curies,
    this.predecessorVersion,
    this.replies,
    this.self,
    this.versionHistory,
    this.wpAttachment,
    this.wpFeaturedMedia,
    this.wpTerm,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      about: json['about'] != null ? (json['about'] as List).map((i) => User.fromJson(i)).toList() : null,
      author: json['author'] != null ? (json['author'] as List).map((i) => User.fromJson(i)).toList() : null,
      collection: json['collection'] != null ? (json['collection'] as List).map((i) => Collection.fromJson(i)).toList() : null,
      curies: json['curies'] != null ? (json['curies'] as List).map((i) => User.fromJson(i)).toList() : null,
      predecessorVersion: json['predecessor-version'] != null ? (json['predecessor-version'] as List).map((i) => User.fromJson(i)).toList() : null,
      replies: json['replies'] != null ? (json['replies'] as List).map((i) => User.fromJson(i)).toList() : null,
      self: json['self'] != null ? (json['self'] as List).map((i) => User.fromJson(i)).toList() : null,
      versionHistory: json['version-history'] != null ? (json['version-history'] as List).map((i) => User.fromJson(i)).toList() : null,
      wpAttachment: json['wp:attachment'] != null ? (json['wp:attachment'] as List).map((i) => User.fromJson(i)).toList() : null,
      wpFeaturedMedia: json['wp:featuredmedia'] != null ? (json['wp:featuredmedia'] as List).map((i) => User.fromJson(i)).toList() : null,
      wpTerm: json['wp:term'] != null ? (json['wp:term'] as List).map((i) => User.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.about != null) {
      data['about'] = this.about!.map((v) => v.toJson()).toList();
    }
    if (this.author != null) {
      data['author'] = this.author!.map((v) => v.toJson()).toList();
    }
    if (this.collection != null) {
      data['collection'] = this.collection!.map((v) => v.toJson()).toList();
    }
    if (this.curies != null) {
      data['curies'] = this.curies!.map((v) => v.toJson()).toList();
    }
    if (this.predecessorVersion != null) {
      data['predecessor-version'] = this.predecessorVersion!.map((v) => v.toJson()).toList();
    }
    if (this.replies != null) {
      data['replies'] = this.replies!.map((v) => v.toJson()).toList();
    }
    if (this.self != null) {
      data['self'] = this.self!.map((v) => v.toJson()).toList();
    }
    if (this.versionHistory != null) {
      data['version-history'] = this.versionHistory!.map((v) => v.toJson()).toList();
    }
    if (this.wpAttachment != null) {
      data['wp:attachment'] = this.wpAttachment!.map((v) => v.toJson()).toList();
    }
    if (this.wpFeaturedMedia != null) {
      data['wp:featuredmedia'] = this.wpFeaturedMedia!.map((v) => v.toJson()).toList();
    }
    if (this.wpTerm != null) {
      data['wp:term'] = this.wpTerm!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  int? bbp_anonymous_reply_count;
  int? bbp_forum_subforum_count;
  int? bbp_reply_count;
  int? bbp_reply_count_hidden;
  int? bbp_topic_count;
  int? bbp_topic_count_hidden;
  int? bbp_total_reply_count;
  int? bbp_total_topic_count;
  int? bbp_voice_count;

  Meta(
      {this.bbp_anonymous_reply_count,
      this.bbp_forum_subforum_count,
      this.bbp_reply_count,
      this.bbp_reply_count_hidden,
      this.bbp_topic_count,
      this.bbp_topic_count_hidden,
      this.bbp_total_reply_count,
      this.bbp_total_topic_count,
      this.bbp_voice_count});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      bbp_anonymous_reply_count: json['_bbp_anonymous_reply_count'],
      bbp_forum_subforum_count: json['_bbp_forum_subforum_count'],
      bbp_reply_count: json['_bbp_reply_count'],
      bbp_reply_count_hidden: json['_bbp_reply_count_hidden'],
      bbp_topic_count: json['_bbp_topic_count'],
      bbp_topic_count_hidden: json['_bbp_topic_count_hidden'],
      bbp_total_reply_count: json['_bbp_total_reply_count'],
      bbp_total_topic_count: json['_bbp_total_topic_count'],
      bbp_voice_count: json['_bbp_voice_count'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_bbp_anonymous_reply_count'] = this.bbp_anonymous_reply_count;
    data['_bbp_forum_subforum_count'] = this.bbp_forum_subforum_count;
    data['_bbp_reply_count'] = this.bbp_reply_count;
    data['_bbp_reply_count_hidden'] = this.bbp_reply_count_hidden;
    data['_bbp_topic_count'] = this.bbp_topic_count;
    data['_bbp_topic_count_hidden'] = this.bbp_topic_count_hidden;
    data['_bbp_total_reply_count'] = this.bbp_total_reply_count;
    data['_bbp_total_topic_count'] = this.bbp_total_topic_count;
    data['_bbp_voice_count'] = this.bbp_voice_count;
    return data;
  }
}
