// bible_theme_provider.dart
import 'dart:convert';

import 'package:biblia_palabra_de_vida_app/models/custom_theme_model.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BibleThemeProvider with ChangeNotifier {
  BibleThemeType _currentTheme = BibleThemeType.light;
  List<CustomTheme> _customThemes = [];
  bool _isCustomTheme = false;
  CustomTheme? _currentCustomTheme;

  BibleThemeType get currentTheme => _currentTheme;
  List<CustomTheme> get customThemes => _customThemes;
  bool get isCustomTheme => _isCustomTheme;
  CustomTheme? get currentCustomTheme => _currentCustomTheme;

  // BibleTheme get themeData => BibleTheme.themes[_currentTheme]!;
  BibleTheme get themeData {
    if (_isCustomTheme && _currentCustomTheme != null) {
      return BibleTheme(
        name: _currentCustomTheme!.name,
        backgroundColor: _currentCustomTheme!.backgroundColor,
        disabledColor: StyleColor.grayMedium,
        textColor: _currentCustomTheme!.textColor,
        appBarColor: _currentCustomTheme!.appBarColor,
        buttonColor: _currentCustomTheme!.buttonColor,
        buttonTextColor: _currentCustomTheme!.buttonTextColor,
        verseHighlightColor: _currentCustomTheme!.verseHighlightColor,
      );
    }
    return BibleTheme.themes[_currentTheme]!;
  }

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();

    // cargar tema Predeterminado
    final savedThemeIndex = prefs.getInt('saved_bible_theme') ?? 0;
    _currentTheme = BibleThemeType.values[savedThemeIndex];

    // Cargar temas personalizados
    final customThemeJson = prefs.getStringList('custom_themes') ?? [];
    _customThemes = customThemeJson
        .map((theme) => CustomTheme.fromJson(jsonDecode(theme)))
        .toList();

    // cargar tema personalizado actual  si existe
    final currentCustomThemeJson = prefs.getString('current_custom_theme');
    if (currentCustomThemeJson != null) {
      _currentCustomTheme =
          CustomTheme.fromJson(jsonDecode(currentCustomThemeJson));
      _isCustomTheme = true;
    }

    notifyListeners();
  }

  void changeTheme(BibleThemeType newTheme) async {
    _currentTheme = newTheme;
    _isCustomTheme = false;
    _currentCustomTheme = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('saved_bible_theme', newTheme.index);
    prefs.remove('current_custom_theme');

    notifyListeners();
  }

  Future<void> addCustomTheme(CustomTheme newTheme) async {
    _customThemes.add(newTheme);
    await _saveCustomThemes();

    notifyListeners();
  }

  Future<void> applyCustomTheme(CustomTheme theme) async {
    _currentCustomTheme = theme;
    _isCustomTheme = true;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('current_custom_theme', jsonEncode(theme.toJson()));

    notifyListeners();
  }

  Future<void> removeCustomTheme(String id) async {
    _customThemes.removeWhere((theme) => theme.id == id);

    if (_isCustomTheme && _currentCustomTheme?.id == id) {
      _isCustomTheme = false;
      _currentCustomTheme = null;
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('current_custom_theme');
    }

    await _saveCustomThemes();
    notifyListeners();
  }

  Future<void> _saveCustomThemes() async {
    final prefs = await SharedPreferences.getInstance();
    final customThemeJson =
        _customThemes.map((theme) => jsonEncode(theme.toJson())).toList();

    prefs.setStringList('custom_themes', customThemeJson);
  }
}
