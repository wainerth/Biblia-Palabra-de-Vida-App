import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:flutter/material.dart';

enum DialogTypeAction { info, warning, error }

class CustomDialogWithAction extends StatelessWidget {
  final String message;
  final DialogTypeAction dialogType;
  final String buttonOk;
  final String textButtonAction;
  final bool showAction;
  final void Function()? CallbackActionOk;
  final void Function()? actionCallback;

  const CustomDialogWithAction(
      {Key? key,
      required this.message,
      required this.dialogType,
      this.buttonOk = 'Ok',
      this.actionCallback,
      this.showAction = false,
      this.textButtonAction = 'Aceptar', 
      this.CallbackActionOk,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String title;

    switch (dialogType) {
      case DialogTypeAction.info:
        icon = Icons.info_outline;
        color = Colors.blue;
        title = 'Información';
        break;
      case DialogTypeAction.warning:
        icon = Icons.warning_amber;
        color = Colors.orange;
        title = 'Advertencia';
        break;
      case DialogTypeAction.error:
        icon = Icons.error_outline;
        color = Colors.red;
        title = 'Error';
        break;
    }

    return AlertDialog(
      scrollable: true,
      title: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: color)),
        ],
      ),
      content: Text(
        message,
        style: StylesApp(context).textStyleBody12.copyWith(color: Colors.black),
      ),
      actions: [
        TextButton(
          style: StylesApp(context).btnWidgetSmall,
          onPressed: CallbackActionOk,
          child: Text(
            buttonOk,
            style: StylesApp(context).textStyleBody14,
          ),
        ),
        if (showAction) ...{
          SizedBox(height: 10),
          TextButton(
            style: StylesApp(context).btnWidgetSmall,
            onPressed: actionCallback,
            child: Text(
              textButtonAction,
              style: StylesApp(context).textStyleBody14,
            ),
          ),
        }
      ],
    );
  }
}
