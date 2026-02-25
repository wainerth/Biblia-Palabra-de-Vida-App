import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/services/audio_service.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class Personaje {
  final String nombre;
  final String imagen;

  Personaje({required this.nombre, required this.imagen});
}

class ReddleScreen extends StatefulWidget {
  const ReddleScreen({super.key});

  @override
  State<ReddleScreen> createState() => _ReddleScreenState();
}

class _ReddleScreenState extends State<ReddleScreen> {
  // variable que contiene las traducciones de esta pantalla
  final _translationProvider = AppTranslationProvider();
  String difficulty = '';
  // Datos del juego
  List<GuessCharacter> personajes = [];
  TextEditingController nameCharacter = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  GuessCharacter? personajeActual;
  String? respuestaSeleccionada;
  bool mostrarImagen = false;
  bool respuestaCorrecta = false;
  int failedAttempts = 3;
  late AudioService _audioService;

  // Función para determinar si es tablet
  bool get isTablet {
    final width = MediaQuery.of(context).size.width;
    return width >= 600;
  }

  @override
  void initState() {
    super.initState();
    _audioService = AudioService(); // Initialize the audio service
  }

  Future<void> loadCharacters() async {
    LoadingService().showLoading(context);
    try {
      final guessResponse =
          await getAllGuessCharacters(null, null, difficulty, null);
      if (guessResponse.error != null) {
        LoadingService().hideLoading();
        if (mounted) {
          await showCustomDialogWithAction(context,
              message: guessResponse.error!,
              dialogType: DialogTypeAction.error,
              buttonOk: "Ok", actionCallbackOk: () {
            Navigator.pop(context);
          });
        }
        setState(() {
          difficulty = '';
        });
        return;
      }
      if (guessResponse.data['data'].isNotEmpty) {
        setState(() {
          personajes = guessResponse.data['data']
              .map<GuessCharacter>((guess) => GuessCharacter.fromJson(guess))
              .toList();
          // List<GuessCharacter> randomCharacter = personajes..shuffle();
          personajeActual = personajes.first;
          respuestaSeleccionada = null;
          mostrarImagen = false;
          respuestaCorrecta = false;
        });
      } else {
        LoadingService().hideLoading();
        if (mounted) {
          await showCustomDialogWithAction(context,
              message:
                  _translationProvider.tr("quiz_screen.errors.no_characters"),
              dialogType: DialogTypeAction.info,
              buttonOk: "Ok", actionCallbackOk: () {
            Navigator.pop(context);
          });
        }
        setState(() {
          difficulty = '';
        });
        return;
      }
    } catch (e) {
      LoadingService().hideLoading();
      if (mounted) {
        await showCustomDialogWithAction(context,
            message: e.toString(),
            dialogType: DialogTypeAction.error,
            buttonOk: "Ok", actionCallbackOk: () {
          Navigator.pop(context);
        });
      }
      setState(() {
        difficulty = '';
      });
      return;
    } finally {
      LoadingService().hideLoading();
    }
  }

  void _verificarRespuesta(String respuesta) {
    // _focusNode.dispose();

    setState(() {
      respuestaSeleccionada = respuesta;
      respuestaCorrecta = respuesta.toLowerCase() ==
          personajeActual?.character.name.toLowerCase();
      mostrarImagen = true;
      if (!respuestaCorrecta) {
        failedAttempts -= 1;
        _audioService.playWrongAnswer();
      } else {
        _audioService.playCorrectAnswer();
      }
    });
    // Opcional: Mostrar feedback y cambiar de personaje después de un tiempo
    Future.delayed(Duration(seconds: 4), () {
      if (failedAttempts > 0) {
        if (personajes.indexOf(personajeActual!) < personajes.length - 1) {
          _nuevoPersonaje();
        } else {
          _audioService.playWinSound();
          _showDialogFinallyPlay();
        }
      } else {
        _audioService.playFailedAttempts();
        _showDialogFailedAttempts();
      }
    });
    setState(() {
      nameCharacter.text = '';
    });
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
              foregroundColor: WidgetStatePropertyAll(StyleColor.white)),
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pop(context);
          },
          splashColor: StyleColor.orange,
          color: StyleColor.white,
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        backgroundColor: StyleColor.turquoise,
        title: Text(
          _translationProvider.tr("quiz_screen.title"),
          style: StylesApp(context)
              .textStyleBody16
              .copyWith(color: StyleColor.white),
        ),
      ),
      body: SafeArea(
          child: Container(
        child:
            difficulty.isEmpty ? _buildSelectedDifficulty() : _buildPlayScene(),
      )),
    );
  }

  Widget _buildSelectedDifficulty() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isTablet ? 500 : double.infinity,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: isTablet ? 20.0 : 0),
            Text(
              _translationProvider.tr("quiz_screen.difficulty_selection.title"),
              style: isTablet
                  ? StylesApp(context).textStyleBody24.copyWith(
                        color: StyleColor.black,
                        fontWeight: FontWeight.bold,
                      )
                  : StylesApp(context).textStyleBody20.copyWith(
                        color: StyleColor.black,
                      ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 40.0 : 20.0),
            _buildDifficultyButton(
                _translationProvider
                    .tr("quiz_screen.difficulty_selection.easy"),
                Icons.face_2_rounded),
            SizedBox(height: isTablet ? 24.0 : 15),
            _buildDifficultyButton(
                _translationProvider
                    .tr("quiz_screen.difficulty_selection.medium"),
                Icons.face_2_rounded),
            SizedBox(height: isTablet ? 24.0 : 15),
            _buildDifficultyButton(
                _translationProvider
                    .tr("quiz_screen.difficulty_selection.hard"),
                Icons.face_2_rounded),
            SizedBox(height: isTablet ? 40.0 : 15),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(String level, IconData icon) {
    return GestureDetector(
      onTap: () => _selectDifficulty(_getDifficultyCharacter(level)),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16.0 : 8.0),
        margin: EdgeInsets.symmetric(
          horizontal: isTablet ? 60.0 : 12.0,
          vertical: isTablet ? 8.0 : 0,
        ),
        constraints: BoxConstraints(
          minHeight: isTablet ? 100 : 80,
          minWidth: isTablet ? 300 : double.infinity,
        ),
        decoration: BoxDecoration(
          color: StyleColor.white,
          border: Border.all(
            color: StyleColor.cosmicBlue,
            strokeAlign: 0.5,
            width: isTablet ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(isTablet ? 16.0 : 8.0),
          boxShadow: [
            BoxShadow(
              blurRadius: isTablet ? 16 : 12,
              offset: Offset(0, isTablet ? 6 : 4),
              color: StyleColor.black.withValues(alpha: isTablet ? 0.2 : 0.25),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isTablet ? 32 : 24,
              color: _getDifficultyColor(level),
            ),
            SizedBox(width: isTablet ? 20.0 : 12.0),
            Text(
              level,
              style: isTablet
                  ? StylesApp(context).textStyleBody24.copyWith(
                        color: _getDifficultyColor(level),
                        fontWeight: FontWeight.w600,
                      )
                  : StylesApp(context).textStyleBody20.copyWith(
                        color: StyleColor.black,
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDifficulty(String level) async {
    if (!mounted) return;
    setState(() {
      difficulty = level;
    });
    await loadCharacters();
  }

  Widget _buildPlayScene() {
    return isTablet ? _buildSceneTablet() : _buildSceneMobile();
  }

  _buildSceneTablet() {
    return Container(
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          // Header con oportunidades
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            margin: EdgeInsets.only(bottom: 20.0),
            decoration: BoxDecoration(
              color: StyleColor.cosmicBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _translationProvider
                          .tr("quiz_screen.game_play.header.title"),
                      style: StylesApp(context).textStyleBody20.copyWith(
                            color: StyleColor.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      _translationProvider.trParams(
                          "quiz_screen.game_play.header.difficulty",
                          {"difficulty": difficulty}),
                      style: StylesApp(context)
                          .textStyleBody14
                          .copyWith(color: StyleColor.grayDark),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _translationProvider
                          .tr("quiz_screen.game_play.header.opportunities"),
                      style: StylesApp(context)
                          .textStyleBody14
                          .copyWith(color: StyleColor.grayDark),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          failedAttempts > 2
                              ? "assets/fire_rachaActive.png"
                              : "assets/fire_rachaInactive.png",
                          width: 24,
                        ),
                        SizedBox(width: 4),
                        Image.asset(
                          failedAttempts > 1
                              ? "assets/fire_rachaActive.png"
                              : "assets/fire_rachaInactive.png",
                          width: 24,
                        ),
                        SizedBox(width: 4),
                        Image.asset(
                          failedAttempts > 0
                              ? "assets/fire_rachaActive.png"
                              : "assets/fire_rachaInactive.png",
                          width: 24,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Contenedor principal con dos columnas
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // COLUMNA IZQUIERDA: Imagen y entrada de texto
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.only(right: 12.0),
                    decoration: BoxDecoration(
                      color: StyleColor.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 16,
                          offset: Offset(0, 6),
                          color: StyleColor.black.withValues(alpha: 0.1),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Progreso
                          Container(
                            padding: EdgeInsets.all(12.0),
                            margin: EdgeInsets.only(bottom: 16.0),
                            decoration: BoxDecoration(
                              color:
                                  StyleColor.turquoise.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _translationProvider.tr(
                                      "quiz_screen.game_play.header.progress"),
                                  style: StylesApp(context)
                                      .textStyleBody15
                                      .copyWith(
                                        color: StyleColor.black,
                                      ),
                                ),
                                Text(
                                  personajes.isNotEmpty
                                      ? "${personajes.indexOf(personajeActual!) + 1}/${personajes.length}"
                                      : "0/0",
                                  style: StylesApp(context)
                                      .textStyleBody16
                                      .copyWith(
                                        color: StyleColor.turquoise,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // Imagen del personaje
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: mostrarImagen && personajeActual != null
                                  ? StyleColor.white
                                  : Colors.grey[400],
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 6),
                                  color:
                                      StyleColor.black.withValues(alpha: 0.25),
                                  blurRadius: 16,
                                )
                              ],
                            ),
                            child: Center(
                              child: mostrarImagen && personajeActual != null
                                  ? Image.network(
                                      "${GraphQLConfig.urlServidor}${personajeActual!.character.img.urlImg}",
                                      fit: BoxFit.contain,
                                    )
                                  : Icon(
                                      Icons.question_mark_sharp,
                                      size: 120,
                                      color: StyleColor.grayMedium,
                                    ),
                            ),
                          ),

                          SizedBox(height: 24),

                          // Título y pregunta
                          Text(
                            _translationProvider
                                .tr("quiz_screen.game_play.question"),
                            style: StylesApp(context).textStyleBody20.copyWith(
                                  color: StyleColor.black,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: 16),

                          // Campo de texto para respuesta
                          TextFormField(
                            controller: nameCharacter,
                            focusNode: _focusNode,
                            textInputAction: TextInputAction.done,
                            onTapOutside: (event) {
                              _focusNode.unfocus();
                            },
                            decoration: StylesApp(context)
                                .inputDecorationOutlineStyle
                                .copyWith(
                                  hintText: _translationProvider
                                      .tr("quiz_screen.game_play.input_hint"),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(16.0),
                                ),
                            style: StylesApp(context)
                                .textStyleBody14
                                .copyWith(color: StyleColor.black),
                          ),

                          SizedBox(height: 20),

                          // Botón de verificar
                          ButtonThemeWidget(
                            text: _translationProvider
                                .tr("quiz_screen.game_play.verify_button"),
                            width: double.infinity,
                            height: 50,
                            buttonStyle:
                                StylesApp(context).btnWidgetSmall.copyWith(
                                      backgroundColor: WidgetStatePropertyAll(
                                        nameCharacter.text.isEmpty
                                            ? StyleColor.grayMedium
                                                .withValues(alpha: 0.5)
                                            : StyleColor.turquoise,
                                      ),
                                    ),
                            disabled: nameCharacter.text.isEmpty,
                            onPressed: nameCharacter.text.isEmpty
                                ? null
                                : () {
                                    _verificarRespuesta(
                                        nameCharacter.text.trim());
                                  },
                          ),

                          // Feedback de respuesta
                          if (respuestaSeleccionada != null && mostrarImagen)
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: respuestaCorrecta
                                    ? StyleColor.greenDark
                                        .withValues(alpha: 0.1)
                                    : StyleColor.redDark.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: respuestaCorrecta
                                      ? StyleColor.greenDark
                                      : StyleColor.redDark,
                                  width: 2.0,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    respuestaCorrecta
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: respuestaCorrecta
                                        ? StyleColor.greenDark
                                        : StyleColor.redDark,
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Flexible(
                                    child: Text(
                                      respuestaCorrecta
                                          ? _translationProvider.tr(
                                              "quiz_screen.game_play.feedback.correct")
                                          : _translationProvider.trParams(
                                              "quiz_screen.game_play.feedback.incorrect",
                                              {
                                                  "name": personajeActual!
                                                      .character.name
                                                }),
                                      style: StylesApp(context)
                                          .textStyleBody16
                                          .copyWith(
                                            color: _getColorText(),
                                            fontWeight: FontWeight.w600,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // COLUMNA DERECHA: Pistas
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: StyleColor.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 16,
                          offset: Offset(0, 6),
                          color: StyleColor.black.withValues(alpha: 0.1),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header de pistas
                          Container(
                            padding: EdgeInsets.all(16.0),
                            margin: EdgeInsets.only(bottom: 20.0),
                            decoration: BoxDecoration(
                              color: StyleColor.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: StyleColor.orange,
                                width: 2.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lightbulb,
                                  color: StyleColor.orange,
                                  size: 28,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  _translationProvider
                                      .tr("quiz_screen.game_play.clues_title"),
                                  style: StylesApp(context)
                                      .textStyleBody28
                                      .copyWith(
                                        color: StyleColor.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // Lista de pistas con altura fija
                          Column(
                            children: _buildOpcionesTablet(personajes.isNotEmpty
                                ? personajes.first
                                : null),
                          ),

                          SizedBox(height: 20),

                          // Información adicional
                          Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color:
                                  StyleColor.blueLight.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _translationProvider.tr(
                                      "quiz_screen.game_play.instructions.title"),
                                  style: StylesApp(context)
                                      .textStyleBody16
                                      .copyWith(
                                        color: StyleColor.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "${_translationProvider.tr("quiz_screen.game_play.instructions.step1")}\n${_translationProvider.tr("quiz_screen.game_play.instructions.step2")}\n${_translationProvider.tr("quiz_screen.game_play.instructions.step3")}\n${_translationProvider.tr("quiz_screen.game_play.instructions.step4")}",
                                  style: StylesApp(context)
                                      .textStyleBody14
                                      .copyWith(
                                        color: StyleColor.grayDark,
                                        height: 1.5,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),
        ],
      ),
    );
  }

  _buildSceneMobile() {
    if (personajeActual == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return SingleChildScrollView(
      child: Stack(children: [
        Positioned(
          top: 0,
          right: 0,
          child: Row(
            children: [
              Text(
                "${_translationProvider.tr("quiz_screen.game_play.header.opportunities")}: ",
                style: StylesApp(context)
                    .textStyleBody10
                    .copyWith(color: StyleColor.grayMedium),
              ),
              Image.asset(
                failedAttempts > 2
                    ? "assets/fire_rachaActive.png"
                    : "assets/fire_rachaInactive.png",
                width: 20,
              ),
              Image.asset(
                failedAttempts > 1
                    ? "assets/fire_rachaActive.png"
                    : "assets/fire_rachaInactive.png",
                width: 20,
              ),
              Image.asset(
                failedAttempts > 0
                    ? "assets/fire_rachaActive.png"
                    : "assets/fire_rachaInactive.png",
                width: 20,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                _translationProvider
                    .tr("quiz_screen.game_play.header.mobile_title"),
                style: StylesApp(context)
                    .textStyleBody20
                    .copyWith(color: StyleColor.black),
              ),
            ),
            const SizedBox(height: 20),
            // Imagen del personaje (con signo de interrogación o imagen real)
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  backgroundBlendMode: BlendMode.color,
                  color: mostrarImagen && personajeActual != null
                      ? StyleColor.white
                      : Colors.grey[400],
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 4),
                        color: StyleColor.black.withValues(alpha: 0.25),
                        blurRadius: 12)
                  ]),
              child: mostrarImagen && personajeActual != null
                  ? Image.network(
                      "${GraphQLConfig.urlServidor}${personajeActual!.character.img.urlImg}",
                      color: StyleColor.black,
                    )
                  : Icon(
                      Icons.question_mark_sharp,
                      fill: 1,
                      size: 150,
                    ),
            ),
            SizedBox(height: 15),
            // Pregunta
            Text(
              _translationProvider.tr("quiz_screen.game_play.question"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (personajes.isNotEmpty)
              Text(
                  "${personajes.indexOf(personajeActual!) + 1}/${personajes.length}"),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: TextFormField(
                controller: nameCharacter,
                focusNode: _focusNode,
                textInputAction: TextInputAction.done,
                onTapOutside: (event) {
                  _focusNode.unfocus();
                },
                decoration: StylesApp(context)
                    .inputDecorationOutlineStyle
                    .copyWith(
                        hintText: _translationProvider
                            .tr("quiz_screen.game_play.input_hint")),
              ),
            ),
            Text(
              _translationProvider.tr("quiz_screen.game_play.clues_mobile"),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Feedback
            if (respuestaSeleccionada != null && mostrarImagen)
              Text(
                respuestaCorrecta
                    ? _translationProvider
                        .tr("quiz_screen.game_play.feedback.correct")
                    : _translationProvider.trParams(
                        "quiz_screen.game_play.feedback.incorrect",
                        {"name": personajeActual!.character.name}),
                style: TextStyle(
                  fontSize: 18,
                  color: _getColorText(),
                ),
              ),
            SizedBox(height: 5),
            // Pistas de respuesta
            if (personajeActual != null) ..._buildOpciones(personajeActual!),
            ButtonThemeWidget(
              text: "Verificar",
              disabled: nameCharacter.text.isEmpty,
              buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                  backgroundColor: nameCharacter.text.isEmpty
                      ? WidgetStatePropertyAll(
                          StyleColor.grayMedium.withValues(alpha: .50))
                      : null),
              onPressed: nameCharacter.text.isEmpty
                  ? null
                  : () {
                      _verificarRespuesta(nameCharacter.text.trim());
                    },
            ),
            SizedBox(
              height: 30.0,
            )
          ],
        ),
      ]),
    );
  }

// Versión mejorada de pistas para tablet
  List<Widget> _buildOpcionesTablet(GuessCharacter? personaje) {
    if (personaje == null) {
      return [
        Container(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Text(
              _translationProvider.tr("quiz_screen.game_play.loading_clues"),
              style: StylesApp(context).textStyleBody16,
            ),
          ),
        ),
      ];
    }

    final opciones = personaje.clues;
    return opciones.map((opcion) {
      return Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: StyleColor.cosmicBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: StyleColor.cosmicBlue,
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: StyleColor.cosmicBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "${opciones.indexOf(opcion) + 1}",
                  style: StylesApp(context).textStyleBody14.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                opcion.description,
                style: StylesApp(context).textStyleBody14.copyWith(
                      color: StyleColor.black,
                      height: 1.5,
                    ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildOpciones(GuessCharacter personaje) {
    final opciones = personaje.clues;
    print(personaje.character.name);
    return opciones.map((opcion) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.sizeOf(context).width,
            constraints: BoxConstraints(minHeight: 40.0),
            decoration: BoxDecoration(
                color: StyleColor.cosmicBlue,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                      color: StyleColor.black.withValues(alpha: 0.25),
                      offset: Offset(0, 4),
                      blurRadius: 12)
                ]),
            child: Text(
              opcion.description,
              style: StylesApp(context).textStyleBody14,
            ),
          ));
    }).toList();
  }

  Color? _getColorText() {
    if (respuestaSeleccionada == null) return null;

    if (respuestaCorrecta) {
      return Colors.green; // Respuesta correcta
    } else if (!respuestaCorrecta) {
      return Colors.red; // Respuesta incorrecta seleccionada
    }
    return null; // Otras opciones
  }

  void _showDialogFailedAttempts() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(_translationProvider
            .tr("quiz_screen.failed_attempts_dialog.title")),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 500 : double.infinity,
            maxHeight:
                isTablet ? 450 : MediaQuery.of(context).size.height * 0.5,
          ),
          child: Text(_translationProvider
              .tr("quiz_screen.failed_attempts_dialog.message")),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                difficulty = '';
                personajes = [];
                personajeActual = null;
                failedAttempts = 3;
                mostrarImagen = false;
                respuestaSeleccionada = '';
              });
            },
            child: Text(_translationProvider
                .tr("quiz_screen.failed_attempts_dialog.play_again")),
          ),
        ],
      ),
    );
  }

  void _showDialogFinallyPlay() async {
    LoadingService().showLoading(context);
    String tipo = '';
    if (difficulty == 'F') {
      tipo = 'Facil';
    } else if (difficulty == 'I') {
      tipo = 'Medio';
    } else {
      tipo = 'Difícil';
    }
    try {
      final userData =
          Provider.of<UserProvider>(context, listen: false).currentUser;
      final responseSaveResult =
          await saveResultPlay(userData!.userId, tipo, 'adivinanza');
      if (responseSaveResult.error != null) {
        LoadingService().hideLoading();
        if (mounted) {
          await showCustomDialogWithAction(context,
              message: responseSaveResult.error!,
              dialogType: DialogTypeAction.error,
              buttonOk:
                  _translationProvider.tr("quiz_screen.load_error_dialog.back"),
              actionCallbackOk: () {
                Navigator.pop(context);
              },
              textButton: _translationProvider
                  .tr("quiz_screen.load_load_error_dialog.retry"),
              actionCallback: () {
                _showDialogFinallyPlay();
              });
        }
        return;
      }

      final responseResult =
          await getAllResultGame(userData.userId, 'adivinanza');
      if (responseResult.error != null) {
        LoadingService().hideLoading();
        if (mounted) {
          await showCustomDialogWithAction(context,
              message: responseSaveResult.error!,
              dialogType: DialogTypeAction.error,
              buttonOk:
                  _translationProvider.tr("quiz_screen.load_error_dialog.back"),
              actionCallbackOk: () {
                Navigator.pop(context);
              },
              textButton: _translationProvider
                  .tr("quiz_screen.load_error_dialog.retry"),
              actionCallback: () {
                _showDialogFinallyPlay();
              });
        }
        return;
      }
      LoadingService().hideLoading();
      final ResultGameModel infoResult =
          ResultGameModel.fromJson(responseResult.data);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("${infoResult.message.resultTitle}"),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 500 : double.infinity,
                maxHeight:
                    isTablet ? 450 : MediaQuery.of(context).size.height * 0.5,
              ),
              child: Column(
                children: [
                  Text(
                    "${infoResult.message.resultDescription}",
                    style: StylesApp(context)
                        .textStyleBody16
                        .copyWith(color: StyleColor.black),
                  ),
                  Text(
                      "${_translationProvider.trParams("quiz_screen.result_dialog.category", {
                        "category": infoResult.message.category!,
                      })} ${_translationProvider.trParams("quiz_screen.result_dialog.difficulty", {
                        "difficulty": infoResult.message.difficulty!,
                      })}"),
                  Text(_translationProvider
                      .trParams("quiz_screen.result_dialog.score", {
                    "score": infoResult.score.toString(),
                  }))
                ],
              ),
            ),
            actions: [
              ButtonThemeWidget(
                text: _translationProvider
                    .tr("quiz_screen.result_dialog.play_again"),
                buttonStyle: StylesApp(context).btnWidgetSmall,
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    difficulty = '';
                    personajes = [];
                    personajeActual = null;
                    failedAttempts = 3;
                    mostrarImagen = false;
                    respuestaSeleccionada = '';
                  });
                },
              )
            ],
          ),
        );
      }
    } catch (e) {
      LoadingService().hideLoading();
      if (mounted) {
        await showCustomDialogWithAction(context,
            message: e.toString(),
            dialogType: DialogTypeAction.error,
            buttonOk:
                _translationProvider.tr("quiz_screen.load_error_dialog.back"),
            actionCallbackOk: () {
              Navigator.pop(context);
            },
            textButton:
                _translationProvider.tr("quiz_screen.load_error_dialog.retry"),
            actionCallback: () {
              _showDialogFinallyPlay();
            });
      }
    } finally {
      LoadingService().hideLoading();
    }
  }

  void _nuevoPersonaje() {
    setState(() {
      mostrarImagen = false;
      respuestaCorrecta = false;
      respuestaSeleccionada = '';
      personajeActual = personajes[personajes.indexOf(personajeActual!) + 1];
    });
  }

  Color _getDifficultyColor(String level) {
    if (_translationProvider.tr('quiz_screen.difficulty_selection.easy') ==
        level) {
      return StyleColor.greenDark;
    } else if (_translationProvider
            .tr('quiz_screen.difficulty_selection.medium') ==
        level) {
      return StyleColor.orange;
    } else if (_translationProvider
            .tr('quiz_screen.difficulty_selection.hard') ==
        level) {
      return StyleColor.redDark;
    } else {
      return StyleColor.black;
    }
  }

  String _getDifficultyCharacter(String level) {
    if (_translationProvider.tr('quiz_screen.difficulty_selection.easy') ==
        level) {
      return 'F';
    } else if (_translationProvider
            .tr('quiz_screen.difficulty_selection.medium') ==
        level) {
      return 'I';
    } else if (_translationProvider
            .tr('quiz_screen.difficulty_selection.hard') ==
        level) {
      return 'D';
    } else {
      return 'F';
    }
  }
}
