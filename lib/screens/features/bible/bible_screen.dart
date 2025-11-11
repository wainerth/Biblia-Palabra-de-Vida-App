import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:math';

import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/class/bible_version_selector.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
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
  double fontSizeNumber = 12;
  double fontSizeVerse = 16;
  ModelData fontFamilySet = ModelData(label: "Aclonica", value: "1");
  AudioChapterModel? audioChapter;
  Video video = Video(url: "");
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
  int? scrollToVerse;
  final Map<int, GlobalKey> _verseKeys = {};
  bool _isManualScroll = false;

  final double _scrollThreshold = 50.0;

  // Nueva variable para controlar el drawer
  bool _showDrawer = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initTTS(); // Inicializar TTS
    _initSpeechRate();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userData = userProvider.currentUser;
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      await _initDataLoad();

      _loadHighlights();

      if (args != null) {
        if (args['bibleId'] != null) {
          final bibleId = args['bibleId'];
          final bookId = args['bookId'];
          final chapterId = args['chapterId'];
          final verseId = args['verseId'];
          await loadVersionAndChapter(InputDataSearchModel(
              versionId: bibleId,
              bookId: bookId,
              chapterId: chapterId,
              startVerseId: verseId,
              endVerseId: verseId));

          args.clear();
        }
      }
    });
    scrollController.addListener(() {
      _handleScroll();
      // Cuando el usuario mueve el scroll manualmente
      if (scrollController.position.isScrollingNotifier.value) {
        if (!_isManualScroll) return;
        if (scrollToVerse != null && scrollToVerse! > 0) {
          setState(() => scrollToVerse = null);
        }
      }
    });
  }

  @override
  void dispose() {
    flutterTts.stop(); // Detener TTS al salir
    scrollController.dispose();
    super.dispose();
  }

  void _initTTS() async {
    flutterTts = FlutterTts();

    await flutterTts.setLanguage("es-ES"); // Configurar idioma
    // await flutterTts.setVoice({"name": "es-es-x-ana-local", "locale": "es-ES"});
    await flutterTts.setSpeechRate(0.5); // Velocidad de habla (0-1)
    await flutterTts.setVolume(1.0); // Volumen (0-1)
    await flutterTts.setPitch(1.0); // Tono (0.5-2.0)

    // Configurar handlers para eventos
    flutterTts.setStartHandler(() {
      setState(() => isPlaying = true);
    });

    flutterTts.setCompletionHandler(() {
      setState(() {});
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
    final rate = await PreferencesManager().getTtsSpeechRate();
    setState(() {
      _speechRate = rate;
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
        await flutterTts.speak("${verses[i].text}.");
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

  void _handleScroll() {
    final scrollPosition = scrollController.position;

    if (scrollPosition.pixels > _scrollThreshold && !_showDrawer) {
      setState(() => _showDrawer = true);
    } else if (scrollPosition.pixels <= _scrollThreshold && _showDrawer) {
      setState(() => _showDrawer = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<BibleThemeProvider>(context);
    currentTheme = themeProvider.themeData;

    return Consumer<BibleThemeProvider>(
        builder: (context, themeProvider, child) {
      final currentTheme = themeProvider.themeData;
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: currentTheme.backgroundColor,
        endDrawer:
            _buildNavigationDrawer(currentTheme), // Drawer siempre disponible
        endDrawerEnableOpenDragGesture: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        floatingActionButton: _showDrawer
            ? FloatingActionButton(
                mini: true,
                elevation: 0,
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
                backgroundColor: currentTheme.backgroundColor,
                child: Icon(
                  Icons.menu,
                  color: currentTheme.buttonColor,
                ),
              )
            : null,
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
                    onBack: () => Navigator.pushReplacementNamed(
                        context, '/layoutPage',
                        arguments: {'selectedIndex': 0}),
                  )
                } else ...{
                  // cabecera
                  if (!_showDrawer)
                    BibleHeaderWidget(
                      spacingBottom: 10.0,
                      onSearchBible: () {
                        openModal();
                      },
                      versionName:
                          currentVersion != null ? currentVersion!.version : '',
                      title: currentBook != null ? currentBook!.modernName : '',
                      showIconVideo: video.url.isNotEmpty,
                      chapter: currentChapter != null
                          ? '${currentChapter!.chapter}'
                          : '',
                      onVideoCollection: () async {
                        await _showVideoDialog();
                      },
                      onBack: () async {
                        Navigator.pushNamed(
                          context,
                          '/layoutPage',
                          arguments: {'selectedIndex': 0},
                        );
                      },
                      onVersionTap: () async {
                        await _changeBibleVersion();
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
                                            if (_showDrawer)
                                              _buildDrawerIndicator(
                                                  currentTheme),
                                            // Otros widgets de la lista...
                                            const SizedBox(height: 40),
                                            _buildContinuousText(), // Tu texto formateado como un widget
                                            SizedBox(
                                              height:
                                                  kBottomNavigationBarHeight +
                                                      45,
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
                                  // CUSTOMIZE BUTTON
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
                                              onChangedFontSize:
                                                  (fontSize) async {
                                                setState(() {
                                                  // persistir tamaño de fuente
                                                  fontSizeNumber =
                                                      fontSize! - 4;
                                                  fontSizeVerse = fontSize;
                                                });
                                                await PreferencesManager()
                                                    .setFontSizeVerse(
                                                        fontSize!);
                                              },
                                              onChangedFont: (newFont) async {
                                                if (kDebugMode) {
                                                  print(
                                                      'la nueva fuente ${newFont!.label}');
                                                }
                                                // persistir familia de fuente
                                                setState(() {
                                                  fontFamilySet = newFont!;
                                                });
                                                await PreferencesManager()
                                                    .setFontFamilySet(
                                                        newFont!.toJson());
                                              },
                                            );
                                          });
                                    },
                                    icon: Icon(
                                      CupertinoIcons.textformat_size,
                                      color: currentTheme.buttonColor,
                                    ),
                                  ),

                                  // COPY BUTTON
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 25.0,
                                    onPressed: () async {
                                      Clipboard.setData(ClipboardData(
                                          text: await copyChapter(
                                              currentVersion,
                                              currentBook,
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
                                  // SHARED BUTTON
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 25.0,
                                    onPressed: () async {
                                      await SharePlus.instance
                                          .share(ShareParams(
                                        text: await copyChapter(currentVersion,
                                            currentBook, currentChapter),
                                        subject:
                                            "Palabra de Vida - ${currentChapter!.chapter} ${currentBook!.modernName} \n ver en:${GraphQLConfig.urlServidor}officialbible",
                                      ));
                                    },
                                    icon: Icon(
                                      Icons.share_rounded,
                                      color: currentTheme.buttonColor,
                                    ),
                                  ),
                                  // MODAL ACTIONS BUTTON
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 25.0,
                                    onPressed: () {
                                      openModal();
                                    },
                                    icon: Icon(
                                      Icons.search_rounded,
                                      color: currentTheme.buttonColor,
                                    ),
                                  ),
                                  // FAVORITE BUTTON
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
                                                      setState(() {
                                                        _favoriteVerses
                                                            .removeAt(
                                                                indexToDelete);
                                                      });
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
                                      color: currentTheme.buttonColor,
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
                                                                .withValues(
                                                                    alpha: 0.3),
                                                        onChanged:
                                                            (value) async {
                                                          setState(() =>
                                                              _speechRate =
                                                                  value);
                                                          await flutterTts
                                                              .setSpeechRate(
                                                                  value);

                                                          await PreferencesManager()
                                                              .setTtsSpeechRate(
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
                                        ],
                                      ),
                                    ),
                                  ),
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

  /// Widget realiza la construcción de los textSpan para selección continua
  Widget _buildContinuousText() {
    // 🔥 TEXTO COMPLETO con números para copiar/compartir
    final fullTextWithNumbers =
        verses.map((v) => "${v.verse} ${v.text}").join(' ');
    // 🔥 TEXTO SIN números para backend/resaltado
    final fullTextWithoutNumbers = verses.map((v) => v.text).join(' ');

    return SelectableText.rich(
      key: _selectableTextKey,
      TextSpan(
        children: verses.asMap().entries.map((entry) {
          final index = entry.key;
          final verse = entry.value;
          _verseKeys[index] ??= GlobalKey();

          return TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: Stack(
                  key: _verseKeys[index],
                  alignment: Alignment.center,
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
                          child: Transform.translate(
                              offset: Offset(0, -4),
                              child: Stack(
                                children: [
                                  if (scrollToVerse != null &&
                                      scrollToVerse == verses.indexOf(verse))
                                    StreamBuilder<bool>(
                                      stream: Stream.periodic(
                                          const Duration(milliseconds: 700),
                                          (i) => i % 2 == 0),
                                      builder: (context, snapshot) {
                                        final active = snapshot.data ?? true;
                                        return AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 350),
                                          opacity: active ? 1.0 : 0.35,
                                          child: Transform.translate(
                                            offset: active
                                                ? const Offset(6, 0)
                                                : const Offset(0, 0),
                                            child: Icon(
                                              weight: 75.0,
                                              Icons
                                                  .swap_horizontal_circle_rounded,
                                              size: 22,
                                              color: StyleColor.blueDark,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  SizedBox(
                                    child: Text(
                                      "${verse.verse}",
                                      style: StylesApp(context)
                                          .textStyleBody16
                                          .copyWith(
                                            fontFamily: fontFamilySet.label,
                                            fontSize: fontSizeNumber,
                                            fontWeight: FontWeight.bold,
                                            color: currentPlayingVerseIndex ==
                                                    verses.indexOf(verse)
                                                ? Colors.blue
                                                : currentTheme
                                                    .verseHighlightColor,
                                          ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 🔥 TextSpan simple sin números para la selección
              ..._buildHighlightedTextSpansForSelection(verse),
            ],
          );
        }).toList(),
      ),
      contextMenuBuilder: (context, selectableRegionState) {
        final selection = selectableRegionState.textEditingValue.selection;

        // 🔥 TEXTO PARA COPIAR/COMPARTIR: Con números
        final selectedTextWithNumbers =
            selection.textInside(fullTextWithNumbers);
        // 🔥 TEXTO PARA BACKEND/RESALTADO: Sin números
        final selectedTextWithoutNumbers = _getSelectedTextWithoutNumbers(
            selection, fullTextWithNumbers, fullTextWithoutNumbers);

        if (kDebugMode) {
          print(
              "🎯 Texto seleccionado CON números: '$selectedTextWithNumbers'");
          print(
              "🎯 Texto seleccionado SIN números: '$selectedTextWithoutNumbers'");
          print("📏 Rango selección: ${selection.start}-${selection.end}");
        }

        // 🔥 OBTENER versículos usando el texto SIN números para el backend
        final selectedVerses =
            _getVersesInSelectionFromOriginalSelection(selection);

        // _getVersesInSelectionWithoutNumbers(
        //     selection, fullTextWithNumbers, fullTextWithoutNumbers);
        final overlapsHighlights =
            _selectionOverlapsHighlights(selection, fullTextWithNumbers);

        // 🔥 DEBUG: Verificar qué versículos se detectaron
        if (kDebugMode) {
          print("📋 Versículos detectados: ${selectedVerses.length}");
          for (final verse in selectedVerses) {
            print(
                "   📖 Versículo ${verse.verse}: '${verse.text.substring(verse.posIni!, verse.posFin!)}'");
          }
        }

        return CustomContextMenu(
          anchors: selectableRegionState.contextMenuAnchors,
          children: [
            CustomContextMenuItem(
              icon: Icons.content_copy,
              label: 'Copiar versículo',
              onPressed: () {
                final reference =
                    "${currentBook?.modernName} ${currentChapter?.chapter}:${selectedVerses.isNotEmpty ? selectedVerses.first.verse : ''}";
                // 🔥 COPIAR texto CON números
                print("Copiado a :  $reference");
                Clipboard.setData(ClipboardData(
                    text: "$reference\n$selectedTextWithNumbers"));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Versículo copiado')),
                );
                selectableRegionState.hideToolbar();
              },
            ),
            CustomContextMenuItem(
              icon: Icons.share,
              label: 'Compartir versículo',
              onPressed: () {
                final reference =
                    "${currentBook?.modernName} ${currentChapter?.chapter}:${selectedVerses.isNotEmpty ? selectedVerses.first.verse : ''}";
                // 🔥 COMPARTIR texto CON números
                SharePlus.instance.share(ShareParams(
                  text: "$reference\n$selectedTextWithNumbers",
                  subject: 'Versículo de ${currentBook?.modernName}',
                ));
                selectableRegionState.hideToolbar();
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
                  // 🔥 RESALTAR usando versículos SIN números
                  _showColorPickerForSelection(
                    context,
                    selectedVerses,
                    selection.start,
                    selection.end,
                    selectedVerses.length > 1,
                  );
                  selectableRegionState.hideToolbar();
                },
              ),
          ],
        );
      },
      onSelectionChanged: (selection, cause) {
        if (selection.isValid && !selection.isCollapsed) {
          final overlaps =
              _selectionOverlapsHighlights(selection, fullTextWithNumbers);
          if (overlaps) {
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

  /// 🔥 FUNCIÓN SIMPLIFICADA: Obtener versículos desde selección original
  List<VerseModel> _getVersesInSelectionFromOriginalSelection(
      TextSelection selection) {
    List<VerseModel> selectedVerses = [];

    if (!selection.isValid || selection.isCollapsed) {
      return selectedVerses;
    }

    int currentPosition = 0;

    for (final verse in verses) {
      final verseText = verse.text;
      final verseNumber = "${verse.verse} ";
      final verseNumberLength = verseNumber.length;

      // Rango de este versículo en el texto completo
      final verseStart = currentPosition;
      final verseEnd = currentPosition + verseNumberLength + verseText.length;

      // Verificar superposición
      if (selection.start < verseEnd && selection.end > verseStart) {
        // Calcular qué parte del texto del versículo está seleccionada
        final selectionStartInVerse =
            selection.start - verseStart - verseNumberLength;
        final selectionEndInVerse =
            selection.end - verseStart - verseNumberLength;

        // Ajustar límites
        final start = selectionStartInVerse.clamp(0, verseText.length);
        final end = selectionEndInVerse.clamp(0, verseText.length);

        if (start < end) {
          final selectedVerse = VerseModel(
            id: verse.id,
            verse: verse.verse,
            text: verse.text,
            highlights: verse.highlights,
            posIni: start,
            posFin: end,
          );
          selectedVerses.add(selectedVerse);
        }
      }

      currentPosition += verseNumberLength + verseText.length + 1;
    }

    return selectedVerses;
  }

  /// 🔥 NUEVA FUNCIÓN: Obtener texto seleccionado sin números de versículo
  String _getSelectedTextWithoutNumbers(TextSelection selection,
      String fullTextWithNumbers, String fullTextWithoutNumbers) {
    if (!selection.isValid || selection.isCollapsed) return '';

    // 🔥 CONVERTIR selección de texto con números a texto sin números
    final selectionInWithoutNumbers = _convertSelectionToWithoutNumbers(
        selection, fullTextWithNumbers, fullTextWithoutNumbers);

    return selectionInWithoutNumbers.textInside(fullTextWithoutNumbers);
  }

  /// 🔥 FUNCIÓN MEJORADA: Convertir selección de texto con números a sin números
  TextSelection _convertSelectionToWithoutNumbers(
      TextSelection selectionWithNumbers,
      String fullTextWithNumbers,
      String fullTextWithoutNumbers) {
    int startWithoutNumbers = 0;
    int endWithoutNumbers = 0;
    int currentIndexWith = 0;
    int currentIndexWithout = 0;

    bool startFound = false;
    bool endFound = false;

    for (final verse in verses) {
      final verseNumber = "${verse.verse}";
      final verseText = verse.text;
      final verseNumberLength = verseNumber.length;

      final verseStartWithNumbers = currentIndexWith;
      final verseEndWithNumbers =
          currentIndexWith + verseNumberLength + verseText.length;
      final verseStartWithoutNumbers = currentIndexWithout;

      // Buscar el inicio de la selección
      if (!startFound &&
          selectionWithNumbers.start >= verseStartWithNumbers &&
          selectionWithNumbers.start <= verseEndWithNumbers) {
        if (selectionWithNumbers.start <=
            verseStartWithNumbers + verseNumberLength) {
          // La selección empieza en el número o antes del texto
          startWithoutNumbers = verseStartWithoutNumbers;
        } else {
          // La selección empieza en el texto
          startWithoutNumbers = verseStartWithoutNumbers +
              (selectionWithNumbers.start -
                  (verseStartWithNumbers + verseNumberLength));
        }
        startFound = true;
      }

      // Buscar el fin de la selección
      if (!endFound &&
          selectionWithNumbers.end >= verseStartWithNumbers &&
          selectionWithNumbers.end <= verseEndWithNumbers) {
        if (selectionWithNumbers.end <=
            verseStartWithNumbers + verseNumberLength) {
          // La selección termina en el número
          endWithoutNumbers = verseStartWithoutNumbers;
        } else {
          // La selección termina en el texto
          endWithoutNumbers = verseStartWithoutNumbers +
              (selectionWithNumbers.end -
                  (verseStartWithNumbers + verseNumberLength));
        }
        endFound = true;
      }

      // Si ya encontramos ambos, salir del loop
      if (startFound && endFound) break;

      currentIndexWith += verseNumberLength + verseText.length + 1;
      currentIndexWithout += verseText.length + 1;
    }

    // 🔥 Asegurar que endWithoutNumbers sea al menos igual a startWithoutNumbers
    if (endWithoutNumbers < startWithoutNumbers) {
      endWithoutNumbers = startWithoutNumbers;
    }

    return TextSelection(
      baseOffset: startWithoutNumbers,
      extentOffset: endWithoutNumbers,
    );
  }

  /// 🔥 VERSIÓN CORREGIDA: Método para crear resaltados que convierte índices
  List<TextSpan> _buildHighlightedTextSpansForSelection(VerseModel verse) {
    final text = " ${verse.text} "; // 🔥 INCLUIR el espacio alrededor del texto
    final spans = <TextSpan>[];
    int currentPos = 0;

    // Ordenar resaltados por posición de inicio
    verse.highlights!.sort((a, b) => a!.startIndex.compareTo(b!.startIndex));

    for (final highlight in verse.highlights!) {
      // 🔥 CONVERTIR índices de backend (solo texto) a índices de visualización (con número)
      final verseNumber = "${verse.verse}";
      final verseNumberLength = verseNumber.length;

      // Los índices del backend son relativos solo al texto, necesitamos ajustarlos
      final displayStartIndex = highlight!.startIndex + verseNumberLength;
      final displayEndIndex = highlight.endIndex + verseNumberLength;

      // 1. Texto antes del resaltado (si hay espacio no cubierto)
      if (currentPos < displayStartIndex) {
        spans.add(TextSpan(
          text: text.substring(currentPos, displayStartIndex),
          style: StylesApp(context).textStyleBody14.copyWith(
                decoration:
                    _isFavorite(verse) ? TextDecoration.underline : null,
                color: currentPlayingVerseIndex == verses.indexOf(verse)
                    ? Colors.blue
                    : currentTheme.textColor,
                decorationThickness: 4.0,
                decorationColor: StyleColor.yellowLight,
                fontFamily: fontFamilySet.label,
                fontSize: fontSizeVerse,
                fontWeight: FontWeight.w400,
              ),
        ));
      }

      // 2. Aplicar el resaltado con índices convertidos
      spans.add(TextSpan(
        recognizer: LongPressGestureRecognizer()
          ..onLongPress = () {
            if (kDebugMode) {
              print('Long press en versículo ${verse.verse}');
            }
            _showHighlightOptions(context, highlight);
          },
        text: text.substring(displayStartIndex, displayEndIndex),
        style: StylesApp(context).textStyleBody14.copyWith(
              decoration: _isFavorite(verse) ? TextDecoration.underline : null,
              color: currentPlayingVerseIndex == verses.indexOf(verse)
                  ? Colors.blue
                  : currentTheme.textColor,
              decorationThickness: 4.0,
              decorationColor: StyleColor.yellowLight,
              fontFamily: fontFamilySet.label,
              fontSize: fontSizeVerse,
              backgroundColor:
                  Color(int.parse('0XFF${formatColor(highlight.color)}'))
                      .withAlpha(77),
              fontWeight: FontWeight.w400,
            ),
      ));

      // Actualizar posición actual al final del resaltado actual
      currentPos = displayEndIndex;
    }

    // 3. Texto restante después del último resaltado
    if (currentPos < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentPos),
        style: StylesApp(context).textStyleBody14.copyWith(
              decoration: _isFavorite(verse) ? TextDecoration.underline : null,
              color: currentPlayingVerseIndex == verses.indexOf(verse)
                  ? Colors.blue
                  : currentTheme.textColor,
              decorationThickness: 4.0,
              decorationColor: StyleColor.yellowLight,
              fontFamily: fontFamilySet.label,
              fontSize: fontSizeVerse,
              fontWeight: FontWeight.w400,
            ),
      ));
    }

    return spans;
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
                setState(() {
                  isPlaying = false;
                });
                flutterTts.stop();

                _readVerse(verse);
              }
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 30),
        ],
      ),
    );
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
                    final hexColor = color
                        .toARGB32()
                        .toRadixString(16)
                        .padLeft(8, '0')
                        .toUpperCase();
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
                      color: Color(color.toARGB32()),
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
          SizedBox(
            height: 30,
          )
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
        id: verse.id!,
        verse: verse.verse,
        startIndex: verse.posIni!,
        endIndex: verse.posFin!,
        color: color,
      );
      inputHighlight.add(newHighlight); // actualizo temporal
    }
    LoadingService().showLoading(context);
    final responseCreate = await createHighLighters(inputHighlight,
        userData!.userId, int.parse(currentVersion!.id), currentChapter!.id!);
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
        verses[encontrado].highlights?.add(lighter); // actualizo verses
      }
    }

    setState(() {});
  }

  /// Método que verifica si ya esta resaltado la elección
  bool _selectionOverlapsHighlights(TextSelection selection, String fullText) {
    for (final verse in verses) {
      for (final highlight in verse.highlights!) {
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
        verse.highlights?.removeWhere((h) =>
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
            await deleteVerseFavorite(userData!.userId, verse.id!);
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
        final responseAddFavorite =
            await createNewVerseFavoriteByUser(userData!.userId, verse.id!);

        if (responseAddFavorite.error != null) {
          await showCustomDialog(context,
              message: responseAddFavorite.error!,
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
          userData!.userId, int.parse(currentVersion!.id), currentChapter!.id!);
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
            verse.highlights?.clear();
            verse.highlights
                ?.addAll(_highlights.where((h) => h.id == verse.id));
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
    String? chapterId = currentChapter?.id;
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
    final fontSize = await PreferencesManager().getFontSizeVerse();
    setState(() {
      fontSizeVerse = fontSize;
      fontSizeNumber = fontSizeVerse - 4;
    });

    // Recuperar ModelData de SharedPreferences
    final fontFamily = await PreferencesManager().getFontFamilySet();
    setState(() {
      fontFamilySet = ModelData.fromJson(fontFamily);
    });
    if (mounted) setState(() {});
  }

  /// Método de carga inicial de datos
  Future<void> _initDataLoad() async {
    LoadingService().showLoading(context);
    if (Provider.of<CatalogueProvider>(context, listen: false)
        .allBibleVersion
        .isEmpty) {
      await Provider.of<CatalogueProvider>(context, listen: false)
          .loadBibleVersions();
    }
    setState(() {
      errorMessage = null;
    });
    lastVersionsSelected = await PreferencesManager()
        .getSelectedBibleVersion(); //  cargo la version almacena en cache

    final loadBook = await PreferencesManager()
        .getBookSelected(); // cargo el libro almacenado en cache
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
      await loadVideoByChapter(currentChapter!.id!);
      // validamos si se habilita o deshabilita el botón anterior y el botón siguiente
      validateNextAndPrevious();
    } catch (e) {
      LoadingService().hideLoading();
      errorMessage = 'Error al cargar la biblia $e';
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } finally {
      LoadingService().hideLoading();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _buildSelectionDrawer() {
    return Drawer(
      width: 320,
      backgroundColor: StyleColor.blueDark,
      child: SafeArea(
        child: Column(
          children: [
            // Header del drawer con información actual
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: currentTheme.appBarColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Navegación Bíblica',
                        style: TextStyle(
                          color: currentTheme.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 24),
                        color: currentTheme.textColor,
                        onPressed: () {
                          _scaffoldKey.currentState?.closeEndDrawer();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Información actual
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: currentTheme.backgroundColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Leyendo actualmente:',
                          style: TextStyle(
                            color: currentTheme.textColor.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${currentBook?.modernName} ${currentChapter?.chapter}',
                          style: TextStyle(
                            color: currentTheme.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Versión: ${currentVersion?.version}',
                          style: TextStyle(
                            color: currentTheme.textColor.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selección de Versión de la Biblia
                    // _buildVersionSelection(currentTheme),

                    SizedBox(height: 24),

                    // Selección de Libro
                    // _buildBookSelection(currentTheme),

                    SizedBox(height: 24),

                    // Selección de Capítulo
                    // _buildChapterSelection(currentTheme),

                    SizedBox(height: 24),

                    // Acciones rápidas
                    // _buildQuickActions(currentTheme),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Desliza hacia abajo para cerrar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: currentTheme.textColor.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Método para ir al siguiente capítulo
  Future<void> _goToPreviousChapter(String chapterNumber) async {
    setState(() {
      isPlaying = false;
    });
    flutterTts.stop;
    LoadingService().showLoading(context);
    if (currentChapter!.chapter > 1) {
      setState(() {
        currentChapter = allChapters.firstWhere((chapter) =>
            chapter.chapter.toString() == chapterNumber.toString());
        verses = currentChapter!.verses!;
        verses.sort((a, b) {
          // Convertir a números si son strings (ejemplo: "1" -> 1)
          final verseA = a.verse;
          final verseB = b.verse;

          return verseA.compareTo(verseB); // Orden ascendente
        });
      });
      await PreferencesManager().setChapterSelected(chapterNumber);
    } else if (currentBook!.numberBook > 1) {
      // Ir al último capítulo del libro anterior
      final prevBook = currentVersion!.books
          .firstWhere((b) => b.numberBook == currentBook!.numberBook - 1);
      setState(() {
        // actualizo libro actual con el anterior
        currentBook = prevBook;
      });
      await PreferencesManager().setBookSelected(prevBook.id);

      /// consultamos los capítulos con sus versículos del libro anterior y le indicamos
      /// que es el primer capítulo del libro que se esta abandonando
      await loadChapters(prevBook, true);

      // actualizamos el storage del capítulo seleccionado
      await PreferencesManager()
          .setChapterSelected(currentChapter!.chapter.toString());
    }

    // cargamos los resaltados
    await _loadHighlights();

    LoadingService().hideLoading();

    // validamos si se habilita o deshabilita el botón anterior y el botón siguiente
    validateNextAndPrevious();
  }

  /// Método para regresar al capítulo anterior
  Future<void> _goToNextChapter(String chapterNumber) async {
    setState(() {
      isPlaying = false;
    });
    flutterTts.stop;
    LoadingService().showLoading(context);
    if (currentChapter!.chapter < currentBook!.chapters) {
      setState(() {
        currentChapter = allChapters.firstWhere((chapter) =>
            chapter.chapter.toString() == chapterNumber.toString());
        verses = currentChapter!.verses!;
        verses.sort((a, b) {
          // Convertir a números si son strings (ejemplo: "1" -> 1)
          final verseA = a.verse;
          final verseB = b.verse;

          return verseA.compareTo(verseB); // Orden ascendente
        });
      });
      await PreferencesManager().setChapterSelected(chapterNumber);
    } else if (currentBook!.numberBook < currentVersion!.books.length) {
      // Ir al primer capítulo del siguiente libro
      final nextBook = currentVersion!.books
          .firstWhere((b) => b.numberBook == currentBook!.numberBook + 1);
      setState(() {
        // actualizo libro actual con el anterior
        currentBook = nextBook;
      });

      // actualizamos el storage de libro seleccionado
      await PreferencesManager().setBookSelected(nextBook.id);

      // removemos el storage de capítulo seleccionado
      await PreferencesManager().clearOne('chapterSelected');

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
      });

      //si no es el el primer capítulo del libro
      if (!firstChapter) {
        // verificamos si hay capítulo en cache
        final chapterNumber = await PreferencesManager().getChapterSelected();
        if (chapterNumber != null) {
          setState(() {
            currentChapter = allChapters
                .firstWhere((ch) => ch.chapter.toString() == chapterNumber);
          });
        } else {
          setState(() => currentChapter = allChapters.first);
        }
      } else {
        setState(() => currentChapter = allChapters.last);
      }

      if (currentChapter != null) {
        setState(() {
          verses = currentChapter!.verses!
              .map<VerseModel>((verse) => VerseModel.fromJson(verse.toJson()))
              .toList();
          //ordenamos los versículos de menor a mayor
          verses.sort((a, b) {
            final verseA = a.verse;
            final verseB = b.verse;

            return verseA.compareTo(verseB); // Orden ascendente
          });
        });
      }
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

  // Variable para almacenar el ID del versículo marcado por scroll
  loadVersionAndChapter(InputDataSearchModel data) async {
    final bibleVersions = Provider.of<CatalogueProvider>(context, listen: false)
        .allBibleVersion
        .map((v) => ModelData(value: v.id, label: v.version))
        .toList();
    //version seleccionada
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
        if (kDebugMode) {
          print(responseChapterByBook.error);
        }
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

        verses = currentChapter!.verses!;
      });
      setState(() {
        currentBook = currentBook!.copyWith(
          chapters: allChapters.length - 1,
        );
        // Mover el scroll al versículo de inicio si está presente
        if (verses.isNotEmpty) {
          final startIndex =
              verses.indexWhere((v) => v.id == data.startVerseId);
          if (startIndex != -1) {
            setState(() => scrollToVerse = startIndex);
            scrollToKeyVerse(startIndex); // 🔥 Usar la nueva función
          }
        }
      });
      await PreferencesManager().setSelectedBibleVersion(lastVersionsSelected!);
      // actualizamos el storage de libro seleccionado
      await PreferencesManager().setBookSelected(currentBook!.id);
      // actualizamos el storage del capítulo seleccionado
      await PreferencesManager()
          .setChapterSelected(currentChapter!.chapter.toString());
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

// Reemplaza la función de scroll en loadVersionAndChapter
  void scrollToKeyVerse(int startIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _verseKeys[startIndex];
      if (key?.currentContext != null && scrollController.hasClients) {
        // 🔥 Usar Scrollable.ensureVisible para scroll preciso
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
          alignment: 0.1, // El versículo aparece al 10% desde arriba
        ).then((_) {
          // Permitir scroll manual nuevamente después de un delay
          setState(() => _isManualScroll = false);
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() => _isManualScroll = true);
            }
          });
        });
      } else {
        // Fallback: cálculo aproximado
        _scrollToVerseFallback(startIndex);
      }
    });
  }

// Método fallback por si las keys no funcionan
  void _scrollToVerseFallback(int startIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_selectableTextKey.currentContext != null &&
          scrollController.hasClients) {
        try {
          // Calcular altura aproximada basada en texto acumulado
          double estimatedHeight = 0.0;

          for (int i = 0; i < startIndex; i++) {
            final verse = verses[i];
            // Estimación más precisa basada en longitud del texto
            final textLength = "${verse.verse} ${verse.text}".length;
            final lineHeight =
                fontSizeVerse * 1.5; // Altura aproximada por línea
            final lines =
                (textLength / 50).ceil(); // Aprox. 50 caracteres por línea
            estimatedHeight += lines * lineHeight + 16; // +16 por padding
          }

          // Ajustar con márgenes
          estimatedHeight += 40.0; // Widget inicial del ListView

          await scrollController.animateTo(
            estimatedHeight.clamp(
                0.0, scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
          );
        } catch (error) {
          // Fallback más simple
          final itemHeight = 80.0; // Altura estimada por versículo
          await scrollController.animateTo(
            (startIndex * itemHeight)
                .clamp(0.0, scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
          );
        }
      }
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

  loadVideoByChapter(String id) async {
    final responseVideo = await getVideoByChapter(id);
    if (responseVideo.error != null) {
      await showCustomDialogWithAction(context,
          message: responseVideo.error!,
          dialogType: DialogTypeAction.error,
          buttonOk: "re intentar",
          textButton: "Volver",
          actionCallbackOk: () {},
          actionCallback: () {});
      return;
    }

    setState(() {
      video = Video.fromJson(responseVideo.data);
    });
  }

  void openModal() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return Dialog(
          backgroundColor: currentTheme.backgroundColor,
          insetPadding: EdgeInsets.zero,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SearchBibleWidget(
              currentVersion: currentVersion!,
              currentBook: currentBook!,
              currentChapter: currentChapter!,
              onActionBook: (InputDataSearchModel data) async {
                await loadVersionAndChapter(data);
              },
              onActionTabText: (InputDataSearchModel data) async {
                await loadVersionAndChapter(data);
              },
              onActionTheme: (InputDataSearchModel data) async {
                await loadVersionAndChapter(data);
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation.drive(
              CurveTween(curve: Curves.fastOutSlowIn)), // ← Solución segura
          child: child,
        );
      },
    );
  }

// Método para construir el drawer de navegación
  Widget _buildNavigationDrawer(BibleTheme currentTheme) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.75, // Ancho personalizado
      backgroundColor: currentTheme.backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // Header del drawer
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
              decoration: BoxDecoration(
                color: currentTheme.appBarColor,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Navegación',
                        style: StylesApp(context).textStyleBody18.copyWith(
                              color: currentTheme.buttonTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 24),
                        color: currentTheme.buttonTextColor,
                        onPressed: () {
                          _scaffoldKey.currentState?.closeEndDrawer();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                // padding: EdgeInsets.all(16),
                children: [
                  BibleHeaderWidget(
                    showButton: false,
                    topPosition: null,
                    bottomPosition: 10.0,
                    onSearchBible: () {
                      openModal();
                    },
                    versionName:
                        currentVersion != null ? currentVersion!.version : '',
                    title: currentBook != null ? currentBook!.modernName : '',
                    showIconVideo: video.url.isNotEmpty,
                    chapter: currentChapter != null
                        ? '${currentChapter!.chapter}'
                        : '',
                    onVideoCollection: () async {
                      await _showVideoDialog();
                    },
                    onBack: () async {
                      Navigator.pushNamed(
                        context,
                        '/layoutPage',
                        arguments: {'selectedIndex': 0},
                      );
                    },
                    onVersionTap: () async {
                      await _changeBibleVersion();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerIndicator(BibleTheme currentTheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: currentTheme.buttonColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: currentTheme.buttonColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.swipe_left,
            color: currentTheme.buttonColor,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Desliza desde la derecha para navegar',
            style: TextStyle(
              color: currentTheme.buttonColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Método para mostrar el diálogo de video
  Future<void> _showVideoDialog() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height * 0.50,
              maxHeight: MediaQuery.sizeOf(context).height * 0.50,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: BoxConstraints(minHeight: 213),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: (video.url.contains('youtube.com') ||
                              video.url.contains('youtu.be'))
                          ? PlayerYoutubeWidget(videoUrl: video.url)
                          : PlayerNoYoutube(
                              url: "${GraphQLConfig.urlServidor}${video.url}"),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Método para cambiar la versión de la Biblia
  Future<void> _changeBibleVersion() async {
    final bibleVersions = Provider.of<CatalogueProvider>(
      context,
      listen: false,
    )
        .allBibleVersion
        .map(
          (v) => ModelData(value: v.id, label: v.version),
        )
        .toList();

    final selectedVersion = await BibleVersionSelector.show(
      context: context,
      versions: bibleVersions,
      preferenceKey: preferenceKey,
      savedId: lastVersionsSelected,
    );

    if (selectedVersion != null) {
      if (kDebugMode) {
        print('Versión seleccionada: ${selectedVersion.label}');
      }

      // Actualizar la versión seleccionada
      setState(() => lastVersionsSelected = selectedVersion.value);

      // Limpiar cache y guardar nueva versión
      await PreferencesManager().clearOne('bookSelected');
      await PreferencesManager().clearOne('chapterSelected');
      await PreferencesManager().setSelectedBibleVersion(lastVersionsSelected!);

      // Recargar datos con la nueva versión
      _initDataLoad();
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
      final verseNumber = int.parse(verse.id!);
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
