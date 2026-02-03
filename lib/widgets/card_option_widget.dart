import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardOptionWidget extends StatelessWidget {
  final String imageBackground;
  final String labelCard;
  final List<Color> gradientColors;
  const CardOptionWidget({
    super.key,
    required this.imageBackground,
    required this.labelCard,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
            minHeight: MediaQuery.sizeOf(context).width > 400 ? 120 : 40.sp,
            maxWidth: 170.0.sp),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Image.asset(
                imageBackground,
                fit: BoxFit.cover,
                height: 50,
              ),
            ),
            Center(
              child: Text(
                labelCard,
                textAlign: TextAlign.center,
                style: StylesApp(context).textStyleBody16,
              ),
            ),
          ],
        ));
  }
}
