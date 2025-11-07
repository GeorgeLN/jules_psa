
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(File image, String userDocumentId) async {
    try {
      final String imagePath = '$userDocumentId/${DateTime.now()}.png';
      final Reference storageReference = _storage.ref().child(imagePath);
      final UploadTask uploadTask = storageReference.putFile(image);
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      // ignore: avoid_print
      print('Error al subir la imagen: $e');
      return null;
    }
  }

  Future<void> deletePatientImage(String imageUrl) async {
    try {
      final Reference storageReference = _storage.refFromURL(imageUrl);
      await storageReference.delete();
    } catch (e) {
      // ignore: avoid_print
      print('Error al eliminar la imagen: $e');
      rethrow;
    }
  }

  Future<String?> uploadPatientImageData(
      Uint8List imageData, String userId, String patientId) async {
    try {
      String filePath =
          '$userId/$patientId/pain_scale_${DateTime.now().millisecondsSinceEpoch}.png';
      Reference ref = _storage.ref().child(filePath);
      await ref.putData(imageData);
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      // ignore: avoid_print
      print('Error al subir la imagen a Firebase Storage: $e');
      return null;
    }
  }
}
