
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pain_scale_app/data/models/patient_model.dart';
import 'package:pain_scale_app/data/models/user_model.dart';

class UserProvider with ChangeNotifier {
  String? _uid;
  UserModel? _userModel;
  PatientModel? _patientModel;
  String? _ageUser;
  String? _numberPain;
  String? _patientUid;
  String? _patientName;
  Uint8List? _patientPainScaleImage;
  
  String? get getUid => _uid;
  UserModel? get getUserModel => _userModel;
  PatientModel? get getPatientModel => _patientModel;
  String? get getAgeUser => _ageUser;
  String? get getNumberPain => _numberPain;
  String? get getPatientId => _patientUid;
  String? get getPatientName => _patientName;
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
    _uid = user;
    notifyListeners();
  }

  void setPatientId(String patientId) {
    _patientUid = patientId;
    notifyListeners();
  }

  void setPatientName(String patientId) {
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
    _uid = null;
    notifyListeners();
  }
}