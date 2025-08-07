import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class InfoModalWidget extends StatefulWidget {
  final PrayerModel dataSeleccionada;
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
                                          text: widget
                                              .dataSeleccionada.requestDate,
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
                                            widget.dataSeleccionada.requestedBy,
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
                                        text: widget.dataSeleccionada.prayedFor,
                                        style: StylesApp(context)
                                            .textStyleBody2_14
                                            .copyWith(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  softWrap: true,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Oración por: ",
                                          style: StylesApp(context)
                                              .textStyleBody2_14),
                                      TextSpan(
                                        text: widget.dataSeleccionada
                                            .prayerCategory.name
                                            .trim(),
                                        style: StylesApp(context)
                                            .textStyleBody2_14
                                            .copyWith(color: Colors.black),
                                      ),
                                      TextSpan(
                                          text: " / ",
                                          style: StylesApp(context)
                                              .textStyleBody2_14),
                                      TextSpan(
                                        text: widget.dataSeleccionada
                                            .prayerSubType.name,
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
                                          text: "Descripción: ",
                                          style: StylesApp(context)
                                              .textStyleBody2_14),
                                      TextSpan(
                                          text: widget
                                              .dataSeleccionada.prayerDetails,
                                          style: StylesApp(context)
                                              .textStyleBody2_14
                                              .copyWith(color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            AudioPlayerWidget(
                              pathUrl: widget.dataSeleccionada.audioPrayer !=
                                      null
                                  ? "${GraphQLConfig.urlServidor}${widget.dataSeleccionada.audioPrayer!.url}"
                                  : '',
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
                                        maxHeight: widget.dataSeleccionada
                                                    .statusRequest !=
                                                null
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
                                              if (widget.dataSeleccionada
                                                      .statusRequest !=
                                                  null)
                                                Text(
                                                  widget
                                                      .dataSeleccionada
                                                      .statusRequest
                                                      .messageSystems!
                                                      .message,
                                                  style: StylesApp(context)
                                                      .textStyleBody15
                                                      .copyWith(
                                                          color: Colors.black),
                                                ),
                                              SizedBox(
                                                height: 21.0,
                                              ),
                                              if (widget.dataSeleccionada
                                                      .responser !=
                                                  null)
                                                Text(
                                                  widget.dataSeleccionada
                                                      .responser!.message,
                                                  style: StylesApp(context)
                                                      .textStyleBody15
                                                      .copyWith(
                                                          color: Colors.black),
                                                ),
                                              SizedBox(
                                                height: 12.0,
                                              ),
                                              if (widget.dataSeleccionada
                                                      .responser !=
                                                  null)
                                                Text.rich(
                                                  TextSpan(
                                                    style: StylesApp(context)
                                                        .textStyleBody12
                                                        .copyWith(
                                                            color: StyleColor
                                                                .grayMedium),
                                                    text:
                                                        '${widget.dataSeleccionada.responser?.bookName} ${widget.dataSeleccionada.responser?.chapter}:${widget.dataSeleccionada.responser?.verse} \n "${widget.dataSeleccionada.responser?.text}"',
                                                  ),
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
                            SizedBox(
                              height: 12.0,
                            ),
                            if (widget.dataSeleccionada.responser != null)
                              AudioPlayerWidget(
                                pathUrl: widget.dataSeleccionada.responser!
                                            .audioResponse !=
                                        null
                                    ? "${GraphQLConfig.urlServidor}${widget.dataSeleccionada.responser?.audioResponse!.url}"
                                    : '',
                                showImage: false,
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
