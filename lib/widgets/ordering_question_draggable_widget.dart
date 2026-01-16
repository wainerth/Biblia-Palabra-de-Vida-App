import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class OrderingQuestionDraggableWidget extends StatefulWidget {
  final bool orderedCompleted;
  final Question currentQuestion;
  final List<Answer> orderedAnswers;
  final bool showError;
  final double fontSize;
  final List<Map<String, String>> options;
  final Function(BuildContext context, int) answerSelected;
  final Function()? onContinue;
  final bool isTablet;

  const OrderingQuestionDraggableWidget({
    super.key,
    required this.orderedCompleted,
    required this.orderedAnswers,
    required this.currentQuestion,
    required this.options,
    required this.answerSelected,
    required this.showError,
    this.fontSize = 14.0,
    this.onContinue,
    this.isTablet = false,
  });

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
    
    // Si es tablet y está completada, mostrar diseño especial
    if (widget.isTablet && widget.orderedCompleted) {
      return _buildTabletCompletedLayout();
    }
    
    return Container(
      padding: widget.isTablet ? EdgeInsets.all(16.0) : EdgeInsets.zero,
      child: Column(
        children: [
          if (widget.isTablet && !widget.orderedCompleted) ...{
            Container(
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                color: StyleColor.turquoise.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: StyleColor.turquoise,
                  width: 2.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.drag_handle,
                    color: StyleColor.turquoise,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Arrastra las respuestas a los espacios vacíos",
                    style: StylesApp(context).textStyleBody16.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          },
          
          if (!widget.orderedCompleted) ...{
            // Área de destino para arrastrar (en tablet se muestra horizontalmente)
            widget.isTablet 
                ? _buildTabletDragTargetArea() 
                : _buildMobileDragTargetArea(),
                
            SizedBox(height: widget.isTablet ? 24.0 : 10.0),
            
            // Botón de verificar
            ButtonThemeWidget(
              width: widget.isTablet ? 200.0 : 150.0,
              height: widget.isTablet ? 40.0 : 27.0,
              text: "Verificar Orden",
              buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                backgroundColor: WidgetStatePropertyAll(
                  widget.orderedAnswers.length < countList
                      ? StyleColor.grayMedium
                      : StyleColor.orange,
                ),
              ),
              onPressed: widget.orderedAnswers.length < countList
                  ? null
                  : () {
                      widget.answerSelected(context, currentIndex);
                    },
            ),
            
            SizedBox(height: widget.isTablet ? 24.0 : 10.0),
            
            // Opciones para arrastrar (en tablet se muestra en grid)
            widget.isTablet 
                ? _buildTabletDraggableOptions() 
                : _buildMobileDraggableOptions(),
          } else ...{
            // Para móvil, mantener el diseño original
            if (!widget.isTablet) _buildMobileCompletedLayout(),
          },
        ],
      ),
    );
  }

  // ========== MÉTODOS PARA TABLET ==========

  Widget _buildTabletDragTargetArea() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: StyleColor.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: StyleColor.turquoise,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Orden Actual",
            style: StylesApp(context).textStyleBody16.copyWith(
                  fontWeight: FontWeight.bold,
                  color: StyleColor.turquoise,
                ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: List.generate(countList, (index) {
              return DragTarget<Answer>(
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
                  return Container(
                    width: widget.isTablet ? 220 : null,
                    height: widget.isTablet ? 60 : 40,
                    decoration: BoxDecoration(
                      color: widget.orderedAnswers.isNotEmpty &&
                              index < widget.orderedAnswers.length &&
                              widget.orderedAnswers[index] != null
                          ? StyleColor.turquoise
                          : Color(0XFFC4C4C4).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: widget.orderedAnswers.isNotEmpty &&
                                index < widget.orderedAnswers.length &&
                                widget.orderedAnswers[index] != null
                            ? StyleColor.turquoise
                            : Colors.grey[300]!,
                        width: 2.0,
                      ),
                    ),
                    child: widget.orderedAnswers.isNotEmpty &&
                            index < widget.orderedAnswers.length &&
                            widget.orderedAnswers[index] != null
                        ? Stack(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: widget.isTablet ? 40 : 32,
                                    height: widget.isTablet ? 40 : 32,
                                    margin: EdgeInsets.only(left: 8.0),
                                    decoration: BoxDecoration(
                                      color: Color(
                                        int.parse(
                                            '0XFF${widget.options[index]["color"]}'),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.orderedAnswers[index].option!,
                                        style: StylesApp(context)
                                            .textStyleBody14
                                            .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 30),
                                      child: Text(
                                        widget.orderedAnswers[index].answer,
                                        style: StylesApp(context)
                                            .textStyleBody14
                                            .copyWith(
                                              fontSize: widget.isTablet ? 16 : widget.fontSize,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                right: 4,
                                top: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.orderedAnswers.removeWhere(
                                          (element) =>
                                              element.id ==
                                              widget.orderedAnswers[index].id);
                                    });
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: StyleColor.redDark,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.grey[400],
                              size: widget.isTablet ? 32 : 24,
                            ),
                          ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletDraggableOptions() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: StyleColor.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: StyleColor.cosmicBlue,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Opciones Disponibles",
            style: StylesApp(context).textStyleBody16.copyWith(
                  fontWeight: FontWeight.bold,
                  color: StyleColor.cosmicBlue,
                ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: List.generate(
              countList,
              (index) {
                return _searchExistedOrdered(currentAnswers[index].id)
                    ? Container() // Ocultar opciones ya seleccionadas
                    : LongPressDraggable(
                        data: currentAnswers[index],
                        feedback: Material(
                          color: Colors.transparent,
                          child: Container(
                            width: widget.isTablet ? 220 : null,
                            height: widget.isTablet ? 60 : 40,
                            decoration: BoxDecoration(
                              color: StyleColor.starlightBlue,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: widget.isTablet ? 40 : 32,
                                  height: widget.isTablet ? 40 : 32,
                                  margin: EdgeInsets.only(left: 8.0),
                                  decoration: BoxDecoration(
                                    color: Color(
                                      int.parse(
                                          '0XFF${widget.options[index]["color"]}'),
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.options[index]["option"]!,
                                      style: StylesApp(context)
                                          .textStyleBody14
                                          .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    currentAnswers[index].answer,
                                    style: StylesApp(context)
                                        .textStyleBody14
                                        .copyWith(
                                          fontSize: widget.isTablet ? 16 : widget.fontSize,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        childWhenDragging: Container(
                          width: widget.isTablet ? 220 : null,
                          height: widget.isTablet ? 60 : 40,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: StyleColor.turquoise,
                              width: 2.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: Container(
                          width: widget.isTablet ? 220 : null,
                          height: widget.isTablet ? 60 : 40,
                          decoration: BoxDecoration(
                            color: StyleColor.turquoise,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: widget.isTablet ? 40 : 32,
                                height: widget.isTablet ? 40 : 32,
                                margin: EdgeInsets.only(left: 8.0),
                                decoration: BoxDecoration(
                                  color: Color(
                                    int.parse(
                                        '0XFF${widget.options[index]["color"]}'),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    currentAnswers[index].option!,
                                    style: StylesApp(context)
                                        .textStyleBody14
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  currentAnswers[index].answer,
                                  style: StylesApp(context)
                                      .textStyleBody14
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: widget.isTablet ? 16 : widget.fontSize,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletCompletedLayout() {
    return Container(
      padding: EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono y título
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: widget.showError
                  ? StyleColor.redLight.withOpacity(0.1)
                  : StyleColor.greenDark.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: widget.showError
                    ? StyleColor.redLight
                    : StyleColor.greenDark,
                width: 2.0,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  widget.showError ? Icons.cancel : Icons.check_circle,
                  size: 64,
                  color: widget.showError
                      ? StyleColor.redLight
                      : StyleColor.greenDark,
                ),
                SizedBox(height: 12),
                Text(
                  widget.showError
                      ? "Respuesta Incorrecta"
                      : "¡Respuesta Correcta!",
                  style: StylesApp(context).textStyleBody24.copyWith(
                        color: widget.showError
                            ? StyleColor.redLight
                            : StyleColor.greenDark,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24),
          
          // Explicación del orden correcto
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: StyleColor.blueLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: StyleColor.cosmicBlue,
                width: 2.0,
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Orden Correcto",
                  style: StylesApp(context).textStyleBody20.copyWith(
                        color: StyleColor.cosmicBlue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 16),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i < widget.orderedAnswers.length; i++)
                          Container(
                            margin: EdgeInsets.only(bottom: 12.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: StyleColor.turquoise,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Color(
                                      int.parse(
                                          '0XFF${widget.options[i]["color"]}'),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      (i + 1).toString(),
                                      style: StylesApp(context)
                                          .textStyleBody14
                                          .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    widget.orderedAnswers[i].answer,
                                    style: StylesApp(context)
                                        .textStyleBody16
                                        .copyWith(
                                          color: Colors.black,
                                          height: 1.4,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  getCorrectOrderString(),
                  style: StylesApp(context).textStyleBody16.copyWith(
                        color: StyleColor.orange,
                        fontStyle: FontStyle.italic,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24),
          
          // Botón de continuar
          if (widget.onContinue != null)
            ButtonThemeWidget(
              text: "Continuar",
              width: 200,
              height: 50,
              buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                backgroundColor: WidgetStatePropertyAll(
                  widget.showError ? StyleColor.orange : StyleColor.greenDark,
                ),
              ),
              onPressed: widget.onContinue,
            ),
        ],
      ),
    );
  }

  // ========== MÉTODOS PARA MÓVIL (mantener original) ==========

  Widget _buildMobileDragTargetArea() {
    return DragTarget<Answer>(
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
              margin: EdgeInsets.only(bottom: 10.0, left: 6.0, right: 6.0),
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
                                style: StylesApp(context)
                                    .textStyleBody12
                                    .copyWith(fontSize: widget.fontSize),
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
                                            widget.orderedAnswers[index].id);
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
    );
  }

  Widget _buildMobileDraggableOptions() {
    return Column(
      children: List.generate(
        countList,
        (index) {
          return _searchExistedOrdered(currentAnswers[index].id)
              ? Container(
                  margin: EdgeInsets.only(bottom: 10.0, left: 6.0, right: 6.0),
                  constraints: BoxConstraints(minHeight: 40.0),
                  decoration: BoxDecoration(
                    color:
                        StyleColor.twilightBlue.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                )
              : LongPressDraggable(
                  data: currentAnswers[index],
                  feedback: Material(
                    color: Colors.transparent,
                    child: Container(
                      margin:
                          EdgeInsets.only(bottom: 10.0, left: 6.0, right: 6.0),
                      constraints:
                          BoxConstraints(minHeight: 40.0, maxHeight: 40.0),
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
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                              style: StylesApp(context)
                                  .textStyleBody12
                                  .copyWith(fontSize: widget.fontSize),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    margin:
                        EdgeInsets.only(bottom: 10.0, left: 6.0, right: 6.0),
                    constraints: BoxConstraints(minHeight: 40.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: StyleColor.turquoise),
                    ),
                  ),
                  child: Container(
                    margin:
                        EdgeInsets.only(bottom: 10.0, left: 6.0, right: 6.0),
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
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
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
    );
  }

  Widget _buildMobileCompletedLayout() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 218.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                margin:
                    EdgeInsets.symmetric(horizontal: 14.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
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
                        SizedBox(height: 21.0),
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
          SizedBox(height: 16.0),
          ButtonThemeWidget(
            width: 150.0,
            height: 27.0,
            onPressed: widget.onContinue,
            text: "Continuar",
            buttonStyle: StylesApp(context).btnWidgetSmall,
            textStyle: StylesApp(context).textStyleBody6,
          ),
          SizedBox(height: 17.0),
        ],
      ),
    );
  }

  String getCorrectOrderString() {
    List<Answer> sortedAnswers = List.from(widget.orderedAnswers);
    sortedAnswers
        .sort((a, b) => a.correctOrder!.compareTo(b.correctOrder as num));

    String orderedText =
        sortedAnswers.map((answer) => answer.answer).join(', ');

    return "El orden correcto de los hechos es \n$orderedText";
  }
}