import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final PageController _controllerPage = PageController();
  late ConfettiController _confettiController;
  double fontSizeText = 16.sp;
  double isPage = 0;
  List<History> stories = [];
  bool isLoading = true;
  String? errorMessage;
  CourseDetail? course;
  Level? level;
  Stage? stage;
  int _selectedButtonIndex = 1;
  String levelId = '';
  String sectionId = '';
  String courseId = '';
  bool finalStory = false;
  int storyIndex = 0;
  // variables para TTS
  late FlutterTts flutterTts;
  bool isPlaying = false;
  double _speechRate = 0.5; // Velocidad por defecto
  bool _isProgrammaticNavigation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController = ConfettiController(duration: Duration(seconds: 10));
      _initTTS(); // Inicializar TTS
      _generateData(context);
      getFontSizeText();
    });
  }

  getFontSizeText() async {
    double? fontSize = await PreferencesManager().getFontSizeVerse();
    setState(() => fontSizeText = fontSize);
  }

  Future<void> _generateData(BuildContext context) async {
    if (!mounted) return;
    final translationProvider = context.read<AppTranslationProvider>();
    LoadingService().showLoading(context);

    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      _cleanupLoading();
      setState(() {
        errorMessage = translationProvider.tr('history_screen.error_arguments');
        isLoading = false;
      });
      return;
    }

    try {
      levelId = args['levelId'] ?? '';
      sectionId = args['sectionId'] ?? '';
      courseId = args['courseId'] ?? '';

      // Validar IDs
      if (levelId.isEmpty || sectionId.isEmpty || courseId.isEmpty) {
        setState(() {
          errorMessage =
              translationProvider.tr('history_screen.error_parameters');
        });
      }
      setState(() {});

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final LoginUser? userData = userProvider.currentUser;

      if (userData == null) {
        setState(() {
          errorMessage =
              translationProvider.tr('history_screen.user_no_authenticate');
        });
      }

      final ResponseData responseCourse = await loadOneCourse(
        userData!.userId,
        courseId,
      );

      if (!mounted) return;

      if (responseCourse.error != null) {
        errorMessage = responseCourse.error;
        return;
      }
      course = CourseDetail.fromJson(removeTypename(responseCourse.data));

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
      level = Level.fromJson(removeTypename(levelResponse.data));

      // obtenemos las historias
      final ResponseData historyResponse = await loadStoriesByLevel(levelId);

      if (historyResponse.error != null) {
        errorMessage = historyResponse.error;
        return;
      }
      if (historyResponse.data == null ||
          (historyResponse.data is List && historyResponse.data.isEmpty)) {
        errorMessage = translationProvider.tr('history_screen.no_stories');
        return;
      }
      setState(() {
        stories = historyResponse.data
            .map((story) => History.fromJson(removeTypename(story)))
            .cast<History>()
            .toList();
        // stories.insert(
        //     0,
        //     History(
        //       id: '11111111111',
        //       orderCard: 1,
        //       level: IntermediateLevel(unLockLevel: true, levelNumber: 2),
        //       status: 1,
        //       text:
        //           ' texto normal  y texto en idioma  וַיָּמָת יוֹסֵף בֶּן־מֵאָה וָעֶשֶׂר שָׁנִים וַיַּחַנְטוּ אֹתוֹ וַיִּישֶׂם בָּאָרוֹן בְּמִצְרָֽיִם',
        //       img: Img(urlImg: 'assets/intro.png'),
        //       audio: null,
        //       video: null,
        //     ));
        // stories.insert(
        //     1,
        //     History(
        //       id: '11111111111',
        //       orderCard: 1,
        //       level: IntermediateLevel(unLockLevel: true, levelNumber: 2),
        //       status: 1,
        //       text:
        //           'Love is patient, love is kind. It does not envy, it does not boast, it is not proud. It does not dishonor others, it is not self-seeking, it is not easily angered, it keeps no record of wrongs.',
        //       img: Img(urlImg: 'assets/intro.png'),
        //       audio: null,
        //       video: null,
        //     ));
        isPlaying = true;
      });
      _togglePlayPause(stories[0]);
    } catch (e) {
      errorMessage =
          "${translationProvider.tr('history_screen.an_error_occurred')}: $e";
    } finally {
      LoadingService().hideLoading();
      setState(() {
        isLoading = false;
      });
    }
  }

  void _cleanupLoading() {
    try {
      LoadingService().hideLoading();
    } catch (_) {
      // Ignorar errores al ocultar loading
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    flutterTts.stop(); // Detener TTS al salir
    _controllerPage.dispose();
    _confettiController.dispose();
    super.dispose();
  }

// Función para detectar si es tablet

  @override
  Widget build(BuildContext context) {
    final translationProvider = context.read<AppTranslationProvider>();

    return Scaffold(
      body: SafeArea(
        child: ResponsiveLayout(
          mobile: _buildMobileLayout(translationProvider),
          tablet: _buildTabletLayout(translationProvider),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(AppTranslationProvider translationProvider) {
    return Row(
      children: [
        // Columna izquierda: Información del curso y controles
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.white,
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
                    HeaderNotDetailsStageWidget(
                      title:
                          "${translationProvider.tr('history_screen.title')} ${course?.titleCourse}",
                      stage:
                          stage != null ? stage!.sectionNumber.toString() : '',
                      subtitle: stage != null ? stage!.sectionName : '',
                      details: stage,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: StyleColor.orange,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level != null ? level!.name : '',
                            style: StylesApp(context).textStyleBody5.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "${translationProvider.tr('history_screen.level_name')} ${finalStory ? stories.length : (isPage + 1).floorToDouble().toStringAsFixed(0)} de ${stories.length}",
                            style: StylesApp(context).textStyleBody5.copyWith(
                                  fontSize: 14,
                                ),
                          ),
                        ],
                      ),
                    ),

                    // Controles de reproducción TTS
                    if (!finalStory)
                      Container(
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  translationProvider
                                      .tr('history_screen.voice_control'),
                                  style: StylesApp(context)
                                      .textStyleBody16
                                      .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: StyleColor.black,
                                      ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: StyleColor.turquoise,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    setState(() => isPlaying = !isPlaying);
                                    if (stories.isNotEmpty &&
                                        (finalStory
                                            ? storyIndex < stories.length
                                            : storyIndex < stories.length)) {
                                      _togglePlayPause(stories[storyIndex]);
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.speed,
                                    size: 20, color: StyleColor.black),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Slider(
                                    value: _speechRate,
                                    min: 0.1,
                                    max: 1.0,
                                    divisions: 9,
                                    label: _getSpeedLabel(
                                        _speechRate, translationProvider),
                                    activeColor: StyleColor.turquoise,
                                    inactiveColor: StyleColor.turquoise
                                        .withValues(alpha: 0.3),
                                    onChanged: (value) async {
                                      setState(() => _speechRate = value);
                                      await flutterTts.setSpeechRate(value);
                                      await PreferencesManager()
                                          .setTtsSpeechRate(value);
                                    },
                                  ),
                                ),
                                SizedBox(width: 12),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: StyleColor.turquoise
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${(_speechRate * 100).round()}%',
                                    style: TextStyle(
                                      color: StyleColor.turquoise,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    // Controles de navegación
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.skip_previous),
                                  label: Text(
                                    translationProvider
                                        .tr('history_screen.beginning'),
                                    style: StylesApp(context)
                                        .textStyleBody10
                                        .copyWith(
                                          fontSize: 14.0,
                                        ),
                                  ),
                                  onPressed: () {
                                    // SIEMPRE permitir ir al inicio, incluso en finalStory
                                    if (stories.isNotEmpty) {
                                      setState(() {
                                        isPage = 0;
                                        storyIndex = 0;
                                        finalStory =
                                            false; // Salir del modo finalStory
                                        isPlaying = false;
                                      });
                                      flutterTts.stop();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: StyleColor.twilightBlue,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.skip_next),
                                  label: Text(
                                    translationProvider
                                        .tr('history_screen.end'),
                                    style: StylesApp(context)
                                        .textStyleBody10
                                        .copyWith(
                                          fontSize: 14.0,
                                        ),
                                  ),
                                  onPressed: () async {
                                    if (stories.isNotEmpty) {
                                      // // Ir al final de las historias

                                      _controllerPage
                                          .animateToPage(
                                        stories.length - 1,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      )
                                          .then((_) {
                                        // Restablecer después de la animación
                                        if (mounted) {
                                          setState(() {
                                            _isProgrammaticNavigation =
                                                false; // ← Restablecer
                                          });
                                        }
                                      });

                                      setState(() {
                                        _isProgrammaticNavigation = true;
                                        isPage =
                                            (stories.length - 1).toDouble();
                                        storyIndex = stories.length - 1;
                                        isPlaying = false;
                                        finalStory = true;
                                      });
                                      await flutterTts.stop();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: StyleColor.turquoise,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          if (!finalStory && stories.isNotEmpty) ...[
                            LinearProgressIndicator(
                              value: _calculateProgressValue(),
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  StyleColor.turquoise),
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${translationProvider.tr('history_screen.progress')}: ${((isPage / (stories.length > 1 ? stories.length - 1 : stories.length)) * 100).toStringAsFixed(0)}%',
                              style:
                                  StylesApp(context).textStyleBody12.copyWith(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    Spacer(),

                    // Botones de acción final - SOLO mostrar si finalStory es true
                    if (finalStory) ...[
                      Container(
                        margin: EdgeInsets.all(16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: StyleColor.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: StyleColor.orange),
                        ),
                        child: Column(
                          children: [
                            Text(
                              translationProvider
                                  .tr('history_screen.congratulations'),
                              style:
                                  StylesApp(context).textStyleBody18.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: StyleColor.orange,
                                      ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "${translationProvider.tr('history_screen.congratulations')} ${translationProvider.tr('history_screen.completed_story')}",
                              textAlign: TextAlign.center,
                              style:
                                  StylesApp(context).textStyleBody16.copyWith(
                                        color: Colors.grey[700],
                                        fontSize: 16.0,
                                      ),
                            ),
                            SizedBox(height: 16),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (stories.isNotEmpty) {
                                      setState(() {
                                        finalStory = false;
                                        isPage = 0;
                                        storyIndex = 0;
                                        isPlaying = false;
                                      });
                                      flutterTts.stop();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: StyleColor.turquoise,
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(double.infinity, 48),
                                  ),
                                  child: Text(
                                    translationProvider
                                        .tr('history_screen.restart_story'),
                                    style: StylesApp(context)
                                        .textStyleBody16
                                        .copyWith(
                                          fontSize: 16.0,
                                        ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.popAndPushNamed(
                                      context,
                                      "/questionPage",
                                      arguments: {
                                        'courseId': courseId,
                                        "levelId": levelId,
                                        "sectionId": sectionId
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: StyleColor.orange,
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(double.infinity, 48),
                                  ),
                                  child: Text(
                                    translationProvider.tr(
                                        'history_screen.continue_questions'),
                                    style: StylesApp(context)
                                        .textStyleBody16
                                        .copyWith(
                                          fontSize: 16.0,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  }
                }
              ],
            ),
          ),
        ),

        // Columna derecha: Contenido de la historia
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.grey[50],
            child: Column(
              children: [
                if (!isLoading && errorMessage == null) ...[
                  if (finalStory) ...[
                    Expanded(
                      child: Stack(
                        children: [
                          // Confeti
                          Align(
                            alignment: Alignment.topCenter,
                            child: ConfettiWidget(
                              confettiController: _confettiController,
                              blastDirection: -1.0, // Hacia arriba
                              emissionFrequency: 0.05,
                              numberOfParticles: 20,
                              maxBlastForce: 100,
                              minBlastForce: 80,
                              gravity: 0.2,
                              shouldLoop: true,
                              colors: const [
                                Colors.green,
                                Colors.blue,
                                Colors.pink,
                                Colors.orange,
                                Colors.purple,
                              ],
                            ),
                          ),
                          // Contenido principal
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 250,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 221, 193, 148),
                                    borderRadius: BorderRadius.circular(200),
                                  ),
                                  child: Stack(children: [
                                    Center(
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(200),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Image.asset(
                                        "assets/comingSoon.gif",
                                        height: 200,
                                        width: 200,
                                      ),
                                    ),
                                  ]),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        translationProvider.tr(
                                            'history_screen.congratulations'),
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: StyleColor.orange,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        translationProvider.tr(
                                            'history_screen.has_completed_story'),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        translationProvider.tr(
                                            'history_screen.continue_learning'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Activar confeti cuando aparece la pantalla final
                    if (finalStory)
                      Builder(
                        builder: (_) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            initConfetti();
                          });
                          return SizedBox.shrink();
                        },
                      ),
                  ] else if (stories.isNotEmpty) ...[
                    // Vista normal de la historia
                    Expanded(
                      child: PageView.builder(
                        controller: _controllerPage,
                        onPageChanged: (index) async {
                          if (_isProgrammaticNavigation) {
                            setState(() {
                              isPage = index.toDouble();
                              storyIndex = index;
                              isPlaying = false; // ← Mantener detenido
                            });
                            return;
                          }
                          if (index >= stories.length - 1) {
                            setState(() {
                              finalStory = true;
                            });
                          } else {
                            setState(() {
                              isPage = index.toDouble();
                              storyIndex = index;
                              isPlaying = true;
                            });
                          }
                          await flutterTts.stop();
                          if (index < stories.length) {
                            _togglePlayPause(stories[index]);
                          }
                        },
                        itemCount: stories.length,
                        itemBuilder: (context, index) {
                          final story = stories[index];
                          final ScrollController pageScrollController =
                              ScrollController();
                          return _buildTabletStoryContent(
                              story, pageScrollController, translationProvider);
                        },
                      ),
                    ),
                  ] else ...[
                    // Mensaje si no hay historias
                    Expanded(
                      child: Center(
                        child: Text(
                          translationProvider.tr('history_screen.no_stories'),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],

                // Controles inferiores para tablet
                if (!isLoading &&
                    errorMessage == null &&
                    !finalStory &&
                    stories.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Colors.grey[200]!)),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: isPage == 0
                              ? null
                              : () {
                                  _controllerPage.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                },
                          icon: Icon(Icons.arrow_back_ios, size: 24),
                          color: StyleColor.turquoise,
                        ),
                        Expanded(
                          child: Slider(
                            value: isPage,
                            min: 0,
                            max: (stories.length - 1).toDouble(),
                            divisions:
                                stories.length > 1 ? stories.length - 1 : 1,
                            onChanged: (value) {
                              _controllerPage.animateToPage(
                                value.toInt(),
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            activeColor: StyleColor.turquoise,
                            inactiveColor: Colors.grey[300],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (isPage < stories.length - 1) {
                              _controllerPage.nextPage(
                                duration: Duration(milliseconds: 350),
                                curve: Curves.easeIn,
                              );
                            } else {
                              // Si está en la última página, activar finalStory
                              setState(() {
                                finalStory = true;
                              });
                            }
                          },
                          icon: Icon(Icons.arrow_forward_ios, size: 24),
                          color: StyleColor.turquoise,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Contenido de historia para tablet
  Widget _buildTabletStoryContent(
      History story,
      ScrollController scrollController,
      AppTranslationProvider translationProvider) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: StyleColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Imagen de la historia
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                GraphQLConfig.urlServidor + story.img.urlImg,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Controles multimedia
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedButtonIndex = 1;
                    });
                  },
                  icon: Icon(Icons.image, size: 28),
                  color: _selectedButtonIndex == 1
                      ? StyleColor.turquoise
                      : Colors.grey[600],
                ),
                SizedBox(width: 8),

                if (story.audio != null && story.audio!.url != '')
                  IconButton(
                    onPressed: () {
                      _showAudioDialog(story, translationProvider);
                    },
                    icon: Icon(Icons.audiotrack, size: 28),
                    color: _selectedButtonIndex == 2
                        ? StyleColor.turquoise
                        : Colors.grey[600],
                  ),
                if (story.audio != null && story.audio!.url != '')
                  SizedBox(width: 8),

                if (story.video != null && story.video!.url != '')
                  IconButton(
                    onPressed: () {
                      _showVideoDialog(story);
                    },
                    icon: Icon(Icons.videocam, size: 28),
                    color: _selectedButtonIndex == 3
                        ? StyleColor.turquoise
                        : Colors.grey[600],
                  ),

                Spacer(),

                // Control de tamaño de fuente
                Row(
                  children: [
                    Icon(Icons.text_decrease,
                        size: 20, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 150,
                      child: Slider(
                        value: fontSizeText,
                        min: 12,
                        max: 24,
                        onChanged: (value) async {
                          await PreferencesManager().setFontSizeVerse(value);
                          setState(() => fontSizeText = value);
                        },
                        activeColor: StyleColor.turquoise,
                        inactiveColor: Colors.grey[300],
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.text_increase,
                        size: 20, color: Colors.grey[600]),
                    IconButton(
                      onPressed: () {
                        _copyStory(stories[storyIndex], translationProvider);
                      },
                      icon: Icon(
                        Icons.copy,
                        color: StyleColor.turquoise,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Texto de la historia
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                thickness: 6,
                radius: Radius.circular(3),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: _buildRichTextWithLinks(
                      story.text, context, translationProvider),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAudioDialog(
      History story, AppTranslationProvider translationProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      translationProvider.tr('history_screen.audio_story'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                AudioPlayerWidget(
                  showImage: false,
                  inactiveColor: StyleColor.orange,
                  backgroundColor: Colors.white,
                  controlsColor: StyleColor.turquoise,
                  pathUrl: story.audio?.url ?? "",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showVideoDialog(History story) async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(20),
            child: Stack(
              children: [
                Container(
                  width: 600,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: story.video != null &&
                            (story.video!.url.contains('youtube.com') ||
                                story.video!.url.contains('youtu.be'))
                        ? PlayerYoutubeWidget(videoUrl: story.video!.url)
                        : PlayerNoYoutube(url: story.video?.url ?? ""),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 24),
                    onPressed: () {
                      Navigator.pop(context);
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown,
                        DeviceOrientation.landscapeLeft,
                        DeviceOrientation.landscapeRight,
                      ]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  // Layout para móvil (mismo que el original)
  Widget _buildMobileLayout(AppTranslationProvider translationProvider) {
    return Column(
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
            HeaderNotDetailsStageWidget(
              title:
                  "${translationProvider.tr('history_screen.title')} ${course?.titleCourse}",
              stage: stage != null ? stage!.sectionNumber.toString() : '',
              subtitle: stage != null ? stage!.sectionName : '',
              details: stage,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              padding: EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: StyleColor.orange,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Text(
                " ${level != null ? level!.name : ''} - ${translationProvider.tr('history_screen.level_name')} ${(isPage + 1).floorToDouble().toStringAsFixed(0)}",
                style: StylesApp(context).textStyleBody5,
              ),
            ),
            Expanded(
              child: finalStory
                  ? SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 221, 193, 148),
                                borderRadius: BorderRadius.circular(200)),
                            child: Stack(children: [
                              Center(
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(200)),
                                ),
                              ),
                              Center(
                                child: Image.asset(
                                  "assets/comingSoon.gif", // GIF animado
                                  height: 200,
                                  width: 200,
                                ),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                textAlign: TextAlign.center,
                                "${translationProvider.tr('history_screen.congratulations')} ${translationProvider.tr('history_screen.completed_story')}",
                                style: StylesApp(context)
                                    .textStyleBody18
                                    .copyWith(color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                ButtonThemeWidget(
                                  textCenter: true,
                                  text: translationProvider
                                      .tr('history_screen.restart_story'),
                                  buttonStyle:
                                      StylesApp(context).btnWidgetSmall,
                                  height: null,
                                  width: 170,
                                  onPressed: () async {
                                    setState(() {
                                      finalStory = false;
                                      isPage = 0;
                                      storyIndex = 0;
                                      isPlaying = false;
                                    });
                                    await flutterTts.stop();
                                  },
                                ),
                                ButtonThemeWidget(
                                  textCenter: true,
                                  text: translationProvider.tr(
                                      'history_screen.continue_questions'),
                                  buttonStyle:
                                      StylesApp(context).btnWidgetSmall,
                                  height: null,
                                  width: 170,
                                  onPressed: () {
                                    Navigator.popAndPushNamed(
                                      context,
                                      "/questionPage",
                                      arguments: {
                                        'courseId': courseId,
                                        "levelId": levelId,
                                        "sectionId": sectionId
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : PageView.builder(
                      controller: _controllerPage,
                      onPageChanged: (index) async {
                        if (index > stories.length - 1) {
                          setState(() {
                            finalStory = true;
                          });
                        } else {
                          setState(() {
                            isPage = index.toDouble();
                          });
                        }
                        setState(() {
                          isPlaying = true;
                        });
                        await flutterTts.stop();
                        _togglePlayPause(stories[index]);
                      },
                      itemCount: stories.length + 1,
                      itemBuilder: (context, index) {
                        if (index < stories.length) {
                          final story = stories[index];
                          // Crear un nuevo ScrollController *dentro* del itemBuilder
                          final ScrollController pageScrollController =
                              ScrollController();
                          return _buildItemPageView(story, context,
                              pageScrollController, translationProvider);
                        }
                        return Container();
                      },
                    ),
            ),
            SizedBox(
              height: 18.0,
            ),
            if (!finalStory) ...{
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
                        min: 10.0,
                        max: 20.0,
                        value: fontSizeText,
                        onChanged: (value) async {
                          await PreferencesManager().setFontSizeVerse(value);
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
                    ),
                    IconButton(
                      onPressed: () {
                        _copyStory(stories[storyIndex], translationProvider);
                      },
                      icon: Icon(
                        Icons.copy,
                        color: StyleColor.turquoise,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                constraints: BoxConstraints(minHeight: 35),
                decoration: BoxDecoration(
                    color: Color(0XFF858585),
                    borderRadius: BorderRadius.circular(8.0)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 0,
                      child: SizedBox(
                        width: 35,
                        height: 35.0,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          iconSize: 35.0,
                          onPressed: () {
                            _controllerPage.animateToPage(
                              0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                            setState(() {
                              isPage = 0;
                            });
                          },
                          icon: Icon(
                            Icons.skip_previous_outlined,
                            color: Colors.white,
                            size: 35.0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 0,
                            child: SizedBox(
                              width: 45,
                              height: 45.0,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                iconSize: 45.0,
                                onPressed: isPage == 0
                                    ? null
                                    : () async {
                                        _controllerPage.previousPage(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn,
                                        );
                                        setState(() {
                                          isPage = _controllerPage.page!;
                                          storyIndex -= 1;
                                          isPlaying = false;
                                        });
                                        await flutterTts.stop();
                                        _togglePlayPause(stories[storyIndex]);
                                      },
                                icon: Icon(
                                  Icons.arrow_left_sharp,
                                  color: Colors.white,
                                  size: 45.0,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(6.0),
                              minHeight: 14.0,
                              value: _calculateProgressValue(),
                              backgroundColor: Color(0xFFC4C4C4),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0XFFF27728),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 0,
                            child: SizedBox(
                              width: 45.0,
                              height: 45.0,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                iconSize: 45.0,
                                onPressed: () async {
                                  _controllerPage.nextPage(
                                    duration: Duration(milliseconds: 350),
                                    curve: Curves.easeIn,
                                  );

                                  if (isPage < stories.length - 1) {
                                    setState(() {
                                      isPage = _controllerPage.page! + 1;
                                      storyIndex += 1;
                                      isPlaying = false;
                                    });
                                    await flutterTts.stop();
                                    _togglePlayPause(stories[storyIndex]);
                                  } else {
                                    await flutterTts.stop();

                                    setState(
                                      () {
                                        finalStory = true;
                                      },
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.arrow_right_sharp,
                                  color: Colors.white,
                                  size: 45.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: SizedBox(
                        width: 30,
                        height: 30.0,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          iconSize: 25.0,
                          onPressed: () async {
                            setState(
                              () {
                                isPlaying = false;
                                finalStory = true;
                              },
                            );
                            await flutterTts.stop();
                          },
                          icon: Icon(
                            Icons.skip_next_outlined,
                            color: Colors.white,
                            size: 25.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            },
            SizedBox(
              height: 10.0,
            )
          }
        }
      ],
    );
  }

  Widget _buildItemPageView(
      History story,
      BuildContext context,
      ScrollController scrollController,
      AppTranslationProvider translationProvider) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 226.0, maxHeight: 226.0),
            child: Stack(
              // Usamos un Stack para superponer los botones a la imagen
              children: [
                Image.network(
                  GraphQLConfig.urlServidor + story.img.urlImg,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/placeholder.png',
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ); // Imagen de marcador de posición
                  }, // Ajusta la imagen al contenedor
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    offset: Offset(0.0, 4.0),
                    blurStyle: BlurStyle.outer),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedButtonIndex = 1;
                    });
                  },
                  icon: Icon(Icons.image),
                  color: _selectedButtonIndex == 1
                      ? StyleColor.turquoise
                      : StyleColor.twilightBlue,
                ),
                if (story.audio != null && story.audio!.url != '')
                  IconButton(
                    onPressed: () {
                      // Lógica para reproducir audio
                      setState(() {
                        _selectedButtonIndex = 2;
                      });
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          constraints:
                                              BoxConstraints(minHeight: 213),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.transparent),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 50,
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            child: AudioPlayerWidget(
                                              showImage: false,
                                              inactiveColor: StyleColor.orange,
                                              backgroundColor: Colors.white,
                                              controlsColor:
                                                  StyleColor.turquoise,
                                              pathUrl: story.audio == null
                                                  ? ""
                                                  : story.audio!.url,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pop(); // Cierra el diálogo
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withValues(
                                                  alpha:
                                                      0.7), // Fondo semitransparente para el botón
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    icon: Icon(Icons.audiotrack),
                    color: _selectedButtonIndex == 2
                        ? StyleColor.turquoise
                        : StyleColor.twilightBlue,
                  ),
                if (story.video != null && story.video!.url != '')
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        _selectedButtonIndex = 3;
                      });
                      await SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown,
                      ]);
                      if (mounted) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: Stack(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      constraints:
                                          BoxConstraints(minHeight: 213),
                                      // height: 213,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: story.video != null &&
                                                (story.video!.url.contains(
                                                        'youtube.com') ||
                                                    story.video!.url
                                                        .contains('youtu.be'))
                                            ? PlayerYoutubeWidget(
                                                videoUrl: story.video!.url)
                                            : PlayerNoYoutube(
                                                url: story.video!.url),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    // Posiciona el botón de cerrar
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pop(); // Cierra el diálogo
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withValues(
                                              alpha:
                                                  0.7), // Fondo semitransparente para el botón
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              );
                            });
                      }
                    },
                    icon: Icon(Icons.videocam),
                    color: _selectedButtonIndex == 3
                        ? StyleColor.turquoise
                        : StyleColor.twilightBlue,
                  ),
                // lector de la historia
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: StyleColor.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Slider para control de velocidad
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  // Botón de stop
                                  IconButton(
                                    icon: Icon(Icons.stop, size: 24),
                                    color: StyleColor.turquoise,
                                    onPressed: () async {
                                      await flutterTts.stop();
                                      setState(() {
                                        isPlaying = false;
                                      });
                                    },
                                  ),
                                  // Botón de play/pause
                                  IconButton(
                                      icon: Icon(
                                        isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: 28,
                                      ),
                                      color: StyleColor.turquoise,
                                      onPressed: () {
                                        setState(() => isPlaying = !isPlaying);
                                        _togglePlayPause(story);
                                      }),
                                  Icon(Icons.speed,
                                      size: 18, color: StyleColor.black),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Slider(
                                      value: _speechRate,
                                      min: 0.1,
                                      max: 1.0,
                                      divisions: 9,
                                      label: _getSpeedLabel(
                                          _speechRate, translationProvider),
                                      activeColor: StyleColor.turquoise,
                                      inactiveColor: StyleColor.turquoise
                                          .withValues(alpha: 0.3),
                                      onChanged: (value) async {
                                        setState(() => _speechRate = value);
                                        await flutterTts.setSpeechRate(value);
                                        await PreferencesManager()
                                            .setTtsSpeechRate(value);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _getSpeedLabel(
                                        _speechRate, translationProvider),
                                    style: TextStyle(
                                      color: StyleColor.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${translationProvider.tr('history_screen.speed')}: ${(_speechRate * 100).round()}%',
                                style: TextStyle(
                                  color: StyleColor.black,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 7.0,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo
                borderRadius: BorderRadius.circular(10), // Bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Sombra
                  ),
                ],
              ),
              height: 248.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 14.0, vertical: 15.0),
                  constraints: BoxConstraints(
                    minHeight: 73.0,
                    maxHeight: 230.0,
                  ),
                  width: MediaQuery.sizeOf(context).width,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    thickness: 6.0,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 21.0,
                          ),
                          _buildRichTextWithLinks(
                              story.text, context, translationProvider),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initTTS() async {
    flutterTts = FlutterTts();

    await flutterTts.setLanguage("es-ES"); // Configurar idioma
    await flutterTts.setSharedInstance(true);

    // 2. Establecer idioma hebreo
    // await flutterTts.setVoice({"name": "es-es-x-ana-local", "locale": "es-ES"});
    await flutterTts.setSpeechRate(0.5); // Velocidad de habla (0-1)
    await flutterTts.setVolume(1.0); // Volumen (0-1)
    await flutterTts.setPitch(1.0); // Tono (0.5-2.0)

    // Configurar handlers para eventos
    flutterTts.setStartHandler(() {
      setState(() => isPlaying = true);
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
        // currentPlayingVerseIndex = null;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isPlaying = false;
      });
      showSnackBar("Error en TTS: $msg", type: SnackBarType.error);
    });
  }
// Agrega estas funciones en tu clase _HistoryScreenState

  String _detectLanguage(String text) {
    // 1. Primero verificar hebreo (más específico)
    final hebrewRegex = RegExp(r'[\u0590-\u05FF\uFB1D-\uFB4F]');
    final hebrewCount = hebrewRegex.allMatches(text).length;

    if (hebrewCount > 0) {
      print("✅ Detectado HEBREO por caracteres hebreos: $hebrewCount");
      return "hebrew";
    }

    // 2. Palabras clave ESPECÍFICAS en español (prioridad alta)
    final spanishKeywords = AppConstants.spanishKeywords;

    // 3. Palabras clave en inglés
    final englishKeywords = AppConstants.englishKeywords;

    // 4. Contar ocurrencias
    int spanishScore = 0;
    int englishScore = 0;

    final textLower = text.toLowerCase();

    for (final keyword in spanishKeywords) {
      // Buscar palabra completa (con límites de palabra)
      final pattern = RegExp(r'\b' + RegExp.escape(keyword) + r'\b');
      spanishScore += pattern.allMatches(textLower).length;
    }

    for (final keyword in englishKeywords) {
      final pattern = RegExp(r'\b' + RegExp.escape(keyword) + r'\b');
      englishScore += pattern.allMatches(textLower).length;
    }

    // 5. Verificar tildes españolas (caracteres especiales)
    final spanishTildesRegex = RegExp(r'[áéíóúÁÉÍÓÚñÑ]');
    final spanishTildesCount = spanishTildesRegex.allMatches(text).length;
    spanishScore += spanishTildesCount * 3; // Peso extra por tildes

    if (kDebugMode) {
      print("""
  🔍 Análisis de idioma:
  - Puntos español: $spanishScore (keywords: ${spanishScore - spanishTildesCount}, tildes: $spanishTildesCount)
  - Puntos inglés: $englishScore
  """);
    }

    // 6. Decidir idioma (umbral mínimo)
    if (spanishScore > englishScore && spanishScore >= 2) {
      if (kDebugMode) {
        print("✅ Idioma detectado: ESPAÑOL");
      }
      return "spanish";
    } else if (englishScore > spanishScore && englishScore >= 2) {
      if (kDebugMode) {
        print("✅ Idioma detectado: INGLÉS");
      }
      return "english";
    }

    // 7. Si está muy parejo o no hay keywords, usar REGLAS POR DEFECTO
    final totalLetters =
        text.replaceAll(RegExp(r'[^a-zA-ZáéíóúÁÉÍÓÚñÑ]'), '').length;
    if (totalLetters > 0) {
      // Porcentaje de tildes
      final tildesPercentage = spanishTildesCount / totalLetters;

      if (tildesPercentage > 0.02) {
        // 2% de tildes → español
        if (kDebugMode) {
          print("✅ Español detectado por tildes ($tildesPercentage%)");
        }
        return "spanish";
      }
    }

    // 8. DEFAULT: Español para textos bíblicos (tu caso)
    print("⚠️ Idioma no claro, usando ESPAÑOL por defecto");
    return "spanish";
  }

  /// Configurar FlutterTTS según idioma detectado
  Future<void> _configureTTSForLanguage(String language) async {
    try {
      switch (language.toLowerCase()) {
        case "hebrew":
        case "he":
        case "iw":
          // Intentar diferentes códigos de hebreo
          final hebrewCodes = ["he-IL", "he", "iw-IL", "iw"];
          bool configured = false;

          for (final code in hebrewCodes) {
            if (await flutterTts.isLanguageAvailable(code)) {
              await flutterTts.setLanguage(code);
              await flutterTts.setSpeechRate(0.3); // Más lento para hebreo
              if (kDebugMode) {
                print("✅ TTS configurado para HEBREO con código: $code");
              }
              configured = true;
              break;
            }
          }

          if (!configured) {
            if (kDebugMode) {
              print("⚠️ Voz hebrea no disponible, usando español");
            }
            await flutterTts.setLanguage("es-ES");
          }
          break;

        case "spanish":
        case "es":
          await flutterTts.setLanguage("es-ES");
          await flutterTts.setSpeechRate(_speechRate);
          if (kDebugMode) {
            print("✅ TTS configurado para ESPAÑOL");
          }
          break;

        case "english":
        case "en":
          await flutterTts.setLanguage("en-US");
          await flutterTts.setSpeechRate(_speechRate);
          if (kDebugMode) {
            print("✅ TTS configurado para INGLÉS");
          }
          break;

        default:
          await flutterTts.setLanguage("es-ES");
          if (kDebugMode) {
            print("✅ TTS configurado para ESPAÑOL (por defecto)");
          }
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error configurando TTS: $e");
      }
      await flutterTts.setLanguage("es-ES"); // Fallback
    }
  }

  String _getSpeedLabel(
      double speed, AppTranslationProvider translationProvider) {
    if (speed <= 0.4) return translationProvider.tr('history_screen.slow');
    if (speed <= 0.6) return translationProvider.tr('history_screen.normal');
    return translationProvider.tr('history_screen.fast');
  }

  Future<void> _togglePlayPause(story) async {
    if (!isPlaying) {
      // setState(() => isPlaying = false);
      await flutterTts.pause();
    } else {
      await flutterTts.awaitSpeakCompletion(true);
      // Eliminar los textos que están dentro de {( ... )} incluyendo desde / hasta )}
      // Ejemplo: {(Juan 1:4-5 /RVR95)} -> elimina " /RVR95" y deja "Juan 1:4-5"
      String cleanText = story.text.replaceAllMapped(
        RegExp(r'\{\(([^\/\)]+)(?:\/[^\)]*)?\)\}'),
        (Match match) => (match.group(1) ?? '').trim(),
      );
      // 2. DETECTAR IDIOMA automáticamente
      final detectedLanguage = _detectLanguage(cleanText);

      // 3. CONFIGURAR TTS para ese idioma
      await _configureTTSForLanguage(detectedLanguage);

      // 4. Eliminar todos los emojis del texto
      String textWithoutEmojis = cleanText.replaceAll(
        RegExp(
          r'[\u{1F600}-\u{1F64F}' // Emoticons
          r'\u{1F300}-\u{1F5FF}' // Símbolos y pictogramas
          r'\u{1F680}-\u{1F6FF}' // Transporte y símbolos
          r'\u{1F1E0}-\u{1F1FF}' // Banderas (iOS)
          r'\u{1F018}-\u{1F270}' // Varios símbolos
          r'[\u{1F000}-\u{1F9FF}' // Emojis principales y suplementarios
          r'\u{2600}-\u{26FF}' // Símbolos misceláneos
          r'\u{2700}-\u{27BF}' // Dingbats
          r'\u{2300}-\u{23FF}' // Símbolos técnicos (incluye ⭐)
          r'\u{2B50}-\u{2BFF}' // Símbolos y flechas (incluye ⭐)
          r'\u{FE00}-\u{FE0F}' // Variantes de emojis
          r'\u{1F900}-\u{1F9FF}' // Emojis suplementarios
          r'\u{1FA70}-\u{1FAFF}' // Símbolos extendidos
          r']',
          unicode: true,
        ),
        '', // Reemplazar con string vacío
      );
      // // 2. Formatear referencias (ej: "Juan 8:4-36" → "Juan capítulo 8 versículo 4 al 36")
      String ttsText = textWithoutEmojis.replaceAllMapped(
        RegExp(r'(\w+) (\d+):(\d+)(?:-(\d+))?'),
        (Match match) {
          final book = match.group(1); // "Juan"
          final chapter = match.group(2); // "8"
          final verseStart = match.group(3); // "4"
          final verseEnd = match.group(4); // "36" (opcional)

          if (verseEnd != null) {
            return '$book capítulo $chapter versículo $verseStart al $verseEnd';
          } else {
            return '$book capítulo $chapter versículo $verseStart';
          }
        },
      );

      await flutterTts.speak(ttsText);
      // setState(() => isPlaying = true);
    }
  }

  _buildRichTextWithLinks(String text, BuildContext context,
      AppTranslationProvider translationProvider) {
    // Busca las partes de la cadena que coincidan con {( )} y las resalta.
    final curlyRegExp = RegExp(r'\{\((.*?)\)\}'); // Coincide con {( ... )}

    final matches = curlyRegExp.allMatches(text).toList();

    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      // Texto antes del match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: TextStyle(
            color: Colors.black,
            fontSize: fontSizeText,
          ),
        ));
      }
      // Texto del match (enlace)
      final matchedText = match.group(0)!;
      final textRead = matchedText.replaceFirstMapped(
        RegExp(
            r'^\{\(\s*([^\/\)]+)\s*(?:\/[^\)]*)?\)\}'), // Captura solo la referencia
        (match) =>
            match.group(1)?.trim() ??
            matchedText, // Extrae el grupo 1 (la referencia)
      );

      spans.add(
        TextSpan(
          text: textRead,
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
            fontSize: fontSizeText,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              LoadingService().showLoading(context);
              try {
                final ResponseData responseDetailLink =
                    await getReferencesBibleByName(matchedText, null);
                if (responseDetailLink.error != null) {
                  LoadingService().hideLoading();
                  if (mounted) {
                    await showCustomDialog(context,
                        showDetails: true,
                        messageDetail: responseDetailLink.error!,
                        message: responseDetailLink.userFriendlyError!,
                        dialogType: DialogType.error);
                  }
                  return;
                }
                setState(() {
                  // mapeamos datos
                  final ResponseReferenceBiblicalModel reference =
                      ResponseReferenceBiblicalModel.fromJson(
                          responseDetailLink.data);
                  _buildModalShowDetailLink(
                      matchedText, reference, translationProvider);
                });
                LoadingService().hideLoading();
              } catch (e) {
                LoadingService().hideLoading();
                await showCustomDialog(context,
                    message: e.toString(), dialogType: DialogType.error);
              } finally {
                LoadingService().hideLoading();
              }
            },
        ),
      );
      lastMatchEnd = match.end;
    }
    // Texto restante después del último match
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSizeText,
        ),
      ));
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: StylesApp(context).textStyleBody5.copyWith(
              color: Colors.black,
              fontSize: fontSizeText,
            ),
      ),
    );
  }

  void _buildModalShowDetailLink(
      String matchedText,
      ResponseReferenceBiblicalModel reference,
      AppTranslationProvider translationProvider) {
    // Mover las variables al nivel superior del widget Stateful
    final versions = Provider.of<CatalogueProvider>(context, listen: false)
        .allBibleVersion
        .map<ModelData>((version) => ModelData<VersionModel>(
            label: version.version, value: version.id, originalData: version))
        .toList();

    // Inicializar con la versión de la referencia
    ModelData? versionSelected = versions.firstWhere(
      (v) => v.originalData.version == reference.bibleName,
      orElse: () => ModelData(label: "", value: ""),
    );

    ResponseReferenceBiblicalModel? localReference = reference;
    showModalBottomSheet(
      backgroundColor: StyleColor.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * .85,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    "${translationProvider.tr('history_screen.bible_version')}\n ${localReference!.bibleName}",
                    style: StylesApp(context)
                        .textStyleBody18
                        .copyWith(color: StyleColor.black),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      constraints: BoxConstraints(
                        minWidth: 160.0,
                        maxWidth: StylesApp(context).sizeTextFormField.width,
                      ),
                      child: CustomDropdownBottomWidget(
                        hintText: translationProvider
                            .tr('history_screen.select_version'),
                        items: versions,
                        onChanged: (ModelData? newVersion) async {
                          if (newVersion == null) return;

                          setModalState(() {
                            versionSelected = newVersion;
                          });

                          LoadingService().showLoading(context);
                          try {
                            final ResponseData responseDetailLink =
                                await getReferencesBibleByName(
                                    matchedText, newVersion.originalData.code);

                            if (responseDetailLink.error != null) {
                              LoadingService().hideLoading();
                              await showCustomDialog(context,
                                  message: responseDetailLink.error!,
                                  dialogType: DialogType.error);
                              return;
                            }

                            setModalState(() {
                              localReference =
                                  ResponseReferenceBiblicalModel.fromJson(
                                      responseDetailLink.data);
                            });
                          } catch (e) {
                            await showCustomDialog(context,
                                message: e.toString(),
                                dialogType: DialogType.error);
                          } finally {
                            LoadingService().hideLoading();
                          }
                        },
                        selectedItem: versionSelected,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: localReference?.verses.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: 6.0, left: 4.0, right: 4.0, bottom: 6.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: StyleColor.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: StyleColor.black.withValues(alpha: .25),
                                spreadRadius: 2.0,
                                offset: Offset(0, 2.0),
                              )
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -15,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 20.0,
                                      onPressed: () {
                                        copyToClipboard(
                                          context,
                                          CopyModelVerse(
                                            book: Book(
                                              modernName:
                                                  localReference?.bookName,
                                            ),
                                            chapter: ChapterModel(
                                              chapter: int.parse(localReference!
                                                  .chapterNumber),
                                            ),
                                            verse: VerseModel(
                                              verse: localReference!
                                                  .verses[index].verse!,
                                              text: localReference!
                                                  .verses[index].text!,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.file_copy_rounded,
                                        color: StyleColor.turquoise,
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 20.0,
                                      onPressed: () => shareVerse(
                                        context,
                                        CopyModelVerse(
                                          book: Book(
                                            modernName:
                                                localReference?.bookName,
                                          ),
                                          chapter: ChapterModel(
                                            chapter: int.parse(
                                                localReference!.chapterNumber),
                                          ),
                                          verse: VerseModel(
                                            verse: localReference!
                                                .verses[index].verse!,
                                            text: localReference!
                                                .verses[index].text!,
                                          ),
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.share_rounded,
                                        color: StyleColor.turquoise,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 22,
                                  ),
                                  Center(
                                    child: Text.rich(TextSpan(children: [
                                      TextSpan(
                                        text: localReference?.bookName,
                                        style: StylesApp(context)
                                            .textStyleBody16
                                            .copyWith(
                                                color: StyleColor.turquoise),
                                      ),
                                      TextSpan(
                                        text:
                                            "  ${localReference?.chapterNumber}:${localReference?.verses[index].verse}",
                                        style: StylesApp(context)
                                            .textStyleBody14
                                            .copyWith(color: StyleColor.black),
                                      )
                                    ])),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      '"${localReference?.verses[index].text}"',
                                      style: StylesApp(context)
                                          .textStyleBody12
                                          .copyWith(color: StyleColor.black),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: StyleColor.turquoise,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(double.infinity, 44),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      translationProvider.tr('history_screen.close'),
                      style: StylesApp(context).textStyleBody5.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  double _calculateProgressValue() {
    // Validar que haya historias
    if (stories.isEmpty) return 0.0;

    // Validar que isPage sea un número válido
    if (isPage.isNaN || isPage.isInfinite) return 0.0;

    // Calcular progreso seguro
    final int totalItems = stories.length;
    final int maxPage = totalItems > 1 ? totalItems - 1 : totalItems;

    // Evitar división por cero
    if (maxPage <= 0) return 0.0;

    // Limitar el valor entre 0 y 1
    double progress = isPage / maxPage;
    return progress.clamp(0.0, 1.0);
  }

  initConfetti() {
    _confettiController.play();
  }

  void _copyStory(History story, AppTranslationProvider translationProvider) {
    Clipboard.setData(ClipboardData(text: story.text));
    showSnackBar(translationProvider.tr('history_screen.story_copied'),
        type: SnackBarType.success);
  }
}
