import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/loading_service.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class AventureScreen extends StatefulWidget {
  const AventureScreen({super.key});

  @override
  State<AventureScreen> createState() => _AventureScreenState();
}

class _AventureScreenState extends State<AventureScreen> {
  late final userProvider;
  bool isLoading = true;
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(),
              isLoading
                ? Container()
                : errorMessage != null
                  ? Center(child: BuildErrorWidget(
                    
                    errorMessage: errorMessage!,
                    onRetry: () async => _generateData(context) ,
                    onBack: ()=> Navigator.pop(context),
                    ),)
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
                return Column(
                  children: [
                    CardAventureWidget(
                      course: courses[index],
                      onTap: () {
                        Navigator.popAndPushNamed(context, '/detailCoursePage',
                            arguments: courses[index]);
                      },
                      goToMap: (){
                        Navigator.pushNamed(context, '/mapPage',
                        arguments:courses[index] );
                      },
                    ),
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
}
