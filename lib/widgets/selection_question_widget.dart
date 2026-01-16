import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';

class SelectionQuestionWidget extends StatefulWidget {
  final Question currentQuestion;
  final bool suggestionSelected;
  final bool selectionCompleted;
  final bool isAnswerSelected;
  final bool isCorrect;
  final double fontSize;
  final bool isTablet;
  final List<Map<String, String>> options;
  final Function(BuildContext context, int) answerSelected;

  final void Function() callBackContinue;
  const SelectionQuestionWidget({
    super.key,
    required this.currentQuestion,
    required this.answerSelected,
    required this.options,
    required this.suggestionSelected,
    required this.selectionCompleted,
    required this.isCorrect,
    required this.callBackContinue,
    required this.isAnswerSelected,
    this.fontSize = 14.0,
    this.isTablet = false,
  });

  @override
  State<SelectionQuestionWidget> createState() =>
      _SelectionQuestionWidgetState();
}

class _SelectionQuestionWidgetState extends State<SelectionQuestionWidget> {
  List currentAnswers = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return widget.isTablet
          ? Container(
              padding: widget.isTablet ? EdgeInsets.all(16.0) : EdgeInsets.zero,
              child: Column(
                children: [
                  if (widget.isTablet) ...[
                    Text(
                      "Selecciona la respuesta correcta",
                      style: StylesApp(context).textStyleBody16.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16),
                  ],
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 2.9,
                    ),
                    itemCount: widget.options.length,
                    itemBuilder: (context, index) {
                      return _buildOptionItem(context, index);
                    },
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: widget.currentQuestion.answers.length,
              itemBuilder: (context, int index) {
                return _buildOptionItem(context, index);
              },
            );
    } catch (e, st) {
      if (kDebugMode) {
        print('Error en SelectionQuestionWidget: $e');
        print('Stack Trace: $st'); // Imprime el Stack Trace completo
      }
      return Center(child: Text("Error: $e"));
    }
  }

  Widget _buildOptionItem(BuildContext context, int index) {
    currentAnswers = widget.currentQuestion.answers;
    final answer = currentAnswers[index];
    return GestureDetector(
      onTap: widget.isAnswerSelected
          ? null
          : () {
              widget.answerSelected(context, index);
            },
      child: Container(
        margin: widget.isTablet
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        constraints: BoxConstraints(minHeight: 48.0),
        decoration: BoxDecoration(
          color: widget.suggestionSelected && answer.isCorrect
              ? Colors.green
              : widget.isAnswerSelected
                  ? StyleColor.turquoise.withValues(alpha: 0.30)
                  : StyleColor.turquoise,
          borderRadius: BorderRadius.circular(8.0),
          // border: !widget.isCorrect
          //     ? Border.all(color: Colors.redAccent, width: 3.0)
          //     : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              offset: Offset(0.0, 4.0),
              blurStyle: BlurStyle.inner,
              blurRadius: 4.0,
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical:  widget.isTablet ? 12.0 : 12.0),
          child: Row(
            spacing: 10.0,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 0,
                child: Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.0),
                    color: Color(
                      int.parse('0xFF${widget.options[index]["color"]}'),
                    ),
                  ),
                  child: Center(
                      child: Text(
                    widget.currentQuestion.answers[index].option ?? "",
                    style: widget.isTablet
                        ? StylesApp(context)
                            .textStyleBody14
                            .copyWith(color: Colors.black)
                        : StylesApp(context)
                            .textStyleBody12
                            .copyWith(color: Colors.black),
                  )),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    widget.currentQuestion.answers[index].answer,
                    style: widget.isTablet
                        ? StylesApp(context)
                            .textStyleBody14
                        : StylesApp(context)
                            .textStyleBody12,
                  ),
                ),
              ), // Display the answer text
            ],
          ),
        ),
      ),
    );
  }
}
