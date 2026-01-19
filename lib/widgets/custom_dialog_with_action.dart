import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:flutter/material.dart';

enum DialogTypeAction { info, warning, error }

class CustomDialogWithAction extends StatelessWidget {
  final String message;
  final DialogTypeAction dialogType;
  final String buttonOk;
  final String textButtonAction;
  final bool showAction;
  final void Function()? callbackActionOk;
  final void Function()? actionCallback;

  const CustomDialogWithAction({
    super.key,
    required this.message,
    required this.dialogType,
    this.buttonOk = 'Ok',
    this.actionCallback,
    this.showAction = false,
    this.textButtonAction = 'Aceptar',
    this.callbackActionOk,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    
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
      insetPadding: isTablet 
          ? EdgeInsets.symmetric(horizontal: 100, vertical: 100)
          : EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      contentPadding: EdgeInsets.all(isTablet ? 24 : 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: isTablet ? 28 : 24),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              style: StylesApp(context).textStyleBody16.copyWith(
                color: color,
                fontSize: isTablet ? 20 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isTablet ? 400 : 300,
          maxHeight: isTablet ? 300 : 200,
        ),
        child: SingleChildScrollView(
          child: Text(
            message,
            style: StylesApp(context).textStyleBody15.copyWith(
              fontSize: isTablet ? 17 : 15,
              color: Colors.black87,
            ),
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: callbackActionOk ?? () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 16,
                  vertical: isTablet ? 12 : 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                ),
              ),
              child: Text(
                buttonOk,
                style: StylesApp(context).textStyleBody14.copyWith(
                  fontSize: isTablet ? 16 : 14,
                  color: Colors.white,
                ),
              ),
            ),
            if (showAction) ...[
              SizedBox(width: isTablet ? 16 : 12),
              OutlinedButton(
                onPressed: actionCallback,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24 : 16,
                    vertical: isTablet ? 12 : 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isTablet ? 10 : 8),
                  ),
                  side: BorderSide(color: color),
                ),
                child: Text(
                  textButtonAction,
                  style: StylesApp(context).textStyleBody14.copyWith(
                    fontSize: isTablet ? 16 : 14,
                    color: color,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

