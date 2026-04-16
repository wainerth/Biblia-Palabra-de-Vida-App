import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTranslationProvider extends ChangeNotifier {
  // Singleton pattern
  static AppTranslationProvider? _instance;
  static AppTranslationProvider get instance {
    assert(_instance != null, 'TranslationProvider no inicializado');
    return _instance!;
  }

  // Constructor privado
  AppTranslationProvider._internal() {
    _instance = this;
  }

  // Factory constructor
  factory AppTranslationProvider() {
    return _instance ??= AppTranslationProvider._internal();
  }

  // ============ VARIABLES DE ESTADO ============
  Map<String, dynamic> _translations = {};
  String _currentLanguage = 'es';
  bool _isInitialized = false;

  // ============ IDIOMAS SOPORTADOS ============
  static final List<Map<String, String>> _supportedLanguages = [
    {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
    {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
    {'code': 'it', 'name': 'Italiano', 'flag': '🇮🇹'},
  ];

  // ============ GETTERS ============
  Map<String, dynamic> get translations => _translations;
  String get currentLanguage => _currentLanguage;
  bool get isInitialized => _isInitialized;
  List<Map<String, String>> get supportedLanguages => _supportedLanguages;

  String get currentLanguageName {
    return _supportedLanguages
        .firstWhere((lang) => lang['code'] == _currentLanguage)['name']!;
  }

  String get currentLanguageFlag {
    return _supportedLanguages
        .firstWhere((lang) => lang['code'] == _currentLanguage)['flag']!;
  }

  // ============ MÉTODOS PRINCIPALES ============

  /// Inicializa el provider
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Cargar preferencias guardadas
    await _loadPreferences();

    // Cargar traducciones del idioma actual
    await _loadTranslations(_currentLanguage);

    _isInitialized = true;
    notifyListeners();
  }

  /// Carga las preferencias guardadas
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentLanguage = prefs.getString('app_language') ?? 'es';
    } catch (e) {
      print('Error cargando preferencias: $e');
      _currentLanguage = 'es';
    }
  }

  /// Carga las traducciones desde un archivo JSON
  Future<void> _loadTranslations(String languageCode) async {
    try {
      // Cargar el archivo JSON desde assets
      final jsonString = await rootBundle
          .loadString('assets/translations/$languageCode.json');
      
      // Decodificar JSON manteniendo la estructura anidada
      _translations = json.decode(jsonString);

      print('✅ Traducciones cargadas para: $languageCode');
      print('   - Grupos: ${_translations.keys.join(', ')}');
    } catch (e) {
      print('❌ Error cargando traducciones para $languageCode: $e');
      
      // Si falla, cargar español como respaldo
      if (languageCode != 'es') {
        await _loadTranslations('es');
      }
    }
  }

  /// Cambia el idioma de la aplicación
  Future<void> setLanguage(String languageCode) async {
    if (!_supportedLanguages.any((lang) => lang['code'] == languageCode)) {
      print('⚠️ Idioma no soportado: $languageCode');
      return;
    }

    // Guardar preferencia
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', languageCode);

    // Cargar nuevas traducciones
    await _loadTranslations(languageCode);

    // Actualizar estado
    _currentLanguage = languageCode;
    notifyListeners();

    print('🌍 Idioma cambiado a: $languageCode');
  }

  /// Traduce un texto usando su ruta (ej: 'settings.configuracion')
  String tr(String path, {String? defaultValue}) {
    // Si no está inicializado, devolver la ruta o valor por defecto
    if (!_isInitialized) {
      return defaultValue ?? path;
    }

    try {
      // Dividir la ruta por puntos (ej: 'settings.configuracion' -> ['settings', 'configuracion'])
      final parts = path.split('.');
      
      // Navegar por la estructura anidada
      dynamic current = _translations;
      for (final part in parts) {
        if (current is Map && current.containsKey(part)) {
          current = current[part];
        } else {
          // Si no se encuentra, mostrar warning en desarrollo
          assert(() {
            print('⚠️ Texto no traducido: "$path" en idioma $_currentLanguage');
            return true;
          }());
          
          return defaultValue ?? path;
        }
      }
      
      // Asegurarse de que sea un String
      return current is String ? current : current.toString();
    } catch (e) {
      // En caso de error, mostrar warning y devolver valor por defecto
      assert(() {
        print('⚠️ Error en ruta de traducción "$path": $e');
        return true;
      }());
      
      return defaultValue ?? path;
    }
  }

  /// Traduce un texto con parámetros
  String trParams(String path, Map<String, String> params, {String? defaultValue}) {
    String text = tr(path, defaultValue: defaultValue);
    
    // Reemplazar parámetros
    params.forEach((param, value) {
      text = text.replaceAll('{{$param}}', value);
    });
    
    return text;
  }

  /// Obtiene un grupo completo de traducciones
  Map<String, dynamic>? getGroup(String groupName) {
    if (!_isInitialized) return null;
    
    final group = _translations[groupName];
    return group is Map ? Map<String, dynamic>.from(group) : null;
  }

  /// Verifica si una ruta existe en las traducciones
  bool hasTranslation(String path) {
    if (!_isInitialized) return false;
    
    try {
      final parts = path.split('.');
      dynamic current = _translations;
      
      for (final part in parts) {
        if (current is Map && current.containsKey(part)) {
          current = current[part];
        } else {
          return false;
        }
      }
      
      return current is String;
    } catch (e) {
      return false;
    }
  }

  /// Limpia todas las traducciones (útil para testing)
  void clear() {
    _translations.clear();
    _currentLanguage = 'es';
    _isInitialized = false;
    notifyListeners();
  }
}