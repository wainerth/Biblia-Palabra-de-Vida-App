import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:installed_apps/installed_apps.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  static const platform =
      MethodChannel('com.renuevo.palabradevidabiblia/appchecker');
  final String appName = "amistad Online"; // Ajusta esto
  final String appPackageName = "amistad.online2"; // Ajusta esto
  String playStoreUrl = "";
  String playStoreWebUrl = "";
  final String appCustomUrl =
      "amistad.online2://"; // Esquema personalizado - ¡DEBES VERIFICARLO!
  final String appDescription =
      "Una radio con valores que te acompaña todos los días";
  bool showScreen = false;
  @override
  void initState() {
    super.initState();
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
            title: Text("Abrir aplicación externa"),
            content: Text("Serás redirigido a 'Amistad Online'"),
            actions: [
              TextButton(
                  child: Text("cancel"),
                  onPressed: () => Navigator.pop(ctx, false)),
              TextButton(
                  child: Text("Aceptar"),
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
          message:
              "No se pudo abrir la aplicación $appName. ¿Deseas descargar la App?",
          dialogType: DialogTypeAction.error,
          buttonOk: "Continuar",
          showAction: true,
          actionCallbackOk: () async {
            Navigator.pop(context);
            await launchUrl(Uri.parse(playStoreWebUrl),
                mode: LaunchMode.externalApplication);
          },
          textButton: "Cancelar",
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
            "No se pudo abrir la aplicación $appName. ¿Deseas descargar la App?",
        dialogType: DialogTypeAction.error,
        buttonOk: "Continuar",
        showAction: true,
        actionCallbackOk: () {
          Navigator.pop(context);
          final Uri playStoreUri = Uri.parse(playStoreWebUrl);
          launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
        },
        textButton: "Cancelar",
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
      playStoreWebUrl = GraphQLConfig.urlApkRadio;
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
          'Audio',
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
              "AMISTAD",
              style: StylesApp(context).textStyleBody28.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
            ),
            Text(
              "Online Radio",
              style: StylesApp(context).textStyleBody20.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            Text(
              "La frecuencia que acompaña",
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
                      "Estás a punto de abrir:",
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
                      title: Text("Confirmar"),
                      content:
                          Text("¿Deseas abrir la aplicación $appPackageName?"),
                      actions: [
                        TextButton(
                          child: Text("Cancelar"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: Text("Abrir"),
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
                "Escuchar Radio",
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
