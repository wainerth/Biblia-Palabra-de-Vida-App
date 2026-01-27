import 'dart:async';

import 'package:biblia_palabra_de_vida_app/class/bible_version_selector.dart';
import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

// ============================================================================
// ENUMERACIONES Y CONSTANTES
// ============================================================================

enum BibleScreenState {
  loading,
  skeleton,
  content,
  error,
}

const Duration _kLoadTimeout = Duration(seconds: 10);
// ============================================================================
// CLASE PRINCIPAL
// ============================================================================

class BibleScreen extends StatefulWidget {
  const BibleScreen({super.key});

  @override
  State<BibleScreen> createState() => _BibleScreenState();
}

// ============================================================================
// ESTADO DEL WIDGET
// ============================================================================

class _BibleScreenState extends State<BibleScreen> {
  // ==========================================================================
  // 1. CONTROLADORES Y KEYS
  // ==========================================================================
  final ScrollController scrollController = ScrollController();
  final GlobalKey _selectableTextKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<int, GlobalKey> _verseKeys = {};

  // ==========================================================================
  // 2. PROPIEDADES DE FLUTTER TTS
  // ==========================================================================
  late FlutterTts flutterTts;
  bool isPlaying = false;
  int? currentPlayingVerseIndex;
  double _speechRate = 0.5;

  // ==========================================================================
  // 3. ESTADO DE LA PANTALLA Y DATOS
  // ==========================================================================
  BibleScreenState _screenState = BibleScreenState.loading;
  bool _showSkeleton = true;
  String? errorMessage;

  // ==========================================================================
  // 4. DATOS DE LA BIBLIA
  // ==========================================================================
  LoginUser? userData;
  VersionModel? currentVersion;
  BookModel? currentBook;
  ChapterModel? currentChapter;
  List<ChapterModel> allChapters = [];
  List<VerseModel> verses = [];

  // ==========================================================================
  // 5. CONFIGURACIÓN DEL USUARIO
  // ==========================================================================
  String? lastVersionsSelected;
  final String preferenceKey = 'selectedBibleVersion';
  double fontSizeNumber = 12;
  double fontSizeVerse = 16;
  ModelData fontFamilySet = ModelData(label: "Aclonica", value: "1");

  // ==========================================================================
  // 6. FUNCIONALIDADES ADICIONALES
  // ==========================================================================
  bool versionConSaltos = true;
  bool hasPreviousChapter = false;
  bool hasNextChapter = false;
  Video video = Video(url: "");
  List<FavoriteVerse> _favoriteVerses = [];
  List<HighlightRangeModel> _highlights = [];
  late BibleTheme currentTheme;

  // ==========================================================================
  // 7. VARIABLES DE NAVEGACIÓN Y UI
  // ==========================================================================
  int? scrollToVerseStart;
  int? scrollToVerseEnd;
  final bool _showDrawer = false;
  Timer? _loadTimeoutTimer;
  late BibleThemeProvider _themeProvider;
  bool _isThemeListenerRegistered = false;

  // ==========================================================================
  // 8. GETTERS COMPUTADOS
  // ==========================================================================
  bool get _isLoading => _screenState == BibleScreenState.loading;
  bool get _showError => _screenState == BibleScreenState.error;

  final Set<int> _selectedVerses = <int>{};
  // En tu clase de estado
  bool _showSelectionToolbar = false;

  final GlobalKey _toolbarKey = GlobalKey();

// Getter para obtener los versículos seleccionados
  List<VerseModel> get _getSelectedVerses {
    return _selectedVerses.map((index) => verses[index]).toList();
  }

// Verificar si alguno de los versículos seleccionados ya tiene resaltado
  bool get _hasAnyHighlightedSelection {
    return _getSelectedVerses.any(
        (verse) => verse.highlights != null && verse.highlights!.isNotEmpty);
  }

  bool _isVerseSelected(int index) {
    return _selectedVerses.contains(index);
  }

  void _onVerseTap(int index, VerseModel verse) {
    setState(() {
      if (_selectedVerses.contains(index)) {
        // Deselection si ya está seleccionado
        _selectedVerses.remove(index);
      } else {
        // Seleccionar si no está seleccionado
        _selectedVerses.add(index);
      }
    });

    if (kDebugMode) {
      print(
          'Versículo ${verse.verse} ${_selectedVerses.contains(index) ? 'seleccionado' : 'deseleccionado'}');
    }

    // Mostrar/ocultar toolbar si hay selección
    _updateToolbarVisibility();
  }

  void _updateToolbarVisibility() {
    if (_selectedVerses.isNotEmpty) {
      _showToolbar();
    } else {
      _hideToolbar();
    }
  }

// Función para obtener los versículos seleccionados
  List<VerseModel> getSelectedVerses() {
    return _selectedVerses.map((index) => verses[index]).toList();
  }

  // ==========================================================================
  // 9. INIT STATE
  // ==========================================================================
  @override
  void initState() {
    super.initState();
    _initTTS();
    _initSpeechRate();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScreen();
    });
  }
  // ==========================================================================
  // 10. didChangeDependencies
  // ==========================================================================

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Registrar listener para cambios de tema
    if (!_isThemeListenerRegistered) {
      _themeProvider = Provider.of<BibleThemeProvider>(context, listen: false);
      _themeProvider.addListener(_onThemeChanged);
      _isThemeListenerRegistered = true;

      // Establecer el tema inicial
      currentTheme = _themeProvider.themeData;
    }
  }

  // ==========================================================================
  // 10. DISPOSE
  // ==========================================================================
  @override
  void dispose() {
    // Remover listener cuando se destruya el widget
    if (_isThemeListenerRegistered) {
      _themeProvider.removeListener(_onThemeChanged);
    }
    _loadTimeoutTimer?.cancel();
    flutterTts.stop();
    scrollController.dispose();
    super.dispose();
  }

  // ==========================================================================
  // 11. MÉTODOS DE INICIALIZACIÓN
  // ==========================================================================

  void _initTTS() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage("es-ES");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    flutterTts.setStartHandler(() {
      setState(() => isPlaying = true);
    });

    flutterTts.setCompletionHandler(() {
      setState(() {});
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isPlaying = false;
        currentPlayingVerseIndex = null;
      });
      _showSnackBar("Error en TTS: $msg");
    });
  }

// inicializa la velocidad de habla desde las preferencias del usuario
  Future<void> _initSpeechRate() async {
    final rate = await PreferencesManager().getTtsSpeechRate();
    setState(() => _speechRate = rate);
    await flutterTts.setSpeechRate(_speechRate);
  }

  // ==========================================================================
  // 12. INICIALIZACIÓN PRINCIPAL CON TIME-OUT
  // ==========================================================================

  Future<void> _initializeScreen() async {
    // Configurar timeout para evitar loading infinito
    _loadTimeoutTimer = Timer(_kLoadTimeout, () {
      if (mounted && _screenState == BibleScreenState.loading) {
        setState(() {
          _screenState = BibleScreenState.error;
          errorMessage = 'Tiempo de carga excedido';
        });
        LoadingService().hideLoading();
      }
    });

    try {
      // 1. Obtener datos del usuario
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userData = userProvider.currentUser;

      // 2. Mostrar skeleton inmediatamente
      setState(() {
        _screenState = BibleScreenState.skeleton;
        _showSkeleton = true;
      });

      // 3. Cargar datos mínimos con timeout
      await _loadMinimumDataWithTimeout();

      // 4. Si llegamos aquí y aún estamos en skeleton, cambiar a content
      if (_screenState == BibleScreenState.skeleton) {
        setState(() {
          _screenState = BibleScreenState.content;
          _showSkeleton = false;
        });
      }

      // 5. Manejar argumentos de navegación (solo si tenemos datos)
      if (currentVersion != null && currentBook != null) {
        await _handleNavigationArguments();
      }

      // 5. Cargar datos adicionales en background
      _loadAdditionalDataInBackground();
    } catch (e) {
      _handleInitializationError(e);
    } finally {
      _loadTimeoutTimer?.cancel();
      LoadingService().hideLoading();
    }
  }

  Future<void> _loadMinimumDataWithTimeout() async {
    try {
      // Cargar versión y libro
      await _loadBibleVersionAndBook();

      // Verificar que tengamos datos básicos
      if (currentVersion == null || currentBook == null) {
        throw Exception('No se pudo cargar la versión o libro de la biblia');
      }

      // Cargar capítulo inicial
      _loadInitialChapter();

      // Verificar que tengamos versículos
      if (verses.isEmpty) {
        // Si no hay versículos, intentar cargar de otra manera
        await _loadChaptersFallback();
      }
    } on TimeoutException catch (_) {
      _useFallbackData();
    } catch (e) {
      rethrow;
    }
  }

  void _useFallbackData() {
    // Datos mínimos para mostrar algo
    if (currentVersion == null) {
      final catalogueProvider = context.read<CatalogueProvider>();
      if (catalogueProvider.allBibleVersion.isNotEmpty) {
        currentVersion = catalogueProvider.allBibleVersion.first;
        currentBook = currentVersion!.books.first;
      }
    }

    setState(() {
      _screenState = BibleScreenState.content;
      _showSkeleton = false;
      verses = []; // Lista vacía pero UI funcional
    });
  }

  Future<void> _loadChaptersFallback() async {
    try {
      if (currentBook == null) return;

      // Intentar cargar todos los capítulos
      final response = await getChapterWithVerses(currentBook!.id);

      if (response.error == null && response.data.isNotEmpty) {
        allChapters = response.data
            .map<ChapterModel>((chapter) => ChapterModel.fromJson(chapter))
            .toList();
        allChapters.sort((a, b) => a.chapter.compareTo(b.chapter));

        // Usar el primer capítulo disponible
        if (allChapters.isNotEmpty) {
          currentChapter = allChapters.first;
          verses = currentChapter!.verses ?? [];
        }
      }
    } catch (e) {
      // Si falla, mantener versículos vacíos pero mostrar UI
      if (kDebugMode) print('⚠️ Fallback load failed: $e');
    }
  }

  // ==========================================================================
  // MÉTODO PARA MANEJAR CAMBIOS DE TEMA
  // ==========================================================================
  void _onThemeChanged() {
    if (mounted) {
      setState(() {
        // Actualizar el tema actual cuando el provider notifique cambios
        currentTheme = _themeProvider.themeData;
      });
    }
  }
  // ==========================================================================
  // 13. CARGA DE DATOS PRINCIPALES
  // ==========================================================================

  Future<void> _loadBibleVersionAndBook() async {
    final catalogueProvider = context.read<CatalogueProvider>();

    // Asegurar que BibleVersions estén cargadas
    if (catalogueProvider.allBibleVersion.isEmpty) {
      await catalogueProvider.loadBibleVersions();
    }

    lastVersionsSelected = await PreferencesManager().getSelectedBibleVersion();
    final loadBook = await PreferencesManager().getBookSelected();

    if (lastVersionsSelected != null) {
      currentVersion = catalogueProvider.allBibleVersion
          .firstWhere((version) => version.id == lastVersionsSelected);
    } else {
      currentVersion = catalogueProvider.allBibleVersion.first;
      await PreferencesManager().setSelectedBibleVersion(currentVersion!.id);
    }

    if (loadBook != null && currentVersion != null) {
      currentBook = currentVersion!.books.firstWhere((b) => b.id == loadBook);
    } else {
      currentBook = currentVersion!.books.first;
      await PreferencesManager().setBookSelected(currentBook!.id);
    }
  }

  Future<void> _loadInitialChapter() async {
    if (currentBook == null) return;

    try {
      // 1. Obtener el número de capítulo guardado
      final chapterNumberStr =
          await PreferencesManager().getChapterSelected() ?? '1';
      final chapterNumber = int.tryParse(chapterNumberStr) ?? 1;

      if (kDebugMode) {
        print('📖 Intentando cargar capítulo guardado: $chapterNumber');
      }

      // 2. Cargar TODOS los capítulos del libro
      final response = await getChapterWithVerses(currentBook!.id);

      if (response.error == null && response.data.isNotEmpty) {
        // 3. Buscar el capítulo específico por número
        ChapterModel? foundChapter;

        for (var chapterData in response.data) {
          final chapter = ChapterModel.fromJson(chapterData);
          if (chapter.chapter == chapterNumber) {
            foundChapter = chapter;
            break;
          }
        }

        // 4. Si no se encuentra el capítulo, usar el primero
        currentChapter =
            foundChapter ?? ChapterModel.fromJson(response.data.first);
        verses = currentChapter!.verses ?? [];

        // 5. Actualizar el conteo de capítulos del libro
        currentBook = currentBook?.copyWith(chapters: response.data.length);

        if (kDebugMode) {
          print(
              '✅ Capítulo cargado: ${currentChapter!.chapter} (guardado: $chapterNumber)');
          print('✅ Versículos: ${verses.length}');
          print('✅ Total capítulos en libro: ${currentBook!.chapters}');
        }

        validateNextAndPrevious();

        // 6. Actualizar estado
        setState(() {
          _screenState = BibleScreenState.content;
          _showSkeleton = false;
        });

        return;
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error en _loadInitialChapter: $e');
    }

    // 7. Fallback: cargar todos los capítulos
    if (kDebugMode) print('⚠️ Usando fallback loadChapters');
    await loadChapters(currentBook!, false);
  }

  Future<void> _handleNavigationArguments() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null && args['bibleId'] != null) {
      final bibleId = args['bibleId'];
      final bookId = args['bookId'];
      final chapterId = args['chapterId'];
      final verseId = args['verseId'];

      await loadVersionAndChapter(InputDataSearchModel(
        versionId: bibleId,
        bookId: bookId,
        chapterId: chapterId,
        startVerseId: verseId,
        endVerseId: verseId,
      ));
    }
  }

  // ==========================================================================
  // 14. CARGA EN BACKGROUND
  // ==========================================================================

  void _loadAdditionalDataInBackground() {
    if (currentChapter?.id != null) {
      Future.microtask(() async {
        try {
          await Future.wait([
            _loadHighlights(),
            _loadPersistedData(),
            loadVideoByChapter(currentChapter!.id!),
          ], eagerError: false);
        } catch (e) {
          if (kDebugMode) print('⚠️ Background data load error: $e');
        }
      });
    }

    // Cargar todos los capítulos en background
    if (allChapters.isEmpty) {
      Future.microtask(() async {
        try {
          await loadChapters(currentBook!, false);
        } catch (e) {
          // No crítico
        }
      });
    }
  }

  void _handleInitializationError(dynamic error) {
    if (mounted) {
      setState(() {
        _screenState = BibleScreenState.error;
        _showSkeleton = false;
        errorMessage = 'Error al cargar: ${error.toString()}';
      });
    }
    LoadingService().hideLoading();
  }

  // ==========================================================================
  // 16. MÉTODOS DE TTS
  // ==========================================================================

  String _getSpeedLabel(double speed) {
    if (speed <= 0.4) return 'Lento';
    if (speed <= 0.6) return 'Normal';
    return 'Rápido';
  }

  Future<void> _readVerse(VerseModel verse) async {
    try {
      if (isPlaying) await flutterTts.stop();

      setState(() => currentPlayingVerseIndex = verses.indexOf(verse));
      await flutterTts.speak("Versículo ${verse.verse}. ${verse.text}");
    } catch (e) {
      _showSnackBar("Error al leer versículo: ${e.toString()}");
    } finally {
      setState(() => isPlaying = false);
      await flutterTts.stop();
    }
  }

  Future<void> _togglePlayPause() async {
    if (isPlaying) {
      await flutterTts.pause();
      setState(() => isPlaying = false);
    } else {
      if (currentPlayingVerseIndex != null) {
        await flutterTts.awaitSpeakCompletion(true);
        if (currentPlayingVerseIndex != null &&
            currentPlayingVerseIndex! < verses.length) {
          await flutterTts.speak(
              "Versículo ${verses[currentPlayingVerseIndex!].verse}. ${verses[currentPlayingVerseIndex!].text}");
        }
      } else {
        _readFullChapter();
      }
      setState(() => isPlaying = true);
    }
  }

  // ==========================================================================
  // 17. BUILD PRINCIPAL
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    // final themeProvider =
    //     Provider.of<BibleThemeProvider>(context, listen: false);
    // currentTheme = themeProvider.themeData;

    return Builder(
      builder: (context) {
        return _buildMainContent(currentTheme);
      },
    );
  }

  Widget _buildMainContent(BibleTheme theme) {
    if (_showError) {
      return _buildErrorScreen();
    }

    if (_isLoading) {
      return _buildLoadingScreen();
    }

    if (_showSkeleton) {
      return _buildSkeletonScreen(theme);
    }

    return isTablet(context)
        ? _buildTableLayout(theme)
        : _buildMobileLayout(theme);
  }

  void _showToolbar() {
    // Posicionar el toolbar en el centro vertical, a la derecha
    setState(() {
      _showSelectionToolbar = true;
    });
  }

  void _hideToolbar() {
    setState(() {
      _showSelectionToolbar = false;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedVerses.clear();
      _showSelectionToolbar = false;
    });
  }
  // ==========================================================================
  // 18. ESTADOS DE UI
  // ==========================================================================

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: currentTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Cargando Biblia...',
              style: TextStyle(color: currentTheme.textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonScreen(BibleTheme theme) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skeleton header
            Container(
              height: 80,
              color: theme.appBarColor,
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 16,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 80,
                          height: 12,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.only(right: 8, top: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 16,
                                margin: EdgeInsets.only(bottom: 4),
                                color: Colors.grey[300],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: 16,
                                margin: EdgeInsets.only(bottom: 4),
                                color: Colors.grey[300],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 16,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: currentTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              errorMessage ?? 'Error desconocido',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: currentTheme.textColor,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _screenState = BibleScreenState.loading;
                });
                _initializeScreen();
              },
              child: Text('Reintentar'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/layoutPage',
                  arguments: {'selectedIndex': 0},
                );
              },
              child: Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // 19. LAYOUT PRINCIPALES
  // ==========================================================================

  Widget _buildTableLayout(BibleTheme currentTheme) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: currentTheme.backgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            Flexible(
              flex: 3,
              child: _buildNavigationPanel(currentTheme),
            ),
            Flexible(
              flex: 8,
              child: _buildBibleContent(currentTheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BibleTheme currentTheme) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: currentTheme.backgroundColor,
      endDrawer: _buildNavigationDrawer(currentTheme),
      endDrawerEnableOpenDragGesture: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: _showDrawer
          ? FloatingActionButton(
              mini: true,
              elevation: 0,
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
              backgroundColor: currentTheme.backgroundColor,
              child: Icon(
                Icons.menu,
                color: currentTheme.buttonColor,
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            if (!_showDrawer)
              BibleHeaderWidget(
                spacingBottom: 10.0,
                onSearchBible: () {
                  setState(() {
                    scrollToVerseStart = null;
                    scrollToVerseEnd = null;
                  });
                  openModal();
                },
                versionName:
                    currentVersion != null ? currentVersion!.version : '',
                title: currentBook != null ? currentBook!.modernName : '',
                showIconVideo: video.url.isNotEmpty,
                chapter:
                    currentChapter != null ? '${currentChapter!.chapter}' : '',
                onVideoCollection: _showVideoDialog,
                onBack: () async {
                  Navigator.pushNamed(
                    context,
                    '/layoutPage',
                    arguments: {'selectedIndex': 0},
                  );
                },
                onVersionTap: _changeBibleVersion,
              ),
            Expanded(
              child: _buildBibleContent(currentTheme),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // 20. COMPONENTES REUTILIZABLES
  // ==========================================================================

  Widget _buildNavigationPanel(BibleTheme currentTheme) {
    return Container(
      decoration: BoxDecoration(
        color: currentTheme.backgroundColor,
        border: Border(
          right: BorderSide(
            color: currentTheme.buttonColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            decoration: BoxDecoration(
              color: currentTheme.appBarColor,
            ),
            child: Stack(
              children: [
                Container(
                  height: 35.0,
                  width: 35.0,
                  decoration: BoxDecoration(
                    color: currentTheme.name != 'Claro'
                        ? currentTheme.buttonColor
                        : Color(0XFFFD8C43),
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  child: IconButton(
                    constraints: BoxConstraints(maxHeight: 35.0),
                    padding: EdgeInsets.all(0),
                    iconSize: 35.0,
                    color: currentTheme.name != 'Claro'
                        ? currentTheme.buttonTextColor
                        : currentTheme.backgroundColor,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/layoutPage',
                      arguments: {'selectedIndex': 0},
                    ),
                    icon: Icon(
                      Icons.arrow_back,
                      size: 35.0,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Navegación',
                    style: StylesApp(context).textStyleBody18.copyWith(
                          color: currentTheme.buttonTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              children: [
                BibleHeaderWidget(
                  widthButton: 250.0,
                  showButton: false,
                  topPosition: null,
                  bottomPosition: 10.0,
                  onSearchBible: () {
                    setState(() {
                      scrollToVerseStart = null;
                      scrollToVerseEnd = null;
                    });
                    openModal();
                  },
                  versionName:
                      currentVersion != null ? currentVersion!.version : '',
                  title: currentBook != null ? currentBook!.modernName : '',
                  showIconVideo: video.url.isNotEmpty,
                  chapter: currentChapter != null
                      ? '${currentChapter!.chapter}'
                      : '',
                  onVideoCollection: _showVideoDialog,
                  onVersionTap: _changeBibleVersion,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBibleContent(BibleTheme currentTheme) {
    return Column(
      children: [
        // este es el Contenedor de la biblia es donde se cargan los versículos de un capitulo
        Expanded(
          child: Stack(
            children: [
              Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                thickness: 6.0,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        // indicador del drawer lateral para navegar
                        if (_showDrawer) _buildDrawerIndicator(currentTheme),
                        const SizedBox(height: 40),
                        // Contenido de la Biblia
                        _buildContinuousText(),
                        SizedBox(height: kBottomNavigationBarHeight + 45),
                      ],
                    ),
                  ),
                ),
              ),
              _buildSelectionToolbar(),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration:
                      BoxDecoration(color: currentTheme.backgroundColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildIconButton(
                        icon: CupertinoIcons.textformat_size,
                        onPressed: _showTextFormatModal,
                      ),
                      _buildIconButton(
                        icon: Icons.file_copy_rounded,
                        onPressed: _copyChapter,
                      ),
                      _buildIconButton(
                        icon: Icons.share_rounded,
                        onPressed: _shareChapter,
                      ),
                      _buildIconButton(
                        icon: Icons.search_rounded,
                        onPressed: () {
                          setState(() {
                            scrollToVerseStart = null;
                            scrollToVerseEnd = null;
                          });
                          openModal();
                        },
                      ),
                      _buildIconButton(
                        icon: Icons.star,
                        onPressed: _showFavorites,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 0,
                left: 0,
                child: _buildNavigationControls(currentTheme),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      padding: EdgeInsets.zero,
      iconSize: 25.0,
      onPressed: onPressed,
      icon: Icon(icon, color: currentTheme.buttonColor),
    );
  }

  // ==========================================================================
  // 21. CONTROLES DE NAVEGACIÓN Y TTS
  // ==========================================================================

  Widget _buildNavigationControls(BibleTheme currentTheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.0),
      width: MediaQuery.sizeOf(context).width * (isTablet(context) ? 0.75 : 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildChapterButton(
            icon: Icons.keyboard_arrow_left_rounded,
            enabled: hasPreviousChapter,
            onPressed: () => _goToPreviousChapter(
              (currentChapter!.chapter - 1).toString(),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: currentTheme.backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.stop, size: 24),
                              color: currentTheme.buttonColor,
                              onPressed: () async {
                                await flutterTts.stop();
                                setState(() {
                                  isPlaying = false;
                                  currentPlayingVerseIndex = null;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 28,
                              ),
                              color: currentTheme.buttonColor,
                              onPressed: _togglePlayPause,
                            ),
                            Icon(Icons.speed,
                                size: 18, color: currentTheme.textColor),
                            SizedBox(width: 8),
                            Expanded(
                              child: Slider(
                                value: _speechRate,
                                min: 0.1,
                                max: 1.0,
                                divisions: 9,
                                label: _getSpeedLabel(_speechRate),
                                activeColor: currentTheme.buttonColor,
                                inactiveColor: currentTheme.buttonColor
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
                              _getSpeedLabel(_speechRate),
                              style: TextStyle(
                                color: currentTheme.textColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Velocidad: ${(_speechRate * 100).round()}%',
                          style: TextStyle(
                            color: currentTheme.textColor,
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
          _buildChapterButton(
            icon: Icons.keyboard_arrow_right_rounded,
            enabled: hasNextChapter,
            onPressed: () => _goToNextChapter(
              (currentChapter!.chapter + 1).toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: enabled ? currentTheme.buttonColor : StyleColor.grayMedium,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: IconButton(
          disabledColor: StyleColor.grayMedium,
          padding: EdgeInsets.all(0),
          alignment: Alignment.center,
          iconSize: 35,
          onPressed: enabled ? onPressed : null,
          icon: Icon(
            icon,
            size: 35,
            color: currentTheme.buttonTextColor,
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // 22. DRAWER DE NAVEGACIÓN
  // ==========================================================================

  Widget _buildNavigationDrawer(BibleTheme currentTheme) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.75,
      backgroundColor: currentTheme.backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
              decoration: BoxDecoration(
                color: currentTheme.appBarColor,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Navegación',
                        style: StylesApp(context).textStyleBody18.copyWith(
                              color: currentTheme.buttonTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 24),
                        color: currentTheme.buttonTextColor,
                        onPressed: () {
                          _scaffoldKey.currentState?.closeEndDrawer();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  BibleHeaderWidget(
                    showButton: false,
                    spacingBottom: 10.0,
                    onSearchBible: () {
                      setState(() {
                        scrollToVerseStart = null;
                        scrollToVerseEnd = null;
                      });
                      openModal();
                    },
                    versionName:
                        currentVersion != null ? currentVersion!.version : '',
                    title: currentBook != null ? currentBook!.modernName : '',
                    showIconVideo: video.url.isNotEmpty,
                    chapter: currentChapter != null
                        ? '${currentChapter!.chapter}'
                        : '',
                    onVideoCollection: _showVideoDialog,
                    onBack: () async {
                      Navigator.pushNamed(
                        context,
                        '/layoutPage',
                        arguments: {'selectedIndex': 0},
                      );
                    },
                    onVersionTap: _changeBibleVersion,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerIndicator(BibleTheme currentTheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: currentTheme.buttonColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: currentTheme.buttonColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.swipe_left,
            color: currentTheme.buttonColor,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Desliza desde la derecha para navegar',
            style: TextStyle(
              color: currentTheme.buttonColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 23. TEXTO CONTINUO CON RESALTADOS
  // ==========================================================================

  Widget _buildContinuousText() {
    // si se esta cargando la biblia o esta en precarga
    if (_screenState == BibleScreenState.loading || _showSkeleton) {
      return _buildLoadingVerses();
    }
    // si no hubo contenido a mostrar
    if (verses.isEmpty && _screenState == BibleScreenState.content) {
      return _buildNoVersesMessage();
    }
    verses.map((v) => "${v.verse} ${v.text}").join(' ');

    return SelectableText.rich(
      enableInteractiveSelection: false,
      TextSpan(
        children: verses.asMap().entries.expand((entry) {
          final index = entry.key;
          final verse = entry.value;
          _verseKeys[index] ??= GlobalKey();

          final isInScrollRange = _isVerseInScrollRange(verse.verse);
          final isFirstInRange = scrollToVerseStart != null &&
              verse.verse.toString() == scrollToVerseStart.toString();

          return [
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: GestureDetector(
                onTap: () => _showVersePopupMenu(context, verse),
                child: Stack(
                  key: _verseKeys[index],
                  alignment: Alignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, -4),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isInScrollRange
                                  ? StyleColor.white
                                  : _isVerseSelected(index)
                                      ? Colors.blue.withValues(alpha: 0.3)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                              border: isInScrollRange
                                  ? Border.all(
                                      color: StyleColor.blueDark,
                                      width: isFirstInRange ? 2 : 1,
                                    )
                                  : null,
                            ),
                            child: Text(
                              "${verse.verse}",
                              style: StylesApp(context)
                                  .textStyleBody16
                                  .copyWith(
                                    fontFamily: fontFamilySet.label,
                                    fontSize: fontSizeNumber,
                                    fontWeight: FontWeight.bold,
                                    color: isInScrollRange
                                        ? StyleColor.blueDark
                                        : currentPlayingVerseIndex ==
                                                verses.indexOf(verse)
                                            ? Colors.blue
                                            : currentTheme.verseHighlightColor,
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
            // Usamos la función _buildHighlightedTextSpansForSelection modificada
            ..._buildHighlightedTextSpansForSelectionWithTap(verse, index)
                .map((span) {
              if (isInScrollRange) {
                return TextSpan(
                  text: span.text,
                  style: span.style?.copyWith(
                    backgroundColor: _isVerseSelected(index)
                        ? Colors.blue.withValues(alpha: 0.2)
                        : StyleColor.white, // Fondo para texto
                    color: _isVerseSelected(index)
                        ? currentTheme.textColor
                        : StyleColor.blueDark, // Texto azul oscuro
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: span.recognizer,
                );
              }
              return span;
            }),
          ];
        }).toList(),
      ),
      style: TextStyle(
        fontSize: fontSizeNumber,
        fontFamily: fontFamilySet.label,
      ),
    );
  }

  Widget _buildLoadingVerses() {
    return Column(
      children: List.generate(10, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(right: 12, top: 4),
                decoration: BoxDecoration(
                  color: currentTheme.backgroundColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color:
                            currentTheme.backgroundColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 16,
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color:
                            currentTheme.backgroundColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 16,
                      decoration: BoxDecoration(
                        color:
                            currentTheme.backgroundColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _retryLoadChapter() async {
    setState(() {
      _screenState = BibleScreenState.loading;
      _showSkeleton = false;
    });

    try {
      await _loadInitialChapter();

      if (verses.isNotEmpty) {
        setState(() {
          _screenState = BibleScreenState.content;
        });
      } else {
        setState(() {
          _screenState = BibleScreenState.content;
        });
      }
    } catch (e) {
      setState(() {
        _screenState = BibleScreenState.error;
        errorMessage = 'Error al cargar: ${e.toString()}';
      });
    }
  }

// ==========================================================================
// MÉTODO PARA MOSTRAR MENSAJE CUANDO NO HAY VERSÍCULOS
// ==========================================================================

  Widget _buildNoVersesMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono ilustrativo
            Icon(
              Icons.menu_book_rounded,
              size: 80,
              color: currentTheme.buttonColor.withValues(alpha: 0.3),
            ),
            SizedBox(height: 20),

            // Título del mensaje
            Text(
              'No se encontraron versículos',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: currentTheme.textColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),

            // Descripción detallada
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'El capítulo ${currentChapter?.chapter ?? 'actual'} del libro '
                '${currentBook?.modernName ?? 'seleccionado'} no contiene versículos disponibles.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: currentTheme.textColor.withValues(alpha: 0.7),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 8),

            // Información adicional
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: currentTheme.buttonColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: currentTheme.buttonColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: currentTheme.buttonColor,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Información del capítulo',
                          style: TextStyle(
                            color: currentTheme.buttonColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _buildInfoRow(
                      'Libro:', currentBook?.modernName ?? 'No disponible'),
                  _buildInfoRow(
                      'Capítulo:', '${currentChapter?.chapter ?? 'N/A'}'),
                  _buildInfoRow(
                      'Versión:', currentVersion?.version ?? 'No disponible'),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botón para reintentar
                ElevatedButton.icon(
                  onPressed: () {
                    _retryLoadChapter();
                  },
                  icon: Icon(Icons.refresh, size: 20),
                  label: Text('Reintentar'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: currentTheme.buttonTextColor,
                    backgroundColor: currentTheme.buttonColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                SizedBox(width: 12),

                // Botón para cambiar de capítulo
                OutlinedButton.icon(
                  onPressed: () {
                    _goToNextChapter('${(currentChapter?.chapter ?? 0) + 1}');
                  },
                  icon: Icon(Icons.skip_next, size: 20),
                  label: Text('Siguiente capítulo'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: currentTheme.buttonColor,
                    side: BorderSide(color: currentTheme.buttonColor),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

// Widget auxiliar para mostrar información
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: currentTheme.textColor.withValues(alpha: 0.6),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: currentTheme.textColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 24. MÉTODOS DE TEXTO Y RESALTADOS
  // ==========================================================================

  List<TextSpan> _buildHighlightedTextSpansForSelectionWithTap(
      VerseModel verse, int index) {
    final text = " ${verse.text} ";
    final spans = <TextSpan>[];
    int currentPos = 0;

    final bool isVerseSelected = _isVerseSelected(index);

    // Crear un solo TextSpan para todo el versículo con tap
    if (verse.highlights == null || verse.highlights!.isEmpty) {
      // Si no hay resaltados, todo el texto es un solo span
      spans.add(TextSpan(
        text: text,
        recognizer: TapGestureRecognizer()
          ..onTap = () => _onVerseTap(index, verse),
        style: StylesApp(context).textStyleBody14.copyWith(
              decoration: _isFavorite(verse) ? TextDecoration.underline : null,
              color: currentPlayingVerseIndex == index
                  ? Colors.green
                  : currentTheme.textColor,
              backgroundColor: isVerseSelected
                  ? Colors.blue.withValues(alpha: 0.3)
                  : Colors.transparent,
              decorationThickness: 4.0,
              decorationColor: StyleColor.yellowLight,
              fontFamily: fontFamilySet.label,
              fontSize: fontSizeVerse,
              fontWeight: FontWeight.w400,
            ),
      ));
      return spans;
    }

    verse.highlights!.sort((a, b) => a!.startIndex.compareTo(b!.startIndex));

    for (final highlight in verse.highlights!) {
      final verseNumber = "${verse.verse}";
      final verseNumberLength = verseNumber.length;

      final displayStartIndex = highlight!.startIndex + verseNumberLength;
      final displayEndIndex = highlight.endIndex + verseNumberLength;

      if (currentPos < displayStartIndex) {
        spans.add(TextSpan(
          text: text.substring(currentPos, displayStartIndex),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _onVerseTap(index, verse),
          style: StylesApp(context).textStyleBody14.copyWith(
                decoration:
                    _isFavorite(verse) ? TextDecoration.underline : null,
                color: currentPlayingVerseIndex == index
                    ? Colors.green
                    : currentTheme.textColor,
                backgroundColor: isVerseSelected
                    ? Colors.blue.withValues(alpha: 0.2)
                    : Colors.transparent,
                decorationThickness: 4.0,
                decorationColor: StyleColor.yellowLight,
                fontFamily: fontFamilySet.label,
                fontSize: fontSizeVerse,
                fontWeight: FontWeight.w400,
              ),
        ));
      }

      spans.add(TextSpan(
        text: text.substring(displayStartIndex, displayEndIndex),
        // Usar TapGestureRecognizer con timer para detectar long press
        recognizer: TapAndLongPressRecognizer(
          onTap: () => _onVerseTap(index, verse),
          onLongPress: () => _handleLongPress(highlight),
        ),
        style: StylesApp(context).textStyleBody14.copyWith(
              decoration: _isFavorite(verse) ? TextDecoration.underline : null,
              color: currentPlayingVerseIndex == index
                  ? Colors.green
                  : currentTheme.textColor,
              // IMPORTANTE: No sobrescribir el color de resaltado cuando está seleccionado
              backgroundColor: isVerseSelected
                  ? Colors.blue.withValues(alpha: 0.2)
                  : Color(int.parse('0XFF${formatColor(highlight.color)}'))
                      .withAlpha(77),
              decorationThickness: 4.0,
              decorationColor: StyleColor.yellowLight,
              fontFamily: fontFamilySet.label,
              fontSize: fontSizeVerse,
              fontWeight: FontWeight.w400,
            ),
      ));

      currentPos = displayEndIndex;
    }

    if (currentPos < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentPos),
        recognizer: TapGestureRecognizer()
          ..onTap = () => _onVerseTap(index, verse),
        style: StylesApp(context).textStyleBody14.copyWith(
              decoration: _isFavorite(verse) ? TextDecoration.underline : null,
              color: currentPlayingVerseIndex == index
                  ? Colors.green
                  : currentTheme.textColor,
              backgroundColor: isVerseSelected
                  ? Colors.blue.withValues(alpha: 0.2)
                  : Colors.transparent,
              decorationThickness: 4.0,
              decorationColor: StyleColor.yellowLight,
              fontFamily: fontFamilySet.label,
              fontSize: fontSizeVerse,
              fontWeight: FontWeight.w400,
            ),
      ));
    }

    return spans;
  }

// Widget del toolbar flotante
  Widget _buildSelectionToolbar() {
    if (!_showSelectionToolbar || _selectedVerses.isEmpty) {
      return SizedBox.shrink();
    }

    return Positioned(
      left: 16, // Ajusta según tu layout
      top: MediaQuery.of(context).padding.top + 60, // Debajo del status bar
      child: Container(
        key: _toolbarKey,
        decoration: BoxDecoration(
          color: currentTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Contador de versículos seleccionados
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 16, color: Colors.blue),
                  SizedBox(width: 6),
                  Text(
                    '${_selectedVerses.length}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ),

            // Botones del toolbar
            _buildToolbarButton(
              icon: Icons.content_copy,
              iconColor: currentTheme.buttonColor,
              label: 'Copiar',
              onTap: _copySelectedVerses,
            ),
            Divider(height: 1, color: Colors.grey[300]),

            _buildToolbarButton(
              icon: Icons.share,
              iconColor: currentTheme.buttonColor,
              label: 'Compartir',
              onTap: _shareSelectedVerses,
            ),
            Divider(height: 1, color: Colors.grey[300]),

            if (!_hasAnyHighlightedSelection)
              _buildToolbarButton(
                icon: Icons.highlight,
                iconColor: currentTheme.buttonColor,
                label: 'Resaltar',
                onTap: _showHighlightColorPicker,
              ),

            if (!_hasAnyHighlightedSelection)
              Divider(height: 1, color: Colors.grey[300]),

            _buildToolbarButton(
              icon: Icons.clear_all,
              iconColor: currentTheme.buttonColor,
              label: 'Limpiar',
              onTap: _clearSelection,
            ),
          ],
        ),
      ),
    );
  }

// Widget para cada botón del toolbar
  Widget _buildToolbarButton({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          // width: 160, // Ancho fijo para el toolbar
          child: Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLongPress(HighlightRangeModel highlight) {
    if (kDebugMode) {
      print('Long press en texto resaltado');
    }
    _showHighlightOptions(context, highlight);
  }

  // ==========================================================================
  // 25. MÉTODOS DE INTERACCIÓN DEL USUARIO
  // ==========================================================================

  void _showVersePopupMenu(BuildContext context, VerseModel verse) {
    final isFavorite = _isFavorite(verse);
    final isCurrentPlaying = currentPlayingVerseIndex == verses.indexOf(verse);

    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(isFavorite ? Icons.star_outline : Icons.star),
            title: Text(
                isFavorite ? 'Remover de favoritos' : 'Agregar a favoritos'),
            onTap: () {
              _toggleFavorite(verse);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(isCurrentPlaying ? Icons.stop : Icons.volume_up),
            title:
                Text(isCurrentPlaying ? 'Detener lectura' : 'Leer versículo'),
            onTap: () {
              if (isCurrentPlaying) {
                flutterTts.stop();
              } else {
                setState(() => isPlaying = false);
                flutterTts.stop();
                _readVerse(verse);
              }
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  bool _isFavorite(VerseModel verse) {
    return _favoriteVerses.any((f) => f.verse.id == verse.id);
  }

  // ==========================================================================
  // 26. MÉTODOS DE CARGA DE DATOS
  // ==========================================================================

  Future<void> _loadHighlights() async {
    if (userData != null && currentVersion != null && currentChapter != null) {
      final responseHighLighter = await getAllHighLighters(
          userData!.userId, int.parse(currentVersion!.id), currentChapter!.id!);
      if (responseHighLighter.error != null) {
        errorMessage = responseHighLighter.error;
        return;
      }

      if (responseHighLighter.data.isNotEmpty) {
        setState(() {
          _highlights = responseHighLighter.data
              .map<HighlightRangeModel>((h) => HighlightRangeModel(
                  id: h['verse']['id'],
                  verse: h['verse']['verse'],
                  startIndex: h['startIndex'],
                  endIndex: h['endIndex'],
                  color: h['color']))
              .toList();
          for (final verse in verses) {
            verse.highlights?.clear();
            verse.highlights
                ?.addAll(_highlights.where((h) => h.id == verse.id));
          }
        });
      }
    }
  }

  Future<void> _loadPersistedData() async {
    await Provider.of<BibleThemeProvider>(context, listen: false)
        .loadSavedTheme();

    String userId = userData != null ? userData!.userId : '';
    String? chapterId = currentChapter?.id;
    String versionId = currentVersion != null ? currentVersion!.id : "0";

    final responseFavorite =
        await getFavoriteVerseByUser(null, null, versionId, chapterId, userId);
    if (responseFavorite.data != null && responseFavorite.data.isNotEmpty) {
      setState(() {
        _favoriteVerses = responseFavorite.data['data']
            .map<FavoriteVerse>((favorite) => FavoriteVerse.fromJson(favorite))
            .toList();
      });
    }

    final fontSize = await PreferencesManager().getFontSizeVerse();
    setState(() {
      fontSizeVerse = fontSize;
      fontSizeNumber = fontSizeVerse - 4;
    });

    final fontFamily = await PreferencesManager().getFontFamilySet();
    setState(() {
      fontFamilySet = ModelData.fromJson(fontFamily);
    });
  }

  Future<void> loadChapters(BookModel book, bool firstChapter,
      {String? chapterNumber}) async {
    if (!mounted) return;
    setState(() => _screenState = BibleScreenState.loading);

    try {
      final responseChapterByBook = await getChapterWithVerses(book.id);
      if (responseChapterByBook.error != null) {
        setState(() => errorMessage = responseChapterByBook.error);
        return;
      }

      setState(() {
        allChapters = responseChapterByBook.data
            .map<ChapterModel>((chapter) => ChapterModel.fromJson(chapter))
            .toList();
        allChapters.sort((a, b) => a.chapter.compareTo(b.chapter));
      });

      if (!firstChapter) {
        final selectedChapterNumber =
            chapterNumber ?? await PreferencesManager().getChapterSelected();
        if (selectedChapterNumber != null) {
          currentChapter = allChapters.firstWhere(
            (ch) => ch.chapter.toString() == selectedChapterNumber,
          );
        } else {
          currentChapter = allChapters.first;
        }
      } else {
        currentChapter = allChapters.last;
      }

      if (currentChapter != null) {
        setState(() {
          verses = currentChapter!.verses!
              .map<VerseModel>((verse) => VerseModel.fromJson(verse.toJson()))
              .toList();
          verses.sort((a, b) => a.verse.compareTo(b.verse));
        });
      }

      setState(() {
        currentBook = book.copyWith(chapters: allChapters.length - 1);
        _screenState = BibleScreenState.content;
      });
    } catch (e) {
      setState(() {
        _screenState = BibleScreenState.error;
        errorMessage = 'Error al cargar el capítulo $e';
      });
    }
  }

  // ==========================================================================
  // 27. NAVEGACIÓN ENTRE CAPÍTULOS
  // ==========================================================================

  Future<void> _goToPreviousChapter(String chapterNumber) async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() => isPlaying = false);
    }

    setState(() {
      _screenState = BibleScreenState.skeleton;
      scrollToVerseStart = null;
      scrollToVerseEnd = null;
      currentPlayingVerseIndex = null;
      // _isManualScroll = false;
    });

    try {
      if (currentChapter!.chapter > 1) {
        final cacheKey = '${currentVersion!.id}_${currentBook!.id}';
        if (_chaptersCache.containsKey(cacheKey)) {
          final cachedChapter = _chaptersCache[cacheKey]!.firstWhere(
            (c) => c.chapter.toString() == chapterNumber,
          );

          setState(() {
            currentChapter = cachedChapter;
            verses = cachedChapter.verses ?? [];
            _screenState = BibleScreenState.content;
          });
        } else {
          await loadChapters(currentBook!, false, chapterNumber: chapterNumber);
        }

        await PreferencesManager().setChapterSelected(chapterNumber);
      } else if (currentBook!.numberBook > 1) {
        final prevBook = currentVersion!.books
            .firstWhere((b) => b.numberBook == currentBook!.numberBook - 1);

        setState(() => currentBook = prevBook);
        await PreferencesManager().setBookSelected(prevBook.id);
        await loadChapters(prevBook, true);
        await PreferencesManager()
            .setChapterSelected(currentChapter!.chapter.toString());
      }

      await _loadHighlights();
      validateNextAndPrevious();
      _scrollToTop();

      _loadAdditionalDataInBackground();
    } catch (e) {
      setState(() {
        _screenState = BibleScreenState.error;
        errorMessage = 'Error al cambiar de capítulo: ${e.toString()}';
      });
    }
  }

  Future<void> _goToNextChapter(String chapterNumber) async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() => isPlaying = false);
    }

    setState(() {
      _screenState = BibleScreenState.skeleton;
      scrollToVerseStart = null;
      scrollToVerseEnd = null;
      currentPlayingVerseIndex = null;
      // _isManualScroll = false;
    });

    try {
      if (currentChapter!.chapter < currentBook!.chapters) {
        final cacheKey = '${currentVersion!.id}_${currentBook!.id}';
        if (_chaptersCache.containsKey(cacheKey)) {
          final cachedChapter = _chaptersCache[cacheKey]!.firstWhere(
            (c) => c.chapter.toString() == chapterNumber,
          );

          setState(() {
            currentChapter = cachedChapter;
            verses = cachedChapter.verses ?? [];
            _screenState = BibleScreenState.content;
          });
        } else {
          await loadChapters(currentBook!, false, chapterNumber: chapterNumber);
        }

        await PreferencesManager().setChapterSelected(chapterNumber);
      } else if (currentBook!.numberBook < currentVersion!.books.length) {
        final nextBook = currentVersion!.books
            .firstWhere((b) => b.numberBook == currentBook!.numberBook + 1);

        setState(() => currentBook = nextBook);
        await PreferencesManager().setBookSelected(nextBook.id);
        await PreferencesManager().clearOne('chapterSelected');
        await loadChapters(nextBook, false);
      }

      await _loadHighlights();
      validateNextAndPrevious();
      _scrollToTop();

      _loadAdditionalDataInBackground();
    } catch (e) {
      setState(() {
        _screenState = BibleScreenState.error;
        errorMessage = 'Error al cambiar de capítulo: ${e.toString()}';
      });
    }
  }

  // ==========================================================================
  // 28. CACHE DE CAPÍTULOS
  // ==========================================================================

  static final Map<String, List<ChapterModel>> _chaptersCache = {};

  // ==========================================================================
  // 29. MÉTODOS DE UTILIDAD
  // ==========================================================================

  void validateNextAndPrevious() {
    setState(() {
      hasPreviousChapter = !(currentBook != null &&
          currentBook!.numberBook == 1 &&
          (currentChapter != null && currentChapter!.chapter == 1));

      hasNextChapter = !(currentBook != null &&
          currentBook!.numberBook == currentBook!.chapters &&
          currentChapter!.chapter == currentBook!.chapters);
    });
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients && scrollController.offset > 0) {
        scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // ==========================================================================
  // 30. MÉTODOS DE MODALES Y DIÁLOGOS
  // ==========================================================================

  void openModal() {
    _clearSelection();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20),
              constraints: BoxConstraints(
                // maxWidth: 600,
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              decoration: BoxDecoration(
                color: currentTheme.backgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SearchBibleWidget(
                  currentVersion: currentVersion!,
                  currentBook: currentBook!,
                  currentChapter: currentChapter!,
                  onActionBook: (InputDataSearchModel data) async {
                    try {
                      await loadVersionAndChapter(data);
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (kDebugMode) print('Error: $e');
                    }
                  },
                  onActionTabText: (InputDataSearchModel data) async {
                    try {
                      await loadVersionAndChapter(data);
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                  onActionTheme: (InputDataSearchModel data) async {
                    try {
                      await loadVersionAndChapter(data);
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
      },
    );
  }

  Future<void> _showVideoDialog() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.sizeOf(context).height * 0.50,
                maxHeight: MediaQuery.sizeOf(context).height * 0.50,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: BoxConstraints(minHeight: 213),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: (video.url.contains('youtube.com') ||
                                video.url.contains('youtu.be'))
                            ? PlayerYoutubeWidget(videoUrl: video.url)
                            : PlayerNoYoutube(
                                url:
                                    "${GraphQLConfig.urlServidor}${video.url}"),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.7),
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
            ),
          );
        },
      );
    }
  }

  Future<void> _changeBibleVersion() async {
    final bibleVersions = Provider.of<CatalogueProvider>(
      context,
      listen: false,
    )
        .allBibleVersion
        .map(
          (v) => ModelData(value: v.id, label: v.version),
        )
        .toList();

    final selectedVersion = await BibleVersionSelector.show(
      context: context,
      versions: bibleVersions,
      preferenceKey: preferenceKey,
      savedId: lastVersionsSelected,
    );

    if (selectedVersion != null) {
      setState(() => lastVersionsSelected = selectedVersion.value);

      await PreferencesManager().clearOne('bookSelected');
      await PreferencesManager().clearOne('chapterSelected');
      await PreferencesManager().setSelectedBibleVersion(lastVersionsSelected!);

      setState(() {
        _screenState = BibleScreenState.skeleton;
      });

      await _loadBibleVersionAndBook();
      await _loadInitialChapter();
      _loadAdditionalDataInBackground();
    }
  }

  // ==========================================================================
  // 31. MÉTODOS DE ACCIONES DE USUARIO
  // ==========================================================================

  void _showTextFormatModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        Provider.of<BibleThemeProvider>(context, listen: false);

        return ModalTextFormatSizeWidget(
          fontSize: fontSizeVerse,
          selectedItem: fontFamilySet,
          onChangedFontSize: (fontSize) async {
            setState(() {
              fontSizeNumber = fontSize! - 4;
              fontSizeVerse = fontSize;
            });
            await PreferencesManager().setFontSizeVerse(fontSize!);
          },
          onChangedFont: (newFont) async {
            setState(() => fontFamilySet = newFont!);
            await PreferencesManager().setFontFamilySet(newFont!.toJson());
          },
        );
      },
    );
  }

  Future<void> _copyChapter() async {
    final text = await copyChapter(currentVersion, currentBook, currentChapter);
    Clipboard.setData(ClipboardData(text: text));
    _showSnackBar(
      "El capítulo ${currentChapter!.chapter} del libro ${currentBook!.modernName} se ha copiado con éxito al portapapeles",
    );
  }

  Future<void> _shareChapter() async {
    final text = await copyChapter(currentVersion, currentBook, currentChapter);
    await SharePlus.instance.share(ShareParams(
      text: text,
      subject:
          "Palabra de Vida - ${currentChapter!.chapter} ${currentBook!.modernName}",
    ));
  }

  Future<void> _showFavorites() async {
    final versionId = currentVersion != null ? currentVersion!.id : "0";

    try {
      LoadingService().showLoading(context);
      final userId = userData != null ? userData!.userId : '';

      final responseFavorite =
          await getFavoriteVerseByUser(1, 10, versionId, null, userId);

      if (responseFavorite.error != null) {
        LoadingService().hideLoading();
        _showSnackBar(responseFavorite.error!);
        return;
      }

      final listFavorite = responseFavorite.data['data']
          .map<FavoriteVerse>((favorite) => FavoriteVerse.fromJson(favorite))
          .toList();

      final objPagination =
          PaginationInfo.fromJson(responseFavorite.data['meta']);

      LoadingService().hideLoading();
      if (mounted) {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) {
            return DialogFavoriteVerseWidget(
              currentTheme: currentTheme,
              paginationInfo: objPagination,
              versionId: currentVersion!.id,
              favoriteVerses: listFavorite,
              onDeleted: (verseId) {
                final indexToDelete = _favoriteVerses
                    .indexWhere((verse) => verse.verse.id == verseId);
                if (indexToDelete != -1) {
                  setState(() => _favoriteVerses.removeAt(indexToDelete));
                }
              },
            );
          },
        );
      }
    } catch (e) {
      LoadingService().hideLoading();
      _showSnackBar(e.toString());
    }
  }

  // ==========================================================================
  // 32. MÉTODOS DE RESALTADO
  // ==========================================================================

  void _showHighlightColorPicker() {
    // Obtener versículos seleccionados
    final selectedVerses = _getSelectedVerses;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => ColorPickerBottomSheet(
        selectedVerses: selectedVerses,
        onColorSelected: (color) {
          // Convertir color a formato HEX
          final hexColor = color
              .toARGB32()
              .toRadixString(16)
              .padLeft(8, '0')
              .toUpperCase()
              .substring(2);

          // Llamar a tu función existente _addHighlight
          _addHighlight(selectedVerses, hexColor);

          // Limpiar selección
          _clearSelection();

          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _addHighlight(List<VerseModel> listVerses, String color) async {
    final List<HighlightRangeModel> inputHighlight = [];
    for (final verse in listVerses) {
      inputHighlight.add(HighlightRangeModel(
        id: verse.id!,
        verse: verse.verse,
        startIndex: verse.posIni!,
        endIndex: verse.text.length - 1,
        color: color,
      ));
    }

    LoadingService().showLoading(context);
    final responseCreate = await createHighLighters(inputHighlight,
        userData!.userId, int.parse(currentVersion!.id), currentChapter!.id!);

    if (responseCreate.error != null) {
      LoadingService().hideLoading();
      _showSnackBar(responseCreate.userFriendlyError!);
      return;
    }

    LoadingService().hideLoading();
    for (final lighter in inputHighlight) {
      _highlights.add(lighter);
      final index = verses.indexWhere((verse) => verse.id == lighter.id);
      if (index != -1) {
        verses[index].highlights?.add(lighter);
      }
    }
    setState(() {});
  }

  void _showHighlightOptions(
      BuildContext context, HighlightRangeModel highlight) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Resaltado"),
        content: Text("¿Qué deseas hacer con este resaltado?"),
        actions: [
          TextButton(
            child: Text("Eliminar"),
            onPressed: () {
              _removeHighlight(highlight);
              Navigator.pop(ctx);
            },
          ),
          TextButton(
            child: Text("Cancelar"),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  Future<void> _removeHighlight(HighlightRangeModel highlight) async {
    LoadingService().showLoading(context);
    final responseRemove = await removeHighLighters(highlight.id);

    if (responseRemove.error != null) {
      LoadingService().hideLoading();
      _showSnackBar(responseRemove.error!);
      return;
    }

    LoadingService().hideLoading();
    setState(() {
      _highlights.remove(highlight);
      for (final verse in verses) {
        verse.highlights?.removeWhere((h) =>
            h!.id == highlight.id &&
            h.startIndex == highlight.startIndex &&
            h.endIndex == highlight.endIndex);
      }
    });
  }

  Future<void> _toggleFavorite(VerseModel verse) async {
    LoadingService().showLoading(context);
    try {
      if (_favoriteVerses.any((f) => f.verse.id == verse.id)) {
        final responseRemove =
            await deleteVerseFavorite(userData!.userId, verse.id!);
        if (responseRemove.error != null) {
          _showSnackBar(responseRemove.error!);
          LoadingService().hideLoading();
          return;
        }
        setState(() {
          _favoriteVerses.removeAt(
              _favoriteVerses.indexWhere((f) => f.verse.id == verse.id));
        });
      } else {
        final responseAddFavorite =
            await createNewVerseFavoriteByUser(userData!.userId, verse.id!);

        if (responseAddFavorite.error != null) {
          _showSnackBar(responseAddFavorite.error!);
          LoadingService().hideLoading();
          return;
        }

        setState(() {
          _favoriteVerses.add(FavoriteVerse(
              userId: userData!.userId,
              book: currentBook!,
              chapter: currentChapter!,
              verse: verse));
        });
      }
      LoadingService().hideLoading();
    } catch (e) {
      LoadingService().hideLoading();
      _showSnackBar(e.toString());
    }
  }

  // ==========================================================================
  // 33. MÉTODOS DE CARGA DE VERSIÓN ESPECÍFICA
  // ==========================================================================

  Future<void> loadVersionAndChapter(InputDataSearchModel data) async {
    final bibleVersions = Provider.of<CatalogueProvider>(context, listen: false)
        .allBibleVersion
        .map((v) => ModelData(value: v.id, label: v.version))
        .toList();

    setState(() {
      _screenState = BibleScreenState.skeleton;
      lastVersionsSelected = bibleVersions
          .firstWhere((version) => version.value == data.versionId)
          .value;
      final currentVers = Provider.of<CatalogueProvider>(context, listen: false)
          .allBibleVersion
          .firstWhere((version) => version.id == lastVersionsSelected);
      currentVersion = currentVers;
      currentBook =
          currentVers.books.firstWhere((book) => book.id == data.bookId);
    });

    try {
      final responseChapterByBook = await getChapterWithVerses(currentBook!.id);
      if (responseChapterByBook.error != null) {
        setState(() => errorMessage = responseChapterByBook.error);
        return;
      }

      setState(() {
        allChapters = responseChapterByBook.data
            .map<ChapterModel>((chapter) => ChapterModel.fromJson(chapter))
            .toList();
        allChapters.sort((a, b) => a.chapter.compareTo(b.chapter));
        currentChapter =
            allChapters.firstWhere((chapter) => chapter.id == data.chapterId);
        verses = currentChapter!.verses!;
        currentBook = currentBook!.copyWith(chapters: allChapters.length - 1);
      });
// Variables adicionales en tu clase
      int scrollToIndexStart = 0; // Índice en la lista para scroll
      int scrollToIndexEnd = 0; // Índice en la lista para scroll
      if (verses.isNotEmpty) {
        if (kDebugMode) {
          print(scrollToIndexEnd);
        }
        int startIndex = verses.indexWhere((v) => v.id == data.startVerseId);
        int endIndex = verses.indexWhere((v) => v.id == data.endVerseId);
        if (startIndex != -1) {
          // startIndex +=1;
          setState(() {
            scrollToIndexStart = startIndex;
            scrollToIndexEnd = endIndex != -1 ? endIndex : startIndex;
            // Para el resaltado (números de versículos)
            scrollToVerseStart = verses[startIndex].verse;
            scrollToVerseEnd = endIndex != -1
                ? verses[endIndex].verse
                : verses[startIndex].verse;
          });
          _scrollToKeyVerse(scrollToIndexStart);
        }
      }

      await PreferencesManager().setSelectedBibleVersion(lastVersionsSelected!);
      await PreferencesManager().setBookSelected(currentBook!.id);
      await PreferencesManager()
          .setChapterSelected(currentChapter!.chapter.toString());

      setState(() => _screenState = BibleScreenState.content);
      // Cargar datos adicionales en background
      _loadAdditionalDataInBackground();
    } catch (e) {
      setState(() {
        _screenState = BibleScreenState.error;
        errorMessage = 'Error al cargar el capítulo $e';
      });
    }
  }

  // ==========================================================================
  // 34. SCROLL A VERSÍCULO ESPECÍFICO
  // ==========================================================================

  void _scrollToKeyVerse(int startIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _verseKeys[startIndex];
      if (key?.currentContext != null && scrollController.hasClients) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      } else {
        _scrollToVerseFallback(startIndex);
      }
    });
  }

  void _scrollToVerseFallback(int startIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_selectableTextKey.currentContext != null &&
          scrollController.hasClients) {
        try {
          double estimatedHeight = 0.0;
          for (int i = 0; i < startIndex; i++) {
            final verse = verses[i];
            final textLength = "${verse.verse} ${verse.text}".length;
            final lineHeight = fontSizeVerse * 1.5;
            final lines = (textLength / 50).ceil();
            estimatedHeight += lines * lineHeight + 16;
          }
          // estimatedHeight += 40.0;

          await scrollController.animateTo(
            estimatedHeight.clamp(
                0.0, scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
          );
        } catch (error) {
          final itemHeight = 80.0;
          await scrollController.animateTo(
            (startIndex * itemHeight)
                .clamp(0.0, scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  // ==========================================================================
  // 35. CARGA DE VIDEO
  // ==========================================================================

  Future<void> loadVideoByChapter(String id) async {
    final responseVideo = await getVideoByChapter(id);
    if (responseVideo.error != null) {
      if (mounted) {
        await showCustomDialogWithAction(context,
            message: responseVideo.error!,
            dialogType: DialogTypeAction.error,
            buttonOk: "re intentar",
            textButton: "Volver",
            actionCallbackOk: () {},
            actionCallback: () {});
      }
      return;
    }

    setState(() {
      video = Video.fromJson(responseVideo.data);
    });
  }

  // ==========================================================================
  // 36. LECTURA DE CAPÍTULO COMPLETO
  // ==========================================================================

  Future<void> _readFullChapter() async {
    try {
      if (isPlaying) {
        await flutterTts.stop();
        return;
      }

      setState(() => isPlaying = true);

      for (int i = 0; i < verses.length; i++) {
        if (!isPlaying) break;

        setState(() => currentPlayingVerseIndex = i);

        if (_selectableTextKey.currentContext != null &&
            scrollController.hasClients) {
          try {
            final renderBox =
                _selectableTextKey.currentContext!.findRenderObject();
            if (renderBox is RenderBox) {
              final text = verses
                  .sublist(0, i)
                  .map((v) => "${v.verse} ${v.text}")
                  .join(' ');
              final tp = TextPainter(
                text: TextSpan(
                  text: text,
                  style: StylesApp(context).textStyleBody14.copyWith(
                        fontFamily: fontFamilySet.label,
                        fontSize: fontSizeVerse,
                      ),
                ),
                textDirection: TextDirection.ltr,
                maxLines: null,
              );
              tp.layout(maxWidth: renderBox.size.width);
              final offsetY = tp.height - 15;
              await scrollController.animateTo(
                offsetY,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          } catch (_) {
            final itemHeight = 40.0;
            await scrollController.animateTo(
              i * itemHeight,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }

        await flutterTts.speak("${verses[i].text}.");
        await _waitForTtsCompletion();
        if (!isPlaying) break;
      }
    } catch (e) {
      _showSnackBar("Error al leer capítulo: ${e.toString()}");
    } finally {
      setState(() {
        isPlaying = false;
        currentPlayingVerseIndex = null;
      });
    }
  }

  Future<void> _waitForTtsCompletion() async {
    final completer = Completer<void>();
    void onComplete() {
      flutterTts.setCompletionHandler(() {});
      completer.complete();
    }

    flutterTts.setCompletionHandler(onComplete);

    while (isPlaying && !completer.isCompleted) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    await completer.future;
  }

  void _copySelectedVerses() {
    if (getSelectedVerses().isEmpty) {
      _showSnackBar('No hay versículos seleccionados para copiar');
      return;
    }
    final versesToCopy =
        getSelectedVerses().map((v) => "${v.verse} ${v.text}\n").join(' ');
    final reference =
        "${currentVersion?.version}\n${currentBook?.modernName} ${currentChapter?.chapter}:${getSelectedVerses().first.verse}${getSelectedVerses().first != getSelectedVerses().last ? '-' : ''}${getSelectedVerses().first != getSelectedVerses().last ? getSelectedVerses().last.verse : ''}";
    Clipboard.setData(
      ClipboardData(
          text:
              "$reference\n$versesToCopy ${GraphQLConfig.urlServidor}OfficialBible"),
    );
    _showSnackBar('Versículo copiado');
  }

  void _shareSelectedVerses() {
    if (getSelectedVerses().isEmpty) {
      _showSnackBar('No hay versículos seleccionados para copiar');
      return;
    }
    final versesToCopy =
        getSelectedVerses().map((v) => "${v.verse} ${v.text}\n").join(' ');
    final reference =
        "${currentVersion?.version}\n${currentBook?.modernName} ${currentChapter?.chapter}:${getSelectedVerses().first.verse}${getSelectedVerses().first != getSelectedVerses().last ? '-' : ''}${getSelectedVerses().first != getSelectedVerses().last ? getSelectedVerses().last.verse : ''}";
    SharePlus.instance.share(ShareParams(
      text:
          "$reference\n$versesToCopy ${GraphQLConfig.urlServidor}OfficialBible",
      subject: 'Versículo de ${currentBook?.modernName}',
    ));
  }

  bool _isVerseInScrollRange(int verseNumber) {
    if (scrollToVerseStart == null && scrollToVerseEnd == null) {
      return false;
    }

    if (scrollToVerseEnd == null) {
      // Es un solo versículo
      return verseNumber == scrollToVerseStart;
    }

    // Es un rango
    return verseNumber >= scrollToVerseStart! &&
        verseNumber <= scrollToVerseEnd!;
  }
}

// ============================================================================
// FUNCIÓN AUXILIAR EXTERNA
// ============================================================================

List<VerseModel> getVersesInRange(
    List<VerseModel> verses, String startId, String endId) {
  try {
    final start = int.parse(startId);
    final end = int.parse(endId);

    if (start > end) {
      throw ArgumentError('startVerseId no puede ser mayor que endVerseId');
    }

    final result = verses.where((verse) {
      final verseNumber = int.parse(verse.id!);
      return verseNumber >= start && verseNumber <= end;
    }).toList();

    if (result.isEmpty) {
      throw StateError('No se encontraron versículos en el rango $start-$end');
    }

    return result;
  } on FormatException {
    throw FormatException('Los IDs deben ser números válidos');
  }
}

// Crea un gesture recognizer personalizado
class TapAndLongPressRecognizer extends OneSequenceGestureRecognizer {
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  Timer? _longPressTimer;
  bool _longPressHandled = false;
  int? _currentPointer;

  TapAndLongPressRecognizer({
    required this.onTap,
    required this.onLongPress,
  });

  @override
  void addPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);
    _currentPointer = event.pointer;
    _longPressHandled = false;

    // Iniciar timer para long press
    _longPressTimer = Timer(const Duration(milliseconds: 500), () {
      if (_currentPointer == event.pointer && !_longPressHandled) {
        _longPressHandled = true;
        onLongPress();
        stopTrackingPointer(event.pointer);
      }
    });
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerUpEvent && !_longPressHandled) {
      _longPressTimer?.cancel();
      onTap();
      stopTrackingPointer(event.pointer);
    } else if (event is PointerCancelEvent) {
      _longPressTimer?.cancel();
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  void rejectGesture(int pointer) {
    _longPressTimer?.cancel();
    stopTrackingPointer(pointer);
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  @override
  String get debugDescription => 'tap and long press recognizer';

  @override
  void didStopTrackingLastPointer(int pointer) {
    // No action needed
  }
}
