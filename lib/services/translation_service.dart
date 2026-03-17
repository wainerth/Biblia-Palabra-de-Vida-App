// lib/services/translation_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  // Cache para traducciones
  final Map<String, String> _translationCache = {};

  // Configuración
  String _currentLanguage = 'es';
  bool _translationEnabled = true;
  static const String _apiKey = 'TU_API_KEY_AQUI'; // Reemplaza con tu API key
  static const String _apiUrl = 'https://api.mymemory.translated.net/get';

  // Listener para notificar cambios (si quieres usar ChangeNotifier)
  final List<VoidCallback> _listeners = [];

  // Getters
  String get currentLanguage => _currentLanguage;
  bool get translationEnabled => _translationEnabled;

  // Lista de idiomas soportados
  List<Map<String, String>> get supportedLanguages => _supportedLanguages;

  static final List<Map<String, String>> _supportedLanguages = [
    {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
    {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'},
    {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
    {'code': 'ko', 'name': '한국어', 'flag': '🇰🇷'},
    {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
    {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
    {'code': 'it', 'name': 'Italiano', 'flag': '🇮🇹'},
  ];

  // ============ NUEVOS MÉTODOS PARA PERSISTENCIA ============

  // Cargar preferencias guardadas
  Future<void> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentLanguage = prefs.getString('app_language') ?? 'es';
      _translationEnabled = prefs.getBool('translation_enabled') ?? true;

      if (kDebugMode) {
        print('📱 Preferencias cargadas:');
        print('   - Idioma: $_currentLanguage');
        print('   - Traducción activada: $_translationEnabled');
      }

      _notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cargando preferencias: $e');
      }
    }
  }

  // Guardar configuración de idioma
  Future<void> setLanguage(String languageCode) async {
    if (_supportedLanguages.any((lang) => lang['code'] == languageCode)) {
      _currentLanguage = languageCode;

      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language', languageCode);

      // Limpiar cache al cambiar idioma
      _clearCache();

      _notifyListeners();

      if (kDebugMode) {
        print('🌍 Idioma cambiado a: $languageCode');
      }
    }
  }

  // Activar/desactivar traducción con persistencia
  Future<void> toggleTranslation(bool enabled) async {
    _translationEnabled = enabled;

    // Guardar en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('translation_enabled', enabled);

    if (!enabled) {
      _clearCache();
    }

    _notifyListeners();

    if (kDebugMode) {
      print('🔄 Traducción ${enabled ? 'activada' : 'desactivada'}');
    }
  }

  // Método conveniente para alternar
  Future<void> toggleTranslationStatus() async {
    await toggleTranslation(!_translationEnabled);
  }

  // ============ MÉTODOS DE NOTIFICACIÓN ============

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  // ============ MÉTODOS DE UTILIDAD ============

  // Obtener objeto de idioma actual
  Map<String, String>? get currentLanguageInfo {
    try {
      return _supportedLanguages.firstWhere(
        (lang) => lang['code'] == _currentLanguage,
      );
    } catch (e) {
      return {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'};
    }
  }

  // Obtener nombre del idioma actual
  String get currentLanguageName {
    return currentLanguageInfo?['name'] ?? 'Español';
  }

  // Obtener bandera del idioma actual
  String get currentLanguageFlag {
    return currentLanguageInfo?['flag'] ?? '🇪🇸';
  }

  // Verificar si un idioma es el actual
  bool isCurrentLanguage(String languageCode) {
    return _currentLanguage == languageCode;
  }

  // ============ MÉTODOS EXISTENTES (con algunas mejoras) ============

  Future<String> translateText(String text,
      {String? targetLang, String? cacheKey}) async {
    // Si la traducción está desactivada o es español, devolver texto original
    if (!_translationEnabled || _currentLanguage == 'es') {
      return text;
    }

    // Si el texto está vacío, devolver vacío
    if (text.trim().isEmpty) {
      return text;
    }

    // Usar cacheKey si se proporciona, sino generar uno
    final key = cacheKey ?? '${_currentLanguage}_${text.hashCode}';

    // Verificar cache
    if (_translationCache.containsKey(key)) {
      return _translationCache[key]!;
    }

    try {
      // Para debugging
      if (kDebugMode) {
        print(
            '🔄 Traduciendo: "${text.length > 30 ? '${text.substring(0, 30)}...' : text}"');
        print('   Idioma destino: ${targetLang ?? _currentLanguage}');
      }

      // Llamar a la API de traducción
      final translatedText =
          await _callTranslationAPI(text, targetLang ?? _currentLanguage);

      // Guardar en cache
      _translationCache[key] = translatedText;

      if (kDebugMode) {
        print('✅ Traducido: "$translatedText"');
      }

      return translatedText;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error traduciendo "$text": $e');
      }
      // En caso de error, devolver texto original
      return text;
    }
  }

  // Método para traducir múltiples textos
  Future<List<String>> translateMultiple(List<String> texts,
      {List<String>? cacheKeys}) async {
    if (!_translationEnabled || _currentLanguage == 'es') {
      return texts;
    }

    final results = <String>[];

    for (int i = 0; i < texts.length; i++) {
      final text = texts[i];
      final cacheKey = cacheKeys != null && i < cacheKeys.length
          ? cacheKeys[i]
          : '${_currentLanguage}_${text.hashCode}';

      if (_translationCache.containsKey(cacheKey)) {
        results.add(_translationCache[cacheKey]!);
      } else {
        final translated = await translateText(text, cacheKey: cacheKey);
        results.add(translated);
      }
    }

    return results;
  }

  // Método para traducir un mapa de textos (útil para JSON)
  Future<Map<String, String>> translateMap(Map<String, String> texts) async {
    if (!_translationEnabled || _currentLanguage == 'es') {
      return texts;
    }

    final translatedMap = <String, String>{};

    for (final entry in texts.entries) {
      final translated = await translateText(entry.value, cacheKey: entry.key);
      translatedMap[entry.key] = translated;
    }

    return translatedMap;
  }

  // Llamada a la API
  Future<String> _callTranslationAPI(String text, String targetLang) async {
    try {
      final url = Uri.parse(
          '$_apiUrl?q=${Uri.encodeComponent(text)}&langpair=es|$targetLang');

      if (kDebugMode) {
        print(
            '🌐 Llamando API: ${url.toString().length > 100 ? '${url.toString().substring(0, 100)}...' : url}');
      }

      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (kDebugMode) {
        print('📡 Respuesta API: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final translatedText = data['responseData']['translatedText'] as String;

        // Limpiar el texto (MyMemory a veces añade tags HTML)
        return _cleanTranslatedText(translatedText);
      } else {
        throw Exception('Error en API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en traducción: $e');
    }
  }

  // Limpiar texto traducido
  String _cleanTranslatedText(String text) {
    if (text.isEmpty) return text;

    // Remover tags HTML si existen
    String cleaned = text
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll('&#39;', "'") // Replace HTML entities
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&#160;', ' ')
        .replaceAll(RegExp(r'\s+'), ' ') // Multiple spaces to single space
        .trim();

    return cleaned;
  }

  // Limpiar cache
  void clearCache() {
    _translationCache.clear();
    if (kDebugMode) {
      print('🗑️ Cache de traducciones limpiado');
    }
  }

  void _clearCache() {
    _translationCache.clear();
  }

  // Método para inicializar el servicio (llamar en main.dart)
  Future<void> initialize() async {
    await loadPreferences();

    if (kDebugMode) {
      print('🚀 TranslationService inicializado');
      print('   - Idioma actual: $_currentLanguage');
      print('   - Traducción activada: $_translationEnabled');
      print('   - Idiomas soportados: ${_supportedLanguages.length}');
    }
  }

  // Método para obtener estadísticas (útil para debugging)
  Map<String, dynamic> getStats() {
    return {
      'currentLanguage': _currentLanguage,
      'translationEnabled': _translationEnabled,
      'cacheSize': _translationCache.length,
      'supportedLanguages': _supportedLanguages.length,
    };
  }
}
