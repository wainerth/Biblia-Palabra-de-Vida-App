import 'dart:convert';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CurrentMonthCalendarWidget extends StatefulWidget {
  final DateTime registrationDate;
  const CurrentMonthCalendarWidget({super.key, required this.registrationDate});

  @override
  State<CurrentMonthCalendarWidget> createState() =>
      _CurrentMonthCalendarWidgetState();
}

class _CurrentMonthCalendarWidgetState
    extends State<CurrentMonthCalendarWidget> {
  String? errorMessage;
  DateCalendar? dayProtectedStreak;
  late DateTime displayedMonth;
  late DateTime lastDate;
  int daysInMonth = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    lastDate = widget.registrationDate.add(Duration(days: 365 * 5));

    // Inicializar con el mes actual o fecha de registro si es posterior
    displayedMonth = now.isBefore(widget.registrationDate)
        ? widget.registrationDate
        : DateTime(now.year, now.month);

    _updateDaysInMonth();
    _generateData();
  }

  void _updateDaysInMonth() {
    daysInMonth =
        DateTime(displayedMonth.year, displayedMonth.month + 1, 0).day;
  }

  Future<void> _generateData() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      final userProvider = context.read<UserProvider>();
      final userData = userProvider.currentUser;

      final response =
          await streaksCalendar(userData!.userId, displayedMonth.month);

      if (response.error != null) {
        errorMessage = response.error;
      } else {
        dayProtectedStreak =
            DateCalendar.fromJson(removeTypename(response.data));
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> previousMonth() async {
    final newMonth = DateTime(displayedMonth.year, displayedMonth.month - 1);

    if (newMonth.isAfter(widget.registrationDate) ||
        newMonth.isAtSameMomentAs(widget.registrationDate)) {
      setState(() {
        displayedMonth = newMonth;
        _updateDaysInMonth();
      });
      await _generateData();
    }
  }

  Future<void> nextMonth() async {
    final newMonth = DateTime(displayedMonth.year, displayedMonth.month + 1);

    if (newMonth.isBefore(lastDate)) {
      setState(() {
        displayedMonth = newMonth;
        _updateDaysInMonth();
      });
      await _generateData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationProvider = context.watch<AppTranslationProvider>();

    final dayWidgets = List.generate(daysInMonth, (index) {
      final day = index + 1;
      final currentDate =
          DateTime(displayedMonth.year, displayedMonth.month, day);

      final hasPlayDay =
          dayProtectedStreak?.playDay.any((d) => _isSameDay(d, currentDate)) ??
              false;

      final hasProtectedStreak = dayProtectedStreak?.protectedStreak
              .any((d) => _isSameDay(d, currentDate)) ??
          false;

      return Container(
        height: 26.0,
        width: 26.0,
        margin: const EdgeInsets.all(0.0),
        child: Stack(
          children: [
            if (hasPlayDay)
              Positioned.fill(
                child: Image.asset(
                  "assets/fire_rachaActive.png",
                  fit: BoxFit.fitHeight,
                ),
              ),
            if (hasProtectedStreak)
              Positioned.fill(
                child: Image.asset(
                  "assets/fire_rachaInactive.png",
                  fit: BoxFit.fitHeight,
                ),
              ),
            Center(
              child: Text(
                day.toString(),
                style: StylesApp(context).textStyleBody6,
              ),
            ),
          ],
        ),
      );
    });

    return Container(
      margin: const EdgeInsets.all(7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translationProvider.tr('current_month_calendar.constancy'),
            style: StylesApp(context).textStyCalendar,
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0XFF12CBC4),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      left: 10,
                      top: 0,
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 20.0,
                          icon: const Icon(Icons.arrow_back),
                          onPressed: _isLoading ? null : previousMonth,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '${_getNameMonth(displayedMonth, translationProvider)} ${displayedMonth.year}',
                          style: StylesApp(context).textStyCalendarWhite,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 0,
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 20.0,
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: _isLoading ? null : nextMonth,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22.0,
                    vertical: 8.0,
                  ),
                  child: GridView.count(
                    crossAxisCount: 7,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: dayWidgets,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getNameMonth(
      DateTime date, AppTranslationProvider translationProvider) {
    final monthsString =
        translationProvider.tr('current_month_calendar.months');

    // Si el string es null o está vacío, usar fallback
    if (monthsString == null || monthsString.isEmpty) {
      return _getMonthFallback(translationProvider, date.month);
    }

    // Parsear el string a lista
    final monthList = _parseMonthString(monthsString);

    // Si la lista es válida y tiene el mes solicitado, devolverlo
    if (monthList.isNotEmpty && monthList.length >= date.month) {
      return monthList[date.month - 1];
    }

    // Fallback
    return _getMonthFallback(translationProvider, date.month);
  }

  List<String> _parseMonthString(String monthsString) {
    try {
      // Limpiar el string
      String clean = monthsString
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll('...', '')
          .trim();

      // Si el string está vacío después de limpiar
      if (clean.isEmpty) return [];

      // Dividir por comas y limpiar cada elemento
      return clean
          .split(',')
          .map((month) => month.trim().replaceAll("'", '').replaceAll('"', ''))
          .where((month) => month.isNotEmpty) // Filtrar elementos vacíos
          .toList();
    } catch (e) {
      debugPrint('Error parseando string de meses: $e');
      return [];
    }
  }

  String _getMonthFallback(AppTranslationProvider provider, int month) {
    // Obtener idioma actual
    final lang = provider.currentLanguage ?? 'es';

    // Mapa de fallback
    const Map<String, List<String>> monthsByLang = {
      'en': [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
      ],
      'es': [
        "Enero",
        "Febrero",
        "Marzo",
        "Abril",
        "Mayo",
        "Junio",
        "Julio",
        "Agosto",
        "Septiembre",
        "Octubre",
        "Noviembre",
        "Diciembre"
      ],
      'fr': [
        "Janvier",
        "Février",
        "Mars",
        "Avril",
        "Mai",
        "Juin",
        "Juillet",
        "Août",
        "Septembre",
        "Octobre",
        "Novembre",
        "Décembre"
      ],
      'pt': [
        "Janeiro",
        "Fevereiro",
        "Março",
        "Abril",
        "Maio",
        "Junho",
        "Julho",
        "Agosto",
        "Setembro",
        "Outubro",
        "Novembro",
        "Dezembro"
      ],
    };

    return monthsByLang[lang]?[month - 1] ?? "Month $month";
  }
}
