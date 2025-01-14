import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class CustomModalWidget extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;

  const CustomModalWidget({
    super.key,
    required this.title,
    required this.content,
    this.buttonText = 'Aceptar',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left : 12.0, right: 12.0, top : 0.0, bottom: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              spacing: 10.0,
              children: [
                SizedBox(
                  height: 28.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0XFF739EC7),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Text(
                    title,
                    style: StylesApp(context).textStyleBody8,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      color: Color(0XFF566CB2),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        spacing: 8,
                        children: [
                          Column(
                            spacing: 8,
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: Color(0XFFF4C622),
                                      borderRadius: BorderRadius.circular(28)),
                                  child: Text(
                                    "Etapa 1",
                                    style: StylesApp(context).textStyleBody4,
                                  )),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: Color(0XFFF4C622),
                                      borderRadius: BorderRadius.circular(28)),
                                  child: Text("12 / 12",
                                      style: StylesApp(context).textStyleBody4)),
                            ],
                          ),
                          Expanded(
                            child: Text(
                              softWrap: true,
                              "Introducción nuevo testamento",
                              style: StylesApp(context)
                                  .textStyleBody4
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 18.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Sombra
                  ),
                ],
              ),
              height: 286,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 9.0),
                  child: ListBody(
                    children: [
                      Text(
                        content,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Center(
              child: ButtonThemeWidget(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Aceptar",
                buttonStyle: StylesApp(context).btnWidgetSmall,
                textStyle: StylesApp(context).textStyleBody6,
              ),
            ),
            SizedBox(height: 20.0,)
          ],
        ),
      ),
      // contentPadding: EdgeInsets.zero,
    );
  }
}
