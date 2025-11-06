
import 'package:flutter/material.dart';
import 'package:pain_scale_app/data/models/patient_model.dart';
import 'package:pain_scale_app/data/repositories/user_repository.dart';

enum ViewState { idle, loading, success, error }

class PatientViewModel extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  Future<bool> addPatient({
    required String userDocumentId,
    required String patientName,
    required String patientAge,
  }) async {
    try {
      _setState(ViewState.loading);

      // Create a new patient
      PatientModel newPatient = PatientModel(
        uid: '', // Firestore will generate this
        nombre: patientName,
        edad: patientAge,
        imagen: '', // This will be updated later
      );

      // Add the patient to the "pacientes" collection and get the new patient's ID
      final patientId = await _userRepository.addPatientAndGetId(newPatient);

      // Update the new patient with its own ID
      newPatient = PatientModel(
        uid: patientId,
        nombre: newPatient.nombre,
        edad: newPatient.edad,
        imagen: newPatient.imagen,
      );
      await _userRepository.updatePatient(newPatient);

      // Add the patient to the user's "pacientes" map
      await _userRepository.addPatientToUser(userDocumentId, newPatient);

      _setState(ViewState.success);
      return true;
    } catch (e) {
      _setState(ViewState.error);
      return false;
    }
  }
}
