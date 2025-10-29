import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/repositories/storage_repository.dart';

class StorageViewModel extends ChangeNotifier {
  final StorageRepository _storageRepository = StorageRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> uploadImage(String userDocument) async {
    if (_selectedImage == null) return;

    _isLoading = true;
    notifyListeners();

    _imageUrl = await _storageRepository.uploadImage(_selectedImage!, userDocument);

    _isLoading = false;
    notifyListeners();
  }
}
