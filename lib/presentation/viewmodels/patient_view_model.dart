
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

  Future<bool> updatePatientImage({
    required String userDocumentId,
    required String patientId,
    required String imageUrl,
  }) async {
    try {
      _setState(ViewState.loading);

      // Obtener el paciente
      PatientModel? patient = await _userRepository.getPatient(patientId);

      if (patient != null) {
        // Actualizar la URL de la imagen
        PatientModel updatedPatient = PatientModel(
          uid: patient.uid,
          nombre: patient.nombre,
          edad: patient.edad,
          imagen: imageUrl,
        );

        // Actualizar el paciente en la colección de pacientes
        await _userRepository.updatePatient(updatedPatient);

        // Actualizar el paciente en la lista de pacientes del usuario
        UserModel? user = await _userRepository.getUser(userDocumentId);

        if (user != null) {
          // Encontrar el paciente en la lista y actualizarlo
          for (int i = 0; i < user.pacientes.length; i++) {
            if (user.pacientes[i].uid == patientId) {
              user.pacientes[i] = updatedPatient;
              break;
            }
          }

          // Actualizar el usuario
          await _userRepository.updateUser(user);
        }
      }

      _setState(ViewState.success);
      return true;
    } catch (e) {
      _setState(ViewState.error);
      return false;
    }
  }
}
