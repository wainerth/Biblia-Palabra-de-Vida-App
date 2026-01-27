import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum DialogType { info, warning, error }

class CustomDialog extends StatefulWidget {
  final String message;
  final String buttonOk;
  final DialogType dialogType;
  final String textButton;
  final bool showAction;
  final void Function()? actionCallback;
  final String? errorDetail;
  final bool showDetails;

  const CustomDialog({
    super.key,
    this.buttonOk = 'Ok',
    required this.message,
    required this.dialogType,
    this.showAction = false,
    this.actionCallback,
    this.textButton = 'Aceptar',
    this.errorDetail,
    this.showDetails = false,
  });

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  late bool _showErrorDetails;

  @override
  void initState() {
    super.initState();
    _showErrorDetails = widget.showDetails;
  }

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String title;

    switch (widget.dialogType) {
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

    final double screenWidth = MediaQuery.of(context).size.width;
    final double dialogMaxWidth =
        screenWidth * 0.9 > 600 ? 600 : screenWidth * 0.9;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogMaxWidth),
        child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
          scrollable: true,
          title: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: color)),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mensaje amigable para el usuario
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: StylesApp(context)
                    .textStyleBody12
                    .copyWith(color: Colors.black),
              ),

              const SizedBox(height: 16),

              // Detalles del error (solo si hay y si está expandido)
              if (widget.errorDetail != null && _showErrorDetails) ...[
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(Icons.code, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Detalles técnicos:',
                      style: StylesApp(context).textStyleBody10.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: SelectableText(
                    widget.errorDetail!,
                    style: StylesApp(context).textStyleBody10.copyWith(
                          color: Colors.grey[800],
                          fontFamily: 'Monospace',
                        ),
                  ),
                ),

                const SizedBox(height: 8),

                // Botón para copiar al portapapeles
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.errorDetail!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error copiado al portapapeles'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: Icon(Icons.copy, size: 16),
                    label: Text(
                      'Copiar',
                      style: StylesApp(context).textStyleBody10,
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),

                Divider(color: Colors.grey[300]),
              ],

              // Botón para mostrar/ocultar detalles (SIEMPRE visible si hay errorDetail)
              if (widget.errorDetail != null && widget.showDetails) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showErrorDetails = !_showErrorDetails;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showErrorDetails
                            ? Icons.expand_less
                            : Icons.expand_more,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _showErrorDetails
                            ? 'Ocultar detalles'
                            : 'Ver detalles',
                        style: StylesApp(context).textStyleBody10.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              style: StylesApp(context).btnWidgetSmall,
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                widget.buttonOk,
                style: StylesApp(context).textStyleBody14,
              ),
            ),
            if (widget.showAction) ...[
              const SizedBox(height: 10),
              TextButton(
                style: StylesApp(context).btnWidgetSmall,
                onPressed: widget.actionCallback,
                child: Text(
                  widget.textButton,
                  style: StylesApp(context).textStyleBody14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}