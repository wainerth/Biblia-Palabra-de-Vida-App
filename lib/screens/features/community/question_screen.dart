import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  static const MAX_SCORE = 150;
  static const MEDIUM_SCORE = 100;
  static const LOOW_SCORE = 50;
  LoginUser? userData;
  int currentIndex = 0;
  bool showError = false;
  bool suggestionSelected = false;
  var selectedOption;
  bool isLoading = true;
  String? errorMessage;
  Stage? stage;
  Level? level;
  late Question currentQuestion;
  List currentAnswers = [];

  List<Question> questions = [];
  final options = [
    {"option": "A", "color": "A8A1E7"},
    {"option": "B", "color": "C3F0F9"},
    {"option": "C", "color": "E1D8D8"},
    {"option": "D", "color": "A8B9F1"}
  ];
  int failedAttempts = 0;
  double score = 0;
  bool _isAnswerSelected = false;
  int _selectedAnswerIndex = -1;
  bool isOrdering = false;
  List<UserResponses>? responses = [];
  String imgBack = "";

//draggable variables
  bool orderedCompleted = false;
  List<Answer> orderedAnswers = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateData(context);
    });
  }

  Future<void> _generateData(BuildContext context) async {
    LoadingService().showLoading(context);

    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      try {
        final String levelId = args['levelId'];
        final String sectionId = args['sectionId'];
        setState(() {});

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        // obtenemos sección
        final ResponseData stageResponse = await loadStageById(levelId);

        if (stageResponse.error != null) {
          errorMessage = stageResponse.error;
        }
        stage = Stage.fromJson(stageResponse.data);
        // obtenemos el nivel
        final levelResponse = await loadOneLevel(levelId);

        if (levelResponse.error != null) {
          errorMessage = levelResponse.error;
        }
        level = Level.fromJson(levelResponse.data);

        // obtenemos las preguntas
        final ResponseData questionResponse =
            await loadQuestionByStory(levelId);

        if (questionResponse.error != null) {
          errorMessage = questionResponse.error;
        }
        setState(() {
          questions = questionResponse.data
              .map((question) => Question.fromJson(removeTypename(question)))
              .cast<Question>()
              .toList();

          currentQuestion = questions[currentIndex];
          currentAnswers = questions[currentIndex].answers;
          for (int i = 0; i < currentAnswers.length; i++) {
            currentAnswers[i].option = options[i]["option"];
          }
        });
      } catch (e) {
        errorMessage = "An error occurred: $e";
      } finally {
        LoadingService().hideLoading();
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _answerSelected(BuildContext context, int index) {
    setState(() {
      _isAnswerSelected = true;
      _selectedAnswerIndex = index;
    });
    bool isCorrect = currentAnswers[index].isCorrect;
    responses!.add(UserResponses(
      answerId: currentAnswers[index].id,
      questionId: currentQuestion.id,
      userId: userData!.user.id,
    ));

    if (!isCorrect) {
      setState(() {
        suggestionSelected = true;

        failedAttempts += 1;
      });
    } else {
      setState(() {
        suggestionSelected = false;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(hours: 24),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.error,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  isCorrect ? '¡Muy bien!' : '¡Oh, lo siento!',
                  style: StylesApp(context).textStyleBody12,
                ),
              ],
            ),
            TextButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                // setState(() async {
                if (currentIndex < questions.length - 1) {
                  setState(() {
                    currentIndex++;
                    currentQuestion = questions[currentIndex];
                    currentAnswers = currentQuestion.answers;
                  });
                } else {
                  //llamamos servicio de respuestas
                  print("paso por aquí");
                  final ResponseData responseSendResponses =
                      await sendResponsesUser(responses!);
                  if (responseSendResponses.error != null) {
                    await showCustomDialog(context,
                        message: responseSendResponses.error!,
                        dialogType: DialogType.error);
                  }
                  // lamamos al servicios que nos registra el score
                  final ResponseData sendScoreResponse = await sendScoreUser(
                      userData!.user.id, level!.id, failedAttempts);
                  if (sendScoreResponse.error != null) {
                    await showCustomDialog(context,
                        message: sendScoreResponse.error!,
                        dialogType: DialogType.error);
                  }
                  bool isLastLevel = sendScoreResponse.data['isLastLevel'];
                  if (isLastLevel) {
                    // mostrar modal de seccion completada
                  } else {
                    // consultamos ultimo progreso en el nivel
                    final ResponseData progressLevelResponse =
                        await lastLevelProgressUser(
                            userData!.user.id, level!.id);
                    if (progressLevelResponse.error != null) {
                      await showCustomDialog(context,
                          message: progressLevelResponse.error!,
                          dialogType: DialogType.error);
                    }
                    final data =
                        LevelProgressUser.fromJson(progressLevelResponse.data);
                    _showDialog(context, data);
                  }
                }
                setState(() {
                  _isAnswerSelected = false;
                  suggestionSelected = false;
                  _selectedAnswerIndex = -1;
                });
                // });
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
        backgroundColor: isCorrect ? Colors.green : Colors.red,
      ),
    );
    // _showDialog(context);
    Future.delayed(Duration(seconds: 2), () {
      // Lógica para pasar a la siguiente pregunta
      // setState(() {
      //   if (currentIndex < currentQuestion.answers.length) {
      //     currentIndex++;
      //     if (currentIndex == currentQuestion.answers.length) {
      //       _showDialog(context);
      //     }
      //   }
      //   _isAnswerSelected = false;
      //   suggestionSelected = false;
      //   _selectedAnswerIndex = -1;
      // });
    });
  }

  void verifyOrdered(BuildContext context, int index) {
    bool isCorrectOrder = true;
    for (int i = 0; i < orderedAnswers.length; i++) {
      if (orderedAnswers[i].orderInAnswer != i + 1) {
        isCorrectOrder = false;
        break;
      }
    }

    if (isCorrectOrder) {
      score += 30;
      showError = false;
    } else {
      showError = true;
    }
    setState(() {
      orderedCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<UserProvider>(context, listen: false).currentUser;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              if (isLoading) ...{
                Container()
              } else ...{
                if (errorMessage != null) ...{
                  BuildErrorWidget(
                    errorMessage: errorMessage!,
                    onRetry: () async => _generateData(context),
                    onBack: () => Navigator.pop(context),
                  )
                } else ...{
                  Column(
                    children: <Widget>[
                      HeaderNotDetailsStageWidget(
                        title: "Conoce el Antiguo Testamento",
                        stage: stage!.id,
                        subtitle: stage!.sectionName,
                        details: stage,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        padding:
                            EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        width: double.infinity,
                        height: 25.0,
                        decoration: BoxDecoration(
                            color: StyleColor.orange,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          "Paso 1 ${level!.name}",
                          style: StylesApp(context).textStyleBody5,
                        ),
                      ),
                      SizedBox(
                        height: 19.0,
                      ),
                      Container(
                        constraints: BoxConstraints(minHeight: 68.0),
                        margin: EdgeInsets.symmetric(horizontal: 6.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 11.0, vertical: 15.0),
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
                    ],
                  ),
                  // we show  question and answer or ordering
                  Expanded(
                    flex: isOrdering ? 3 : 2,
                    child: Column(
                      children: [
                        if (!isOrdering) ...{
                          OrderingQuestionDraggableWidget(
                            orderedCompleted: orderedCompleted,
                            orderedAnswers: orderedAnswers,
                            currentQuestion: currentQuestion,
                            options: options,
                            answerSelected: (context, index) {
                              verifyOrdered(context, index);
                            },
                            showError: showError,
                            onContinue: () async {
                              if (currentIndex < questions.length - 1) {
                                setState(() {
                                  currentIndex++;
                                  orderedCompleted = false;
                                  currentQuestion = questions[currentIndex];
                                  orderedAnswers.clear();
                                });
                              } else {
                                //llamamos servicio de respuestas
                                print("paso por aquí");
                                final ResponseData responseSendResponses =
                                    await sendResponsesUser(responses!);
                                if (responseSendResponses.error != null) {
                                  await showCustomDialog(context,
                                      message: responseSendResponses.error!,
                                      dialogType: DialogType.error);
                                }
                                // lamamos al servicios que nos registra el score
                                final ResponseData sendScoreResponse =
                                    await sendScoreUser(userData!.user.id,
                                        level!.id, failedAttempts);
                                if (sendScoreResponse.error != null) {
                                  await showCustomDialog(context,
                                      message: sendScoreResponse.error!,
                                      dialogType: DialogType.error);
                                }
                                bool isLastLevel =
                                    sendScoreResponse.data['isLastLevel'];
                                if (isLastLevel) {
                                  // mostrar modal de seccion completada
                                } else {
                                  // consultamos ultimo progreso en el nivel
                                  final ResponseData progressLevelResponse =
                                      await lastLevelProgressUser(
                                          userData!.user.id, level!.id);
                                  if (progressLevelResponse.error != null) {
                                    await showCustomDialog(context,
                                        message: progressLevelResponse.error!,
                                        dialogType: DialogType.error);
                                  }
                                  final data = LevelProgressUser.fromJson(
                                      progressLevelResponse.data);
                                  _showDialog(context, data);
                                }
                              }
                              setState(() {
                                _isAnswerSelected = false;
                                suggestionSelected = false;
                                _selectedAnswerIndex = -1;
                              });
                            },
                          )
                        } else ...{
                          Expanded(
                            flex: 3,
                            child: SelectionQuestionWidget(
                              currentQuestion: currentQuestion,
                              options: options,
                              answerSelected: (context, index) {
                                _answerSelected(context, index);
                              },
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
                    flex: isOrdering ? 1 : 0,
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 278.0),
                        child: Column(
                          children: [
                            Text(
                              "${currentIndex + 1}/${currentAnswers.length}",
                              style: StylesApp(context)
                                  .textStyleBody12
                                  .copyWith(color: Colors.black),
                            ),
                            LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(6.0),
                              minHeight: 14.0,
                              value: currentIndex / (currentAnswers.length - 1),
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
                  if (!isOrdering)
                    SizedBox(
                      height: 20,
                    )
                },
              },
            ],
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context, LevelProgressUser data) {
    if (data.score > MEDIUM_SCORE) {
      setState(() {
        imgBack = "assets/boxStartFull.png";
      });
    } else if (data.score < MEDIUM_SCORE && data.score > LOOW_SCORE) {
      setState(() {
        imgBack = "assets/boxStartMedium.png";
      });
    } else if (data.score < LOOW_SCORE && data.score > 0) {
      setState(() {
        imgBack = "assets/boxStartLow.png";
      });
    } else {
      setState(() {
        imgBack = "assets/boxStartFailed.png";
      });
    }
    return showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(imgBack),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: data.score > 0 ? 100 : 33.0,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      data.message.resultTitle,
                      // data['score'] > 0 ? 'Felicitaciones' : "Ya casi lo\n logras! ",
                      style: StylesApp(context)
                          .textStyleCongratulation
                          .copyWith(color: Colors.white),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      score > 0
                          ? 'Culminaste el Paso ${data.level.id}'
                          : "Intenta nuevamente el\n Paso ${data.level.id} para avanzar",
                      style: StylesApp(context).textStyleWithe20,
                    ),
                    if (score > 0) ...{
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        'Haz ganado\n ${data.score} LMs de energía',
                        style: StylesApp(context).textStyleWithe20,
                      ),
                    },
                    SizedBox(
                      height: 37.0,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (score < MEDIUM_SCORE && score >= LOOW_SCORE) ...{
                    SizedBox(
                      height: 23.0,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      score > 0
                          ? "Puedes repetir el paso para\n tratar de ganar 3 estrellas"
                          : "En toda labor hay fruto.",
                      style: StylesApp(context)
                          .textStyleBodyAso20
                          .copyWith(color: Color(0XFFFD8C43)),
                    ),
                  },
                  Image.asset(
                    "assets/kawaii_fire.png",
                    height: calculateHeight(score),
                    fit: BoxFit.contain,
                  ),
                  Text(
                    "${score.toStringAsFixed(0)} lms",
                    style: StylesApp(context)
                        .textStyleBody20
                        .copyWith(color: Color(0XFFFD8C43)),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  ButtonThemeWidget(
                    text: "Continuar",
                    width: 132.0,
                    height: 32.0,
                    buttonStyle: StylesApp(context).btnWidgetSmall,
                    onPressed: () {
                      Navigator.popAndPushNamed(context, "/mapPage");
                    },
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  double calculateHeight(double score) {
    score = score.abs();

    double maxPossibleHeight = score / 1000 * 112;

    if (score >= MAX_SCORE) {
      return 112; // Alto fijo cuando los puntos son mayores o iguales a 1000
    } else {
      double width = ((maxPossibleHeight * 100)) / 112;

      return width > 30 ? ((maxPossibleHeight * 100)) / 112 : 40;
    }
  }
}

// widget de selección
