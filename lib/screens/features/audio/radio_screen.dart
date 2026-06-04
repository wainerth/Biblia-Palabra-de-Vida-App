import 'package:biblia_palabra_de_vida_app/config/api_config.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:installed_apps/installed_apps.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  final translationProvider = AppTranslationProvider();

  static const platform =
      MethodChannel('com.renuevo.palabradevidabiblia/appchecker');
  final String appName = "amistad Online"; // Ajusta esto
  final String appPackageName = "amistad.online2"; // Ajusta esto
  String playStoreUrl = "";
  String playStoreWebUrl = "";
  final String appCustomUrl =
      "amistad.online2://"; // Esquema personalizado - ¡DEBES VERIFICARLO!
  String appDescription = "";
  bool showScreen = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appDescription = translationProvider.tr("radio_screen.app_description");
    });
  }

  static Future<bool> isAppInstalled(String packageName) async {
    try {
      // Paso 3: Invocar el método nativo
      final bool? result = await platform.invokeMethod<bool>(
        'isAppInstalled',
        {'packageName': packageName},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error al verificar app: ${e.message}");
      }
      return false;
    }
  }

  Future<void> _launchApp() async {
    try {
      // Verificar si podemos lanzar el esquema personalizado
      if (await isAppInstalled(appPackageName)) {
        // Siempre informar al usuario
        final confirmed = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(translationProvider
                .tr("radio_screen.external_app_dialog.title")),
            content: Text(translationProvider
                .tr("radio_screen.external_app_dialog.message")),
            actions: [
              TextButton(
                  child: Text(translationProvider
                      .tr("radio_screen.external_app_dialog.cancel")),
                  onPressed: () => Navigator.pop(ctx, false)),
              TextButton(
                  child: Text(translationProvider
                      .tr("radio_screen.external_app_dialog.accept")),
                  onPressed: () => Navigator.pop(ctx, true)),
            ],
          ),
        );

        if (!confirmed) return;
        await launchUrl(
          Uri.parse('android-app://$appPackageName'),
          mode: LaunchMode.externalNonBrowserApplication,
        );
      } else {
        await showCustomDialogWithAction(
          context,
          message: translationProvider.tr("radio_screen.error_dialog.message"),
          dialogType: DialogTypeAction.error,
          buttonOk:
              translationProvider.tr("radio_screen.error_dialog.continue"),
          showAction: true,
          actionCallbackOk: () async {
            Navigator.pop(context);
            await launchUrl(Uri.parse(playStoreWebUrl),
                mode: LaunchMode.externalApplication);
          },
          textButton:
              translationProvider.tr("radio_screen.error_dialog.cancel"),
          actionCallback: () {
            Navigator.pop(context);
            setState(() {
              showScreen = true;
            });
          },
        );
      }
    } catch (e) {
      await showCustomDialogWithAction(
        context,
        message:
            translationProvider.trParams("radio_screen.error_dialog.message", {
          "appName": appName,
        }),
        dialogType: DialogTypeAction.error,
        buttonOk: translationProvider.tr("radio_screen.error_dialog.continue"),
        showAction: true,
        actionCallbackOk: () {
          Navigator.pop(context);
          final Uri playStoreUri = Uri.parse(playStoreWebUrl);
          launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
        },
        textButton: translationProvider.tr("radio_screen.error_dialog.cancel"),
        actionCallback: () async {
          Navigator.pop(context);
          setState(() {
            showScreen = true;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      playStoreUrl = "market://details?id=$appPackageName";
      playStoreWebUrl = ApiConfig.urlApkRadio;
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
              foregroundColor: WidgetStatePropertyAll(StyleColor.white)),
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pushNamed(context, '/layoutPage');
          },
          splashColor: StyleColor.orange,
          color: StyleColor.white,
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        backgroundColor: StyleColor.turquoise,
        title: Text(
          translationProvider.tr("radio_screen.title"),
          style: StylesApp(context)
              .textStyleBody16
              .copyWith(color: StyleColor.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Icon(Icons.radio, size: 80, color: Colors.blue),
            SizedBox(height: 30),
            Text(
              translationProvider.tr("radio_screen.app_name"),
              style: StylesApp(context).textStyleBody28.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
            ),
            Text(
              translationProvider.tr("radio_screen.app_subtitle"),
              style: StylesApp(context).textStyleBody20.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            Text(
              translationProvider.tr("radio_screen.app_tagline"),
              style: StylesApp(context).textStyleBody16.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            SizedBox(height: 40),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      translationProvider.tr("radio_screen.opening_message"),
                      style: StylesApp(context).textStyleBody16.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      appName,
                      style: StylesApp(context).textStyleBody16.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      appDescription,
                      style: StylesApp(context).textStyleBody16.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(translationProvider.tr("radio_screen.confirm_dialog.title")),
                      content:
                          Text(translationProvider.tr("radio_screen.confirm_dialog.message")),
                      actions: [
                        TextButton(
                          child: Text(translationProvider.tr("radio_screen.confirm_dialog.cancel")),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: Text(translationProvider.tr("radio_screen.confirm_dialog.open")),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _launchApp();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                translationProvider.tr("radio_screen.button"),
                style: StylesApp(context)
                    .textStyleBody18
                    .copyWith(color: StyleColor.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
