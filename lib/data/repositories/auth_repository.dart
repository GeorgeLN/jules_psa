
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pain_scale_app/data/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('Failed to sign in with email and password: ${e.message}');
      return null;
    }
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password, String name, String document) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        final userModel = UserModel(
          correo: email,
          nombre: name,
          documento: document,
          pacientes: {},
        );

        await _firestore
            .collection('Usuarios')
            .doc(document)
            .set(userModel.toJson());

        await _storage.ref().child(document).child('.placeholder').putString('');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('Failed to create user with email and password: ${e.message}');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
