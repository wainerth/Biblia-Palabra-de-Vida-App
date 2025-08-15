import 'dart:async';
import 'dart:math';

import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/services/audio_service.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen>
    with WidgetsBindingObserver {
  String difficulty = '';
  List<MemoryModel> lisMemory = [];
  List<bool> flippedCards = [];
  List<bool> matchedCards = [];
  int? firstSelectedIndex;
  bool canFlip = true;
  bool isBackgroundPlaying = true;
  bool _playWin = false;
  late AudioService _audioService;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService(); // Initialize the audio service
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadData();
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _audioService.stopBackgroundMusic(); // Detener música al salir
    _audioService.dispose(); // Liberar recursos del audio
    WidgetsBinding.instance.removeObserver(this); // Limpiar el observer
    super.dispose();
  }

  // Manejo del ciclo de vida de la aplicación para pausar/reanudar música
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _audioService.pauseBackgroundMusic();
    } else if (state == AppLifecycleState.resumed) {
      _audioService.playBackgroundMusic();
    }
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
          'Memoria',
          style: StylesApp(context)
              .textStyleBody16
              .copyWith(color: StyleColor.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.volume_up, color: StyleColor.white),
            onPressed: () async {
              if (isBackgroundPlaying) {
                _audioService.stopBackgroundMusic();
                setState(() => isBackgroundPlaying = false);
                await PreferencesManager().setBackgroundPlaying(false);
              } else {
                _audioService.playBackgroundMusic();
                await PreferencesManager().setBackgroundPlaying(true);
                setState(() => isBackgroundPlaying = true);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: difficulty.isEmpty
              ? _buildSelectedDifficulty()
              : _buildPlayScene(),
        ),
      ),
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
              difficulty = "Facil";
              flippedCards = List<bool>.filled(lisMemory.length, false);
              matchedCards = List<bool>.filled(lisMemory.length, false);
            });
            print('DEBUG: Dificultad seleccionada: F. Iniciando precarga...');
            await _preloadImages(); // <-- Asegúrate de que este await termine.
            print('DEBUG: Precarga de imágenes completada para dificultad F.');
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
              difficulty = "Medio";
              flippedCards = List<bool>.filled(lisMemory.length, false);
              matchedCards = List<bool>.filled(lisMemory.length, false);
            });
            print('DEBUG: Dificultad seleccionada: I. Iniciando precarga...');
            await _preloadImages(); // <-- Asegúrate de que este await termine.
            print('DEBUG: Precarga de imágenes completada para dificultad I.');
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
              difficulty = "Difícil";
              flippedCards = List<bool>.filled(lisMemory.length, false);
              matchedCards = List<bool>.filled(lisMemory.length, false);
            });
            print('DEBUG: Dificultad seleccionada: D. Iniciando precarga...');
            await _preloadImages(); // <-- Asegúrate de que este await termine.
            print('DEBUG: Precarga de imágenes completada para dificultad D.');
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Text(
          "¡Encuentra los pares para ganar!",
          style: StylesApp(context)
              .textStyleBody20
              .copyWith(color: StyleColor.black),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            padding: const EdgeInsets.all(16.0),
            itemCount: lisMemory.length,
            itemBuilder: (BuildContext context, int index) {
              return MemoryCard(
                card: lisMemory[index],
                isFlipped:
                    flippedCards.isNotEmpty ? flippedCards[index] : false,
                isMatched:
                    matchedCards.isNotEmpty ? matchedCards[index] : false,
                onTap: () => _handleCardTap(index),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Tiempo Restante: ",
          style: StylesApp(context)
              .textStyleBody15
              .copyWith(color: StyleColor.black),
        ),
        Center(
          child: CountDownWidget(
            win: _playWin,
            initialCount: getTimeLevel(difficulty),
            onFinished: () {
              if (!_playWin) {
                _audioService.playTimeUpSound();
                _showTimeUpDialog();
              }
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _showDialogFinallyPlay() async {
    LoadingService().showLoading(context);

    try {
      final userData =
          Provider.of<UserProvider>(context, listen: false).currentUser;
      final responseSaveResult =
          await saveResultPlay(userData!.userId, difficulty, 'memoria');
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

      final responseResult = await getAllResultGame(userData.userId, 'memoria');
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
          title: Text(
            textAlign: TextAlign.center,
            "${infoResult.message.resultTitle}",
            style: StylesApp(context)
                .textStyleBody18
                .copyWith(color: StyleColor.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                textAlign: TextAlign.center,
                "${infoResult.message.resultDescription}",
                style: StylesApp(context)
                    .textStyleBody16
                    .copyWith(color: StyleColor.black),
              ),
              Text(
                textAlign: TextAlign.center,
                "Dificultad: ${infoResult.message.difficulty}",
                style: StylesApp(context)
                    .textStyleBody12
                    .copyWith(color: StyleColor.grayMedium),
              ),
              Text(
                textAlign: TextAlign.center,
                "Puntaje obtenido:  ${infoResult.score}",
                style: StylesApp(context)
                    .textStyleBody12
                    .copyWith(color: StyleColor.grayMedium),
              )
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
                });
                _audioService.playBackgroundMusic();
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
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text('¡Felicidades!'),
    //     content: const Text('Has encontrado todos los pares.'),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Navigator.pop(context);
    //           setState(() {
    //             difficulty = '';
    //             flippedCards = [];
    //             matchedCards = [];
    //             firstSelectedIndex = null;
    //           });
    //         },
    //         child: const Text('Jugar de nuevo'),
    //       ),
    //     ],
    //   ),
    // );
  }

  void _showTimeUpDialog() {
    setState(() {
      _audioService.stopBackgroundMusic();
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¡Tiempo terminado!'),
        content:
            const Text('Se acabó el tiempo. ¿Quieres intentarlo de nuevo?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                difficulty = '';
                flippedCards = [];
                matchedCards = [];
                firstSelectedIndex = null;
              });
              _audioService.playBackgroundMusic();
              _audioService.stopTimeUpSound();
            },
            child: const Text('Jugar de nuevo'),
          ),
        ],
      ),
    );
  }

  String getCounter(int i) {
    final counter = Duration(seconds: i);
    setState(() {});
    return (counter.inSeconds - 1).toString();
  }

  Future<void> _loadData() async {
    final musicBackground = await PreferencesManager().getIsBackgroundPlaying();
    if (musicBackground == true) {
      _audioService.playBackgroundMusic();
    } else {
      _audioService.stopBackgroundMusic();
    }

    setState(() => isBackgroundPlaying = musicBackground);

    LoadingService().showLoading(context);
    try {
      final memoryResponse = await getMemory();
      if (memoryResponse.error != null) {
        LoadingService().hideLoading();
        await showCustomDialogWithAction(context,
            message: memoryResponse.error!,
            dialogType: DialogTypeAction.error,
            textButton: "Reintentar",
            actionCallback: () => _loadData(),
            buttonOk: "Volver",
            actionCallbackOk: () => {
                  Navigator.pushNamed(context, "/layout"),
                  _audioService.stopBackgroundMusic(),
                });
        return;
      }

      setState(() {
        lisMemory = memoryResponse.data
            .map<MemoryModel>((memory) => MemoryModel.fromJson(memory))
            .toList();
        flippedCards = List<bool>.filled(lisMemory.length, false);
        matchedCards = List<bool>.filled(lisMemory.length, false);
      });
      LoadingService().hideLoading();
    } catch (e) {
      LoadingService().hideLoading();
      await showCustomDialogWithAction(context,
          message: e.toString(),
          dialogType: DialogTypeAction.error,
          buttonOk: "Reintentar",
          actionCallbackOk: () => _loadData());
    } finally {
      LoadingService().hideLoading();
    }
  }

  void _handleCardTap(int index) async {
    if (!canFlip || flippedCards[index] || matchedCards[index]) return;
    await _audioService.playCardTapSound();
    setState(() {
      flippedCards[index] = true;
    });

    if (firstSelectedIndex == null) {
      // Primera carta seleccionada
      firstSelectedIndex = index;
    } else {
      // Segunda carta seleccionada
      canFlip = false;
      final secondIndex = index;

      // Verificar si hay coincidencia
      if (lisMemory[firstSelectedIndex!].pair == lisMemory[secondIndex].pair) {
        // Coincidencia encontrada
        await _audioService.playMatchSound(); // Sonido de coincidencia
        setState(() {
          matchedCards[firstSelectedIndex!] = true;
          matchedCards[secondIndex] = true;
          flippedCards[firstSelectedIndex!] = false;
          flippedCards[secondIndex] = false;
        });
        firstSelectedIndex = null;
        canFlip = true;

        // Verificar si el juego ha terminado
        if (matchedCards.every((matched) => matched)) {
          setState(() {
            _playWin = true;
          });
          await _audioService.stopBackgroundMusic();
          await _audioService.playWinSound();
          _showDialogFinallyPlay();
        }
      } else {
        // No hay coincidencia, voltear de nuevo después de un retraso
        await _audioService.playNoMatchSound(); // Sonido de no coincidencia
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            flippedCards[firstSelectedIndex!] = false;
            flippedCards[secondIndex] = false;
            firstSelectedIndex = null;
            canFlip = true;
          });
        });
      }
    }
  }

  int getTimeLevel(String difficulty) {
    if (difficulty == 'Facil') {
      return 90;
    } else if (difficulty == 'Medio') {
      return 60;
    } else {
      return 40;
    }
  }

  Future<void> _preloadImages() async {
    // Muestra un indicador de carga mientras precargas las imágenes
    LoadingService().showLoading(context);

    // Iterar sobre todas las MemoryModel y precargar sus imágenes
    final List<Future<void>> precacheFutures = [];
    for (final memoryItem in lisMemory) {
      final imageUrl = "${GraphQLConfig.urlServidor}${memoryItem.img.urlImg}";
      // print('DEBUG: Preloading image: $imageUrl');
      precacheFutures.add(precacheImage(
        NetworkImage(imageUrl),
        context,
      ));
    }

    // Esperar a que TODAS las imágenes se precarguen
    await Future.wait(precacheFutures);
    LoadingService().hideLoading();
    // Aquí podrías agregar un pequeño delay si quieres que el usuario vea un "cargando"
    // o simplemente que el juego empiece instantáneamente después de la carga.
  }
}

class CountDownWidget extends StatefulWidget {
  final int initialCount;
  final bool win;
  final VoidCallback? onFinished;
  const CountDownWidget(
      {super.key,
      required this.initialCount,
      this.onFinished,
      this.win = false});

  @override
  State<CountDownWidget> createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  late int _currentCount;
  Timer? _timer;
  late AudioService _audioService;

  @override
  void initState() {
    super.initState();
    _currentCount = widget.initialCount;
    _startCountDown();
    _audioService = AudioService(); // Initialize the audio service
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioService.dispose(); // Liberar recursos del audio
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "$_currentCount",
      style: StylesApp(context).textStyCompleteLevelTitle.copyWith(
          color: _currentCount <= 10 ? StyleColor.redDark : StyleColor.black),
    );
  }

  void _startCountDown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentCount > 0) {
          if (_currentCount <= 10 && !widget.win) {
            _audioService.playCounterClock();
          }
          _currentCount--;
        } else {
          _audioService.stopCounterClock();
          _timer?.cancel();
          if (widget.onFinished != null) {
            widget.onFinished!();
          }
        }
      });
    });
  }
}

class MemoryCard extends StatelessWidget {
  final MemoryModel card;
  final bool isFlipped;
  final bool isMatched;
  final VoidCallback onTap;

  const MemoryCard({
    super.key,
    required this.card,
    required this.isFlipped,
    required this.isMatched,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotateAnim = Tween(begin: pi / 2, end: 0.0).animate(animation);
          return RotationYTransition(
            rotation: rotateAnim,
            child: child,
          );
        },
        child: isFlipped || isMatched ? _buildFrontCard() : _buildBackCard(),
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      key: const ValueKey('front'),
      decoration: BoxDecoration(
        color: StyleColor.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: StyleColor.black.withValues(alpha: 0.25),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Image.network(
          "${GraphQLConfig.urlServidor}${card.img.urlImg}",
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      key: const ValueKey('back'),
      decoration: BoxDecoration(
        color: StyleColor.cosmicBlue,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: StyleColor.black.withValues(alpha: 0.25),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.question_mark,
          size: 40,
          color: StyleColor.white,
        ),
      ),
    );
  }
}

class RotationYTransition extends AnimatedWidget {
  final Widget child;
  final Animation<double> rotation;

  const RotationYTransition({
    super.key,
    required this.rotation,
    required this.child,
  }) : super(listenable: rotation);

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(rotation.value),
      alignment: Alignment.center,
      child: child,
    );
  }
}
