// streak_service.dart
import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/models/date_calendar.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class StreakService {
  static void showStreakCelebration({
    required BuildContext context,
    required DateCalendar streakCalendar,
    VoidCallback? onSeeDetails,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => StreakCelebrationDialog(
        streakCalendar: streakCalendar,
        onSeeDetails: onSeeDetails,
      ),
    );
  }

  static Future<bool> shouldShowCelebration() async {
    // Verificar si es la primera vez que juega hoy
    final lastPlayDate = await PreferencesManager().getLastPlayDate();
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastPlayDate != today) {
      await PreferencesManager().setLastPlayDate(today);
      return true;
    }

    return false;
  }
}
