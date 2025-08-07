import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  ScrollController _scrollMessage = ScrollController();
  ScrollController _scrollverse = ScrollController();
  int intents = 0;
  @override
  void dispose() {
    messageController.dispose();
    verseController.dispose();
    _scrollMessage.dispose();
    _scrollverse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: StyleColor.white,
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
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
                          SizedBox(height: 35.sp),
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
                                        borderRadius:
                                            BorderRadius.circular(16)),
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
                          controller: _scrollverse,
                          thumbVisibility:
                              true, // Hace visible la barra permanentemente
                          trackVisibility:
                              true, // Opcional: muestra el área del track
                          thickness: 6.0, // Grosor de la barra
                          radius: Radius.circular(3), // Bordes redondeados
                          child: SingleChildScrollView(
                            controller: _scrollverse,
                            child: TextField(
                              controller: verseController,
                              decoration: StylesApp(context)
                                  .inputDecorationOutlineStyle
                                  .copyWith(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 8.0),
                                    hintText:
                                        'Juan 1: 4 \n "Y de tal Manera..."',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(16)),
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
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return StyleColor
                                          .orange; // Color cuando está seleccionado
                                    }
                                    return Colors
                                        .transparent; // Color cuando no está seleccionado
                                  }),
                                  side: MaterialStateBorderSide.resolveWith(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 26.0),
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
                        onPressed:() => _handleSubmit(context),
                      ),
                    ),

                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

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

  Future<void> _showVerseSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: StyleColor.white,
          insetPadding: EdgeInsets.symmetric(horizontal: 5.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 10,
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
                  SearchByBookWidget(
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
          return;
        } else {
          LoadingService().hideLoading();
          showCustomDialog(context,
              message: response.error!, dialogType: DialogType.error);
          return;
        }
      }
      LoadingService().hideLoading();
      await showCustomDialog(
        context,
        message:
            "La Respuesta a la solicitud ${widget.prayerRequest.requestId} Fue Realizada con éxito!",
        dialogType: DialogType.info,
      );
      Navigator.pop(context);
      widget.emitUpdateList!();
    } catch (e) {
      if (intents <= 3) {
        LoadingService().hideLoading();
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
      } else {
        LoadingService().hideLoading();
        showCustomDialog(context,
            message: e.toString(), dialogType: DialogType.error);
        return;
      }
    } finally {
      LoadingService().hideLoading();
    }
  }
}
