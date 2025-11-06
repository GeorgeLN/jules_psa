
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pain_scale_app/data/models/patient_model.dart';
import 'package:pain_scale_app/data/models/user_model.dart';

class UserRepository {
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('usuarios');
  final CollectionReference _patientsCollection = FirebaseFirestore.instance.collection('pacientes');

  // USUARIOS
  Future<void> addUser(UserModel userData) async {
    await _usersCollection.add(userData.toJson());
  }

  Future<List<UserModel>> fetchUsers() async {
    QuerySnapshot snapshot = await _usersCollection.get();
    return snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
  }

  Future<void> updateUser(UserModel userData) async {
    await _usersCollection.doc(userData.uid).update(userData.toJson());
  }

  Future<void> deleteUser(String id) async {
    await _usersCollection.doc(id).delete();
  }

  // PACIENTES
  Future<void> addPatient(PatientModel patientData) async {
    await _patientsCollection.add(patientData.toJson());
  }

  Future<List<PatientModel>> fetchPatients() async {
    QuerySnapshot snapshot = await _patientsCollection.get();
    return snapshot.docs.map((doc) => PatientModel.fromSnapshot(doc)).toList();
  }

  Future<void> updatePatient(PatientModel patientData) async {
    await _patientsCollection.doc(patientData.uid).update(patientData.toJson());
  }

  Future<void> deletePatient(String id) async {
    await _patientsCollection.doc(id).delete();
  }
}