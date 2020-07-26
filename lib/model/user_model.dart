class UserModel {
  String userName;
  String userEmail;
  String uuid;

  UserModel({
    this.uuid,
    this.userName,
    this.userEmail,
  });

  String getUserEmail() => userEmail;
  String getUuid() => uuid;
  String getUserName() => userName;
}
