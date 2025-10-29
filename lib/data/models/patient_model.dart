
class PatientModel {
  final String nombre;
  final String edad;
  final String imagen;

  PatientModel({
    required this.nombre,
    required this.edad,
    required this.imagen,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      nombre: json['nombre'],
      edad: json['edad'],
      imagen: json['imagen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'edad': edad,
      'imagen': imagen,
    };
  }
}
