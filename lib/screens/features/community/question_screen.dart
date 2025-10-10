import 'dart:io';

import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int MAX_SCORE = 0;
  int MEDIUM_SCORE = 0;
  int LOW_SCORE = 0;
  final options = [
    {"option": "A", "color": "A8A1E7"},
    {"option": "B", "color": "C3F0F9"},
    {"option": "C", "color": "E1D8D8"},
    {"option": "D", "color": "A8B9F1"}
  ];

  LoginUser? userData;
  late Map<String, dynamic> config;
  CourseDetail? course;
  Stage? stage;
  Level? level;
  UserAchievement? achievement;
  TitleModel? title;
  PrizeModel? prize;
  Reward? reward;
  double fontSizeText = 16;
  LevelProgressUser? levelProgress;
  SendScoreModel? sendScore = SendScoreModel(
    isLastLevel: false,
    isLastStage: false,
    rewardObtained: false,
    hasBeenPlayedSection: false,
    hasBeenPlayedLevel: false,
    prizeAwarded: false,
    rewardData: null,
    titleAwarded: false,
  );
  Question currentQuestion = Question(
      id: "",
      question: "",
      difficulty: "",
      status: 0,
      answers: [],
      isOrdering: false);
  // ResponseData? responseSend;
  int numberQuestion = 0;
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
  bool showTitleObtained = false; // para mostrar titulo desbloqueado
  bool showPrizeWon = false; // para mostrar Premio desbloqueado
  bool showLastStageCompleted =
      false; // para mostrar mensaje de culminación de etapa
  bool showRewardObtained = false; // si obtuvo recompensa
  bool _selectionCompleted = false;
  bool _isAnswerSelected = false;
  bool isLastStage = false;
  bool showReview = false;
  int bestScore = 0;
  String imgBack = "";
  String courseId = "";
  String levelId = "";
  String sectionId = "";
  String nextSectionId = "";
  String? errorMessage;

  int currentIndex = 0;
  int failedAttempts = 0;

  double score = 0;
//draggable variables
  bool orderedCompleted = false;
  List<Answer> orderedAnswers = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateData(context);
      getFontSizeText();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getFontSizeText() async {
    double? fontSize = await PreferencesManager().getFontSizeQuestion();
    setState(() => fontSizeText = fontSize);
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
        final LoginUser? userData = userProvider.currentUser;

        // obtenemos curso
        final ResponseData courseResponse =
            await loadOneCourse(userData!.userId, courseId);
        if (courseResponse.error != null) {
          errorMessage = courseResponse.error;
          return;
        }
        course = CourseDetail.fromJson(courseResponse.data);
        // obtenemos sección
        final ResponseData stageResponse = await loadStageById(sectionId);

        if (stageResponse.error != null) {
          errorMessage = stageResponse.error;
          return;
        }
        stage = Stage.fromJson(stageResponse.data);
        // obtenemos el nivel
        final levelResponse = await loadOneLevel(levelId);

        if (levelResponse.error != null) {
          errorMessage = levelResponse.error;
          return;
        }
        level = Level.fromJson(levelResponse.data);

        // obtenemos las preguntas
        final ResponseData questionResponse =
            await loadQuestionByStory(levelId);

        if (questionResponse.error != null) {
          errorMessage = questionResponse.error;
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
    });
    _isCorrect =
        (currentAnswers.isNotEmpty) ? currentAnswers[index].isCorrect : false;
    if (userData != null) {
      responses.add(UserResponses(
        answerId: currentAnswers[index].id,
        questionId: currentQuestion.id,
        userId: userData!.userId,
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
                if (!mounted) return;
                setState(() {
                  _isAnswerSelected = false;
                  _suggestionSelected = false;
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
      if (orderedAnswers[i].correctOrder != i + 1) {
        isCorrectOrder = false;
        break;
      }
    }

    if (isCorrectOrder) {
      setState(() {
        showError = false;
      });
    } else {
      setState(() {
        showError = true;
        failedAttempts += 1;
      });
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
        numberQuestion = currentIndex + 1;
        currentAnswers = questions[currentIndex].answers;
        orderedAnswers.clear();
      });
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
      }
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
        // Proceso de comprobación

        LoadingService().showLoading(context);
        // lamamos al servicios que nos registra el score
        final ResponseData sendScoreResponse = await sendScoreUser(
            userData != null ? userData!.userId : '',
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

        // consultamos ultimo progreso en el nivel correspondiente para obtener experiencia acumulada y energía acumulada
        final ResponseData progressLevelResponse = await lastLevelProgressUser(
            userData != null ? userData!.userId : '',
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
        // print("es nuevo record : ${levelProgress!.newRecord}");
        if (levelProgress!.newRecord) {
          experience = levelProgress!.score > levelProgress!.scoreLastAttempt
              ? levelProgress!.score - levelProgress!.scoreLastAttempt
              : 0;
          energy = (experience / 10).toInt();
        } else {
          experience = 0;
          energy = 0;
          setState(() {
            bestScore = levelProgress!.scoreLastAttempt;
          });
        }

        // si ya se jugo ese nivel o sección esta repitiendo
        if (sendScore!.hasBeenPlayedLevel) {
          setState(() {
            showReview = true;
          });
        }

        // actualizar variable local de los datos del perfil
        setState(() {
          userData = userData!.copyWith(
              expTotalUser: userData!.expTotalUser + experience,
              energyPoints: userData!.energyPoints + energy);
        });

        if (kDebugMode) {
          print('${userData!.expTotalUser}  ${userData!.energyPoints}');
        }
        Provider.of<UserProvider>(context, listen: false).setUser(userData);

        // si Obtuvo una recompensa
        if (sendScore!.rewardObtained && !sendScore!.hasBeenPlayedLevel) {
          setState(() {
            reward = sendScore!.rewardData;
          });
          updateLocalProfile(reward!);
        }

        // obtener la proxima sección desbloqueada
        if (sendScore!.isLastLevel == true && !sendScore!.hasBeenPlayedLevel) {
          final responseUnlockSection =
              await getNextSectionUnlocked(userData!.userId, sectionId);
          if (responseUnlockSection.error != null) {
            LoadingService().hideLoading();
            await showCustomDialog(context,
                message: responseUnlockSection.error!,
                dialogType: DialogType.error);
            return;
          }
          nextSectionId = responseUnlockSection.data != null
              ? responseUnlockSection.data["unlockedSectionId"] ?? ''
              : '';
        }

        // si es la ultima etapa del curso
        if (sendScore!.isLastStage) {
          // si se desbloqueo un titulo buscamos el Titulo
          if (sendScore!.titleAwarded) {
            await loadTitleForUser();
          }

          // si obtuvo un premio
          if (sendScore!.prizeAwarded) {
            await loadPrizeForUser();
          }
        }
        LoadingService().hideLoading();
        // habilitamos mostrar paso completado
        setState(() {
          activityIsCompleted = true; // para ocultar las preguntas
          showStepCompleted = true; // mostramos mensaje de paso completado
          orderedCompleted = false;
          _selectionCompleted = false;
          failedAttempts = 0;
        });
      }
    }
    setState(() {
      _isAnswerSelected = false;
      _suggestionSelected = false;
    });
    String? userToken = await PreferencesManager().getUserToken();
    await Provider.of<AuthenticationProvider>(context, listen: false)
        .loadProfileUser(userData!.userId, userToken);
  }

  loadTitleForUser() async {
    final responseTitle = await getTitleForUser(userData!.userId, course!.id);

    if (responseTitle.error != null) {
      // si desbloqueo un titulo
      LoadingService().hideLoading();
      await showCustomDialog(context,
          message: responseTitle.error!, dialogType: DialogType.error);
      return;
    } else {
      if (responseTitle.data != null) {
        title = TitleModel.fromJson(removeTypename(responseTitle.data));
      }
    }
  }

  loadPrizeForUser() async {
    final responsePrizeWon = await getPrizeByUserId(userData!.userId, courseId);
    if (responsePrizeWon.error != null) {
      // si desbloqueo un titulo
      LoadingService().hideLoading();
      await showCustomDialog(context,
          message: responsePrizeWon.error!, dialogType: DialogType.error);
      return;
    }

    prize = PrizeModel.fromJson(removeTypename(responsePrizeWon.data));
  }

  updateLocalProfile(Reward data) {
    final int experience = data.earnedExperience;
    final int energy = data.earnedEnergy;
    setState(() {
      userData = userData!.copyWith(
          expTotalUser: userData!.expTotalUser + experience,
          energyPoints: userData!.energyPoints + energy);
    });
    Provider.of<UserProvider>(context, listen: false).setUser(userData);
  }

  @override
  Widget build(BuildContext context) {
    userData = Provider.of<UserProvider>(context, listen: false).currentUser;
    config = Provider.of<CatalogueProvider>(context, listen: false).allConfig;
    MAX_SCORE = config["highScore"];
    MEDIUM_SCORE = config["mediumScore"];
    LOW_SCORE = config["lowScore"];
    return PopScope(
      canPop:
          true, // Permite que la pantalla sea sacada de la pila de navegación
      onPopInvokedWithResult: (didPop, result) async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
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
                          showStage: !showTitleObtained &&
                              !showRewardObtained &&
                              !showPrizeWon,
                          showAction: !showTitleObtained &&
                              !showRewardObtained &&
                              !showPrizeWon,
                          title:
                              "Conoce el ${course != null ? course!.titleCourse : ''}",
                          stage: stage != null
                              ? (stage!.sectionNumber).toString()
                              : '',
                          subtitle: stage != null ? stage!.sectionName : '',
                          details: stage,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    if (!showTitleObtained &&
                        !showRewardObtained &&
                        !showPrizeWon &&
                        !showLastStageCompleted) ...{
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        padding:
                            EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        width: double.infinity,
                        // height: 25.0,
                        decoration: BoxDecoration(
                            color: StyleColor.orange,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          "${level?.name} - Paso ${numberQuestion}",
                          style: StylesApp(context).textStyleBody5,
                        ),
                      ),
                      SizedBox(
                        height: 19.0,
                      ),
                    },
                    if (!activityIsCompleted) ...{
                      // we show  question and answer or ordering
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
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
                          Positioned(
                            top: -20,
                            right: 10,
                            child: Row(
                              children: [
                                Text(
                                  "Oportunidades: ",
                                  style: StylesApp(context)
                                      .textStyleBody10
                                      .copyWith(color: StyleColor.grayMedium),
                                ),
                                Image.asset(
                                  failedAttempts <= 2
                                      ? "assets/fire_rachaActive.png"
                                      : "assets/fire_rachaInactive.png",
                                  width: 20,
                                ),
                                Image.asset(
                                  failedAttempts <= 1
                                      ? "assets/fire_rachaActive.png"
                                      : "assets/fire_rachaInactive.png",
                                  width: 20,
                                ),
                                Image.asset(
                                  failedAttempts == 0
                                      ? "assets/fire_rachaActive.png"
                                      : "assets/fire_rachaInactive.png",
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 38.0,
                      ),
                      if (questions.isNotEmpty)
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: _buildBody(context),
                        ))
                    } else ...{
                      // si completo nivel
                      if (showStepCompleted) ...{
                        Expanded(
                          child:
                              _buildActivityCompleted(context, levelProgress!),
                        )
                      },
                      // si obtiene recompensa por completar sección
                      if (showRewardObtained) ...{
                        Expanded(
                          child: RewardWidget(
                            rewardInfo: reward,
                            onPressed: () async {
                              // si es la ultima sección del curso
                              if (sendScore!.isLastStage && !showReview) {
                                setState(() {
                                  showStepCompleted = false;
                                  showTitleObtained = false;
                                  showRewardObtained = false;
                                  showLastStageCompleted = true;
                                });
                              } else {
                                Navigator.popAndPushNamed(context, '/mapPage',
                                    arguments: {
                                      'courseId': courseId,
                                      'sectionId': nextSectionId.isEmpty
                                          ? sectionId
                                          : nextSectionId
                                    });
                              }
                            },
                          ),
                        ),
                      },
                      // si es la ultima sección del curso
                      if (showLastStageCompleted) ...{
                        Expanded(
                          child: _buildLastStage(context),
                        ),
                      },
                      //si tiene premio por el curso
                      if (showPrizeWon) ...{
                        Expanded(
                          child: _buildPrizeWon(context),
                        )
                      },
                      //si tiene Titulo por el curso
                      if (showTitleObtained) ...{
                        Expanded(
                          child: _buildAchievementUnlocked(context),
                        )
                      },
                    },
                  },
                },
              ],
            ),
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
          flex: !currentQuestion.isOrdering ? 3 : 2,
          child: Column(
            children: [
              if (currentQuestion.isOrdering) ...{
                OrderingQuestionDraggableWidget(
                  orderedCompleted: orderedCompleted,
                  orderedAnswers: orderedAnswers,
                  currentQuestion: currentQuestion,
                  options: options,
                  fontSize: fontSizeText,
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
                      fontSize: fontSizeText,
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
        Container(
          margin: EdgeInsets.symmetric(horizontal: 9),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Slider(
                  activeColor: Colors.blueGrey,
                  inactiveColor: Colors.grey,
                  thumbColor: StyleColor.turquoise,
                  min: 12.0,
                  max: 20.0,
                  value: fontSizeText,
                  onChanged: (value) async {
                    await PreferencesManager().setFontSizeQuestion(value);
                    print(value);
                    setState(() => fontSizeText = value);
                  },
                  secondaryTrackValue: 20.0,
                ),
              ),
              Expanded(
                flex: 0,
                child: Text(
                  "Aa",
                  style: StylesApp(context).textStyleBody12.copyWith(
                        color: Colors.black,
                      ),
                ),
              )
            ],
          ),
        ),
        Center(
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
                  value: currentIndex /
                      (questions.length > 1
                          ? questions.length - 1
                          : questions.length),
                  backgroundColor: Color(0xFFC4C4C4),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0XFFF27728),
                  ),
                ),
              ],
            ),
          ),
        ),
        // if (currentQuestion.isOrdering)
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  // esta parte es para mostrar nivel Completado
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
                      ? 'Culminaste el Paso ${data.level.levelNumber}'
                      : "Intenta nuevamente el\n Paso ${data.level.levelNumber} para avanzar",
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
                data.score > 0 && data.score < MAX_SCORE
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
                  "Mejor puntaje : $bestScore",
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
                onPressed: () async {
                  // mostrar si hay recompensa
                  if (sendScore!.devMessageLevel != null &&
                      sendScore!.devMessageLevel!.isNotEmpty) {
                    await showCustomDialog(
                      context,
                      message: sendScore!.devMessageLevel!,
                      dialogType: DialogType.info,
                    );
                  }

                  if (sendScore!.isLastLevel == true &&
                      sendScore!.devMessageSection != null &&
                      sendScore!.devMessageSection!.isNotEmpty) {
                    await showCustomDialog(
                      context,
                      message: sendScore!.devMessageSection!,
                      dialogType: DialogType.info,
                    );
                  }
                  if (!sendScore!.hasBeenPlayedSection &&
                      sendScore!.rewardObtained &&
                      reward != null &&
                      !showReview) {
                    setState(() {
                      showStepCompleted = false;
                      showTitleObtained = false;
                      showRewardObtained = true;
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

  // sección de Sección o etapa completada
  _buildLastStage(BuildContext context) {
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
                  "Etapa $sectionId Completada",
                  style: StylesApp(context)
                      .textStyleCongratulation
                      .copyWith(color: Colors.white),
                ),
                SizedBox(
                  height: 29,
                ),
                Text(
                  textAlign: TextAlign.center,
                  'El esfuerzo valió la pena  completaste la Etapa $sectionId \n “${stage?.sectionName}” \n fue completada con éxito"',
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
            "${userData!.energyPoints} lms",
            style: StylesApp(context)
                .textStyleBody12
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
              onPressed: () async {
                await SharePlus.instance.share(ShareParams(
                  text:
                      "¡Etapa $stage.sectionNumber-${stage?.sectionName} completada",
                  subject: "¡Felicita a ${userData!.username}! ",
                ));
              }),
          SizedBox(height: 43),
          ButtonThemeWidget(
            text: "Continuar",
            width: 208,
            height: 32,
            buttonStyle: StylesApp(context).btnWidgetSmall,
            onPressed: () {
              //si obtuvo premio
              if (prize != null) {
                setState(() {
                  showTitleObtained = false;
                  showLastStageCompleted = false;
                  showPrizeWon = true;
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

  // premio Obtenido
  _buildPrizeWon(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
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
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      'Haz ganado un ${prize!.typeStone} para\n tu colección',
                      style: StylesApp(context).textStyleBody20,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Container(
              width: 158,
              // height: 175,
              decoration: BoxDecoration(
                  border: Border.all(width: 15, color: Color(0XFFF3AD3D)),
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: Offset(0.0, 4.0),
                          blurStyle: BlurStyle.outer,
                          blurRadius: 4.0,
                        ),
                      ]),
                      child: Image.network(
                        GraphQLConfig.urlServidor + prize!.img.urlImg,
                        height: 80,
                      ),
                    ),
                    // Divider(
                    //   color: Colors.black.withValues(alpha: 0.50),
                    //   height: 3,
                    // ),
                    Text(
                      "${prize?.biblicalName}",
                      style: StylesApp(context)
                          .textStyleBody12
                          .copyWith(color: Colors.black),
                    ),
                    Text(
                      "${prize?.typeStone}",
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
              "Cuando lo requieras puede canjearlo\n por ${prize?.exchangeValue.toInt()}lms de energía",
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
                        height:
                            calculateHeight(userData!.energyPoints.toDouble()),
                        fit: BoxFit.contain,
                      ),
                      Text(
                        "${userData!.energyPoints} lms",
                        style: StylesApp(context)
                            .textStyleBody12
                            .copyWith(color: StyleColor.orange),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 29,
                ),
                ButtonThemeWidget(
                  text: "Continuar",
                  width: 132,
                  height: 32,
                  buttonStyle: StylesApp(context).btnWidgetSmall,
                  onPressed: () {
                    //si obtuvo Premio
                    if (title != null) {
                      setState(() {
                        showStepCompleted = false;
                        showRewardObtained = false;
                        showLastStageCompleted = false;
                        showPrizeWon = false;
                        showTitleObtained = true;
                      });
                    } else {
                      // hacemos route a aventura screen
                      Navigator.popAndPushNamed(context, '/layoutPage1');
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 43),
          ],
        ),
      ),
    );
  }

  // esta parte es para mostrar titulo obtenido
  _buildAchievementUnlocked(BuildContext context) {
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
                    "Haz obtenido\n el titulo de\n ${title?.title}!",
                    style: StylesApp(context)
                        .textStyleCongratulation
                        .copyWith(color: Colors.white),
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
                      GraphQLConfig.urlServidor + title!.img.urlImg,
                      height: 80,
                    ),
                    Text(
                      title?.title ?? "",
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
              onPressed: () async {
                try {
                  final responseDownloadCertificate =
                      await getUrlCertificate(userData!.userId, courseId);
                  if (responseDownloadCertificate.error != null) {
                    await showCustomDialog(
                      context,
                      message: responseDownloadCertificate.error!,
                      dialogType: DialogType.error,
                    );
                    return;
                  }
                  if (responseDownloadCertificate.data != null) {
                    final url =
                        "${GraphQLConfig.urlServidor}${responseDownloadCertificate.data['url']}";
                    try {
                      final response = await http.get(Uri.parse(url));
                      if (response.statusCode == 200) {
                        final directory =
                            Directory("/storage/emulated/0/Download");
                        if (!directory.existsSync()) {
                          directory.createSync(recursive: true);
                        }
                        final filePath = "${directory.path}/certificado.pdf";
                        final file = File(filePath);
                        await file.writeAsBytes(response.bodyBytes);

                        await showCustomDialogWithAction(
                          context,
                          message:
                              "Certificado descargado exitosamente en: $filePath",
                          dialogType: DialogTypeAction.info,
                          buttonOk: "Ok",
                          actionCallbackOk: () {
                            Navigator.pop(context);
                          },
                          textButton: "Abrir directorio",
                          actionCallback: () async {
                            try {
                              await launchUrl(Uri.file(directory.path));
                            } catch (e) {
                              await showCustomDialog(
                                context,
                                message:
                                    "No se pudo abrir la carpeta de descargas.",
                                dialogType: DialogType.error,
                              );
                            }
                          },
                        );
                      } else {
                        await showCustomDialog(
                          context,
                          message: "No se pudo descargar el certificado.",
                          dialogType: DialogType.error,
                        );
                      }
                    } catch (e) {
                      await showCustomDialog(
                        context,
                        message: "Error al descargar el certificado: $e",
                        dialogType: DialogType.error,
                      );
                    }
                  }
                  // if (responseDownloadCertificate.data != null) {
                  //   final url =
                  //       "${GraphQLConfig.urlServidor}${responseDownloadCertificate.data['url']}";
                  //   if (await canLaunchUrl(Uri.parse(url))) {
                  //     await launchUrl(Uri.parse(url),
                  //         mode: LaunchMode.externalApplication);
                  //   } else {
                  //     await showCustomDialog(
                  //       context,
                  //       message: "No se pudo abrir el enlace de descarga.",
                  //       dialogType: DialogType.error,
                  //     );
                  //   }
                  // }
                } catch (e) {
                  await showCustomDialog(
                    context,
                    message: e.toString(),
                    dialogType: DialogType.error,
                  );
                  return;
                }
              },
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
                await SharePlus.instance.share(ShareParams(
                  text: "¡He obtenido el titulo de ${title?.title}!",
                  subject: "¡Felicita a ${userData!.username}! ",
                ));
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
                        height:
                            calculateHeight(userData!.energyPoints.toDouble()),
                        fit: BoxFit.contain,
                      ),
                      Text(
                        "${userData!.energyPoints} lms",
                        style: StylesApp(context)
                            .textStyleBody12
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
                    onPressed: () async {
                      // if (certificateCreated != null) {
                      Navigator.popAndPushNamed(context, '/layoutPage1');
                      // } else {
                      //   try {
                      //     final responseCreateCertificate =
                      //         await createCertificate(
                      //             userData?.userId, courseId);
                      //     if (responseCreateCertificate.error != null) {
                      //       await showCustomDialog(
                      //         context,
                      //         message: responseCreateCertificate.error!,
                      //         dialogType: DialogType.error,
                      //       );
                      //       return;
                      //     }
                      //     certificateCreated =
                      //         ResponseCertificateCreated.fromJson(
                      //             responseCreateCertificate.data);
                      //   } catch (e) {
                      //     await showCustomDialog(
                      //       context,
                      //       message: e.toString(),
                      //       dialogType: DialogType.error,
                      //     );
                      //     return;
                      //   }
                      //   Navigator.popAndPushNamed(context, '/layoutPage1');
                      // }
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
