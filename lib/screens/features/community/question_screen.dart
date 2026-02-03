import 'dart:io';
import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/constants/app_constants.dart';
import 'package:biblia_palabra_de_vida_app/services/streak_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
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

// Importar los nuevos componentes

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final options = AppConstants.listOption;

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

  // Constantes
  int MAX_SCORE = 0;
  int MEDIUM_SCORE = 0;
  int LOW_SCORE = 0;

  // Añade estas variables para TTS
  FlutterTts flutterTts = FlutterTts();
  bool isTtsEnabled = false;
  bool isTtsSpeaking = false;
  double ttsVolume = 1.0;
  double ttsRate = 0.5;
  double ttsPitch = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateData(context);
      getFontSizeText();
      _initTts();
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  // Inicializar TTS
  Future<void> _initTts() async {
    // Verificar preferencias de usuario para TTS
    bool? savedTtsEnabled = await PreferencesManager().getTtsEnabled();
    setState(() {
      // isTtsEnabled = savedTtsEnabled ?? false;
    });

    // Configurar TTS
    await flutterTts.setVolume(ttsVolume);
    await flutterTts.setSpeechRate(ttsRate);
    await flutterTts.setPitch(ttsPitch);
    await flutterTts.setLanguage("es-ES");

    // Configurar handlers de eventos
    flutterTts.setStartHandler(() {
      setState(() {
        isTtsSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isTtsSpeaking = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isTtsSpeaking = false;
      });
      if (kDebugMode) {
        print("TTS Error: $msg");
      }
    });
  }

  // Leer pregunta actual
  Future<void> _speakQuestion() async {
    if (!isTtsEnabled || currentQuestion.question.isEmpty) return;

    String textToSpeak = "Pregunta $numberQuestion de ${questions.length}. "
        "${currentQuestion.question}";

    await flutterTts.speak(textToSpeak);
  }

  // Leer opciones de respuesta
  Future<void> _speakOptions() async {
    if (!isTtsEnabled || currentAnswers.isEmpty) return;

    StringBuffer optionsText = StringBuffer();
    optionsText.write("Opciones: ");

    for (int i = 0; i < currentAnswers.length; i++) {
      optionsText.write("Opción ${String.fromCharCode(65 + i)}: ");
      optionsText.write(currentAnswers[i].answer);
      if (i < currentAnswers.length - 1) {
        optionsText.write(". ");
      }
    }

    await flutterTts.speak(optionsText.toString());
  }

  // Leer respuesta específica
  Future<void> _speakAnswer(int index) async {
    if (!isTtsEnabled || index >= currentAnswers.length) return;

    String textToSpeak = "Opción ${String.fromCharCode(65 + index)}: "
        "${currentAnswers[index].answer}";

    await flutterTts.speak(textToSpeak);
  }

  // Detener TTS
  Future<void> _stopTts() async {
    await flutterTts.stop();
    setState(() {
      isTtsSpeaking = false;
    });
  }

  // Alternar estado TTS
  Future<void> _toggleTts() async {
    bool newState = !isTtsEnabled;
    setState(() {
      isTtsEnabled = newState;
    });

    await PreferencesManager().setTtsEnabled(newState);

    if (!newState) {
      await _stopTts();
    }
  }

  Future<void> getFontSizeText() async {
    double? fontSize = await PreferencesManager().getFontSizeQuestion();
    setState(() => fontSizeText = fontSize);
  }

  ///
  //función que se encarga de cargar los datos iniciales de la pantalla
  ///
  Future<void> _generateData(BuildContext context) async {
    setState(() => isLoading = true);

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
        _initializeQuestions(questionResponse.data);
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

  void _initializeQuestions(List<dynamic> data) {
    setState(() {
      questions = data
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
  }

  ///
  /// Función que se encarga de marcar respuesta seleccionada
  ///
  void _answerSelected(BuildContext context, int index) {
    // Primero leer la opción seleccionada
    if (isTtsEnabled) {
      _speakAnswer(index);
    }

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
    _showAnswerSnackbar(context);
  }

  void _showAnswerSnackbar(BuildContext context) {
    // Leer feedback de respuesta
    if (isTtsEnabled) {
      String feedback =
          _isCorrect ? "¡Respuesta correcta!" : "Respuesta incorrecta";
      flutterTts.speak(feedback);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(hours: 24),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(_isCorrect ? Icons.check_circle : Icons.error,
                    color: Colors.white),
                SizedBox(width: 8),
                Text(_isCorrect ? '¡Muy bien!' : '¡Oh, lo siento!'),
              ],
            ),
            TextButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                await funcAnswerValidate();
                if (mounted) {
                  setState(() {
                    _isAnswerSelected = false;
                    _suggestionSelected = false;
                  });
                }
              },
              child: Text('Siguiente', style: TextStyle(color: Colors.white)),
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
              level:
                  LevelUser(levelNumber: level!.levelNumber, id: "", name: ""),
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
              level:
                  LevelUser(levelNumber: level!.levelNumber, id: "", name: ""),
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
          bestScore = levelProgress!.scoreLastAttempt;
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
        await _checkForStreakCelebration();

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
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
        body: SafeArea(
          child: _buildMainContent(),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if (isLoading) return Container();
    if (errorMessage != null) {
      return BuildErrorWidget(
        errorMessage: errorMessage!,
        onRetry: () async => _generateData(context),
        onBack: () => Navigator.pop(context),
      );
    }

    // Usar ResponsiveLayout para manejar móvil/tablet
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildCommonHeader(),
        if (_shouldShowQuestionContent()) ...[
          SizedBox(height: 19),
          _buildTtsControls(),
          QuestionCard(
            question: currentQuestion.question,
            numberQuestion: numberQuestion,
            totalQuestions: questions.length,
            failedAttempts: failedAttempts,
            fontSize: fontSizeText,
            isTablet: false,
            onSpeakQuestion: isTtsEnabled ? _speakQuestion : null,
          ),
          SizedBox(height: 38),
          Expanded(child: _buildQuestionBody()),
        ] else if (activityIsCompleted) ...[
          Expanded(child: _buildResultScreen(context)),
        ],
      ],
    );
  }

// Widget para controles TTS
  Widget _buildTtsControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón para activar/desactivar TTS
          IconButton(
            icon: Icon(
              isTtsEnabled ? Icons.volume_up : Icons.volume_off,
              color: isTtsEnabled ? Colors.blue : Colors.grey,
            ),
            onPressed: _toggleTts,
            tooltip: isTtsEnabled ? "Desactivar lectura" : "Activar lectura",
          ),

          // Controles de TTS solo si está activado
          if (isTtsEnabled) ...[
            // Botón para leer pregunta
            IconButton(
              icon: Icon(
                isTtsSpeaking ? Icons.stop : Icons.play_arrow,
                color: Colors.blue,
              ),
              onPressed: isTtsSpeaking ? _stopTts : _speakQuestion,
              tooltip: isTtsSpeaking ? "Detener lectura" : "Leer pregunta",
            ),

            // Botón para leer opciones
            IconButton(
              icon: Icon(Icons.list, color: Colors.blue),
              onPressed: _speakOptions,
              tooltip: "Leer opciones",
            ),
          ],

          // Espaciador
          Spacer(),

          // Opcional: ajustar velocidad
          if (isTtsEnabled && isTablet(context))
            Row(
              children: [
                Icon(Icons.speed, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  "Velocidad",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(width: 8),
                Slider(
                  value: ttsRate,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  onChanged: (value) async {
                    setState(() => ttsRate = value);
                    await flutterTts.setSpeechRate(value);
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        _buildCommonHeader(),
        if (_shouldShowQuestionContent()) ...[
          SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna izquierda
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTtsControls(),
                          QuestionCard(
                            question: currentQuestion.question,
                            numberQuestion: numberQuestion,
                            totalQuestions: questions.length,
                            failedAttempts: failedAttempts,
                            fontSize: fontSizeText,
                            isTablet: true,
                            onSpeakQuestion:
                                isTtsEnabled ? _speakQuestion : null,
                          ),
                          SizedBox(height: 20),
                          ProgressControls(
                            fontSize: fontSizeText,
                            currentValue: currentIndex.toDouble(),
                            maxValue: _calculateProgressValue(),
                            onFontSizeChanged: _updateFontSize,
                            isTablet: true,
                          ),
                          Spacer(),
                          _buildLevelInfo(),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 16),

                  // Columna derecha: Respuestas
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _buildQuestionBody(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ] else if (activityIsCompleted) ...[
          Expanded(child: _buildResultScreen(context)),
        ],
      ],
    );
  }

  Widget _buildCommonHeader() {
    final showStageInfo = !showTitleObtained &&
        !showRewardObtained &&
        !showPrizeWon &&
        !showLastStageCompleted;

    return QuestionHeader(
      course: course,
      stage: stage,
      level: level,
      numberQuestion: numberQuestion,
      showStageInfo: showStageInfo,
      onBack: () => Navigator.pop(context),
    );
  }

  Widget _buildQuestionBody() {
    if (currentQuestion.isOrdering) {
      return OrderingQuestionDraggableWidget(
        orderedCompleted: orderedCompleted,
        orderedAnswers: orderedAnswers,
        currentQuestion: currentQuestion,
        options: options,
        fontSize: fontSizeText,
        answerSelected: verifyOrdered,
        showError: showError,
        onContinue: funcAnswerValidate,
      );
    }

    return SelectionQuestionWidget(
      suggestionSelected: _suggestionSelected,
      selectionCompleted: _selectionCompleted,
      isCorrect: _isCorrect,
      currentQuestion: currentQuestion,
      options: options,
      fontSize: fontSizeText,
      answerSelected: _answerSelected,
      callBackContinue: () {},
      isAnswerSelected: _isAnswerSelected,
    );
  }

  Widget _buildResultScreen(BuildContext context) {
    if (showStepCompleted) return _buildActivityCompleted();
    if (showRewardObtained) return _buildRewardScreen();
    if (showLastStageCompleted) return _buildLastStage(context);
    if (showPrizeWon) return _buildPrizeWon(context);
    if (showTitleObtained) return _buildAchievementUnlocked(context);
    return Container();
  }

  Widget _buildRewardScreen() {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isTablet(context) ? 600 : double.infinity,
        ),
        child: RewardWidget(
          rewardInfo: reward,
          onPressed: () async {
            if (sendScore!.isLastStage && !showReview) {
              setState(() {
                showStepCompleted = false;
                showTitleObtained = false;
                showRewardObtained = false;
                showLastStageCompleted = true;
              });
            } else {
              Navigator.popAndPushNamed(context, '/mapPage', arguments: {
                'courseId': courseId,
                'sectionId': nextSectionId.isEmpty ? sectionId : nextSectionId
              });
            }
          },
        ),
      ),
    );
  }

  String _getBackgroundImage() {
    if (levelProgress == null) return "assets/boxStartFailed.png";

    final score = levelProgress!.score;
    if (score > MEDIUM_SCORE) return "assets/boxStartFull.png";
    if (score > LOW_SCORE && score <= MEDIUM_SCORE)
      return "assets/boxStartMedium.png";
    if (score > 0 && score <= LOW_SCORE) return "assets/boxStartLow.png";
    return "assets/boxStartFailed.png";
  }

  // Método reutilizable para construir contenido del resultado
  Widget _buildResultContent() {
    return Column(
      children: [
        Text(
          '${levelProgress!.score > 0 ? levelProgress!.message.resultTitle : "Ya casi lo\n logras!"}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet(context) ? 28 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isTablet(context) ? 16 : 8),
        Text(
          levelProgress!.score > 0
              ? 'Culminaste el Paso ${levelProgress!.level.levelNumber}'
              : "Intenta nuevamente el\n Paso ${levelProgress!.level.levelNumber} para avanzar",
          textAlign: TextAlign.center,
          style: StylesApp(context).textStyleBody16.copyWith(
                color: Colors.white,
                fontSize: isTablet(context) ? 20 : 16,
              ),
        ),
        if (levelProgress!.score > 0 && !showReview) ...[
          SizedBox(height: isTablet(context) ? 20 : 8),
          Text(
            'Haz ganado\n ${levelProgress!.energy} LMs de energía',
            textAlign: TextAlign.center,
            style: StylesApp(context).textStyleBody16.copyWith(
                  color: Colors.white,
                  fontSize: isTablet(context) ? 18 : 16,
                ),
          ),
        ],
      ],
    );
  }

  // Método reutilizable para construir acciones del resultado
  Widget _buildResultActions() {
    return Column(
      children: [
        if (levelProgress!.score > 0 && !showReview) ...[
          Image.asset(
            "assets/kawaii_fire.png",
            height: isTablet(context) ? 100 : 60,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 12),
          Text(
            "${levelProgress!.energy.toStringAsFixed(0)} lms",
            style: StylesApp(context).textStyleBody16.copyWith(
                  color: Color(0XFFFD8C43),
                  fontSize: isTablet(context) ? 18 : 16,
                ),
          ),
          SizedBox(height: 20),
        ],
        ButtonThemeWidget(
          text: "Continuar",
          width: isTablet(context) ? 200 : 132,
          height: isTablet(context) ? 48 : 32,
          buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                textStyle: WidgetStatePropertyAll(
                  StylesApp(context).textStyleBody16.copyWith(
                        fontSize: isTablet(context) ? 16 : 14,
                      ),
                ),
              ),
          onPressed: _handleContinue,
        ),
      ],
    );
  }

  void _handleContinue() async {
    // Lógica reutilizable para continuar
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
      Navigator.popAndPushNamed(context, '/mapPage',
          arguments: {'courseId': courseId, 'sectionId': sectionId});
    }
  }

  // Helper para verificar si mostrar contenido de pregunta
  bool _shouldShowQuestionContent() {
    return !activityIsCompleted &&
        !showTitleObtained &&
        !showRewardObtained &&
        !showPrizeWon &&
        !showLastStageCompleted;
  }

  // Helper para info de nivel en tablet
  Widget _buildLevelInfo() {
    if (level == null) return Container();

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nivel actual",
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(fontSize: 12, color: Colors.grey[600])),
          Text(level!.name,
              style: StylesApp(context).textStyleBody16.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal)),
          SizedBox(height: 4),
          Text("Paso $numberQuestion",
              style: StylesApp(context)
                  .textStyleBody14
                  .copyWith(fontSize: 14, color: Colors.grey[700])),
        ],
      ),
    );
  }

  void _updateFontSize(double value) async {
    await PreferencesManager().setFontSizeQuestion(value);
    setState(() => fontSizeText = value);
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

  // esta parte es para mostrar nivel Completado
  Widget _buildActivityCompleted() {
    // Usar el mismo componente para móvil y tablet con diseño responsivo interno
    return SingleChildScrollView(
      padding: EdgeInsets.all(isTablet(context) ? 24 : 20),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
              maxWidth: isTablet(context) ? 800 : double.infinity),
          child: Column(
            children: [
              // Contenido adaptable según tamaño
              Container(
                padding: EdgeInsets.all(isTablet(context) ? 32 : 20),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(isTablet(context) ? 16 : 8),
                  image: DecorationImage(
                    image: AssetImage(_getBackgroundImage()),
                    fit: BoxFit.cover,
                  ),
                ),
                child: _buildResultContent(),
              ),
              SizedBox(height: isTablet(context) ? 32 : 20),
              _buildResultActions(),
            ],
          ),
        ),
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
                      Navigator.popAndPushNamed(context, '/layoutPage1');
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

  double _calculateProgressValue() {
    // Validar que haya historias
    if (questions.isEmpty) return 1.0;

    // Calcular progreso seguro
    final double totalItems = questions.length.toDouble();
    final double maxPage = totalItems > 1 ? totalItems - 1 : totalItems;

    // Evitar división por cero
    if (maxPage <= 0) return 1.0;

    return maxPage;
  }

  Future<void> _checkForStreakCelebration() async {
    // Verificar si deberíamos mostrar la celebración
    final shouldShow = await StreakService.shouldShowCelebration();

    if (shouldShow) {
      // Obtener datos del calendario
      final ResponseData response =
          await streaksCalendar(userData!.userId, DateTime.now().month);

      if (response.error == null) {
        final streakCalendar = DateCalendar.fromJson(response.data);

        // Mostrar diálogo de celebración
        WidgetsBinding.instance.addPostFrameCallback((_) {
          StreakService.showStreakCelebration(
            context: context,
            streakCalendar: streakCalendar,
            onSeeDetails: () {
              // Navegar a pantalla de detalles de racha
              Navigator.pushNamed(context, '/streak-details');
            },
          );
        });
      }
    }
  }
}
