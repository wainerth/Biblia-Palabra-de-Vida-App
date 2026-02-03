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
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

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
  bool _isDisposed = false;
  late AudioService _audioService;

  // Función para determinar si es tablet
  bool get isTablet {
    final width = MediaQuery.of(context).size.width;
    return width >= 600;
  }

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isDisposed) await _loadData();
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _isDisposed = false;
    _audioService.stopBackgroundMusic();
    _audioService.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isDisposed) return;

    if (state == AppLifecycleState.paused) {
      _audioService.pauseBackgroundMusic();
    } else if (state == AppLifecycleState.resumed) {
      if (isBackgroundPlaying) {
        _audioService.restoreBackgroundMusic();
      }
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
            icon: Icon(isBackgroundPlaying ? Icons.volume_up : Icons.volume_off,
                color: StyleColor.white),
            onPressed: () async {
              if (isBackgroundPlaying) {
                _audioService.stopBackgroundMusic();
                setState(() => isBackgroundPlaying = false);
                await PreferencesManager().setBackgroundPlaying(false);
              } else {
                _audioService.restoreBackgroundMusic();
                await PreferencesManager().setBackgroundPlaying(true);
                setState(() => isBackgroundPlaying = true);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: isTablet
              ? EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0)
              : null,
          child: difficulty.isEmpty
              ? _buildSelectedDifficulty()
              : _buildPlayScene(),
        ),
      ),
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
              "Selecciona la dificultad",
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
            _buildDifficultyButton("Fácil", Icons.face_2_rounded),
            SizedBox(height: isTablet ? 24.0 : 15),
            _buildDifficultyButton("Medio", Icons.face_2_rounded),
            SizedBox(height: isTablet ? 24.0 : 15),
            _buildDifficultyButton("Difícil", Icons.face_2_rounded),
            SizedBox(height: isTablet ? 40.0 : 15),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(String level, IconData icon) {
    return GestureDetector(
      onTap: () => _selectDifficulty(level),
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

  Color _getDifficultyColor(String level) {
    switch (level) {
      case "Fácil":
        return StyleColor.greenDark;
      case "Medio":
        return StyleColor.orange;
      case "Difícil":
        return StyleColor.redDark;
      default:
        return StyleColor.black;
    }
  }

  Future<void> _selectDifficulty(String level) async {
    if (_isDisposed) return;
    await _loadData();
    if (kDebugMode) {
      print('DEBUG: Dificultad seleccionada: $level  Iniciando precarga...');
    }
    await _preloadImages();
    setState(() {
      difficulty = level;
      flippedCards = List<bool>.filled(lisMemory.length, false);
      matchedCards = List<bool>.filled(lisMemory.length, false);
    });
    if (kDebugMode) {
      print('DEBUG: Precarga de imágenes completada para dificultad $level.');
    }
  }

  Widget _buildPlayScene() {
    return isTablet ? _buildSceneTablet() : _buildSceneMobile();
  }

  int _getGridColumnCount() {
    // Para tablet, calculamos el número de columnas según la dificultad
    if (lisMemory.length <= 8) return 5;
    if (lisMemory.length <= 12) return 5;
    if (lisMemory.length <= 16) return 5;
    return 4; // Por defecto
  }

  void _showDialogFinallyPlay() async {
    if (_isDisposed) return;

    LoadingService().showLoading(context);

    try {
      final userData =
          Provider.of<UserProvider>(context, listen: false).currentUser;
      final responseSaveResult =
          await saveResultPlay(userData!.userId, difficulty, 'memoria');
      if (responseSaveResult.error != null) {
        if (_isDisposed) return;
        LoadingService().hideLoading();
        await _showErrorDialog(responseSaveResult.error!);
        return;
      }

      final responseResult = await getAllResultGame(userData.userId, 'memoria');
      if (responseResult.error != null) {
        if (_isDisposed) return;

        LoadingService().hideLoading();
        await _showErrorDialog(responseSaveResult.error!);
        return;
      }

      if (_isDisposed) return;

      LoadingService().hideLoading();

      final ResultGameModel infoResult =
          ResultGameModel.fromJson(responseResult.data);
      await _showSuccessDialog(infoResult);
    } catch (e) {
      if (_isDisposed) return;
      LoadingService().hideLoading();
      await _showErrorDialog(e.toString());
    } finally {
      LoadingService().hideLoading();
    }
  }

  Future<void> _showErrorDialog(String message) async {
    await showCustomDialogWithAction(
      context,
      message: message,
      dialogType: DialogTypeAction.error,
      buttonOk: "Volver",
      actionCallbackOk: () {
        if (!_isDisposed) Navigator.pop(context);
      },
      textButton: "Reintentar",
      actionCallback: () {
        if (!_isDisposed) _showDialogFinallyPlay();
      },
      // isTablet: isTablet,
    );
  }

  Future<void> _showSuccessDialog(ResultGameModel infoResult) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: StyleColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 20.0 : 12.0),
        ),
        insetPadding: isTablet
            ? EdgeInsets.symmetric(horizontal: 80.0, vertical: 60.0)
            : EdgeInsets.all(16.0),
        title: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isTablet ? 20.0 : 12.0),
          decoration: BoxDecoration(
            color: StyleColor.greenLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isTablet ? 20.0 : 12.0),
              topRight: Radius.circular(isTablet ? 20.0 : 12.0),
            ),
          ),
          child: Text(
            textAlign: TextAlign.center,
            "${infoResult.message.resultTitle}",
            style: isTablet
                ? StylesApp(context).textStyleBody24.copyWith(
                      color: StyleColor.white,
                      fontWeight: FontWeight.bold,
                    )
                : StylesApp(context).textStyleBody18.copyWith(
                      color: StyleColor.white,
                    ),
          ),
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 500 : double.infinity,
            maxHeight:
                isTablet ? 450 : MediaQuery.of(context).size.height * 0.5,
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: IntrinsicHeight(
              child: Container(
                padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.celebration,
                      size: isTablet ? 64 : 48,
                      color: StyleColor.orange,
                    ),
                    SizedBox(height: isTablet ? 20.0 : 12),
                    Text(
                      textAlign: TextAlign.center,
                      "${infoResult.message.resultDescription}",
                      style: isTablet
                          ? StylesApp(context).textStyleBody18.copyWith(
                                color: StyleColor.black,
                                height: 1.4,
                              )
                          : StylesApp(context).textStyleBody16.copyWith(
                                color: StyleColor.black,
                              ),
                    ),
                    SizedBox(height: isTablet ? 20.0 : 8),
                    if (infoResult.message.difficulty != 'Limite') ...{
                      Container(
                        padding: EdgeInsets.all(isTablet ? 16.0 : 12),
                        margin: EdgeInsets.only(top: isTablet ? 16.0 : 8),
                        decoration: BoxDecoration(
                          color: StyleColor.blueLight,
                          borderRadius:
                              BorderRadius.circular(isTablet ? 12.0 : 8.0),
                        ),
                        child: Column(
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              "Dificultad: ${infoResult.message.difficulty}",
                              style: isTablet
                                  ? StylesApp(context).textStyleBody16.copyWith(
                                        color: StyleColor.cosmicBlue,
                                        fontWeight: FontWeight.w600,
                                      )
                                  : StylesApp(context).textStyleBody12.copyWith(
                                        color: StyleColor.cosmicBlue,
                                      ),
                            ),
                            SizedBox(height: isTablet ? 8.0 : 4),
                            if (infoResult.score > 0)
                              Text(
                                textAlign: TextAlign.center,
                                "Puntaje obtenido: ${infoResult.score}",
                                style: isTablet
                                    ? StylesApp(context)
                                        .textStyleBody20
                                        .copyWith(
                                          color: StyleColor.orange,
                                          fontWeight: FontWeight.bold,
                                        )
                                    : StylesApp(context)
                                        .textStyleBody14
                                        .copyWith(
                                          color: StyleColor.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                              ),
                          ],
                        ),
                      ),
                    }
                  ],
                ),
              ),
            ),
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
            child: Center(
              child: ButtonThemeWidget(
                text: "Jugar de nuevo",
                width: isTablet ? 250 : null,
                height: isTablet ? 55 : null,
                buttonStyle: isTablet
                    ? StylesApp(context).btnWidgetSmall
                    : StylesApp(context).btnWidgetSmall,
                onPressed: () {
                  Navigator.pop(context);
                  if (!_isDisposed) {
                    setState(() {
                      difficulty = '';
                      _playWin = false;
                    });
                    _audioService.restoreBackgroundMusic();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTimeUpDialog() {
    if (_isDisposed) return;

    setState(() {
      _audioService.stopBackgroundMusic();
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth:
                isTablet ? 500 : double.infinity, // Máximo ancho para tablet
            maxHeight: isTablet ? 600 : double.infinity,
          ),
          child: Container(
            padding: EdgeInsets.all(isTablet ? 32.0 : 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_off,
                  size: isTablet ? 64 : 56,
                  color: StyleColor.redDark,
                ),
                SizedBox(height: isTablet ? 20.0 : 16),
                Text(
                  '¡Tiempo terminado!',
                  style: isTablet
                      ? StylesApp(context).textStyleBody24.copyWith(
                            color: StyleColor.redDark,
                            fontWeight: FontWeight.bold,
                          )
                      : StylesApp(context).textStyleBody20.copyWith(
                            color: StyleColor.redDark,
                          ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isTablet ? 12.0 : 8),
                Text(
                  'Se acabó el tiempo. ¿Quieres intentarlo de nuevo?',
                  style: isTablet
                      ? StylesApp(context).textStyleBody18.copyWith(
                            color: StyleColor.black,
                          )
                      : StylesApp(context).textStyleBody16.copyWith(
                            color: StyleColor.black,
                          ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isTablet ? 24.0 : 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonThemeWidget(
                      text: "Jugar de nuevo",
                      width: isTablet ? 200 : null,
                      height: isTablet ? 50 : null,
                      buttonStyle: isTablet
                          ? StylesApp(context).btnWidgetSmall
                          : StylesApp(context).btnWidgetSmall,
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          difficulty = '';
                          flippedCards = [];
                          matchedCards = [];
                          firstSelectedIndex = null;
                        });
                        _audioService.restoreBackgroundMusic();
                        _audioService.stopTimeUpSound();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getCounter(int i) {
    final counter = Duration(seconds: i);
    setState(() {});
    return (counter.inSeconds - 1).toString();
  }

  Future<void> _loadData() async {
    if (_isDisposed) return;

    final musicBackground = await PreferencesManager().getIsBackgroundPlaying();
    setState(() => isBackgroundPlaying = musicBackground);

    if (musicBackground == true) {
      _audioService.playBackgroundMusic();
    } else {
      _audioService.stopBackgroundMusic();
    }

    LoadingService().showLoading(context);
    try {
      final memoryResponse = await getMemory();
      if (memoryResponse.error != null) {
        if (_isDisposed) return;
        LoadingService().hideLoading();
        await _showLoadErrorDialog(memoryResponse.error!);
        return;
      }

      if (_isDisposed) return;

      setState(() {
        lisMemory = memoryResponse.data
            .map<MemoryModel>((memory) => MemoryModel.fromJson(memory))
            .toList();
      });
    } catch (e) {
      if (_isDisposed) return;
      await _showLoadErrorDialog(e.toString());
    } finally {
      if (!_isDisposed) LoadingService().hideLoading();
    }
  }

  Future<void> _showLoadErrorDialog(String message) async {
    await showCustomDialogWithAction(
      context,
      message: message,
      dialogType: DialogTypeAction.error,
      textButton: "Reintentar",
      actionCallback: () => _loadData(),
      buttonOk: "Volver",
      actionCallbackOk: () {
        Navigator.pushNamed(context, "/layoutPage");
        _audioService.stopBackgroundMusic();
      },
      // isTablet: isTablet,
    );
  }

  void _handleCardTap(int index) async {
    if (!canFlip || flippedCards[index] || matchedCards[index] || _isDisposed)
      return;

    await _audioService.playCardTapSound();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_isDisposed) {
        _audioService.restoreBackgroundMusic();
      }
    });
    setState(() => flippedCards[index] = true);

    if (firstSelectedIndex == null) {
      firstSelectedIndex = index;
    } else {
      canFlip = false;
      final secondIndex = index;
      if (lisMemory[firstSelectedIndex!].pair == lisMemory[secondIndex].pair) {
        await _audioService.playMatchSound();
        if (_isDisposed) return;

        setState(() {
          matchedCards[firstSelectedIndex!] = true;
          matchedCards[secondIndex] = true;
          flippedCards[firstSelectedIndex!] = false;
          flippedCards[secondIndex] = false;
        });
        firstSelectedIndex = null;
        canFlip = true;

        if (matchedCards.every((matched) => matched)) {
          setState(() {
            _playWin = true;
          });
          await _audioService.stopBackgroundMusic();
          await _audioService.playWinSound();
          if (!_isDisposed) _showDialogFinallyPlay();
        }
      } else {
        await _audioService.playNoMatchSound();
        if (_isDisposed) return;

        Future.delayed(const Duration(milliseconds: 1000), () {
          if (!_isDisposed && mounted && firstSelectedIndex != null) {
            setState(() {
              flippedCards[firstSelectedIndex!] = false;
              flippedCards[secondIndex] = false;
              firstSelectedIndex = null;
              canFlip = true;
            });
          }
        });
      }
    }
  }

  int getTimeLevel(String difficulty) {
    switch (difficulty) {
      case 'Medio':
        return 60;
      case 'Difícil':
        return 40;
      default:
        return 90;
    }
  }

  Future<void> _preloadImages() async {
    if (_isDisposed) return;

    LoadingService().showLoading(context);
    try {
      final List<Future<void>> precacheFutures = [];
      for (final memoryItem in lisMemory) {
        final imageUrl = "${GraphQLConfig.urlServidor}${memoryItem.img.urlImg}";
        precacheFutures.add(precacheImage(
          NetworkImage(imageUrl),
          context,
        ));
      }
      await Future.wait(precacheFutures);
    } catch (e) {
      LoadingService().hideLoading();
      if (kDebugMode) print('Error en precarga $e');
    } finally {
      if (!_isDisposed) LoadingService().hideLoading();
    }
  }

  _buildSceneTablet() {
    return Column(
      children: [
        SizedBox(height: 32.0),
        // Contenedor principal con dos columnas
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // COLUMNA IZQUIERDA: Información y controles
                Expanded(
                  flex: 2,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Título
                          Container(
                            margin: EdgeInsets.only(bottom: 24.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.memory,
                                  size: 48,
                                  color: StyleColor.turquoise,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Memoria Bíblica",
                                  style: StylesApp(context)
                                      .textStyleBody24
                                      .copyWith(
                                        color: StyleColor.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "¡Encuentra los pares para ganar!",
                                  style: StylesApp(context)
                                      .textStyleBody18
                                      .copyWith(
                                        color: StyleColor.grayDark,
                                        height: 1.4,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          // Dificultad seleccionada
                          Container(
                            padding: EdgeInsets.all(16.0),
                            margin: EdgeInsets.only(bottom: 20.0),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(difficulty)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: _getDifficultyColor(difficulty),
                                width: 2.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_4,
                                  color: _getDifficultyColor(difficulty),
                                  size: 28,
                                ),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Dificultad",
                                      style: StylesApp(context)
                                          .textStyleBody16
                                          .copyWith(
                                            color: StyleColor.grayDark,
                                          ),
                                    ),
                                    Text(
                                      difficulty,
                                      style: StylesApp(context)
                                          .textStyleBody20
                                          .copyWith(
                                            color:
                                                _getDifficultyColor(difficulty),
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Tiempo transcurrido
                          Container(
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: StyleColor.blueLight.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: StyleColor.cosmicBlue,
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      color: StyleColor.cosmicBlue,
                                      size: 32,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Tiempo",
                                      style: StylesApp(context)
                                          .textStyleBody16
                                          .copyWith(
                                            color: StyleColor.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                CountDownWidget(
                                  win: _playWin,
                                  initialCount: getTimeLevel(difficulty),
                                  onFinished: () {
                                    if (!_playWin && !_isDisposed) {
                                      _audioService.playTimeUpSound();
                                      _showTimeUpDialog();
                                    }
                                  },
                                  isTablet: true,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Tiempo restante",
                                  style: StylesApp(context)
                                      .textStyleBody14
                                      .copyWith(
                                        color: StyleColor.grayDark,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // Estadísticas
                          Container(
                            margin: EdgeInsets.only(top: 20.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: StyleColor.orange.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Cartas encontradas:",
                                      style: StylesApp(context)
                                          .textStyleBody16
                                          .copyWith(
                                            color: StyleColor.grayDark,
                                          ),
                                    ),
                                    Text(
                                      "${matchedCards.where((matched) => matched).length ~/ 2}",
                                      style: StylesApp(context)
                                          .textStyleBody20
                                          .copyWith(
                                            color: StyleColor.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total de pares:",
                                      style: StylesApp(context)
                                          .textStyleBody16
                                          .copyWith(
                                            color: StyleColor.grayDark,
                                          ),
                                    ),
                                    Text(
                                      "${lisMemory.length ~/ 2}",
                                      style: StylesApp(context)
                                          .textStyleBody20
                                          .copyWith(
                                            color: StyleColor.greenDark,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Botón de reinicio
                          Container(
                            margin: EdgeInsets.only(top: 24.0),
                            child: ButtonThemeWidget(
                              text: "Cambiar dificultad",
                              width: double.infinity,
                              height: 48,
                              buttonStyle: StylesApp(context)
                                  .btnWidgetSmall
                                  .copyWith(
                                    backgroundColor: WidgetStatePropertyAll(
                                      StyleColor.grayMedium.withValues(alpha: 0.8),
                                    ),
                                  ),
                              onPressed: () {
                                setState(() {
                                  difficulty = '';
                                  _playWin = false;
                                  flippedCards = [];
                                  matchedCards = [];
                                  firstSelectedIndex = null;
                                });
                                _audioService.restoreBackgroundMusic();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 24.0),

                // COLUMNA DERECHA: Juego de memoria
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
                    child: Column(
                      children: [
                        // Instrucciones rápidas
                        // Container(
                        //   margin: EdgeInsets.only(bottom: 16.0),
                        //   padding: EdgeInsets.all(12.0),
                        //   decoration: BoxDecoration(
                        //     color: StyleColor.turquoise.withValues(alpha: 0.1),
                        //     borderRadius: BorderRadius.circular(12.0),
                        //   ),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Icon(
                        //         Icons.info_outline,
                        //         color: StyleColor.turquoise,
                        //         size: 24,
                        //       ),
                        //       SizedBox(width: 12),
                        //       Expanded(
                        //         child: Text(
                        //           "Haz clic en las cartas para encontrar los pares",
                        //           style: StylesApp(context)
                        //               .textStyleBody16
                        //               .copyWith(
                        //                 color: StyleColor.black,
                        //               ),
                        //           maxLines: 2,
                        //           overflow: TextOverflow.ellipsis,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        // Grid de cartas
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _getGridColumnCount(),
                              crossAxisSpacing: 12.0,
                              mainAxisSpacing: 12.0,
                              childAspectRatio: 1.6,
                            ),
                            itemCount: lisMemory.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MemoryCard(
                                card: lisMemory[index],
                                isFlipped: flippedCards.isNotEmpty
                                    ? flippedCards[index]
                                    : false,
                                isMatched: matchedCards.isNotEmpty
                                    ? matchedCards[index]
                                    : false,
                                onTap: () => _handleCardTap(index),
                                isTablet: true,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24.0),
      ],
    );
  }

  _buildSceneMobile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: isTablet ? 32.0 : 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 32.0 : 16.0),
          child: Text(
            "¡Encuentra los pares para ganar!",
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
        ),
        SizedBox(height: isTablet ? 24.0 : 20),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 40.0 : 16.0,
              vertical: isTablet ? 8.0 : 0,
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet ? _getGridColumnCount() : 4,
                crossAxisSpacing: isTablet ? 12.0 : 8.0,
                mainAxisSpacing: isTablet ? 12.0 : 8.0,
                childAspectRatio: isTablet ? 0.9 : 1.0,
              ),
              itemCount: lisMemory.length,
              itemBuilder: (BuildContext context, int index) {
                return MemoryCard(
                  card: lisMemory[index],
                  isFlipped:
                      flippedCards.isNotEmpty ? flippedCards[index] : false,
                  isMatched:
                      matchedCards.isNotEmpty ? matchedCards[index] : false,
                  onTap: () => _handleCardTap(index),
                  isTablet: isTablet,
                );
              },
            ),
          ),
        ),
        SizedBox(height: isTablet ? 24.0 : 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 32.0 : 16.0),
          child: Column(
            children: [
              Text(
                "Dificultad: $difficulty",
                style: isTablet
                    ? StylesApp(context).textStyleBody18.copyWith(
                          color: StyleColor.black,
                          fontWeight: FontWeight.w600,
                        )
                    : StylesApp(context).textStyleBody15.copyWith(
                          color: StyleColor.black,
                        ),
              ),
              SizedBox(height: isTablet ? 12.0 : 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer,
                    color: StyleColor.cosmicBlue,
                    size: isTablet ? 28 : 24,
                  ),
                  SizedBox(width: isTablet ? 12.0 : 8),
                  Text(
                    "Tiempo Restante: ",
                    style: isTablet
                        ? StylesApp(context).textStyleBody18.copyWith(
                              color: StyleColor.black,
                            )
                        : StylesApp(context).textStyleBody15.copyWith(
                              color: StyleColor.black,
                            ),
                  ),
                  CountDownWidget(
                    win: _playWin,
                    initialCount: getTimeLevel(difficulty),
                    onFinished: () {
                      if (!_playWin && !_isDisposed) {
                        _audioService.playTimeUpSound();
                        _showTimeUpDialog();
                      }
                    },
                    isTablet: isTablet,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: isTablet ? 32.0 : 20),
      ],
    );
  }
}

class CountDownWidget extends StatefulWidget {
  final int initialCount;
  final bool win;
  final VoidCallback? onFinished;
  final bool isTablet;
  const CountDownWidget({
    super.key,
    required this.initialCount,
    this.onFinished,
    this.win = false,
    this.isTablet = false,
  });

  @override
  State<CountDownWidget> createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  late int _currentCount;
  Timer? _timer;
  late AudioService _audioService;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _currentCount = widget.initialCount;
    _audioService = AudioService();
    _startCountDown();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
        horizontal: widget.isTablet ? 12.0 : 8.0,
        vertical: widget.isTablet ? 6.0 : 4.0,
      ),
      decoration: BoxDecoration(
        color: _currentCount <= 10
            ? StyleColor.redLight.withValues(alpha: 0.2)
            : StyleColor.blueLight.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(widget.isTablet ? 12.0 : 8.0),
        border: Border.all(
          color:
              _currentCount <= 10 ? StyleColor.redDark : StyleColor.cosmicBlue,
          width: widget.isTablet ? 2.0 : 1.5,
        ),
      ),
      child: Text(
        "$_currentCount",
        style: widget.isTablet
            ? StylesApp(context).textStyleBody24.copyWith(
                  color: _currentCount <= 10
                      ? StyleColor.redDark
                      : StyleColor.cosmicBlue,
                  fontWeight: FontWeight.bold,
                )
            : StylesApp(context).textStyCompleteLevelTitle.copyWith(
                  color: _currentCount <= 10
                      ? StyleColor.redDark
                      : StyleColor.black,
                ),
      ),
    );
  }

  void _startCountDown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      if (widget.win) {
        timer.cancel();
        _audioService.stopCounterClock();
        return;
      }

      setState(() {
        if (_currentCount > 0) {
          if (_currentCount <= 10) {
            _audioService.playCounterClock();
          }
          _currentCount--;
        } else {
          _audioService.stopCounterClock();
          timer.cancel();
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
  final bool isTablet;

  const MemoryCard({
    super.key,
    required this.card,
    required this.isFlipped,
    required this.isMatched,
    required this.onTap,
    this.isTablet = false,
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
        borderRadius: BorderRadius.circular(isTablet ? 12.0 : 8.0),
        boxShadow: [
          BoxShadow(
            blurRadius: isTablet ? 16 : 12,
            color: StyleColor.black.withValues(alpha: 0.25),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 8.0 : 4.0),
          child: Image.network(
            "${GraphQLConfig.urlServidor}${card.img.urlImg}",
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      key: const ValueKey('back'),
      decoration: BoxDecoration(
        color: StyleColor.cosmicBlue,
        borderRadius: BorderRadius.circular(isTablet ? 12.0 : 8.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            StyleColor.cosmicBlue,
            StyleColor.blueDark,
          ],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: isTablet ? 16 : 12,
            color: StyleColor.black.withValues(alpha: 0.3),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.question_mark,
          size: isTablet ? 48 : 40,
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
