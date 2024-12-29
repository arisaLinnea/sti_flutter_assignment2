class UserLogin {
  String? ownerId;
  String userName;
  String pwd;

  UserLogin({this.ownerId, required this.userName, required this.pwd});

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      ownerId: json['ownerId'] ?? "",
      userName: json['userName'],
      pwd: json['pwd'],
    );
  }

  Map<String, dynamic> toJson() => {
        'ownerId': ownerId,
        'userName': userName,
        'pwd': pwd,
      };
}
