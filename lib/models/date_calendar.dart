class DateCalendar {
  List<DateTime> playDay;
  List<DateTime> protectedStreak;

  DateCalendar({
    required this.playDay,
    required this.protectedStreak,
  });
  factory DateCalendar.fromJson(Map<String, dynamic> json) {
    return DateCalendar(
      playDay: (json['playDay'] as List<dynamic>)
          .map((dateString) => DateTime.parse(dateString))
          .toList(),
      protectedStreak: (json['protectedStreak'] as List<dynamic>)
          .map((dateString) => DateTime.tryParse(dateString))
          .whereType<DateTime>() // Filter out nulls if any date string is invalid
          .toList(),
    );

  }
}
