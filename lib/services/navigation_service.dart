import 'package:biblia_palabra_de_vida_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../providers/app_providers.dart';
import '../services/remote_config_service.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  bool? _hasSeenIntro;

  // ========== GESTIÓN DE ESTADO ==========
  void updateHasSeenIntro(bool? value) {
    _hasSeenIntro = value;
  }

  // ========== NAVEGACIÓN PRINCIPAL ==========
  void goToInitialScreen() {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;

    // 1. PRIMERO: Navegar a la pantalla correspondiente
    if (_hasSeenIntro == null) {
      Navigator.pushReplacementNamed(ctx, '/loading');
      _checkForSoftUpdateAfterNavigation(ctx);
      return;
    }

    if (_hasSeenIntro!) {
      final authProvider = ctx.read<AuthenticationProvider>();
      authProvider.checkAuthentication(ctx).then((_) {
        if (authProvider.isAuthenticated && authProvider.token != null) {
          Navigator.pushReplacementNamed(ctx, '/layoutPage');
        } else {
          Navigator.pushReplacementNamed(ctx, '/homePage');
        }
        // 2. DESPUÉS de navegar, verificar soft update
        _checkForSoftUpdateAfterNavigation(ctx);
      });
    } else {
      Navigator.pushReplacementNamed(ctx, '/introPage');
      _checkForSoftUpdateAfterNavigation(ctx);
    }
  }

// 🔥 NUEVO: Método separado para verificar soft update después de navegar
  void _checkForSoftUpdateAfterNavigation(BuildContext ctx) {
    // Pequeño delay para asegurar que la navegación terminó
    Future.delayed(const Duration(milliseconds: 500), () {
      final currentRoute = ModalRoute.of(ctx)?.settings.name;

      // Solo mostrar en pantallas principales, no en loading/splash
      if (currentRoute != '/loading' &&
          currentRoute != '/splashPage' &&
          currentRoute != '/introPage') {
        final remoteConfigService = RemoteConfigService();
        remoteConfigService.isSoftUpdateRecommended().then((softRecommended) {
          if (softRecommended) {
            _showSoftUpdateDialog(ctx, remoteConfigService);
          }
        });
      }
    });
  }

  void _showSoftUpdateDialog(BuildContext ctx, RemoteConfigService config) {
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        title: Text(config.updateTitle),
        content: Text(config.updateMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Ahora no'),
          ),
          ElevatedButton(
            onPressed: () async {
              final url = Uri.parse(config.storeUrlAndroid);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  // ========== MANEJO DE REMOTE CONFIG ==========
  Future<void> handleRemoteConfigUpdate(RemoteConfigService config) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (navigatorKey.currentContext != null) {
      _handleConfigChange(navigatorKey.currentContext!, config);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleConfigChange(navigatorKey.currentContext!, config);
      });
    }
  }

  void _handleConfigChange(BuildContext context, RemoteConfigService config) {
    Navigator.pushReplacementNamed(context, "/splashPage");
  }

  void showSoftUpdateDialog(BuildContext context, RemoteConfigService config) {
    // Verificar si ya hay un diálogo abierto
    if (Navigator.canPop(context) &&
        ModalRoute.of(context)?.isCurrent != true) {
      // Ya hay algo mostrándose, esperar un poco
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          showSoftUpdateDialog(context, config);
        }
      });
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      useSafeArea: true,
      builder: (BuildContext dialogContext) => WillPopScope(
        onWillPop: () async => true, // Permitir cerrar con back
        child: AlertDialog(
          title: Text(config.updateTitle),
          content: Text(config.updateMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Cerrar diálogo
                // NO navegar, solo continuar en la misma pantalla
              },
              child: const Text('Ahora no'),
            ),
            ElevatedButton(
              onPressed: () async {
                final url = Uri.parse(config.storeUrlAndroid);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
                Navigator.pop(dialogContext); // Cerrar diálogo
                // Mantener al usuario en la misma pantalla
              },
              child: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  // ========== ORIENTACIÓN ==========
  void applyOrientationPolicy() {
    // Solo aplicar una vez al inicio
    try {
      final context = navigatorKey.currentContext;
      if (context == null) return;

      final shortestSide = MediaQuery.of(context).size.shortestSide;
      final bool isTablet = shortestSide >= 550;

      if (isTablet) {
        // Tablet: solo landscape
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        // Móvil: solo portrait
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }

      print('📱 Orientación fijada: ${isTablet ? "Landscape" : "Portrait"}');
    } catch (e) {
      debugPrint('Could not apply orientation policy: $e');
    }
  }
}
