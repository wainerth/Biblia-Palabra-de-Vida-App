import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class SafeTimeZoneService {
  static bool _initialized = false;

  static Future<void> _initialize() async {
    if (!_initialized) {
      tz.initializeTimeZones();
      _initialized = true;
    }
  }

  /// Obtiene la zona horaria IANA (ej: "America/Caracas") - SIMPLE Y FUNCIONAL
  static Future<String> getIANATimezone() async {
    try {
      await _initialize();

      // Método CORRECTO para 0.10.0
      return tz.local.name; // "America/Caracas"
    } catch (e) {
      print('Error obteniendo IANA: $e');
      return _fallbackIANATimezone();
    }
  }

  /// Información completa y FUNCIONAL
  static Future<Map<String, dynamic>> getCompleteTimeZoneInfo() async {
    await _initialize();
    final now = DateTime.now();

    try {
      final location = tz.local;
      final nowTz = tz.TZDateTime.now(location);

      return {
        // Información IANA
        'iana_timezone': location.name, // "America/Caracas"
        'timezone_id': location.name,

        // Offsets (usando DateTime normal, es más confiable)
        'offset_hours': now.timeZoneOffset.inHours,
        'offset_minutes': now.timeZoneOffset.inMinutes,
        'offset_formatted': _formatOffset(now.timeZoneOffset),

        // Fechas y horas
        'local_time': nowTz.toIso8601String(),
        'utc_time': now.toUtc().toIso8601String(),
        'local_timestamp': nowTz.millisecondsSinceEpoch,

        // Horario de verano (estimación simple)
        'has_dst': _estimateHasDST(location.name),
        'current_is_dst': _estimateIsCurrentlyDST(),

        // Información de la zona
        'location': {
          'continent': location.name.split('/').first,
          'city': location.name.split('/').last,
          'full_name': location.name,
        },

        // Seguridad
        'permissions_required': 'none',
        'play_store_compliant': true,

        // Debug
        'package_version': '0.10.0',
        'success': true,
      };
    } catch (e) {
      print('Error en getCompleteTimeZoneInfo: $e');
      return {
        'iana_timezone': _fallbackIANATimezone(),
        'error': e.toString(),
        'success': false,
        'fallback': true,
      };
    }
  }

  /// Estimación simple de si la zona tiene DST
  static bool _estimateHasDST(String timezoneName) {
    final zonesWithDST = [
      'America/New_York',
      'America/Chicago',
      'America/Denver',
      'America/Los_Angeles',
      'America/Toronto',
      'America/Vancouver',
      'America/Mexico_City',
      'Europe/London',
      'Europe/Paris',
      'Europe/Berlin',
      'Europe/Madrid',
      'Australia/Sydney',
      'Australia/Melbourne',
      'America/Santiago',
      'America/Sao_Paulo',
      'America/Argentina/Buenos_Aires'
    ];

    return zonesWithDST
        .any((zone) => timezoneName.contains(zone.split('/').last));
  }

  /// Estimación simple de si actualmente es DST
  static bool _estimateIsCurrentlyDST() {
    final now = DateTime.now();
    final month = now.month;

    // Simplificación: marzo a octubre en hemisferio norte
    // Para hemisferio sur sería octubre a marzo
    return month >= 3 && month <= 10;
  }

  /// Formatear offset
  static String _formatOffset(Duration offset) {
    final hours = offset.inHours;
    final minutes = offset.inMinutes.abs() % 60;
    final sign = hours.isNegative ? '-' : '+';
    return 'UTC$sign${hours.abs().toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}';
  }

  /// Fallback basado en offset
  static String _fallbackIANATimezone() {
    final offset = DateTime.now().timeZoneOffset.inHours;

    // Mapeo simple de offset a zona común
    switch (offset) {
      case -6:
        return 'America/Mexico_City';
      case -5:
        return 'America/Bogota';
      case -4:
        return 'America/Caracas';
      case -3:
        return 'America/Argentina/Buenos_Aires';
      case 0:
        return 'UTC';
      case 1:
        return 'Europe/Madrid';
      case 2:
        return 'Europe/Athens';
      case -8:
        return 'America/Los_Angeles';
      case -7:
        return 'America/Denver';
      case -9:
        return 'America/Anchorage';
      case -10:
        return 'Pacific/Honolulu';
      default:
        return 'UTC';
    }
  }
}
