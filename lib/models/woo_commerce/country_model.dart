import '../common_models/links.dart';

class CountryModel {
  Links? links;
  String? code;
  String? name;
  List<StateModel>? states;

  CountryModel({this.links, this.code, this.name, this.states});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
      code: json['code'],
      name: json['name'],
      states: json['states'] != null ? (json['states'] as List).map((i) => StateModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    if (this.links != null) {
      data['_links'] = this.links!.toJson();
    }
    if (this.states != null) {
      data['states'] = this.states!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StateModel {
  String? code;
  String? name;

  StateModel({this.code, this.name});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      code: json['code'].toString(),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}
