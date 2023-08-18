class RegisterUserModel {
  List<String>? message;

  RegisterUserModel({this.message});

  factory RegisterUserModel.fromJson(Map<String, dynamic> json) {
    return RegisterUserModel(
      message: json['message'] != null ? new List<String>.from(json['message']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message;
    }
    return data;
  }
}
