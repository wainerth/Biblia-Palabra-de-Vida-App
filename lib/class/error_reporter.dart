import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ErrorReporter {
  static Future<void> sendError({
    required String nameFunction,
    required dynamic error,
    required StackTrace stackTrace,
    String? email,
  }) async {
    try {
      final deviceInfo = await DeviceInfoPlugin().deviceInfo;
      final packageInfo = await PackageInfo.fromPlatform();

      final uri = Uri(
        scheme: 'mailto',
        path: email ?? 'pedpab.12@gmail.com', // Email por defecto
        queryParameters: {
          'subject': '🚨 Error en App Biblia - ${DateTime.now()}',
          'body': '''
⚠️ **Error Reportado** ⚠️
llamado desde $nameFunction:\n
📱 **Dispositivo:**
${_formatDeviceInfo(deviceInfo)}

📦 **Versión App:**
${packageInfo.version} (${packageInfo.buildNumber})

🛠 **Error:**
${error.toString()}

🔍 **Stack Trace:**
${stackTrace.toString()}
'''
        },
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        debugPrint('No se pudo abrir el cliente de email');
      }
    } catch (e) {
      debugPrint('Error al reportar: $e');
    }
  }

  static String _formatDeviceInfo(dynamic deviceInfo) {
    if (deviceInfo is AndroidDeviceInfo) {
      return '''
Modelo: ${deviceInfo.model}
Android: ${deviceInfo.version.release}
SDK: ${deviceInfo.version.sdkInt}
''';
    } else if (deviceInfo is IosDeviceInfo) {
      return '''
Dispositivo: ${deviceInfo.utsname.machine}
iOS: ${deviceInfo.systemVersion}
''';
    }
    return 'Desconocido';
  }
}