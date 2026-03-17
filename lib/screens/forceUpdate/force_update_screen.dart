import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateScreen extends StatelessWidget {
  final String title;
  final String message;
  final String storeUrl;

  const ForceUpdateScreen({
    super.key,
    required this.title,
    required this.message,
    required this.storeUrl,
  });

  Future<void> _openStore() async {
    final url = Uri.parse(storeUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.system_update,
                size: 80,
                color: Colors.red,
              ),
              SizedBox(height: 24),
              Text(
                title,
                style: StylesApp(context).textStyleBody24.copyWith(
                      color: StyleColor.grayDark,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: StylesApp(context)
                    .textStyleBody16
                    .copyWith(color: StyleColor.grayMedium, fontSize: 16),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _openStore,
                style: StylesApp(context).btnWidgetSmall.copyWith(
                      minimumSize:
                          WidgetStatePropertyAll(Size(150, 40)),
                    ),
                child: Text('ACTUALIZAR AHORA'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
