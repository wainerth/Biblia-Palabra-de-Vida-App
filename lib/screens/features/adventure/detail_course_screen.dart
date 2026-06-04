import 'package:biblia_palabra_de_vida_app/config/api_config.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
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
  ResponseProgress? progressUser;
  int _selectedIndex = 1;
  late AppTranslationProvider _translationProvider;
  // determinar s ies table
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStageSections(context);
    });
  }

  Future<void> _loadStageSections(context) async {
    final translationProvider = _translationProvider;

    setState(() => errorMessage = null);

    if (!mounted) return;
    final route = ModalRoute.of(context);
    if (route == null || route.settings.arguments == null) {
      setState(() {
        errorMessage =
            translationProvider.tr('details_course.errors.navigation_context');
        isLoading = false;
      });
      return;
    }

    try {
      if (mounted) {
        LoadingService().showLoading(context);
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final courseParam = route.settings.arguments as Map<String, dynamic>?;

      if (courseParam == null || !courseParam.containsKey("courseId")) {
        setState(() {
          errorMessage = translationProvider
              .tr('details_course.errors.course_id_not_provided');
          isLoading = false;
        });
        return;
      }

      final LoginUser? userData = userProvider.currentUser;

      if (userData == null) {
        setState(() {
          errorMessage = translationProvider
              .tr('details_course.errors.user_not_authenticated');
          isLoading = false;
        });
        return;
      }

      setState(() {
        progressUser = userProvider.progressUser;
      });

      // obtenemos curso
      final ResponseData courseResponse = await loadOneCourse(
        userData.userId,
        courseParam["courseId"],
      ).timeout(const Duration(seconds: 30));

      if (courseResponse.error != null) {
        errorMessage = courseResponse.error;
        return;
      }
      course = CourseDetail.fromJson(courseResponse.data);

      // obtenemos etapas del curso
      final result = await loadStageByCourse(userData.userId, course!.id);
      if (result.error != null) {
        errorMessage = result.error;
        return;
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
      errorMessage =
          "${translationProvider.tr('details_course.errors.an_error_occurred')}: $e";
      return;
    } finally {
      // 5. Asegurar que hideLoading se llame incluso si mounted es false
      try {
        LoadingService().hideLoading();
      } catch (_) {}

      // 6. Solo llamar setState si el widget sigue montado
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
    _translationProvider = context.read<AppTranslationProvider>();
    final translationProvider = context.read<AppTranslationProvider>();

    return Scaffold(
      body: SafeArea(
        child: isTablet(context)
            ? _buildTabletLayout(translationProvider)
            : _buildMobileLayout(translationProvider),
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

  _buildBodyContent(course, AppTranslationProvider translationProvider) {
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
                      userProvider.currentUser!.userId, course.id);
                  if (progressResponse!.error != null) {
                    await showCustomDialog(context,
                        messageDetail: progressResponse.error!,
                        message: progressResponse.userFriendlyError!,
                        dialogType: DialogType.error);
                  }
                  progressUser = progressResponse.data;
                  if (progressUser?.success == true) {
                    if (progressUser!.message
                        .contains('El curso ya fue finalizado')) {
                      await showCustomDialogWithAction(
                        context,
                        message: progressUser!.message,
                        dialogType: DialogTypeAction.info,
                        buttonOk: translationProvider
                            .tr('detail_course.see_more_courses'),
                        textButton: translationProvider
                            .tr('detail_course.go_to_course'),
                        showAction: true,
                        actionCallbackOk: () {
                          Navigator.pushNamed(context, '/layoutPage',
                              arguments: {'selectedIndex': 1});
                        },
                        actionCallback: () {
                          Navigator.pushNamed(context, '/mapPage', arguments: {
                            'courseId': progressUser?.data?.courseId,
                            'sectionId':
                                progressUser?.data?.sectionId ?? stages.first.id
                          });
                        },
                      );
                      return;
                    } else {
                      Navigator.pushNamed(context, '/mapPage', arguments: {
                        'courseId': course.id,
                        'sectionId':
                            progressUser?.data?.sectionId ?? stages.first.id
                      });
                    }
                  } else {
                    if (stages.first.levelCount > 0) {
                      Navigator.pushNamed(context, '/mapPage', arguments: {
                        'courseId': course.id,
                        'sectionId': stages.first.id
                      });
                    } else {
                      await showCustomDialog(context,
                          message: translationProvider
                              .tr('detail_course.course_unavailable'),
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
                        buttonText:
                            translationProvider.tr('detail_course.accept'),
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
          _listOfStages(context, translationProvider)
        ],
      ),
    );
  }

  _listOfStages(
      BuildContext context, AppTranslationProvider translationProvider) {
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
                                        "${translationProvider.tr('detail_course.stage')} ${stage.sectionNumber}", //index + 1
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
                                        onPressed: (getStatus(stage,
                                                    translationProvider) ==
                                                translationProvider.tr(
                                                    'detail_course.status.pending'))
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
                                              return (getStatus(stage,
                                                          translationProvider) ==
                                                      translationProvider.tr(
                                                          'detail_course.status.completed'))
                                                  ? Color(0XFFC7AA34)
                                                  : Color(
                                                      0XFF12CBC4); // Use the component's default.
                                            },
                                          ),
                                        ),
                                        text: getStatus(
                                            stage, translationProvider),
                                      ),
                                      if (getStatus(
                                              stage, translationProvider) !=
                                          translationProvider.tr(
                                              'detail_course.status.pending')) ...{
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
                                          text: translationProvider
                                              .tr('detail_course.go'),
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
                                    buttonText: translationProvider
                                        .tr('detail_course.accept'),
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
                      if (getStatus(stage, translationProvider) ==
                          translationProvider
                              .tr('detail_course.status.in_progress'))
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
                        color: Colors.black.withValues(alpha: 0.1),
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
                          "${translationProvider.tr('detail_course.stage')} ${index + 1} - ${translationProvider.tr('detail_course.coming_soon')}",
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

  String getStatus(level, AppTranslationProvider translationProvider) {
    if (level.levelCompletedCount > 0) {
      if (level.levelCompletedCount.toString() == level.levelCount.toString()) {
        return translationProvider.tr('detail_course.status.completed');
      } else {
        return translationProvider.tr('detail_course.status.in_progress');
      }
    } else {
      return level.unLockSection
          ? translationProvider.tr('detail_course.status.in_progress')
          : translationProvider.tr('detail_course.status.pending');
    }
  }

  IconData getEstadoIcon(String estado, AppTranslationProvider trProvider) {
    final completed = trProvider.tr('detail_course.status.completed');
    final inProgress = trProvider.tr('detail_course.status.in_progress');
    final pending = trProvider.tr('detail_course.status.pending');

    if (estado == completed) {
      return Icons.chat_bubble_outline;
    } else if (estado == inProgress) {
      return Icons.whatshot;
    } else if (estado == pending) {
      return Icons.square;
    } else {
      return Icons.error;
    }
  }

  _buildTabletLayout(AppTranslationProvider translationProvider) {
    return Column(
      children: [
        HeadScoreWidget(
          onRoute: () {
            Navigator.popAndPushNamed(context, '/profilePage');
          },
        ),
        SizedBox(height: 16.0),
        // titulo
        Text(
          translationProvider.tr('detail_course.title'),
          style: StylesApp(context)
              .textStyleBody14
              .copyWith(color: StyleColor.vibrantPurple),
        ),
        SizedBox(
          height: 24.0,
        ),

        // contenido Principal
        if (isLoading)
          Center(
            child: CircularProgressIndicator(),
          )
        else if (errorMessage != null)
          Center(
            child: BuildErrorWidget(
              errorMessage: errorMessage!,
              onRetry: () async => await _loadStageSections(context),
              onBack: () => Navigator.pop(context),
            ),
          )
        else
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                spacing: 10.0,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: _buildTabletCourseCard(translationProvider),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: _buildTabletStagesList(translationProvider),
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }

  // Card del curso para tablet
  Widget _buildTabletCourseCard(AppTranslationProvider translationProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen del curso
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              image: course?.imgCourseUrl.isNotEmpty == true
                  ? DecorationImage(
                      image: NetworkImage(
                          "${ApiConfig.baseUrl}${course!.imgCourseUrl}"),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: course?.imgCourseUrl.isNotEmpty == true
                  ? Colors.transparent
                  : Color(0XFF12CBC4),
            ),
            child: course?.imgCourseUrl.isNotEmpty == true
                ? null
                : Center(
                    child: Icon(
                      Icons.book,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
          ),

          // Contenido del card
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Información del curso
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course?.titleCourse ?? 'Curso',
                        style: StylesApp(context).textStyleBody20.copyWith(
                              fontSize: 22,
                              color: Colors.black87,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),
                      Text(
                        course?.introduction ?? 'Descripción del curso',
                        style: StylesApp(context).textStyleBody14.copyWith(
                              fontSize: 16,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          _buildInfoChip(
                            icon: Icons.layers,
                            text:
                                '${course?.sectionCompletedCount ?? 0}/${course?.sectionCount ?? 0} ${translationProvider.tr('detail_course.course_sections')}',
                          ),
                          SizedBox(width: 12),
                          _buildInfoChip(
                            icon: Icons.check_circle,
                            text:
                                '${((course?.sectionCompletedCount ?? 0) / (course?.sectionCount ?? 1) * 100).toInt()} ${translationProvider.tr('detail_course.completed_percentage')}',
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Botones de acción
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(24),
                                  constraints: BoxConstraints(
                                    maxWidth: 500,
                                  ),
                                  child: CustomModalWidget(
                                    title: course?.titleCourse ?? '',
                                    content: course?.introduction ?? '',
                                    buttonText: translationProvider
                                        .tr('detail_course.accept'),
                                    id: course?.id ?? '',
                                    showSubtitle: false,
                                    itemCount: 0,
                                    itemsCompleted: 0,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: StyleColor.turquoise,
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          translationProvider
                              .tr('detail_course.view_course_details'),
                          style: StylesApp(context).textStyleBody14.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                      SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () async {
                          setState(() => loadAventure = true);
                          await _handleGoToMap();
                          setState(() => loadAventure = false);
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: StyleColor.turquoise),
                        ),
                        child: loadAventure
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: StyleColor.turquoise,
                                ),
                              )
                            : Text(
                                translationProvider
                                    .tr('detail_course.go_to_course_map'),
                                style:
                                    StylesApp(context).textStyleBody12.copyWith(
                                          color: StyleColor.turquoise,
                                        ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(AppTranslationProvider translationProvider) {
    return OrientationBuilder(
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
                  translationProvider.tr('detail_course.title'),
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
                        : _buildBodyContent(course, translationProvider)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: StyleColor.turquoise.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Color(0XFF12CBC4)),
          SizedBox(width: 6),
          Text(
            text,
            style: StylesApp(context).textStyleBody10.copyWith(
                  fontSize: 12.0,
                  color: StyleColor.turquoise,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  // Método auxiliar para manejar la navegación al mapa
  Future<void> _handleGoToMap() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final progressResponse = await userProvider.getProgressUser(
        userProvider.currentUser!.userId, course!.id);

    if (progressResponse!.error != null) {
      await showCustomDialog(context,
          messageDetail: progressResponse.error!,
          message: progressResponse.userFriendlyError!,
          dialogType: DialogType.error);
      return;
    }

    progressUser = progressResponse.data;

    if (progressUser?.success == true) {
      if (progressUser!.message.contains('El curso ya fue finalizado')) {
        await showCustomDialogWithAction(
          context,
          message: progressUser!.message,
          dialogType: DialogTypeAction.info,
          buttonOk: _translationProvider.tr('detail_course.see_more_course'),
          textButton: _translationProvider.tr('detail_course.go_to_course'),
          showAction: true,
          actionCallbackOk: () {
            Navigator.pushNamed(context, '/layoutPage',
                arguments: {'selectedIndex': 1});
          },
          actionCallback: () {
            Navigator.pushNamed(context, '/mapPage', arguments: {
              'courseId': progressUser?.data?.courseId,
              'sectionId': progressUser?.data?.sectionId ?? stages.first.id
            });
          },
        );
        return;
      } else {
        Navigator.pushNamed(context, '/mapPage', arguments: {
          'courseId': course!.id,
          'sectionId': progressUser?.data?.sectionId ?? stages.first.id
        });
      }
    } else {
      if (stages.first.levelCount > 0) {
        Navigator.pushNamed(context, '/mapPage',
            arguments: {'courseId': course!.id, 'sectionId': stages.first.id});
      } else {
        await showCustomDialog(context,
            message: _translationProvider.tr('detail_course.course_unavailable'),
            dialogType: DialogType.info);
      }
    }
  }

  // Lista de etapas para tablet
  Widget _buildTabletStagesList(AppTranslationProvider translationProvider) {
    return Container(
      decoration: BoxDecoration(
        color: StyleColor.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: StyleColor.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header de la lista
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: StyleColor.turquoise,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translationProvider.tr('detail_course.course_stages'),
                  style: StylesApp(context).textStyleBody20.copyWith(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                ),
                Text(
                  '${stages.length} ${translationProvider.tr('detail_course.stages_count')}',
                  style: StylesApp(context).textStyleBody12,
                ),
              ],
            ),
          ),

          // Lista de etapas
          Expanded(
            child: stages.isEmpty
                ? Center(
                    child: Text(
                      translationProvider.tr('detail_course.no_stages'),
                      style: StylesApp(context).textStyleBody14.copyWith(
                            fontSize: 18,
                            color: StyleColor.grayMedium,
                          ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: stages.length,
                    itemBuilder: (context, index) {
                      final stage = stages[index];
                      return _buildTabletStageItem(
                          stage, index, translationProvider);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Item de etapa para tablet
  Widget _buildTabletStageItem(
      Stage stage, int index, AppTranslationProvider translationProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.only(left: 16.0),
      decoration: BoxDecoration(
        color: Color(int.parse('0XFF${stage.color}')).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: StyleColor.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Número de etapa
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: StyleColor.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    translationProvider.tr('detail_course.stage'),
                    style: StylesApp(context).textStyleBody10.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    '${stage.sectionNumber}',
                    style: StylesApp(context).textStyleBody20.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),

          // Contenido de la etapa
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          stage.sectionName,
                          style: StylesApp(context).textStyleBody16.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outline, color: Colors.white),
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(24),
                                  constraints: BoxConstraints(
                                    maxWidth: 500,
                                  ),
                                  child: CustomModalWidget(
                                    title: stage.sectionName,
                                    content: stage.introduction,
                                    buttonText: translationProvider
                                        .tr('detail_course.accept'),
                                    id: "${stage.sectionNumber} ",
                                    itemCount: stage.levelCount,
                                    itemsCompleted: stage.levelCompletedCount,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Barra de progreso
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            translationProvider.tr('detail_course.progress'),
                            style: StylesApp(context).textStyleBody14.copyWith(
                                  fontSize: 14,
                                ),
                          ),
                          Text(
                            '${stage.levelCompletedCount}/${stage.levelCount}',
                            style: StylesApp(context).textStyleBody14.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: StyleColor.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: stage.levelCount > 0
                              ? stage.levelCompletedCount / stage.levelCount
                              : 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: StyleColor.white,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: ButtonThemeWidget(
                          height: StylesApp(context).btnHeight.height,
                          onPressed: (getStatus(stage, translationProvider) ==
                                  translationProvider
                                      .tr("detail_course.status.pending"))
                              ? null
                              : () {
                                  Navigator.pushNamed(context, '/mapPage',
                                      arguments: {
                                        'courseId': course?.id,
                                        'sectionId': stage.id
                                      });
                                },
                          textStyle:
                              StylesApp(context).textStyleBody14.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                          buttonStyle:
                              StylesApp(context).btnWidgetSmall.copyWith(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.disabled)) {
                                  return Colors.grey[
                                      400]; // Color when the button is disabled
                                }
                                return (getStatus(stage, translationProvider) ==
                                        translationProvider.tr(
                                            "detail_course.status.completed"))
                                    ? Color(0XFFC7AA34)
                                    : StyleColor
                                        .turquoise; // Use the component's default.
                              },
                            ),
                          ),
                          text: getStatus(stage, translationProvider),
                        ),
                      ),
                      SizedBox(width: 12),
                      if (getStatus(stage, translationProvider) !=
                          translationProvider
                              .tr("detail_course.status.pending")) ...{
                        SizedBox(width: 8.0),
                        ButtonThemeWidget(
                          height: StylesApp(context).btnHeight.height,
                          onPressed: () {
                            Navigator.pushNamed(context, '/mapPage',
                                arguments: {
                                  'courseId': course?.id,
                                  'sectionId': stage.id
                                });
                          },
                          textStyle:
                              StylesApp(context).textStyleBody14.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                          width: 60,
                          text: translationProvider.tr("detail_course.go"),
                          buttonStyle: StylesApp(context).btnWidgetSmall,
                        )
                      }
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
