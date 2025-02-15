import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class SelectionQuestionWidget extends StatefulWidget {
  final currentQuestion;
  final List<Map<String, String>> options;
  final Function(BuildContext context, int) answerSelected;
  const SelectionQuestionWidget(
      {super.key,
      required this.currentQuestion,
      required this.answerSelected,
      required this.options});

  @override
  State<SelectionQuestionWidget> createState() =>
      _SelectionQuestionWidgetState();
}

class _SelectionQuestionWidgetState extends State<SelectionQuestionWidget> {
  List currentAnswers = [];
  bool _isAnswerSelected = false;
  bool suggestionSelected = false;
  int _selectedAnswerIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 6.0),
            child: ListView.builder(
              itemCount: widget.currentQuestion.answers.length,
              itemBuilder: (context, int index) {
                currentAnswers = widget.currentQuestion.answers;
                final answer = currentAnswers[index];
                return GestureDetector(
                  onTap: _isAnswerSelected
                      ? null
                      : () {
                          widget.answerSelected(context, index);
                        },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 27.0),
                    constraints: BoxConstraints(minHeight: 48.0),
                    decoration: BoxDecoration(
                      color: suggestionSelected && answer.isCorrect
                          ? Colors.green
                          : _isAnswerSelected
                              ? StyleColor.turquoise.withValues(alpha: 0.30)
                              : StyleColor.turquoise,
                      borderRadius: BorderRadius.circular(8.0),
                      border: _selectedAnswerIndex == index && !answer.isCorrect
                          ? Border.all(color: Colors.redAccent, width: 3.0)
                          : null,
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
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
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
                                  int.parse(
                                      '0xFF${widget.options[index]["color"]}'),
                                ),
                              ),
                              child: Center(
                                  child: Text(
                                widget.currentQuestion.answers[index].option!,
                                style: StylesApp(context)
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
                                style: StylesApp(context).textStyleBody12,
                              ),
                            ),
                          ), // Display the answer text
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: 47.0,
        ),
      ],
    );
  }
}
