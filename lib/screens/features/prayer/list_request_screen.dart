import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/info_modal_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class ListRequestScreen extends StatefulWidget {
  const ListRequestScreen({super.key});

  @override
  State<ListRequestScreen> createState() => _ListRequestScreenState();
}

class _ListRequestScreenState extends State<ListRequestScreen> {
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
          "Mi hijo esta en las drogas quiero verlo libre de ese vicio que Dios lo libre de esa situación, no se como ayudarlo",
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
                      return _cardListItem(context, index);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _cardListItem(BuildContext context, int index) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 89.0,
      ),
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
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
                        style: StylesApp(context).textStyleBody2_14),
                    TextSpan(
                        text: "${listRequest[index]["dateAndTime"]}",
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
                        style: StylesApp(context).textStyleBody2_14),
                    TextSpan(
                        text: "${listRequest[index]["addressee"]}",
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
                        style: StylesApp(context).textStyleBody2_14),
                    TextSpan(
                        text: "${listRequest[index]["typeOfPrayer"]}",
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
                        text: "", style: StylesApp(context).textStyleBody2_14),
                    TextSpan(
                        text: "${listRequest[index]["prayer"]}",
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
  }

  _showModal(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return LiabilityNoticeWidget(
          openModalInfo: () {
            _showMOdalInfo(context, dataSeleccionada);
          },
        );
      },
    );
  }

  void _showMOdalInfo(BuildContext context, infoData) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return InfoModalWidget(dataSeleccionada: infoData);
      },
    );
  }
}
