import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/button_theme_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Widget interno que maneja la carga de datos y el contenido
class WhatsAppScheduleContent extends StatefulWidget {
  final bool receiveWhatsApp;
  final List<ScheduleModel> selectedHours;
  final Function(bool) onWhatsAppChanged;
  final Function(List<ScheduleModel>) onHoursChanged;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const WhatsAppScheduleContent({
    super.key,
    required this.receiveWhatsApp,
    required this.selectedHours,
    required this.onWhatsAppChanged,
    required this.onHoursChanged,
    required this.onCancel,
    required this.onSave,
  });

  @override
  State<WhatsAppScheduleContent> createState() =>
      WhatsAppScheduleContentState();
}

class WhatsAppScheduleContentState extends State<WhatsAppScheduleContent> {
  late Future<List<ScheduleModel>> _hoursFuture;

  @override
  void initState() {
    super.initState();

    _hoursFuture = _loadAvailableHours();
  }

  Future<List<ScheduleModel>> _loadAvailableHours() async {
    try {
      final response = await getSchedule(); // Tu función existente
      return _processScheduleResponse(response.data);
    } catch (e) {
      throw Exception('Error al cargar los horarios: $e');
    }
  }

  List<ScheduleModel> _processScheduleResponse(dynamic response) {
    // Procesa la respuesta según tu estructura
    if (response is List && response.isNotEmpty) {
      return response.map((item) => ScheduleModel.fromJson(item)).toList();
    }

    // Horarios por defecto
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          SizedBox(height: 20),
          FutureBuilder<List<ScheduleModel>>(
            future: _hoursFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingState();
              }

              if (snapshot.hasError) {
                return _buildErrorState(snapshot.error.toString());
              }

              final availableHours = snapshot.data ?? [];
              return _buildFormContent(availableHours);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SvgPicture.asset(
          "assets/whatsapp.svg",
          width: 60,
          height: 60,
        ),
        SizedBox(height: 16),
        Text(
          'Mensajes por WhatsApp',
          style: _textStyleTitle(context),
        ),
        SizedBox(height: 12),
        Text(
          '¿Deseas recibir mensajes de notificación a través de WhatsApp?',
          textAlign: TextAlign.center,
          style: _textStyleSubtitle(context),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF25D366)),
            ),
            SizedBox(height: 16),
            Text(
              'Cargando horarios disponibles...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade400,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red.shade400,
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _hoursFuture = _loadAvailableHours();
                });
              },
              child: Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent(List<ScheduleModel> availableHours) {
    return Column(
      children: [
        _buildWhatsAppCheckbox(),
        if (widget.receiveWhatsApp) ...[
          SizedBox(height: 24),
          Divider(),
          SizedBox(height: 16),
          _buildHoursSelector(availableHours),
          if (widget.selectedHours.isNotEmpty) ...[
            SizedBox(height: 16),
            _buildSelectedHoursChips(),
          ],
        ],
        SizedBox(height: 24),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildWhatsAppCheckbox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: GestureDetector(
        onTap: () {
          widget.onWhatsAppChanged(!widget.receiveWhatsApp);
        },
        child: Row(
          children: [
            Checkbox(
              value: widget.receiveWhatsApp,
              onChanged: (value) => widget.onWhatsAppChanged(value ?? false),
              activeColor: Color(0xFF25D366),
            ),
            Expanded(
              child: Text(
                'Habilitar notificaciones por WhatsApp',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoursSelector(List<ScheduleModel> availableHours) {
    return Column(
      children: [
        Text(
          'Selecciona los horarios para recibir mensajes',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(height: 8),
        Text(
          'Mínimo 2 horas - Máximo 3 horas',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 16),
        Container(
          constraints: BoxConstraints(maxHeight: 300),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2,
            ),
            itemCount: availableHours.length,
            itemBuilder: (context, index) {
              final hour = availableHours[index];

              final isSelected =
                  widget.selectedHours.any((h) => h.id == hour.id);

              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    widget.onHoursChanged(
                      widget.selectedHours
                          .where((h) => h.id != hour.id)
                          .toList(),
                    );
                  } else {
                    if (widget.selectedHours.length < 3) {
                      widget.onHoursChanged([...widget.selectedHours, hour]);
                    } else {
                      _showLimitSnackBar('Máximo 3 horas permitidas');
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected ? Color(0xFF25D366) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isSelected ? Color(0xFF25D366) : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      hour.time,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade800,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedHoursChips() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Horas seleccionadas:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedHours.map((hour) {
              return Chip(
                label: Text(hour.time, style: TextStyle(fontSize: 12)),
                onDeleted: () {
                  widget.onHoursChanged(
                    widget.selectedHours.where((h) => h.id != hour.id).toList(),
                  );
                },
                backgroundColor: Color(0xFF25D366).withValues(alpha: 0.1),
                deleteIconColor: Color(0xFF25D366),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: ButtonThemeWidget(
            buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                  backgroundColor: WidgetStatePropertyAll(Colors.white),
                  foregroundColor: WidgetStatePropertyAll(StyleColor.grayDark),
                  side: WidgetStatePropertyAll(
                      BorderSide(color: StyleColor.greenDark)),
                ),
            onPressed: widget.onCancel,
            text: 'Cancelar',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ButtonThemeWidget(
            buttonStyle: StylesApp(context).btnWidgetSmall,
            onPressed: () {
              if (widget.receiveWhatsApp) {
                if (widget.selectedHours.length < 2) {
                  _showLimitSnackBar('Debes seleccionar al menos 2 horas');
                  return;
                }
                if (widget.selectedHours.length > 3) {
                  _showLimitSnackBar('Máximo 3 horas permitidas');
                  return;
                }
              }
              widget.onSave();
            },
            text: 'Guardar',
          ),
        ),
      ],
    );
  }

  void _showLimitSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Estilos
  TextStyle _textStyleTitle(BuildContext context) {
    return StylesApp(context).textStyleBody20.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: StyleColor.grayDark,
        );
  }

  TextStyle _textStyleSubtitle(BuildContext context) {
    return StylesApp(context).textStyleBody16.copyWith(
          fontSize: 16,
          color: StyleColor.grayMedium,
        );
  }
}
