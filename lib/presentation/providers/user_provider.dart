
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pain_scale_app/data/models/user_model.dart';

class UserProvider with ChangeNotifier {
  String? _uid;
  String? _userDocumentId;
  UserModel? _userModel;
  String? _ageUser;
  String? _numberPain;
  String? _patientUid;
  Uint8List? _patientPainScaleImage;

  String? get getUid => _uid;
  String? get getUserDocumentId => _userDocumentId;
  UserModel? get getUserModel => _userModel;
  String? get getAgeUser => _ageUser;
  String? get getNumberPain => _numberPain;
  String? get getPatientId => _patientUid;
  Uint8List? get getPatientPainScaleImage => _patientPainScaleImage;

  void setUid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  void setUserModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  void setPatientPainScaleImage(Uint8List patientPainScaleImage) {
    _patientPainScaleImage = patientPainScaleImage;
    notifyListeners();
  }

  void setUserDocumentId(String user) {
    _userDocumentId = user;
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
    _userDocumentId = null;
    _userModel = null;
    _numberPain = null;
    _patientPainScaleImage = null;
    notifyListeners();
  }
}