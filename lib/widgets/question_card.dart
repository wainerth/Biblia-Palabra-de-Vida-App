import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final String question;
  final int numberQuestion;
  final int totalQuestions;
  final int failedAttempts;
  final double fontSize;
  final bool isTablet;

  const QuestionCard({
    super.key,
    required this.question,
    required this.numberQuestion,
    required this.totalQuestions,
    required this.failedAttempts,
    required this.fontSize,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isTablet) {
      return _buildTabletCard(context);
    }
    return _buildMobileCard(context);
  }

  Widget _buildMobileCard(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          constraints: BoxConstraints(minHeight: 68.0),
          margin: EdgeInsets.symmetric(horizontal: 6.0),
          padding: EdgeInsets.symmetric(horizontal: 11.0, vertical: 15.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0XFFFFBB00),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                offset: Offset(0.0, 4.0),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Text(
            question,
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize,
            ),
          ),
        ),
        Positioned(
          top: -20,
          right: 10,
          child: _buildAttemptsCounter(context),
        ),
      ],
    );
  }

  Widget _buildTabletCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0XFFFFBB00),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: Offset(0.0, 4.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Pregunta $numberQuestion de $totalQuestions",
                  style: StylesApp(context).textStyleBody12.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              _buildAttemptsCounter(context),
            ],
          ),
          SizedBox(height: 12),
          Text(
            question,
            style: StylesApp(context).textStyleBody12.copyWith(
              color: Colors.black,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttemptsCounter(BuildContext context) {
    return Row(
      children: [
        Text(
          "Oportunidades: ",
          style: StylesApp(context).textStyleBody12.copyWith(
            color: StyleColor.grayDark,
            fontSize: 12,
          ),
        ),
        ...List.generate(3, (index) {
          return Padding(
            padding: EdgeInsets.only(left: 4),
            child: Image.asset(
              failedAttempts <= (2 - index)
                  ? "assets/fire_rachaActive.png"
                  : "assets/fire_rachaInactive.png",
              width: 20,
            ),
          );
        }),
      ],
    );
  }
}
