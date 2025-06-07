import 'dart:convert';

import 'package:biblia_palabra_de_vida_app/class/bible_version_selector.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/catalogue_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BibleScreen extends StatefulWidget {
  const BibleScreen({super.key});

  @override
  State<BibleScreen> createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen> {
  final ScrollController scrollController = ScrollController();
  SharedPreferences? prefs;

  String? errorMessage;
  bool isLoading = true;
  VersionModel? currentVersion;
  BookModel? currentBook;
  ChapterModel? currentChapter;
  List<VerseModel> verses = [];
  String? lastVersionsSelected;
  bool versionConSaltos = true;
  Color? selectedColor;
  String preferenceKey = 'selectedBibleVersion';

  List<String> _favoriteVerses = [];
  List<String> _highlightedVerses = [];

  // Nuevas variables para manejar selección de texto
  TextSelection _currentSelection = TextSelection.collapsed(offset: -1);
  String _selectedText = '';
  Offset _selectionPopupPosition = Offset.zero;
  bool _showSelectionMenu = false;
  // GlobalKey _verseTextKey = GlobalKey();
  final Map<String, GlobalKey> _verseTextKeys = {};

  // Estructura para guardar resaltados parciales
  // Formato: {'verseId': {'start': int, 'end': int, 'color': Color}}
  Map<String, dynamic> _partialHighlights = {};

  @override
  void initState() {
    super.initState();
    _loadPersistedData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initDataLoad();
      _loadPersistedData();
      _loadPartialHighlights();
    });
  }

// Método para obtener o crear una clave para un versículo
  GlobalKey _getVerseKey(String verseId) {
    if (!_verseTextKeys.containsKey(verseId)) {
      _verseTextKeys[verseId] = GlobalKey();
    }
    return _verseTextKeys[verseId]!;
  }

  Future<void> _loadPartialHighlights() async {
    final prefs = await SharedPreferences.getInstance();
    final highlightsJson = prefs.getString('partialHighlights');
    if (highlightsJson != null) {
      setState(() {
        _partialHighlights =
            Map<String, dynamic>.from(json.decode(highlightsJson));
      });
    }
  }

  Future<void> _savePartialHighlights() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('partialHighlights', json.encode(_partialHighlights));
  }

  Future<void> _loadPersistedData() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteVerses = prefs.getStringList('favoriteVerses') ?? [];
    _highlightedVerses = prefs.getStringList('highlightedVerses') ?? [];
    if (mounted) setState(() {});
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteVerses', _favoriteVerses);
  }

  Future<void> _saveHighlights() async {
    // llamar al servicio de resaltado
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('highlightedVerses', _highlightedVerses);
  }

  Future<void> _initDataLoad() async {
    prefs = await SharedPreferences.getInstance();
    lastVersionsSelected =
        prefs!.getString(preferenceKey); //  cargo la version almacena en cache
    final loadBook =
        prefs!.getString('bookSelected'); // cargo el libro almacenado en cache

    // si hay version en cache
    setState(() {
      if (lastVersionsSelected != null) {
        // busco esa version
        currentVersion = Provider.of<CatalogueProvider>(context, listen: false)
            .allBibleVersion
            .firstWhere((version) => version.id == lastVersionsSelected);

        if (loadBook != null) {
          currentBook =
              currentVersion!.books.firstWhere((book) => book.id == loadBook);
          // cargamos el capitulo correspondiente
        } else {
          currentBook = currentVersion!.books[0];
        }
      } else {
        currentVersion = Provider.of<CatalogueProvider>(context, listen: false)
            .allBibleVersion[0];
        currentBook = currentVersion!.books[0];
      }
      currentBook = currentBook!.copyWith(
        chapters: currentVersion!.books.length, // Usamos el mapa de capítulos
      );
    });

    _loadChapterByBook(currentVersion, currentBook, null, context);
  }

  Future<void> _loadChapterByBook(
      version, book, chapterId, BuildContext context) async {
    setState(() {
      errorMessage = null;
    });
    LoadingService().showLoading(context);
    try {
      if (chapterId == null) {
        // consultamos un capitulo si chapter es null
        final responseChapterByBook =
            await getChapterWithVerses(currentBook!.id);
        if (responseChapterByBook.error != null) {
          setState(() {
            errorMessage = responseChapterByBook.error;
          });
        }

        chapterId = responseChapterByBook.data[0]!['id'];
      }
      final responseChapter = await getOneChapterWithVerses(chapterId);
      if (responseChapter.error != null) {
        errorMessage = responseChapter.error;
      }
      setState(() {
        currentChapter = ChapterModel.fromJson(responseChapter.data);

        verses = currentChapter!.verses
            .map<VerseModel>((verse) => VerseModel.fromJson(verse.toJson()))
            .toList();
      });

// actualizamos la cache
      prefs!.setString(preferenceKey, version.id);
      prefs!.setString('bookSelected', book!.id);
      prefs!.setString('chapterSelected', chapterId);
    } catch (e) {
      errorMessage = 'Error cargar un capitulo $e';
      setState(() {
        isLoading = false;
      });
    } finally {
      LoadingService().hideLoading();
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _goToPreviousChapter() async {
    if (currentChapter!.chapter > 1) {
      await _loadChapterByBook(currentVersion, currentBook,
          '${currentBook!.id}_${currentChapter!.chapter - 1}', context);
    } else if (currentBook!.numberBook > 1) {
      // Ir al último capítulo del libro anterior
      final prevBook = currentVersion!.books
          .firstWhere((b) => b.numberBook == currentBook!.numberBook - 1);
      await _loadChapterByBook(currentVersion, prevBook,
          '${prevBook.id}_${prevBook.chapters}', context);
    }
  }

  Future<void> _goToNextChapter() async {
    if (currentChapter!.chapter < currentBook!.chapters) {
      await _loadChapterByBook(currentVersion, currentBook,
          '${currentBook!.id}_${currentChapter!.chapter + 1}', context);
    } else if (currentBook!.numberBook < currentVersion!.books.length) {
      // Ir al primer capítulo del siguiente libro
      final nextBook = currentVersion!.books
          .firstWhere((b) => b.numberBook == currentBook!.numberBook + 1);
      await _loadChapterByBook(
          currentVersion, nextBook, '${nextBook.id}_1', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentBook != null) {
      print('${currentBook!.chapters}');
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                if (isLoading) ...{
                  Container()
                } else ...{
                  if (errorMessage != null) ...{
                    BuildErrorWidget(
                      errorMessage: errorMessage!,
                      onRetry: () async => _loadChapterByBook(
                          currentVersion, currentBook, currentChapter, context),
                      onBack: () => Navigator.pop(context),
                    )
                  } else ...{
                    BibleHeaderWidget(
                      versionName:
                          currentVersion != null ? currentVersion!.version : '',
                      title: currentBook != null ? currentBook!.modernName : '',
                      chapter: currentChapter != null
                          ? '${currentChapter!.chapter}'
                          : '',
                      onAudioTap: () {},
                      onBack: () {
                        Navigator.pop(context);
                      },
                      onVersionTap: () async {
                        final bibleVersions = Provider.of<CatalogueProvider>(
                                context,
                                listen: false)
                            .allBibleVersion
                            .map(
                                (v) => ModelData(value: v.id, label: v.version))
                            .toList();

                        final selectedVersion = await BibleVersionSelector.show(
                            context: context,
                            versions: bibleVersions,
                            preferenceKey: preferenceKey,
                            savedId: lastVersionsSelected);

                        if (selectedVersion != null) {
                          // Aquí manejas la versión seleccionada
                          print(
                              'Versión seleccionada: ${selectedVersion.label}');
                          setState(() {
                            lastVersionsSelected = selectedVersion
                                .value; // actualizo la version de la biblia

                            // removemos los datos de la cache para iniciar de nuevo
                            prefs!.remove('bookSelected');
                            prefs!.remove('chapterSelected');
                          });
                          prefs!
                              .setString(preferenceKey, lastVersionsSelected!);
                          _initDataLoad();
                        }
                      },
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: Stack(
                          children: [
                            // body
                            Scrollbar(
                              controller: scrollController,
                              thumbVisibility: true,
                              thickness: 6.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          controller: scrollController,
                                          itemCount: verses.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final verse = verses[index];
                                            final isFavorite = _favoriteVerses
                                                .contains(verse.id);
                                            final isHighlighted =
                                                _highlightedVerses
                                                    .contains(verse.id);

                                            return index == 0
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 42.0),
                                                      _buildVerseText(
                                                          context,
                                                          verse,
                                                          isFavorite,
                                                          isHighlighted,
                                                          index),
                                                    ],
                                                  )
                                                : _buildVerseText(
                                                    context,
                                                    verse,
                                                    isFavorite,
                                                    isHighlighted,
                                                    index);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white),
                                // width: MediaQuery.sizeOf(context).width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        padding: EdgeInsets.zero,
                                        iconSize: 25.0,
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return modalTextFormatSizeWidget();
                                              });
                                        },
                                        icon: Icon(
                                          CupertinoIcons.textformat_size,
                                          color: StyleColor.turquoise,
                                        )),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 25.0,
                                      onPressed: () async {
                                        Clipboard.setData(ClipboardData(
                                            text: await copyChapter(
                                                currentChapter)));
                                        await showCustomDialog(
                                          context,
                                          message:
                                              "El capitulo ${currentChapter!.chapter} del libro ${currentBook!.modernName}  \n se ha copiado con éxito al\n portapapeles",
                                          dialogType: DialogType.info,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.file_copy_rounded,
                                        color: StyleColor.turquoise,
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 25.0,
                                      onPressed: () async {
                                        await Share.share(
                                          await copyChapter(currentChapter),
                                          subject:
                                              "Palabra de Vida - ${currentChapter!.chapter} ${currentBook!.modernName}",
                                        );
                                      },
                                      icon: Icon(
                                        Icons.share_rounded,
                                        color: StyleColor.turquoise,
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 25.0,
                                      onPressed: () {
                                        showModalBottomSheet(
                                          isDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SearchBibleWidget();
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.search_rounded,
                                        color: StyleColor.turquoise,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 7.0),
                                width: MediaQuery.sizeOf(context).width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: StyleColor.turquoise,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Center(
                                        child: IconButton(
                                          padding: EdgeInsets.all(0),
                                          alignment: Alignment.center,
                                          iconSize: 35,
                                          color: StyleColor.turquoise,
                                          onPressed: currentBook != null &&
                                                  currentBook!.numberBook ==
                                                      1 &&
                                                  (currentChapter != null &&
                                                      currentChapter!.chapter ==
                                                          1)
                                              ? null
                                              : () {
                                                  // Lógica para ir al capítulo anterior
                                                  _goToPreviousChapter();
                                                },
                                          icon: Icon(
                                            Icons.keyboard_arrow_left_rounded,
                                            size: 35,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          color: StyleColor.turquoise,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Center(
                                        child: IconButton(
                                          padding: EdgeInsets.all(0),
                                          alignment: Alignment.center,
                                          iconSize: 35,
                                          onPressed: currentBook != null &&
                                                  currentBook!.numberBook ==
                                                      currentBook!.chapters &&
                                                  currentChapter!.chapter ==
                                                      currentBook!.chapters
                                              ? null
                                              : () {
                                                  // Lógica para ir al siguiente capítulo
                                                  _goToNextChapter();
                                                },
                                          icon: Icon(
                                            Icons.keyboard_arrow_right_rounded,
                                            size: 35,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  }
                }
              ],
            ),
            // Menú de selección de texto
            if (_showSelectionMenu)
              Positioned(
                left: _selectionPopupPosition.dx,
                top: _selectionPopupPosition.dy,
                child: _buildSelectionMenu(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerseText(BuildContext context, VerseModel verse,
      bool isFavorite, bool isHighlighted, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          SelectableRegion(
            key: _getVerseKey(verse.id),
            selectionControls: _BibleTextSelectionControls(
              onSelectionChanged: (selection, _) =>
                  _handleTextSelectionChanged(selection, verse),
              verse: verse,
            ),
            focusNode: FocusNode(),
            child: RichText(
              text: TextSpan(
                style: StylesApp(context).textStyleBodyRoboto20.copyWith(
                      color: isHighlighted ? selectedColor : Colors.black,
                      backgroundColor:
                          isFavorite ? Colors.pink.withOpacity(0.1) : null,
                    ),
                children: [
                  TextSpan(
                    text: "${verse.verse} ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ..._buildHighlightedTextSpans(verse.text, verse.id),
                ],
              ),
            ),
          ),
          // Capa táctil para limpiar selección
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  _showSelectionMenu = false;
                  _currentSelection = TextSelection.collapsed(offset: -1);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildHighlightedTextSpans(String text, String verseId) {
    final spans = <TextSpan>[];
    final highlights = _partialHighlights[verseId] ?? [];
    int currentPosition = 0;

    // Ordenar resaltados por posición de inicio
    if (highlights.length > 0) {
      highlights.sort((a, b) => a['start'].compareTo(b['start']));
    }

    for (final highlight in highlights) {
      final start = highlight['start'];
      final end = highlight['end'];
      final color = Color(highlight['color']);

      // Texto antes del resaltado
      if (currentPosition < start) {
        spans.add(TextSpan(
          text: text.substring(currentPosition, start),
          style: const TextStyle(fontWeight: FontWeight.normal),
        ));
      }

      // Texto resaltado
      spans.add(TextSpan(
        text: text.substring(start, end),
        style: TextStyle(
          fontWeight: FontWeight.normal,
          backgroundColor: color.withOpacity(0.3),
          color: Colors.black,
        ),
      ));

      currentPosition = end;
    }

    // Texto después del último resaltado
    if (currentPosition < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentPosition),
        style: const TextStyle(fontWeight: FontWeight.normal),
      ));
    }

    return spans;
  }

  void _handleTextSelectionChanged(TextSelection selection, VerseModel verse) {
  if (selection.isCollapsed || selection.baseOffset == selection.extentOffset) {
    setState(() => _showSelectionMenu = false);
    return;
  }

  final renderKey = _getVerseKey(verse.id);
  final renderBox = renderKey.currentContext?.findRenderObject() as RenderBox?;
  
  if (renderBox == null) return;

  try {
    // Use the widget's position as a base for the popup
    final boxPosition = renderBox.localToGlobal(Offset.zero);

    setState(() {
      _currentSelection = selection;
      _selectedText = verse.text.substring(
        selection.start.clamp(0, verse.text.length),
        selection.end.clamp(0, verse.text.length),
      );
      // Place the popup above the verse widget
      _selectionPopupPosition = Offset(
        boxPosition.dx + renderBox.size.width / 2,
        boxPosition.dy - 50,
      );
      _showSelectionMenu = true;
    });
  } catch (e) {
    debugPrint('Error calculando posición: $e');
  }
}

  Widget _buildSelectionMenu() {
    final verseId = (_currentSelection as BibleTextSelection?)?.verse?.id;
    final isHighlighted = verseId != null &&
        _partialHighlights.containsKey(verseId) &&
        _isSelectionHighlighted();

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isHighlighted) ...[
                _buildSelectionMenuItem(
                  icon: Icons.copy,
                  label: 'Copiar',
                  onTap: _copySelectedText,
                ),
                _buildSelectionMenuItem(
                  icon: Icons.share,
                  label: 'Compartir',
                  onTap: _shareSelectedText,
                ),
                _buildSelectionMenuItem(
                  icon: Icons.highlight,
                  label: 'Resaltar',
                  onTap: _highlightSelectedText,
                ),
              ] else ...[
                _buildSelectionMenuItem(
                  icon: Icons.copy,
                  label: 'Copiar',
                  onTap: _copySelectedText,
                ),
                _buildSelectionMenuItem(
                  icon: Icons.share,
                  label: 'Compartir',
                  onTap: _shareSelectedText,
                ),
                _buildSelectionMenuItem(
                  icon: Icons.highlight_off,
                  label: 'Quitar resaltado',
                  onTap: _removeHighlight,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: () {
        onTap();
        setState(() => _showSelectionMenu = false);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: iconColor ?? Colors.grey[700]),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  bool _isSelectionHighlighted() {
    final selection = _currentSelection as BibleTextSelection?;
    if (selection == null || selection.verse == null) return false;

    final verseId = selection.verse!.id;
    final highlights = _partialHighlights[verseId] ?? [];

    for (final highlight in highlights) {
      if (selection.start >= highlight['start'] &&
          selection.end <= highlight['end']) {
        return true;
      }
    }
    return false;
  }

  void _copySelectedText() {
    if (_selectedText.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _selectedText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Texto copiado al portapapeles')),
    );
    setState(() => _showSelectionMenu = false);
  }

  void _shareSelectedText() {
    if (_selectedText.isEmpty) return;
    Share.share(_selectedText);
    setState(() => _showSelectionMenu = false);
  }

  void _highlightSelectedText() async {
    final selection = _currentSelection as BibleTextSelection?;
    if (selection == null || selection.verse == null) return;

    final color = await ColorPickerDialog.show(context);
    if (color == null) return;

    final verseId = selection.verse!.id;
    final newHighlight = {
      'start': selection.start,
      'end': selection.end,
      'color': color.value,
    };

    setState(() {
      if (!_partialHighlights.containsKey(verseId)) {
        _partialHighlights[verseId] = [];
      }
      _partialHighlights[verseId].add(newHighlight);
      _showSelectionMenu = false;
    });

    await _savePartialHighlights();
  }

  void _removeHighlight() {
    final selection = _currentSelection as BibleTextSelection?;
    if (selection == null || selection.verse == null) return;

    final verseId = selection.verse!.id;
    if (!_partialHighlights.containsKey(verseId)) return;

    setState(() {
      _partialHighlights[verseId] = _partialHighlights[verseId]
          .where((highlight) => !(selection.start >= highlight['start'] &&
              selection.end <= highlight['end']))
          .toList();

      if (_partialHighlights[verseId].isEmpty) {
        _partialHighlights.remove(verseId);
      }

      _showSelectionMenu = false;
    });

    _savePartialHighlights();
  }

// Compartir versículo
  void _shareVerse(VerseModel verse) async {
    final text =
        '${verse.verse} ${verse.text} (${currentBook!.modernName} ${currentChapter!.chapter}:${verse.verse})';
    await Share.share(text);
  }

// Manejar favoritos
  void _toggleFavorite(VerseModel verse) async {
    setState(() {
      if (_favoriteVerses.contains(verse.id)) {
        _favoriteVerses.remove(verse.id);
      } else {
        _favoriteVerses.add(verse.id);
      }
    });
    await _saveFavorites();
  }

// Resaltar versículo
  void _toggleHighlight(VerseModel verse) async {
    setState(() {
      if (_highlightedVerses.contains(verse.id)) {
        _highlightedVerses.remove(verse.id);
      } else {
        _highlightedVerses.add(verse.id);
      }
    });
    await _saveHighlights();
  }

// Copiar versículo
  void _copyVerse(VerseModel verse) async {
    final text =
        '${verse.verse} ${verse.text} (${currentBook!.modernName} ${currentChapter!.chapter}:${verse.verse})';
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Versículo copiado al portapapeles')),
    );
  }
}

class BibleTextSelection extends TextSelection {
  final VerseModel? verse;

  BibleTextSelection({
    required super.baseOffset,
    required super.extentOffset,
    this.verse,
    super.affinity = TextAffinity.downstream,
    super.isDirectional = false,
  });

  @override
  BibleTextSelection copyWith({
    int? baseOffset,
    int? extentOffset,
    TextAffinity? affinity,
    bool? isDirectional,
    VerseModel? verse,
  }) {
    return BibleTextSelection(
      baseOffset: baseOffset ?? this.baseOffset,
      extentOffset: extentOffset ?? this.extentOffset,
      affinity: affinity ?? this.affinity,
      isDirectional: isDirectional ?? this.isDirectional,
      verse: verse ?? this.verse,
    );
  }
}

class _BibleTextSelectionControls extends TextSelectionControls {
  final void Function(TextSelection selection, VerseModel verse)
      onSelectionChanged;
  final VerseModel verse;

  _BibleTextSelectionControls({
    required this.onSelectionChanged,
    required this.verse,
  });

  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset position,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate, [
    ValueListenable<ClipboardStatus>? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ]) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
    double? startGlyphHeight,
    double? endGlyphHeight,
  ]) {
    return const SizedBox.shrink();
  }

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    return Offset.zero;
  }

  @override
  Size getHandleSize(double textLineHeight) {
    return Size.zero;
  }

  @override
  Future<void> handleCopy(TextSelectionDelegate delegate) async {
    // No implementado - usamos nuestro propio manejo
    return super.handleCopy(delegate);
  }

  @override
  void handleSelectionChanged(
    TextEditingValue value,
    RenderEditable renderObject,
    SelectionChangedCause? cause,
  ) {
    if (cause == SelectionChangedCause.longPress ||
        cause == SelectionChangedCause.drag) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onSelectionChanged(value.selection, verse);
      });
    }
  }
}

class ColorPickerDialog {
  static final List<Color> colorPalette = [
    const Color(0xFFFFD700), // Amarillo
    const Color(0xFFFFA07A), // Salmón claro
    const Color(0xFF98FB98), // Verde menta
    const Color(0xFFADD8E6), // Azul claro
    const Color(0xFFFFC0CB), // Rosa
    const Color(0xFFFFFF00), // Amarillo puro
    const Color(0xFF90EE90), // Verde claro
    const Color(0xFF87CEFA), // Azul cielo
  ];

  static Future<Color?> show(BuildContext context) {
    return showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar color para resaltar'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: colorPalette.map((color) {
                    return GestureDetector(
                      onTap: () => Navigator.pop(context, color),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
