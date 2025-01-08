import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class CurrentMonthCalendarWidget extends StatefulWidget {
  const CurrentMonthCalendarWidget({super.key});

  @override
  State<CurrentMonthCalendarWidget> createState() =>
      _CurrentMonthCalendarWidgetState();
}

class _CurrentMonthCalendarWidgetState
    extends State<CurrentMonthCalendarWidget> {
  @override
  Widget build(BuildContext context) {
    DateTime registrationDate = DateTime(2023, 7, 1); // Fecha de registro
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month);
    DateTime displayedMonth = currentDate;
    DateTime lastDate = registrationDate.add(Duration(days: 365 * 5));
    List datesWithImage = [
      DateTime(2025, 01, 01),
      DateTime(2025, 01, 04),
      DateTime(2025, 01, 05),
      DateTime(2025, 01, 06),
      DateTime(2025, 01, 07),
      DateTime(2025, 01, 08),
      DateTime(2025, 01, 10),
      DateTime(2025, 01, 11),
    ];

    if (currentDate.isBefore(registrationDate)) {
      currentDate = registrationDate;
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        void previousMonth() {
          if (displayedMonth.isAfter(registrationDate)) {
            setState(() {
              displayedMonth =
                  DateTime(displayedMonth.year, displayedMonth.month - 1);
            });
          }
        }

        void nextMonth() {
          if (displayedMonth
              .isBefore(registrationDate.add(Duration(days: 365 * 5)))) {
            setState(() {
              displayedMonth =
                  DateTime(displayedMonth.year, displayedMonth.month + 1);
            });
          }
        }

        int daysInMonth =
            DateTime(displayedMonth.year, displayedMonth.month + 1, 0).day;
        List<Widget> dayWidgets = [];

        for (int i = 1; i <= daysInMonth; i++) {
          dayWidgets.add(
            Container(
              height: 26,
              width: 26.0,
              margin: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                // border: Border.all(width: 1)
              ),
              child: Stack(
                children: [
                  if (datesWithImage.contains(DateTime(
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
                          "/fire_rachaActive.png",
                          fit: BoxFit.fitHeight,
                          height: 50,
                          width: 50,
                        ),
                      ),
                    )
                  } else if (DateTime(
                              displayedMonth.year, displayedMonth.month, i)
                          .isAfter(datesWithImage.first) &&
                      DateTime(displayedMonth.year, displayedMonth.month, i)
                          .isBefore(datesWithImage.last)) ...{
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.asset(
                          "/fire_rachaInactive.png",
                          fit: BoxFit.fitHeight,
                          height: 50,
                          width: 50,
                        ),
                      ),
                    )
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
                                  displayedMonth.isAfter(registrationDate)
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
                          horizontal: 22.0, vertical: 5),
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
