import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class InfoModalWidget extends StatefulWidget {
  final dynamic dataSeleccionada;
  const InfoModalWidget({
    super.key,
    required this.dataSeleccionada,
  });

  @override
  State<InfoModalWidget> createState() => _InfoModalWidgetState();
}

class _InfoModalWidgetState extends State<InfoModalWidget> {
  final ScrollController _scrollController = ScrollController();
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
                                style: StylesApp(context).textStyleTitleOrange),
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
                                              "${widget.dataSeleccionada["dateAndTime"]}",
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
                                          text: "Solicitante: ",
                                          style: StylesApp(context)
                                              .textStyleBody2_14),
                                      TextSpan(
                                        text:
                                            "${widget.dataSeleccionada["applicant"]}",
                                        style: StylesApp(context)
                                            .textStyleBody2_14
                                            .copyWith(color: Colors.black),
                                      ),
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
                                            "${widget.dataSeleccionada["addressee"]}",
                                        style: StylesApp(context)
                                            .textStyleBody2_14
                                            .copyWith(color: Colors.black),
                                      ),
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
                                            "${widget.dataSeleccionada["typeOfPrayer"]}",
                                        style: StylesApp(context)
                                            .textStyleBody2_14
                                            .copyWith(color: Colors.black),
                                      ),
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
                                              "${widget.dataSeleccionada["prayer"]}",
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
                                          text: "Descripción: ",
                                          style: StylesApp(context)
                                              .textStyleBody2_14),
                                      TextSpan(
                                          text:
                                              "${widget.dataSeleccionada["description"]}",
                                          style: StylesApp(context)
                                              .textStyleBody2_14
                                              .copyWith(color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            AudioPlayerWidget(
                              pathUrl: widget.dataSeleccionada["audio"],
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
                                        maxHeight:
                                            widget.dataSeleccionada["status"]
                                                ? 194.0
                                                : 73.0,
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
                                              if (widget
                                                  .dataSeleccionada["status"])
                                                Text(
                                                  "El grupo de oración oro por tu pedido.",
                                                  style: StylesApp(context)
                                                      .textStyleBody15
                                                      .copyWith(
                                                          color: Colors.black),
                                                ),
                                              SizedBox(
                                                height: 21.0,
                                              ),
                                              Text(
                                                widget.dataSeleccionada[
                                                        "status"]
                                                    ? widget.dataSeleccionada[
                                                            "message"]
                                                        .replaceAll('"', '\n"')
                                                    : "Tu pedido fue enviado al grupo de oración para clamar a Dios en tu favor.",
                                                textAlign: TextAlign.left,
                                                style: StylesApp(context)
                                                    .textStyleBody15
                                                    .copyWith(
                                                        color: Colors.black),
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
  }
}
