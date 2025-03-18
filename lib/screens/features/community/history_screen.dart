import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateData(context);
    });
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
            await loadOneCourse(userData!.user.id, courseId);
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
                    "Paso ${(isPage + 1).floorToDouble().toStringAsFixed(0)} ${level != null ? level!.name : ''}",
                    style: StylesApp(context).textStyleBody5,
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controllerPage,
                    onPageChanged: (index) {
                      setState(() {
                        isPage = index.toDouble();
                      });
                    },
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      final story = stories[index];
                      // Crear un nuevo ScrollController *dentro* del itemBuilder
                      final ScrollController _pageScrollController =
                          ScrollController();
                      return _buildItemPageView(
                          story, context, _pageScrollController);
                    },
                  ),
                ),
                SizedBox(
                  height: 18.0,
                ),
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
                          min: 10.sp,
                          max: 20.sp,
                          value: fontSizeText,
                          onChanged: (value) {
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
                          style: StylesApp(context).textStyleBody16.copyWith(
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
                                      Navigator.popAndPushNamed(
                                        context,
                                        "/questionPage",
                                        arguments: {
                                          'courseId': courseId,
                                          "levelId": levelId,
                                          "sectionId": sectionId
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
                if (_isPlayingAudio) // Mostrar reproductor de audio
                  Positioned(
                    bottom: 50,
                    left: 0,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.transparent),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 50,
                      width: MediaQuery.sizeOf(context).width,
                      child: AudioPlayerWidget(
                        showImage: false,
                        inactiveColor: StyleColor.orange,
                        backgroundColor: Colors.white,
                        controlsColor: StyleColor.turquoise,
                        pathUrl: "reflexion2.mp3",
                      ),
                    ),
                  ),
                if (_isPlayingVideo) // Mostrar reproductor de video
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        constraints: BoxConstraints(minHeight: 213),
                        // height: 213,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: story.videoUrl != null &&
                                  (story.videoUrl!.contains('youtube.com') ||
                                      story.videoUrl!.contains('youtu.be'))
                              ? PlayerYoutubeWidget(
                                  videoUrl: story.videoUrl ?? '')
                              : playerNoYoutube(
                                  url:
                                      'https://videos.pexels.com/video-files/20000940/20000940-hd_1080_1920_30fps.mp4'),
                        ),
                      ),
                    ),
                  ),

                // SizedBox(
                //   height: 7.0,
                // ),
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
                    // Lógica para ver imagen (siempre habilitado)
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
                IconButton(
                  onPressed: () {
                    // Lógica para reproducir audio
                    setState(() {
                      _selectedButtonIndex = 2;
                      _isPlayingVideo = false;
                      _isPlayingAudio = true;
                    });
                  },
                  // story.audioUrl != null
                  //     ? () {
                  // // Lógica para reproducir audio
                  // setState(() {
                  //   _isPlayingVideo = false;
                  //   _isPlayingAudio = true;
                  // });
                  //       }
                  //     : null, // Deshabilitado si no hay URL de audio
                  icon: Icon(Icons.audiotrack),
                  color: _selectedButtonIndex == 2
                      ? StyleColor.turquoise
                      : StyleColor.twilightBlue,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedButtonIndex = 3;
                      _isPlayingVideo = true;
                      _isPlayingAudio = false;
                    });
                  },

                  // story.videoUrl != null
                  //     ? () {
                  // setState(() {
                  //   _isPlayingVideo = true;
                  //   _isPlayingAudio = false;
                  // });
                  //       }
                  //     : null, // Deshabilitado si no hay URL de video
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
