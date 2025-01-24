
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';

class RequestPrayerScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  const RequestPrayerScreen({
    super.key,
    required this.args,
  });

  @override
  State<RequestPrayerScreen> createState() => _RequestPrayerScreenState();
}

class _RequestPrayerScreenState extends State<RequestPrayerScreen> {
  final TextEditingController requestController = TextEditingController();
  final TextEditingController _recipientName = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  List<DropdownMenuEntry> options = [];
  List<Map<String, dynamic>> peticiones = [
    {
      "id": "1",
      'options': [
        "Sanidad de enfermedad",
        "Quitar dolencias",
        "Recuperación tras una operación",
        "Recuperación tras un accidente",
        "Libre de depresión",
        "Libre de ansiedad ",
        "Otro",
      ],
    },
    {
      "id": "2",
      'options': [
        "Estoy desesperado necesito paz",
        "Me siento muy depresivo necesito paz",
        "A veces me siento depresivo necesito paz",
        "Por Liberación",
        "Por Libertad",
        "Otro"
      ]
    },
    {
      "id": "3",
      'options': [
        "Unidad y armonía familiar",
        "Protección y seguridad de la familia",
        "Sabiduría en la crianza ",
        "Salvación y vida espiritual de la familia",
        "Provisión y bienestar familia",
        "Reconciliación familiar",
        "Libertad de un familiar",
        "Otro"
      ],
    },
    {
      "id": "4",
      "options": [
        "Protección por seguridad física",
        "Protección Riesgo de contagio",
        "Protección de enemigos",
        "Protección de la iglesia",
        "Protección de la familia",
        "Libertad",
        "Otro"
      ]
    },
    {
      "id": "5",
      "options": [
        "Librar de problemas en el trabajo",
        "conseguir empleo estable",
        "Por un asenso laboral",
        "Dirección ante cambio de empleo",
        "sabiduría en el trabajo",
        "Otro"
      ]
    },
    {
      "id": "6",
      "options": [
        "Mejora en las finanzas ",
        "Ayuda para salir de deudas",
        "Sabiduría en la administración",
        "Bendición en negocios y proyectos",
        "Protección y estabilidad financiera",
        "Otro"
      ]
    },
    {
      "id": "7",
      "options": [
        "Liberación de la adicción",
        "Fortaleza para resistir la tentación",
        "Restauración emocional y espiritual",
        "Apoyo para reconstruir relaciones",
        "Perseverancia en la recuperación",
        "Otro"
      ]
    },
    {
      "id": "8",
      "options": [
        "Liberación espiritual",
        "Crecimiento espiritual",
        "Fortaleza en la fe",
        "Dirección y propósito",
        "Protección espiritual",
        "Avivamiento y servicio",
        "Otro"
      ]
    },
    {
      "id": "9",
      "options": [
        "Fortaleza en momentos duelo",
        "Relaciones interpersonales",
        "Por éxito en metas personales",
        "Gratitud y dirección futura",
        "Otro"
      ]
    }
  ];

  List<DropdownMenuEntry> generarOpcionesDropdown(String id) {
    final categoria = peticiones.firstWhere((p) => p['id'] == id);

    // Convertir JSArray<dynamic> a List<String>
    final options = List<String>.from(categoria["options"]);

    return options.map((key) {
      return DropdownMenuEntry(
        style: ButtonStyle(iconSize: WidgetStatePropertyAll(25.0)),
        label: key,
        value: key.toLowerCase().replaceAll(' ', '_'),
      );
    }).toList();
  }

  @override
  void initState() {
    options = generarOpcionesDropdown(widget.args["value"]);
    if (kDebugMode) {
      print(options);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(widget.args);
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(color: Color(0XFF12CBC4)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeadScreenNotAvatar(
                  title: "Pedidos de Oración\n ${widget.args['label']}",
                  onRoute: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 46.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: _buildDropdown(context),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: TextField(
                    style: StylesApp(context).textStyleBody4,
                    decoration: InputDecoration(
                      fillColor: Color(0XFFFFFFFF),
                      filled: true,
                      hintStyle: StylesApp(context).hintStyle,
                      hintText: "Nombre de por quien Orar",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    controller: _recipientName,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: 281.0,
                      maxHeight: 281.0,
                    ),
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0XFFFFFFFF),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      thickness: 6.0,
                      child: SingleChildScrollView(
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: null,
                          style: StylesApp(context).textStyleBody4,
                          decoration: InputDecoration(
                            hintText: 'Describe tu pedido de oración...',
                            hintStyle: StylesApp(context).textStyleHintText,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: AudioRecorderWidget(),
                ),
                SizedBox(
                  height: 10,
                ),
                ButtonThemeWidget(
                  text: "Enviar",
                  buttonStyle: StylesApp(context).btnWidgetSmall,
                  width: 239.0,
                  height: 41.0,
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          insetPadding: EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 0.0, bottom: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0XFFFFF8DD),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 27,
                                        bottom: 39.0,
                                        left: 16.0,
                                        right: 16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                            textAlign: TextAlign.center,
                                            "Petición Enviada con Éxito ",
                                            style: StylesApp(context)
                                                .textStyleTitleOrange),
                                        SizedBox(
                                          height: 21.0,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Tu petición de oración ha sido enviada a la comunidad de oración, quienes van a orar por tu petición.",
                                          style: StylesApp(context)
                                              .textStyleBody12
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 21.0,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Por favor te pedimos que creas en el poder de Dios, si le buscamos el es bueno misericordioso para perdonarnos y darnos una respuesta que sea para bendicion de nuestras vidas.",
                                          style: StylesApp(context)
                                              .textStyleBody12
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                        ),
                                        SizedBox(
                                          height: 21.0,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          'Juan 3:16 "De tal manera amó Dios al mundo, que ha dado a su Hijo unigénito, para que todo aquel que en él cree, no se pierda, mas tenga vida eterna"',
                                          style: StylesApp(context)
                                              .textStyleBody12
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: ButtonThemeWidget(
                                      text: "Aceptar",
                                      buttonStyle:
                                          StylesApp(context).btnWidgetSmall,
                                      width: 239.0,
                                      height: 41.0,
                                      onPressed: () {
                                        Navigator.popAndPushNamed(
                                            context, '/prayerPage');
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 34.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenu _buildDropdown(BuildContext context) {
    return DropdownMenu(
      initialSelection: "Seleccione una opción",
      controller: requestController,
      dropdownMenuEntries: options,
      enableFilter: true,
      requestFocusOnTap: true,
      hintText: "Tipo de Pedido",
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        hintStyle: StylesApp(context).textStyleHintText,
        filled: true,
        fillColor: Color(0XFFFFFFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
      ),
      width: double.infinity,
      onSelected: (option) {
        setState(() {
          if (kDebugMode) {
            print(option);
          }
        });
      },
      textStyle: StylesApp(context).textStyleBody4,
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Color(0XFFFFFFFF)),
        elevation: WidgetStatePropertyAll(4.0),
        padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
      ),
    );
  }
}
