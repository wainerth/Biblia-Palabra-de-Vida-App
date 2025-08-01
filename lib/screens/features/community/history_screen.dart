import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final PageController _controllerPage = PageController();

  double fontSizeText = 16.sp;
  double isPage = 0;
  List<History> stories = [];
  bool isLoading = true;
  String? errorMessage;
  CourseDetail? course;
  Level? level;
  Stage? stage;
  int _selectedButtonIndex = 1;
  String levelId = '';
  String sectionId = '';
  String courseId = '';
  bool finalStory = false;
  int storyIndex = 0;
  // variables para TTS
  late FlutterTts flutterTts;
  bool isPlaying = false;
  double _speechRate = 0.5; // Velocidad por defecto

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initTTS(); // Inicializar TTS
      _generateData(context);
      // _controllerPage.addListener(_pageListener);
      getFontSizeText();
    });
  }

  getFontSizeText() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    double? fontSize = sharedPreferences.getDouble('fontSizeText');
    if (fontSize != null) {
      setState(() {
        fontSizeText = fontSize;
      });
    } else {
      setState(() {
        fontSizeText = 16.sp;
      });
    }
  }

  Future<void> _generateData(BuildContext context) async {
    setState(() {
      errorMessage = null;
    });
    LoadingService().showLoading(context);

    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      try {
        levelId = args['levelId'];
        sectionId = args['sectionId'];
        courseId = args['courseId'];
        setState(() {});

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final LoginUser? userData = userProvider.currentUser;
        final ResponseData responseCourse =
            await loadOneCourse(userData!.userId, courseId);
        if (responseCourse.error != null) {
          errorMessage = responseCourse.error;
        }
        course = CourseDetail.fromJson(removeTypename(responseCourse.data));

        // obtenemos sección
        final ResponseData stageResponse = await loadStageById(sectionId);

        if (stageResponse.error != null) {
          errorMessage = stageResponse.error;
        }
        stage = Stage.fromJson(stageResponse.data);
        // obtenemos el nivel
        final levelResponse = await loadOneLevel(levelId);

        if (levelResponse.error != null) {
          errorMessage = levelResponse.error;
        }
        level = Level.fromJson(removeTypename(levelResponse.data));

        // obtenemos las historias
        final ResponseData historyResponse = await loadStoriesByLevel(levelId);

        if (historyResponse.error != null) {
          errorMessage = historyResponse.error;
        }
        setState(() {
          stories = historyResponse.data
              .map((story) => History.fromJson(removeTypename(story)))
              .cast<History>()
              .toList();

          stories.insert(
            0,
            History(
                id: "122",
                text:
                    "esta es la historia que tendrá la prueba {(Juan 1:4-5 /RVR95)} para validar si se puede levantar una modal {(Apocalipsis 1:4-5 /RVR05)}",
                orderCard: 1,
                level: IntermediateLevel(
                    levelNumber: 1, unLockLevel: true, countLevelNumber: 1),
                img: Img(urlImg: "images/achievement/expA.png"),
                audio: Audio(url: "url"),
                video: Video(url: " url"),
                status: 1),
          );
        });
        _togglePlayPause(stories[0]);
      } catch (e) {
        errorMessage = "An error occurred: $e";
      } finally {
        LoadingService().hideLoading();
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    flutterTts.stop(); // Detener TTS al salir
    _controllerPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (isLoading) ...{
              Container()
            } else ...{
              if (errorMessage != null) ...{
                BuildErrorWidget(
                  errorMessage: errorMessage!,
                  onRetry: () async => _generateData(context),
                  onBack: () => Navigator.pop(context),
                )
              } else ...{
                HeaderNotDetailsStageWidget(
                  title: "Conoce el ${course?.titleName}",
                  stage: stage != null ? stage!.id : '',
                  subtitle: stage != null ? stage!.sectionName : '',
                  details: stage,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  padding: EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: StyleColor.orange,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    " ${level != null ? level!.name : ''} - Paso ${(isPage + 1).floorToDouble().toStringAsFixed(0)}",
                    style: StylesApp(context).textStyleBody5,
                  ),
                ),
                Expanded(
                  child: finalStory
                      ? SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 250,
                                width: 250,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 221, 193, 148),
                                    borderRadius: BorderRadius.circular(200)),
                                child: Stack(children: [
                                  Center(
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(200)),
                                    ),
                                  ),
                                  Center(
                                    child: Image.asset(
                                      "assets/comingSoon.gif", // GIF animado
                                      height: 200,
                                      width: 200,
                                    ),
                                  ),
                                ]),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "¡Felicidades! Has llegado al final de la historia.",
                                    style: StylesApp(context)
                                        .textStyleBody18
                                        .copyWith(color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 10,
                                  children: [
                                    ButtonThemeWidget(
                                      textCenter: true,
                                      text: "Volver a Iniciar la Historia",
                                      buttonStyle:
                                          StylesApp(context).btnWidgetSmall,
                                      height: null,
                                      width: 180,
                                      onPressed: () async {
                                        setState(() {
                                          finalStory = false;
                                          isPage = 0;
                                          isPlaying = false;
                                        });
                                        await flutterTts.stop();
                                      },
                                    ),
                                    ButtonThemeWidget(
                                      textCenter: true,
                                      text: "Continuar con las Preguntas",
                                      buttonStyle:
                                          StylesApp(context).btnWidgetSmall,
                                      height: null,
                                      width: 180,
                                      onPressed: () {
                                        Navigator.popAndPushNamed(
                                          context,
                                          "/questionPage",
                                          arguments: {
                                            'courseId': courseId,
                                            "levelId": levelId,
                                            "sectionId": sectionId
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : PageView.builder(
                          controller: _controllerPage,
                          onPageChanged: (index) async {
                            if (index > stories.length - 1) {
                              setState(() {
                                finalStory = true;
                              });
                            } else {
                              setState(() {
                                isPage = index.toDouble();
                              });
                            }
                            setState(() {
                              isPlaying = false;
                            });
                            await flutterTts.stop();
                            _togglePlayPause(stories[index]);
                          },
                          itemCount: stories.length + 1,
                          itemBuilder: (context, index) {
                            if (index < stories.length) {
                              final story = stories[index];
                              // Crear un nuevo ScrollController *dentro* del itemBuilder
                              final ScrollController pageScrollController =
                                  ScrollController();
                              return _buildItemPageView(
                                  story, context, pageScrollController);
                            }
                            return Container();
                          },
                        ),
                ),
                SizedBox(
                  height: 18.0,
                ),
                if (!finalStory) ...{
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 9),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Slider(
                            activeColor: Colors.blueGrey,
                            inactiveColor: Colors.grey,
                            thumbColor: StyleColor.turquoise,
                            min: 10.0,
                            max: 20.0,
                            value: fontSizeText,
                            onChanged: (value) async {
                              final sharedPreferences =
                                  await SharedPreferences.getInstance();
                              await sharedPreferences.setDouble(
                                  'fontSizeText', value);
                              setState(() {
                                fontSizeText = value;
                              });
                            },
                            secondaryTrackValue: 20.0,
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Text(
                            "Aa",
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: Colors.black,
                                ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    constraints: BoxConstraints(minHeight: 35),
                    decoration: BoxDecoration(
                        color: Color(0XFF858585),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 0,
                          child: SizedBox(
                            width: 35,
                            height: 35.0,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              iconSize: 35.0,
                              onPressed: () {
                                _controllerPage.animateToPage(
                                  0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                                setState(() {
                                  isPage = 0;
                                });
                              },
                              icon: Icon(
                                Icons.skip_previous_outlined,
                                color: Colors.white,
                                size: 35.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 0,
                                child: SizedBox(
                                  width: 45,
                                  height: 45.0,
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    iconSize: 45.0,
                                    onPressed: isPage == 0
                                        ? null
                                        : () async {
                                            _controllerPage.previousPage(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeIn,
                                            );
                                            setState(() {
                                              isPage = _controllerPage.page!;
                                              storyIndex -= 1;
                                              isPlaying = false;
                                            });
                                            await flutterTts.stop();
                                            _togglePlayPause(
                                                stories[storyIndex]);
                                          },
                                    icon: Icon(
                                      Icons.arrow_left_sharp,
                                      color: Colors.white,
                                      size: 45.0,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(6.0),
                                  minHeight: 14.0,
                                  value: isPage / (stories.length - 1),
                                  backgroundColor: Color(0xFFC4C4C4),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0XFFF27728),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: SizedBox(
                                  width: 45.0,
                                  height: 45.0,
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    iconSize: 45.0,
                                    onPressed: () async {
                                      _controllerPage.nextPage(
                                        duration: Duration(milliseconds: 350),
                                        curve: Curves.easeIn,
                                      );

                                      if (isPage < stories.length - 1) {
                                        setState(() {
                                          isPage = _controllerPage.page! + 1;
                                          storyIndex += 1;
                                          isPlaying = false;
                                        });
                                        await flutterTts.stop();
                                        _togglePlayPause(stories[storyIndex]);
                                      } else {
                                        setState(
                                          () {
                                            finalStory = true;
                                          },
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      Icons.arrow_right_sharp,
                                      color: Colors.white,
                                      size: 45.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: SizedBox(
                            width: 30,
                            height: 30.0,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              iconSize: 25.0,
                              onPressed: () async {
                                setState(
                                  () {
                                    isPlaying = false;
                                    finalStory = true;
                                  },
                                );
                                await flutterTts.stop();
                              },
                              icon: Icon(
                                Icons.skip_next_outlined,
                                color: Colors.white,
                                size: 25.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                },
                SizedBox(
                  height: 10.0,
                )
              }
            }
          ],
        ),
      ),
    );
  }

  Widget _buildItemPageView(
      History story, BuildContext context, ScrollController scrollController) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 226.0, maxHeight: 226.0),
            child: Stack(
              // Usamos un Stack para superponer los botones a la imagen
              children: [
                Image.network(
                  GraphQLConfig.urlServidor + story.img.urlImg,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/placeholder.png',
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ); // Imagen de marcador de posición
                  }, // Ajusta la imagen al contenedor
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    offset: Offset(0.0, 4.0),
                    blurStyle: BlurStyle.outer),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedButtonIndex = 1;
                    });
                  },
                  icon: Icon(Icons.image),
                  color: _selectedButtonIndex == 1
                      ? StyleColor.turquoise
                      : StyleColor.twilightBlue,
                ),
                if (story.audio != null && story.audio!.url != '')
                  IconButton(
                    onPressed: () {
                      // Lógica para reproducir audio
                      setState(() {
                        _selectedButtonIndex = 2;
                      });
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          constraints:
                                              BoxConstraints(minHeight: 213),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.transparent),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 50,
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            child: AudioPlayerWidget(
                                              showImage: false,
                                              inactiveColor: StyleColor.orange,
                                              backgroundColor: Colors.white,
                                              controlsColor:
                                                  StyleColor.turquoise,
                                              pathUrl: story.audio == null
                                                  ? ""
                                                  : story.audio!.url,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pop(); // Cierra el diálogo
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withValues(
                                                  alpha:
                                                      0.7), // Fondo semitransparente para el botón
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
                                ],
                              ),
                            );
                          });
                    },
                    icon: Icon(Icons.audiotrack),
                    color: _selectedButtonIndex == 2
                        ? StyleColor.turquoise
                        : StyleColor.twilightBlue,
                  ),
                if (story.video != null && story.video!.url != '')
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        _selectedButtonIndex = 3;
                      });
                      await SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown,
                      ]);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: Stack(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    constraints: BoxConstraints(minHeight: 213),
                                    // height: 213,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: story.video != null &&
                                              (story.video!.url.contains(
                                                      'youtube.com') ||
                                                  story.video!.url
                                                      .contains('youtu.be'))
                                          ? PlayerYoutubeWidget(
                                              videoUrl: story.video!.url)
                                          : PlayerNoYoutube(
                                              url: story.video!.url),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  // Posiciona el botón de cerrar
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pop(); // Cierra el diálogo
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withValues(
                                            alpha:
                                                0.7), // Fondo semitransparente para el botón
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
                              ]),
                            );
                          });
                    },
                    icon: Icon(Icons.videocam),
                    color: _selectedButtonIndex == 3
                        ? StyleColor.turquoise
                        : StyleColor.twilightBlue,
                  ),
                // lector de la historia
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: StyleColor.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Slider para control de velocidad
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  // Botón de stop
                                  IconButton(
                                    icon: Icon(Icons.stop, size: 24),
                                    color: StyleColor.turquoise,
                                    onPressed: () async {
                                      await flutterTts.stop();
                                      setState(() {
                                        isPlaying = false;
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
                                      color: StyleColor.turquoise,
                                      onPressed: () {
                                        _togglePlayPause(story);
                                      }),
                                  Icon(Icons.speed,
                                      size: 18, color: StyleColor.black),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Slider(
                                      value: _speechRate,
                                      min: 0.1,
                                      max: 1.0,
                                      divisions: 9,
                                      label: _getSpeedLabel(_speechRate),
                                      activeColor: StyleColor.turquoise,
                                      inactiveColor: StyleColor.turquoise
                                          .withValues(alpha: 0.3),
                                      onChanged: (value) async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        setState(() {
                                          _speechRate = value;
                                        });
                                        await flutterTts.setSpeechRate(value);
                                        await prefs.setDouble(
                                            'tts_speech_rate', value);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _getSpeedLabel(_speechRate),
                                    style: TextStyle(
                                      color: StyleColor.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Velocidad: ${(_speechRate * 100).round()}%',
                                style: TextStyle(
                                  color: StyleColor.black,
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
              ],
            ),
          ),
          SizedBox(
            height: 7.0,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Sombra
                  ),
                ],
              ),
              height: 248.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 14.0, vertical: 15.0),
                  constraints: BoxConstraints(
                    minHeight: 73.0,
                    maxHeight: 230.0,
                  ),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    thickness: 6.0,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 21.0,
                          ),
                          _buildRichTextWithLinks(story.text, context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
      setState(() {
        isPlaying = false;
        // currentPlayingVerseIndex = null;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isPlaying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en TTS: $msg")),
      );
    });
  }

  String _getSpeedLabel(double speed) {
    if (speed <= 0.4) return 'Lento';
    if (speed <= 0.6) return 'Normal';
    return 'Rápido';
  }

  Future<void> _togglePlayPause(story) async {
    if (isPlaying) {
      await flutterTts.pause();
      setState(() => isPlaying = false);
    } else {
      await flutterTts.awaitSpeakCompletion(true);
      // Eliminar los textos que están dentro de {( ... )} incluyendo desde / hasta )}
      // Ejemplo: {(Juan 1:4-5 /RVR95)} -> elimina " /RVR95" y deja "Juan 1:4-5"
      String cleanText = story.text.replaceAllMapped(
        RegExp(r'\{\(([^\/\)]+)(?:\/[^\)]*)?\)\}'),
        (Match match) => (match.group(1) ?? '').trim(),
      );
      await flutterTts.speak(cleanText);
      setState(() => isPlaying = true);
    }
  }

  _buildRichTextWithLinks(String text, BuildContext context) {
    // Busca las partes de la cadena que coincidan con {( )} y las resalta.
    final curlyRegExp = RegExp(r'\{\((.*?)\)\}'); // Coincide con {( ... )}

    final matches = curlyRegExp.allMatches(text).toList();

    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      // Texto antes del match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: TextStyle(
            color: Colors.black,
            fontSize: fontSizeText,
          ),
        ));
      }
      // Texto del match (enlace)
      final matchedText = match.group(0)!;
      spans.add(
        TextSpan(
          text: matchedText.replaceFirstMapped(
            RegExp(r'\/.*(?=\)\})'),
            (m) => '', // Oculta visualmente lo que sigue después de /
          ),
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
            fontSize: fontSizeText,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              print(matchedText);
              _buildModalShowDetailLink(matchedText);
              // abrirá una modal
            },
        ),
      );
      lastMatchEnd = match.end;
    }
    // Texto restante después del último match
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSizeText,
        ),
      ));
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: StylesApp(context).textStyleBody5.copyWith(
              color: Colors.black,
              fontSize: fontSizeText,
            ),
      ),
    );
  }

  void _buildModalShowDetailLink(String? text) {
    if (text == null) return;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                "Detalle del enlace",
                style: StylesApp(context).textStyleBody18.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 16),
              Text(
                text,
                style: StylesApp(context).textStyleBody5.copyWith(
                      color: Colors.blue,
                      fontSize: fontSizeText,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: StyleColor.turquoise,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 44),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cerrar",
                  style: StylesApp(context).textStyleBody5.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
