import 'package:shared/shared.dart';

class UserLoginFactory {
  static Future<UserLogin> fromServerJson(Map<String, dynamic> json) async {
    return UserLogin(
      ownerId: json['ownerId'],
      userName: json['userName'],
      pwd: json['pwd'],
    );
  }

  static Map<String, dynamic> toServerJson(UserLogin userLogin) {
    return {
      'ownerId': userLogin.ownerId,
      'userName': userLogin.userName,
      'pwd': userLogin.pwd
    };
  }
}
