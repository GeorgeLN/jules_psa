
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientModel {
  final String nombre;
  final String edad;
  final String imagen;
  final String uid;
  final String? dolorGeneral;

  PatientModel({
    required this.nombre,
    required this.edad,
    required this.imagen,
    required this.uid,
    this.dolorGeneral,
  });

  factory PatientModel.fromSnapshot(DocumentSnapshot snapshot) {
    final patient =
        PatientModel.fromJson(snapshot.data() as Map<String, dynamic>);

    return PatientModel(
      uid: snapshot.id,
      nombre: patient.nombre,
      edad: patient.edad,
      imagen: patient.imagen,
      dolorGeneral: patient.dolorGeneral,
    );
  }

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      uid: json['uid'] as String,
      nombre: json['nombre'],
      edad: json['edad'],
      imagen: json['imagen'],
      dolorGeneral: json['dolorGeneral'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nombre': nombre,
      'edad': edad,
      'imagen': imagen,
      'dolorGeneral': dolorGeneral,
    };
  }
}
