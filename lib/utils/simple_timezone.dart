import 'dart:io';

import 'package:biblia_palabra_de_vida_app/utils/time_zoned_constants.dart';

class SimpleTimeZone {
  /// Método PRINCIPAL - Una línea para obtener IANA
  static String get currentIANA {
    final offset = DateTime.now().timeZoneOffset.inHours;
    return _offsetToIANA(offset);
  }
  
  /// Mapeo offset -> IANA usando TUS constantes
  static String _offsetToIANA(int offset) {
    switch (offset) {
      // Venezuela y países GMT-4
      case -4: return TimeZoneConstants.americaCaracas;
      
      // Colombia, Perú, Ecuador, Panamá GMT-5
      case -5:
        return _detectCountryInGMT5() 
            ? TimeZoneConstants.americaBogota 
            : TimeZoneConstants.americaLima;
      
      // México, Centroamérica GMT-6
      case -6:
        return _detectCountryInGMT6() 
            ? TimeZoneConstants.americaMexicoCity 
            : TimeZoneConstants.americaGuatemala;
      
      // Argentina, Chile, Brasil, Uruguay GMT-3
      case -3:
        if (_detectCountry('ar') || _detectCountry('argentina')) {
          return TimeZoneConstants.americaBuenosAires;
        } else if (_detectCountry('cl') || _detectCountry('chile')) {
          return TimeZoneConstants.americaSantiago;
        } else if (_detectCountry('br') || _detectCountry('brasil')) {
          return TimeZoneConstants.americaSaoPaulo;
        } else if (_detectCountry('uy') || _detectCountry('uruguay')) {
          return TimeZoneConstants.americaMontevideo;
        }
        return TimeZoneConstants.americaBuenosAires;
      
      // USA/Canadá
      case -8: return TimeZoneConstants.americaLosAngeles;
      case -7: return TimeZoneConstants.americaDenver;
      case -6: return TimeZoneConstants.americaChicago;
      case -5: return TimeZoneConstants.americaNewYork;
      case -4: return TimeZoneConstants.americaToronto;
      
      // Europa
      case 0: return TimeZoneConstants.europeLondon;
      case 1: 
        if (_detectCountry('es') || _detectCountry('spain')) {
          return TimeZoneConstants.europeMadrid;
        } else if (_detectCountry('fr') || _detectCountry('france')) {
          return TimeZoneConstants.europeParis;
        } else if (_detectCountry('de') || _detectCountry('germany')) {
          return TimeZoneConstants.europeBerlin;
        } else if (_detectCountry('it') || _detectCountry('italy')) {
          return TimeZoneConstants.europeRome;
        }
        return TimeZoneConstants.europeMadrid;
      case 2: return TimeZoneConstants.europeAthens;
      case 3: return TimeZoneConstants.europeMoscow;
      
      // Asia
      case 9: return TimeZoneConstants.asiaTokyo;
      case 8: return TimeZoneConstants.asiaShanghai;
      case 5: return TimeZoneConstants.asiaKolkata;
      case 3: return TimeZoneConstants.asiaDubai;
      
      // Oceanía
      case 10: return TimeZoneConstants.australiaSydney;
      case 12: return TimeZoneConstants.pacificAuckland;
      case -10: return TimeZoneConstants.pacificHonolulu;
      
      // Por defecto: UTC
      default: return TimeZoneConstants.utc;
    }
  }
  
  // Helpers para detección por país (opcional)
  static bool _detectCountry(String countryCode) {
    final locale = _getLocale();
    return locale.toLowerCase().contains(countryCode);
  }
  
  static bool _detectCountryInGMT5() {
    final locale = _getLocale().toLowerCase();
    return locale.contains('co') ||  // Colombia
           locale.contains('pe') ||  // Perú
           locale.contains('ec') ||  // Ecuador
           locale.contains('pa');    // Panamá
  }
  
  static bool _detectCountryInGMT6() {
    final locale = _getLocale().toLowerCase();
    return locale.contains('mx') ||  // México
           locale.contains('gt') ||  // Guatemala
           locale.contains('sv') ||  // El Salvador
           locale.contains('hn');    // Honduras
  }
  
  static String _getLocale() {
    // Obtener locale del dispositivo
    try {
      return Platform.localeName;
    } catch (e) {
      return '';
    }
  }
  
  /// Obtener solo el offset (GMT-4, GMT+2, etc.)
  static String get currentOffset {
    final offset = DateTime.now().timeZoneOffset;
    final hours = offset.inHours;
    return 'GMT${hours >= 0 ? '+' : ''}$hours';
  }
  
  /// Para Venezuela específicamente (siempre seguro)
  static String get venezuela {
    return TimeZoneConstants.americaCaracas;
  }
  
  /// Async version si la necesitas
  static Future<String> get currentIANAasync async {
    await Future.delayed(Duration.zero);
    return currentIANA;
  }
}