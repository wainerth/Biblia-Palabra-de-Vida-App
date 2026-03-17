import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';

class MaintenanceScreen extends StatelessWidget {
  final String title;
  final String message;

  const MaintenanceScreen({
    super.key,
    required this.title,
    required this.message,
  });

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
                Icons.build_circle,
                size: 80,
                color: Colors.orange,
              ),
              SizedBox(height: 24),
              Text(
                title,
                style: StylesApp(context).textStyleBody24.copyWith(
                      fontSize: 24,
                      color: StyleColor.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: StylesApp(context)
                    .textStyleBody16
                    .copyWith(color: StyleColor.grayDark, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
