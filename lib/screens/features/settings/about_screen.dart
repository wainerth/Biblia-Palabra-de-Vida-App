import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/services/device_service.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Map<String, dynamic>? _versionApp;

  @override
  void initState() {
    super.initState();
    _initDeviceInfo();
  }

  Future<void> _initDeviceInfo() async {
    final info = await _loadDeviceInfo();
    if (mounted) {
      setState(() {
        _versionApp = info;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12CBC4),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(StyleColor.orange),
              foregroundColor: MaterialStatePropertyAll(StyleColor.white)),
          padding: const EdgeInsets.all(0),
          onPressed: () {
            Navigator.pop(context);
          },
          splashColor: StyleColor.orange,
          color: StyleColor.white,
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        backgroundColor: StyleColor.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/elipsisTop.png"),
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo o imagen de la app
                  const SizedBox(height: 8),
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/icon.png', // Cambia por el logo de tu app
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Biblia Palabra de Vida',
                    style: TextStyle(
                      color: Color(0xFFFF914D),
                      fontFamily: 'LuckiestGuy',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _versionApp != null && _versionApp!.isNotEmpty
                  ? _versionApp!['appVersion'].toString()
                  : 'Cargando...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: const Divider(color: Colors.white, thickness: 1),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: const Text(
                'Esta aplicación fue creada para ayudarte a estudiar y compartir la Palabra de Dios de manera interactiva y divertida.\n\nDesarrollada por el equipo de Biblia Palabra de Vida.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: const Divider(color: Colors.white, thickness: 1),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GestureDetector(
                onTap: () async {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: GraphQLConfig.emailContact,
                    queryParameters: {
                      'subject': 'Consulta - Biblia Palabra de Vida',
                      'body': 'Hola, tengo una consulta sobre la aplicación:',
                    },
                  );

                  if (await canLaunchUrl(emailLaunchUri)) {
                    await launchUrl(emailLaunchUri);
                  } else {
                    // Si no se puede abrir el cliente de correo, mostrar un snackbar o diálogo
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('No se pudo abrir la aplicación de correo'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Contacto: ${GraphQLConfig.emailContact}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Text(
              '© 2025 Biblia Palabra de Vida',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _loadDeviceInfo() async {
    try {
      final deviceData = await DeviceService.getDeviceInfo();
      if (kDebugMode) {
        print('Device info: $deviceData');
      }
      // Aquí puedes usar la información si la necesitas
      return deviceData;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading device info: $e');
      }
      return <String, dynamic>{};
    }
  }
}
