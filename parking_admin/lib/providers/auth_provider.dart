import 'package:flutter/material.dart';

enum AuthStatus { unauthorized, loading, authenticated }

class AuthState extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unauthorized;
  AuthStatus get status => _status;

  Future<void> login() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      _status = AuthStatus.authenticated;
    } catch (e) {
      _status = AuthStatus.unauthorized;
    }
    notifyListeners();
  }

  void logout() {
    _status = AuthStatus.unauthorized;
    notifyListeners();
  }
}
