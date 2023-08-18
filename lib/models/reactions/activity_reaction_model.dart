class ActivityReactionModel {
  int? isReacted;
  int? isRemoved;

  ActivityReactionModel({this.isReacted, this.isRemoved});

  factory ActivityReactionModel.fromJson(Map<String, dynamic> json) {
    return ActivityReactionModel(
      isReacted: json['is_reacted'],
      isRemoved: json['is_removed'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_reacted'] = this.isReacted;
    data['is_removed'] = this.isRemoved;

    return data;
  }
}