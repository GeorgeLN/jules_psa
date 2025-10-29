
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _user;
  String? _ageUser;
  String? _numberPain;
  String? _userDocumentId;
  String? _patientId;

  String? get getUser => _user;
  String? get getAgeUser => _ageUser;
  String? get getNumberPain => _numberPain;
  String? get getUserDocumentId => _userDocumentId;
  String? get getPatientId => _patientId;

  void setUser(String user) {
    _user = user;
    notifyListeners();
  }

  void setUserDocumentId(String userDocumentId) {
    _userDocumentId = userDocumentId;
    notifyListeners();
  }

  void setPatientId(String patientId) {
    _patientId = patientId;
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