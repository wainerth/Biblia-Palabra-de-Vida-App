import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class InfiniteAnimation extends StatefulWidget {
  final double coordTop;
  final double coordLeft;
  final int j;
  final int index;
  const InfiniteAnimation(
      {super.key,
      required this.coordTop,
      required this.coordLeft,
      required this.j,
      required this.index});
  @override
  State<InfiniteAnimation> createState() => _InfiniteAnimationState();
}

class _InfiniteAnimationState extends State<InfiniteAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Variables para las coordenadas y el índice
  List<String> imageBarcos = [
    "assets/barcos/barco1.png",
    "assets/barcos/barco2.png",
    "assets/barcos/barco3.png",
    "assets/barcos/barco4.png",
    "assets/barcos/barco5.png",
    "assets/barcos/barco6.png",
    "assets/barcos/barco7.png",
    "assets/barcos/barco8.png",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat(
        reverse: true); // Repite la animación en reversa para un bucle continuo

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        double value = _animation.value;
        double verticalOffset = (widget.j % 2 == 0 ? 10 : -10) * value;
        double horizontalOffset = (widget.j % 2 == 0 ? 30 : -30) * value;
        return Positioned(
          top: widget.index % 2 == 0
              ? StylesApp(context).positionedLevels(widget.coordTop).dy +
                  verticalOffset
              : StylesApp(context).positionedLevels(widget.coordTop).dy +
                  verticalOffset,
          left: widget.index % 2 == 0
              ? StylesApp(context).positionedLevels(widget.coordLeft).dx +
                  horizontalOffset
              : StylesApp(context).positionedLevels(widget.coordLeft).dx +
                  horizontalOffset,
          child: SizedBox(
            width: 40,
            child: Image.asset(
              imageBarcos[widget.j],
              width: double.infinity,
              height: 60,
              fit: BoxFit.fill,
            ),
          ),
        );
      },
    );
  }
}
