// services/bible_translation_service.dart
import 'package:translator/translator.dart';
import 'dart:async';

class BibleTranslationService {
  static final BibleTranslationService _instance = BibleTranslationService._internal();
  factory BibleTranslationService() => _instance;
  BibleTranslationService._internal();

  final GoogleTranslator _translator = GoogleTranslator();
  
  // Cache simple y rápido
  final Map<String, String> _translationCache = {};
  
  // Traducción RÁPIDA con timeout corto
  Future<String> translateVerse({
    required String text,
    required String targetLanguage,
    String sourceLanguage = 'es',
    int maxRetries = 1, // Solo 1 intento para velocidad
  }) async {
    if (targetLanguage == 'es') return text;
    
    // Cache rápido
    final cacheKey = '${sourceLanguage}_${targetLanguage}_${text.hashCode}';
    if (_translationCache.containsKey(cacheKey)) {
      return _translationCache[cacheKey]!;
    }
    
    try {
      // Timeout más corto para mejor UX
      final translation = await _translator.translate(
        text,
        from: sourceLanguage,
        to: targetLanguage,
      ).timeout(const Duration(seconds: 3));
      
      final translatedText = translation.text;
      
      // Guardar en cache solo si es diferente
      if (translatedText != text) {
        _translationCache[cacheKey] = translatedText;
        
        // Limitar tamaño del cache para no usar mucha memoria
        if (_translationCache.length > 100) {
          final firstKey = _translationCache.keys.first;
          _translationCache.remove(firstKey);
        }
      }
      
      return translatedText;
    } catch (e) {
      // En caso de error, devolver texto original
      print('Traducción rápida falló: $e');
      return text;
    }
  }
  
  // Traducción en batch PARALELA
  Future<List<String>> translateVerses({
    required List<String> texts,
    required String targetLanguage,
    String sourceLanguage = 'es',
  }) async {
    if (targetLanguage == 'es') return texts;
    
    final List<Future<String>> futures = [];
    
    // Crear todas las futures en paralelo
    for (final text in texts) {
      futures.add(translateVerse(
        text: text,
        targetLanguage: targetLanguage,
        sourceLanguage: sourceLanguage,
        maxRetries: 1, // Solo 1 intento por velocidad
      ));
    }
    
    // Ejecutar en paralelo pero con límite
    try {
      return await Future.wait(futures);
    } catch (e) {
      print('Error en traducción paralela: $e');
      return texts; // Fallback a textos originales
    }
  }
  
  void clearCache() {
    _translationCache.clear();
  }
}