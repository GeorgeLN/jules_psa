
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _user;
  String? _ageUser;
  String? _numberPain;

  String? get getUser => _user;
  String? get getAgeUser => _ageUser;
  String? get getNumberPain => _numberPain;

  void setUser(String user) {
    _user = user;
    notifyListeners();
  }

  void setNumberPain(String numberPain) {
    _numberPain = numberPain;
    notifyListeners();
  }

  void setAgeUser(String ageUser) {
    _ageUser = ageUser;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _numberPain = null;
    notifyListeners();
  }
}