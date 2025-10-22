// streak_celebration_dialog.dart
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/services/audio_service.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';

class StreakCelebrationDialog extends StatefulWidget {
  final DateCalendar streakCalendar;
  final VoidCallback? onSeeDetails;

  const StreakCelebrationDialog({
    super.key,
    required this.streakCalendar,
    this.onSeeDetails,
  });

  @override
  State<StreakCelebrationDialog> createState() =>
      _StreakCelebrationDialogState();
}

class _StreakCelebrationDialogState extends State<StreakCelebrationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  AudioService audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Reproducir sonido y animación
    audioService.playSuccessSound();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    audioService.stopSuccessSound();
    audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(children: [
            _buildContent(),
            Positioned(
              top: 10,
              right: 0,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close_rounded),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono de fuego animado
          _buildFireIcon(),
          SizedBox(height: 16),

          // Título de felicitación
          _buildTitle(),
          SizedBox(height: 16),

          // Calendario de la semana
          _buildWeekCalendar(),
          SizedBox(height: 24),

          // Estadísticas de racha
          _buildStreakStats(),
          SizedBox(height: 24),

        ],
      ),
    );
  }

  Widget _buildFireIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        // color: StyleColor.black,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Stack(children: [
          Positioned(
            top: 32,
            left: 20,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
          ),
          Image.asset(
            "assets/comingSoon.gif",
          ),
        ]),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          '¡Felicidades! 🎉',
          style: StylesApp(context).textStyleBody24.copyWith(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
        ),
        SizedBox(height: 8),
        Text("${widget.streakCalendar?.currentStreak}",
            style: StylesApp(context).textStyleBody32.copyWith(
                  color: StyleColor.orange,
                )),
        Text(
          "días de Racha",
          style: StylesApp(context).textStyleBody16.copyWith(
                color: Color(0xFF718096),
              ),
        ),
      ],
    );
  }

  Widget _buildWeekCalendar() {
    final today = DateTime.now();
    final weekDays = _getCurrentWeek();
    ScrollController scrollController = ScrollController();
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      thickness: 8.0,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          decoration: BoxDecoration(
            color: StyleColor.turquoise,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            spacing: 4.0,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((day) {
              final isPlayed = widget.streakCalendar.playDay.any((playDay) =>
                  playDay.year == day.year &&
                  playDay.month == day.month &&
                  playDay.day == day.day);
              final isToday = _isSameDay(day, today);

              return _buildDayCell(day, isPlayed, isToday);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime day, bool isPlayed, bool isToday) {
    return Column(
      children: [
        Text(
          _getDayAbbreviation(day.weekday),
          style: StylesApp(context).textStyleBody12.copyWith(
                fontSize: 12,
                color: StyleColor.white,
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 8),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isToday
                ? StyleColor.orange
                : isPlayed
                    ? Color(0xFF48BB78)
                    : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isPlayed
                ? Image.asset(
                    'assets/fire_rachaActive.png',
                    width: 30,
                    height: 30,
                  )
                : Text(
                    day.day.toString(),
                    style: StylesApp(context).textStyleBody14.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          'Racha Actual',
          '${widget.streakCalendar?.currentStreak} días',
          Icons.local_fire_department,
          StyleColor.orange,
        ),
        _buildStatItem(
          'Récord',
          '${widget.streakCalendar.longestStreak} días',
          Icons.emoji_events,
          Color(0xFFFFD700),
        ),
      ],
    );
  }

  Widget _buildStatItem(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: StylesApp(context).textStyleBody12.copyWith(
                // fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: StylesApp(context).textStyleBody12.copyWith(
                fontSize: 12,
                color: Color(0xFF718096),
              ),
        ),
      ],
    );
  }

  // Métodos auxiliares
  List<DateTime> _getCurrentWeek() {
    final today = DateTime.now();
    final firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));

    return List.generate(
        7, (index) => firstDayOfWeek.add(Duration(days: index)));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getDayAbbreviation(int weekday) {
    final abbreviations = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    return abbreviations[weekday - 1];
  }
}
