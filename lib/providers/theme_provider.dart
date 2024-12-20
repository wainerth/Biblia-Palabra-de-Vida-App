import 'package:flutter/material.dart';

import 'package:biblia_palabra_de_vida_app/themes/appTheme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = themes.first.toThemeData();
  String _themeName = themes.first.name;

  ThemeData get currentTheme => _currentTheme;
  String get themeName => _themeName;

  void setTheme(AppTheme theme) {
    _currentTheme = theme.toThemeData();
    _themeName = theme.name;
    notifyListeners();
  }
}
