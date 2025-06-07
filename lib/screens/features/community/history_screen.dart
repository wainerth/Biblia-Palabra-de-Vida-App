import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  CourseModel? course;
  Level? level;
  Stage? stage;
  bool _isPlayingAudio = false;
  bool _isPlayingVideo = false;
  int _selectedButtonIndex = 1;
  String levelId = '';
  String sectionId = '';
  String courseId = '';
  bool finalStory = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        course = CourseModel.fromJson(removeTypename(responseCourse.data));

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
        });
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
    // _controllerPage.removeListener(_pageListener);
    _controllerPage.dispose();
    bool _isPlayingAudio = false;
    bool _isPlayingVideo = false;
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
                  title: "Conoce el ${course?.title}",
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
                      ? Container(
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
                                      onPressed: () {
                                        setState(() {
                                          finalStory = false;
                                          isPage = 0;
                                        });
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
                          onPageChanged: (index) {
                            if (index > stories.length - 1) {
                              setState(() {
                                finalStory = true;
                              });
                            } else {
                              setState(() {
                                isPage = index.toDouble();
                              });
                            }
                          },
                          itemCount: stories.length + 1,
                          itemBuilder: (context, index) {
                            if (index < stories.length) {
                              final story = stories[index];
                              // Crear un nuevo ScrollController *dentro* del itemBuilder
                              final ScrollController _pageScrollController =
                                  ScrollController();
                              return _buildItemPageView(
                                  story, context, _pageScrollController);
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
                                        : () {
                                            _controllerPage.previousPage(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeIn,
                                            );
                                            setState(() {
                                              isPage = _controllerPage.page!;
                                            });
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
                                    onPressed: () {
                                      _controllerPage.nextPage(
                                        duration: Duration(milliseconds: 350),
                                        curve: Curves.easeIn,
                                      );

                                      if (isPage < stories.length - 1) {
                                        setState(() {
                                          isPage = _controllerPage.page! + 1;
                                        });
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
                              onPressed: () {
                                setState(
                                  () {
                                    finalStory = true;
                                  },
                                );
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
                      _isPlayingVideo = false;
                      _isPlayingAudio = false;
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
                        _isPlayingVideo = false;
                        _isPlayingAudio = true;
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
                                        ? "reflexion2.mp3"
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
                                      color: Colors.grey.withOpacity(
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
                        _isPlayingVideo = true;
                        _isPlayingAudio = false;
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
                                              (story.video!.url
                                                      .contains('youtube.com') ||
                                                  story.video!.url
                                                      .contains('youtu.be'))
                                          ? PlayerYoutubeWidget(
                                              videoUrl: story.video!.url)
                                          : playerNoYoutube(
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
                                        color: Colors.grey.withOpacity(
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
                          Text(
                            story.text,
                            textAlign: TextAlign.left,
                            style: StylesApp(context).textStyleBody5.copyWith(
                                  color: Colors.black,
                                  fontSize: fontSizeText,
                                ),
                          ),
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
}
