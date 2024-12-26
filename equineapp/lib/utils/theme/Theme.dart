import 'package:flutter/material.dart';

enum ThemeModeType { light, dark }

class ThemeProviderNotifier extends ChangeNotifier {
  ThemeModeType _themeMode = ThemeModeType.light;

  ThemeModeType get themeMode => _themeMode;

  void toggleThemeMode() {
    _themeMode = (_themeMode == ThemeModeType.light)
        ? ThemeModeType.dark
        : ThemeModeType.light;
    notifyListeners();
  }

  ThemeData getThemeData() {
    return (_themeMode == ThemeModeType.light) ? _lightTheme : _darkTheme;
  }
}

final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  // Add other light theme configurations here
);

final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  // Add other dark theme configurations here
);
