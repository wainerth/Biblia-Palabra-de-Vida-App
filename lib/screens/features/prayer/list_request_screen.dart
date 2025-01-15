import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/audio_player_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class ListRequestScreen extends StatefulWidget {
  const ListRequestScreen({super.key});

  @override
  State<ListRequestScreen> createState() => _ListRequestScreenState();
}

class _ListRequestScreenState extends State<ListRequestScreen> {
  bool _isChecked = false;
  dynamic dataSeleccionada = {};
  List listRequest = [
    {
      "id": "1",
      "dateAndTime": "07/01/2025  20:30",
      "applicant": "Pedro Alfonzo Ramírez Perez",
      "addressee": "Juan Ramirez",
      "typeOfPrayer": "Libertad de los vicios",
      "prayer": "Fortaleza para resistir la tentación",
      "description":
          "Mi hijo esta en las drogas quiero verlo libre de ese vicio que Dios lo libre de esa situación, no se como ayudarlo",
      "status": false,
      "audio": "/audio.mp4",
      "message":
          "Juan 8:36: \"Así que, si el Hijo os libertare, seréis verdaderamente libres.\""
    },
    {
      "id": "2",
      "dateAndTime": "07/01/2025  20:30",
      "addressee": "Juan Ramirez",
      "applicant": "Pedro Alfonzo Ramírez Perez",
      "typeOfPrayer": "Libertad de los vicios",
      "prayer": "Fortaleza para resistir la tentación",
      "description":
          "Mi hijo esta en las drogas quiero verlo libre de ese vicio que Dios lo libre de esa situación, no se como ayudarlo",
      "status": true,
      "audio": "/audio.mp4",
      "message":
          "Juan 8:36: \"Así que, si el Hijo os libertare, seréis verdaderamente libres.\""
    },
    {
      "id": "3",
      "dateAndTime": "07/01/2025  20:30",
      "addressee": "Juan Ramirez",
      "applicant": "Pedro Alfonzo Ramírez Perez",
      "typeOfPrayer": "Libertad de los vicios",
      "prayer": "Fortaleza para resistir la tentación",
      "description":
          "Mi hijo esta en las drogas quiero verlo libre de ese vicio que Dios lo libre de esa situación, no se como ayudarlo",
      "status": false,
      "audio": "/audio.mp4",
      "message":
          "Juan 8:36: \"Así que, si el Hijo os libertare, seréis verdaderamente libres.\""
    },
    {
      "id": "4",
      "dateAndTime": "07/01/2025  20:30",
      "addressee": "Juan Ramirez",
      "applicant": "Pedro Alfonzo Ramírez Perez",
      "typeOfPrayer": "Libertad de los vicios",
      "prayer": "Fortaleza para resistir la tentación",
      "description":
          "Mi hijo esta en las drogas quiero verlo libre de ese vicio que Dios lo libre de esa situación, no se como ayudarlo",
      "status": false,
      "audio": "/audio.mp4",
      "message":
          "Juan 8:36: \"Así que, si el Hijo os libertare, seréis verdaderamente libres.\""
    },
    {
      "id": "5",
      "dateAndTime": "07/01/2025  20:30",
      "addressee": "Juan Ramirez",
      "applicant": "Pedro Alfonzo Ramírez Perez",
      "typeOfPrayer": "Libertad de los vicios",
      "prayer": "Fortaleza para resistir la tentación",
      "description":
          "Mi hijo esta en las drogas quiero verlo libre de ese vicio que Dios lo libre de esa situación, no se como ayudarlo",
      "status": false,
      "audio": "/audio.mp4",
      "message":
          "Juan 8:36: \"Así que, si el Hijo os libertare, seréis verdaderamente libres.\""
    },
    {
      "id": "6",
      "dateAndTime": "07/01/2025  20:30",
      "addressee": "Juan Ramirez",
      "applicant": "Pedro Alfonzo Ramírez Perez",
      "typeOfPrayer": "Libertad de los vicios",
      "prayer": "Fortaleza para resistir la tentación",
      "description":
          "Mi hijo esta en las drogas quiero verlo libre de ese vicio que Dios lo libre de esa situación, no se como ayudarlo",
      "status": false,
      "audio": "/audio.mp4",
      "message":
          "Juan 8:36: \"Así que, si el Hijo os libertare, seréis verdaderamente libres.\""
    },
    {
      "id": "7",
      "dateAndTime": "07/01/2025  20:30",
      "addressee": "Juan Ramirez",
      "applicant": "Pedro Alfonzo Ramírez Perez",
      "typeOfPrayer": "Libertad de los vicios",
      "prayer": "Fortaleza para resistir la tentación",
      "description":
          "Mi hijo esta en las drogas quiero verlo libre de ese vicio que Dios lo libre de esa situación, no se como ayudarlo",
      "status": false,
      "audio": "/audio.mp4",
      "message":
          "Juan 8:36: \"Así que, si el Hijo os libertare, seréis verdaderamente libres.\""
    },
    {
      "id": "8",
      "dateAndTime": "07/01/2025  20:30",
      "addressee": "Juan Ramirez",
      "applicant": "Pedro Alfonzo Ramírez Perez",
      "typeOfPrayer": "Libertad de los vicios",
      "prayer": "Fortaleza para resistir la tentación",
      "description":
          "Mi hijo esta en las drogas quiero verlo libre de ese vicio que Dios lo libre de esa situación, no se como ayudarlo",
      "status": false,
      "audio": "/audio.mp4",
      "message":
          "Juan 8:36: \"Así que, si el Hijo os libertare, seréis verdaderamente libres.\""
    },
    {
      "id": "9",
      "dateAndTime": "07/01/2025  20:30",
      "addressee": "Juan Ramirez",
      "applicant": "Pedro Alfonzo Ramírez Perez",
      "typeOfPrayer": "Libertad de los vicios",
      "prayer": "Fortaleza para resistir la tentación",
      "description":
          "Mi hijo esta en las drogas quiero verlo libre de ese vicio que Dios lo libre de esa situación, no se como ayudarlo",
      "status": false,
      "audio": "/audio.mp4",
      "message":
          "Juan 8:36: \"Así que, si el Hijo os libertare, seréis verdaderamente libres.\""
    },
    {
      "id": "10",
      "dateAndTime": "07/01/2025  20:30",
      "addressee": "Juan Ramirez",
      "applicant": "Pedro Alfonzo Ramírez Perez",
      "typeOfPrayer": "Libertad de los vicios",
      "prayer": "Fortaleza para resistir la tentación",
      "description":
          "Mi hijo esta en las drogas quiero verlo libre de ese vicio que Dios lo libre de esa situación, no se como ayudarlo",
      "status": false,
      "audio": "/audio.mp4",
      "message":
          "Juan 8:36: \"Así que, si el Hijo os libertare, seréis verdaderamente libres.\""
    },
    {
      "id": "11",
      "dateAndTime": "07/01/2025  20:30",
      "addressee": "Juan Ramirez",
      "applicant": "Pedro Alfonzo Ramírez Perez",
      "typeOfPrayer": "Libertad de los vicios",
      "prayer": "Fortaleza para resistir la tentación",
      "description":
          "Mi hijo esta en las drogras quiero verlo libre de ese vicio que Dios lo libre de esa situación, no se como ayudarlo",
      "status": false,
      "audio": "/audio.mp4",
      "message":
          "Juan 8:36: \"Así que, si el Hijo os libertare, seréis verdaderamente libres.\""
    },
  ];

  _deleteItem(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content: Text("¿Está seguro de que desea eliminar esta petición?"),
          actions: [
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Sí"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  listRequest.removeWhere((item) => item["id"] == id);
                });
              },
            ),
          ],
        );
      },
    );
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
              Expanded(
                child: ListView.builder(
                    itemCount: listRequest.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        constraints: BoxConstraints(
                          minHeight: 89.0,
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 8.0),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  textAlign: TextAlign.left,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Fecha hora: ",
                                          style: StylesApp(context)
                                              .textStyleBody2_14),
                                      TextSpan(
                                          text:
                                              "${listRequest[index]["dateAndTime"]}",
                                          style: StylesApp(context)
                                              .textStyleBody2_14
                                              .copyWith(color: Colors.black)),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Por: ",
                                          style: StylesApp(context)
                                              .textStyleBody2_14),
                                      TextSpan(
                                          text:
                                              "${listRequest[index]["addressee"]}",
                                          style: StylesApp(context)
                                              .textStyleBody2_14
                                              .copyWith(color: Colors.black)),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Oración por: ",
                                          style: StylesApp(context)
                                              .textStyleBody2_14),
                                      TextSpan(
                                          text:
                                              "${listRequest[index]["typeOfPrayer"]}",
                                          style: StylesApp(context)
                                              .textStyleBody2_14
                                              .copyWith(color: Colors.black)),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "",
                                          style: StylesApp(context)
                                              .textStyleBody2_14),
                                      TextSpan(
                                          text:
                                              "${listRequest[index]["prayer"]}",
                                          style: StylesApp(context)
                                              .textStyleBody2_14
                                              .copyWith(color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: -10,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  _showModal(context);
                                  setState(() {
                                    dataSeleccionada = listRequest[index];
                                  });
                                },
                                icon: Icon(
                                  Icons.add_circle_outline_sharp,
                                  color: StyleColor.turquoise,
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: -10,
                                right: 0,
                                child: IconButton(
                                    onPressed: () {
                                      _deleteItem(listRequest[index]["id"]);
                                    },
                                    icon: Icon(Icons.delete_outline)))
                          ],
                        ),
                      );
                    }),
              ),
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
                                        fillColor: WidgetStatePropertyAll(
                                            Colors.white),
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
                                          .textStyleBody16
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
                              _showMOdalInfo(context);
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

  void _showMOdalInfo(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    showDialog(
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
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0XFFFFF8DD),
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
                                    "Respuesta\n Pedidos de Oración",
                                    style: StylesApp(context)
                                        .textStyleTitleOrange),
                                SizedBox(
                                  height: 21.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text: "Fecha hora: ",
                                              style: StylesApp(context)
                                                  .textStyleBody2_14),
                                          TextSpan(
                                              text:
                                                  "${dataSeleccionada["dateAndTime"]}",
                                              style: StylesApp(context)
                                                  .textStyleBody2_14
                                                  .copyWith(
                                                      color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text: "Solicitante: ",
                                              style: StylesApp(context)
                                                  .textStyleBody2_14),
                                          TextSpan(
                                              text:
                                                  "${dataSeleccionada["applicant"]}",
                                              style: StylesApp(context)
                                                  .textStyleBody2_14
                                                  .copyWith(
                                                      color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text: "Pide por: ",
                                              style: StylesApp(context)
                                                  .textStyleBody2_14),
                                          TextSpan(
                                              text:
                                                  "${dataSeleccionada["addressee"]}",
                                              style: StylesApp(context)
                                                  .textStyleBody2_14
                                                  .copyWith(
                                                      color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text: "Oración por: ",
                                              style: StylesApp(context)
                                                  .textStyleBody2_14),
                                          TextSpan(
                                              text:
                                                  "${dataSeleccionada["typeOfPrayer"]}",
                                              style: StylesApp(context)
                                                  .textStyleBody2_14
                                                  .copyWith(
                                                      color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text: "",
                                              style: StylesApp(context)
                                                  .textStyleBody2_14),
                                          TextSpan(
                                              text:
                                                  "${dataSeleccionada["prayer"]}",
                                              style: StylesApp(context)
                                                  .textStyleBody2_14
                                                  .copyWith(
                                                      color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text: "Descripción: ",
                                              style: StylesApp(context)
                                                  .textStyleBody2_14),
                                          TextSpan(
                                              text:
                                                  "${dataSeleccionada["description"]}",
                                              style: StylesApp(context)
                                                  .textStyleBody2_14
                                                  .copyWith(
                                                      color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                AudioPlayerWidget(
                                    pathUrl: dataSeleccionada["audio"],
                                    showImage: false,
                                    ),

                                SizedBox(
                                  height: 21.0,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    minHeight: 96.0,
                                    // maxHeight: 205.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Mensaje",
                                        style: StylesApp(context)
                                            .textStyleBodyOrange15,
                                      ),
                                      SizedBox(
                                        height: 17.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7.0),
                                        child: Container(
                                          constraints: BoxConstraints(
                                            minHeight: 73.0,
                                            maxHeight:dataSeleccionada["status"] ? 205.0 : 73.0,
                                          ),
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Scrollbar(
                                            controller: _scrollController,
                                            thumbVisibility: true,
                                            thickness: 6.0,
                                            child: SingleChildScrollView(
                                              controller: _scrollController,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "El grupo de oración oro por tu pedido.",
                                                    style: StylesApp(context)
                                                        .textStyleBody15
                                                        .copyWith(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                  SizedBox(
                                                    height: 21.0,
                                                  ),
                                                  Text(
                                                    dataSeleccionada["status"]
                                                        ? dataSeleccionada[
                                                                "message"]
                                                            .replaceAll(
                                                                '"', '\n"')
                                                        : "Tu pedido fue enviado al grupo de oración para clamar a Dios en tu favor.",
                                                    textAlign: TextAlign.left,
                                                    style: StylesApp(context)
                                                        .textStyleBody15
                                                        .copyWith(
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Container(
                                //   decoration: BoxDecoration(
                                //     color: Colors.white,
                                //     borderRadius: BorderRadius.circular(12.0),
                                //   ),
                                //   child: Container(
                                //     constraints: BoxConstraints(
                                //       minHeight: 98.0,
                                //       maxHeight: 205.0,
                                //     ),
                                //     // height: double.infinity,
                                //     child: SingleChildScrollView(
                                //       controller: _scrollController,
                                //       child: Scrollbar(
                                //         thumbVisibility: true,
                                //         controller: _scrollController,
                                //         thickness: 6.0,
                                //         child: Column(
                                //           children: [
                                //             Text(
                                //               "Mensaje",
                                //               style: StylesApp(context)
                                //                   .textStyleBodyOrange15,
                                //             ),
                                //             SizedBox(
                                //               height: 17.0,
                                //             ),
                                //             Text(
                                //               dataSeleccionada["message"],
                                //               style: StylesApp(context)
                                //                   .textStyleBody15
                                //                   .copyWith(
                                //                       color: Colors.black),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Center(
                            child: ButtonThemeWidget(
                              text: "Gracias",
                              buttonStyle: StylesApp(context).btnWidgetSmall,
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
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                          iconSize: 25.0,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: Colors.black,
                          )),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
