import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  static const MAX_SCORE = 150;
  static const MEDIUM_SCORE = 100;
  static const LOW_SCORE = 50;
  final options = [
    {"option": "A", "color": "A8A1E7"},
    {"option": "B", "color": "C3F0F9"},
    {"option": "C", "color": "E1D8D8"},
    {"option": "D", "color": "A8B9F1"}
  ];

  LoginUser? userData;
  Stage? stage;
  Level? level;
  UserAchievement? achievement;
  UserAchievement? prize;
  Reward? reward;
  LevelProgressUser? levelProgress;
  SendScoreModel? sendScore = SendScoreModel(
      isLastLevel: false,
      titleUnlocked: false,
      isLastStage: false,
      rewardObtained: false,
      prizeWon: false);
  Question currentQuestion = Question(
    id: "",
    question: "",
    difficulty: "",
    level: LevelQuestion(
      levelNumber: 0,
    ),
    status: 0,
    answers: [],
  );
  ResponseData? responseSend;

  List currentAnswers = [];
  List<Question> questions = [];
  List<UserResponses> responses = [];

  bool _isCorrect = false;
  bool showError = false;
  bool _suggestionSelected = false;
  bool isLoading = false;
  bool activityIsCompleted =
      false; // para controlar si las preguntas fueron respondidas
  bool showStepCompleted =
      false; // para mostrar mensaje de culminación de nivel
  bool showAchievementUnlocked = false; // para mostrar Logro desbloqueado
  bool showLastStageCompleted =
      false; // para mostrar mensaje de culminación de etapa
  bool showRewardObtained = false; // si obtuvo recompensa
  bool isOrdering = false;
  bool _selectionCompleted = false;
  bool _isAnswerSelected = false;
  bool isLastStage = false;
  bool showReview = false;
  int bestScore = 0;
  String imgBack = "";
  String courseId = "";
  String levelId = "";
  String sectionId = "";
  String? errorMessage;

  int currentIndex = 0;
  int failedAttempts = 0;
  int _selectedAnswerIndex = -1;

  double score = 0;
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

  @override
  void dispose() {
    super.dispose();
  }

  ///
  //función que se encarga de cargar los datos iniciales de la pantalla
  ///
  Future<void> _generateData(BuildContext context) async {
    errorMessage = null;
    LoadingService().showLoading(context);

    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      try {
        courseId = args['courseId'];
        levelId = args['levelId'];
        sectionId = args['sectionId'];
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

          for (int i = 0; i < questions.length; i++) {
            for (int j = 0; j < questions[i].answers.length; j++) {
              questions[i].answers[j].option = options[j]["option"];
            }
          }
          currentQuestion = questions[currentIndex];
          currentAnswers = questions[currentIndex].answers;
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

  ///
  /// Función que se encarga de marcar respuesta seleccionada
  ///
  void _answerSelected(BuildContext context, int index) {
    setState(() {
      _isAnswerSelected = true;
      _suggestionSelected = false;
      _selectedAnswerIndex = index;
    });
    _isCorrect = (currentAnswers != null && currentAnswers.isNotEmpty)
        ? currentAnswers[index].isCorrect
        : false;
    if (userData != null) {
      responses.add(UserResponses(
        answerId: currentAnswers[index].id,
        questionId: currentQuestion.id,
        userId: userData!.user.id,
      ));
    }

    if (!_isCorrect) {
      setState(() {
        _suggestionSelected = true;

        failedAttempts += 1;
      });
    } else {
      setState(() {
        _suggestionSelected = true;
      });
    }
    setState(() {
      _selectionCompleted = true;
    });
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
                setState(() {
                  _isAnswerSelected = false;
                  _suggestionSelected = false;
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
        backgroundColor: _isCorrect ? Colors.green : Colors.red,
      ),
    );
  }

  ///
  /// Función que se encarga de verificar el orden de las respuestas
  ///
  void verifyOrdered(BuildContext context, int index) {
    bool isCorrectOrder = true;
    for (int i = 0; i < orderedAnswers.length; i++) {
      if (orderedAnswers[i].orderInAnswer != i + 1) {
        isCorrectOrder = false;
        break;
      }
    }

    if (isCorrectOrder) {
      showError = false;
    } else {
      failedAttempts += 1;
    }
    setState(() {
      orderedCompleted = true;
    });
  }

  ///
  /// Función que se encarga de validar las respuestas enviadas
  ///
  funcAnswerValidate() async {
    // si no es la ultima pregunta
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        orderedCompleted = false;
        _selectionCompleted = false;
        currentQuestion = questions[currentIndex];
        currentAnswers = questions[currentIndex].answers;
        orderedAnswers.clear();
      });
    } else {
      // si falle 3 o mas veces muestro modal de inténtalo de nuevo
      if (failedAttempts >= 3) {
        setState(() {
          levelProgress = LevelProgressUser(
              id: "",
              score: 0,
              energy: 0,
              message: Message(
                  resultDescription: "", resultTitle: "", difficulty: ""),
              newRecord: false,
              user: InfoUser(username: "", rolId: 0, id: ""),
              failedAttempts: failedAttempts,
              scoreLastAttempt: 0,
              completed: false,
              level: LevelUser(levelNumber: 0, id: "", name: ""),
              status: true);
          activityIsCompleted = true;
          showStepCompleted = true;
        });
      } else {
        LoadingService().showLoading(context);
        //llamamos servicio  registrar las respuestas enviadas
        responseSend = await sendResponsesUser(responses!);
        if (responseSend?.error != null) {
          LoadingService().hideLoading();
          await showCustomDialog(context,
              message: responseSend!.error!, dialogType: DialogType.error);
          return;
        }
        // lamamos al servicios que nos registra el score
        final ResponseData sendScoreResponse = await sendScoreUser(
            userData != null ? userData!.user.id : '',
            courseId,
            levelId,
            failedAttempts);
        if (sendScoreResponse.error != null) {
          LoadingService().hideLoading();
          await showCustomDialog(context,
              message: sendScoreResponse.error!, dialogType: DialogType.error);
          return;
        }
        sendScore =
            SendScoreModel.fromJson(removeTypename(sendScoreResponse.data));
        // si se desbloqueo un titulo buscamos el logro
        if (sendScore!.titleUnlocked) {
          final responseAchievement = await getAchievement(userData!.user.id);

          if (responseAchievement.error != null) {
            // si desbloqueo un titulo
            LoadingService().hideLoading();
            await showCustomDialog(context,
                message: responseAchievement.error!,
                dialogType: DialogType.error);
            return;
          } else {
            final List<UserAchievement> achievements = responseAchievement.data
                .map((achievement) =>
                    UserAchievement.fromJson(removeTypename(achievement)))
                .cast<UserAchievement>()
                .toList();
            achievement = achievements.isNotEmpty ? achievements.last : null;
          }
        }
        // si obtuvo un premio
        if (sendScore!.prizeWon) {
          final responsePrizeWon = await getPrizeWon(userData!.user.id);
        }
        // si obtuvo una recompensa
        if (sendScore!.isLastLevel) {
          final responseRewardObtained =
              await getRewardObtained(userData!.user.id);
          if (responseRewardObtained.error != null) {
            LoadingService().hideLoading();
            await showCustomDialog(context,
                message: responseRewardObtained.error!,
                dialogType: DialogType.error);
            return;
          }
          reward = Reward.fromJson(removeTypename(responseRewardObtained.data));
          // desbloquear la proxima sección
          // final responseUnlockSection = await unlockedNextSection(userData!.user.id, sectionId);
          // if (responseUnlockSection.error != null) {
          //    LoadingService().hideLoading();
          //   await showCustomDialog(context,
          //       message: responseRewardObtained.error!,
          //       dialogType: DialogType.error);
          //   return;
          // }
        }

        // consultamos ultimo progreso en el nivel
        final ResponseData progressLevelResponse = await lastLevelProgressUser(
            userData != null ? userData!.user.id : '',
            level != null ? level!.id : '');
        if (progressLevelResponse.error != null) {
          LoadingService().hideLoading();
          await showCustomDialog(context,
              message: progressLevelResponse.error!,
              dialogType: DialogType.error);
          return;
        }
        levelProgress = LevelProgressUser.fromJson(progressLevelResponse.data);

        // actualizamos energía y experiencia en el perfil del usuario
        int experience = 0;
        int energy = 0;
        // si no ha obtenido todos los puntos
        print("es nuevo record : ${levelProgress!.newRecord}");

        if (levelProgress!.newRecord) {
          experience = levelProgress!.score > levelProgress!.scoreLastAttempt
              ? levelProgress!.score - levelProgress!.scoreLastAttempt
              : 0;
          energy = (experience / 10).toInt();
        } else {
          experience = 0; //levelProgress!.score;
          energy = 0; // (experience / 10).toInt();
          setState(() {
            bestScore = levelProgress!.scoreLastAttempt;
            showReview = true;
          });
        }

        setState(() {
          userData = userData!.copyWith(
              expTotalUser: userData!.expTotalUser + experience,
              energyPoints: userData!.energyPoints + energy);
        });

        print('${userData!.expTotalUser}  ${userData!.energyPoints}');
        Provider.of<UserProvider>(context, listen: false).setUser(userData);

        // habilitamos mostrar paso completado
        setState(() {
          activityIsCompleted = true; // para ocultar las preguntas
          showStepCompleted = true; // mostramos mensaje de paso completado
        });
        // _showDialog(context, levelProgress!, sendScore?.isLastLevel);
        LoadingService().hideLoading();
        setState(() {
          orderedCompleted = false;
          _selectionCompleted = false;
          failedAttempts = 0;
        });
      }
    }
    setState(() {
      _isAnswerSelected = false;

      _suggestionSelected = false;
      _selectedAnswerIndex = -1;
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
                        stage: stage != null ? stage!.id : '',
                        subtitle: stage != null ? stage!.sectionName : '',
                        details: stage,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  if (!showAchievementUnlocked && !showLastStageCompleted) ...{
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      width: double.infinity,
                      height: 25.0,
                      decoration: BoxDecoration(
                          color: StyleColor.orange,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Text(
                        "Paso 1 ${level?.name}",
                        style: StylesApp(context).textStyleBody5,
                      ),
                    ),
                  },
                  SizedBox(
                    height: 19.0,
                  ),
                  if (!activityIsCompleted) ...{
                    // we show  question and answer or ordering
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
                    if (questions.isNotEmpty)
                      Expanded(
                        child: _buildBody(context),
                      )
                  } else ...{
                    if (showStepCompleted) ...{
                      Expanded(
                        child: _buildActivityCompleted(context, levelProgress!),
                      )
                    },
                   
                    if (showAchievementUnlocked) ...{
                      Expanded(
                        child: _buildAchievementUnloked(context),
                      )
                    },
                    //si es el ultimo nivel  y si es la ultima etapa!

                    if (showLastStageCompleted) ...{
                      Expanded(
                          child: _buildLastStage(
                              context) //_buildLastLevel(context),
                          ),
                    },
                    if (showRewardObtained) ...{
                      Expanded(
                          child: RewardWidget() //_buildLastLevel(context),
                          ),
                    },
                  },
                },
              },
            ],
          ),
        ),
      ),
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

  _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: !isOrdering ? 3 : 2,
          child: Column(
            children: [
              if (isOrdering) ...{
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
                if (currentQuestion != null && options.isNotEmpty)
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
          flex: !isOrdering ? 1 : 0,
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
        if (isOrdering)
          SizedBox(
            height: 20,
          )
      ],
    );
  }

  _buildActivityCompleted(BuildContext context, data) {
    if (data.score > MEDIUM_SCORE) {
      setState(() {
        imgBack = "assets/boxStartFull.png";
      });
    } else if (data.score > LOW_SCORE && data.score <= MEDIUM_SCORE) {
      setState(() {
        imgBack = "assets/boxStartMedium.png";
      });
    } else if (data.score > 0 && data.score <= LOW_SCORE) {
      setState(() {
        imgBack = "assets/boxStartLow.png";
      });
    } else {
      setState(() {
        imgBack = "assets/boxStartFailed.png";
      });
    }
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
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: data.score > 0 ? 100 : 33.0,
                ),
                Text(
                  textAlign: TextAlign.center,
                  data.score > 0
                      ? data.message.resultTitle
                      : "Ya casi lo\n logras! ",
                  style: StylesApp(context)
                      .textStyleCongratulation
                      .copyWith(color: Colors.white),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  textAlign: TextAlign.center,
                  data.score > 0
                      ? 'Culminaste el Paso ${data.level.id}'
                      : "Intenta nuevamente el\n Paso ${data.level.id} para avanzar",
                  style: StylesApp(context).textStyleWithe20,
                ),
                if (data.score > 0 && !showReview) ...{
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    'Haz ganado\n ${data.energy} LMs de energía',
                    style: StylesApp(context).textStyleWithe20,
                  ),
                } else ...{
                  Text(
                    textAlign: TextAlign.center,
                    "En toda labor hay fruto.",
                    style: StylesApp(context).textStyleBodyAso20.copyWith(
                          color: Colors.white,
                          letterSpacing: data.score > 0 ? 0.0 : 1,
                        ),
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
              SizedBox(
                height: 23.0,
              ),
              Text(
                textAlign: TextAlign.center,
                data.score > 0
                    ? "Puedes repetir el paso para\n tratar de ganar 3 estrellas"
                    : "En toda labor hay fruto.",
                style: StylesApp(context).textStyleBodyAso20.copyWith(
                      color: Color(0XFFFD8C43),
                      letterSpacing: data.score > 0 ? 0.0 : 1,
                    ),
              ),
              if (showReview) ...{
                Text(
                  textAlign: TextAlign.center,
                  "Mejor puntaje : ${bestScore}",
                  style: StylesApp(context).textStyleBodyAso20.copyWith(
                        color: Color(0XFFFD8C43),
                        letterSpacing: data.score > 0 ? 0.0 : 1,
                      ),
                ),
              },
              if (data.score > 0 && !showReview)
                Image.asset(
                  "assets/kawaii_fire.png",
                  height: calculateHeight(score),
                  fit: BoxFit.contain,
                ),
              if (data.score > 0 && !showReview) ...{
                Text(
                  "${data.energy.toStringAsFixed(0)} lms",
                  style: StylesApp(context)
                      .textStyleBody20
                      .copyWith(color: Color(0XFFFD8C43)),
                )
              },
              SizedBox(
                height: data.score > 0 ? 50.0 : 158.0,
              ),
              ButtonThemeWidget(
                text: "Continuar",
                width: 132.0,
                height: 32.0,
                buttonStyle: StylesApp(context).btnWidgetSmall,
                onPressed: () {
                  if (sendScore!.titleUnlocked) {
                    setState(() {
                      showStepCompleted = false;
                      showAchievementUnlocked = true;
                    });
                  } else if (sendScore!.isLastLevel) {
                    setState(() {
                      showStepCompleted = false;
                      showAchievementUnlocked = false;
                      showLastStageCompleted = true;
                    });
                  } else {
                    Navigator.popAndPushNamed(context, '/mapPage', arguments: {
                      'courseId': courseId,
                      'sectionId': sectionId
                    });
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  /// dialog si obtuvo titulo
  _buildAchievementUnloked(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/boxOrange.png'),
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter)),
              child: Column(
                children: [
                  SizedBox(
                    height: 27,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "Haz obtenido\n el titulo de\n ${achievement?.title}!",
                    style: StylesApp(context)
                        .textStyleCongratulation
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    height: 29,
                  ),
                  // Text(
                  //   textAlign: TextAlign.center,
                  //   'Haz ganado un zafiro para\n tu coleccion',
                  //   style: StylesApp(context).textStyleBody20,
                  // ),
                  // SizedBox(
                  //   height: 29,
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 29,
            ),
            Container(
              width: 190,
              // height: 175,
              decoration: BoxDecoration(
                  color: Color(0XFFC7AA34),
                  // border: Border.all(width: 15, color: StyleColor.orange),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.network(
                      GraphQLConfig.urlServidor + achievement!.img.urlImg,
                      height: 80,
                    ),
                    Text(
                      achievement?.title ?? "",
                      style: StylesApp(context).textStyleBody12,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 29,
            ),
            ButtonThemeWidget(
              width: 245,
              height: 32,
              buttonStyle: StylesApp(context).btnPrimary,
              text: "Descargar certificado",
              onPressed: () {},
            ),
            SizedBox(
              height: 29,
            ),
            ButtonThemeWidget(
              showIcon: true,
              icon: Icons.share,
              width: 245,
              height: 32,
              colorIcon: Colors.white,
              buttonStyle: StylesApp(context).btnPrimary,
              text: "Compartir logro",
              onPressed: () async {
                await Share.share(
                  "¡He obtenido el titulo de ${achievement?.title}!",
                  subject: "¡Felicita a ${userData!.user.username}! ",
                );
              },
            ),
            SizedBox(
              height: 29,
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  flex: 0,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/kawaii_fire.png",
                        height: calculateHeight(550),
                        fit: BoxFit.contain,
                      ),
                      Text(
                        "550 lms",
                        style: StylesApp(context)
                            .textStyleBody16
                            .copyWith(color: StyleColor.orange),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 48,
                ),
                Center(
                  child: ButtonThemeWidget(
                    text: "Continuar",
                    width: 132,
                    height: 32,
                    buttonStyle: StylesApp(context).btnWidgetSmall,
                    onPressed: () {
                      if (sendScore!.isLastLevel) {
                        setState(() {
                          showAchievementUnlocked = false;
                          showLastStageCompleted = true;
                        });
                      } else {
                        Navigator.popAndPushNamed(context, '/mapPage',
                            arguments: {
                              'courseId': courseId,
                              'sectionId': sectionId
                            });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 43),
          ],
        ),
      ),
    );
  }

  /// sección de nivel completado
  _buildLastLevel(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/boxOrange.png'),
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter)),
            child: Column(
              children: [
                SizedBox(
                  height: 27,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Etapa ${sectionId} Completada",
                  style: StylesApp(context)
                      .textStyleCongratulation
                      .copyWith(color: Colors.white),
                ),
                SizedBox(
                  height: 29,
                ),
                Text(
                  textAlign: TextAlign.center,
                  'El esfuerzo valió la pena  completaste la Etapa 2 \n “${stage?.sectionName}” \n fue completada con éxito"',
                  style: StylesApp(context).textStyleBody20,
                ),
                SizedBox(
                  height: 29,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 29,
          ),
          Image.asset(
            "assets/kawaii_fire.png",
            height: calculateHeight(550),
            fit: BoxFit.contain,
          ),
          Text(
            "550 lms",
            style: StylesApp(context)
                .textStyleBody16
                .copyWith(color: StyleColor.orange),
          ),
          ButtonThemeWidget(
            showIcon: true,
            icon: Icons.share,
            width: 208,
            height: 32,
            colorIcon: Colors.white,
            buttonStyle: StylesApp(context).btnPrimary,
            text: "Compartir logro",
          ),
          SizedBox(height: 43),
          ButtonThemeWidget(
            text: "Continuar",
            width: 208,
            height: 32,
            buttonStyle: StylesApp(context).btnWidgetSmall,
            onPressed: () {
              if (sendScore!.isLastLevel) {
                setState(() {
                  showAchievementUnlocked = false;
                  showLastStageCompleted = true;
                });
              } else {
                Navigator.popAndPushNamed(context, '/mapPage',
                    arguments: {'courseId': courseId, 'sectionId': sectionId});
              }
            },
          ),
        ],
      ),
    );
  }

  _buildLastStage(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/boxOrange.png'),
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter)),
              child: Column(
                children: [
                  SizedBox(
                    height: 27,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "¡Felicidades\n por completar\n este curso!",
                    style: StylesApp(context)
                        .textStyleCongratulation
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    height: 29,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    'Haz ganado un zafiro para\n tu coleccion',
                    style: StylesApp(context).textStyleBody20,
                  ),
                  SizedBox(
                    height: 29,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 29,
            ),
            Container(
              width: 158,
              // height: 175,
              decoration: BoxDecoration(
                  border: Border.all(width: 15, color: StyleColor.orange),
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/premios/zafiro.png',
                      height: 80,
                    ),
                    Divider(
                      color: Colors.black.withValues(alpha: 0.50),
                      height: 2,
                    ),
                    Text(
                      "Dan",
                      style: StylesApp(context)
                          .textStyleBody12
                          .copyWith(color: Colors.black),
                    ),
                    Text(
                      "Zafiro",
                      style: StylesApp(context)
                          .textStyleBody12
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 29,
            ),
            Text(
              textAlign: TextAlign.center,
              "Cuando lo requieras puede canjearlo\n por 200lms de energia",
              style: StylesApp(context)
                  .textStyleBody14
                  .copyWith(color: Colors.black),
            ),
            SizedBox(
              height: 29,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 10,
              children: [
                Expanded(
                  flex: 0,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/kawaii_fire.png",
                        height: calculateHeight(550),
                        fit: BoxFit.contain,
                      ),
                      Text(
                        "550 lms",
                        style: StylesApp(context)
                            .textStyleBody16
                            .copyWith(color: StyleColor.orange),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ButtonThemeWidget(
                    text: "Continuar",
                    width: 132,
                    height: 32,
                    buttonStyle: StylesApp(context).btnWidgetSmall,
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/mapPage',
                          arguments: {
                            'courseId': courseId,
                            'sectionId': sectionId
                          });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 43),
          ],
        ),
      ),
    );
  }
}
