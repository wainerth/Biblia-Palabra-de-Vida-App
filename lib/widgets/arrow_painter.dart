import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 47, 13, 196)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);

    // Sombra para la flecha
    final shadowPath = Path();
    shadowPath.moveTo(0, 0);
    shadowPath.lineTo(size.width / 2, size.height);
    shadowPath.lineTo(size.width, 0);

    canvas.drawShadow(shadowPath, Colors.black12, 2, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
