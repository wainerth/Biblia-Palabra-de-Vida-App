import 'dart:math';

import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart' as animation;


class RewardWidget extends StatefulWidget {
  @override
  _RewardWidgetState createState() => _RewardWidgetState();
}

class _RewardWidgetState extends State<RewardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StyleColor.turquoise,
      body: Stack(
        children: [
          // Fondo con partículas
          Positioned.fill(child: _buildParticleBackground()),

          // Contenido principal
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icono de recompensa
                Icon(
                  Icons.star,
                  size: 100,
                  color: Colors.yellow,
                ),

                SizedBox(height: 20),

                // Mensaje de recompensa
                Text(
                  '¡Recompensa Obtenida!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  '¡Has ganado un premio!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                  ButtonThemeWidget(
                text: "Continuar",
                width: 132.0,
                height: 32.0,
                buttonStyle: StylesApp(context).btnWidgetSmall,
                onPressed: () {
                  // if (sendScore!.titleUnlocked) {
                  //   setState(() {
                  //     showStepCompleted = false;
                  //     showAchievementUnlocked = true;
                  //   });
                  // } else if (sendScore!.isLastLevel) {
                  //   setState(() {
                  //     showStepCompleted = false;
                  //     showAchievementUnlocked = false;
                  //     showLastStageCompleted = true;
                  //   });
                  // } else {
                  //   Navigator.popAndPushNamed(context, '/mapPage', arguments: {
                  //     'courseId': courseId,
                  //     'sectionId': sectionId
                  //   });
                  // }
                },
              )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fondo con partículas animadas
  Widget _buildParticleBackground() {
    return animation.LoopAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 5),
      builder: (context, value, child) {
        return CustomPaint(
          painter: ParticlePainter(value, _controller),
        );
      },
    );
  }
}

// Pintor de partículas personalizadas
class ParticlePainter extends CustomPainter {
  final double progress;
  final AnimationController controller;

  ParticlePainter(this.progress, this.controller);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final paint = Paint()..color = const Color.fromARGB(255, 252, 248, 248).withOpacity(0.5);

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Animación de partículas con movimiento
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 5;
      final offset = Offset(x, y + controller.value * 50);

      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}