import 'dart:io';
import 'package:biblia_palabra_de_vida_app/utils/time_zoned_constants.dart';
import 'package:flutter/services.dart';

class NativeTimeZone {
  static const MethodChannel _channel = MethodChannel('com.yourapp/timezone');

  /// Obtiene la zona horaria REAL del dispositivo
  static Future<String> getTimeZone() async {
    try {
      // Solo para Android/iOS
      if (Platform.isAndroid || Platform.isIOS) {
        final String? timezone = await _channel.invokeMethod('getTimeZone');

        if (timezone != null && timezone.isNotEmpty) {
          // Validar formato IANA
          if (_isValidIANA(timezone)) {
            return timezone;
          }
        }
      }

      // Fallback: usar offset
      return _getTimeZoneFromOffset();
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
      return _getTimeZoneFromOffset();
    }
  }

  static bool _isValidIANA(String zone) {
    return zone.contains('/') &&
        ['America/', 'Europe/', 'Asia/', 'Africa/', 'Australia/', 'Pacific/']
            .any((prefix) => zone.startsWith(prefix));
  }

  static String _getTimeZoneFromOffset() {
    final offset = DateTime.now().timeZoneOffset.inHours;
    return _offsetToIANA(offset);
  }

  static String _offsetToIANA(int offset) {
    // Usar TUS constantes
    if (offset == -4) return TimeZoneConstants.americaCaracas;
    if (offset == -5) return TimeZoneConstants.americaBogota;
    if (offset == -6) return TimeZoneConstants.americaMexicoCity;
    if (offset == -3) return TimeZoneConstants.americaBuenosAires;
    if (offset == -8) return TimeZoneConstants.americaLosAngeles;
    if (offset == -5) return TimeZoneConstants.americaNewYork;
    if (offset == 0) return TimeZoneConstants.europeLondon;
    if (offset == 1) return TimeZoneConstants.europeMadrid;
    return TimeZoneConstants.utc;
  }
}
