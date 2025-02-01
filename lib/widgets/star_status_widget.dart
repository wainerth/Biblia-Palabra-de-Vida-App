import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StarStatusWidget extends StatefulWidget {
  final double unLockLevel;
  final double containerWidth;
  const StarStatusWidget({
    super.key,
    required this.unLockLevel,
    required this.containerWidth,
  });

  @override
  State<StarStatusWidget> createState() => _StarStatusWidgetState();
}

class _StarStatusWidgetState extends State<StarStatusWidget> {
  @override
  Widget build(BuildContext context) {
    final starSize = 30.sp;
    return SizedBox(
      width:  widget.containerWidth,
      child: Center(
        child: SizedBox(
          height: 50.0,
          child: Stack(
            children: [
              if (widget.unLockLevel > 99) ...[
               
                Positioned(
                  top: 10,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(),
                    child: Image.asset(
                      "assets/star-shadow.png",
                      width: starSize,
                      height: starSize,
                    ),
                  ),
                ),
                Positioned(
                  top: -30,
                  left:
                      0, //(widget.containerWidth - starSize) / 2, //starSpacing + starSize + starSpacing,
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    "assets/star-shadow.png",
                    width: starSize,
                    height: starSize,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: widget
                      .containerWidth - starSize, //starSpacing + (2 * starSize) + (2 * starSpacing),
                  child: Image.asset(
                    "assets/star-shadow.png",
                    width: starSize,
                    height: starSize,
                  ),
                ),
              ] else if (widget.unLockLevel > 50) ...[
                Positioned(
                  top: 10,
                  left: 0.0,
                  child: Image.asset(
                    "assets/star-shadow-medium.png",
                    width: starSize,
                    height: starSize,
                  ),
                ),
                Positioned(
                  top: -20,
                  left: 0, //(widget.containerWidth - starSize) / 2,
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    "assets/star-shadow-medium.png",
                    width: starSize,
                    height: starSize,
                  ),
                ),
              ] else if (widget.unLockLevel > 0) ...[
                Positioned(
                  top: 10,
                  left: 0.0,
                  child: Image.asset(
                    "assets/star_incomplete.png",
                    width: starSize,
                    height: starSize,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
