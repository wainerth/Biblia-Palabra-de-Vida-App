import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class DetailRequestScreen extends StatefulWidget {
  const DetailRequestScreen({super.key});

  @override
  State<DetailRequestScreen> createState() => _DetailRequestScreenState();
}

class _DetailRequestScreenState extends State<DetailRequestScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showModal(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: StyleColor.turquoise,
          ),
          child: Column(
            children: [
              HeadScreenNotAvatar(
                title: "Respuestas de\n Pedidos de Oración",
                onRoute: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              Text("Pantalla de lista de peticiones")
            ],
          ),
        ),
      ),
    );
  }

  _showModal(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              EdgeInsets.only(left: 12.0, right: 12.0, top: 0.0, bottom: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0XFFFFE072),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 27, bottom: 39.0, left: 16.0, right: 16.0),
                        child: Column(
                          children: [
                            Text(
                                textAlign: TextAlign.center,
                                "Aviso de responsabilidad",
                                style: StylesApp(context).textStyleTitleRed),
                            SizedBox(
                              height: 21.0,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              "La información, consejos u orientaciones ofrecidos aquí tienen el propósito de brindar apoyo espiritual y emocional, pero no constituyen asesoramiento profesional. Te recomendamos que, para cuestiones legales, médicas o psicológicas, consultes con un especialista",
                              style:
                                  StylesApp(context).textStyleBody20.copyWith(
                                        color: Colors.black,
                                      ),
                            ),
                            SizedBox(
                              height: 21.0,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: ButtonThemeWidget(
                          text: "Aceptar",
                          buttonStyle: StylesApp(context).btnWidgetSmall,
                          width: 239.0,
                          height: 41.0,
                          onPressed: () {
                          },
                        ),
                      ),
                      SizedBox(
                        height: 28.0,
                      ),
                      Center(
                        child: ButtonThemeWidget(
                          text: "Salir",
                          buttonStyle:
                              StylesApp(context).btnWidgetSmall.copyWith(
                                      backgroundColor: WidgetStatePropertyAll(
                                    Color(0XFF006AFF),
                                  )),
                          width: 239.0,
                          height: 41.0,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 34.0,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
