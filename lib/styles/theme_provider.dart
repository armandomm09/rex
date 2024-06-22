import 'package:chat_app/styles/dark_mode.dart';
import 'package:chat_app/styles/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = darkMode;
  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
  if (_themeData == lightMode) {
    themeData = darkMode; // Aquí usamos el setter para notificar a los listeners
  } else {
    themeData = lightMode; // Aquí también
  }
}

}
