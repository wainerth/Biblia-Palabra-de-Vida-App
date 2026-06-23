import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

// Modelo de Evento
class EventModel {
  final String id;
  final String title;
  final String description;
  final String type; // culto, reunion, capacitacion, social
  final DateTime date;
  final String location;
  final String? imageUrl;
  final String timeStart;
  final String timeEnd;
  bool userConfirmed;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.date,
    required this.location,
    this.imageUrl,
    required this.timeStart,
    required this.timeEnd,
    this.userConfirmed = false,
  });

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  String get fullDateTime {
    return '$formattedDate - $timeStart a $timeEnd';
  }

  String get monthYear {
    return '${date.month}/${date.year}';
  }
}

class EventCalendarPage extends StatefulWidget {
  const EventCalendarPage({super.key});

  @override
  State<EventCalendarPage> createState() => _EventCalendarPageState();
}

class _EventCalendarPageState extends State<EventCalendarPage> {
  TextEditingController searchTextController = TextEditingController();
  String searchText = '';
  List<EventModel> listEvent = [];
  List<EventModel> filteredEvents = [];
  bool loading = false;

  // Filtros
  String selectedType = 'todos';
  DateTime? selectedMonth;
  Set<String> confirmedEvents = {};

  // Tipos de eventos
  final List<Map<String, dynamic>> eventTypes = [
    {'value': 'todos', 'label': 'Todos', 'icon': Icons.all_inclusive},
    {'value': 'culto', 'label': 'Culto', 'icon': Icons.church},
    {'value': 'reunion', 'label': 'Reunión', 'icon': Icons.people},
    {'value': 'capacitacion', 'label': 'Capacitación', 'icon': Icons.school},
    {'value': 'social', 'label': 'Social', 'icon': Icons.celebration},
  ];

  @override
  void initState() {
    super.initState();
    _loadEvents();
    selectedMonth = DateTime.now();
  }

  void _loadEvents() {
    // Datos de ejemplo - Reemplazar con API real
    listEvent = [
      EventModel(
        id: '1',
        title: 'Culto de Adoración',
        description:
            'Ven a adorar a Dios en un ambiente de paz y amor. Trae tu familia.',
        type: 'culto',
        date: DateTime(2026, 6, 15),
        location: 'Iglesia Principal - Av. Libertador',
        imageUrl: null,
        timeStart: '09:00 AM',
        timeEnd: '11:00 AM',
      ),
      EventModel(
        id: '2',
        title: 'Reunión de Jóvenes',
        description: 'Comparte con otros jóvenes, juegos, dinámicas y palabra.',
        type: 'reunion',
        date: DateTime(2026, 6, 20),
        location: 'Salón de Jóvenes - 2do piso',
        timeStart: '05:00 PM',
        timeEnd: '08:00 PM',
      ),
      EventModel(
        id: '3',
        title: 'Taller de Liderazgo',
        description: 'Capacitación para líderes y servidores de la iglesia.',
        type: 'capacitacion',
        date: DateTime(2026, 6, 10),
        location: 'Auditorio Principal',
        timeStart: '08:00 AM',
        timeEnd: '04:00 PM',
      ),
      EventModel(
        id: '4',
        title: 'Comida Comunitaria',
        description: 'Comparte con la comunidad, trae un plato para compartir.',
        type: 'social',
        date: DateTime(2026, 6, 25),
        location: 'Área de Confraternidad',
        timeStart: '12:00 PM',
        timeEnd: '03:00 PM',
      ),
      EventModel(
        id: '5',
        title: 'Culto de Oración',
        description: 'Una noche especial de oración e intercesión.',
        type: 'culto',
        date: DateTime(2026, 6, 28),
        location: 'Iglesia Principal',
        timeStart: '07:00 PM',
        timeEnd: '09:00 PM',
      ),
      EventModel(
        id: '6',
        title: 'Escuela de Discipulado',
        description: 'Curso de discipulado para nuevos creyentes.',
        type: 'capacitacion',
        date: DateTime(2026, 7, 5),
        location: 'Salón 101',
        timeStart: '09:00 AM',
        timeEnd: '12:00 PM',
      ),
    ];
    filteredEvents = List.from(listEvent);
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      filteredEvents = listEvent.where((event) {
        // Filtro por búsqueda
        final matchesSearch = searchText.isEmpty ||
            event.title.toLowerCase().contains(searchText.toLowerCase()) ||
            event.description.toLowerCase().contains(searchText.toLowerCase());

        // Filtro por tipo
        final matchesType =
            selectedType == 'todos' || event.type == selectedType;

        // Filtro por mes
        final matchesMonth = selectedMonth == null ||
            (event.date.month == selectedMonth!.month &&
                event.date.year == selectedMonth!.year);

        return matchesSearch && matchesType && matchesMonth;
      }).toList();
    });
  }

  void cleanSearch() {
    setState(() {
      searchText = '';
      searchTextController.clear();
    });
    _applyFilters();
  }

  void _onSearchChanged(String value) {
    _applyFilters();
  }

  void _filterByType(String type) {
    setState(() {
      selectedType = type;
    });
    _applyFilters();
  }

  Future<void> _selectMonth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) {
      setState(() {
        selectedMonth = picked;
      });
      _applyFilters();
    }
  }

  void _clearMonthFilter() {
    setState(() {
      selectedMonth = null;
    });
    _applyFilters();
  }

  void _shareEvent(EventModel event) async {
    final message = '''
📅 *${event.title}*
📝 ${event.description}
📍 ${event.location}
🕒 ${event.fullDateTime}
🙏 ¡Te esperamos!

Compartido desde App Biblia Palabra de Vida
''';
    await SharePlus.instance.share(ShareParams(text: message));
  }

  void _shareWhatsApp(EventModel event) async {
    final message = '''
*${event.title}*
${event.description}
📍 ${event.location}
🕒 ${event.fullDateTime}
¡Te esperamos! 🙏''';

    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl = "https://wa.me/?text=$encodedMessage";

    try {
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        _shareEvent(event);
      }
    } catch (e) {
      _shareEvent(event);
    }
  }

  void _addToCalendar(EventModel event) {
    final calendarEvent = Event(
      title: event.title,
      description: event.description,
      location: event.location,
      startDate: DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
        int.parse(event.timeStart.split(':')[0]),
        int.parse(event.timeStart.split(':')[1].split(' ')[0]),
      ),
      endDate: DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
        int.parse(event.timeEnd.split(':')[0]),
        int.parse(event.timeEnd.split(':')[1].split(' ')[0]),
      ),
      allDay: false,
    );
    Add2Calendar.addEvent2Cal(calendarEvent);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Evento agregado al calendario')),
    );
  }

  void _confirmAttendance(EventModel event) async {
    setState(() {
      event.userConfirmed = !event.userConfirmed;
      if (event.userConfirmed) {
        confirmedEvents.add(event.id);
      } else {
        confirmedEvents.remove(event.id);
      }
    });

    // Aquí enviar confirmación al backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          event.userConfirmed
              ? '¡Confirmaste tu asistencia a ${event.title}!'
              : 'Cancelaste tu asistencia a ${event.title}',
        ),
        backgroundColor: event.userConfirmed ? Colors.green : Colors.orange,
      ),
    );
  }

  String _getTypeIcon(String type) {
    switch (type) {
      case 'culto':
        return '⛪';
      case 'reunion':
        return '👥';
      case 'capacitacion':
        return '📚';
      case 'social':
        return '🎉';
      default:
        return '📅';
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'culto':
        return Colors.purple;
      case 'reunion':
        return Colors.blue;
      case 'capacitacion':
        return Colors.orange;
      case 'social':
        return Colors.green;
      default:
        return StyleColor.turquoise;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StyleColor.turquoise,
        title: const Text(
          'Calendario de Eventos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filtros de tipo (chip)
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: eventTypes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final type = eventTypes[index];
                final isSelected = selectedType == type['value'];
                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(type['icon'], size: 16),
                      const SizedBox(width: 4),
                      Text(type['label']),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => _filterByType(type['value']),
                  backgroundColor: Colors.grey.shade200,
                  selectedColor: StyleColor.turquoise.withOpacity(0.2),
                  checkmarkColor: StyleColor.turquoise,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? StyleColor.turquoise
                        : Colors.grey.shade700,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              },
            ),
          ),

          // Filtro por mes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _selectMonth,
                  icon: const Icon(Icons.calendar_month),
                  label: Text(
                    selectedMonth == null
                        ? 'Todos los meses'
                        : '${_getMonthName(selectedMonth!.month)} ${selectedMonth!.year}',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: StyleColor.turquoise,
                    elevation: 1,
                  ),
                ),
                if (selectedMonth != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _clearMonthFilter,
                    icon: const Icon(Icons.close),
                    color: Colors.red,
                    tooltip: 'Limpiar filtro de mes',
                  ),
                ],
                const Spacer(),
                if (filteredEvents.isNotEmpty)
                  Text(
                    '${filteredEvents.length} eventos',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),

          // Buscador
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextFormField(
              readOnly: listEvent.isEmpty || loading,
              controller: searchTextController,
              style: StylesApp(context).textStyleSmallBlack,
              decoration:
                  StylesApp(context).inputDecorationOutlineStyle.copyWith(
                        hintText: "Buscar evento por nombre o descripción...",
                        hintStyle: StylesApp(context)
                            .textStyleBody14
                            .copyWith(color: StyleColor.grayMedium),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        suffixIcon: searchText.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: cleanSearch,
                              )
                            : null,
                      ),
              onChanged: _onSearchChanged,
            ),
          ),

          // Lista de eventos
          Expanded(
            child: filteredEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy,
                            size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'No hay eventos para mostrar',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Prueba con otros filtros',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return _buildEventCard(event);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(EventModel event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera con tipo y fecha
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getTypeColor(event.type).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getTypeColor(event.type),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_getTypeIcon(event.type)),
                      const SizedBox(width: 4),
                      Text(
                        event.type.toUpperCase(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(Icons.calendar_today,
                    size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  event.formattedDate,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Descripción
                Text(
                  event.description,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
                const SizedBox(height: 12),

                // Ubicación
                Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Horario
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${event.timeStart} - ${event.timeEnd}',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),

                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Compartir WhatsApp
                    _buildActionButton(
                      icon: Icons.message,
                      label: 'WhatsApp',
                      color: Colors.green,
                      onPressed: () => _shareWhatsApp(event),
                    ),

                    // Agregar a calendario
                    _buildActionButton(
                      icon: Icons.calendar_today,
                      label: 'Calendario',
                      color: Colors.blue,
                      onPressed: () => _addToCalendar(event),
                    ),

                    // Confirmar asistencia
                    _buildActionButton(
                      icon: event.userConfirmed
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      label: event.userConfirmed ? 'Confirmado' : 'Asistiré',
                      color: event.userConfirmed ? Colors.green : Colors.orange,
                      onPressed: () => _confirmAttendance(event),
                    ),

                    // Compartir general
                    _buildActionButton(
                      icon: Icons.share,
                      label: 'Compartir',
                      color: Colors.purple,
                      onPressed: () => _shareEvent(event),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return months[month - 1];
  }
}
