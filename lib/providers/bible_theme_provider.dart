// bible_theme_provider.dart
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BibleThemeProvider with ChangeNotifier {
  BibleThemeType _currentTheme = BibleThemeType.light;

  BibleThemeType get currentTheme => _currentTheme;
  BibleTheme get themeData => BibleTheme.themes[_currentTheme]!;

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeIndex = prefs.getInt('saved_bible_theme') ?? 0;
    _currentTheme = BibleThemeType.values[savedThemeIndex];
    notifyListeners();
  }

  void changeTheme(BibleThemeType newTheme) async {
    _currentTheme = newTheme;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('saved_bible_theme', newTheme.index);
    notifyListeners();
  }
}
