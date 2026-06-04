import 'package:biblia_palabra_de_vida_app/config/api_config.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:biblia_palabra_de_vida_app/services/device_service.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
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

  Widget _buildMobileLayout() {
    final translationProvider = context.read<AppTranslationProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFF12CBC4),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
              foregroundColor: WidgetStatePropertyAll(StyleColor.white)),
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
                  const SizedBox(height: 8),
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/icon.png',
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    translationProvider.tr('about.title'),
                    style: StylesApp(context).textStyleBody12.copyWith(
                          color: StyleColor.orange,
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
                  : translationProvider.tr('about.loading'),
              style: StylesApp(context).textStyleBody16.copyWith(
                    color: Colors.white,
                    fontSize: 16,
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
              child: Text(
                translationProvider.tr('about.app_description'),
                textAlign: TextAlign.center,
                style: StylesApp(context).textStyleBody16.copyWith(
                      color: Colors.white,
                      fontSize: 16,
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
                    path: ApiConfig.emailContact,
                    queryParameters: {
                      'subject': translationProvider.tr('about.email_subject'),
                      'body': translationProvider.tr('about.email_body'),
                    },
                  );

                  if (await canLaunchUrl(emailLaunchUri)) {
                    await launchUrl(emailLaunchUri);
                  } else {
                    showSnackBar(translationProvider.tr('about.email_error'),
                        type: SnackBarType.error);
                  }
                },
                child: Text(
                  '${translationProvider.tr('about.contact')} ${ApiConfig.emailContact}',
                  style: StylesApp(context).textStyleBody16.copyWith(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              translationProvider.tr('about.copyright'),
              style: StylesApp(context).textStyleBody16.copyWith(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    final translationProvider = context.read<AppTranslationProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF12CBC4),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
              foregroundColor: WidgetStatePropertyAll(StyleColor.white)),
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
        elevation: 0,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Columna izquierda: Logo e información principal
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo con efecto de sombra
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'assets/icon.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Título principal
                    Text(
                      translationProvider.tr('about.title'),
                      textAlign: TextAlign.center,
                      style: StylesApp(context).textStyleBody12.copyWith(
                            color: StyleColor.orange,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                    ),

                    const SizedBox(height: 30),

                    // Versión de la app
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _versionApp != null && _versionApp!.isNotEmpty
                            ? '${translationProvider.tr('about.version_label')} ${_versionApp!['appVersion'].toString()}'
                            : translationProvider.tr('about.loading_version'),
                        style: StylesApp(context).textStyleBody18.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Información adicional
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            translationProvider.tr('about.copyright'),
                            style: StylesApp(context).textStyleBody16.copyWith(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            translationProvider.tr('about.all_rights_reserved'),
                            style: StylesApp(context).textStyleBody14.copyWith(
                                  color: Colors.white60,
                                  fontSize: 14,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Columna derecha: Información detallada
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título de la columna
                    Text(
                      translationProvider.tr('about.about_app'),
                      style: StylesApp(context).textStyleBody16.copyWith(
                            color: Color(0xFF12CBC4),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    const SizedBox(height: 30),

                    // Descripción
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              translationProvider.tr('about.welcome'),
                              style:
                                  StylesApp(context).textStyleBody20.copyWith(
                                        color: Color(0xFF333333),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),

                            const SizedBox(height: 20),

                            Text(
                              translationProvider.tr('about.app_description'),
                              style:
                                  StylesApp(context).textStyleBody16.copyWith(
                                        color: Color(0xFF555555),
                                        fontSize: 17,
                                        height: 1.6,
                                      ),
                            ),

                            const SizedBox(height: 20),

                            // Características
                            Text(
                              translationProvider.tr('about.features_title'),
                              style:
                                  StylesApp(context).textStyleBody16.copyWith(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),

                            const SizedBox(height: 15),

                            _buildFeatureItem( translationProvider.tr('about.feature_multiple_versions')),
                            _buildFeatureItem(
                                translationProvider.tr('about.feature_advanced_search')),
                            _buildFeatureItem(translationProvider.tr('about.feature_bookmarks')),
                            _buildFeatureItem(translationProvider.tr('about.feature_themes')),
                            _buildFeatureItem(translationProvider.tr('about.feature_audio')),
                            _buildFeatureItem(translationProvider.tr('about.feature_notes')),

                            const SizedBox(height: 30),

                            // Divider
                            Container(
                              height: 1,
                              color: const Color(0xFF12CBC4)
                                  .withValues(alpha: 0.3),
                            ),

                            const SizedBox(height: 30),

                            // Equipo de desarrollo
                            Text(
                              translationProvider.tr('about.development_team'),
                              style:
                                  StylesApp(context).textStyleBody16.copyWith(
                                        color: Color(0xFF333333),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),

                            const SizedBox(height: 15),

                            Text(
                              translationProvider.tr('about.team_description') ,
                              style:
                                  StylesApp(context).textStyleBody16.copyWith(
                                        color: Color(0xFF555555),
                                        fontSize: 17,
                                        height: 1.6,
                                      ),
                            ),

                            const SizedBox(height: 30),

                            // Contacto
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF12CBC4)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: const Color(0xFF12CBC4)
                                      .withValues(alpha: 0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translationProvider.tr('about.contact_section'),
                                    style: StylesApp(context)
                                        .textStyleBody16
                                        .copyWith(
                                          color: Color(0xFF333333),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      final Uri emailLaunchUri = Uri(
                                        scheme: 'mailto',
                                        path: ApiConfig.emailContact,
                                        queryParameters: {
                                          'subject':
                                              translationProvider.tr('about.email_subject'),
                                          'body':
                                              translationProvider.tr('about.email_body'),
                                        },
                                      );

                                      if (await canLaunchUrl(emailLaunchUri)) {
                                        await launchUrl(emailLaunchUri);
                                      } else {
                                        showSnackBar(
                                            translationProvider.tr('about.email_error'),
                                            type: SnackBarType.error);
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.email,
                                          color: const Color(0xFF12CBC4),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            ApiConfig.emailContact,
                                            style: StylesApp(context)
                                                .textStyleBody16
                                                .copyWith(
                                                  color: Color(0xFF555555),
                                                  fontSize: 16,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                   translationProvider.tr('about.contact_instruction'),
                                    style: StylesApp(context)
                                        .textStyleBody16
                                        .copyWith(
                                          color: Color(0xFF777777),
                                          fontSize: 15,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF12CBC4),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: StylesApp(context).textStyleBody16.copyWith(
                    color: Color(0xFF555555),
                    fontSize: 16,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
    );
  }

  Future<Map<String, dynamic>> _loadDeviceInfo() async {
    try {
      final deviceData = await DeviceService.getDeviceInfo();
      if (kDebugMode) {
        print('Device info: $deviceData');
      }
      return deviceData;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading device info: $e');
      }
      return <String, dynamic>{};
    }
  }
}
