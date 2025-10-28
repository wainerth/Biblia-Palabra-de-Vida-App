import 'dart:io';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

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
  LoginUser? userData;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController requestController = TextEditingController();
  final TextEditingController _recipientName = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  File? audioFile;
  List<ModelData> options = []; // lista formateada para el dropdown
  ModelData subtypeSelected =
      ModelData(label: "Seleccione una opción", value: "");

  generarOpcionesDropdown(String id) async {
    LoadingService().showLoading(context);
    try {
      final responseSubTypes = await getAllPrayerRequestSubTypes(id);
      if (responseSubTypes.error != null) {
        LoadingService().hideLoading();
        await showCustomDialog(
          context,
          message: responseSubTypes.error!,
          dialogType: DialogType.error,
        );
        return;
      }
      setState(() {
        final List<PrayerSubTypeModel> subTypes = responseSubTypes.data
            .map<PrayerSubTypeModel>(
                (json) => PrayerSubTypeModel.fromJson(json))
            .toList();

        options = subTypes
            .map<ModelData>((subType) => ModelData(
                  label: subType.name,
                  value: subType.id,
                ))
            .toList();
      });
      LoadingService().hideLoading();
    } catch (e) {
      LoadingService().hideLoading();
      await showCustomDialog(
        context,
        message: e.toString(),
        dialogType: DialogType.error,
      );
    } finally {
      LoadingService().hideLoading();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Cargar los datos iniciales
      await generarOpcionesDropdown(widget.args["value"]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userData = userProvider.currentUser;
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
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      color: StyleColor.white,
                      // border: Border.all(color: StyleColor.orange, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: CustomDropdownBottomWidget<PrayerSubTypeModel>(
                      hintText: "Tipo de Pedido",
                      items: options,
                      border: false,
                      onChanged: (ModelData? newValue) {
                        setState(() {
                          subtypeSelected = newValue!;
                        });
                      },
                      selectedItem: subtypeSelected.value.isNotEmpty
                          ? options.firstWhere(
                              (element) =>
                                  element.value == subtypeSelected.value,
                              orElse: () => ModelData(
                                  label: "Seleccione una opción", value: ""),
                            )
                          : null,
                    ),
                  ),
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
                      controller: _scrollController,
                      thumbVisibility: true,
                      thickness: 6.0,
                      child: SingleChildScrollView(
                        controller: _scrollController,
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
                  child: AudioRecorderWidget(
                    onAudioRecorded: (File file) {
                      setState(() {
                        audioFile = file;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ButtonThemeWidget(
                  text: "Enviar",
                  buttonStyle: StylesApp(context).btnWidgetSmall,
                  width: 239.0,
                  height: 41.0,
                  onPressed: () async {
                    LoadingService().showLoading(context);

                    try {
                      // almaceno en Model para formatear
                      final requestData = RequestPrayerModel(
                          audio: audioFile,
                          description: _descriptionController.text,
                          prayerFor: _recipientName.text,
                          prayerSubTypeId: subtypeSelected.value,
                          userId: userData!.userId);

                      // llamo al servicio de crear una solicitud
                      final responseCreatedRequest =
                          await sendPrayerRequest(requestData);

                      // si hay error lo muestro
                      if (responseCreatedRequest.error != null) {
                        // cierro el loading
                        LoadingService().hideLoading();
                        await showCustomDialog(context,
                            message: responseCreatedRequest.error!,
                            dialogType: DialogType.error);
                        return;
                      }
                      // cierro el loading
                      if (!responseCreatedRequest.data['successful']) {
                        LoadingService().hideLoading();
                        await showCustomDialog(context,
                            message: responseCreatedRequest.data['message'],
                            dialogType: DialogType.error);
                        return;
                      }
                      LoadingService().hideLoading();
                      openModalSendSuccessfully(context);
                    } catch (e) {
                      LoadingService().hideLoading();
                      await showCustomDialog(context,
                          message: e.toString(), dialogType: DialogType.error);
                    } finally {
                      LoadingService().hideLoading();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> openModalSendSuccessfully(BuildContext context) {
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
                        top: 27, bottom: 39.0, left: 16.0, right: 16.0),
                    child: Column(
                      children: [
                        Text(
                            textAlign: TextAlign.center,
                            "Petición Enviada con Éxito ",
                            style: StylesApp(context).textStyleTitleOrange),
                        SizedBox(
                          height: 21.0,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          "Tu petición de oración ha sido enviada a la comunidad de oración, quienes van a orar por tu petición.",
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: Colors.black,
                              ),
                        ),
                        SizedBox(
                          height: 21.0,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          "Por favor te pedimos que creas en el poder de Dios, si le buscamos el es bueno misericordioso para perdonarnos y darnos una respuesta que sea para bendición de nuestras vidas.",
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: Colors.black,
                              ),
                        ),
                        SizedBox(
                          height: 21.0,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          'Juan 3:16 "De tal manera amó Dios al mundo, que ha dado a su Hijo unigénito, para que todo aquel que en él cree, no se pierda, mas tenga vida eterna"',
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: Colors.black,
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
                        Navigator.popAndPushNamed(context, '/prayerPage');
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
  }
}
