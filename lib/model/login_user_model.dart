class LoginUserModel {
  String? name;
  String? mail;
  String? password;

  LoginUserModel({this.name, this.mail, this.password});

  LoginUserModel.fromJson(Map<String, dynamic> json) {
    name = json['FirstName'];
    mail = json['Email'];
    password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FirstName'] = this.name;
    data['Email'] = this.mail;
    data['Password'] = this.password;
    return data;
  }
}