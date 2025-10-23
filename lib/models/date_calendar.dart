class DateCalendar {
  List<DateTime> playDay;
  List<DateTime> protectedStreak;
  String? lostStreak;
  int currentStreak;
int longestStreak;

  DateCalendar({
    required this.playDay,
    required this.protectedStreak,
    this.lostStreak,
    this.currentStreak = 0,
    this.longestStreak = 0,
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
          longestStreak: json['longestStreak'] ?? 0,
          currentStreak: json['currentStreak'] ?? 0,
          lostStreak: json['lostStreak']

    );

  }
}
