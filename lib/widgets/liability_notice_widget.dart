import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class LiabilityNoticeWidget extends StatefulWidget {
  final VoidCallback openModalInfo;
  const LiabilityNoticeWidget({super.key, required this.openModalInfo});

  @override
  State<LiabilityNoticeWidget> createState() => _LiabilityNoticeWidgetState();
}

class _LiabilityNoticeWidgetState extends State<LiabilityNoticeWidget> {
  bool _isChecked = false;

  
  @override
  Widget build(BuildContext context) {
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
                          style: StylesApp(context).textStyleBody20.copyWith(
                                color: Colors.black,
                              ),
                        ),
                        SizedBox(
                          height: 21.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isChecked = !_isChecked;
                            });
                          },
                          child: Row(
                            spacing: 4.0,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 0,
                                child: SizedBox(
                                  height: 26.0,
                                  width: 26.0,
                                  child: Checkbox(
                                    side: BorderSide(width: 1),
                                    checkColor: Colors.black,
                                    fillColor:
                                        WidgetStatePropertyAll(Colors.white),
                                    value: _isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isChecked = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  softWrap: true,
                                  "Acepto las condiciones del aviso de responsabilidad",
                                  style: StylesApp(context)
                                      .textStyleBody12
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
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
                        if (_isChecked) {
                          Navigator.pop(context);
                          widget.openModalInfo();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Es obligatorio aceptar las condiciones del aviso de responsabilidad'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 28.0,
                  ),
                  Center(
                    child: ButtonThemeWidget(
                      text: "Salir",
                      buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
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
  }
}
