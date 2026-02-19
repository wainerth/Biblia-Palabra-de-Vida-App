class TranslationConstants {
  // Idiomas soportados
  static const List<Language> supportedLanguages = [
    Language(code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸'),
    Language(code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸'),
    Language(code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹'),
    Language(code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷'),
    Language(code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹'),
    Language(code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪'),
    Language(code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺'),
    Language(code: 'zh', name: 'Chinese', nativeName: '中文', flag: '🇨🇳'),
  ];

  // Límites
  static const int maxTextLength = 5000; // Caracteres máximos por traducción
  static const int cacheSize = 1000; // Máximo items en caché
  static const Duration translationTimeout = Duration(seconds: 30);
  
  // Modos de traducción
  static const String modeOnline = 'online';
  static const String modeOffline = 'offline';
  static const String modeHybrid = 'hybrid';
  
  // Configuración por defecto
  static const String defaultLanguage = 'es';
  static const String defaultMode = modeHybrid;
  
  // Palabras que NO traducir
  static const Set<String> nonTranslatableWords = {
    'Jehová', 'Jesús', 'Cristo', 'Dios', 'Señor', 'Amén', 'Aleluya',
    'Selah', 'Espíritu', 'Santo', 'Mesías', 'Biblia', 'Evangelio',
    'Apóstol', 'Profeta', 'Rey', 'Sacerdote', 'Templo', 'Altar'
  };
}

class Language {
  final String code;
  final String name;
  final String nativeName;
  final String flag;
  
  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}