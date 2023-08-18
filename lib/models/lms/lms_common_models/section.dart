class Section {
  int? course_id;
  String? description;
  int? id;
  List<SectionItem>? items;
  String? order;
  var percent;
  String? title;

  Section({this.course_id, this.description, this.id, this.items, this.order, this.percent, this.title});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      course_id: json['course_id'],
      description: json['description'],
      id: json['id'],
      items: json['items'] != null ? (json['items'] as List).map((i) => SectionItem.fromJson(i)).toList() : null,
      order: json['order'],
      percent: json['percent'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course_id'] = this.course_id;
    data['description'] = this.description;
    data['id'] = this.id;
    data['order'] = this.order;
    data['percent'] = this.percent;
    data['title'] = this.title;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SectionItem {
  String? duration;
  String? graduation;
  int? id;
  bool? locked;
  bool? preview;
  String? status;
  String? title;
  String? type;

  SectionItem({this.duration, this.graduation, this.id, this.locked, this.preview, this.status, this.title, this.type});

  factory SectionItem.fromJson(Map<String, dynamic> json) {
    return SectionItem(
      duration: json['duration'],
      graduation: json['graduation'],
      id: json['id'],
      locked: json['locked'],
      preview: json['preview'],
      status: json['status'],
      title: json['title'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['graduation'] = this.graduation;
    data['id'] = this.id;
    data['locked'] = this.locked;
    data['preview'] = this.preview;
    data['status'] = this.status;
    data['title'] = this.title;
    data['type'] = this.type;
    return data;
  }
}
