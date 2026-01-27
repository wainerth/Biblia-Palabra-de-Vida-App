import 'package:provider/provider.dart';
import 'dart:async';
// import 'package:flutter/material.dart';
import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
// import 'package:audioplayers/audioplayers.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  // Variables existentes...
  late final UserProvider userProvider;
  CourseDetail? course;
  Stage? stage;
  List<Level> levels = [];
  List<List<Level>> gruposDeNiveles = [];
  late ScrollController scrollController;
  final _isVisible = ValueNotifier<bool>(true);
  Timer? _timer;
  int _selectedIndex = 2;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> imagePaths = [
    'assets/mapa1.png',
    'assets/mapa2.png',
    'assets/mapa3.png',
  ];
  final List<String> imagePathsTablet = [
    'assets/mapa1Tablet.png',
    'assets/map2Tablet.png'
  ];

  bool isLoading = true;
  String? errorMessage;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isMuted = false;
  bool _audioPlayerDisposed = false;

  // Determinar si es tablet
  bool get isTablet {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.shortestSide >= 600;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      scrollController = ScrollController();
      _generateData(context);
      await _loadMutePreference();
      if (!isMuted) {
        await playAudio();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    stopAudio();
    _audioPlayerDisposed = true;
    audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Métodos de audio existentes...
  Future<void> playAudio() async {
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.setVolume(0.5);
    await audioPlayer.play(AssetSource('mar-aves.mp3'));
  }

  Future<void> stopAudio() async {
    if (!_audioPlayerDisposed) {
      await audioPlayer.stop();
    }
  }

  Future<void> muteAudio() async {
    setState(() {
      isMuted = !isMuted;
    });
    _saveMutePreference();

    if (isMuted) {
      await audioPlayer.setVolume(0.0);
    } else {
      await audioPlayer.setVolume(1.0);
    }
  }

  _loadMutePreference() async {
    final mute = await PreferencesManager().getIsMuted();
    setState(() => isMuted = mute);
  }

  _saveMutePreference() async {
    await PreferencesManager().setMuted(isMuted);
  }

  // Métodos existentes...
  onScrollPosition() {
    final int unlockedIndex = levels
        .indexWhere((level) => level.unLockLevel && level.levelScore == 0);
    if (unlockedIndex != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          unlockedIndex * StylesApp(context).sizeContainerLevel.height,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  Future<void> _generateData(BuildContext context) async {
    LoadingService().showLoading(context);
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      try {
        final String courseId = args['courseId'];
        final String sectionId = args['sectionId'];

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

        // obtenemos los niveles
        final result = await loadLevelsByCourse(userData.userId, sectionId);
        if (result.error != null) {
          errorMessage = result.error;
          return;
        } else {
          setState(() {
            levels = result.data
                .map((level) => Level.fromJson(removeTypename(level)))
                .cast<Level>()
                .toList();

            if (stage != null && stage!.numberOfLevels != null) {
              final int levelsOfNumbers = stage!.numberOfLevels!;
              for (int i = 1; i <= levelsOfNumbers; i++) {
                if (!levels.any((level) => level.levelNumber == i)) {
                  levels.add(Level(
                    id: 'pending_$i',
                    name: 'Próximamente',
                    isUnderConstruction: true,
                    unLockLevel: false,
                    color: 'A9B8BE',
                    section: Section(sectionName: ''),
                    img: Img(urlImg: ''),
                    score: 0,
                    levelScore: 0,
                    levelNumber: i,
                  ));
                }
              }
            }

            levels.sort((a, b) => a.levelNumber.compareTo(b.levelNumber));
            gruposDeNiveles = chunked(levels, 5);
          });
        }
      } catch (e) {
        errorMessage = "An error occurred: $e";
        return;
      } finally {
        final int unlockedIndex = levels
            .indexWhere((level) => level.unLockLevel && level.levelScore == 0);
        if (unlockedIndex != -1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollController.animateTo(
              unlockedIndex * StylesApp(context).sizeContainerLevel.height,
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
            );
          });
        }
        LoadingService().hideLoading();
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    if (index.toString() == _selectedIndex.toString()) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/layoutPage', (route) => false);

    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex.toString() == 0.toString()) {
      Navigator.pushNamed(context, '/layoutPage');
    } else if (index.toString() == 3.toString()) {
      Navigator.pushNamed(
        context,
        '/layoutPage1',
        arguments: {'selectedIndex': 2},
      );
    } else if (_selectedIndex.toString() == 4.toString()) {
      Navigator.pushNamed(
        context,
        '/layoutPage1',
        arguments: {'selectedIndex': 3},
      );
    } else if (_selectedIndex.toString() == 5.toString()) {
      Navigator.pushNamed(
        context,
        '/layoutPage1',
        arguments: {'selectedIndex': 4},
      );
    } else {
      Navigator.pushNamed(
        context,
        '/layoutPage1',
        arguments: {'selectedIndex': index},
      );
    }
  }

  List<List<T>> chunked<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {},
      child: Scaffold(
        body: isTablet ? _buildTabletLayout() : _buildMobileLayout(),
        bottomNavigationBar: isTablet ? null : _buildBottomNavigationBar(),
      ),
    );
  }

  // ========== DISEÑO PARA TABLET ==========
  Widget _buildTabletLayout() {
    return SafeArea(
      child: Column(
        children: [
          // Header para tablet
          HeadScoreWidget(
            onRoute: () {
              Navigator.popAndPushNamed(context, '/profilePage');
            },
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Columna izquierda - Información y controles (30%)
                  Expanded(
                    flex: 3,
                    child: _buildTabletInfoColumn(),
                  ),

                  SizedBox(width: 24.0),

                  // Columna derecha - Mapa (70%)
                  Expanded(
                    flex: 7,
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : errorMessage != null
                            ? BuildErrorWidget(
                                errorMessage: errorMessage!,
                                onRetry: () async => _generateData(context),
                                onBack: () => Navigator.pop(context),
                              )
                            : _buildTabletMapColumn(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Columna de información para tablet
  Widget _buildTabletInfoColumn() {
    return Container(
      decoration: BoxDecoration(
        color: StyleColor.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: StyleColor.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header del curso
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: StyleColor.turquoise,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        course?.titleCourse ?? 'Curso',
                        style: StylesApp(context).textStyleBody20.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: StyleColor.white,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline, color: StyleColor.white),
                      onPressed: course != null
                          ? () {
                              Navigator.popAndPushNamed(
                                  context, '/detailCoursePage',
                                  arguments: {"courseId": course!.id});
                            }
                          : null,
                    ),
                  ],
                ),
                SizedBox(height: 12),
                if (stage != null) ...[
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: StyleColor.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Etapa ${stage!.sectionNumber}',
                          style: StylesApp(context).textStyleBody14.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          stage!.sectionName,
                          style: StylesApp(context).textStyleBody16.copyWith(
                                fontSize: 16,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outline, color: StyleColor.white),
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(24),
                                  constraints: BoxConstraints(
                                    maxWidth: 500,
                                    // maxHeight: 400,
                                  ),
                                  child: CustomModalWidget(
                                    title: stage!.sectionName,
                                    content: stage!.introduction,
                                    buttonText: 'Aceptar',
                                    id: stage!.sectionNumber.toString(),
                                    itemCount: stage!.levelCount,
                                    itemsCompleted: stage!.levelCompletedCount,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Información del progreso
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Controles de audio
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: StyleColor.turquoise.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.volume_up, color: StyleColor.turquoise),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Efectos de sonido',
                              style:
                                  StylesApp(context).textStyleBody16.copyWith(
                                        fontSize: 16,
                                        color: StyleColor.black,
                                      ),
                            ),
                          ),
                          Switch.adaptive(
                            value: !isMuted,
                            onChanged: (value) async {
                              await muteAudio();
                              if (isMuted) {
                                stopAudio();
                              } else {
                                playAudio();
                              }
                            },
                            activeColor: StyleColor.turquoise,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Información del progreso
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progreso del Nivel',
                            style: StylesApp(context).textStyleBody18.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: StyleColor.black,
                                ),
                          ),
                          SizedBox(height: 12),
                          if (stage != null) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: _buildProgressInfo(
                                    icon: Icons.check_circle,
                                    label: 'Completados',
                                    value: '${getCompletedLevelsCount()}',
                                    color: StyleColor.turquoise,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildProgressInfo(
                                    icon: Icons.layers,
                                    label: 'Totales',
                                    value: '${getTotalLevelsCount()}',
                                    color: StyleColor.yellowLight,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Container(
                              height: 8,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: getProgressPercentage() / 100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: StyleColor.turquoise,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Botón de scroll automático
                    ElevatedButton.icon(
                      onPressed: onScrollPosition,
                      icon: Icon(Icons.explore),
                      label: Text(
                        'Encontrar nivel activo',
                        style: StylesApp(context).textStyleBody16.copyWith(
                              fontSize: 16,
                              color: StyleColor.white,
                            ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: StyleColor.turquoise,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Navegación rápida
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Navegación',
                            style: StylesApp(context).textStyleBody18.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: StyleColor.black,
                                ),
                          ),
                          SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildNavChip(
                                icon: Icons.book,
                                label: 'Detalles del curso',
                                onTap: course != null
                                    ? () {
                                        Navigator.popAndPushNamed(
                                            context, '/detailCoursePage',
                                            arguments: {
                                              "courseId": course!.id
                                            });
                                      }
                                    : null,
                              ),
                              _buildNavChip(
                                icon: Icons.arrow_back,
                                label: 'Volver a etapas',
                                onTap: () {
                                  Navigator.popAndPushNamed(
                                      context, '/layoutPage1');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Columna del mapa para tablet
  Widget _buildTabletMapColumn() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: StyleColor.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          children: [
            // Fondo del mapa
            Container(
              color: StyleColor.turquoise,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    _showBottomNavigationBar();
                  }
                  return true;
                },
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: gruposDeNiveles.length,
                  itemBuilder: (context, index) {
                    return _buildTabletMapSection(index);
                  },
                ),
              ),
            ),

            // Controles flotantes
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: onScrollPosition,
                backgroundColor: Colors.white,
                child: Icon(Icons.explore, color: Color(0XFF12CBC4)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sección del mapa para tablet
  Widget _buildTabletMapSection(int index) {
    List<Level> grupo = gruposDeNiveles[index];
    String image = index == 0
        ? imagePathsTablet[0]
        : index % 2 == 0
            ? imagePathsTablet[0]
            : imagePathsTablet[1];

    // Coordenadas ajustadas para tablet
    List<double> coordATop = [0.0, 0.20, 0.38, 0.65, 0.90];
    List<double> coordALeft = [0.30, 0.40, 0.50, 0.45, 0.40];

    List<double> coordBTop = [0.0, 0.25, 0.35, 0.55, 0.75];
    List<double> coordBLeft = [0.25, 0.15, 0.05, 0.08, 0.10];

    List<double> coordATopBarco = [
      0.30,
      0.40,
      0.50,
      0.53,
      0.70,
      0.80,
      0.80,
      0.90
    ];
    List<double> coordALeftBarco = [
      0.15,
      0.15,
      -0.00,
      0.35,
      0.15,
      0.25,
      0.10,
      0.25
    ];

    List<double> coordBTopBarco = [
      0.10,
      0.30,
      0.40,
      0.50,
      0.50,
      0.65,
      0.80,
      0.90
    ];
    List<double> coordBLeftBarco = [
      0.55,
      0.40,
      0.70,
      0.35,
      0.57,
      0.32,
      0.55,
      0.45
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 1.2,
      child: Stack(
        children: [
          // Imagen de fondo
          Image.asset(
            image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // Barcos animados
          if (index % 2 == 0) ...[
            for (var j = 0; j < 8; j++) ...{
              _buildTabletAnimatedBoat(
                coordTop: coordATopBarco[j],
                coordLeft: coordALeftBarco[j],
              ),
            },
          ] else ...[
            for (var j = 0; j < 8; j++) ...{
              _buildTabletAnimatedBoat(
                coordTop: coordBTopBarco[j],
                coordLeft: coordBLeftBarco[j],
              ),
            }
          ],

          // Niveles
          for (var i = 0; i < grupo.length; i++) ...{
            Positioned(
              top: MediaQuery.of(context).size.height *
                  (index % 2 == 0 ? coordATop[i] : coordBTop[i]),
              left: MediaQuery.of(context).size.width *
                  (index % 2 == 0 ? coordALeft[i] : coordBLeft[i]),
              child: _buildTabletLevelItem(grupo[i]),
            ),
          },
        ],
      ),
    );
  }

  // Item de nivel para tablet
  Widget _buildTabletLevelItem(Level level) {
    final double containerSize =
        isTablet ? 80.0 : StylesApp(context).sizeContainer.width;
    final double subContainerSize =
        isTablet ? 60.0 : StylesApp(context).sizeContainerSub.width;

    return GestureDetector(
      onTap: level.unLockLevel == false
          ? null
          : () async {
              stopAudio();
              if (level.isUnderConstruction == true) {
                await showCustomDialog(context,
                    message:
                        "Este Nivel Esta en Construcción,\n al Estar disponible Te llagara un Notificación",
                    dialogType: DialogType.info);
                return;
              } else {
                Navigator.pushNamed(
                  context,
                  '/historyPage',
                  arguments: {
                    'courseId': course?.id,
                    'levelId': level.id,
                    'sectionId': stage!.id
                  },
                );
              }
            },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: containerSize * 1.5,
        ),
        child: Stack(
          children: [
            // Estrellas de puntuación
            Center(
              child: StarStatusWidget(
                containerWidth: containerSize * 1.5,
                levelScore: level.levelScore,
              ),
            ),

            // Contenedor principal del nivel
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: containerSize,
                        height: containerSize,
                        decoration: BoxDecoration(
                            color: Color(level.levelScore > 0
                                ? getColorItem(level.levelScore)
                                : int.tryParse('0xFF${level.color}') ??
                                    0XFF000000),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: level.levelScore > 0
                                  ? Color(getColorItem(level.levelScore))
                                  : Color.fromARGB(
                                      100,
                                      int.parse(
                                          '0xFF${level.color}'.substring(2),
                                          radix: 16),
                                      int.parse(
                                          '0xFF${level.color}'.substring(4, 6),
                                          radix: 16),
                                      int.parse(
                                          '0xFF${level.color}'.substring(6),
                                          radix: 16),
                                    ),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: level.levelScore > 0
                                    ? Color(getColorShadow(level.levelScore))
                                        .withValues(alpha: 0.5)
                                    : Colors.black.withValues(alpha: 0.5),
                                offset: Offset(0, 8),
                                blurRadius: 8,
                              )
                            ]),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (level.unLockLevel == true &&
                                  level.levelScore == 0) ...{
                                AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return Container(
                                      width:
                                          containerSize + 15 * _animation.value,
                                      height:
                                          containerSize + 15 * _animation.value,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.yellow.withValues(
                                            alpha: 0.5 * (1 - _animation.value)),
                                      ),
                                    );
                                  },
                                ),
                              },
                              _buildItemLevel(context, level, subContainerSize),
                            ],
                          ),
                        ),
                      ),
                      if (level.unLockLevel == false)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFA9B8BE).withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${level.levelNumber}. ${level.name}",
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Barco animado para tablet
  Widget _buildTabletAnimatedBoat(
      {required double coordTop, required double coordLeft}) {
    return Positioned(
      top: MediaQuery.of(context).size.height * coordTop,
      left: MediaQuery.of(context).size.width * coordLeft,
      child: InfiniteAnimation(
        coordTop: coordTop,
        coordLeft: coordLeft,
        j: 0, // Este valor no se usa realmente en InfiniteAnimation
        index: 0,
        // size: isTablet ? 40.0 : 30.0,
      ),
    );
  }

  // ========== DISEÑO PARA MÓVIL (EXISTENTE) ==========
  Widget _buildMobileLayout() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          _showBottomNavigationBar();
        }
        return true;
      },
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: StyleColor.turquoise,
          ),
          height: MediaQuery.sizeOf(context).height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: errorMessage != null
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              spacing: 0,
              children: [
                HeadScoreWidget(
                  onRoute: () {
                    Navigator.popAndPushNamed(context, '/profilePage');
                  },
                ),
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
                    _buildMobileContent(),
                  }
                }
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Contenido móvil (existente)
  Widget _buildMobileContent() {
    return Column(
      children: [
        Stack(children: [
          HeaderMapWidget(
            title: course!.titleCourse,
            subtitleStage: stage!.sectionName,
            indexStage: stage!.sectionNumber,
            onRouteBack: () {
              Navigator.popAndPushNamed(context, '/layoutPage1');
            },
            onShowInfoCourse: () {
              Navigator.popAndPushNamed(context, '/detailCoursePage',
                  arguments: {"courseId": course!.id});
            },
            onShowInfoStage: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return CustomModalWidget(
                    title: stage!.sectionName,
                    content: stage!.introduction,
                    buttonText: 'Aceptar',
                    id: stage!.sectionNumber.toString(),
                    itemCount: stage!.levelCount,
                    itemsCompleted: stage!.levelCompletedCount,
                  );
                },
              );
            },
            onScroller: onScrollPosition,
          ),
          Positioned(
            top: 0,
            right: 30,
            child: IconButton(
              iconSize: 25,
              icon: Icon(
                isMuted ? Icons.volume_off : Icons.volume_up,
                color: isMuted ? Colors.grey : Colors.white,
              ),
              onPressed: () async {
                await muteAudio();
                if (isMuted) {
                  stopAudio();
                } else {
                  playAudio();
                }
              },
            ),
          )
        ]),
        SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: _buildMobileMap(),
        ),
      ],
    );
  }

  // Mapa móvil (existente)
  Widget _buildMobileMap() {
    // Coordenadas existentes...
    List<double> coordATop = [0.0, 0.10, 0.31, 0.54, 0.76];
    List<double> coordALeft = [0.20, 0.49, 0.65, 0.65, 0.64];
    List<double> coordBTop = [0.0, 0.13, 0.31, 0.54, 0.76];
    List<double> coordBLeft = [0.40, 0.17, 0.01, 0.03, 0.05];
    List<double> coordATopBarco = [
      0.25,
      0.35,
      0.45,
      0.48,
      0.65,
      0.75,
      0.75,
      0.85
    ];
    List<double> coordALeftBarco = [
      0.20,
      0.10,
      -0.05,
      0.35,
      0.17,
      0.35,
      0.10,
      0.25
    ];
    List<double> coordBTopBarco = [
      0.05,
      0.25,
      0.35,
      0.45,
      0.45,
      0.60,
      0.75,
      0.85
    ];
    List<double> coordBLeftBarco = [
      0.90,
      0.85,
      0.65,
      0.80,
      0.52,
      0.87,
      0.50,
      0.90
    ];

    return ListView.builder(
      controller: scrollController,
      itemCount: gruposDeNiveles.length,
      itemBuilder: (context, index) {
        List<Level> grupo = gruposDeNiveles[index];
        String image = index == 0
            ? imagePaths[0]
            : index % 2 == 0
                ? imagePaths[1]
                : imagePaths[2];
        return Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  padding: index == 0
                      ? EdgeInsets.only(top: 20)
                      : EdgeInsets.only(top: 0),
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.sizeOf(context).height,
                  ),
                  child: Image.asset(
                    image,
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height + 130,
                    fit: BoxFit.fill,
                  ),
                ),
                if (index % 2 == 0) ...{
                  for (var j = 0; j < 8; j++) ...{
                    InfiniteAnimation(
                      coordTop: coordATopBarco[j],
                      coordLeft: coordALeftBarco[j],
                      j: j,
                      index: index,
                    ),
                  },
                } else ...{
                  for (var j = 0; j < 8; j++) ...{
                    InfiniteAnimation(
                      coordTop: coordBTopBarco[j],
                      coordLeft: coordBLeftBarco[j],
                      j: j,
                      index: index,
                    ),
                  }
                },
                for (var i = 0; i < grupo.length; i++) ...{
                  Positioned(
                    key: Key(grupo[i].id),
                    top: index % 2 == 0
                        ? StylesApp(context).positionedLevels(coordATop[i]).dy
                        : StylesApp(context).positionedLevels(coordBTop[i]).dy,
                    left: index % 2 == 0
                        ? StylesApp(context).positionedLevels(coordALeft[i]).dx
                        : StylesApp(context).positionedLevels(coordBLeft[i]).dx,
                    child: GestureDetector(
                      key: Key("$index-$i"),
                      onTap: grupo[i].unLockLevel == false
                          ? null
                          : () async {
                              stopAudio();
                              if (grupo[i].isUnderConstruction == true) {
                                await showCustomDialog(context,
                                    message:
                                        "Este Nivel Esta en Construcción,\n al Estar disponible Te llagara un Notificación",
                                    dialogType: DialogType.info);
                                return;
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  '/historyPage',
                                  arguments: {
                                    'courseId': course?.id,
                                    'levelId': grupo[i].id,
                                    'sectionId': stage!.id
                                  },
                                );
                              }
                            },
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: StylesApp(context).sizeContainerLevel.width,
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: StarStatusWidget(
                                containerWidth:
                                    StylesApp(context).sizeContainerLevel.width,
                                levelScore: grupo[i].levelScore,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 30),
                                Center(
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: StylesApp(context)
                                            .sizeContainer
                                            .width,
                                        height: StylesApp(context)
                                            .sizeContainer
                                            .height,
                                        decoration: BoxDecoration(
                                            color: Color(grupo[i].levelScore > 0
                                                ? getColorItem(
                                                    grupo[i].levelScore)
                                                : int.tryParse(
                                                        '0xFF${grupo[i].color}') ??
                                                    0XFF000000),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: grupo[i].levelScore > 0
                                                  ? Color(getColorItem(
                                                      grupo[i].levelScore))
                                                  : Color.fromARGB(
                                                      100,
                                                      int.parse(
                                                          '0xFF${grupo[i].color}'
                                                              .substring(2),
                                                          radix: 16),
                                                      int.parse(
                                                          '0xFF${grupo[i].color}'
                                                              .substring(4, 6),
                                                          radix: 16),
                                                      int.parse(
                                                          '0xFF${grupo[i].color}'
                                                              .substring(6),
                                                          radix: 16),
                                                    ),
                                              width: 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: grupo[i].levelScore > 0
                                                    ? Color(getColorShadow(
                                                            grupo[i]
                                                                .levelScore))
                                                        .withValues(alpha: 0.5)
                                                    : Colors.black
                                                        .withValues(alpha: 0.5),
                                                offset: Offset(0, 8),
                                                blurRadius: 8,
                                              )
                                            ]),
                                        child: Center(
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              if (grupo[i].unLockLevel ==
                                                      true &&
                                                  grupo[i].levelScore == 0) ...{
                                                AnimatedBuilder(
                                                  animation: _animation,
                                                  builder: (context, child) {
                                                    return Container(
                                                      width: StylesApp(context)
                                                              .sizeContainer
                                                              .width +
                                                          10 * _animation.value,
                                                      height: StylesApp(context)
                                                              .sizeContainer
                                                              .height +
                                                          10 * _animation.value,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.yellow
                                                            .withValues(alpha: 0.5 *
                                                                (1 -
                                                                    _animation
                                                                        .value)),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              },
                                              _buildItemLevel(
                                                  context,
                                                  grupo[i],
                                                  StylesApp(context)
                                                      .sizeContainerSub
                                                      .width),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (grupo[i].unLockLevel == false)
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFFA9B8BE)
                                                  .withValues(alpha: 0.9),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "${grupo[i].levelNumber} ${grupo[i].name}",
                                  style: StylesApp(context)
                                      .textStyNameNumber
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                  textAlign: TextAlign.center,
                                  maxLines: grupo[i].isUnderConstruction == true
                                      ? 1
                                      : 3,
                                  overflow: grupo[i].isUnderConstruction == true
                                      ? TextOverflow.ellipsis
                                      : TextOverflow.clip,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                },
              ],
            ),
          ],
        );
      },
    );
  }

  // Bottom Navigation Bar (existente)
  Widget _buildBottomNavigationBar() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isVisible,
      builder: (context, isVisible, child) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isVisible ? kBottomNavigationBarHeight + 25 : 0,
          curve: Curves.easeInOut,
          child: Wrap(children: [
            CustomBottomNavigationBarWidget(
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              backgroundColor: Colors.white,
              selectedItemColor: Color(0XFF12CBC4),
              unselectedItemColor: Colors.white,
              selectedLabelStyle: StylesApp(context).textStyleBody10,
              unselectedLabelStyle: StylesApp(context).textStyleBody10,
              items: getItemsMap(context),
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ]),
        );
      },
    );
  }

  void _showBottomNavigationBar() {
    _isVisible.value = true;
    _timer?.cancel();
    _timer = Timer(Duration(seconds: 2), () {
      _isVisible.value = false;
    });
  }

  // ========== WIDGETS AUXILIARES ==========
  Widget _buildProgressInfo({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: StylesApp(context).textStyleBody20.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              Text(
                label,
                style: StylesApp(context).textStyleBody12.copyWith(
                      fontSize: 11,
                      color: color.withValues(alpha: 0.8),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavChip({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: StyleColor.turquoise.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: StyleColor.turquoise.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: StyleColor.turquoise),
            SizedBox(width: 6),
            Text(
              label,
              style: StylesApp(context).textStyleBody14.copyWith(
                    fontSize: 14,
                    color: StyleColor.turquoise,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemLevel(BuildContext context, Level level, double size) {
    if (level.img.urlImg.isNotEmpty) {
      return Container(
        clipBehavior: Clip.antiAlias,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: level.levelScore > 0
              ? Color(getColorInner(level.levelScore))
              : Color.fromARGB(
                  100,
                  int.parse('0xFF${level.color}'.substring(2), radix: 16),
                  int.parse('0xFF${level.color}'.substring(4, 6), radix: 16),
                  int.parse('0xFF${level.color}'.substring(6), radix: 16),
                ),
          shape: BoxShape.circle,
        ),
        child: Image.network(
          "${GraphQLConfig.urlServidor}${level.img.urlImg}",
          errorBuilder: (context, error, stackTrace) {
            return Image.asset("assets/level.png", fit: BoxFit.cover);
          },
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: level.levelScore > 0
              ? Color(getColorInner(level.levelScore))
              : Color.fromARGB(
                  100,
                  int.parse('0xFF${level.color}'.substring(2), radix: 16),
                  int.parse('0xFF${level.color}'.substring(4, 6), radix: 16),
                  int.parse('0xFF${level.color}'.substring(6), radix: 16),
                ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (level.isUnderConstruction == true) ...{
                Icon(Icons.construction, size: size * 0.4),
              } else ...{
                Text(
                  "${level.levelNumber}",
                  style: TextStyle(
                    fontSize: size * 0.3,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "paso",
                  style: TextStyle(
                    fontSize: size * 0.15,
                    color: Colors.white,
                  ),
                ),
              },
            ],
          ),
        ),
      );
    }
  }

  // Métodos de color existentes...
  int getColorShadow(int score) {
    if (score > 100) return 0XFFBE9D27;
    if (score > 50 && score <= 100) return 0XFFA5A7A1;
    return 0XFFD5886B;
  }

  int getColorItem(int score) {
    if (score > 100) return 0XFFFCD859;
    if (score > 50 && score <= 100) return 0XFFE4E0E0;
    return 0XFFD5886B;
  }

  int getColorInner(int score) {
    if (score > 100) return 0XFFDDAC17;
    if (score >= 50 && score <= 100) return 0XFFA5A7A1;
    return 0XFFB05E3C;
  }

  int getCompletedLevelsCount() {
    // Si no, calcula basándote en los niveles con score > 0
    if (levels.isNotEmpty) {
      return levels.where((level) => level.levelScore > 0).length;
    }

    return 0;
  }

  int getTotalLevelsCount() {
    // Prioridad 1: stage.levelCount
    if (stage != null && stage!.levelCount > 0) {
      return stage!.levelCount;
    }

    // Prioridad 2: stage.numberOfLevels
    if (stage != null &&
        stage!.numberOfLevels != null &&
        stage!.numberOfLevels! > 0) {
      return stage!.numberOfLevels!;
    }

    // Prioridad 3: contar todos los niveles en la lista
    if (levels.isNotEmpty) {
      return levels.length;
    }

    return 0;
  }

  double getProgressPercentage() {
    final completed = getCompletedLevelsCount();
    final total = getTotalLevelsCount();

    if (total == 0) return 0.0;

    return (completed / total * 100).clamp(0.0, 100.0);
  }
}
