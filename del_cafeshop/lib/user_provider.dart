import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int? _userId;
  String? _token;
  String? _name;

  int? get userId => _userId;
  String? get token => _token;
  String? get name => _name;

  void setUser({required int userId, required String token,  required String name,}) {
    _userId = userId;
    _token = token;
    _name = name;
    notifyListeners();
  }

void clearUser() {
    _userId = null;
    _token = null;
    _name = null;
    notifyListeners();
  }
}
