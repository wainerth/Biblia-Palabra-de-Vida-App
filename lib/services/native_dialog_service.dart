import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart'; // Para navigatorKey

class NativeDialogService {
  static const MethodChannel _channel =
      MethodChannel('com.biblia.palabradevida/dialog');

  // Bandera para controlar si ya se mostró el diálogo
  static bool _dialogShown = false;

  /// Muestra un diálogo de actualización usando el canal nativo
  static Future<void> showUpdateDialog({
    required String title,
    required String message,
    required String storeUrl,
  }) async {
    // Evitar mostrar múltiples diálogos
    if (_dialogShown) {
      print('⚠️ Diálogo ya mostrado, ignorando...');
      return;
    }

    _dialogShown = true;

    try {
      print('📱 Intentando mostrar diálogo nativo...');

      // Intentar mostrar diálogo nativo
      await _channel.invokeMethod('showUpdateDialog', {
        'title': title,
        'message': message,
        'storeUrl': storeUrl,
      });

      print('✅ Diálogo nativo mostrado correctamente');

      // Resetear bandera después de un tiempo
      Future.delayed(const Duration(seconds: 5), () {
        _dialogShown = false;
      });
    } on PlatformException catch (e) {
      print('❌ Error mostrando diálogo nativo: $e');

      // Fallback: mostrar diálogo de Flutter
      _showFlutterFallback(title, message, storeUrl);
    } catch (e) {
      print('❌ Error desconocido: $e');
      _showFlutterFallback(title, message, storeUrl);
    }
  }

  /// Fallback: diálogo normal de Flutter
  static void _showFlutterFallback(
      String title, String message, String storeUrl) {
    print('📱 Usando fallback de Flutter...');

    final context = navigatorKey.currentContext;
    if (context == null) {
      print('❌ No hay contexto para mostrar diálogo');
      _dialogShown = false;
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _dialogShown = false;
            },
            child: const Text('Ahora no'),
          ),
          ElevatedButton(
            onPressed: () async {
              final url = Uri.parse(storeUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
              Navigator.pop(context);
              _dialogShown = false;
            },
            child: const Text('Actualizar'),
          ),
        ],
      ),
    ).then((_) {
      // Cuando se cierra el diálogo
      _dialogShown = false;
    });
  }

  /// Método para resetear manualmente la bandera (si es necesario)
  static void resetDialogFlag() {
    _dialogShown = false;
  }
}
