import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/widgets/whatsAppScheduleContent.dart';
import 'package:flutter/material.dart';

// Widget principal del diálogo
class WhatsAppScheduleDialog extends StatefulWidget {
  final Function(bool enabled, List<ScheduleModel> hours) onSave;
  final bool initialEnabled;
  final List<ScheduleModel> initialHours;

  const WhatsAppScheduleDialog({
    super.key,
    required this.onSave,
    this.initialEnabled = false, // Valor por defecto
    this.initialHours = const [],
  });

  @override
  State<WhatsAppScheduleDialog> createState() => _WhatsAppScheduleDialogState();
}

class _WhatsAppScheduleDialogState extends State<WhatsAppScheduleDialog> {
  late bool _receiveWhatsApp;
  late List<ScheduleModel> _selectedHours;

  @override
  void initState() {
    super.initState();
    // Inicializar con los valores pasados desde SettingsScreen
    _receiveWhatsApp = widget.initialEnabled;
    _selectedHours = List.from(widget.initialHours);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: WhatsAppScheduleContent(
          receiveWhatsApp: _receiveWhatsApp,
          selectedHours: _selectedHours,
          onWhatsAppChanged: (value) {
            setState(() {
              _receiveWhatsApp = value;
              if (!_receiveWhatsApp) {
                _selectedHours.clear();
              }
            });
          },
          onHoursChanged: (hours) {
            setState(() {
              _selectedHours = hours;
            });
          },
          onCancel: () => Navigator.pop(context, false),
          onSave: () {
            widget.onSave(_receiveWhatsApp, _selectedHours);
            Navigator.pop(context, true);
          },
        ),
      ),
    );
  }
}

// Método estático para mostrar el diálogo fácilmente
extension WhatsAppScheduleDialogExtension on WhatsAppScheduleDialog {
  static Future<bool?> show({
    required BuildContext context,
    bool initialEnabled = false,
    List<ScheduleModel> initialHours = const [],
    required Function(bool enabled, List<ScheduleModel> hours) onSave,
  }) async {
    return showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => WhatsAppScheduleDialog(
        onSave: onSave,
        initialEnabled: initialEnabled,
        initialHours: initialHours,
      ),
    );
  }
}
