
import 'package:flutter/material.dart';

class WaveProvider extends ChangeNotifier {
  // Estado booleano privado
  bool _isActive = false;

  // Getter para exponer el estado
  bool get isActive => _isActive;

  // Setter para cambiar el estado y notificar listeners
  void setActive(bool value) {
    if (_isActive != value) {
      _isActive = value;
      notifyListeners();
    }
  }
}
