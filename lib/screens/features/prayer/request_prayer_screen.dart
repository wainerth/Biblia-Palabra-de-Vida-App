import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool _autoValidate = false;
  final _translationProvider = AppTranslationProvider();

  // File? audioFile;
  List<ModelData> options = [];
  ModelData? subtypeSelected;

  bool get isTablet {
    final width = MediaQuery.of(context).size.width;
    return width >= 600;
  }

  generarOpcionesDropdown(String id) async {
    LoadingService().showLoading(context);
    try {
      final responseSubTypes = await getAllPrayerRequestSubTypes(id);
      if (responseSubTypes.error != null) {
        LoadingService().hideLoading();
        if (mounted) {
          await showCustomDialog(
            context,
            message: responseSubTypes.error!,
            dialogType: DialogType.error,
          );
        }
        return;
      }
      setState(() {
        final List<PrayerSubTypeModel> subTypes = responseSubTypes.data
            .map<PrayerSubTypeModel>(
                (json) => PrayerSubTypeModel.fromJson(json))
            .toList();
        options.add(ModelData(
            label: _translationProvider
                .tr('request_prayer_screen.form.request_type.hint'),
            value: ""));
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
      if (mounted) {
        await showCustomDialog(
          context,
          message: e.toString(),
          dialogType: DialogType.error,
        );
      }
    } finally {
      LoadingService().hideLoading();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await generarOpcionesDropdown(widget.args["value"]);
    });
    super.initState();
  }

  bool _validateField() {
    return _formKey.currentState?.validate() ?? false;
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
        child: ResponsiveLayout(
          mobile: _buildMobileLayout(context),
          tablet: _buildTabletLayout(context),
        ),
      ),
    );
  }

  // DISEÑO DE TABLET A DOS COLUMNAS
  Widget _buildTabletLayout(BuildContext context) {
    final dailyWord =
        Provider.of<UserProvider>(context, listen: false).dailyProverb;
    return Container(
      height: MediaQuery.sizeOf(context).height,
      decoration: BoxDecoration(color: Color(0XFF12CBC4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // COLUMNA IZQUIERDA - Instrucciones y referencia bíblica
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0XFF12CBC4),
                    Color(0XFF0FA9A3),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header con botón de regreso
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                              size: 28, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _translationProvider
                                .tr('request_prayer_screen.title'),
                            style: StylesApp(context)
                                .textStyleTitleOrange
                                .copyWith(
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Categoría seleccionada
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.category,
                              color: StyleColor.orange, size: 24),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "${_translationProvider.tr('request_prayer_screen.category')}: ${widget.args['label']}",
                              style:
                                  StylesApp(context).textStyleBody18.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: StyleColor.blueDark,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40),

                    // Instrucciones
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lightbulb_outline,
                                  color: StyleColor.orange, size: 26),
                              SizedBox(width: 10),
                              Text(
                                _translationProvider.tr(
                                    'request_prayer_screen.instructions.title'),
                                style:
                                    StylesApp(context).textStyleBody20.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: StyleColor.blueDark,
                                        ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          _buildInstructionStep(
                              "1",
                              _translationProvider.tr(
                                  'request_prayer_screen.instructions.step_1')),
                          SizedBox(height: 12),
                          _buildInstructionStep(
                              "2",
                              _translationProvider.tr(
                                  'request_prayer_screen.instructions.step_2')),
                          SizedBox(height: 12),
                          _buildInstructionStep(
                              "3",
                              _translationProvider.tr(
                                  'request_prayer_screen.instructions.step_3')),
                          SizedBox(height: 12),
                          // _buildInstructionStep(
                          //     "4", "Graba un audio si lo deseas (opcional)"),
                          // SizedBox(height: 12),
                          _buildInstructionStep(
                              "4",
                              _translationProvider.tr(
                                  'request_prayer_screen.instructions.step_4')),
                        ],
                      ),
                    ),

                    SizedBox(height: 40),

                    // Referencia bíblica
                    if (dailyWord != null) ...{
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/layoutPage",
                              arguments: {
                                'selectedIndex': 1,
                                'bibleId': dailyWord.book!.bibleId,
                                'bookId': dailyWord.book!.id,
                                'chapterId': dailyWord.chapter!.id,
                                'verseId': dailyWord.verse!.id,
                              });
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: StyleColor.orange.withValues(alpha: 0.3),
                                width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.book,
                                          color: StyleColor.orange, size: 24),
                                      SizedBox(width: 10),
                                      Text(
                                        _translationProvider.tr(
                                            'request_prayer_screen.daily_verse.title'),
                                        style: StylesApp(context)
                                            .textStyleBody18
                                            .copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: StyleColor.blueDark,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    spacing: 10.0,
                                    children: [
                                      Center(
                                        child: SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(
                                              Icons.copy,
                                              color: StyleColor.turquoise,
                                              size: 16,
                                            ),
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                  text:
                                                      "${dailyWord.book!.modernName} ${dailyWord.chapter!.chapter}:${dailyWord.verse!.verse}\n ${dailyWord.verse!.text}."));
                                              AdaptiveSnackBar
                                                  .showCopiedMessage(
                                                context,
                                                _translationProvider.tr(
                                                    'request_prayer_screen.daily_verse.copied_message'),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            Icons.share,
                                            color: StyleColor.turquoise,
                                            size: 16,
                                          ),
                                          onPressed: () async {
                                            await SharePlus.instance
                                                .share(ShareParams(
                                              text:
                                                  "${dailyWord.book!.modernName} ${dailyWord.chapter!.chapter}:${dailyWord.verse!.verse}\n ${dailyWord.verse!.text}.\n ${GraphQLConfig.urlServidor}OfficialBible",
                                              subject: _translationProvider.tr(
                                                  'request_prayer_screen.daily_verse.share_subject'),
                                            ));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Text(
                                '"${dailyWord.verse!.text}"',
                                style:
                                    StylesApp(context).textStyleBody16.copyWith(
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey[700],
                                          height: 1.5,
                                        ),
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "${dailyWord.book!.modernName} ${dailyWord.chapter!.chapter}:${dailyWord.verse!.verse}",
                                  style: StylesApp(context)
                                      .textStyleBody14
                                      .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: StyleColor.orange,
                                      ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    }
                  ],
                ),
              ),
            ),
          ),

          // COLUMNA DERECHA - Formulario
          Expanded(
            flex: 6,
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _translationProvider
                            .tr('request_prayer_screen.form.title'),
                        style: StylesApp(context).textStyleBody24.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: StyleColor.blueDark,
                            ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _translationProvider
                            .tr('request_prayer_screen.form.subtitle'),
                        style: StylesApp(context).textStyleBody15.copyWith(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                      ),
                      SizedBox(height: 30),

                      // Tipo de Pedido
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _translationProvider.tr(
                                'request_prayer_screen.form.request_type.label'),
                            style: StylesApp(context).textStyleBody16.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: StyleColor.blueDark,
                                ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              // color: Color(0XFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                              // border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: CustomDropdownWithValidation<
                                PrayerSubTypeModel>(
                              hintText: _translationProvider.tr(
                                  'request_prayer_screen.form.request_type.hint'),
                              items: options,
                              border: true,
                              onChanged: (ModelData? newValue) {
                                setState(() {
                                  subtypeSelected = newValue!;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return _translationProvider.tr(
                                      'request_prayer_screen.form.request_type.validation');
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Nombre de por quien Orar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _translationProvider.tr(
                                'request_prayer_screen.form.recipient_name.label'),
                            style: StylesApp(context).textStyleBody16.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: StyleColor.blueDark,
                                ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            style: StylesApp(context).textStyleBody16.copyWith(
                                  color: StyleColor.black,
                                  fontSize: 16,
                                ),
                            decoration: InputDecoration(
                              fillColor: Color(0XFFF5F5F5),
                              filled: true,
                              hintStyle: StylesApp(context)
                                  .textStyleBody14
                                  .copyWith(color: Colors.grey[500]),
                              errorStyle: StylesApp(context)
                                  .textStyleBody12
                                  .copyWith(
                                      fontSize: 12, color: StyleColor.redLight),
                              hintText: _translationProvider.tr(
                                  'request_prayer_screen.form.recipient_name.hint'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                            controller: _recipientName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return _translationProvider.tr(
                                    'request_prayer_screen.form.recipient_name.validation');
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Descripción
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _translationProvider.tr(
                                'request_prayer_screen.form.description.label'),
                            style: StylesApp(context).textStyleBody16.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: StyleColor.blueDark,
                                ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            constraints: BoxConstraints(
                              minHeight: 160.0,
                              maxHeight: 200.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0XFFF5F5F5),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: Colors.grey[300]!),
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
                                  style: StylesApp(context)
                                      .textStyleBody16
                                      .copyWith(
                                        color: StyleColor.black,
                                        fontSize: 16,
                                      ),
                                  decoration: InputDecoration(
                                    hintText: _translationProvider.tr(
                                        'request_prayer_screen.form.description.hint'),
                                    hintStyle: StylesApp(context)
                                        .textStyleBody14
                                        .copyWith(color: Colors.grey[500]),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(16.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // Grabación de audio
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     // Text(
                      //     //   "Grabación de Audio (Opcional)",
                      //     //   style: StylesApp(context).textStyleBody16.copyWith(
                      //     //         fontSize: 16,
                      //     //         fontWeight: FontWeight.w600,
                      //     //         color: StyleColor.blueDark,
                      //     //       ),
                      //     // ),
                      //     // SizedBox(height: 8),
                      //     //   AudioRecorderWidget(
                      //     //     onAudioRecorded: (File file) {
                      //     //       setState(() {
                      //     //         audioFile = file;
                      //     //       });
                      //     //     },
                      //     //   ),
                      //     //   if (audioFile != null) ...[
                      //     //     SizedBox(height: 10),
                      //     //     Container(
                      //     //       padding: EdgeInsets.all(12),
                      //     //       decoration: BoxDecoration(
                      //     //         color:
                      //     //             StyleColor.blueLight.withValues(alpha: 0.2),
                      //     //         borderRadius: BorderRadius.circular(8),
                      //     //         border: Border.all(color: StyleColor.blue),
                      //     //       ),
                      //     //       child: Row(
                      //     //         children: [
                      //     //           Icon(
                      //     //             Icons.audio_file,
                      //     //             color: StyleColor.blue,
                      //     //             size: 30,
                      //     //           ),
                      //     //           SizedBox(width: 10),
                      //     //           Expanded(
                      //     //             child: Text(
                      //     //               "Audio grabado listo para enviar",
                      //     //               style: StylesApp(context)
                      //     //                   .textStyleBody16
                      //     //                   .copyWith(
                      //     //                       fontSize: 12,
                      //     //                       color: StyleColor.blueDark),
                      //     //             ),
                      //     //           ),
                      //     //           IconButton(
                      //     //             icon: Icon(Icons.close, size: 20),
                      //     //             onPressed: () {
                      //     //               setState(() {
                      //     //                 audioFile = null;
                      //     //               });
                      //     //             },
                      //     //           ),
                      //     //         ],
                      //     //       ),
                      //     //     ),
                      //     //   ],
                      //   ],
                      // ),
                      SizedBox(height: 20),

                      // Botón Enviar
                      Center(
                        child: ButtonThemeWidget(
                          text: _translationProvider
                              .tr('request_prayer_screen.form.submit_button'),
                          buttonStyle: StylesApp(context)
                              .btnWidgetSmall
                              .copyWith(
                                textStyle: WidgetStatePropertyAll(
                                  StylesApp(context).textStyleBody18.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                          width: 300.0,
                          height: 50.0,
                          onPressed: _sendPrayerRequest,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DISEÑO MÓVIL (se mantiene exactamente igual)
  Widget _buildMobileLayout(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      decoration: BoxDecoration(color: Color(0XFF12CBC4)),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            children: [
              HeadScreenNotAvatar(
                title:
                    "${_translationProvider.tr('request_prayer_screen.title')}\n ${widget.args['label']}",
                onRoute: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 46.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: StyleColor.white,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: CustomDropdownWithValidation<PrayerSubTypeModel>(
                    hintText: _translationProvider
                        .tr('request_prayer_screen.form.request_type.label'),
                    items: options,
                    onChanged: (ModelData? newValue) {
                      setState(() {
                        subtypeSelected = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return _translationProvider.tr(
                            'request_prayer_screen.form.request_type.validation');
                      }
                      return null;
                    },
                    border: true,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: TextFormField(
                  style: StylesApp(context).textStyleBody4,
                  decoration: InputDecoration(
                    fillColor: Color(0XFFFFFFFF),
                    filled: true,
                    hintStyle: StylesApp(context).hintStyle,
                    errorStyle: StylesApp(context)
                        .textStyleBody12
                        .copyWith(fontSize: 12, color: StyleColor.redLight),
                    hintText: _translationProvider
                        .tr('request_prayer_screen.form.recipient_name.label'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  controller: _recipientName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _translationProvider.tr(
                          'request_prayer_screen.form.recipient_name.validation');
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
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
              SizedBox(height: 18.0),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 26.0),
              //   child: AudioRecorderWidget(
              //     onAudioRecorded: (File file) {
              //       setState(() {
              //         audioFile = file;
              //       });
              //     },
              //   ),
              // ),
              // SizedBox(height: 10),
              ButtonThemeWidget(
                text: _translationProvider
                    .tr('request_prayer_screen.form.mobile_submit'),
                buttonStyle: StylesApp(context).btnWidgetSmall,
                width: 239.0,
                height: 41.0,
                onPressed: _sendPrayerRequest,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para instrucciones
  Widget _buildInstructionStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: StyleColor.orange,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // Función para enviar la petición (compartida)
  Future<void> _sendPrayerRequest() async {
    if (!_validateField()) {
      if (mounted) {
        await showCustomDialog(context,
            message: _translationProvider.tr('request_prayer_screen.errors'),
            dialogType: DialogType.error);
      }
      return;
    }
    LoadingService().showLoading(context);

    try {
      // almaceno en Model para formatear
      final requestData = RequestPrayerModel(
        audio: null,
        description: _descriptionController.text,
        prayerFor: _recipientName.text,
        prayerSubTypeId: subtypeSelected!.value,
        userId: userData!.userId,
      );

      // llamo al servicio de crear una solicitud
      final responseCreatedRequest = await sendPrayerRequest(requestData);

      // si hay error lo muestro
      if (responseCreatedRequest.error != null) {
        LoadingService().hideLoading();
        if (mounted) {
          await showCustomDialog(context,
              message: responseCreatedRequest.error!,
              dialogType: DialogType.error);
        }
        return;
      }

      // cierro el loading
      if (!responseCreatedRequest.data['successful']) {
        LoadingService().hideLoading();
        if (mounted) {
          await showCustomDialog(context,
              message: responseCreatedRequest.data['message'],
              dialogType: DialogType.error);
        }
        return;
      }

      LoadingService().hideLoading();
      if (mounted) {
        openModalSendSuccessfully(context);
      }
    } catch (e) {
      LoadingService().hideLoading();
      if (mounted) {
        await showCustomDialog(context,
            message: e.toString(), dialogType: DialogType.error);
      }
    } finally {
      LoadingService().hideLoading();
    }
  }

  // Modal de éxito (compartido)
  Future<dynamic> openModalSendSuccessfully(
    BuildContext context,
  ) {
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
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: isTablet ? 500 : double.infinity),
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
                            _translationProvider.tr(
                                'request_prayer_screen.success_modal.title'),
                            style: StylesApp(context).textStyleTitleOrange,
                          ),
                          SizedBox(height: 21.0),
                          Text(
                            textAlign: TextAlign.center,
                            _translationProvider.tr(
                                'request_prayer_screen.success_modal.message_1'),
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: Colors.black,
                                ),
                          ),
                          SizedBox(height: 21.0),
                          Text(
                            textAlign: TextAlign.center,
                            _translationProvider.tr(
                                'request_prayer_screen.success_modal.message_2'),
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: Colors.black,
                                ),
                          ),
                          SizedBox(height: 21.0),
                          Text(
                            textAlign: TextAlign.center,
                            _translationProvider.tr(
                                'request_prayer_screen.success_modal.verse'),
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: Colors.black,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: ButtonThemeWidget(
                        text: _translationProvider.tr(
                            'request_prayer_screen.success_modal.accept_button'),
                        buttonStyle: StylesApp(context).btnWidgetSmall,
                        width: 239.0,
                        height: 41.0,
                        onPressed: () {
                          Navigator.popAndPushNamed(context, '/prayerPage');
                        },
                      ),
                    ),
                    SizedBox(height: 34.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
