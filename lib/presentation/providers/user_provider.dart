
import 'dart:typed_data';

import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _uid;
  String? _user;
  String? _ageUser;
  String? _numberPain;
  String? _patientUid;
  Uint8List? _patientPainScaleImage;

  String? get getUid => _uid;
  String? get getUser => _user;
  String? get getAgeUser => _ageUser;
  String? get getNumberPain => _numberPain;
  String? get getPatientId => _patientUid;
  Uint8List? get getPatientPainScaleImage => _patientPainScaleImage;

  void setUid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  void setPatientPainScaleImage(Uint8List patientPainScaleImage) {
    _patientPainScaleImage = patientPainScaleImage;
    notifyListeners();
  }

  void setUser(String user) {
    _user = user;
    notifyListeners();
  }

  void setPatientId(String patientId) {
    _patientUid = patientId;
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
    _patientPainScaleImage = null;
    notifyListeners();
  }
}