import 'package:biblia_palabra_de_vida_app/providers/catalogue_provider.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:biblia_palabra_de_vida_app/services/remote_config_service.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/button_theme_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const SplashScreen({super.key, required this.onComplete});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final RemoteConfigService _configService;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();

    // 👇 1. Escuchar cambios en tiempo real
    _configService = Provider.of<RemoteConfigService>(context, listen: false);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final catalogueProvider =
          Provider.of<CatalogueProvider>(context, listen: false);
      await catalogueProvider.initialize();

      // Verificar estado de la app
      await _checkAppStatus();
    } catch (e) {
      print('Error en inicialización: $e');
      // Si hay error, igual intentamos ir a home
      widget.onComplete();
    }
  }

  Future<void> _checkAppStatus() async {
    // 4. Verificar modo mantenimiento [citation:4][citation:8]
    if (_configService.isMaintenanceMode) {
      _navigateToMaintenance();
      return;
    }

    // 5. Verificar actualización forzada
    if (await _configService.isForceUpdateRequired()) {
      _navigateToForceUpdate();
      return;
    }

    // 6. Verificar actualización recomendada
    if (await _configService.isSoftUpdateRecommended()) {
      _navigateToSoftUpdate();
      return;
    }

    // 7. Todo ok, completar
    widget.onComplete();
  }

  void _navigateToMaintenance() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MaintenanceScreen(
          title: _configService.maintenanceTitle,
          message: _configService.maintenanceMessage,
        ),
      ),
    );
  }

  void _navigateToForceUpdate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ForceUpdateScreen(
          title: _configService.updateTitle,
          message: _configService.updateMessage,
          storeUrl: _configService.storeUrlAndroid,
        ),
      ),
    );
  }

  void _navigateToSoftUpdate() {
    widget.onComplete();

    // Mostrar diálogo después de navegar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSoftUpdateDialog();
    });
  }

  void _showSoftUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // Se puede cerrar
      builder: (context) => AlertDialog(
        title: Text(
          _configService.updateTitle,
          style: StylesApp(context)
              .textStyleBody16
              .copyWith(color: StyleColor.black),
        ),
        content: Text(
          _configService.updateMessage,
          style: StylesApp(context)
              .textStyleBody14
              .copyWith(color: StyleColor.grayDark),
        ),
        actions: [
          Row(
            spacing: 2.0,
            children: [
              Expanded(
                child: ButtonThemeWidget(
                  buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                      backgroundColor:
                          WidgetStatePropertyAll(StyleColor.blueLight)),
                  onPressed: () => Navigator.pop(context),
                  text: 'Ahora no',
                ),
              ),
              Expanded(
                child: ButtonThemeWidget(
                  buttonStyle: StylesApp(context).btnSecondarySmall,
                  onPressed: () {
                    // Abrir Play Store
                    _openStore(_configService.storeUrlAndroid);
                  },
                  text: 'Actualizar',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _openStore(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/bibleLogo.png", width: 150),
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Verificando actualizaciones...',
                style: StylesApp(context)
                    .textStyleBody14
                    .copyWith(color: StyleColor.black)),
          ],
        ),
      ),
    );
  }
}
