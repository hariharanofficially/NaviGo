class LoginModel {
  final String userName;
  final String password;
  String loginName = "";
  String loginType = "";
  String profileUrl = "";

  LoginModel({
    required this.userName,
    required this.password,
  });

  factory LoginModel.initObject() {
    return LoginModel(
        userName : "",
        password: "");
  }
  Map<String, String> toMap() {
    return {
      "userName" : this.userName,
      "password" : this.password
    };
  }
}
