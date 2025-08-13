import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardAventureWidget extends StatelessWidget {
  final CourseDetail course;
  final bool loadingAction;
  final void Function() onTap;
  final void Function() goToMap;
  const CardAventureWidget({
    super.key,
    required this.course, required this.onTap, required this.goToMap,
    this.loadingAction = false
  });

  @override
  Widget build(BuildContext context) {
    const maxScore = 150;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 6.0),
      margin: EdgeInsets.symmetric(horizontal: 9.0, vertical: 5.0),
      constraints: BoxConstraints(minHeight: 112.0),
      decoration: BoxDecoration(
          color: Color(int.parse('0XFF${course.color}')),
          borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        children: [
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    constraints:
                        BoxConstraints(maxWidth: 79.0, minHeight: 112.0),
                    width: 79.0,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Center(
                                child: StarStatusWidget(
                                containerWidth: 79,
                                levelScore: obtainedStar(maxScore, course.sectionCompletedCount, course.sectionCount) ,
                              ),
                            ),
                            
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 28.0,
                                ),
                                Container(
                                  width: 60.0,
                                  height: 60.0,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.0),
                                    image: DecorationImage(
                                      image: NetworkImage (GraphQLConfig.urlServidor + course.imgCourseUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Center(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(28.0),
                                        color: Color(0XFFFDE754)),
                                    child: Text(
                                      "${course.sectionCompletedCount} / ${course.sectionCount}",
                                      textAlign: TextAlign.center,
                                      style: StylesApp(context).chipLevels,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      course.titleCourse,
                      style: StylesApp(context).textStyleBody5,
                    ),
                  ),
                  SizedBox(
                    width: 37.0,
                  )
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  constraints: BoxConstraints(maxHeight: 50.0),
                  padding: EdgeInsets.all(0),
                  iconSize: 30.sp,
                  onPressed: onTap,
                  icon: Icon(
                    size: 20.sp,
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 6,
                right: 0,
                child: ButtonThemeWidget(
                  loading: loadingAction,
                  onPressed: goToMap,
                  textStyle: StylesApp(context)
                      .chipLevels
                      .copyWith(color: Colors.white),
                  buttonStyle: StylesApp(context).btnWidgetSmall,
                  text: "Ir a aventura",
                  width: 150.0,
                  height: 27,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}
