import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class QuestionHeader extends StatelessWidget {
  final CourseDetail? course;
  final Stage? stage;
  final Level? level;
  final int numberQuestion;
  final bool showStageInfo;
  final VoidCallback onBack;
  
  const QuestionHeader({
    super.key,
    required this.course,
    required this.stage,
    required this.level,
    required this.numberQuestion,
    this.showStageInfo = true,
    required this.onBack,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderNotDetailsStageWidget(
          showStage: showStageInfo,
          showAction: showStageInfo,
          title: "Conoce el ${course?.titleCourse ?? ''}",
          stage: stage?.sectionNumber.toString() ?? '',
          subtitle: stage?.sectionName ?? '',
          details: stage,
          onPressed: onBack,
        ),
        if (showStageInfo) ...[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            padding: EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              "${level?.name ?? ''} - Paso $numberQuestion",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 19.0),
        ],
      ],
    );
  }
}