import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_server/models/user_login.dart';
import 'package:dart_server/repositories/file_repository.dart';
import 'package:shared/shared.dart';

class LoginRepository with FileRepository {
  static final LoginRepository _instance = LoginRepository._internal();

  LoginRepository._internal() {
    File file = File(filePath);
    if (!file.existsSync()) {
      print('Create storage file');
      file.createSync(
          recursive: true); //recursive: true creates the directory too
    }
  }
  final String _storageName = 'login_users';
  final String _filePath = 'db/fileStorage.json';

  factory LoginRepository() => _instance;

  Future<String?> checkLogin({required dynamic json}) async {
    UserLogin userLogin = deserialize(json);
    File file = File(_filePath);
    var serverData = await super.getServerList(file: file, name: _storageName);
    List<dynamic> serverList = serverData['list'];
    List<UserLogin> userLoginList = await Future.wait(
        serverList.map((json) => UserLoginFactory.fromServerJson(json)));

    UserLogin? foundUser = userLoginList.firstWhereOrNull((user) =>
        user.userName == userLogin.userName && user.pwd == userLogin.pwd);

    if (foundUser != null) {
      return foundUser.ownerId;
    } else {
      return null;
    }
  }

  Future<String?> addToList({required dynamic json}) async {
    try {
      UserLogin user = deserialize(json);
      File file = File(super.filePath);

      var {'list': serverList, 'map': jsonmap} =
          await super.getServerList(file: file, name: _storageName);

      if (serverList == null || jsonmap == null) {
        throw StateError('Server list or map is null');
      }

      final int initialLength = serverList.length;
      Map<String, dynamic> newUser = UserLoginFactory.toServerJson(user);
      serverList.add(newUser);

      if (serverList.length == initialLength) {
        return null;
      }

      jsonmap[_storageName] = serverList;
      await file.writeAsString(jsonEncode(jsonmap));
      return newUser['ownerId'];
    } catch (e) {
      rethrow;
    }
  }

  String itemAsString() {
    return 'Login';
  }

  @override
  UserLogin deserialize(Map<String, dynamic> json) => UserLogin.fromJson(json);
}
