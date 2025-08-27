import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DetailCourseScreen extends StatefulWidget {
  const DetailCourseScreen({super.key});

  @override
  State<DetailCourseScreen> createState() => _DetailCorseScreenState();
}

class _DetailCorseScreenState extends State<DetailCourseScreen> {
  CourseDetail? course;
  List<Stage> stages = [];
  bool loadAventure = false;
  bool isLoading = true;
  String? errorMessage;
  LastProgressUser? progressUser;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStageSections(context);
    });
  }

  Future<void> _loadStageSections(_) async {
    LoadingService().showLoading(context);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final courseParam = ModalRoute.of(context)!.settings.arguments;
      final LoginUser? userData = userProvider.currentUser;
      errorMessage = null;
      progressUser = userProvider.progressUser;

      // obtenemos curso
      final ResponseData courseResponse = await loadOneCourse(
          userData!.userId, (courseParam as Map<String, dynamic>)["courseId"]);
      if (courseResponse.error != null) {
        errorMessage = courseResponse.error;
      }
      course = CourseDetail.fromJson(courseResponse.data);
      final result = await loadStageByCourse(userData.userId, course?.id);
      if (result.error != null) {
        errorMessage = result.error;
      } else {
        setState(() {
          if (result.data != null) {
            stages = result.data
                .map((stage) => Stage.fromJson(removeTypename(stage)))
                .cast<Stage>()
                .toList();
          }
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

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/layoutPage', (route) => false);

    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushNamed(context, '/layoutPage');
      } else {
        _selectedIndex = index;
        Navigator.pushNamed(
          context,
          '/layoutPage1',
          arguments: {'selectedIndex': _selectedIndex},
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return SingleChildScrollView(
              child: SizedBox(
                height: orientation == Orientation.portrait
                    ? MediaQuery.sizeOf(context).height - 60
                    : MediaQuery.sizeOf(context).width -
                        (MediaQuery.sizeOf(context).height / 2),
                child: Column(
                  children: [
                    HeadScoreWidget(
                      onRoute: () {
                        Navigator.popAndPushNamed(context, '/profilePage');
                      },
                    ),
                    Text(
                      "Sigue la ruta de la sabiduría",
                      style: StylesApp(context)
                          .textStyleBody20
                          .copyWith(color: StyleColor.vibrantPurple),
                    ),
                    isLoading
                        ? Container()
                        : errorMessage != null
                            ? Center(
                                child: BuildErrorWidget(
                                errorMessage: errorMessage!,
                                onRetry: () async =>
                                    await _loadStageSections(context),
                                onBack: () => Navigator.pop(context),
                              ))
                            : _buildBodyContent(course)
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBarWidget(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0XFF12CBC4),
        unselectedItemColor: Colors.white,
        selectedLabelStyle: StylesApp(context).textStyleBody10,
        unselectedLabelStyle: StylesApp(context).textStyleBody10,
        items: getItemsBarSecond(context),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  _buildBodyContent(course) {
    return Expanded(
      child: Column(
        children: [
          Stack(
            children: [
              CardAventureWidget(
                loadingAction: loadAventure,
                goToMap: () async {
                  setState(() {
                    loadAventure = true;
                  });
                  // consulto si el usuario tiene algún progreso para este curso?
                  final userProvider =
                      Provider.of<UserProvider>(context, listen: false);
                  final progressResponse = await userProvider.getProgressUser(
                      userProvider.currentUser?.userId, course.id);
                  if (progressResponse!.error != null) {
                    await showCustomDialog(context,
                        message: progressResponse.error!,
                        dialogType: DialogType.error);
                  }
                  progressUser = progressResponse.data;
                  if (progressUser != null) {
                    Navigator.pushNamed(context, '/mapPage', arguments: {
                      'courseId': course.id,
                      'sectionId': progressUser!.sectionId ?? stages.first.id
                    });
                  } else {
                    if (stages.first.levelCount > 0) {
                      Navigator.pushNamed(context, '/mapPage', arguments: {
                        'courseId': course.id,
                        'sectionId': stages.first.id
                      });
                    } else {
                      await showCustomDialog(context,
                          message: "¡Este curso no esta Disponible!",
                          dialogType: DialogType.info);
                    }
                    setState(() {
                      loadAventure = false;
                    });
                  }
                },
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return CustomModalWidget(
                        title: course.titleCourse,
                        content: course.introduction,
                        buttonText: 'Aceptar',
                        id: course.id,
                        showSubtitle: false,
                        itemCount: 0,
                        itemsCompleted: 0,
                      );
                    },
                  );
                },
                course: CourseModel(
                    id: course.id,
                    title: course.titleCourse,
                    color: course.color,
                    status: 1,
                    img: Img(urlImg: course.imgCourseUrl),
                    introduction: course.introduction,
                    sectionCount: course.sectionCount,
                    numberOfSections: course.numberOfSections ?? 0,
                    sectionCompletedCount: course.sectionCompletedCount),
              ),
              if (loadAventure)
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 4.0,
                      strokeAlign: BorderSide.strokeAlignInside,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            height: 6.0,
            decoration: BoxDecoration(
              color: Color(0XFFD9D9D9),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    offset: Offset(0.0, 4.0),
                    blurStyle: BlurStyle.outer),
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          _listOfStages(context)
        ],
      ),
    );
  }

  _listOfStages(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        itemCount: course?.numberOfSections ?? 0,
        itemBuilder: (context, index) {
          if (index < stages.length) {
            final stage = stages[index];
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 9.0),
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  constraints: BoxConstraints(
                    minHeight: 65.0,
                  ),
                  decoration: BoxDecoration(
                      color: Color(
                        int.parse('0XFF${stage.color}'),
                      ),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 10.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 0,
                              child: Column(
                                spacing: 10.0,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color(0XFFF4C622),
                                        borderRadius:
                                            BorderRadius.circular(28.0)),
                                    height: 28.0,
                                    constraints: BoxConstraints(
                                        minHeight: 28.0, minWidth: 101.0),
                                    child: Center(
                                      child: Text(
                                        "Etapa ${stage.sectionNumber }",//index + 1
                                        style: StylesApp(context)
                                            .textStyleBody12
                                            .copyWith(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      color: Color(0XFFF4C622),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.75),
                                          offset: Offset(4.0, 4.0),
                                          blurRadius: 4.0,
                                          spreadRadius: -4.0,
                                          blurStyle: BlurStyle.inner,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(28.0),
                                    ),
                                    height: 20.0,
                                    constraints:
                                        BoxConstraints(minHeight: 22.0),
                                    child: Center(
                                      child: Text(
                                        "${stage.levelCompletedCount} / ${stage.levelCount}",
                                        style: StylesApp(context)
                                            .textStyleBody12
                                            .copyWith(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                spacing: 10.0,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    textAlign: TextAlign.left,
                                    stage.sectionName,
                                    style: StylesApp(context).textStyleBody12,
                                  ),
                                  Row(
                                    children: [
                                      ButtonThemeWidget(
                                        height: 27.0,
                                        width: 150.0,
                                        onPressed: (getStatus(stage) ==
                                                "Pendiente")
                                            ? null
                                            : () {
                                                Navigator.pushNamed(
                                                    context, '/mapPage',
                                                    arguments: {
                                                      'courseId': course?.id,
                                                      'sectionId': stage.id
                                                    });
                                              },
                                        textStyle:
                                            StylesApp(context).textStyleBody14,
                                        buttonStyle: StylesApp(context)
                                            .btnWidgetSmall
                                            .copyWith(
                                          backgroundColor: WidgetStateProperty
                                              .resolveWith<Color?>(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.disabled)) {
                                                return Colors
                                                    .grey; // Color when the button is disabled
                                              }
                                              return (getStatus(stage) ==
                                                      "Completado")
                                                  ? Color(0XFFC7AA34)
                                                  : Color(
                                                      0XFF12CBC4); // Use the component's default.
                                            },
                                          ),
                                        ),
                                        text: getStatus(stage),
                                      ),
                                      if (getStatus(stage) != "Pendiente") ...{
                                        SizedBox(width: 8.0),
                                        ButtonThemeWidget(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/mapPage',
                                                arguments: {
                                                  'courseId': course?.id,
                                                  'sectionId': stage.id
                                                });
                                          },
                                          textStyle: StylesApp(context)
                                              .textStyleBody14,
                                          width: 50.sp,
                                          height: 27.0,
                                          text: "Ir",
                                          buttonStyle:
                                              StylesApp(context).btnWidgetSmall,
                                        )
                                      }
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SizedBox(
                          width: 28.sp,
                          height: 28.sp,
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(Icons.info_outline, color: Colors.white),
                            onPressed: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomModalWidget(
                                    title: stage.sectionName,
                                    content: stage.introduction,
                                    buttonText: 'Aceptar',
                                    id: "${stage.sectionNumber} ",
                                    itemCount: stage.levelCount,
                                    itemsCompleted: stage.levelCompletedCount,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      if (getStatus(stage) == "En Proceso")
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Image.asset(
                              "assets/kawaii_fire.png",
                              width: 28.0,
                            ))
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Render a visually enhanced placeholder card for future sections
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 9.0),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  constraints: BoxConstraints(
                    minHeight: 80.0,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade300, Colors.grey.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(2.0, 4.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: Colors.black54,
                        size: 28.0,
                      ),
                      SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          "Etapa ${index + 1} - Próximamente",
                          style: StylesApp(context).textStyleBody14.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                if (index == (course?.numberOfSections ?? 0) - 1) ...{
                  SizedBox(
                    height: kBottomNavigationBarHeight,
                  )
                }
              ],
            );
          }
          
        },
      ),
    );
  }

  String getStatus(level) {
    if (level.levelCompletedCount > 0) {
      if (level.levelCompletedCount.toString() == level.levelCount.toString()) {
        return "Completado";
      } else {
        return "En Proceso";
      }
    } else {
      return level.unLockSection ? "En proceso" : "Pendiente";
    }
  }

  IconData getEstadoIcon(String estado) {
    switch (estado) {
      case 'Completado':
        return Icons.chat_bubble_outline;
      case 'En Proceso':
        return Icons.whatshot;
      case 'Pendiente':
        return Icons.square;
      default:
        return Icons.error;
    }
  }
}
