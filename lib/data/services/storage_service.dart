import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(
      Uint8List imageData, String userId, String patientId) async {
    try {
      String filePath = '$userId/$patientId/pain_scale_${DateTime.now().millisecondsSinceEpoch}.png';
      Reference ref = _storage.ref().child(filePath);
      await ref.putData(imageData);
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error al subir la imagen a Firebase Storage: $e');
      return null;
    }
  }
}
