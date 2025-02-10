import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class BuildErrorWidget extends StatelessWidget {
  final String errorMessage;
  final void Function()? onRetry;
  final void Function()? onBack;
  const BuildErrorWidget(
      {super.key, required this.errorMessage, this.onRetry, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              errorMessage ?? "Failed to load stages.",
                style: TextStyle(color: Colors.red)),
            SizedBox(height: 10),
            ButtonThemeWidget(
              buttonStyle: StylesApp(context).btnWidgetSmall,
              text: "Reintentar",
              onPressed: onRetry,
            ),
            ButtonThemeWidget(
              text: "volver",
              buttonStyle: StylesApp(context).btnWidgetSmall,
              onPressed: onBack,
            ),
          ],
        ),
      ),
    );
  }
}
