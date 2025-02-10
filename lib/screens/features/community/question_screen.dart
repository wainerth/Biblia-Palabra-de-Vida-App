import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int currentIndex = 0;
  bool showError = false;
  bool suggestionSelected = false;
  var selectedOption;
  late Question currentQuestion;
  List currentAnswers = [];

  Stage stage = Stage(
      id: "1",
      sectionName: "Genesis",
      introduction:
          "¿Te gustaría conocer el origen de todo lo que existe, desde el universo hasta la humanidad? En Génesis encontrarás relatos fascinantes sobre la creación, el diluvio, la torre de Babel, la llamada de Abraham, el sacrificio de Isaac, la traición de Jacob, el sueño de José, y mucho más. También se demuestra el carácter de Dios, su amor, su justicia, su fidelidad y su poder. Este es solo el comienzo de grandes historias que continúan en el resto de la Biblia y que te motiva a ser parte de ella. Te invito a leerlo y a descubrir cómo Dios te habla a través de su palabra, ¿Estás listo?",
      unLockSection: true,
      orderCard: 1,
      color: "3ae4e4",
      img: Img(urlImg: "assets/assetStories.png"),
      levelCount: 12,
      levelCompletedCount: 0,
      status: 1);
  Level level = Level(
    id: "1",
    name: "La creación",
    unLockLevel: true,
    color: "3ae4e4",
    section: Section(sectionName: "Genesis"),
    img: Img(urlImg: "assets/level.png"),
  );

  // Question By level
  List<Question> questions = [
    {
      "id": "2",
      "question": "¿Qué hizo Dios en el primer día de la creación?",
      "difficulty": "I",
      "level": {"levelNumber": 1},
      "status": 1,
      "answers": [
        {
          "id": "8",
          "answer": "Creó las plantas y los árboles",
          "isCorrect": false,
          "questionId": "2",
          "scoreForAnswer": 0,
          "orderInAnswer": 2,
          "status": 1
        },
        {
          "id": "6",
          "answer": "Creó la luz y la separó de la oscuridad",
          "isCorrect": true,
          "questionId": "2",
          "scoreForAnswer": 7,
          "orderInAnswer": 4,
          "status": 1
        },
        {
          "id": "5",
          "answer": "Creó el cielo y la tierra",
          "isCorrect": false,
          "questionId": "2",
          "scoreForAnswer": 0,
          "orderInAnswer": 1,
          "status": 1
        },
        {
          "id": "7",
          "answer": "Creó el sol, la luna y las estrellas",
          "isCorrect": false,
          "questionId": "2",
          "scoreForAnswer": 0,
          "orderInAnswer": 3,
          "status": 1
        }
      ]
    },
    {
      "id": "5",
      "question":
          "¿Qué tipo de vida creó Dios en el quinto día de su creación?",
      "difficulty": "I",
      "level": {"levelNumber": 1},
      "status": 1,
      "answers": [
        {
          "id": "19",
          "answer": "Plantas, arbustos y árboles",
          "isCorrect": false,
          "questionId": "5",
          "scoreForAnswer": 0,
          "orderInAnswer": 4,
          "status": 1
        },
        {
          "id": "20",
          "answer": "Ángeles y demonios",
          "isCorrect": false,
          "questionId": "5",
          "scoreForAnswer": 0,
          "orderInAnswer": 1,
          "status": 1
        },
        {
          "id": "17",
          "answer": "Especies marinas y aves",
          "isCorrect": true,
          "questionId": "5",
          "scoreForAnswer": 7,
          "orderInAnswer": 3,
          "status": 1
        },
        {
          "id": "18",
          "answer": "Animales terrestres y humanos",
          "isCorrect": false,
          "questionId": "5",
          "scoreForAnswer": 0,
          "orderInAnswer": 2,
          "status": 1
        }
      ]
    },
    {
      "id": "3",
      "question":
          "¿Qué nombre le dio Dios a la expansión que separó las aguas en el segundo día? ",
      "difficulty": "D",
      "level": {"levelNumber": 1},
      "status": 1,
      "answers": [
        {
          "id": "12",
          "answer": "Nube",
          "isCorrect": false,
          "questionId": "3",
          "scoreForAnswer": 0,
          "orderInAnswer": 1,
          "status": 1
        },
        {
          "id": "9",
          "answer": "Mar",
          "isCorrect": false,
          "questionId": "3",
          "scoreForAnswer": 0,
          "orderInAnswer": 2,
          "status": 1
        },
        {
          "id": "10",
          "answer": "Aire",
          "isCorrect": false,
          "questionId": "3",
          "scoreForAnswer": 0,
          "orderInAnswer": 3,
          "status": 1
        },
        {
          "id": "11",
          "answer": "Cielo",
          "isCorrect": true,
          "questionId": "3",
          "scoreForAnswer": 8,
          "orderInAnswer": 4,
          "status": 1
        }
      ]
    },
    {
      "id": "4",
      "question":
          "¿Qué hizo Dios en el séptimo día después de terminar su obra? ",
      "difficulty": "F",
      "level": {"levelNumber": 1},
      "status": 1,
      "answers": [
        {
          "id": "14",
          "answer": "Se puso a jugar con sus criaturas",
          "isCorrect": false,
          "questionId": "4",
          "scoreForAnswer": 0,
          "orderInAnswer": 1,
          "status": 1
        },
        {
          "id": "13",
          "answer": "Se fue a otro planeta",
          "isCorrect": false,
          "questionId": "4",
          "scoreForAnswer": 0,
          "orderInAnswer": 2,
          "status": 1
        },
        {
          "id": "15",
          "answer": "Descansó y santificó el día",
          "isCorrect": true,
          "questionId": "4",
          "scoreForAnswer": 6,
          "orderInAnswer": 3,
          "status": 1
        },
        {
          "id": "16",
          "answer": "Se arrepintió de lo que había hecho",
          "isCorrect": false,
          "questionId": "4",
          "scoreForAnswer": 0,
          "orderInAnswer": 4,
          "status": 1
        }
      ]
    },
    {
      "id": "1",
      "question":
          "¿Qué día de la creación Dios hizo al hombre a su imagen y semejanza?",
      "difficulty": "F",
      "level": {"levelNumber": 1},
      "status": 1,
      "answers": [
        {
          "id": "3",
          "answer": "El quinto",
          "isCorrect": false,
          "questionId": "1",
          "scoreForAnswer": 0,
          "orderInAnswer": 1,
          "status": 1
        },
        {
          "id": "1",
          "answer": "El primero",
          "isCorrect": false,
          "questionId": "1",
          "scoreForAnswer": 0,
          "orderInAnswer": 2,
          "status": 1
        },
        {
          "id": "2",
          "answer": "El tercero",
          "isCorrect": false,
          "questionId": "1",
          "scoreForAnswer": 0,
          "orderInAnswer": 3,
          "status": 1
        },
        {
          "id": "4",
          "answer": "El sexto",
          "isCorrect": true,
          "questionId": "1",
          "scoreForAnswer": 6,
          "orderInAnswer": 4,
          "status": 1
        }
      ]
    }
  ].map((questionJson) => Question.fromJson(questionJson)).toList();
  final options = [
    {"option": "A", "color": "A8A1E7"},
    {"option": "B", "color": "C3F0F9"},
    {"option": "C", "color": "E1D8D8"},
    {"option": "D", "color": "A8B9F1"}
  ];
  double score = 0;
  bool _isAnswerSelected = false;
  int _selectedAnswerIndex = -1;
  String imgBack = "";

  void _answerSelected(BuildContext context, int index) {
    setState(() {
      _isAnswerSelected = true;
      _selectedAnswerIndex = index;
    });

    bool isCorrect = currentAnswers[index].isCorrect;
    if (!isCorrect) {
      setState(() {
        suggestionSelected = true;
      });
    } else {
      setState(() {
        score += 30;
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
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                setState(() {
                  if (currentIndex < questions.length - 1) {
                    currentIndex++;
                    currentQuestion = questions[currentIndex];
                    currentAnswers = currentQuestion.answers;
                  } else {
                    _showDialog(context);
                  }
                  _isAnswerSelected = false;
                  suggestionSelected = false;
                  _selectedAnswerIndex = -1;
                });
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

  @override
  Widget build(BuildContext context) {
    currentQuestion = questions[currentIndex];
    currentAnswers = questions[currentIndex].answers;
    for (int i = 0; i < currentAnswers.length; i++) {
      currentAnswers[i].option = options[i]["option"];
    }
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            children: [
              Column(
                children: [
                  HeaderNotDetailsStageWidget(
                    title: "Conoce el Antiguo Testamento",
                    stage: stage.id,
                    subtitle: stage.sectionName,
                    details: stage,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    width: double.infinity,
                    height: 25.0,
                    decoration: BoxDecoration(
                        color: StyleColor.orange,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      "Paso 1 ${level.name}",
                      style: StylesApp(context).textStyleBody5,
                    ),
                  ),
                  SizedBox(
                    height: 19.0,
                  ),
                  Container(
                    constraints: BoxConstraints(minHeight: 68.0),
                    margin: EdgeInsets.symmetric(horizontal: 6.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 11.0, vertical: 15.0),
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
              // we show  question and answer
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.0),
                  child: ListView.builder(
                    itemCount: currentQuestion.answers.length,
                    itemBuilder: (context, int index) {
                      currentAnswers = currentQuestion.answers;
                      final answer = currentAnswers[index];
                      return GestureDetector(
                        onTap: _isAnswerSelected
                            ? null
                            : () {
                                _answerSelected(context, index);
                              },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 27.0),
                          constraints: BoxConstraints(minHeight: 48.0),
                          decoration: BoxDecoration(
                            color: suggestionSelected && answer.isCorrect
                                ? Colors.green
                                : _isAnswerSelected
                                    ? StyleColor.turquoise
                                        .withValues(alpha: 0.30)
                                    : StyleColor.turquoise,
                            borderRadius: BorderRadius.circular(8.0),
                            border: _selectedAnswerIndex == index &&
                                    !answer.isCorrect
                                ? Border.all(
                                    color: Colors.redAccent, width: 3.0)
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
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
                                            '0xFF${options[index]["color"]}'),
                                      ),
                                    ),
                                    child: Center(
                                        child: Text(
                                      currentQuestion.answers[index].option!,
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
                                      currentQuestion.answers[index].answer,
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
              Expanded(
                flex: 1,
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
            ],
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    if (score > 100) {
      setState(() {
        imgBack = "assets/boxStartFull.png";
      });
    } else if (score < 100 && score > 50) {
      setState(() {
        imgBack = "assets/boxStartMedium.png";
      });
    } else if (score < 50 && score > 0) {
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
                      height: score > 0 ? 100 : 33.0,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      score > 0 ? 'Felicitaciones' : "Ya casi lo\n logras! ",
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
                          ? 'Culminaste el Paso ${level.id}'
                          : "Intenta nuevamente el\n Paso ${level.id} para avanzar",
                      style: StylesApp(context).textStyleWithe20,
                    ),
                    if (score > 0) ...{
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        'Haz ganado\n $score LMs de energía',
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
                  if (score < 100 && score >= 0) ...{
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

    if (score >= 150) {
      return 112; // Alto fijo cuando los puntos son mayores o iguales a 1000
    } else {
      double width = ((maxPossibleHeight * 100)) / 112;

      return width > 30 ? ((maxPossibleHeight * 100)) / 112 : 40;
    }
  }
}
