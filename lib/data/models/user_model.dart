import 'package:app/data/models/patient_model.dart';

class UserModel {
  final String correo;
  final String nombre;
  final String documento;
  final Map<String, PatientModel> pacientes;

  UserModel({
    required this.correo,
    required this.nombre,
    required this.documento,
    required this.pacientes,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      correo: json['correo'],
      nombre: json['nombre'],
      documento: json['documento'],
      pacientes: (json['pacientes'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, PatientModel.fromJson(value)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'correo': correo,
      'nombre': nombre,
      'documento': documento,
      'pacientes': pacientes.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
    };
  }
}
