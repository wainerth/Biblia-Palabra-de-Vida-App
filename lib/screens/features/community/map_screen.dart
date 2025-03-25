import 'dart:async';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/loading_service.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final userProvider;
  CourseModel? course = null;
  Stage? stage = null;
  List<Level> levels = [];
  List<List<Level>> gruposDeNiveles = [];
  late ScrollController scrollController;
  final _isVisible = ValueNotifier<bool>(true);
  Timer? _timer;
  bool _showBottomNavBar = false;
  int _selectedIndex = 2;

  // int _selectedIndex = 0;
  final List<String> imagePaths = [
    'assets/mapa1.png',
    'assets/mapa2.png',
  ];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateData(context);
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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
        int.parse(lastLockedId) * 190, // Ajusta según el tamaño del nivel
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
        final ResponseData courseResponse = await loadOneCourse(
            userData != null ? userData!.user.id : null, courseId);
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
        final result = await loadLevelsByCourse(userData?.user.id, sectionId);

        if (result.error != null) {
          errorMessage = result.error;
        } else {
          setState(() {
            levels = result.data
                .map((level) => Level.fromJson(removeTypename(level)))
                .cast<Level>()
                .toList();
            gruposDeNiveles = chunked(levels, 4);
          });
        }
      } catch (e) {
        errorMessage = "An error occurred: $e";
      } finally {
        LoadingService().hideLoading();
        setState(() {
          isLoading = false;
        });
        // onScrollPosition();
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushNamed(context, '/layoutPage');
      } else if (_selectedIndex != 2) {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pushNamed(
          context,
          '/layoutPage1',
          arguments: {'selectedIndex': _selectedIndex},
        );
      }
    });
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
    List coordATop = [0.00, 0.25, 0.48, 0.75];

    List coordALeft = [0.17, 0.55, 0.65, 0.65];

    List coordBTop = [0.0, 0.25, 0.50, 0.75];
    List coordBLeft = [0.30, 0.17, 0.05, 0.05];

    return Scaffold(
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
                              onScroller: onScrollPosition),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height,
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: gruposDeNiveles
                                  .length, // Dividimos por 4 para obtener el número de grupos de niveles
                              itemBuilder: (context, index) {
                                List<Level> grupo = gruposDeNiveles[index];
                                String image = index % 2 == 0
                                    ? imagePaths[0]
                                    : imagePaths[1];
                                return Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                              minHeight:
                                                  MediaQuery.sizeOf(context)
                                                      .height),
                                          child: Image.asset(
                                            image,
                                            width: double.infinity,
                                            height: MediaQuery.sizeOf(context)
                                                .height,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
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
                                                      //aaaa
                                                      Navigator.pushNamed(
                                                        context,
                                                        '/historyPage',
                                                        arguments: {
                                                          'courseId':
                                                              course?.id,
                                                          'levelId':
                                                              grupo[i].id,
                                                          'sectionId': stage!.id
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
                                                        containerWidth: StylesApp(
                                                                context)
                                                            .sizeContainerLevel
                                                            .width,
                                                        levelScore:
                                                            grupo[i].levelScore,
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
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Color(grupo[i].levelScore >
                                                                                0
                                                                            ? getColorItem(grupo[i]
                                                                                .levelScore)
                                                                            : int.tryParse('0xFF${grupo[i].color}') ??
                                                                                0XFF000000),
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        border:
                                                                            Border.all(
                                                                          color: grupo[i].levelScore > 0
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
                                                                    child: _buildItemLevel(
                                                                        context,
                                                                        grupo[
                                                                            i])),
                                                              ),
                                                              if (grupo[i]
                                                                      .unLockLevel ==
                                                                  false)
                                                                Positioned.fill(
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: const Color(
                                                                              0xFFA9B8BE)
                                                                          .withValues(
                                                                              alpha: 0.9), // Ajusta la opacidad
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
                                                          textAlign:
                                                              TextAlign.center,
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
            height: value ? kBottomNavigationBarHeight : 0,
            child: CustomBottomNavigationBarWidget(
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              backgroundColor: Color(0XFF7D7878),
              selectedItemColor: Color(0XFF12CBC4),
              unselectedItemColor: Colors.white,
              selectedLabelStyle: StylesApp(context).textStyleBody10,
              unselectedLabelStyle: StylesApp(context).textStyleBody10,
              items: itemsMap
                  .map((item) => BottomNavigationBarItem(
                        icon: Icon(
                          item.icon,
                          size: StylesApp(context).sizeIconBottomBar,
                        ),
                        label: item.title,
                      ))
                  .toList(),
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          );
        },
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
