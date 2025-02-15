import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:flutter/material.dart';

enum DialogType { info, warning, error }

class CustomDialog extends StatelessWidget {
  final String message;
  final DialogType dialogType;

  const CustomDialog(
      {Key? key, required this.message, required this.dialogType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String title;

    switch (dialogType) {
      case DialogType.info:
        icon = Icons.info_outline;
        color = Colors.blue;
        title = 'Información';
        break;
      case DialogType.warning:
        icon = Icons.warning_amber;
        color = Colors.orange;
        title = 'Advertencia';
        break;
      case DialogType.error:
        icon = Icons.error_outline;
        color = Colors.red;
        title = 'Error';
        break;
    }

    return AlertDialog(
      title: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: color)),
        ],
      ),
      content: Text(
        message,
        style: StylesApp(context).textStyleBody16.copyWith(color: Colors.black),
      ),
      actions: [
        TextButton(
          style: StylesApp(context).btnWidgetSmall,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'OK',
            style: StylesApp(context).textStyleBody14,
          ),
        ),
      ],
    );
  }
}
