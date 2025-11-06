
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pain_scale_app/data/models/patient_model.dart';

class UserModel {
  final String uid;
  final String correo;
  final String nombre;
  final List<PatientModel> pacientes;

  UserModel({
    required this.uid,
    required this.correo,
    required this.nombre,
    required this.pacientes,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var pacientes = json['pacientes'];
    List<PatientModel> listaPacientes = [];

    if (pacientes is Map<String, dynamic>) {
      listaPacientes = pacientes.values.map((patientJson) {
        return PatientModel.fromJson(patientJson as Map<String, dynamic>);
      }).toList();
    } else if (pacientes is List) {
      listaPacientes = pacientes.where((patientJson) {
        return patientJson is Map<String, dynamic>;
      }).map((patientJson) {
        return PatientModel.fromJson(patientJson as Map<String, dynamic>);
      }).toList();
    }

    return UserModel(
      uid: json['uid'] as String,
      correo: json['correo'],
      nombre: json['nombre'],
      pacientes: listaPacientes,
    );
  }

    factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final user = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);

    return UserModel(
      uid: snapshot.id,
      correo: user.correo,
      nombre: user.nombre,
      pacientes: user.pacientes,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> pacientesMap = {};
    for (int i = 0; i < pacientes.length; i++) {
      pacientesMap['paciente_$i'] = pacientes[i].toJson();
    }

    return {
      'uid': uid,
      'correo': correo,
      'nombre': nombre,
      'pacientes': pacientesMap,
    };
  }
}
