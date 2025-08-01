import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/services/audio_service.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  LoginUser? userData;
  late AudioService _audioService;
  final options = [
    {"option": "A", "color": "A8A1E7"},
    {"option": "B", "color": "C3F0F9"},
    {"option": "C", "color": "E1D8D8"},
    {"option": "D", "color": "A8B9F1"}
  ];
  bool showError = false;
  List<Question> questions = [];
  List currentAnswers = [];

  Question currentQuestion = Question(
      id: "",
      question: "",
      difficulty: "",
      status: 0,
      answers: [],
      isOrdering: false);
  bool orderedCompleted = false;
  List<Answer> orderedAnswers = [];
  int currentIndex = 0;
  int numberQuestion = 0;

  String difficulty = '';
  int failedAttempts = 3;
  String? respuestaSeleccionada;
  bool respuestaCorrecta = false;
  bool _selectionCompleted = false;
  bool _isAnswerSelected = false;
  bool _suggestionSelected = false;
  bool _isCorrect = false;
  @override
  void initState() {
    _audioService = AudioService(); // Initialize the audio service
    super.initState();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userData = userProvider.currentUser;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
              foregroundColor: WidgetStatePropertyAll(StyleColor.white)),
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pop(context);
          },
          splashColor: StyleColor.orange,
          color: StyleColor.white,
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        backgroundColor: StyleColor.turquoise,
        title: Text(
          'Prueba de Conocimientos',
          style: StylesApp(context)
              .textStyleBody16
              .copyWith(color: StyleColor.white),
        ),
      ),
      body: SafeArea(
          child: Container(
        child:
            difficulty.isEmpty ? _buildSelectedDifficulty() : _buildPlayScene(),
      )),
    );
  }

  Widget _buildSelectedDifficulty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            setState(() {
              difficulty = "F";
            });
            await loadQuestions();
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(12.0),
            constraints: BoxConstraints(minHeight: 80),
            decoration: BoxDecoration(
                color: StyleColor.white,
                border: Border.all(
                  color: StyleColor.cosmicBlue,
                  strokeAlign: 0.5,
                ),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 12,
                      offset: Offset(0, 4),
                      color: StyleColor.black.withValues(alpha: 0.25))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.face_2_rounded),
                Text(
                  "Fácil",
                  style: StylesApp(context)
                      .textStyleBody20
                      .copyWith(color: StyleColor.black),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () async {
            setState(() {
              difficulty = "I";
            });
            await loadQuestions();
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(12.0),
            constraints: BoxConstraints(minHeight: 80),
            decoration: BoxDecoration(
                color: StyleColor.white,
                border: Border.all(
                  color: StyleColor.cosmicBlue,
                  strokeAlign: 0.5,
                ),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 12,
                      offset: Offset(0, 4),
                      color: StyleColor.black.withValues(alpha: 0.25))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.face_2_rounded),
                Text(
                  "Medio",
                  style: StylesApp(context)
                      .textStyleBody20
                      .copyWith(color: StyleColor.black),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () async {
            setState(() {
              difficulty = "D";
            });
            await loadQuestions();
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(12.0),
            constraints: BoxConstraints(minHeight: 80),
            decoration: BoxDecoration(
                color: StyleColor.white,
                border: Border.all(
                  color: StyleColor.cosmicBlue,
                  strokeAlign: 0.5,
                ),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 12,
                      offset: Offset(0, 4),
                      color: StyleColor.black.withValues(alpha: 0.25))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.face_2_rounded),
                Text(
                  "Difícil",
                  style: StylesApp(context)
                      .textStyleBody20
                      .copyWith(color: StyleColor.black),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget _buildPlayScene() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Oportunidades: ",
              style: StylesApp(context)
                  .textStyleBody10
                  .copyWith(color: StyleColor.grayMedium),
            ),
            Image.asset(
              failedAttempts > 2
                  ? "assets/fire_rachaActive.png"
                  : "assets/fire_rachaInactive.png",
              width: 20,
            ),
            Image.asset(
              failedAttempts > 1
                  ? "assets/fire_rachaActive.png"
                  : "assets/fire_rachaInactive.png",
              width: 20,
            ),
            Image.asset(
              failedAttempts > 0
                  ? "assets/fire_rachaActive.png"
                  : "assets/fire_rachaInactive.png",
              width: 20,
            ),
          ],
        ),
        SizedBox(
          height: 45,
        ),
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
                  color: Colors.black.withValues(alpha: .25),
                  offset: Offset(0.0, 4.0),
                  blurStyle: BlurStyle.outer,
                  blurRadius: 4.0)
            ],
          ),
          child: Text(
            currentQuestion.question,
            style: StylesApp(context)
                .textStyleBody12
                .copyWith(color: Colors.black),
          ),
        ),
        SizedBox(
          height: 38.0,
        ),
        if (questions.isNotEmpty)
          Expanded(
            flex: !currentQuestion.isOrdering ? 3 : 2,
            child: Column(
              children: [
                if (currentQuestion.isOrdering) ...{
                  OrderingQuestionDraggableWidget(
                    orderedCompleted: orderedCompleted,
                    orderedAnswers: orderedAnswers,
                    currentQuestion: currentQuestion,
                    options: options,
                    answerSelected: (context, index) =>
                        verifyOrdered(context, index),
                    showError: showError,
                    onContinue: funcAnswerValidate,
                  )
                } else ...{
                  if (options.isNotEmpty)
                    Expanded(
                      flex: 3,
                      child: SelectionQuestionWidget(
                        suggestionSelected: _suggestionSelected,
                        selectionCompleted: _selectionCompleted,
                        isCorrect: _isCorrect,
                        currentQuestion: currentQuestion,
                        options: options,
                        answerSelected: (context, index) {
                          _answerSelected(context, index);
                        },
                        callBackContinue: () async {
                          // await funcAnswerValidate();
                        },
                        isAnswerSelected: _isAnswerSelected,
                      ),
                    ),
                },
                SizedBox(
                  height: 47.0,
                ),
              ],
            ),
          ),
        Expanded(
          flex: !currentQuestion.isOrdering ? 1 : 0,
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 278.0),
              child: Column(
                children: [
                  Text(
                    "${currentIndex + 1}/${questions.length}",
                    style: StylesApp(context)
                        .textStyleBody12
                        .copyWith(color: Colors.black),
                  ),
                  LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(6.0),
                    minHeight: 14.0,
                    value: currentIndex / (questions.length - 1),
                    backgroundColor: Color(0xFFC4C4C4),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0XFFF27728),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (currentQuestion.isOrdering)
          SizedBox(
            height: 20,
          )
      ],
    );
  }

  void verifyOrdered(BuildContext context, int index) {
    bool isCorrectOrder = true;
    for (int i = 0; i < orderedAnswers.length; i++) {
      if (orderedAnswers[i].correctOrder != i + 1) {
        isCorrectOrder = false;
        break;
      }
    }

    if (isCorrectOrder) {
      _audioService.playCorrectAnswer();
      setState(() {
        showError = false;
      });
    } else {
      _audioService.playWrongAnswer();
      setState(() {
        showError = true;
        failedAttempts -= 1;
      });
    }
    setState(() {
      orderedCompleted = true;
    });
  }

  funcAnswerValidate() async {
    if (failedAttempts > 0 && currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        orderedCompleted = false;
        _selectionCompleted = false;
        currentQuestion = questions[currentIndex];
        numberQuestion = currentIndex + 1;
        currentAnswers = questions[currentIndex].answers;
        orderedAnswers.clear();
      });
    } else {
      // si falle 3 o mas veces muestro modal de inténtalo de nuevo
      if (failedAttempts == 0) {
        await _audioService.playFailedAttempts();
        _showDialogFailedAttempts();
      } else {
        _audioService.playWinSound();
        _showDialogFinallyPlay();
      }
    }
    setState(() {
      _isAnswerSelected = false;
      _suggestionSelected = false;
    });
  }

  void _answerSelected(BuildContext context, int index) async {
    setState(() {
      _isAnswerSelected = true;
      _suggestionSelected = false;
    });
    _isCorrect =
        (currentAnswers.isNotEmpty) ? currentAnswers[index].isCorrect : false;

    if (!_isCorrect) {
      await _audioService.playWrongAnswer();
      setState(() {
        _suggestionSelected = true;
        failedAttempts -= 1;
      });
    } else {
      setState(() {
        _suggestionSelected = true;
      });
      await _audioService.playCorrectAnswer();
    }
    setState(() {
      _selectionCompleted = true;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(hours: 24),
        content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
          children: [
            Icon(
            _isCorrect ? Icons.check_circle : Icons.error,
            color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
            _isCorrect ? '¡Muy bien!' : '¡Oh, lo siento!',
            style: StylesApp(context).textStyleBody12,
            ),
          ],
          ),
          // botón de siguiente
          TextButton(
          onPressed: () async {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            await funcAnswerValidate();
          },
          child: Text(
            'Siguiente',
            style: StylesApp(context)
              .textStyleBody12
              .copyWith(color: Colors.white),
          ),
          ),
        ],
        ),
        backgroundColor: _isCorrect ? Colors.green : Colors.red,
      ),
      );
    }
  }

  Future<void> loadQuestions() async {
    LoadingService().showLoading(context);
    try {
      // obtenemos las preguntas
      final ResponseData questionResponse =
          await getQuestionGameDifficulty(difficulty);

      if (questionResponse.error != null) {
        LoadingService().hideLoading();
        LoadingService().hideLoading();
        await showCustomDialogWithAction(context,
            message: questionResponse.error!,
            dialogType: DialogTypeAction.error,
            buttonOk: "Ok", actionCallbackOk: () {
          Navigator.pop(context);
        });
        setState(() {
          difficulty = '';
        });
        return;
      }
      setState(() {
        questions = questionResponse.data
            .map((question) => Question.fromJson(removeTypename(question)))
            .cast<Question>()
            .toList();

        for (int i = 0; i < questions.length; i++) {
          for (int j = 0; j < questions[i].answers.length; j++) {
            questions[i].answers[j].option = options[j]["option"];
          }
        }
        currentQuestion = questions[currentIndex];
        numberQuestion = currentIndex + 1;
        currentAnswers = questions[currentIndex].answers;
      });
      LoadingService().hideLoading();
    } catch (e) {
      LoadingService().hideLoading();
      await showCustomDialogWithAction(context,
          message: e.toString(),
          dialogType: DialogTypeAction.error,
          buttonOk: "Ok", actionCallbackOk: () {
        Navigator.pop(context);
      });
      setState(() {
        difficulty = '';
      });
      return;
    } finally {
      LoadingService().hideLoading();
    }
  }

  void _showDialogFailedAttempts() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¡Oportunidades Agotadas!'),
        content: const Text(
            'Haz Fallado Los Intentos Permitidos. ¿Quieres intentarlo de nuevo?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                difficulty = '';
                failedAttempts = 3;
                respuestaSeleccionada = '';
                questions = [];
                currentQuestion = Question(
                    id: "",
                    question: "",
                    difficulty: difficulty,
                    status: 1,
                    answers: [],
                    isOrdering: false);
              });
              currentAnswers = [];
              currentIndex = 0;
            },
            child: const Text('Jugar de nuevo'),
          ),
        ],
      ),
    );
  }

  void _showDialogFinallyPlay() async {
    LoadingService().showLoading(context);
    String tipo = '';
    if (difficulty == 'F') {
      tipo = 'Facil';
    } else if (difficulty == 'I') {
      tipo = 'Medio';
    } else {
      tipo = 'Difícil';
    }
    try {
      final responseSaveResult =
          await saveResultPlay(userData!.userId, tipo, 'preguntas');
      if (responseSaveResult.error != null) {
        LoadingService().hideLoading();
        await showCustomDialogWithAction(context,
            message: responseSaveResult.error!,
            dialogType: DialogTypeAction.error,
            buttonOk: "Volver",
            actionCallbackOk: () {
              Navigator.pop(context);
            },
            textButton: "Reintentar",
            actionCallback: () {
              _showDialogFinallyPlay();
            });
        return;
      }

      final responseResult =
          await getAllResultGame(userData?.userId, 'preguntas');
      if (responseResult.error != null) {
        LoadingService().hideLoading();
        await showCustomDialogWithAction(context,
            message: responseSaveResult.error!,
            dialogType: DialogTypeAction.error,
            buttonOk: "Volver",
            actionCallbackOk: () {
              Navigator.pop(context);
            },
            textButton: "Reintentar",
            actionCallback: () {
              _showDialogFinallyPlay();
            });
        return;
      }
      LoadingService().hideLoading();

      final ResultGameModel infoResult =
          ResultGameModel.fromJson(responseResult.data);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("${infoResult.message.resultTitle}"),
          content: Column(
            children: [
              Text(
                "${infoResult.message.resultDescription}",
                style: StylesApp(context)
                    .textStyleBody16
                    .copyWith(color: StyleColor.black),
              ),
              Text(
                  "Categoría:  ${infoResult.message.category} Dificultad: ${infoResult.message.difficulty}"),
              Text("Puntaje obtenido:  ${infoResult.score}")
            ],
          ),
          actions: [
            ButtonThemeWidget(
              text: "Jugar de nuevo",
              buttonStyle: StylesApp(context).btnWidgetSmall,
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  difficulty = '';
                  failedAttempts = 3;
                  respuestaSeleccionada = '';
                });
              },
            )
          ],
        ),
      );
    } catch (e) {
      LoadingService().hideLoading();
      await showCustomDialogWithAction(context,
          message: e.toString(),
          dialogType: DialogTypeAction.error,
          buttonOk: "Volver",
          actionCallbackOk: () {
            Navigator.pop(context);
          },
          textButton: "Reintentar",
          actionCallback: () {
            _showDialogFinallyPlay();
          });
    } finally {
      LoadingService().hideLoading();
    }
  }
}
