
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImagenProvider with ChangeNotifier {
  Uint8List? _imagen;

  Uint8List? get imagen => _imagen;

  void setImagen(Uint8List imagen) {
    _imagen = imagen;
    notifyListeners();
  }
}