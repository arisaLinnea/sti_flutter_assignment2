import 'package:flutter/material.dart';
import 'package:parking_user/utils/utils.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

enum AuthStatus { unauthorized, loading, authenticated }

enum RegStatus { ok, loading }

class AuthState extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unauthorized;
  RegStatus _regStatus = RegStatus.ok;
  RegStatus get regStatus => _regStatus;
  AuthStatus get status => _status;

  Owner? _loggedInUser;
  Owner? get userInfo => _loggedInUser;

  Future<void> login({
    required email,
    required password,
    required context,
  }) async {
    _status = AuthStatus.loading;
    notifyListeners();

    var data = UserLogin(userName: email, pwd: password);
    try {
      Owner? loginUser = await UserLoginRepository().canUserLogin(user: data);
      if (loginUser != null) {
        _loggedInUser = loginUser;
        _status = AuthStatus.authenticated;
        Utils.toastMessage('Login Successful');
      } else {
        _status = AuthStatus.unauthorized;
        Utils.toastMessage('Login Failed');
      }
    } catch (e) {
      _status = AuthStatus.unauthorized;
      Utils.toastMessage('Login Failed');
    }
    notifyListeners();
  }

  Future<bool> register({
    required name,
    required ssn,
    required userName,
    required pwd,
  }) async {
    _regStatus = RegStatus.loading;
    notifyListeners();
    try {
      Owner newOwner = Owner(name: name, ssn: ssn);
      String? uuid = await OwnerRepository().addToList(item: newOwner);
      if (uuid != null) {
        UserLogin newLoginUser =
            UserLogin(ownerId: uuid, userName: userName, pwd: pwd);
        String? response =
            await UserLoginRepository().addToList(item: newLoginUser);
        if (response != null) {
          Utils.toastMessage('Account successfully created');
          _regStatus = RegStatus.ok;
          return true;
        } else {
          Utils.toastMessage('Failed to add account');
        }
      } else {
        Utils.toastMessage('Failed to add account');
      }
    } catch (e) {
      Utils.toastMessage('Failed to add account');
    }

    _regStatus = RegStatus.ok;
    notifyListeners();
    return false;
  }

  void logout() {
    _status = AuthStatus.unauthorized;
    notifyListeners();
  }
}
