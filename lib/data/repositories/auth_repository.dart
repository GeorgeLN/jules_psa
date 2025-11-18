
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pain_scale_app/data/models/user_model.dart';

// class ProfileData {
//   final UserModel basicInfo;

//   ProfileData({required this.basicInfo});
// }

class AuthRepository {  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthException(e.code));
    } catch (e) {
      throw Exception("Ocurrió un error inesperado: ${e.toString()}");
    }
  }

  Future<User?> registrarUsuario(
      String email,
      String password,
      String name
    ) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        final userModel = UserModel(
          uid: user.uid,
          correo: email,
          nombre: name,
          pacientes: [],
        );

        try {
          await _firestore.collection('usuarios').doc(user.uid).set(userModel.toJson());
          //await _storage.ref().child(user.uid).child('.placeholder').putString('');
        } catch (e) {
          // ignore: avoid_print
          print('Error saving user data or creating storage folder: $e');
        }
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthException(e.code));
    } catch (e) {
      throw Exception("Ocurrió un error inesperado: ${e.toString()}");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _mapFirebaseAuthException(String code) {
    switch (code) {
      case 'weak-password':
        return 'La contraseña proporcionada es demasiado débil.';
      case 'email-already-in-use':
        return 'La cuenta ya existe para ese correo electrónico.';
      case 'user-not-found':
        return 'No se encontró usuario para ese correo electrónico.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'invalid-email':
        return 'El formato del correo electrónico no es válido.';
      case 'user-disabled':
        return 'Este usuario ha sido deshabilitado.';
      default:
        return 'Ocurrió un error de autenticación.';
    }
  }
}
