import 'dart:math';

import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart' as animation;

class RewardWidget extends StatefulWidget {
  final Reward? rewardInfo;
  final void Function()? onPressed;
  const RewardWidget({super.key, this.rewardInfo, this.onPressed});

  @override
  State<RewardWidget> createState() => _RewardWidgetState();
}

class _RewardWidgetState extends State<RewardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
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
    // Material + SizedBox.expand garantiza constraints finitos
    // sin necesidad de un Scaffold anidado.
    return Material(
      color: StyleColor.turquoise,
      child: SizedBox.expand(
        child: Stack(
          children: [
            // Fondo con partículas (ocupa todo el espacio)
            Positioned.fill(
              child: _buildParticleBackground(),
            ),

            // Contenido principal centrado y con scroll seguro
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // ← CLAVE
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/rewardObtained.gif',
                        width: 200,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        textAlign: TextAlign.center,
                        widget.rewardInfo?.title ?? '',
                        softWrap: true,
                        style: StylesApp(context)
                            .textStyleBody20
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        textAlign: TextAlign.center,
                        widget.rewardInfo?.description ?? '',
                        style: StylesApp(context)
                            .textStyleBody12
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      Text.rich(
                        textAlign: TextAlign.center,
                        style: StylesApp(context)
                            .textStyleBody18
                            .copyWith(color: Colors.white),
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${widget.rewardInfo?.earnedExperience ?? 0} Exp.  ',
                            ),
                            TextSpan(
                              text:
                                  '${widget.rewardInfo?.earnedEnergy ?? 0} LMS',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ButtonThemeWidget(
                        text: "Continuar",
                        width: 132.0,
                        height: 32.0,
                        buttonStyle: StylesApp(context).btnWidgetSmall,
                        onPressed: widget.onPressed,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fondo con partículas animadas
  Widget _buildParticleBackground() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: ParticlePainter(_controller.value),
        );
      },
    );
  }
}

// ───────────────────────────────────────────────────────────
// Painter optimizado: partículas con posición estable
// ───────────────────────────────────────────────────────────
class ParticlePainter extends CustomPainter {
  final double progress; // 0.0 → 1.0

  // Partículas pre-generadas UNA SOLA VEZ.
  // Así no "parpadean" en cada frame.
  static final List<_Particle> _particles = _generateParticles();

  ParticlePainter(this.progress);

  static List<_Particle> _generateParticles() {
    final rnd = Random(42); // semilla fija = reproducible
    return List.generate(70, (_) {
      return _Particle(
        x: rnd.nextDouble(),          // 0..1 (fracción del ancho)
        y: rnd.nextDouble(),          // 0..1 (fracción del alto)
        radius: 1.0 + rnd.nextDouble() * 3.0,
        speed: 0.05 + rnd.nextDouble() * 0.15,
        alpha: 0.2 + rnd.nextDouble() * 0.6,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      // Mueve la partícula hacia abajo de forma continua (wrap-around)
      final dy = (p.y + progress * p.speed) % 1.0;
      final offset = Offset(p.x * size.width, dy * size.height);

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: p.alpha);

      canvas.drawCircle(offset, p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    // Solo repinta si el progreso cambió realmente
    return oldDelegate.progress != progress;
  }
}

class _Particle {
  final double x;      // 0..1
  final double y;      // 0..1
  final double radius;
  final double speed;  // qué tan rápido cae
  final double alpha;

  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.alpha,
  });
}