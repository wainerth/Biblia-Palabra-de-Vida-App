import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/bible_theme_provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AventureScreen extends StatefulWidget {
  const AventureScreen({super.key});

  @override
  State<AventureScreen> createState() => _AventureScreenState();
}

class _AventureScreenState extends State<AventureScreen> {
  late final UserProvider userProvider;
  LoginUser? dataUser;
  LastProgressUser? progressUser;
  bool isLoading = true;
  List<bool> loadAventure = [];
  late BibleTheme currentTheme;

  String? errorMessage;
  int itemPerPageValue = 10;
  List<int> itemsPerPage = [
    5,
    10,
    15,
    25,
    50,
    100,
  ];
  PaginationInfo pagination = PaginationInfo(
    currentPage: 1,
    totalPages: 0,
    itemsPerPage: 0,
    totalItems: 0,
    hasPreviousPage: false,
    hasNextPage: false,
  );

  List<CourseModel> courses = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateData(context, pagination.currentPage, itemPerPageValue);
    });
  }

  Future<void> _generateData(BuildContext context, int page, int limit) async {
    LoadingService().showLoading(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    dataUser = userProvider.currentUser;
    setState(() {
      errorMessage = null;
    });
    try {
      final result = await loadCoursesByUserAndChurch(
          page,
          limit,
          dataUser!.userId,
          dataUser!.userChurch.isNotEmpty
              ? dataUser!.userChurch.first.id
              : null);
      if (result.error != null) {
        LoadingService().hideLoading();
        if (result.error.contains("Información")) {
          await showCustomDialogWithAction(context,
              message: result.error!,
              dialogType: DialogTypeAction.info,
              buttonOk: 'Volver',
              actionCallbackOk: () {
                Navigator.popAndPushNamed(context, '/workspacePage');
              },
              showAction: true,
              textButton: 'Afiliar a una Iglesia?',
              actionCallback: () {
                Navigator.popAndPushNamed(context, '/profilePage');
              });
          errorMessage = result.error;
        } else {
          errorMessage = result.error;
        }
      } else {
        setState(() {
          courses = result.data
              .map((course) => CourseModel.fromJson(removeTypename(course)))
              .cast<CourseModel>()
              .toList();
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    dataUser = userProvider.currentUser;
    progressUser = userProvider.progressUser;
    final themeProvider =
        Provider.of<BibleThemeProvider>(context, listen: false);
    currentTheme = themeProvider.themeData;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(),
            Expanded(
              child: isLoading
                  ? Container()
                  : errorMessage != null
                      ? Center(
                          child: BuildErrorWidget(
                            errorMessage: errorMessage!,
                            onRetry: () async => _generateData(context,
                                pagination.currentPage, itemPerPageValue),
                            onBack: () => Navigator.pop(context),
                          ),
                        )
                      : listViewCardAventure(),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
                top: 8.0,
              ),
              child: CustomPagination(
                pagination: PaginationInfo(
                  currentPage: pagination.currentPage,
                  itemsPerPage: pagination.itemsPerPage,
                  totalPages: pagination.totalPages,
                  hasPreviousPage: pagination.hasPreviousPage,
                  hasNextPage: pagination.hasNextPage,
                  totalItems: pagination.totalItems,
                ),
                itemPerPageValue: itemPerPageValue,
                currentTheme: currentTheme,
                onPageChanged: (newPage, newPerPage) async {
                  if (courses.isNotEmpty) {
                    setState(() {
                      itemPerPageValue = newPerPage;
                    });
                    await _generateData(context, newPage, newPerPage);
                  }
                },
                itemsPerPage: itemsPerPage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  listViewCardAventure() {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 24.0),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        if (loadAventure.length <= index) loadAventure.add(false);
        return Column(
          children: [
            Stack(children: [
              CardAventureWidget(
                course: courses[index],
                loadingAction: loadAventure[index],
                onTap: () {
                  Navigator.popAndPushNamed(context, '/detailCoursePage',
                      arguments: courses[index].id);
                },
                goToMap: () async {
                  setState(() {
                    loadAventure[index] = true;
                  });
                  Stage? stage =
                      await loadStage(dataUser?.userId, courses[index].id);
                  if ( stage != null && stage.levelCount > 0) {
                    final userProvider =
                        Provider.of<UserProvider>(context, listen: false);
                    final progressResponse = await userProvider.getProgressUser(
                        dataUser?.userId, courses[index].id);
                    if (progressResponse!.error != null) {
                      await showCustomDialog(context,
                          message: progressResponse.error!,
                          dialogType: DialogType.error);
                    }
                    progressUser = progressResponse.data;
                    if (progressUser != null) {
                      Navigator.pushNamed(context, '/mapPage', arguments: {
                        'courseId': courses[index].id,
                        'sectionId': progressUser!.sectionId ?? stage.id
                      });
                    } else {
                      Navigator.pushNamed(context, '/mapPage', arguments: {
                        'courseId': courses[index].id,
                        'sectionId': stage.id
                      });
                    }
                  } else {
                    setState(() {
                      loadAventure[index] = false;
                    });
                    await showCustomDialog(context,
                        message: "¡Este curso no esta Disponible!",
                        dialogType: DialogType.info);
                  }
                  setState(() {
                    loadAventure[index] = false;
                  });
                },
              ),
              if (loadAventure[index])
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
                    )),
            ]),
          ],
        );
      },
    );
  }

  loadStage(String? userId, String courseId) async {
    List<Stage> stages = [];
    final result = await loadStageByCourse(userId, courseId);
    if (result.data != null) {
      stages = result.data
          .map((stage) => Stage.fromJson(removeTypename(stage)))
          .cast<Stage>()
          .toList();
      return stages.first;
    }
    return null;
  }
}
