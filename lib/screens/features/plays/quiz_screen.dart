import 'package:biblia_palabra_de_vida_app/constants/app_constants.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
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
  final _translationProvider = AppTranslationProvider();
  LoginUser? userData;
  late AudioService _audioService;
  final options = AppConstants.listOption;
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
  int? _selectedAnswerIndex;
  int? _correctAnswerIndex;

  bool get isTablet {
    final width = MediaQuery.of(context).size.width;
    return width >= 600;
  }

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
          _translationProvider.tr('quiz_screen.title'),
          style: StylesApp(context)
              .textStyleBody16
              .copyWith(color: StyleColor.white),
        ),
      ),
      body: SafeArea(
          child: Container(
            child: difficulty.isEmpty
                ? _buildSelectedDifficulty()
                : _buildPlayScene(),
          )),
    );
  }

  Widget _buildSelectedDifficulty() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isTablet ? 500 : double.infinity,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: isTablet ? 20.0 : 0),
            Text(
              _translationProvider.tr('quiz_screen.difficulty_selection.title'),
              style: isTablet
                  ? StylesApp(context).textStyleBody24.copyWith(
                        color: StyleColor.black,
                        fontWeight: FontWeight.bold,
                      )
                  : StylesApp(context).textStyleBody20.copyWith(
                        color: StyleColor.black,
                      ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 40.0 : 20.0),
            _buildDifficultyButton(
                _translationProvider
                    .tr('quiz_screen.difficulty_selection.easy'),
                Icons.face_2_rounded),
            SizedBox(height: isTablet ? 24.0 : 15),
            _buildDifficultyButton(
                _translationProvider
                    .tr('quiz_screen.difficulty_selection.medium'),
                Icons.face_2_rounded),
            SizedBox(height: isTablet ? 24.0 : 15),
            _buildDifficultyButton(
                _translationProvider
                    .tr('quiz_screen.difficulty_selection.hard'),
                Icons.face_2_rounded),
            SizedBox(height: isTablet ? 40.0 : 15),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(String level, IconData icon) {
    return GestureDetector(
      onTap: () => _selectDifficulty(_getDifficultyCharacter(level)),
      child: Container(
        padding: EdgeInsets.all(isTablet ? 16.0 : 8.0),
        margin: EdgeInsets.symmetric(
          horizontal: isTablet ? 60.0 : 12.0,
          vertical: isTablet ? 8.0 : 0,
        ),
        constraints: BoxConstraints(
          minHeight: isTablet ? 100 : 80,
          minWidth: isTablet ? 300 : double.infinity,
        ),
        decoration: BoxDecoration(
          color: StyleColor.white,
          border: Border.all(
            color: StyleColor.cosmicBlue,
            strokeAlign: 0.5,
            width: isTablet ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(isTablet ? 16.0 : 8.0),
          boxShadow: [
            BoxShadow(
              blurRadius: isTablet ? 16 : 12,
              offset: Offset(0, isTablet ? 6 : 4),
              color: StyleColor.black.withValues(alpha: isTablet ? 0.2 : 0.25),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isTablet ? 32 : 24,
              color: _getDifficultyColor(level),
            ),
            SizedBox(width: isTablet ? 20.0 : 12.0),
            Text(
              level,
              style: isTablet
                  ? StylesApp(context).textStyleBody24.copyWith(
                        color: _getDifficultyColor(level),
                        fontWeight: FontWeight.w600,
                      )
                  : StylesApp(context).textStyleBody20.copyWith(
                        color: StyleColor.black,
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDifficulty(String level) async {
    if (!mounted) return;
    setState(() {
      difficulty = _getDifficultyCharacter(level);
    });
    await loadQuestions();
  }

  Widget _buildPlayScene() {
    return ResponsiveLayout(
        mobile: _buildSceneMobile(), tablet: _buildSceneTablet());
  }

  _buildSceneMobile() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _translationProvider.tr("quiz_screen.game_play.opportunities"),
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
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
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
                      SelectionQuestionWidget(
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
                        selectedAnswerIndex: _selectedAnswerIndex,
                        correctAnswerIndex: _correctAnswerIndex,
                      ),
                  },
                  SizedBox(
                    height: 47.0,
                  ),
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
          if (currentQuestion.isOrdering)
            SizedBox(
              height: 20,
            )
        ],
      ),
    );
  }

  _buildSceneTablet() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header con oportunidades y progreso
          Container(
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.only(bottom: 20.0),
            decoration: BoxDecoration(
              color: StyleColor.cosmicBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Progreso
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _translationProvider.tr("quiz_screen.game_play.progress"),
                      style: StylesApp(context)
                          .textStyleBody14
                          .copyWith(color: StyleColor.grayDark),
                    ),
                    SizedBox(height: 4),
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(8.0),
                        minHeight: 12.0,
                        value: currentIndex / (questions.length - 1),
                        backgroundColor: Color(0xFFC4C4C4),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0XFFF27728),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${currentIndex + 1}/${questions.length}",
                      style: StylesApp(context).textStyleBody14.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),

                // Oportunidades
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _translationProvider
                          .tr("quiz_screen.game_play.opportunities"),
                      style: StylesApp(context)
                          .textStyleBody14
                          .copyWith(color: StyleColor.grayDark),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Image.asset(
                          failedAttempts > 2
                              ? "assets/fire_rachaActive.png"
                              : "assets/fire_rachaInactive.png",
                          width: 24,
                        ),
                        SizedBox(width: 4),
                        Image.asset(
                          failedAttempts > 1
                              ? "assets/fire_rachaActive.png"
                              : "assets/fire_rachaInactive.png",
                          width: 24,
                        ),
                        SizedBox(width: 4),
                        Image.asset(
                          failedAttempts > 0
                              ? "assets/fire_rachaActive.png"
                              : "assets/fire_rachaInactive.png",
                          width: 24,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Contenedor principal con dos columnas
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // COLUMNA IZQUIERDA: Pregunta
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.only(right: 12.0),
                    decoration: BoxDecoration(
                      color: Color(0XFFFFBB00),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          offset: Offset(0.0, 6.0),
                          blurRadius: 12.0,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            currentQuestion.isOrdering
                                ? Icons.sort
                                : Icons.question_answer,
                            size: 48,
                            color: Colors.white,
                          ),
                          SizedBox(height: 16),
                          Text(
                            currentQuestion.question,
                            style: StylesApp(context).textStyleBody20.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  height: 1.4,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              currentQuestion.isOrdering
                                  ? _translationProvider.tr(
                                      "quiz_screen.game_play.ordering_question")
                                  : _translationProvider.tr(
                                      "quiz_screen.game_play.selection_question"),
                              style:
                                  StylesApp(context).textStyleBody14.copyWith(
                                        color: Colors.white,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // COLUMNA DERECHA: Opciones/Respuestas
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: StyleColor.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Indicador del tipo de pregunta
                        Container(
                          padding: EdgeInsets.all(12.0),
                          margin: EdgeInsets.only(bottom: 20.0),
                          decoration: BoxDecoration(
                            color: currentQuestion.isOrdering
                                ? StyleColor.turquoise.withValues(alpha: 0.1)
                                : StyleColor.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: currentQuestion.isOrdering
                                  ? StyleColor.turquoise
                                  : StyleColor.orange,
                              width: 2.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                currentQuestion.isOrdering
                                    ? Icons.info_outline
                                    : Icons.help_outline,
                                color: currentQuestion.isOrdering
                                    ? StyleColor.turquoise
                                    : StyleColor.orange,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Text(
                                currentQuestion.isOrdering
                                    ? _translationProvider.tr(
                                        "quiz_screen.game_play.ordering_instruction")
                                    : _translationProvider.tr(
                                        "quiz_screen.game_play.selection_instruction"),
                                style:
                                    StylesApp(context).textStyleBody16.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                              ),
                            ],
                          ),
                        ),
                        if (questions.isNotEmpty)
                          // Área de preguntas/opciones
                          Expanded(
                            child: currentQuestion.isOrdering
                                ? OrderingQuestionDraggableWidget(
                                    orderedCompleted: orderedCompleted,
                                    orderedAnswers: orderedAnswers,
                                    currentQuestion: currentQuestion,
                                    options: options,
                                    answerSelected: (context, index) =>
                                        verifyOrdered(context, index),
                                    showError: showError,
                                    onContinue: funcAnswerValidate,
                                    // isTablet: isTablet,
                                  )
                                : SelectionQuestionWidget(
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
                                    selectedAnswerIndex: _selectedAnswerIndex,
                                    correctAnswerIndex: _correctAnswerIndex,
                                    // isTablet: isTablet,
                                  ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
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
        _audioService.playFailedAttempts();
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
    // Mostrar loading
    LoadingService().showLoading(context);

    // Actualizar estado de manera más eficiente
    _isAnswerSelected = true;
    _suggestionSelected = false;
    _selectedAnswerIndex = index;

    // Determinar si es correcta
    _isCorrect = currentAnswers[index].isCorrect;

    // Encontrar índice de respuesta correcta (solo si es necesario)
    int correctIndex = -1;
    if (!_isCorrect) {
      correctIndex = currentAnswers.indexWhere((answer) => answer.isCorrect);
    }

    // Reproducir audio según resultado
    if (_isCorrect) {
      _audioService.playCorrectAnswer();
    } else {
      _audioService.playWrongAnswer();
      failedAttempts -= 1;
      _suggestionSelected = true;
    }

    // Actualizar estado final
    _correctAnswerIndex = correctIndex;
    _selectionCompleted = true;

    // Forzar reconstrucción una sola vez
    setState(() {});

    // Ocultar loading
    LoadingService().hideLoading();

    // Mostrar SnackBar (sin 24 horas de duración)
    if (mounted) {
      _showResultSnackBar(context, index);
    }
  }

  void _showResultSnackBar(BuildContext context, int index) {
    final snackBar = SnackBar(
      duration: const Duration(hours: 24), // Reducido a 3 segundos
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                _isCorrect ? Icons.check_circle : Icons.error,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                _isCorrect
                    ? _translationProvider.tr("quiz_screen.snackbar.correct")
                    : _translationProvider.tr("quiz_screen.snackbar.incorrect"),
                style: StylesApp(context).textStyleBody12,
              ),
            ],
          ),
          TextButton(
            onPressed: () async {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              await funcAnswerValidate();
              setState(() {
                _selectedAnswerIndex = null;
                _correctAnswerIndex = null;
              });
            },
            child: Text(
              _translationProvider.tr("quiz_screen.game_play.next"),
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: _isCorrect ? Colors.green : Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            // questions[i] = questions[i].copyWith(
            //     question:
            //         "esto es una prueba de una pregun muuuuuyy larga para poder revisa si se puede obtenr un scroll que permita vizualiozar todo el contenido");
            // questions[i].answers[j] = questions[i].answers[j].copyWith(
            //     answer:
            //         "Esta es una respuesta o opción muy larga que se va  a implemenatr para validar que tanto pueden extenderse las cajas y que tanto es el scrooll de la pantalla que va  apermirt para el usuario pueda ver todas las opciones en el dispositivo movíl , ");
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
        title: Text(_translationProvider
            .tr("quiz_screen.failed_attempts_dialog.title")),
        content: Text(
          _translationProvider.tr("quiz_screen.failed_attempts_dialog.message"),
        ),
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
            child: Text(_translationProvider
                .tr("quiz_screen.failed_attempts_dialog.play_again")),
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
            buttonOk:
                _translationProvider.tr("quiz_screen.load_error_dialog.back"),
            actionCallbackOk: () {
              Navigator.pop(context);
            },
            textButton:
                _translationProvider.tr("quiz_screen.load_error_dialog.retry"),
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
            buttonOk:
                _translationProvider.tr("quiz_screen.load_error_dialog.back"),
            actionCallbackOk: () {
              Navigator.pop(context);
            },
            textButton:
                _translationProvider.tr("quiz_screen.load_error_dialog.retry"),
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
                "${_translationProvider.trParams("quiz_screen.result_dialog.category", {
                      "category": infoResult.message.category!,
                    })}\n ${_translationProvider.trParams("quiz_screen.result_dialog.difficulty", {
                      "difficulty": infoResult.message.difficulty!,
                    })}\n",
              ),
              Text(_translationProvider
                  .trParams("quiz_screen.result_dialog.score", {
                "score": infoResult.score.toString(),
              }))
            ],
          ),
          actions: [
            ButtonThemeWidget(
              text: _translationProvider
                  .tr("quiz_screen.result_dialog.play_again"),
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
          buttonOk: _translationProvider.tr("quiz_screen.error_dialog.back"),
          actionCallbackOk: () {
            Navigator.pop(context);
          },
          textButton: _translationProvider.tr("quiz_screen.error_dialog.retry"),
          actionCallback: () {
            _showDialogFinallyPlay();
          });
    } finally {
      LoadingService().hideLoading();
    }
  }

  Color _getDifficultyColor(String level) {
    if (_translationProvider.tr('quiz_screen.difficulty_selection.easy') ==
        level) {
      return StyleColor.greenDark;
    } else if (_translationProvider
            .tr('quiz_screen.difficulty_selection.medium') ==
        level) {
      return StyleColor.orange;
    } else if (_translationProvider
            .tr('quiz_screen.difficulty_selection.hard') ==
        level) {
      return StyleColor.redDark;
    } else {
      return StyleColor.greenDark;
    }
  }

  String _getDifficultyCharacter(String level) {
    if (_translationProvider.tr('quiz_screen.difficulty_selection.easy') ==
        level) {
      return 'F';
    } else if (_translationProvider
            .tr('quiz_screen.difficulty_selection.medium') ==
        level) {
      return 'I';
    } else if (_translationProvider
            .tr('quiz_screen.difficulty_selection.hard') ==
        level) {
      return 'D';
    } else {
      return 'F';
    }
  }
}
