import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
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
  String difficulty = '';
  // Datos del juego
  List<GuessCharacter> personajes = [];
  TextEditingController nameCharacter = TextEditingController();
  GuessCharacter? personajeActual;
  String? respuestaSeleccionada;
  bool mostrarImagen = false;
  bool respuestaCorrecta = false;
  int failedAttempts = 3;
  late AudioService _audioService;

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
        await showCustomDialogWithAction(context,
            message: guessResponse.error!,
            dialogType: DialogTypeAction.error,
            buttonOk: "Ok", actionCallbackOk: () {
          Navigator.pop(context);
        });
        setState(() {
          difficulty = '';
        });
        return;
      }

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
      LoadingService().hideLoading();
    } catch (e) {
      LoadingService().hideLoading();
      await showCustomDialogWithAction(context,
          message: e.toString(),
          dialogType: DialogTypeAction.error,
          buttonOk: "Ok", actionCallbackOk: () {
        Navigator.pop(context);
      });
      setState(() {
        difficulty = '';
      });
      return;
    } finally {
      LoadingService().hideLoading();
    }
  }

  void _verificarRespuesta(String respuesta) {
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
          'Adivinanza',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            setState(() {
              difficulty = "F";
            });
            await loadCharacters();
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(12.0),
            constraints: BoxConstraints(minHeight: 80),
            decoration: BoxDecoration(
                color: StyleColor.white,
                border: Border.all(
                  color: StyleColor.cosmicBlue,
                  strokeAlign: 0.5,
                ),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 12,
                      offset: Offset(0, 4),
                      color: StyleColor.black.withValues(alpha: 0.25))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.face_2_rounded),
                Text(
                  "Fácil",
                  style: StylesApp(context)
                      .textStyleBody20
                      .copyWith(color: StyleColor.black),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () async {
            setState(() {
              difficulty = "I";
            });
            await loadCharacters();
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(12.0),
            constraints: BoxConstraints(minHeight: 80),
            decoration: BoxDecoration(
                color: StyleColor.white,
                border: Border.all(
                  color: StyleColor.cosmicBlue,
                  strokeAlign: 0.5,
                ),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 12,
                      offset: Offset(0, 4),
                      color: StyleColor.black.withValues(alpha: 0.25))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.face_2_rounded),
                Text(
                  "Medio",
                  style: StylesApp(context)
                      .textStyleBody20
                      .copyWith(color: StyleColor.black),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () async {
            setState(() {
              difficulty = "D";
            });
            await loadCharacters();
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(12.0),
            constraints: BoxConstraints(minHeight: 80),
            decoration: BoxDecoration(
                color: StyleColor.white,
                border: Border.all(
                  color: StyleColor.cosmicBlue,
                  strokeAlign: 0.5,
                ),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 12,
                      offset: Offset(0, 4),
                      color: StyleColor.black.withValues(alpha: 0.25))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.face_2_rounded),
                Text(
                  "Difícil",
                  style: StylesApp(context)
                      .textStyleBody20
                      .copyWith(color: StyleColor.black),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _buildPlayScene() {
    return SingleChildScrollView(
      child: Stack(children: [
        Positioned(
            top: 0,
            right: 0,
            child: Row(
              children: [
                Text(
                  "Oportunidades: ",
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
            )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                "¡Adivina el Personaje Bíblico!",
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
              '¿Quién es este personaje?',
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
                decoration: StylesApp(context)
                    .inputDecorationOutlineStyle
                    .copyWith(hintText: "Ingrese Nombre del Personaje"),
              ),
            ),
            Text(
              'Pistas....',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Feedback
            if (respuestaSeleccionada != null && mostrarImagen)
              Text(
                respuestaCorrecta
                    ? '¡Correcto!'
                    : 'Incorrecto, era ${personajeActual?.character.name}',
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
                      _verificarRespuesta(nameCharacter.text);
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
        title: const Text('¡Oportunidades Agotadas!'),
        content: const Text(
            'Haz Fallado Los Intentos Permitidos. ¿Quieres intentarlo de nuevo?'),
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
            child: const Text('Jugar de nuevo'),
          ),
        ],
      ),
    );
  }

  void _showDialogFinallyPlay() async {
    LoadingService().showLoading(context);

    try {
      final userData =
          Provider.of<UserProvider>(context, listen: false).currentUser;
      final responseSaveResult =
          await saveResultPlay(userData!.userId, difficulty, 'adivinanza');
      if (responseSaveResult.error != null) {
        LoadingService().hideLoading();
        await showCustomDialogWithAction(context,
            message: responseSaveResult.error!,
            dialogType: DialogTypeAction.error,
            buttonOk: "Volver",
            actionCallbackOk: () {
              Navigator.pop(context);
            },
            textButton: "Reintentar",
            actionCallback: () {
              _showDialogFinallyPlay();
            });
        return;
      }

      final responseResult =
          await getAllResultGame(userData.userId, 'adivinanza');
      if (responseResult.error != null) {
        LoadingService().hideLoading();
        await showCustomDialogWithAction(context,
            message: responseSaveResult.error!,
            dialogType: DialogTypeAction.error,
            buttonOk: "Volver",
            actionCallbackOk: () {
              Navigator.pop(context);
            },
            textButton: "Reintentar",
            actionCallback: () {
              _showDialogFinallyPlay();
            });
        return;
      }
      LoadingService().hideLoading();

      final ResultGameModel infoResult =
          ResultGameModel.fromJson(responseResult.data);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("${infoResult.message.resultTitle}"),
          content: Column(
            children: [
              Text(
                "${infoResult.message.resultDescription}",
                style: StylesApp(context)
                    .textStyleBody16
                    .copyWith(color: StyleColor.black),
              ),
              Text(
                  "Categoría:  ${infoResult.message.category} Dificultad: ${infoResult.message.difficulty}"),
              Text("Puntaje obtenido:  ${infoResult.score}")
            ],
          ),
          actions: [
            ButtonThemeWidget(
              text: "Jugar de nuevo",
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
    } catch (e) {
      LoadingService().hideLoading();
      await showCustomDialogWithAction(context,
          message: e.toString(),
          dialogType: DialogTypeAction.error,
          buttonOk: "Volver",
          actionCallbackOk: () {
            Navigator.pop(context);
          },
          textButton: "Reintentar",
          actionCallback: () {
            _showDialogFinallyPlay();
          });
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
}
