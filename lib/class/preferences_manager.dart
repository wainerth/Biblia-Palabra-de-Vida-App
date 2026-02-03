import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';

class PreferencesManager {
  static final PreferencesManager _instance = PreferencesManager._internal();
  factory PreferencesManager() => _instance;
  PreferencesManager._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Método privado para verificar initialization
  Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      await init();
    }
  }

  // Keys para las preferencias
  static const _userTokenKey = 'userToken';
  static const _savedBibleThemeKey = 'saved_bible_theme';
  static const _currentCustomThemeKey = 'current_custom_theme';
  static const _customThemesKey = 'custom_themes';
  static const _userDataKey = 'userData';
  static const _ttsSpeechRateKey = 'tts_speech_rate';
  static const _isMutedKey = 'isMuted';
  static const _isBackgroundPlayingKey = 'isBackgroundPlaying';
  static const _hasSeenIntroKey = 'hasSeenIntro';
  static const String _selectedBibleVersionKey = 'selectedBibleVersion';
  static const String _bookSelectedKey = 'bookSelected';
  static const String _chapterSelectedKey = 'chapterSelected';
  static const String _fontSizeVerseKey = 'fontSizeVerse';
  static const String _fontSizeQuestionKey = 'fontSizeQuestion';
  static const String _fontFamilySetKey = 'fontFamilySet';
  static const String _deviceInfoKey = 'deviceInfo';
  static const String _lastPlayDateKey = 'last_play_date';

  // Métodos para userToken
  Future<String?> getUserToken() async {
    await _ensureInitialized();
    return _prefs!.getString(_userTokenKey);
  }

  Future<void> setUserToken(String token) async {
    await _ensureInitialized();
    await _prefs!.setString(_userTokenKey, token);
  }

  Future<void> clearUserToken() async {
    await _ensureInitialized();
    await _prefs!.remove(_userTokenKey);
  }

  // Métodos para temas de la Biblia
  Future<int> getSavedBibleTheme() async {
    await _ensureInitialized();
    return _prefs!.getInt(_savedBibleThemeKey) ?? 0;
  }

  Future<void> setSavedBibleTheme(int themeIndex) async {
    await _ensureInitialized();
    await _prefs!.setInt(_savedBibleThemeKey, themeIndex);
  }

// Selected Bible Version
  Future<String?> getSelectedBibleVersion() async {
    await _ensureInitialized();
    return _prefs!.getString(_selectedBibleVersionKey);
  }

  Future<void> setSelectedBibleVersion(String version) async {
    await _ensureInitialized();
    await _prefs!.setString(_selectedBibleVersionKey, version);
  }

  // Selected Book
  Future<String?> getBookSelected() async {
    await _ensureInitialized();
    return _prefs!.getString(_bookSelectedKey);
  }

  Future<void> setBookSelected(String book) async {
    await _ensureInitialized();
    await _prefs!.setString(_bookSelectedKey, book);
  }

  // Selected Chapter
  Future<String?> getChapterSelected() async {
    await _ensureInitialized();
    return _prefs!.getString(_chapterSelectedKey);
  }

  Future<void> setChapterSelected(String chapter) async {
    await _ensureInitialized();
    await _prefs!.setString(_chapterSelectedKey, chapter);
  }

  // Font Size for Verses
  Future<double> getFontSizeVerse() async {
    await _ensureInitialized();
    return _prefs!.getDouble(_fontSizeVerseKey) ?? 16.0;
  }

  Future<void> setFontSizeVerse(double size) async {
    await _ensureInitialized();
    await _prefs!.setDouble(_fontSizeVerseKey, size);
  }

  // Font Family (serialized object)
  Future<Map<String, dynamic>> getFontFamilySet() async {
    await _ensureInitialized();
    final jsonString = _prefs!.getString(_fontFamilySetKey);
    if (jsonString != null) {
      return json.decode(jsonString);
    }
    return {'label': 'Aclonica', 'value': "1"}; // Default value
  }

  Future<void> setFontFamilySet(Map<String, dynamic> fontData) async {
    await _ensureInitialized();
    await _prefs!.setString(_fontFamilySetKey, json.encode(fontData));
  }

  // Métodos para temas personalizados
  Future<String?> getCurrentCustomTheme() async {
    await _ensureInitialized();
    return _prefs!.getString(_currentCustomThemeKey);
  }

  Future<void> setCurrentCustomTheme(String themeJson) async {
    await _ensureInitialized();
    await _prefs!.setString(_currentCustomThemeKey, themeJson);
  }

  Future<void> clearCurrentCustomTheme() async {
    await _ensureInitialized();
    await _prefs!.remove(_currentCustomThemeKey);
  }

  Future<List<String>> getCustomThemes() async {
    await _ensureInitialized();
    return _prefs!.getStringList(_customThemesKey) ?? [];
  }

  Future<void> setCustomThemes(List<String> themes) async {
    await _ensureInitialized();
    await _prefs!.setStringList(_customThemesKey, themes);
  }

  Future<void> addCustomTheme(String themeJson) async {
    final themes = await getCustomThemes();
    themes.add(themeJson);
    await setCustomThemes(themes);
  }

  // Métodos para userData
  Future<String?> getUserData() async {
    await _ensureInitialized();

    return _prefs!.getString(_userDataKey);
  }

  Future<String> getUserId() async {
    await _ensureInitialized();

    final userDataString = _prefs!.getString(_userDataKey);

    if (userDataString == null || userDataString.isEmpty) {
      return "";
    }

    try {
      final userInfoJson = jsonDecode(userDataString);

      // Acceder directamente al campo 'id' del JSON
      if (userInfoJson['id'] != null) {
        return userInfoJson['id'].toString();
      } else if (userInfoJson['userId'] != null) {
        return userInfoJson['userId'].toString();
      } else {
        return "";
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error decoding user data: $e');
      }
      return "";
    }
  }

  Future<void> setUserData(String userDataJson) async {
    await _ensureInitialized();

    await _prefs!.setString(_userDataKey, userDataJson);
  }

  Future<void> clearUserData() async => await _prefs!.remove(_userDataKey);

  // Métodos para configuración de TTS
  Future<double> getTtsSpeechRate() async {
    await _ensureInitialized();
    return _prefs!.getDouble(_ttsSpeechRateKey) ?? 0.5;
  }

  Future<void> setTtsSpeechRate(double rate) async {
    await _ensureInitialized();
    await _prefs!.setDouble(_ttsSpeechRateKey, rate);
  }

  // Métodos para configuración de audio
  Future<bool> getIsMuted() async {
    await _ensureInitialized();

    return _prefs!.getBool(_isMutedKey) ?? false;
  }

  Future<void> setMuted(bool muted) async {
    await _ensureInitialized();

    await _prefs!.setBool(_isMutedKey, muted);
  }

  Future<bool> getIsBackgroundPlaying() async {
    await _ensureInitialized();

    return _prefs!.getBool(_isBackgroundPlayingKey) ?? true;
  }

  Future<void> setBackgroundPlaying(bool playing) async {
    await _ensureInitialized();

    await _prefs!.setBool(_isBackgroundPlayingKey, playing);
  }

  // Métodos para onboarding/intro
  Future<bool> hasSeenIntro() async {
    await _ensureInitialized();

    return _prefs!.getBool(_hasSeenIntroKey) ?? false;
  }

  Future<void> setHasSeenIntro(bool seen) async {
    await _ensureInitialized();

    await _prefs!.setBool(_hasSeenIntroKey, seen);
  }

  Future<void> setFontSizeQuestion(double size) async {
    await _ensureInitialized();

    await _prefs!.setDouble(_fontSizeQuestionKey, size);
  }

  Future<double> getFontSizeQuestion() async {
    await _ensureInitialized();
    return _prefs!.getDouble(_fontSizeQuestionKey) ?? 16.0;
  }

  // Métodos para manejo de modelos complejos
  Future<LoginUser?> getLoginUser() async {
    final json = await getUserData();
    return json != null ? LoginUser.fromJson(jsonDecode(json)) : null;
  }

  Future<void> setLoginUser(LoginUser? user) async {
    if (user != null) {
      await setUserData(jsonEncode(user.toJson()));
    } else {
      await clearUserData();
    }
  }

  // Métodos para manejo de modelos complejos
  Future<Map<String, dynamic>?> getDeviceInfo() async {
    await _ensureInitialized();
    final jsonString = _prefs!.getString(_deviceInfoKey);
    return jsonString != null ? jsonDecode(jsonString) : null;
  }

  Future<void> setDeviceInfo(Map<String, dynamic> deviceData) async {
    await _ensureInitialized();
    await _prefs!.setString(_deviceInfoKey, jsonEncode(deviceData));
  }

  // Métodos para manejo de modelos complejos
  Future<String> getLastPlayDate() async {
    await _ensureInitialized();
    return _prefs!.getString(_lastPlayDateKey) ?? '';
  }

  Future<void> setLastPlayDate(String lastPlay) async {
    await _ensureInitialized();
    await _prefs!.setString(_lastPlayDateKey, lastPlay);
  }

  // Limpiar todas las preferencias
  Future<void> clearAll() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }

  // Limpiar una preferencia
  Future<void> clearOne(String key) async {
    await _ensureInitialized();
    await _prefs!.remove(key);
  }

  Future<void> setTtsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tts_enabled', value);
  }

  Future<bool?> getTtsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('tts_enabled');
  }
}
