import 'dart:async';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  late final UserProvider userProvider;
  CourseModel? course;
  Stage? stage;
  List<Level> levels = [];
  List<List<Level>> gruposDeNiveles = [];
  late ScrollController scrollController;
  final _isVisible = ValueNotifier<bool>(true);
  Timer? _timer;
  int _selectedIndex = 2;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // int _selectedIndex = 0;
  final List<String> imagePaths = [
    'assets/mapa1.png',
    'assets/mapa2.png',
    'assets/mapa3.png',
  ];
  bool isLoading = true;
  String? errorMessage;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      scrollController = ScrollController();
      _generateData(context);
      await _loadMutePreference();
      if (!isMuted) {
        await playAudio();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    stopAudio();
    _audioPlayerDisposed = true;
    audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> playAudio() async {
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.setVolume(0.5);
    await audioPlayer.play(AssetSource('mar-aves.mp3'));
  }

  bool _audioPlayerDisposed = false;

  Future<void> stopAudio() async {
    if (!_audioPlayerDisposed) {
      await audioPlayer.stop();
    }
  }

  Future<void> muteAudio() async {
    setState(() {
      isMuted = !isMuted;
    });
    _saveMutePreference();

    if (isMuted) {
      await audioPlayer.setVolume(0.0); // Restaura el volumen
    } else {
      await audioPlayer.setVolume(1.0); // Silencia el audio
    }
  }

  _loadMutePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isMuted = prefs.getBool('isMuted') ?? false;
    });
  }

  _saveMutePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isMuted', isMuted);
  }

  // función que hace scroll en la pantalla
  onScrollPosition() {
    final int lastUnlockedIndex = gruposDeNiveles.lastIndexWhere(
      (grupo) => grupo.any((level) => level.unLockLevel == true),
    );
    if (lastUnlockedIndex != -1) {
      String? lastLockedId = gruposDeNiveles[lastUnlockedIndex]
          .lastWhere((level) => level.unLockLevel == true,
              orElse: () => Level(
                    id: '',
                    name: '',
                    unLockLevel: false,
                    color: '',
                    section: Section(sectionName: ''),
                    img: Img(urlImg: ''),
                    score: 0,
                    levelScore: 0,
                  ))
          .id;

      scrollController.animateTo(
        int.parse(lastLockedId) *
            StylesApp(context)
                .sizeContainerLevel
                .height, //50.0, // Ajusta según el tamaño del nivel
        duration: Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _generateData(BuildContext context) async {
    LoadingService().showLoading(context);
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      try {
        final String courseId = args['courseId'];
        final String sectionId = args['sectionId'];

        setState(() {});
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final LoginUser? userData = userProvider.currentUser;
        // obtenemos curso
        final ResponseData courseResponse =
            await loadOneCourse(userData?.userId, courseId);
        if (courseResponse.error != null) {
          errorMessage = courseResponse.error;
        }
        course = CourseModel.fromJson(courseResponse.data);
        // obtenemos sección
        final ResponseData stageResponse = await loadStageById(sectionId);

        if (stageResponse.error != null) {
          errorMessage = stageResponse.error;
        }
        stage = Stage.fromJson(stageResponse.data);
        // obtenemos los niveles
        final result = await loadLevelsByCourse(userData?.userId, sectionId);

        if (result.error != null) {
          errorMessage = result.error;
        } else {
          setState(() {
            levels = result.data
                .map((level) => Level.fromJson(removeTypename(level)))
                .cast<Level>()
                .toList();
            gruposDeNiveles = chunked(levels, 5);
          });
        }
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

// función que se encarga de navegar entre las opciones
  void _onItemTapped(int index) {
    if (index.toString() == _selectedIndex.toString()) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/layoutPage', (route) => false);

    // stopAudio();
    // audioPlayer.dispose();
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex.toString() == 0.toString()) {
      Navigator.pushNamed(context, '/layoutPage');
    } else if (index.toString() == 3.toString()) {
      Navigator.pushNamed(
        context,
        '/layoutPage1',
        arguments: {'selectedIndex': 2},
      );
    } else {
      Navigator.pushNamed(
        context,
        '/layoutPage1',
        arguments: {'selectedIndex': index},
      );
    }
  }

  List<List<T>> chunked<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    List coordATop = [0.0, 0.10, 0.31, 0.54, 0.76];

    List coordALeft = [0.20, 0.49, 0.65, 0.65, 0.64];

    List coordBTop = [0.0, 0.13, 0.31, 0.54, 0.76];
    List coordBLeft = [0.40, 0.17, 0.01, 0.03, 0.05];

    List coordATopBarco = [0.25, 0.35, 0.45, 0.48, 0.65, 0.75, 0.75, 0.85];
    List coordALeftBarco = [0.20, 0.10, -0.05, 0.35, 0.17, 0.35, 0.10, 0.25];

    List coordBTopBarco = [0.05, 0.25, 0.35, 0.45, 0.45, 0.60, 0.75, 0.85];
    List coordBLeftBarco = [0.90, 0.85, 0.65, 0.80, 0.52, 0.87, 0.50, 0.90];

    return PopScope(
      canPop:
          true, // Permite que la pantalla sea sacada de la pila de navegación
      onPopInvokedWithResult: (didPop, result) async {
        // No need to manually pop here; the system already handles the pop action.

        //  if (navigatorKey.currentState?.canPop() ?? false) {
        //   navigatorKey.currentState?.pop();
        //    // Evita que el WillPopScope haga su retroceso
        // }
      },
      child: Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              _showBottomNavigationBar();
            }
            return true;
          },
          child: SafeArea(
            child: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return Container(
                  decoration: BoxDecoration(
                    color: Color(0XFF12CBC4),
                  ),
                  height: MediaQuery.sizeOf(context).height,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: errorMessage != null
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      spacing: 0,
                      children: [
                        HeadScoreWidget(
                          onRoute: () {
                            Navigator.popAndPushNamed(context, '/profilePage');
                          },
                        ),
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
                            Stack(children: [
                              HeaderMapWidget(
                                title: course!.title,
                                subtitleStage: stage!.sectionName,
                                indexStage: stage!.orderCard,
                                onRouteBack: () {
                                  Navigator.popAndPushNamed(
                                      context, '/layoutPage1');
                                },
                                onShowInfoCourse: () {
                                  Navigator.popAndPushNamed(
                                      context, '/detailCoursePage',
                                      arguments: course!.id);
                                },
                                onShowInfoStage: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomModalWidget(
                                        title: stage!.sectionName,
                                        content: stage!.introduction,
                                        buttonText: 'Aceptar',
                                        id: stage!.id,
                                        itemCount: stage!.levelCount,
                                        itemsCompleted:
                                            stage!.levelCompletedCount,
                                      );
                                    },
                                  );
                                },
                                onScroller: onScrollPosition,
                              ),
                              Positioned(
                                top: 0,
                                right: 30,
                                child: IconButton(
                                  iconSize: 25,
                                  icon: Icon(
                                    isMuted
                                        ? Icons.volume_off
                                        : Icons.volume_up,
                                    color: isMuted ? Colors.grey : Colors.white,
                                  ),
                                  onPressed: () async {
                                    await muteAudio();
                                    if (isMuted) {
                                      stopAudio();
                                    } else {
                                      playAudio();
                                    }
                                  },
                                ),
                              )
                            ]),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height,
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: gruposDeNiveles
                                    .length, // Dividimos por 4 para obtener el número de grupos de niveles
                                itemBuilder: (context, index) {
                                  List<Level> grupo = gruposDeNiveles[index];
                                  String image = index == 0
                                      ? imagePaths[0]
                                      : index % 2 == 0
                                          ? imagePaths[1]
                                          : imagePaths[2];
                                  return Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Container(
                                            padding: index == 0
                                                ? EdgeInsets.only(top: 20)
                                                : EdgeInsets.only(top: 0),
                                            constraints: BoxConstraints(
                                                minHeight:
                                                    MediaQuery.sizeOf(context)
                                                        .height),
                                            // decoration:BoxDecoration(
                                            //   border: Border.all(color: Colors.black, width: 1),
                                            // ),
                                            child: Image.asset(
                                              image,
                                              width: double.infinity,
                                              height: MediaQuery.sizeOf(context)
                                                  .height,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          if (index % 2 == 0) ...{
                                            for (var j = 0; j < 8; j++) ...{
                                              InfiniteAnimation(
                                                coordTop: coordATopBarco[j],
                                                coordLeft: coordALeftBarco[j],
                                                j: j,
                                                index: index,
                                              ),
                                            },
                                          } else ...{
                                            for (var j = 0; j < 8; j++) ...{
                                              InfiniteAnimation(
                                                coordTop: coordBTopBarco[j],
                                                coordLeft: coordBLeftBarco[j],
                                                j: j,
                                                index: index,
                                              ),
                                            }
                                          },
                                          for (var i = 0;
                                              i < grupo.length;
                                              i++) ...{
                                            Positioned(
                                              key: Key(grupo[i].id),
                                              top: index % 2 == 0
                                                  ? StylesApp(context)
                                                      .positionedLevels(
                                                          coordATop[i])
                                                      .dy
                                                  : StylesApp(context)
                                                      .positionedLevels(
                                                          coordBTop[i])
                                                      .dy, // Ajusta la posición vertical
                                              left: index % 2 == 0
                                                  ? StylesApp(context)
                                                      .positionedLevels(
                                                          coordALeft[i])
                                                      .dx
                                                  : StylesApp(context)
                                                      .positionedLevels(
                                                          coordBLeft[i])
                                                      .dx,
                                              child: GestureDetector(
                                                key: Key("$index-$i"),
                                                onTap: grupo[i].unLockLevel ==
                                                        false
                                                    ? null
                                                    : () {
                                                        stopAudio();
                                                        //aaaa
                                                        Navigator.pushNamed(
                                                          context,
                                                          '/historyPage',
                                                          arguments: {
                                                            'courseId':
                                                                course?.id,
                                                            'levelId':
                                                                grupo[i].id,
                                                            'sectionId':
                                                                stage!.id
                                                          },
                                                        );
                                                      },
                                                child: Container(
                                                  // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                                  constraints: BoxConstraints(
                                                    maxWidth: StylesApp(context)
                                                        .sizeContainerLevel
                                                        .width,
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: StarStatusWidget(
                                                          containerWidth:
                                                              StylesApp(context)
                                                                  .sizeContainerLevel
                                                                  .width,
                                                          levelScore: grupo[i]
                                                              .levelScore,
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            height: 30,
                                                          ),
                                                          Center(
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  width: StylesApp(
                                                                          context)
                                                                      .sizeContainer
                                                                      .width, // Ajusta el tamaño según tus necesidades
                                                                  height: StylesApp(
                                                                          context)
                                                                      .sizeContainer
                                                                      .height,
                                                                  decoration: BoxDecoration(
                                                                      color: Color(grupo[i].levelScore > 0 ? getColorItem(grupo[i].levelScore) : int.tryParse('0xFF${grupo[i].color}') ?? 0XFF000000),
                                                                      shape: BoxShape.circle,
                                                                      border: Border.all(
                                                                        color: grupo[i].levelScore >
                                                                                0
                                                                            ? Color(getColorItem(grupo[i].levelScore))
                                                                            : Color.fromARGB(
                                                                                100, // Opacidad: 50%
                                                                                int.parse('0xFF${grupo[i].color}'.substring(2), radix: 16),
                                                                                int.parse('0xFF${grupo[i].color}'.substring(4, 6), radix: 16),
                                                                                int.parse('0xFF${grupo[i].color}'.substring(6), radix: 16),
                                                                              ),
                                                                        width:
                                                                            1,
                                                                      ),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            color: grupo[i].levelScore > 0
                                                                                ? Color(getColorShadow(grupo[i].levelScore)).withValues(alpha: 0.5)
                                                                                : Colors.black.withValues(alpha: 0.5),
                                                                            offset: Offset(0, 8),
                                                                            blurStyle: BlurStyle.outer)
                                                                      ]),
                                                                  child: Center(
                                                                    child:
                                                                        Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      children: [
                                                                        if (grupo[i].unLockLevel ==
                                                                                true &&
                                                                            grupo[i].levelScore ==
                                                                                0) ...{
                                                                          AnimatedBuilder(
                                                                            animation:
                                                                                _animation,
                                                                            builder:
                                                                                (context, child) {
                                                                              return Container(
                                                                                width: StylesApp(context).sizeContainer.width + 10 * _animation.value,
                                                                                height: StylesApp(context).sizeContainer.height + 10 * _animation.value,
                                                                                decoration: BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  color: Colors.yellow.withValues(alpha: 0.5 * (1 - _animation.value)),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        },
                                                                        _buildItemLevel(
                                                                            context,
                                                                            grupo[i]),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                if (grupo[i]
                                                                        .unLockLevel ==
                                                                    false)
                                                                  Positioned
                                                                      .fill(
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: const Color(0xFFA9B8BE).withValues(
                                                                            alpha:
                                                                                0.9), // Ajusta la opacidad
                                                                      ),
                                                                      width: StylesApp(
                                                                              context)
                                                                          .sizeContainer
                                                                          .width,

                                                                      // color: Colors.black.withOpacity(
                                                                      //     0.5), // Ajusta la opacidad
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            textAlign: TextAlign
                                                                .center,
                                                            "${grupo[i].levelNumber} ${grupo[i].name}",
                                                            style: StylesApp(
                                                                    context)
                                                                .textStyNameNumber
                                                                .copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          },
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          }
                        }
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder<bool>(
          valueListenable: _isVisible,
          builder: (context, value, child) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: value ? kBottomNavigationBarHeight + 20 : 0,
              child: CustomBottomNavigationBarWidget(
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                backgroundColor: Colors.white,
                selectedItemColor: Color(0XFF12CBC4),
                unselectedItemColor: Colors.white,
                selectedLabelStyle: StylesApp(context).textStyleBody10,
                unselectedLabelStyle: StylesApp(context).textStyleBody10,
                items: getItemsMap(context),
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            );
          },
        ),
      ),
    );
  }

  int getColorShadow(int score) {
    if (score > 100) {
      return 0XFFBE9D27;
    } else if (score > 50 && score <= 100) {
      return 0XFFA5A7A1;
    } else {
      return 0XFFD5886B;
    }
  }

  int getColorItem(int score) {
    if (score > 100) {
      return 0XFFFCD859;
    } else if (score > 50 && score <= 100) {
      return 0XFFE4E0E0;
    } else {
      return 0XFFD5886B;
    }
  }

  void _showBottomNavigationBar() {
    _isVisible.value = true;
    _timer?.cancel();
    _timer = Timer(Duration(seconds: 2), () {
      _isVisible.value = false;
    });
  }
}

_buildItemLevel(BuildContext context, Level grupo) {
  if (grupo.img.urlImg.isNotEmpty) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: StylesApp(context)
          .sizeContainerSub
          .width, // Ajusta el tamaño según tus necesidades
      height: StylesApp(context).sizeContainerSub.height,
      decoration: BoxDecoration(
        color: grupo.levelScore > 0
            ? Color(getColorInner(grupo.levelScore))
            : Color.fromARGB(
                100,
                int.parse('0xFF${grupo.color}'.substring(2), radix: 16),
                int.parse('0xFF${grupo.color}'.substring(4, 6), radix: 16),
                int.parse('0xFF${grupo.color}'.substring(6), radix: 16),
              ),
        shape: BoxShape.circle,
      ),
      //  "${GraphQLConfig.urlServidor}${grupo.img.urlImg}",
      child: Image.network(
        "${GraphQLConfig.urlServidor}${grupo.img.urlImg}",
        errorBuilder: (context, error, stackTrace) {
          return Image.asset("assets/level.png",
              fit: StylesApp(context).fitImage);
        },
        fit: StylesApp(context).fitImage,
      ),
    );
  } else {
    return Container(
      width: StylesApp(context)
          .sizeContainerSub
          .width, // Ajusta el tamaño según tus necesidades
      height: StylesApp(context).sizeContainerSub.height,
      padding: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        color: grupo.levelScore > 0
            ? Color(getColorInner(grupo.levelScore))
            : Color.fromARGB(
                100,
                int.parse('0xFF${grupo.color}'.substring(2), radix: 16),
                int.parse('0xFF${grupo.color}'.substring(4, 6), radix: 16),
                int.parse('0xFF${grupo.color}'.substring(6), radix: 16),
              ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              textAlign: TextAlign.center,
              "${grupo.levelNumber}",
              style: StylesApp(context).textStyleLevelNumber.copyWith(
                    height: 1,
                    color: Colors.white,
                  ),
            ),
            Text(
              "paso",
              style: StylesApp(context).textStyleLevelNumber.copyWith(
                  fontSize: StylesApp(context).fontSizeBody10,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

int getColorInner(int score) {
  if (score > 100) {
    return 0XFFDDAC17;
  } else if (score >= 50 && score <= 100) {
    return 0XFFA5A7A1;
  } else {
    return 0XFFB05E3C;
  }
}
