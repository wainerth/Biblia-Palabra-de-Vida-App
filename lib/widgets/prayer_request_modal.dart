import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';

class PrayerRequestModal extends StatefulWidget {
  final PrayerModel prayerRequest;
  final void Function()? emitUpdateList;
  const PrayerRequestModal({
    super.key,
    required this.prayerRequest,
    this.emitUpdateList,
  });

  @override
  State<PrayerRequestModal> createState() => _PrayerRequestModalState();
}

class _PrayerRequestModalState extends State<PrayerRequestModal> {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController verseController = TextEditingController();
  File? audioFile;
  bool itemExpanded = false;
  bool showRecordAudio = false;
  bool isLoading = false;
  String? errorMessage;
  String? verseId;
  final ScrollController _scrollMessage = ScrollController();
  final ScrollController _scrollVerse = ScrollController();
  int intents = 0;

  // Detectar si es tablet
  bool get isTablet {
    final width = MediaQuery.of(context).size.width;
    return width >= 600;
  }

  @override
  void dispose() {
    messageController.dispose();
    verseController.dispose();
    _scrollMessage.dispose();
    _scrollVerse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: StyleColor.white,
      insetPadding: isTablet
          ? EdgeInsets.symmetric(
              horizontal: 50.0,
              vertical: 30.0,
            )
          : EdgeInsets.zero,
      shape: isTablet
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            )
          : null,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: double.infinity,
          maxHeight: isTablet ? 900 : double.infinity,
        ),
        child: isTablet
            ? _buildTabletLayout(context)
            : _buildMobileLayout(context),
      ),
    );
  }

  // DISEÑO PARA TABLET
  Widget _buildTabletLayout(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.9,
      decoration: BoxDecoration(
        color: StyleColor.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          // Header para tablet
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: StyleColor.turquoise,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.emitUpdateList?.call();
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Responder Pedido de Oración',
                      style: StylesApp(context).textStyleTitleOrange.copyWith(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Image.asset(
                  "assets/kawaii_fire.png",
                  height: 50.0,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(30.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // COLUMNA IZQUIERDA - Detalles de la petición
                  Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: StyleColor.turquoise.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detalle de la Solicitud',
                            style: StylesApp(context).textStyleBody18.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: StyleColor.blueDark,
                                ),
                          ),

                          SizedBox(height: 20),

                          _buildTabletRequestDetails(),

                          SizedBox(height: 30),

                          // Audio de la petición
                          if (widget.prayerRequest.audioPrayer != null) ...[
                            Text(
                              'Audio de la Petición',
                              style: StylesApp(context).textStyleBody16.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: StyleColor.blueDark,
                              ),
                            ),
                            SizedBox(height: 10),
                            AudioPlayerWidget(
                              pathUrl:
                                  "${GraphQLConfig.urlServidor}${widget.prayerRequest.audioPrayer!.url}",
                              showImage: false,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 30.0),

                  // COLUMNA DERECHA - Formulario de respuesta
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mensaje opcional
                        Text(
                          "Mensaje (opcional)",
                          style: StylesApp(context).textStyleBody16.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: StyleColor.blueDark,
                              ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Scrollbar(
                            controller: _scrollMessage,
                            thumbVisibility: true,
                            thickness: 6.0,
                            child: SingleChildScrollView(
                              controller: _scrollMessage,
                              child: TextField(
                                controller: messageController,
                                style: StylesApp(context)
                                    .textStyleBody16
                                    .copyWith(
                                        fontSize: 16.0,
                                        color: StyleColor.black),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(16.0),
                                  hintText:
                                      "Escribe un mensaje personalizado...",
                                  hintStyle: StylesApp(context)
                                      .textStyleBody14
                                      .copyWith(
                                          fontSize: 16.0,
                                          color: Colors.grey[500]),
                                  border: InputBorder.none,
                                ),
                                minLines: 4,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 25),

                        // Sección de versículo
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Versículo (opcional)",
                                    style: StylesApp(context)
                                        .textStyleBody16
                                        .copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: StyleColor.blueDark,
                                        ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border:
                                          Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: Scrollbar(
                                      controller: _scrollVerse,
                                      thumbVisibility: true,
                                      thickness: 6.0,
                                      child: SingleChildScrollView(
                                        controller: _scrollVerse,
                                        child: TextField(
                                          controller: verseController,
                                          style: StylesApp(context)
                                              .textStyleBody16
                                              .copyWith(
                                                  fontSize: 16.0,
                                                  color: StyleColor.black),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.all(16.0),
                                            hintText:
                                                'Ejemplo: Juan 1:4 "Y de tal manera..."',
                                            hintStyle: StylesApp(context)
                                                .textStyleBody14
                                                .copyWith(
                                                    fontSize: 16.0,
                                                    color: Colors.grey[500]),
                                            border: InputBorder.none,
                                          ),
                                          minLines: 3,
                                          maxLines: null,
                                          keyboardType: TextInputType.multiline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 15),

                            // Botón para adjuntar versículo
                            SizedBox(
                              width: 180,
                              child: ButtonThemeWidget(
                                text: "Buscar\nVersículo",
                                buttonStyle:
                                    StylesApp(context).btnWidgetSmall.copyWith(
                                          textStyle: WidgetStatePropertyAll(
                                            StylesApp(context).textStyleBody16.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                height: 60,
                                onPressed: _showVerseSelectionDialog,
                              ),
                            ),
                          ],
                        ),

                        // SizedBox(height: 30),

                        // Opción de grabación de audio
                        // Container(
                        //   padding: EdgeInsets.all(20),
                        //   decoration: BoxDecoration(
                        //     color: Colors.grey[50],
                        //     borderRadius: BorderRadius.circular(12.0),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Text(
                        //             "Grabación de Audio (opcional)",
                        //             style: StylesApp(context).textStyleBody16.copyWith(
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.w700,
                        //               color: StyleColor.blueDark,
                        //             ),
                        //           ),
                        //           Switch.adaptive(
                        //             value: showRecordAudio,
                        //             onChanged: (value) {
                        //               setState(() {
                        //                 showRecordAudio = value;
                        //               });
                        //             },
                        //             activeColor: StyleColor.orange,
                        //           ),
                        //         ],
                        //       ),
                        //       if (showRecordAudio) ...[
                        //         SizedBox(height: 15),
                        //         AudioRecorderWidget(
                        //           onAudioRecorded: (file) =>
                        //               setState(() => audioFile = file),
                        //         ),
                        //         if (audioFile != null) ...[
                        //           SizedBox(height: 10),
                        //           Container(
                        //             padding: EdgeInsets.all(12),
                        //             decoration: BoxDecoration(
                        //               color: Colors.green[50],
                        //               borderRadius: BorderRadius.circular(8),
                        //               border: Border.all(color: Colors.green),
                        //             ),
                        //             child: Row(
                        //               children: [
                        //                 Icon(Icons.audio_file,
                        //                     color: Colors.green),
                        //                 SizedBox(width: 10),
                        //                 Expanded(
                        //                   child: Text(
                        //                     "Audio grabado listo",
                        //                     style: StylesApp(context).textStyleBody14.copyWith(
                        //                       fontSize: 14.0,
                        //                       color: Colors.green[800],
                        //                       fontWeight: FontWeight.w600,
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 IconButton(
                        //                   icon: Icon(Icons.close, size: 20),
                        //                   onPressed: () {
                        //                     setState(() {
                        //                       audioFile = null;
                        //                     });
                        //                   },
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ],
                        //       ],
                        //     ],
                        //   ),
                        // ),

                        SizedBox(height: 40),

                        // Botón de enviar
                        Center(
                          child: ButtonThemeWidget(
                            width: 300,
                            height: 60,
                            text: "Enviar Respuesta",
                            buttonStyle:
                                StylesApp(context).btnWidgetSmall.copyWith(
                                      textStyle: WidgetStatePropertyAll(
                                        StylesApp(context).textStyleBody18.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                            onPressed: () => _handleSubmit(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Detalles de la petición para tablet
  Widget _buildTabletRequestDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
            Icons.calendar_today, "Fecha:", widget.prayerRequest.requestDate),
        SizedBox(height: 12),
        _buildDetailRow(
            Icons.person, "Solicitante:", widget.prayerRequest.requestedBy),
        SizedBox(height: 12),
        _buildDetailRow(
            Icons.people, "Pide por:", widget.prayerRequest.prayedFor),
        SizedBox(height: 12),
        _buildDetailRow(Icons.category, "Categoría:",
            widget.prayerRequest.prayerCategory.name),
        SizedBox(height: 12),
        _buildDetailRow(Icons.category_outlined, "Subcategoría:",
            widget.prayerRequest.prayerSubType.name),
        SizedBox(height: 15),

        // Descripción
        Text(
          "Descripción:",
          style: StylesApp(context).textStyleBody14.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: StyleColor.blueDark,
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            widget.prayerRequest.prayerDetails,
            style: StylesApp(context).textStyleBody14.copyWith(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: StyleColor.orange, size: 18),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: StylesApp(context).textStyleBody12.copyWith(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: StylesApp(context).textStyleBody14.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // DISEÑO MÓVIL (se mantiene exactamente igual)
  Widget _buildMobileLayout(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton.filled(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
                foregroundColor: WidgetStatePropertyAll(StyleColor.white),
              ),
              padding: EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(context);
                widget.emitUpdateList!();
              },
              splashColor: StyleColor.orange,
              color: StyleColor.white,
              icon: Icon(Icons.arrow_back, size: 30),
            ),
            backgroundColor: StyleColor.white,
            actions: [
              Image.asset(
                "assets/kawaii_fire.png",
                height: 52.0,
                fit: BoxFit.contain,
              )
            ],
          ),
          backgroundColor: StyleColor.turquoise,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 0,
                right: 0,
                top: 0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header con imagen de fondo
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage("assets/elipsisTop.png"),
                        fit: BoxFit.cover,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 48.0),
                        Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            'Responder Pedido\n de Oración',
                            style: StylesApp(context).textStyleTitleOrange,
                          ),
                        ),
                        SizedBox(height: 35),
                      ],
                    ),
                  ),

                  SizedBox(height: 15),

                  // Sección expandible de detalles
                  GestureDetector(
                    onTap: () => setState(() => itemExpanded = !itemExpanded),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Text(
                            "Detalle de la Solicitud",
                            style: StylesApp(context)
                                .textStyleBody16
                                .copyWith(color: StyleColor.white),
                          ),
                          Spacer(),
                          Icon(
                            itemExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: StyleColor.black,
                          ),
                        ],
                      ),
                    ),
                  ),

                  AnimatedCrossFade(
                    duration: Duration(milliseconds: 300),
                    crossFadeState: itemExpanded
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: _buildRequestDetails(),
                    secondChild: Container(),
                  ),

                  SizedBox(height: 21.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Mensaje (opcional)",
                      style: StylesApp(context)
                          .textStyleBody12
                          .copyWith(color: StyleColor.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0)),
                      height: 100,
                      child: Scrollbar(
                        controller: _scrollMessage,
                        thumbVisibility:
                            true, // Hace visible la barra permanentemente
                        trackVisibility:
                            true, // Opcional: muestra el área del track
                        thickness: 6.0, // Grosor de la barra
                        radius: Radius.circular(3), // Bordes redondeados
                        child: SingleChildScrollView(
                          controller: _scrollMessage,
                          child: TextField(
                            controller: messageController,
                            decoration: StylesApp(context)
                                .inputDecorationOutlineStyle
                                .copyWith(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8.0),
                                  hintText: "Mensaje Personalizado",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(16)),
                                  fillColor: StyleColor.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                            minLines: 4,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  // Botón para adjuntar versículo
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ButtonThemeWidget(
                        width: double.infinity,
                        textCenter: true,
                        text: "Adjuntar un Versículo\n (opcional)",
                        buttonStyle: StylesApp(context).btnWidgetSmall,
                        onPressed: _showVerseSelectionDialog,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Versículo (Preview)",
                      style: StylesApp(context)
                          .textStyleBody12
                          .copyWith(color: StyleColor.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0)),
                      height: 100,
                      child: Scrollbar(
                        controller: _scrollVerse,
                        thumbVisibility:
                            true, // Hace visible la barra permanentemente
                        trackVisibility:
                            true, // Opcional: muestra el área del track
                        thickness: 6.0, // Grosor de la barra
                        radius: Radius.circular(3), // Bordes redondeados
                        child: SingleChildScrollView(
                          controller: _scrollVerse,
                          child: TextField(
                            controller: verseController,
                            decoration: StylesApp(context)
                                .inputDecorationOutlineStyle
                                .copyWith(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8.0),
                                  hintText: 'Juan 1: 4 \n "Y de tal Manera..."',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(16)),
                                  fillColor: StyleColor.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                            minLines: 3,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Opción de grabación de audio
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () => setState(
                              () => showRecordAudio = !showRecordAudio),
                          child: Row(
                            children: [
                              Checkbox.adaptive(
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                        (states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return StyleColor
                                        .orange; // Color cuando está seleccionado
                                  }
                                  return Colors
                                      .transparent; // Color cuando no está seleccionado
                                }),
                                side: WidgetStateBorderSide.resolveWith(
                                  (states) => BorderSide(
                                    color: StyleColor
                                        .white, // Color del borde (blanco)
                                    width: 2.0, // Grosor del borde
                                  ),
                                ),
                                checkColor: StyleColor.white,
                                value: showRecordAudio,
                                onChanged: (v) => setState(
                                    () => showRecordAudio = v ?? false),
                              ),
                              Text(
                                "Grabar un Audio? ",
                                style: StylesApp(context)
                                    .textStyleBody10
                                    .copyWith(color: StyleColor.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (showRecordAudio)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26.0),
                          child: AudioRecorderWidget(
                            onAudioRecorded: (file) =>
                                setState(() => audioFile = file),
                          ),
                        ),
                      SizedBox(height: 10),
                    ],
                  ),

                  // Botón de enviar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ButtonThemeWidget(
                      width: double.infinity,
                      text: "Tomar pedido",
                      buttonStyle: StylesApp(context).btnWidgetSmall,
                      onPressed: () => _handleSubmit(context),
                    ),
                  ),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Detalles de la petición (compartido)
  Widget _buildRequestDetails() {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: StyleColor.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: "Fecha hora: ",
                      style: StylesApp(context).textStyleBody2_14),
                  TextSpan(
                      text: widget.prayerRequest.requestDate,
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
                      style: StylesApp(context).textStyleBody2_14),
                  TextSpan(
                    text: widget.prayerRequest.requestedBy,
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
                      style: StylesApp(context).textStyleBody2_14),
                  TextSpan(
                    text: widget.prayerRequest.prayedFor,
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
                      style: StylesApp(context).textStyleBody2_14),
                  TextSpan(
                    text: widget.prayerRequest.prayerCategory.name.trim(),
                    style: StylesApp(context)
                        .textStyleBody2_14
                        .copyWith(color: Colors.black),
                  ),
                  TextSpan(
                      text: " / ", style: StylesApp(context).textStyleBody2_14),
                  TextSpan(
                    text: widget.prayerRequest.prayerSubType.name,
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
                      style: StylesApp(context).textStyleBody2_14),
                  TextSpan(
                      text: widget.prayerRequest.prayerDetails,
                      style: StylesApp(context)
                          .textStyleBody2_14
                          .copyWith(color: Colors.black)),
                ],
              ),
            ),
            SizedBox(height: 12.0),
            AudioPlayerWidget(
              pathUrl: widget.prayerRequest.audioPrayer != null
                  ? "${GraphQLConfig.urlServidor}${widget.prayerRequest.audioPrayer!.url}"
                  : '',
              showImage: false,
            ),
          ],
        ),
      ),
    );
  }

  // Los métodos _showVerseSelectionDialog y _handleSubmit se mantienen igual
  Future<void> _showVerseSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final bool isTablet = MediaQuery.of(context).size.width >= 600;

        return Dialog(
          backgroundColor: StyleColor.white,
          insetPadding: isTablet
              ? EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0)
              : EdgeInsets.symmetric(horizontal: 5.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 700 : MediaQuery.of(context).size.width - 10,
              maxHeight:
                  isTablet ? 800 : MediaQuery.of(context).size.height * 0.9,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: StyleColor.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SearchByBookWidget(
                      showSelectedRange: false,
                      onActionBook: (InputDataSearchModel data) {
                        if (kDebugMode) {
                          print(data.versionId);
                        }
                        verseId = data.startVerseId;
                        setState(() {
                          verseController.text =
                              '${data.book?.modernName} ${data.chapter?.chapter}: ${data.verses?[0].verse}\n "${data.verses?[0].text}"';
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    LoadingService().showLoading(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.currentUser;
    setState(() {
      intents += 1;
    });
    try {
      final response = await answerPrayerRequest(
          messageController.text.trim().isEmpty
              ? null
              : messageController.text.trim(),
          widget.prayerRequest.requestId,
          userData!.userId,
          verseId,
          audioFile);

      if (response.error != null) {
        if (intents <= 3) {
          LoadingService().hideLoading();
          if (mounted) {
            await showCustomDialogWithAction(context,
                message: response.error!,
                dialogType: DialogTypeAction.error,
                buttonOk: "Cancelar",
                actionCallbackOk: () {
                  Navigator.pop(context);
                },
                textButton: "Reintentar",
                showAction: true,
                actionCallback: () async {
                  Navigator.pop(context);
                  await _handleSubmit(context);
                });
          }
          return;
        } else {
          LoadingService().hideLoading();
          if (mounted) {
            showCustomDialog(context,
            showDetails: false,
                message: response.error!, dialogType: DialogType.error);
          }
          return;
        }
      }
      LoadingService().hideLoading();
      if (mounted) {
        await showCustomDialog(
          context,
          message:
              "La Respuesta a la solicitud ${widget.prayerRequest.requestId} Fue Realizada con éxito!",
          dialogType: DialogType.info,
        );
        Navigator.pop(context);
      }
      widget.emitUpdateList!();
    } catch (e) {
      if (intents <= 3) {
        LoadingService().hideLoading();
        if (mounted) {
          await showCustomDialogWithAction(context,
              message: e.toString(),
              dialogType: DialogTypeAction.error,
              buttonOk: "Cancelar",
              actionCallbackOk: () {
                Navigator.pop(context);
              },
              textButton: "Reintentar",
              showAction: true,
              actionCallback: () async {
                Navigator.pop(context);
                await _handleSubmit(context);
              });
        }
      } else {
        LoadingService().hideLoading();
        if (mounted) {
          showCustomDialog(context,
              message: e.toString(), dialogType: DialogType.error);
        }
        return;
      }
    } finally {
      LoadingService().hideLoading();
    }
  }
}
