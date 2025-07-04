import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/class/bible_version_selector.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class BibleScreen extends StatefulWidget {
  const BibleScreen({super.key});

  @override
  State<BibleScreen> createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen> {
  late final UserProvider userProvider;
  LoginUser? userData;
  final ScrollController scrollController = ScrollController();
  SharedPreferences? prefs;
  String? errorMessage;
  bool isLoading = true;
  VersionModel? currentVersion;
  BookModel? currentBook;
  List<ChapterModel> allChapters = [];
  ChapterModel? currentChapter;
  List<VerseModel> verses = [];
  String? lastVersionsSelected;
  bool versionConSaltos = true;
  bool hasPreviousChapter = false;
  bool hasNextChapter = false;
  Color? selectedColor;
  String preferenceKey = 'selectedBibleVersion';
  double fontSizeNumber = 16.sp;
  double fontSizeVerse = 14.sp;
  ModelData fontFamilySet = ModelData(label: "Aclonica", value: "1");
  AudioChapterModel? audioChapter;
  //  Variable para controlar el overlay
  List<FavoriteVerse> _favoriteVerses = [];
  List<HighlightRangeModel> _highlights = [];
  final GlobalKey _selectableTextKey = GlobalKey();
  late BibleTheme currentTheme;

  // Añade estas variables para TTS
  late FlutterTts flutterTts;
  bool isPlaying = false;
  int? currentPlayingVerseIndex;
// Añade estas variables a tu estado
  double _speechRate = 0.5; // Velocidad por defecto

  @override
  void initState() {
    super.initState();
    _initTTS(); // Inicializar TTS
    _initSpeechRate();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userData = userProvider.currentUser;
      await _initDataLoad();
      _loadHighlights();
    });
  }

  @override
  void dispose() {
    flutterTts.stop(); // Detener TTS al salir
    super.dispose();
  }

  void _initTTS() async {
    flutterTts = FlutterTts();

    await flutterTts.setLanguage("es-ES"); // Configurar idioma
    await flutterTts.setVoice({"name": "es-es-x-ana-local", "locale": "es-ES"});
    await flutterTts.setSpeechRate(0.5); // Velocidad de habla (0-1)
    await flutterTts.setVolume(1.0); // Volumen (0-1)
    await flutterTts.setPitch(1.0); // Tono (0.5-2.0)

    // Configurar handlers para eventos
    flutterTts.setStartHandler(() {
      setState(() => isPlaying = true);
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        // isPlaying = false;
        // currentPlayingVerseIndex = null;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isPlaying = false;
        currentPlayingVerseIndex = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en TTS: $msg")),
      );
    });
  }

// Método para inicializar la velocidad desde preferencias
  Future<void> _initSpeechRate() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _speechRate = prefs.getDouble('tts_speech_rate') ?? 0.5;
    });
    await flutterTts.setSpeechRate(_speechRate);
  }

  String _getSpeedLabel(double speed) {
    if (speed <= 0.4) return 'Lento';
    if (speed <= 0.6) return 'Normal';
    return 'Rápido';
  }

  // Método para leer un versículo
  Future<void> _readVerse(VerseModel verse) async {
    try {
      if (isPlaying) {
        await flutterTts.stop();
      }

      setState(() {
        currentPlayingVerseIndex = verses.indexOf(verse);
      });

      await flutterTts.speak("Versículo ${verse.verse}. ${verse.text}");
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al leer versículo: ${e.toString()}")),
        );
      }
    } finally {
      setState(() {
        isPlaying = false;
      });
      await flutterTts.stop();
    }
  }

  // Método para leer todo el capítulo
  Future<void> _readFullChapter() async {
    try {
      if (isPlaying) {
        await flutterTts.stop();
        return;
      }

      setState(() => isPlaying = true);

      for (int i = 0; i < verses.length; i++) {
        if (!isPlaying) break; // Si se detuvo la reproducción, salir

        setState(() => currentPlayingVerseIndex = i);

        // Scroll al versículo actual
        if (_selectableTextKey.currentContext != null &&
            scrollController.hasClients) {
          try {
            final renderBox =
                _selectableTextKey.currentContext!.findRenderObject();
            if (renderBox is RenderBox) {
              final text = verses
                  .sublist(0, i)
                  .map((v) => "${v.verse} ${v.text}")
                  .join(' ');
              final tp = TextPainter(
                text: TextSpan(
                  text: text,
                  style: StylesApp(context).textStyleBody14.copyWith(
                        fontFamily: fontFamilySet.label,
                        fontSize: fontSizeVerse,
                      ),
                ),
                textDirection: TextDirection.ltr,
                maxLines: null,
              );
              tp.layout(maxWidth: renderBox.size.width);
              final offsetY = tp.height - 15;
              await scrollController.animateTo(
                offsetY,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          } catch (_) {
            final itemHeight = 40.0;
            await scrollController.animateTo(
              i * itemHeight,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }

        // Esperar a que termine de hablar antes de continuar
        await flutterTts
            .speak("Versículo ${verses[i].verse}. ${verses[i].text}");
        // Esperar a que termine el TTS antes de continuar
        await _waitForTtsCompletion();
        if (!isPlaying) break;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al leer capítulo: ${e.toString()}")),
        );
      }
    } finally {
      setState(() {
        isPlaying = false;
        currentPlayingVerseIndex = null;
      });
    }
  }

  // Espera a que el TTS termine de hablar
  Future<void> _waitForTtsCompletion() async {
    final completer = Completer<void>();
    void onComplete() {
      flutterTts
          .setCompletionHandler(() {}); // Limpiar handler para evitar fugas
      completer.complete();
    }

    flutterTts.setCompletionHandler(onComplete);

    // Si el usuario detiene la reproducción, salir antes
    while (isPlaying && !completer.isCompleted) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    await completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<BibleThemeProvider>(context);
    currentTheme = themeProvider.themeData;

    return Consumer<BibleThemeProvider>(
        builder: (context, themeProvider, child) {
      final currentTheme = themeProvider.themeData;
      return Scaffold(
        backgroundColor: currentTheme.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              if (isLoading) ...{
                Container()
              } else ...{
                if (errorMessage != null) ...{
                  BuildErrorWidget(
                    errorMessage: errorMessage!,
                    onRetry: () async => _initDataLoad(),
                    onBack: () => Navigator.pushNamed(context, '/layoutPage',
                        arguments: {'selectedIndex': 0}),
                  )
                } else ...{
                  // cabecera
                  BibleHeaderWidget(
                    versionName:
                        currentVersion != null ? currentVersion!.version : '',
                    title: currentBook != null ? currentBook!.modernName : '',
                    chapter: currentChapter != null
                        ? '${currentChapter!.chapter}'
                        : '',
                    onAudioTap: () {},
                    onBack: () {
                      Navigator.pushNamed(
                        context,
                        '/layoutPage',
                        arguments: {'selectedIndex': 0},
                      );
                    },
                    onVersionTap: () async {
                      final bibleVersions = Provider.of<CatalogueProvider>(
                              context,
                              listen: false)
                          .allBibleVersion
                          .map((v) => ModelData(value: v.id, label: v.version))
                          .toList();

                      final selectedVersion = await BibleVersionSelector.show(
                          context: context,
                          versions: bibleVersions,
                          preferenceKey: preferenceKey,
                          savedId: lastVersionsSelected);

                      if (selectedVersion != null) {
                        // Aquí manejas la versión seleccionada
                        if (kDebugMode) {
                          print(
                              'Versión seleccionada: ${selectedVersion.label}');
                        }
                        setState(() {
                          lastVersionsSelected = selectedVersion
                              .value; // actualizo la version de la biblia

                          // removemos los datos de la cache para iniciar de nuevo
                          prefs!.remove('bookSelected');
                          prefs!.remove('chapterSelected');
                        });
                        prefs!.setString(preferenceKey, lastVersionsSelected!);
                        _initDataLoad();
                      }
                    },
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          // body
                          Scrollbar(
                            controller: scrollController,
                            thumbVisibility: true,
                            thickness: 6.0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (versionConSaltos) ...{
                                      Expanded(
                                        child: ListView(
                                          controller: scrollController,
                                          children: [
                                            // Otros widgets de la lista...
                                            const SizedBox(height: 40),
                                            _buildContinuousText(), // Tu texto formateado como un widget
                                            SizedBox(
                                              height:
                                                  kBottomNavigationBarHeight +
                                                      20,
                                            )
                                            // Más widgets...
                                          ],
                                        ),
                                      ),
                                    }
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // opciones de copiado, compartir y configuración
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                  color: currentTheme.backgroundColor),
                              // width: MediaQuery.sizeOf(context).width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 25.0,
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ModalTextFormatSizeWidget(
                                                fontSize: fontSizeVerse,
                                                selectedItem: fontFamilySet,
                                                onChangedFontSize: (fontSize) {
                                                  if (kDebugMode) {
                                                    print(
                                                        'el nuevo tamaño de fuente $fontSize');
                                                  }
                                                  setState(() {
                                                    // persistir tamaño de fuente
                                                    fontSizeNumber =
                                                        fontSize! + 2;
                                                    fontSizeVerse = fontSize;
                                                  });
                                                  prefs!.setDouble(
                                                      "fontSizeVerse",
                                                      fontSize!);
                                                },
                                                onChangedFont: (newFont) {
                                                  if (kDebugMode) {
                                                    print(
                                                        'la nueva fuente ${newFont!.label}');
                                                  }
                                                  // persistir familia de fuente
                                                  setState(() {
                                                    fontFamilySet = newFont!;
                                                  });
                                                  prefs!.setString(
                                                    "fontFamilySet",
                                                    jsonEncode(
                                                        newFont!.toJson()),
                                                  );
                                                },
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        CupertinoIcons.textformat_size,
                                        color: currentTheme.buttonColor,
                                      )),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 25.0,
                                    onPressed: () async {
                                      Clipboard.setData(ClipboardData(
                                          text: await copyChapter(
                                              currentChapter)));
                                      await showCustomDialog(
                                        context,
                                        message:
                                            "El capitulo ${currentChapter!.chapter} del libro ${currentBook!.modernName}  \n se ha copiado con éxito al\n portapapeles",
                                        dialogType: DialogType.info,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.file_copy_rounded,
                                      color: currentTheme.buttonColor,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 25.0,
                                    onPressed: () async {
                                      await Share.share(
                                        await copyChapter(currentChapter),
                                        subject:
                                            "Palabra de Vida - ${currentChapter!.chapter} ${currentBook!.modernName} \n ver en:${GraphQLConfig.urlServidor}officialbible",
                                      );
                                    },
                                    icon: Icon(
                                      Icons.share_rounded,
                                      color: StyleColor.turquoise,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 25.0,
                                    onPressed: () {
                                      showGeneralDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        transitionDuration:
                                            Duration(milliseconds: 500),
                                        pageBuilder: (_, __, ___) {
                                          return Dialog(
                                            backgroundColor:
                                                currentTheme.backgroundColor,
                                            insetPadding: EdgeInsets.zero,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              child: SearchBibleWidget(
                                                onActionBook:
                                                    (InputDataSearchModel
                                                        data) async {
                                                  await loadVersionAndChapter(
                                                      data);
                                                },
                                                onActionTabText:
                                                    (InputDataSearchModel
                                                        data) async {
                                                  await loadVersionAndChapter(
                                                      data);
                                                },
                                                onActionTheme:
                                                    (InputDataSearchModel
                                                        data) async {
                                                  await loadVersionAndChapter(
                                                      data);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        transitionBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return ScaleTransition(
                                            scale: animation.drive(CurveTween(
                                                curve: Curves
                                                    .fastOutSlowIn)), // ← Solución segura
                                            child: child,
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.search_rounded,
                                      color: currentTheme.buttonColor,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 25.0,
                                    onPressed: () async {
                                      String versionId = currentVersion != null
                                          ? currentVersion!.id
                                          : "0";
                                      LoadingService().showLoading(context);
                                      try {
                                        String userId = userData != null
                                            ? userData!.userId
                                            : '';
                                        List<FavoriteVerse> listFavorite = [];
                                        PaginationInfo? objPagination;
                                        final responseFavorite =
                                            await getFavoriteVerseByUser(
                                                1, 10, versionId, null, userId);
                                        if (responseFavorite.error != null) {
                                          LoadingService().hideLoading();
                                          await showCustomDialog(context,
                                              message: responseFavorite.error!,
                                              dialogType: DialogType.error);
                                          return;
                                        }

                                        setState(() {
                                          listFavorite = responseFavorite
                                              .data['data']
                                              .map<FavoriteVerse>((favorite) =>
                                                  FavoriteVerse.fromJson(
                                                      favorite))
                                              .toList();
                                          objPagination =
                                              PaginationInfo.fromJson(
                                                  responseFavorite
                                                      .data['meta']);
                                        });
                                        LoadingService().hideLoading();
                                        showGeneralDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            transitionDuration:
                                                Duration(milliseconds: 500),
                                            pageBuilder: (_, __, ___) {
                                              return DialogFavoriteVerseWidget(
                                                  currentTheme: currentTheme,
                                                  paginationInfo: objPagination,
                                                  versionId: currentVersion!.id,
                                                  favoriteVerses: listFavorite,
                                                  onDeleted: (verseId) {
                                                    final indexToDelete =
                                                        _favoriteVerses
                                                            .indexWhere(
                                                                (verse) =>
                                                                    verse.verse
                                                                        .id ==
                                                                    verseId);
                                                    if (indexToDelete != -1) {
                                                      _favoriteVerses.removeAt(
                                                          indexToDelete);
                                                    }
                                                  });
                                            });
                                      } catch (e) {
                                        LoadingService().hideLoading();
                                        await showCustomDialog(context,
                                            message: e.toString(),
                                            dialogType: DialogType.error);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.star,
                                      color: StyleColor.turquoise,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 7.0),
                              width: MediaQuery.sizeOf(context).width,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: hasPreviousChapter
                                            ? currentTheme.buttonColor
                                            : StyleColor.grayMedium,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                      child: IconButton(
                                        disabledColor: StyleColor.grayMedium,
                                        padding: EdgeInsets.all(0),
                                        alignment: Alignment.center,
                                        iconSize: 35,
                                        //  color: currentTheme.buttonColor,
                                        onPressed: !hasPreviousChapter
                                            ? null
                                            : () {
                                                // Lógica para ir al capítulo anterior
                                                _goToPreviousChapter(
                                                    (currentChapter!.chapter -
                                                            1)
                                                        .toString());
                                              },
                                        icon: Icon(
                                          Icons.keyboard_arrow_left_rounded,
                                          size: 35,
                                          color: currentTheme.buttonTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: currentTheme.backgroundColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // Slider para control de velocidad
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    // Botón de stop
                                                    IconButton(
                                                      icon: Icon(Icons.stop,
                                                          size: 24),
                                                      color: currentTheme
                                                          .buttonColor,
                                                      onPressed: () async {
                                                        await flutterTts.stop();
                                                        setState(() {
                                                          isPlaying = false;
                                                          currentPlayingVerseIndex =
                                                              null;
                                                        });
                                                      },
                                                    ),
                                                    // Botón de play/pause
                                                    IconButton(
                                                      icon: Icon(
                                                        isPlaying
                                                            ? Icons.pause
                                                            : Icons.play_arrow,
                                                        size: 28,
                                                      ),
                                                      color: currentTheme
                                                          .buttonColor,
                                                      onPressed:
                                                          _togglePlayPause,
                                                    ),
                                                    Icon(Icons.speed,
                                                        size: 18,
                                                        color: currentTheme
                                                            .textColor),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                      child: Slider(
                                                        value: _speechRate,
                                                        min: 0.1,
                                                        max: 1.0,
                                                        divisions: 9,
                                                        label: _getSpeedLabel(
                                                            _speechRate),
                                                        activeColor:
                                                            currentTheme
                                                                .buttonColor,
                                                        inactiveColor:
                                                            currentTheme
                                                                .buttonColor
                                                                .withOpacity(
                                                                    0.3),
                                                        onChanged:
                                                            (value) async {
                                                          final prefs =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          setState(() {
                                                            _speechRate = value;
                                                          });
                                                          await flutterTts
                                                              .setSpeechRate(
                                                                  value);
                                                          await prefs.setDouble(
                                                              'tts_speech_rate',
                                                              value);
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      _getSpeedLabel(
                                                          _speechRate),
                                                      style: TextStyle(
                                                        color: currentTheme
                                                            .textColor,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  'Velocidad: ${(_speechRate * 100).round()}%',
                                                  style: TextStyle(
                                                    color:
                                                        currentTheme.textColor,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Indicador de progreso (opcional)
                                          // if (isPlaying &&
                                          //     currentPlayingVerseIndex != null)
                                          //   Padding(
                                          //     padding: EdgeInsets.only(left: 8),
                                          //     child: Text(
                                          //       '${currentPlayingVerseIndex! + 1}/${verses.length}',
                                          //       style: TextStyle(
                                          //         color: currentTheme.textColor
                                          //             .withOpacity(0.6),
                                          //         fontSize: 12,
                                          //       ),
                                          //     ),
                                          //   ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: AudioPlayerWidget(
                                  //     showImage: false,
                                  //     pathUrl: audioChapter != null &&
                                  //             audioChapter!.audioUrl.isNotEmpty
                                  //         ? '${GraphQLConfig.urlServidor}${audioChapter!.audioUrl}'
                                  //         : '',
                                  //     backgroundColor:
                                  //         currentTheme.backgroundColor,
                                  //     controlsColor: currentTheme.buttonColor,
                                  //     actionColor: currentTheme.textColor,
                                  //   ),
                                  // ),
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: hasNextChapter
                                            ? currentTheme.buttonColor
                                            : StyleColor.grayMedium,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                      child: IconButton(
                                        padding: EdgeInsets.all(0),
                                        alignment: Alignment.center,
                                        iconSize: 35,
                                        onPressed: !hasNextChapter
                                            ? null
                                            : () {
                                                // Lógica para ir al siguiente capítulo
                                                _goToNextChapter(
                                                    (currentChapter!.chapter +
                                                            1)
                                                        .toString());
                                              },
                                        icon: Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                          size: 35,
                                          color: currentTheme.buttonTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                }
              }
            ],
          ),
        ),
      );
    });
  }

  /// Widget realiza la construcción de los textSpan para selección
  /// continua
  Widget _buildContinuousText() {
    final fullText = verses.map((v) => "${v.verse} ${v.text}").join(' ');

    return SelectableText.rich(
      key: _selectableTextKey,
      TextSpan(
        children: verses
            .expand((verse) => [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Stack(
                      alignment:
                          Alignment.center, // Centra los hijos en el Stack
                      children: [
                        SelectionContainer.disabled(
                          child: GestureDetector(
                            onTap: () {
                              _showVersePopupMenu(context, verse);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: verse.verse == 1 ? 4.0 : 4.0,
                                right: 4.0,
                              ),
                              child: Text(
                                "${verse.verse}",
                                style:
                                    StylesApp(context).textStyleBody16.copyWith(
                                          fontFamily: fontFamilySet.label,
                                          fontSize: fontSizeNumber,
                                          fontWeight: FontWeight.bold,
                                          color: currentPlayingVerseIndex ==
                                                  verses.indexOf(verse)
                                              ? Colors
                                                  .blue // Cambia color cuando se lee
                                              : currentTheme.textColor,
                                        ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //  if (_isFavorite(verse))
                  //   WidgetSpan(
                  //     alignment: PlaceholderAlignment.baseline,
                  //     baseline: TextBaseline.alphabetic,
                  //     child: SelectionContainer.disabled(
                  //       child: Icon(
                  //         Icons.star,
                  //         size: 16,
                  //         color: StyleColor.yellowLight,
                  //       ),
                  //     ),
                  //   ),
                  ..._buildHighlightedTextSpans(verse),
                ])
            .toList(),
      ),
      contextMenuBuilder: (context, selectableRegionState) {
        final selection = selectableRegionState.textEditingValue.selection;
        final selectedText = selection.textInside(fullText);
        final selectedVerses = _getVersesInSelection(selection, fullText);
        final overlapsHighlights =
            _selectionOverlapsHighlights(selection, fullText);

        return CustomContextMenu(
          anchors: selectableRegionState.contextMenuAnchors,
          children: [
            CustomContextMenuItem(
              icon: Icons.content_copy,
              label: 'Copiar versículo',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: selectedText));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Versículo copiado')),
                );
              },
            ),
            CustomContextMenuItem(
              icon: Icons.share,
              label: 'Compartir versículo',
              onPressed: () {
                Share.share(
                  selectedText,
                  subject: 'Versículo de ${currentBook?.modernName}',
                );
              },
            ),
            if (!overlapsHighlights)
              CustomContextMenuItem(
                icon: selectedVerses.length > 1
                    ? Icons.format_paint
                    : Icons.highlight,
                label: selectedVerses.length > 1
                    ? 'Resaltar ${selectedVerses.length} versículos'
                    : 'Resaltar versículo',
                onPressed: () {
                  _showColorPickerForSelection(
                    context,
                    selectedVerses,
                    selection.start,
                    selection.end,
                    selectedVerses.length > 1,
                  );
                },
              ),
          ],
        );
      },
      onSelectionChanged: (selection, cause) {
        if (selection.isValid && !selection.isCollapsed) {
          final overlaps = _selectionOverlapsHighlights(selection, fullText);
          if (overlaps) {
            // Usar un Future para esperar al siguiente frame y luego limpiar la selección
            Future.delayed(Duration.zero, () {
              final renderObject =
                  _selectableTextKey.currentContext?.findRenderObject();
              if (renderObject is RenderEditable) {
                renderObject.selection =
                    TextSelection.collapsed(offset: selection.baseOffset);
              }
            });
          }
        }
      },
    );
  }

  bool _isFavorite(VerseModel verse) {
    return _favoriteVerses.any((f) => f.verse.id == verse.id);
  }

  void _showVersePopupMenu(BuildContext context, VerseModel verse) {
    final isFavorite = _isFavorite(verse);
    final isCurrentPlaying = currentPlayingVerseIndex == verses.indexOf(verse);

    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(isFavorite ? Icons.star_outline : Icons.star),
            title: Text(
                isFavorite ? 'Remover de favoritos' : 'Agregar a favoritos'),
            onTap: () {
              _toggleFavorite(verse);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(isCurrentPlaying ? Icons.stop : Icons.volume_up),
            title:
                Text(isCurrentPlaying ? 'Detener lectura' : 'Leer versículo'),
            onTap: () {
              if (isCurrentPlaying) {
                flutterTts.stop();
              } else {
                _readVerse(verse);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  /// Método para la creación de los resaltados
  List<TextSpan> _buildHighlightedTextSpans(VerseModel verse) {
    final text = verse.text;
    final spans = <TextSpan>[];
    int currentPos = 0;

    // Ordenar resaltados por posición de inicio (opcional, pero recomendado)
    verse.highlights.sort((a, b) => a!.startIndex.compareTo(b!.startIndex));

    for (final highlight in verse.highlights) {
      // 1. Texto antes del resaltado (si hay espacio no cubierto)
      if (currentPos < highlight!.startIndex) {
        spans.add(TextSpan(
          text: text.substring(
              currentPos,
              (highlight.startIndex > 0
                  ? highlight.startIndex - 1
                  : highlight.startIndex)),
          style: StylesApp(context).textStyleBody14.copyWith(
                decoration:
                    _isFavorite(verse) ? TextDecoration.underline : null,
                color: currentPlayingVerseIndex == verses.indexOf(verse)
                    ? Colors.blue // Cambia color cuando se lee
                    : currentTheme.textColor,
                decorationThickness: 4.0,
                decorationColor: StyleColor.yellowLight,
                fontFamily: fontFamilySet.label,
                fontSize: fontSizeVerse,
                fontWeight: FontWeight.w400,
              ),
        ));
      }

      // 2. Aplicar el resaltado
      spans.add(TextSpan(
        recognizer: LongPressGestureRecognizer()
          ..onLongPress = () {
            if (kDebugMode) {
              print('Long press en versículo ${verse.verse}');
            }
            _showHighlightOptions(context, highlight);
          },
        text: text.substring(
            (highlight.startIndex > 0
                ? highlight.startIndex - 1
                : highlight.startIndex),
            highlight.endIndex < text.length - 1
                ? highlight.endIndex
                : highlight.endIndex),
        // highlight.endIndex < text.length-1 ? highlight.endIndex - 1: highlight.endIndex ),
        style: StylesApp(context).textStyleBody14.copyWith(
              decoration: _isFavorite(verse) ? TextDecoration.underline : null,
              color: currentPlayingVerseIndex == verses.indexOf(verse)
                  ? Colors.blue // Cambia color cuando se lee
                  : currentTheme.textColor,
              decorationThickness: 4.0,
              decorationColor: StyleColor.yellowLight,
              fontFamily: fontFamilySet.label,
              fontSize: fontSizeVerse,
              backgroundColor:
                  Color(int.parse('0XFF${formatColor(highlight.color)}'))
                      .withValues(alpha: 0.3),
              fontWeight: FontWeight.w400,
            ),
      ));

      // Actualizar posición actual al final del resaltado actual
      currentPos = highlight.endIndex;
      // currentPos = highlight.endIndex < text.length-1 ?  highlight.endIndex - 1 : highlight.endIndex;
    }

    // 3. Texto restante después del último resaltado
    if (currentPos < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentPos),
        style: StylesApp(context).textStyleBody14.copyWith(
              decoration: _isFavorite(verse) ? TextDecoration.underline : null,
              color: currentPlayingVerseIndex == verses.indexOf(verse)
                  ? Colors.blue // Cambia color cuando se lee
                  : currentTheme.textColor,
              decorationThickness: 4.0,
              decorationColor: StyleColor.yellowLight,
              fontFamily: fontFamilySet.label,
              fontSize: fontSizeVerse,
              fontWeight: FontWeight.w400,
            ),
      ));
    }

    // Aplica un estilo por defecto a todos los spans si no tienen uno
    return spans;
    // .map((span) {
    //   if (span.style != null) {
    //     return span;
    //   }
    //   return TextSpan(
    //     text: span.text,
    //     children: span.children,
    //     recognizer: span.recognizer,
    //     style: StylesApp(context).textStyleBody14.copyWith(
    //           decoration: _isFavorite(verse) ? TextDecoration.underline : null,
    //           fontFamily: fontFamilySet.label,
    //           fontSize: fontSizeVerse,
    //           color: currentPlayingVerseIndex == verses.indexOf(verse)
    //               ? Colors.blue // Cambia color cuando se lee
    //               : currentTheme.textColor,
    //           decorationThickness: 4.0,
    //           decorationColor: StyleColor.yellowLight,
    //           fontWeight: FontWeight.w400,
    //         ),
    //   );
    // }).toList();
  }

  /// Método que me muestra la modal bottom Sheet pata la elección del color de resaltado
  ///
  void _showColorPickerForSelection(BuildContext context,
      List<VerseModel> verses, int start, int end, bool isContinue) {
    final colors = [
      const Color(0xFFEE5A24),
      const Color(0xFFF79F1F),
      const Color(0xFFFFC312),
      const Color(0xFFFFD55F),
      const Color(0xFFC4E538),
      const Color(0xFFA3CB38),
      const Color(0xFF009432),
      const Color(0xFF006266),
      const Color(0xFF12CBC4),
      const Color(0xFF1289A7),
      const Color(0xFF0652DD),
      const Color(0xFF1B1464),
      const Color(0xFF5758BB),
      const Color(0xFF9980FA),
      const Color(0xFFD980FA),
      const Color(0xFFFDA7DF),
      const Color(0xFF833471),
      const Color(0xFFB53471),
      const Color(0xFF6F1E51),
      const Color(0xFFED4C67),
      const Color(0xFFEA2027),
    ];

    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Resaltar selección',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Divider(),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    final hexColor =
                        '${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
                    final List<VerseModel> newVerses = [];

                    for (final verse in verses) {
                      // Calcular los índices correctos para cada versículo
                      final verseText = "${verse.verse} ${verse.text}";
                      final start = max(0, verse.posIni!);
                      final end = min(verse.posFin!, verseText.length);
                      if (kDebugMode) {
                        print('Color seleccionado: $hexColor');
                      }
                      if (start < end) {
                        newVerses.add(verse);
                      }
                    }
                    _addHighlight(newVerses, hexColor);

                    Navigator.pop(ctx);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(color.value),
                      shape: BoxShape.circle,
                      border: Border.all(width: 2),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          ListTile(
            leading: Icon(Icons.cancel),
            title: Text('Cancelar'),
            onTap: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  /// Método que agrega el resaltado
  void _addHighlight(List<VerseModel> listVerses, String color) async {
    // Verificar si ya existe un resaltado en esta posición
    final List<HighlightRangeModel> inputHighlight = [];
    for (final verse in listVerses) {
      final newHighlight = HighlightRangeModel(
        id: verse.id,
        verse: verse.verse,
        startIndex: verse.posIni!,
        endIndex: verse.posFin!,
        color: color,
      );
      inputHighlight.add(newHighlight); // actualizo temporal
    }
    LoadingService().showLoading(context);
    final responseCreate = await crateHighLighters(inputHighlight,
        userData!.userId, int.parse(currentVersion!.id), currentChapter!.id);
    if (responseCreate.error != null) {
      LoadingService().hideLoading();
      // ignore: use_build_context_synchronously
      await showCustomDialog(context,
          message: responseCreate.error!, dialogType: DialogType.error);
      return;
    }
    LoadingService().hideLoading();
    for (final lighter in inputHighlight) {
      _highlights.add(lighter); // actualizo local
      final encontrado = verses.indexWhere((verse) => verse.id == lighter.id);
      if (encontrado != -1) {
        verses[encontrado].highlights.add(lighter); // actualizo verses
      }
    }

    setState(() {});
  }

  /// Método que verifica si ya esta resaltado la elección
  bool _selectionOverlapsHighlights(TextSelection selection, String fullText) {
    for (final verse in verses) {
      for (final highlight in verse.highlights) {
        // Calcular las posiciones globales del resaltado en el texto completo
        final verseStart = _getVerseGlobalStart(verse, fullText);
        final highlightStart = verseStart + highlight!.startIndex;
        final highlightEnd = verseStart + highlight.endIndex;

        // Verificar si la selección se superpone con este resaltado
        if (selection.start < highlightEnd && selection.end > highlightStart) {
          return true;
        }
      }
    }
    return false;
  }

  /// Método que se encarga de mostrar dialogo para eliminar el resaltado
  void _showHighlightOptions(
      BuildContext context, HighlightRangeModel highlight) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Resaltado"),
        content: Text("¿Qué deseas hacer con este resaltado?"),
        actions: [
          TextButton(
            child: Text("Eliminar"),
            onPressed: () {
              _removeHighlight(highlight);
              Navigator.pop(ctx);
            },
          ),
          TextButton(
            child: Text("Cancelar"),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  /// Función auxiliar para obtener la posición inicial global de un versículo
  int _getVerseGlobalStart(VerseModel verse, String fullText) {
    int position = 0;
    for (final v in verses) {
      if (v.id == verse.id) break;
      position += "${v.verse} ${v.text}".length + 1; // +1 por el espacio
    }
    return position;
  }

  /// Método para obtener versículo(s) seleccionado
  ///
  List<VerseModel> _getVersesInSelection(
      TextSelection selection, String fullText) {
    int currentPosition = 0;
    final selectedVerses = <VerseModel>[];

    // recorremos verses para asignar posición inicial y final
    for (VerseModel verse in verses) {
      final verseText = verse.text;
      final verseStart = currentPosition;
      final verseEnd = currentPosition + verseText.length;
      int initial = 0;
      int posFinal = 0;
      // Verificar si la selección se superpone con este versículo
      if (selection.start < verseEnd && selection.end > verseStart) {
        initial =
            ((selection.start) > verseStart ? selection.start : verseStart) -
                verseStart;
        posFinal = selection.end > verseEnd
            ? verseEnd - verseStart
            : selection.end - verseStart;

        // Guarda la nueva instancia en la list/
        verse = verse.copyWith(
          // <- Asigna el resultado
          posIni: initial == 1 ? initial - 1 : initial,
          posFin: posFinal,
        );
        selectedVerses.add(verse);
      }

      currentPosition = verseEnd + 1; // +1 por el espacio entre versículos
    }

    return selectedVerses;
  }

  /// Método que se encarga de remover el resaltado
  void _removeHighlight(HighlightRangeModel highlight) async {
    // llamamos servicio de remover resaltado
    LoadingService().showLoading(context);
    final responseRemove = await removeHighLighters(highlight.id);
    if (responseRemove.error != null) {
      LoadingService().hideLoading();
      // ignore: use_build_context_synchronously
      await showCustomDialog(context,
          message: responseRemove.error!, dialogType: DialogType.error);
      return;
    }
    LoadingService().hideLoading();
    setState(() {
      _highlights.remove(highlight);
      for (final verse in verses) {
        verse.highlights.removeWhere((h) =>
            h!.id == highlight.id &&
            h.startIndex == highlight.startIndex &&
            h.endIndex == highlight.endIndex);
      }
    });
  }

// Manejar favoritos
  void _toggleFavorite(VerseModel verse) async {
    LoadingService().showLoading(context);
    try {
      if (_favoriteVerses.any((f) => f.verse.id == verse.id)) {
        final responseRemove =
            await deleteVerseFavorite(userData!.userId, verse.id);
        if (responseRemove.error != null) {
          await showCustomDialog(context,
              message: responseRemove.error!, dialogType: DialogType.error);
          LoadingService().hideLoading();
          return;
        }
        // Si ya está en favoritos, lo eliminamos
        setState(() {
          _favoriteVerses.removeAt(
              _favoriteVerses.indexWhere((f) => f.verse.id == verse.id));
        });
      } else {
        final responseAddfavorite =
            await createNewVerseFavoriteByUser(userData!.userId, verse.id);

        if (responseAddfavorite.error != null) {
          await showCustomDialog(context,
              message: responseAddfavorite.error!,
              dialogType: DialogType.error);
          LoadingService().hideLoading();
          return;
        }

        // Si no está en favoritos, lo agregamos
        setState(() {
          _favoriteVerses.add(FavoriteVerse(
              userId: userData!.userId,
              book: currentBook!,
              chapter: currentChapter!,
              verse: verse));
        });
      }
      LoadingService().hideLoading();
    } catch (e) {
      LoadingService().hideLoading();
      await showCustomDialog(context,
          message: e.toString(), dialogType: DialogType.error);
    }
  }

  /// Método que se encarga de cargar los versículos resaltados
  Future<void> _loadHighlights() async {
    if (userData != null && currentVersion != null && currentChapter != null) {
      final responseHighLighter = await getAllHighLighters(
          userData!.userId, int.parse(currentVersion!.id), currentChapter!.id);
      if (responseHighLighter.error != null) {
        errorMessage = responseHighLighter.error;
        return;
      }

      if (responseHighLighter.data.length > 0) {
        setState(() {
          _highlights = responseHighLighter.data
              .map<HighlightRangeModel>((h) => HighlightRangeModel(
                  id: h['verse']['id'],
                  verse: h['verse']['verse'],
                  startIndex: h['startIndex'],
                  endIndex: h['endIndex'],
                  color: h['color']))
              .toList();
          for (final verse in verses) {
            verse.highlights.clear();
            verse.highlights.addAll(_highlights.where((h) => h.id == verse.id));
          }
        });
      }
    }
  }

  /// Método que se encarga de cargar la data persistente de lso resaltados
  Future<void> _loadPersistedData() async {
    // Cargar el tema guardado primero
    await Provider.of<BibleThemeProvider>(context, listen: false)
        .loadSavedTheme();
    // cargar los favoritos
    String userId = userData != null ? userData!.userId : '';
    String? chapterId = currentChapter != null ? currentChapter!.id : null;
    String versionId = currentVersion != null ? currentVersion!.id : "0";

    final responseFavorite =
        await getFavoriteVerseByUser(null, null, versionId, chapterId, userId);
    if (responseFavorite.data != null && responseFavorite.data.length > 0) {
      setState(() {
        _favoriteVerses = responseFavorite.data['data']
            .map<FavoriteVerse>((favorite) => FavoriteVerse.fromJson(favorite))
            .toList();
      });
    }
    if (Provider.of<CatalogueProvider>(context, listen: false)
        .allBibleVersion
        .isEmpty) {
      await Provider.of<CatalogueProvider>(context, listen: false)
          .loadBibleVersions();
    }
    if (prefs!.getDouble("fontSizeVerse") != null) {
      setState(() {
        fontSizeVerse = prefs!.getDouble("fontSizeVerse")!;
      });
    }
    // Recuperar ModelData de SharedPreferences
    if (prefs!.getString("fontFamilySet") != null) {
      setState(() {
        fontFamilySet = ModelData.fromJson(
          jsonDecode(prefs!.getString("fontFamilySet")!),
        );
      });
    }
    if (mounted) setState(() {});
  }

  /// Método de carga inicial de datos
  Future<void> _initDataLoad() async {
    prefs = await SharedPreferences.getInstance();
    LoadingService().showLoading(context);
    setState(() {
      errorMessage = null;
    });
    lastVersionsSelected =
        prefs!.getString(preferenceKey); //  cargo la version almacena en cache

    final loadBook =
        prefs!.getString('bookSelected'); // cargo el libro almacenado en cache
    //leemos la data persistida
    try {
      // si hay version en cache
      setState(() {
        if (lastVersionsSelected != null) {
          // busco esa version
          currentVersion =
              Provider.of<CatalogueProvider>(context, listen: false)
                  .allBibleVersion
                  .firstWhere((version) => version.id == lastVersionsSelected);

          if (loadBook != null) {
            currentBook =
                currentVersion!.books.firstWhere((book) => book.id == loadBook);
            // cargamos el capitulo correspondiente
          } else {
            currentBook = currentVersion!.books[0];
          }
        } else {
          currentVersion =
              Provider.of<CatalogueProvider>(context, listen: false)
                  .allBibleVersion[0];

          currentBook = currentVersion!.books[0];
        }
      });
      //consulto todos los capítulos del libro actual con sus versículos
      await loadChapters(currentBook!, false);
      await _loadPersistedData();

      _loadAudioChapters();
      // validamos si se habilita o deshabilita el botón anterior y el botón siguiente
      validateNextAndPrevious();
    } catch (e) {
      LoadingService().hideLoading();
      errorMessage = 'Error al cargar la biblia $e';
      setState(() {
        isLoading = false;
      });
    } finally {
      LoadingService().hideLoading();
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Método para ir al siguiente capítulo
  Future<void> _goToPreviousChapter(String chapterNumber) async {
    LoadingService().showLoading(context);
    if (currentChapter!.chapter > 1) {
      setState(() {
        currentChapter = allChapters.firstWhere((chapter) =>
            chapter.chapter.toString() == chapterNumber.toString());
        verses = currentChapter!.verses;
        verses.sort((a, b) {
          // Convertir a números si son strings (ejemplo: "1" -> 1)
          final verseA = a.verse;
          final verseB = b.verse;

          return verseA.compareTo(verseB); // Orden ascendente
        });
        prefs!.setString('chapterSelected', chapterNumber);
      });
    } else if (currentBook!.numberBook > 1) {
      // Ir al último capítulo del libro anterior
      final prevBook = currentVersion!.books
          .firstWhere((b) => b.numberBook == currentBook!.numberBook - 1);
      setState(() {
        // actualizo libro actual con el anterior
        currentBook = prevBook;
      });
      prefs!.setString('bookSelected', prevBook.id);

      /// consultamos los capítulos con sus versículos del libro anterior y le indicamos
      /// que es el primer capítulo del libro que se esta abandonando
      await loadChapters(prevBook, true);

      // actualizamos el storage del capítulo seleccionado
      prefs!.setString('chapterSelected', currentChapter!.chapter.toString());
    }

    // cargamos los resaltados
    await _loadHighlights();

    LoadingService().hideLoading();

    // validamos si se habilita o deshabilita el botón anterior y el botón siguiente
    validateNextAndPrevious();
  }

  /// Método para regresar al capítulo anterior
  Future<void> _goToNextChapter(String chapterNumber) async {
    LoadingService().showLoading(context);
    if (currentChapter!.chapter < currentBook!.chapters) {
      setState(() {
        currentChapter = allChapters.firstWhere((chapter) =>
            chapter.chapter.toString() == chapterNumber.toString());
        verses = currentChapter!.verses;
        verses.sort((a, b) {
          // Convertir a números si son strings (ejemplo: "1" -> 1)
          final verseA = a.verse;
          final verseB = b.verse;

          return verseA.compareTo(verseB); // Orden ascendente
        });
        prefs!.setString('chapterSelected', chapterNumber);
      });
    } else if (currentBook!.numberBook < currentVersion!.books.length) {
      // Ir al primer capítulo del siguiente libro
      final nextBook = currentVersion!.books
          .firstWhere((b) => b.numberBook == currentBook!.numberBook + 1);
      setState(() {
        // actualizo libro actual con el anterior
        currentBook = nextBook;
      });

      // actualizamos el storage de libro seleccionado
      prefs!.setString('bookSelected', nextBook.id);

      // removemos el storage de capítulo seleccionado
      prefs!.remove('chapterSelected');

      /// consultamos los capítulos con sus versículos del libro siguiente y le indicamos
      /// en false el parámetro firstChapter
      await loadChapters(nextBook, false);
    }

    // cargamos los resaltados
    await _loadHighlights();
    LoadingService().hideLoading();
    // validamos si se habilita o deshabilita el botón anterior y el botón siguiente
    validateNextAndPrevious();
  }

  Future<void> loadChapters(BookModel book, bool firstChapter) async {
    LoadingService().showLoading(context);
    try {
      //consulto todos los capítulos del libro actual con sus versículos
      final responseChapterByBook = await getChapterWithVerses(book.id);
      if (responseChapterByBook.error != null) {
        setState(() {
          errorMessage = responseChapterByBook.error;
        });
        return;
      }
      setState(() {
        allChapters = responseChapterByBook.data
            .map<ChapterModel>((chapter) => ChapterModel.fromJson(chapter))
            .toList();

        allChapters.sort((a, b) {
          // Convertir a números si son strings (ejemplo: "1" -> 1)
          final chapterA = a.chapter;
          final chapterB = b.chapter;

          return chapterA.compareTo(chapterB); // Orden ascendente
        });
        //si no es el el primer capítulo del libro
        if (!firstChapter) {
          // verificamos si hay capítulo en cache
          if (prefs!.getString('chapterSelected') != null) {
            currentChapter = allChapters.firstWhere((ch) =>
                ch.chapter.toString() == prefs!.getString('chapterSelected'));
          } else {
            currentChapter = allChapters.first;
          }
        } else {
          currentChapter = allChapters.last;
        }

        if (currentChapter != null) {
          verses = currentChapter!.verses
              .map<VerseModel>((verse) => VerseModel.fromJson(verse.toJson()))
              .toList();
          //ordenamos los versículos de menor a mayor
          verses.sort((a, b) {
            final verseA = a.verse;
            final verseB = b.verse;

            return verseA.compareTo(verseB); // Orden ascendente
          });
        }
      });
      // actualizamos la propiedad chapters con la cantidad de capítulos del libro
      setState(() {
        currentBook = book.copyWith(
          chapters: allChapters.length - 1,
        );
      });
    } catch (e) {
      LoadingService().hideLoading();
      errorMessage = 'Error al cargar el capítulo $e';
      setState(() {
        isLoading = false;
      });
    } finally {
      LoadingService().hideLoading();
      setState(() {
        isLoading = false;
      });
    }
  }

  void validateNextAndPrevious() {
    if (currentBook != null &&
        currentBook!.numberBook == 1 &&
        (currentChapter != null && currentChapter!.chapter == 1)) {
      setState(() {
        hasPreviousChapter = false;
      });
    } else {
      setState(() {
        hasPreviousChapter = true;
      });
    }
    if (currentBook != null &&
        currentBook!.numberBook == currentBook!.chapters &&
        currentChapter!.chapter == currentBook!.chapters) {
      setState(() {
        hasNextChapter = false;
      });
    } else {
      setState(() {
        hasNextChapter = true;
      });
    }
  }

  loadVersionAndVerseRange(InputDataSearchModel data) async {
    final bibleVersions = Provider.of<CatalogueProvider>(context, listen: false)
        .allBibleVersion
        .map((v) => ModelData(value: v.id, label: v.version))
        .toList();
    setState(() {
      lastVersionsSelected = bibleVersions
          .firstWhere((version) => version.value == data.versionId)
          .value;
      final currentVers = Provider.of<CatalogueProvider>(context, listen: false)
          .allBibleVersion
          .firstWhere((version) => version.id == lastVersionsSelected);
      currentVersion = currentVers;
      currentBook =
          currentVers.books.firstWhere((book) => book.id == data.bookId);
    });
    LoadingService().showLoading(context);
    try {
      //consulto todos los capítulos del libro actual con sus versículos
      final responseChapterByBook = await getChapterWithVerses(currentBook!.id);
      if (responseChapterByBook.error != null) {
        setState(() {
          errorMessage = responseChapterByBook.error;
        });
        return;
      }
      setState(() {
        allChapters = responseChapterByBook.data
            .map<ChapterModel>((chapter) => ChapterModel.fromJson(chapter))
            .toList();

        allChapters.sort((a, b) {
          // Convertir a números si son strings (ejemplo: "1" -> 1)
          final chapterA = a.chapter;
          final chapterB = b.chapter;

          return chapterA.compareTo(chapterB); // Orden ascendente
        });
        //si no es el el primer capítulo del libro
        currentChapter =
            allChapters.firstWhere((chapter) => chapter.id == data.chapterId);

        verses = getVersesInRange(
            currentChapter!.verses, data.startVerseId, data.endVerseId);
      });
      setState(() {
        currentBook = currentBook!.copyWith(
          chapters: allChapters.length - 1,
        );
        // Mover el scroll al versículo de inicio si está presente
        if (data.startVerseId != null && verses.isNotEmpty) {
          final startIndex =
              verses.indexWhere((v) => v.id == data.startVerseId);
          if (startIndex != -1) {
            // Esperar al siguiente frame para asegurar que el ListView esté construido
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (_selectableTextKey.currentContext != null &&
                  scrollController.hasClients) {
                try {
                  final renderBox =
                      _selectableTextKey.currentContext!.findRenderObject();
                  if (renderBox is RenderBox) {
                    final text = verses
                        .sublist(0, startIndex)
                        .map((v) => "${v.verse} ${v.text}")
                        .join(' ');
                    final tp = TextPainter(
                      text: TextSpan(
                        text: text,
                        style: StylesApp(context).textStyleBody14.copyWith(
                              fontFamily: fontFamilySet.label,
                              fontSize: fontSizeVerse,
                            ),
                      ),
                      textDirection: TextDirection.ltr,
                      maxLines: null,
                    );
                    tp.layout(maxWidth: renderBox.size.width);
                    final offsetY = tp.height - 15;
                    await scrollController.animateTo(
                      offsetY,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                } catch (_) {
                  final itemHeight = 40.0;
                  await scrollController.animateTo(
                    startIndex * itemHeight,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }
              }
            });
          }
        }
      });
    } catch (e) {
      LoadingService().hideLoading();
      errorMessage = 'Error al cargar el capítulo $e';
      setState(() {
        isLoading = false;
      });
    } finally {
      LoadingService().hideLoading();
      setState(() {
        isLoading = false;
      });
    }
  }

  // Variable para almacenar el ID del versículo marcado por scroll
  String? _scrolledVerseId;

  loadVersionAndChapter(InputDataSearchModel data) async {
    final bibleVersions = Provider.of<CatalogueProvider>(context, listen: false)
        .allBibleVersion
        .map((v) => ModelData(value: v.id, label: v.version))
        .toList();
    setState(() {
      lastVersionsSelected = bibleVersions
          .firstWhere((version) => version.value == data.versionId)
          .value;
      final currentVers = Provider.of<CatalogueProvider>(context, listen: false)
          .allBibleVersion
          .firstWhere((version) => version.id == lastVersionsSelected);
      currentVersion = currentVers;
      currentBook =
          currentVers.books.firstWhere((book) => book.id == data.bookId);
    });
    LoadingService().showLoading(context);
    try {
      //consulto todos los capítulos del libro actual con sus versículos
      final responseChapterByBook = await getChapterWithVerses(currentBook!.id);
      if (responseChapterByBook.error != null) {
        setState(() {
          errorMessage = responseChapterByBook.error;
        });
        return;
      }
      setState(() {
        allChapters = responseChapterByBook.data
            .map<ChapterModel>((chapter) => ChapterModel.fromJson(chapter))
            .toList();

        allChapters.sort((a, b) {
          // Convertir a números si son strings (ejemplo: "1" -> 1)
          final chapterA = a.chapter;
          final chapterB = b.chapter;

          return chapterA.compareTo(chapterB); // Orden ascendente
        });
        //si no es el el primer capítulo del libro
        currentChapter =
            allChapters.firstWhere((chapter) => chapter.id == data.chapterId);

        verses = currentChapter!.verses;
      });
      setState(() {
        currentBook = currentBook!.copyWith(
          chapters: allChapters.length - 1,
        );
        // Mover el scroll al versículo de inicio si está presente
        if (data.startVerseId != null && verses.isNotEmpty) {
          final startIndex =
              verses.indexWhere((v) => v.id == data.startVerseId);
          if (startIndex != -1) {
            _scrolledVerseId = verses[startIndex].id;
            // Guardar el ID del versículo marcado por scroll
              WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (_selectableTextKey.currentContext != null &&
                  scrollController.hasClients) {
                try {
                  final renderBox =
                      _selectableTextKey.currentContext!.findRenderObject();
                  if (renderBox is RenderBox) {
                    final text = verses
                        .sublist(0, startIndex)
                        .map((v) => "${v.verse} ${v.text}")
                        .join(' ');
                    final tp = TextPainter(
                      text: TextSpan(
                        text: text,
                        style: StylesApp(context).textStyleBody14.copyWith(
                              fontFamily: fontFamilySet.label,
                              fontSize: fontSizeVerse,
                            ),
                      ),
                      textDirection: TextDirection.ltr,
                      maxLines: null,
                    );
                    tp.layout(maxWidth: renderBox.size.width);
                    final offsetY = tp.height;
                    await scrollController.animateTo(
                      offsetY,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                } catch (_) {
                  final itemHeight = 40.0;
                  await scrollController.animateTo(
                    startIndex * itemHeight,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }
              }
            });
          }
        } else {
          // Si no hay startVerseId, limpiar el marcador
          _scrolledVerseId = null;
        }
      });
    } catch (e) {
      LoadingService().hideLoading();
      errorMessage = 'Error al cargar el capítulo $e';
      setState(() {
        isLoading = false;
      });
    } finally {
      LoadingService().hideLoading();
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loadAudioChapters() async {
    final audioChapterResponse = await getAudioByChapter(currentChapter!.id);
    if (audioChapterResponse.error != null) {
      await showCustomDialog(context,
          message: audioChapterResponse.error!, dialogType: DialogType.error);
      return;
    }
    setState(() {
      audioChapter = AudioChapterModel.fromJson(audioChapterResponse.data);
    });
  }

  Future<void> _togglePlayPause() async {
    if (isPlaying) {
      await flutterTts.pause();
      setState(() => isPlaying = false);
    } else {
      if (currentPlayingVerseIndex != null) {
        // If your TTS plugin supports resume(), use it; otherwise, re-call speak() for the next verse.
        await flutterTts.awaitSpeakCompletion(true);
        if (currentPlayingVerseIndex != null &&
            currentPlayingVerseIndex! < verses.length) {
          await flutterTts.speak(
              "Versículo ${verses[currentPlayingVerseIndex!].verse}. ${verses[currentPlayingVerseIndex!].text}");
        }
      } else {
        _readFullChapter();
      }
      setState(() => isPlaying = true);
    }
  }
}

// Obtener versículos por rango de IDs
List<VerseModel> getVersesInRange(
    List<VerseModel> verses, String startId, String endId) {
  try {
    final start = int.parse(startId);
    final end = int.parse(endId);

    if (start > end) {
      throw ArgumentError('startVerseId no puede ser mayor que endVerseId');
    }

    // Buscar los versículos en el rango
    final result = verses.where((verse) {
      final verseNumber = int.parse(verse.id);
      return verseNumber >= start && verseNumber <= end;
    }).toList();

    if (result.isEmpty) {
      throw StateError('No se encontraron versículos en el rango $start-$end');
    }

    return result;
  } on FormatException {
    throw FormatException('Los IDs deben ser números válidos');
  }
}
