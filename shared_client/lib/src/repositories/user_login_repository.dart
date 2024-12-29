import 'dart:convert';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';
import 'package:shared_client/src/repositories/repository.dart';
import 'package:http/http.dart' as http;

class UserLoginRepository extends Repository<UserLogin> {
  static final UserLoginRepository _instance =
      UserLoginRepository._internal(path: 'login');

  UserLoginRepository._internal({required super.path});

  factory UserLoginRepository() => _instance;

  @override
  Future<String?> addToList({required UserLogin item}) async {
    Uri updatedUri = uri.replace(path: '/api/login/add');
    try {
      final response = await http.post(updatedUri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(serialize(item)));
      if (response.statusCode == 200) {
        return "success";
      } else {
        var body = jsonDecode(response.body);
        // printError('${body['message']}');
        return null;
      }
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  Future<Owner?> canUserLogin({required UserLogin user}) async {
    Uri updatedUri = uri.replace(path: '/api/login');
    try {
      final response = await http.post(
        updatedUri,
        body: jsonEncode(serialize(user)),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return OwnerRepository().deserialize(json);
      }
      return null;
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  @override
  UserLogin deserialize(Map<String, dynamic> json) => UserLogin.fromJson(json);

  @override
  Map<String, dynamic> serialize(UserLogin item) => item.toJson();
}
