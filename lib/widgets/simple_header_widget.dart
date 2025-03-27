import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class SimpleHeaderWidget extends StatelessWidget {
  final String title;
  final Color background;
  final IconData icon;
  final Color iconColor;
  final Color iconBackColor;
  final void Function()? onRoute;
  const SimpleHeaderWidget({
    super.key,
    required this.title,
    this.icon = Icons.arrow_back,
    this.onRoute,
    this.background = StyleColor.turquoise,
    this.iconColor = Colors.white,
    this.iconBackColor = StyleColor.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 44.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      width: double.infinity,
      decoration: BoxDecoration(color: background //StyleColor.turquoise
          ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 10,
            child: Container(
              width: 32.0,
              height: 32.0,
              decoration: BoxDecoration(
                  color: iconBackColor, // StyleColor.orange,
                  borderRadius: BorderRadius.circular(32.0)),
              child: Center(
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  iconSize: 30.0,
                  onPressed: onRoute,
                  icon: Icon(
                    icon,
                    //  Icons.arrow_back,
                    size: 30,
                    color: iconColor,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: StylesApp(context).textStyleBody7,
            ),
          )
        ],
      ),
    );
  }
}