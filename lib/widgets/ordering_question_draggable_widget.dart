import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class OrderingQuestionDraggableWidget extends StatefulWidget {
  final bool orderedCompleted;
  final Question currentQuestion;
  final List<Answer> orderedAnswers;
  final bool showError;
  final List<Map<String, String>> options;
  final Function(BuildContext context, int) answerSelected;
  final Function()? onContinue;
  const OrderingQuestionDraggableWidget(
      {super.key,
      required this.orderedCompleted,
      required this.orderedAnswers,
      required this.currentQuestion,
      required this.options,
      required this.answerSelected,
      required this.showError,
      this.onContinue});

  @override
  State<OrderingQuestionDraggableWidget> createState() =>
      _OrderingQuestionDraggableStateWidget();
}

class _OrderingQuestionDraggableStateWidget
    extends State<OrderingQuestionDraggableWidget> {
  int countList = 0;
  int currentIndex = 0;
  List currentAnswers = [];
  bool orderedCompleted = false;
  final ScrollController _scrollController = ScrollController();

  bool _searchExistedOrdered(id) {
    bool exist = widget.orderedAnswers.any((answer) => answer.id == id);
    return exist;
  }

  @override
  Widget build(BuildContext context) {
    countList = widget.currentQuestion.answers.length;
    currentAnswers = widget.currentQuestion.answers;
    return Column(
      children: [
        if (!widget.orderedCompleted) ...{
          DragTarget<Answer>(
            onAcceptWithDetails: (data) {
              setState(() {
                int dropIndex = -1;
                for (int i = 0; i < widget.orderedAnswers.length; i++) {
                  if (widget.orderedAnswers[i].id == "") {
                    dropIndex = i;
                    break;
                  }
                }
                if (dropIndex != -1) {
                  widget.orderedAnswers[dropIndex] = data.data;
                } else {
                  widget.orderedAnswers.add(data.data);
                }
              });
            },
            builder: (BuildContext context, List candidateData,
                List<dynamic> rejectedData) {
              return Column(
                children: List.generate(countList, (index) {
                  return Container(
                    margin:
                        EdgeInsets.only(bottom: 10.0, left: 6.0, right: 6.0),
                    constraints: BoxConstraints(minHeight: 40.0),
                    decoration: BoxDecoration(
                      color: widget.orderedAnswers.isNotEmpty &&
                              index < widget.orderedAnswers.length &&
                              widget.orderedAnswers[index] != null
                          ? StyleColor.turquoise
                          : Color(0XFFC4C4C4),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: widget.orderedAnswers.isNotEmpty &&
                            index < widget.orderedAnswers.length &&
                            widget.orderedAnswers[index] != null
                        ? Stack(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 0,
                                    child: Container(
                                      width: 32.0,
                                      height: 32.0,
                                      margin: EdgeInsets.only(left: 10.0),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      decoration: BoxDecoration(
                                        color: Color(
                                          int.parse(
                                              '0XFF${widget.options[index]["color"]}'),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          widget.orderedAnswers[index].option!,
                                          style: StylesApp(context)
                                              .textStyleBody12
                                              .copyWith(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                        child: Text(
                                      widget.orderedAnswers[index].answer,
                                      style: StylesApp(context).textStyleBody12,
                                    )),
                                  ),
                                ],
                              ),
                              if (index == widget.orderedAnswers.length - 1)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: SizedBox(
                                    width: 25.0,
                                    height: 25.0,
                                    child: IconButton(
                                      iconSize: 25.0,
                                      padding: EdgeInsets.all(0.0),
                                      onPressed: () {
                                        setState(() {
                                          widget.orderedAnswers.removeWhere(
                                              (element) =>
                                                  element.id ==
                                                  widget.orderedAnswers[index]
                                                      .id);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          )
                        : Container(),
                  );
                }),
              );
            },
          ),
          ButtonThemeWidget(
            width: 150.0,
            height: 27.0,
            text: "Verificar",
            buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                  backgroundColor: WidgetStatePropertyAll(
                    widget.orderedAnswers.length < countList
                        ? Color(0XFFC4C4C4)
                        : Color(0XFFF27728),
                  ),
                ),
            onPressed: widget.orderedAnswers.length < countList
                ? null
                : () {
                    widget.answerSelected(context, currentIndex);
                  },
          ),
          SizedBox(
            height: 10.0,
          ),
          Column(
            children: List.generate(
              countList,
              (index) {
                return _searchExistedOrdered(currentAnswers[index].id)
                    ? Container(
                        margin: EdgeInsets.only(
                            bottom: 10.0, left: 6.0, right: 6.0),
                        constraints: BoxConstraints(minHeight: 40.0),
                        decoration: BoxDecoration(
                          color: StyleColor.twilightBlue.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      )
                    : LongPressDraggable(
                        data: currentAnswers[index],
                        feedback: Material(
                          color: Colors.transparent,
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: 10.0, left: 6.0, right: 6.0),
                            constraints: BoxConstraints(
                                minHeight: 40.0, maxHeight: 40.0),
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            decoration: BoxDecoration(
                              color: StyleColor.starlightBlue,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 0,
                                  child: Container(
                                    width: 32.0,
                                    height: 32.0,
                                    margin: EdgeInsets.only(left: 10.0),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      color: Color(
                                        int.parse(
                                            '0XFF${widget.options[index]["color"]}'),
                                      ),
                                      borderRadius: BorderRadius.circular(32.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.options[index]["option"]!,
                                        style: StylesApp(context)
                                            .textStyleBody12
                                            .copyWith(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                      child: Text(
                                    currentAnswers[index].answer,
                                    style: StylesApp(context).textStyleBody12,
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        childWhenDragging: Container(
                          margin: EdgeInsets.only(
                              bottom: 10.0, left: 6.0, right: 6.0),
                          constraints: BoxConstraints(minHeight: 40.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: StyleColor.turquoise),
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: 10.0, left: 6.0, right: 6.0),
                          constraints: BoxConstraints(minHeight: 40.0),
                          decoration: BoxDecoration(
                            color: StyleColor.turquoise,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 0,
                                child: Container(
                                  width: 32.0,
                                  height: 32.0,
                                  margin: EdgeInsets.only(left: 10.0),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: Color(
                                      int.parse(
                                          '0XFF${widget.options[index]["color"]}'),
                                    ),
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      currentAnswers[index].option!,
                                      style: StylesApp(context)
                                          .textStyleBody12
                                          .copyWith(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                    child: Text(
                                  currentAnswers[index].answer,
                                  style: StylesApp(context).textStyleBody12,
                                )),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
          ),
        } else ...{
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white, // Color de fondo
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Sombra
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 0,
                      child: Image.asset(
                          widget.showError
                              ? "assets/fire_rachaInactive.png"
                              : "assets/fire_rachaActive.png",
                          height: 100,
                          fit: BoxFit.contain),
                    ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        textAlign: TextAlign.center,
                        widget.showError
                            ? "Respuesta\n incorrecta"
                            : "Respuesta\n Correcta",
                        style: StylesApp(context).textStyleBodyAso32.copyWith(
                            color: widget.showError
                                ? StyleColor.redLight
                                : StyleColor.turquoise),
                      ),
                    ),
                  ],
                ),
                Container(
                  // margin: EdgeInsets.symmetric(horizontal: 23),
                  decoration: BoxDecoration(
                    color: Colors.white, // Color de fondo
                    borderRadius:
                        BorderRadius.circular(10), // Bordes redondeados
                  ),
                  height: 218.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 14.0, vertical: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // Sombra
                          ),
                        ],
                      ),
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        thickness: 6.0,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 21.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  getCorrectOrderString(),
                                  style: StylesApp(context)
                                      .textStyleBodyAso20
                                      .copyWith(
                                          color: StyleColor.orange,
                                          letterSpacing: 0.6),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                ButtonThemeWidget(
                  width: 150.0,
                  height: 27.0,
                  onPressed: widget.onContinue,
                  text: "Continuar",
                  buttonStyle: StylesApp(context).btnWidgetSmall,
                  textStyle: StylesApp(context).textStyleBody6,
                ),
                SizedBox(
                  height: 17.0,
                ),
              ],
            ),
          ),
        },
      ],
    );
  }

  String getCorrectOrderString() {
    List<Answer> sortedAnswers =
        List.from(widget.orderedAnswers); // Crea una copia de la lista
    sortedAnswers
        .sort((a, b) => a.correctOrder!.compareTo(b.correctOrder as num));

    String orderedText =
        sortedAnswers.map((answer) => answer.answer).join(', ');

    return "El orden correcto de los hechos es \n$orderedText";
  }
}
