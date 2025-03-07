import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/loading_service.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AventureScreen extends StatefulWidget {
  const AventureScreen({super.key});

  @override
  State<AventureScreen> createState() => _AventureScreenState();
}

class _AventureScreenState extends State<AventureScreen> {
  late final userProvider;
  LoginUser? dataUser;
  LastProgressUser? progressUser;
  bool isLoading = true;
  List<bool> loadAventure = [];
  String? errorMessage;

  List<CourseModel> courses = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateData(context);
    });
  }

  Future<void> _generateData(BuildContext context) async {
    LoadingService().showLoading(context);
    setState(() {
      errorMessage= null;
      
    });
    try {
      final result = await loadCoursesByUserAndChurch(null, null);
      if (result.error != null) {
        errorMessage = result.error;
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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(),
              isLoading
                  ? Container()
                  : errorMessage != null
                      ? Center(
                          child: BuildErrorWidget(
                            errorMessage: errorMessage!,
                            onRetry: () async => _generateData(context),
                            onBack: () => Navigator.pop(context),
                          ),
                        )
                      : listViewCardAventure(),
            ],
          ),
        ),
      ),
    );
  }

  listViewCardAventure() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height - 30,
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 40.0),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                loadAventure.add(false);
                return Column(
                  children: [
                    Stack(children: [
                      CardAventureWidget(
                        course: courses[index],
                        loadingAction: loadAventure[index],
                        onTap: () {
                          Navigator.popAndPushNamed(
                              context, '/detailCoursePage',
                              arguments: courses[index]);
                        },
                        goToMap: () async {
                          setState(() {
                            loadAventure[index] = true;
                          });
                          // consulto si el usuario tiene algún progreso para este curso?
                          final userProvider =
                              Provider.of<UserProvider>(context, listen: false);
                          progressUser = await userProvider.getProgressUser(
                              dataUser?.user.id, courses[index].id);
                          if (progressUser != null) {
                            Navigator.pushNamed(context, '/mapPage',
                                arguments: {
                                  'courseId': courses[index].id,
                                  'sectionId': progressUser!.sectionId
                                });
                          } else {
                            Stage stage = await loadStage(
                                dataUser?.user.id, courses[index].id);
                            if (stage.levelCount > 0) {
                              Navigator.pushNamed(context, '/mapPage',
                                  arguments: {
                                    'courseId': courses[index].id,
                                    'sectionId': stage.id
                                  });
                            } else {
                              await showCustomDialog(context,
                                  message: "¡Este curso no esta Disponible!",
                                  dialogType: DialogType.info);
                            }
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
                            child: Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 4.0,
                                strokeAlign: BorderSide.strokeAlignInside,
                                backgroundColor: Colors.white,
                              ),
                            )),
                    ]),
                    if (index == courses.length - 1) ...{
                      SizedBox(
                        height: kBottomNavigationBarHeight + 30,
                      )
                    }
                  ],
                );
              },
            ),
          ),
        ],
      ),
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
