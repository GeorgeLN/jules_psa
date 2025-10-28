
class UserModel {
  final String id;
  final String name;
  final int edad;

  UserModel({
    required this.id,
    required this.name,
    required this.edad,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      edad: json['edad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'edad': edad,
    };
  }
}