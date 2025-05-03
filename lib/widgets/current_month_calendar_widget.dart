import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
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
  late DateTime displayedMonth; // Mueve displayedMonth aquí
  // late DateTime registrationDate;
  late DateTime lastDate;
  int daysInMonth = 0;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month);
    // registrationDate = DateTime(2023, 7, 1); // Fecha de registro
    lastDate = widget.registrationDate.add(Duration(days: 365 * 5));

    if (currentDate.isBefore(widget.registrationDate)) {
      displayedMonth = widget.registrationDate;
    } else {
      displayedMonth = currentDate;
    }
    daysInMonth =
        DateTime(displayedMonth.year, displayedMonth.month + 1, 0).day;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateData(context);
    });
  }

  Future<void> _generateData(BuildContext context) async {
    LoadingService().showLoading(context);
    DateTime now = DateTime.now();
    try {
      setState(() {});
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final LoginUser? userData = userProvider.currentUser;
      final responseStreakCalendar =
          await streaksCalendar(userData!.user.id, now.month);
      if (responseStreakCalendar.error != null) {
        errorMessage = responseStreakCalendar.error;
      }
      setState(() {
        dayProtectedStreak =
            DateCalendar.fromJson(removeTypename(responseStreakCalendar.data));
      });
      // dayProtectedStreak = responseStreakCalendar.data["protectedStreak"];
    } catch (e) {
      setState(() {
      errorMessage = e as String?;
        
      });
    } finally {
      LoadingService().hideLoading();
    }
  }

  loadStreak(month) async {
    dayProtectedStreak = null;
    LoadingService().showLoading(context);
    try {
      setState(() {});
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final LoginUser? userData = userProvider.currentUser;
      final responseStreakCalendar =
          await streaksCalendar(userData!.user.id, month);
      if (responseStreakCalendar.error != null) {
        errorMessage = responseStreakCalendar.error;
      }
      setState(() {
        dayProtectedStreak =
            DateCalendar.fromJson(removeTypename(responseStreakCalendar.data));
      });
    } catch (e) {
      print(e);
    } finally {
      LoadingService().hideLoading();
    }
  }

  @override
  Widget build(BuildContext context) {

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        void previousMonth() async {
          if (displayedMonth.isAfter(widget.registrationDate)) {
            setState(() {
              displayedMonth =
                  DateTime(displayedMonth.year, displayedMonth.month - 1);
            });
          }
          await loadStreak(displayedMonth.month);
        }

        void nextMonth() async {
          if (displayedMonth
              .isBefore(widget.registrationDate.add(Duration(days: 365 * 5)))) {
            setState(() {
              displayedMonth =
                  DateTime(displayedMonth.year, displayedMonth.month + 1);
              print(displayedMonth.month);
              // loadStreak(displayedMonth.month);
            });
            await loadStreak(displayedMonth.month);
          }
        }

        List<Widget> dayWidgets = [];

        for (int i = 1; i <= daysInMonth; i++) {
          dayWidgets.add(
            Container(
              height: 26.0,
              width: 26.0,
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                // border: Border.all(width: 1)
              ),
              child: Stack(
                children: [
                  if (dayProtectedStreak != null) ...{
                    if (dayProtectedStreak!.playDay.contains(DateTime(
                        displayedMonth.year, displayedMonth.month, i))) ...{
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.asset(
                            "assets/fire_rachaActive.png",
                            fit: BoxFit.fitHeight,
                            height: 40,
                            width: 40,
                          ),
                        ),
                      )
                    },
                    if (dayProtectedStreak!.protectedStreak.contains(DateTime(
                        displayedMonth.year, displayedMonth.month, i))) ...{
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.asset(
                            "assets/fire_rachaInactive.png",
                            fit: BoxFit.fitHeight,
                            height: 40,
                            width: 40,
                          ),
                        ),
                      )
                    },
                  },
                  Center(
                    child: Text(
                      i.toString(),
                      style: StylesApp(context).textStyleBody6,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          margin: EdgeInsets.all(7.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Constancia",
                style: StylesApp(context).textStyCalendar,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0XFF12CBC4),
                    borderRadius: BorderRadius.circular(8.0)),
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
                              padding: EdgeInsets.all(0),
                              iconSize: 25.0,
                              disabledColor: Colors.grey,
                              icon: Icon(
                                Icons.arrow_back,
                                size: 20,
                              ),
                              onPressed:
                                  displayedMonth.isAfter(widget.registrationDate)
                                      ? previousMonth
                                      : null,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_getNameMonth(DateTime(displayedMonth.year, displayedMonth.month + 1, 0))} - ${displayedMonth.year}',
                              style: StylesApp(context).textStyCalendarWhite,
                            ),
                          ],
                        ),
                        Positioned(
                          right: 10,
                          top: 0,
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              iconSize: 25.0,
                              disabledColor: Colors.grey,
                              icon: Icon(
                                Icons.arrow_forward,
                                size: 20,
                              ),
                              onPressed: displayedMonth.isBefore(lastDate)
                                  ? nextMonth
                                  : null,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22.0, vertical: 0),
                      child: GridView.count(
                        crossAxisCount: 7,
                        shrinkWrap: true,
                        children: dayWidgets,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getNameMonth(DateTime dateTime) {
    List<String> months = [
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
    ];
    return months[dateTime.month - 1];
  }
}
