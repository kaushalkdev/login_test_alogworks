class UserModel {
  String userName;
  String userEmail;
  String uuid;
  bool isLogin;

  UserModel({
    this.uuid,
    this.userName,
    this.userEmail,
    this.isLogin,
  });

  String getUserEmail() => userEmail;
  String getUuid() => uuid;
  String getUserName() => userName;
  bool getisLogin() => isLogin;
}
