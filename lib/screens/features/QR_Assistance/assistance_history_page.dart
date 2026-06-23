// lib/modules/assistance/pages/assistance_history_page.dart
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';


class AssistanceHistoryPage extends StatefulWidget {
  const AssistanceHistoryPage({super.key});

  @override
  State<AssistanceHistoryPage> createState() => _AssistanceHistoryPageState();
}

class _AssistanceHistoryPageState extends State<AssistanceHistoryPage> {
  List<AssistanceRecord> _history = [];
  bool _isLoading = true;
  String _selectedFilter = 'todas'; // todas, iglesia, evento

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    // Simular carga - Reemplazar con API real
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _history = [
          AssistanceRecord(
            id: '1',
            churchId: '1',
            churchName: 'Iglesia Principal',
            eventName: 'Culto Dominical',
            date: DateTime.now().subtract(const Duration(days: 1)),
            time: DateTime.now().subtract(const Duration(days: 1)),
            method: 'qr',
          ),
          AssistanceRecord(
            id: '2',
            churchId: '1',
            churchName: 'Iglesia Principal',
            eventName: 'Reunión de Jóvenes',
            date: DateTime.now().subtract(const Duration(days: 5)),
            time: DateTime.now().subtract(const Duration(days: 5)),
            method: 'qr',
          ),
          AssistanceRecord(
            id: '3',
            churchId: '2',
            churchName: 'Iglesia Vida Nueva',
            date: DateTime.now().subtract(const Duration(days: 10)),
            time: DateTime.now().subtract(const Duration(days: 10)),
            method: 'evento',
          ),
        ];
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StyleColor.turquoise,
        title: const Text(
          'Historial de Asistencias',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filtros
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildFilterChip('Todas', 'todas'),
                const SizedBox(width: 8),
                _buildFilterChip('Iglesias', 'iglesia'),
                const SizedBox(width: 8),
                _buildFilterChip('Eventos', 'evento'),
              ],
            ),
          ),
          
          // Lista de asistencias
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _history.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history_toggle_off_outlined, size: 80, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'No hay asistencias registradas',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          final record = _history[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: StyleColor.turquoise.withOpacity(0.1),
                                child: Icon(
                                  record.eventId != null ? Icons.event : Icons.church,
                                  color: StyleColor.turquoise,
                                ),
                              ),
                              title: Text(record.eventName ?? record.churchName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${record.churchName} • ${record.method == 'qr' ? "QR" : "Evento"}'),
                                  Text('${record.formattedDate} - ${record.formattedTime}'),
                                ],
                              ),
                              trailing: const Icon(Icons.check_circle, color: Colors.green),
                            ),
                          );
                        },
                      ),
          ),
          
          // Botón de exportar
          if (_history.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Exportar a Excel/PDF
                  _showExportOptions();
                },
                icon: const Icon(Icons.download),
                label: const Text('Exportar reporte'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == value,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
        // Filtrar lista
      },
      backgroundColor: Colors.grey.shade200,
      selectedColor: StyleColor.turquoise.withOpacity(0.2),
    );
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              leading: Icon(Icons.picture_as_pdf),
              title: Text('Exportar a PDF'),
              subtitle: Text('Generar reporte en PDF'),
            ),
            const ListTile(
              leading: Icon(Icons.table_chart),
              title: Text('Exportar a Excel'),
              subtitle: Text('Generar reporte en Excel'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.share),
              title: Text('Compartir'),
              subtitle: Text('Compartir por WhatsApp o Email'),
            ),
          ],
        ),
      ),
    );
  }
}