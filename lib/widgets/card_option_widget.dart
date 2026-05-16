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
      padding: EdgeInsets.all(8.0),
        constraints: BoxConstraints(
            minHeight: MediaQuery.sizeOf(context).width > 400 ? 70 : 45,
            maxWidth: 170.0.sp),
        width: double.infinity,
        
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage('assets/background_player.jpg'),
          //   fit: BoxFit.cover,
          //   opacity: 0.25),
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
                fit: BoxFit.fitHeight,
                height: 40,
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
