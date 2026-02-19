// providers/translation_provider.dart
import 'package:biblia_palabra_de_vida_app/services/bible_translator_service.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';

class BibleTranslationProvider  with ChangeNotifier {
  final BibleTranslationService _service = BibleTranslationService();

  // Reducir idiomas a los MÁS RÁPIDOS
  static final List<Map<String, String>> _supportedLanguages = [
    {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    // {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'}, // Comentar temporalmente
    // {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'}, // Comentar temporalmente
    // {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'}, // Comentar temporalmente
    // {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'}, // Comentar temporalmente
    // {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'},
    {'code': 'ko', 'name': '한국어', 'flag': '🇰🇷'}, // Comentar temporalmente
    // Solo estos 4 que son más rápidos
  ];

  String _currentLanguage = 'es';
  bool _isTranslating = false;
  bool _translationEnabled = true;
  final Map<String, String> _translatedVerses = {};

  // Para evitar notificaciones durante build
  bool _isNotifying = false;

  // Getters
  String get currentLanguage => _currentLanguage;
  bool get isTranslating => _isTranslating;
  bool get translationEnabled => _translationEnabled;
  List<Map<String, String>> get supportedLanguages => _supportedLanguages;

  String get currentLanguageName {
    return _supportedLanguages
        .firstWhere((lang) => lang['code'] == _currentLanguage)['name']!;
  }

  String get currentLanguageFlag {
    return _supportedLanguages
        .firstWhere((lang) => lang['code'] == _currentLanguage)['flag']!;
  }

  // Cambiar idioma de manera SEGURA
  Future<void> setLanguage(String languageCode) async {
    if (!_supportedLanguages.any((lang) => lang['code'] == languageCode)) {
      return;
    }

    if (_currentLanguage == languageCode) return;

    _currentLanguage = languageCode;
    _translatedVerses.clear();

    // Notificar de manera segura
    _safeNotifyListeners();
  }

  // Traducir un versículo OPTIMIZADO
  Future<String> translateVerse(String text, String verseId) async {
    if (_currentLanguage == 'es' || !_translationEnabled) {
      return text;
    }

    // Cache rápido
    final cacheKey = '${_currentLanguage}_$verseId';
    if (_translatedVerses.containsKey(cacheKey)) {
      return _translatedVerses[cacheKey]!;
    }

    // Verificar si es texto que no necesita traducción
    if (_shouldSkipTranslation(text)) {
      _translatedVerses[cacheKey] = text;
      return text;
    }

    _isTranslating = true;
    _safeNotifyListeners();

    try {
      // Traducción con timeout más corto
      final translated = await _service
          .translateVerse(
            text: text,
            targetLanguage: _currentLanguage,
            sourceLanguage: 'es',
            maxRetries: 1, // Solo 1 intento para ser más rápido
          )
          .timeout(const Duration(seconds: 5), onTimeout: () => text);

      // Solo guardar si es diferente
      if (translated != text) {
        _translatedVerses[cacheKey] = translated;
      }

      return translated;
    } catch (e) {
      print('Error rápido en traducción: $e');
      return text;
    } finally {
      _isTranslating = false;
      _safeNotifyListeners();
    }
  }

  // Traducir múltiples versículos en PARALELO
  Future<List<String>> translateVerses(
      List<String> texts, List<String> verseIds) async {
    if (_currentLanguage == 'es' || !_translationEnabled) return texts;

    _isTranslating = true;
    _safeNotifyListeners();

    try {
      final List<Future<String>> futures = [];
      final List<String> results = [];

      for (int i = 0; i < texts.length; i++) {
        final cacheKey = '${_currentLanguage}_${verseIds[i]}';

        // Verificar cache primero
        if (_translatedVerses.containsKey(cacheKey)) {
          results.add(_translatedVerses[cacheKey]!);
        } else {
          futures.add(_translateSingleQuick(texts[i], verseIds[i]));
        }
      }

      // Esperar solo las que necesitan traducción
      if (futures.isNotEmpty) {
        final translatedResults = await Future.wait(futures);
        results.addAll(translatedResults);
      }

      return results;
    } catch (e) {
      print('Error en batch rápido: $e');
      return texts;
    } finally {
      _isTranslating = false;
      _safeNotifyListeners();
    }
  }

  // Traducción individual rápida
  Future<String> _translateSingleQuick(String text, String verseId) async {
    final cacheKey = '${_currentLanguage}_$verseId';

    try {
      final translated = await _service
          .translateVerse(
            text: text,
            targetLanguage: _currentLanguage,
            sourceLanguage: 'es',
            maxRetries: 1,
          )
          .timeout(const Duration(seconds: 3), onTimeout: () => text);

      if (translated != text) {
        _translatedVerses[cacheKey] = translated;
      }

      return translated;
    } catch (e) {
      return text;
    }
  }

  // Determinar si debe saltarse la traducción
  bool _shouldSkipTranslation(String text) {
    // Textos muy cortos
    if (text.trim().length <= 2) return true;

    // Solo números
    if (RegExp(r'^[\d\s]+$').hasMatch(text.trim())) return true;

    // Nombres propios comunes
    final lowerText = text.toLowerCase();
    final skipWords = {'jehová', 'jesús', 'cristo', 'amén', 'aleluya'};

    return skipWords.contains(lowerText);
  }

  // Notificar de manera SEGURA (sin errores durante build)
  void _safeNotifyListeners() {
    if (_isNotifying || !hasListeners) return;

    _isNotifying = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isNotifying = false;
      if (hasListeners && mounted) {
        notifyListeners();
      }
    });
  }

  void clearCache() {
    _translatedVerses.clear();
    _service.clearCache();
    _safeNotifyListeners();
  }

  void toggleTranslation(bool enabled) {

    _translationEnabled = enabled;
    if (!enabled) {
      _translatedVerses.clear();
    }
    _safeNotifyListeners();
  }

  // Para verificar si está montado (si se usa en widget)
  bool mounted = true;
}
