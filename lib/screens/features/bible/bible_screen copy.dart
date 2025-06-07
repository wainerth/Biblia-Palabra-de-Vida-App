import 'package:biblia_palabra_de_vida_app/class/bible_version_selector.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/catalogue_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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

  int? _selectedVerseIndex;
  final List<VerseModel> _selectedVerses = [];
  List<String> _favoriteVerses = [];
  List<String> _highlightedVerses = [];


  bool _multiSelectMode = false;
  List<int> _selectedVerseIndices = [];

  @override
  void initState() {
    super.initState();
    _loadPersistedData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initDataLoad();
    });
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
        child: Column(
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
                        .map((v) => ModelData(value: v.id, label: v.version))
                        .toList();

                    final selectedVersion = await BibleVersionSelector.show(
                        context: context,
                        versions: bibleVersions,
                        preferenceKey: preferenceKey,
                        savedId: lastVersionsSelected);

                    if (selectedVersion != null) {
                      // Aquí manejas la versión seleccionada
                      print('Versión seleccionada: ${selectedVersion.label}');
                      setState(() {
                        lastVersionsSelected = selectedVersion
                            .value; // actualizo la version de la biblia

                        // removemos los datos de la cache para iniciar de nuevo
                        prefs!.remove('bookSelected');
                        prefs!.remove('chapterSelected');
                      });
                      prefs!.setString(preferenceKey, lastVersionsSelected!);
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (versionConSaltos) ...{
                                    Expanded(
                                      child: ListView.builder(
                                        controller: scrollController,
                                        itemCount: verses.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final verse = verses[index];
                                          final isFavorite = _favoriteVerses
                                              .contains(verse.id);
                                          final isHighlighted =
                                              _highlightedVerses
                                                  .contains(verse.id);

                                          return index == 0
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                  } else ...{
                                    Expanded(
                                      child: GestureDetector(
                                        onLongPress: () {
                                          if (_selectedVerseIndex != null) {
                                            _showVerseOptions(
                                                context,
                                                selectedColor != null
                                                    ? selectedColor!
                                                    : StyleColor.turquoise,
                                                verses[_selectedVerseIndex!]);
                                          }
                                        },
                                        child: ListView(
                                          controller: scrollController,
                                          children: [
                                            const SizedBox(
                                                height:
                                                    42.0), // Espacio inicial
                                            RichText(
                                              text: TextSpan(
                                                style: StylesApp(context)
                                                    .textStyleBodyRoboto20
                                                    .copyWith(
                                                      color: Colors.black,
                                                    ),
                                                children: _buildAllVersesText(
                                                    context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  },
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
                                        text:
                                            await copyChapter(currentChapter)));
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      color: StyleColor.turquoise,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: IconButton(
                                      padding: EdgeInsets.all(0),
                                      alignment: Alignment.center,
                                      iconSize: 35,
                                      color: StyleColor.turquoise,
                                      onPressed: currentBook != null &&
                                              currentBook!.numberBook == 1 &&
                                              (currentChapter != null &&
                                                  currentChapter!.chapter == 1)
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
                                      borderRadius: BorderRadius.circular(8)),
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
      ),
    );
  }
// List<TextSpan> _buildAllVersesText(BuildContext context) {
//   List<TextSpan> spans = [];

//   for (int i = 0; i < verses.length; i++) {
//     final verse = verses[i];
//     final isFavorite = _favoriteVerses.contains(verse.id);
//     final isHighlighted = _highlightedVerses.contains(verse.id);

//     // Estilo para el número del versículo
//     spans.add(TextSpan(
//       text: " ${verse.verse} ",
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         color: isHighlighted ? Colors.yellow : Colors.black,
//         backgroundColor: isFavorite ? Colors.pink.withOpacity(0.1) : null,
//       ),
//     ));

//     // Texto del versículo con punto al final (excepto el último)
//     spans.add(TextSpan(
//       text: "${verse.text}${i < verses.length - 1 ? '. ' : ''}",
//       style: TextStyle(
//         fontWeight: FontWeight.normal,
//         color: isHighlighted ? Colors.yellow : Colors.black,
//         backgroundColor: isFavorite ? Colors.pink.withOpacity(0.1) : null,
//       ),
//     ));
//   }

//   return spans;
// }
  void _showColorPickerDialog(BuildContext context, VerseModel verse) {
    final List<Color> colorPalette = [
      const Color(0xFFEE5A24),
      const Color(0xFFF79F1F),
      const Color(0xFFFFC312),
      const Color(0xFFFFD55F),
      const Color(0xFFC4E538),
      const Color(0xFFA3CB38),
      const Color(0xFF009432),
      const Color(0xFF006266),
      const Color(0xFF12CBC4),
      const Color(0xFF1289A7),
      const Color(0xFF0652DD),
      const Color(0xFF1B1464),
      const Color(0xFF5758BB),
      const Color(0xFF9980FA),
      const Color(0xFFD980FA),
      const Color(0xFFFDA7DF),
      const Color(0xFF833471),
      const Color(0xFFB53471),
      const Color(0xFF6F1E51),
      const Color(0xFFED4C67),
      const Color(0xFFEA2027),
    ];

    showDialog(
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
                      onTap: () {
                        Navigator.pop(context);
                      },
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

  Widget _buildVerseText(BuildContext context, VerseModel verse,
      bool isFavorite, bool isHighlighted, int index) {
    final isSelected =
        _multiSelectMode && _selectedVerseIndices.contains(index);

    return GestureDetector(
      onLongPress: () {
        setState(() {
          _multiSelectMode = true;
          _selectedVerseIndices.add(index);
          _showMultiSelectToolbar();
        });
      },
      onTap: () {
        if (_multiSelectMode) {
          setState(() {
            if (_selectedVerseIndices.contains(index)) {
              _selectedVerseIndices.remove(index);
              if (_selectedVerseIndices.isEmpty) {
                _multiSelectMode = false;
              }
            } else {
              _selectedVerseIndices.add(index);
            }
          });
        } else {
          // Tu lógica normal de tap aquí
          if (_selectedVerseIndex == index) {
            setState(() {
              _selectedVerseIndex = null;
              _selectedVerses.clear();
            });
          } else {
            setState(() {
              _selectedVerseIndex = index;
              _selectedVerses.clear();
              _selectedVerses.add(verse);
            });
          }
        }
      },
      child: Container(
        color: isSelected
            ? Colors.blue.withOpacity(0.3)
            : (_selectedVerseIndex == index
                ? Colors.blue.withOpacity(0.2)
                : Colors.transparent),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Text.rich(
          TextSpan(
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
              TextSpan(
                text: verse.text,
                style: const TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMultiSelectToolbar() {
    // verificar si el contexto todavìa esta montado
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = Overlay.of(context);
      if (overlay == null) return; // Si no hay overlay, salir

      OverlayEntry? overlayEntry;
      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Material(
            elevation: 4,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.copy, color: Colors.blue),
                    onPressed: _copySelectedVerses,
                  ),
                  IconButton(
                    icon: Icon(Icons.share, color: Colors.blue),
                    onPressed: _shareSelectedVerses,
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: _addToFavoritesSelected,
                  ),
                  IconButton(
                    icon: Icon(
                      _selectedVerseIndices.any(
                              (i) => _highlightedVerses.contains(verses[i].id))
                          ? Icons.highlight_remove
                          : Icons.highlight,
                      color: Colors.amber,
                    ),
                    tooltip: _selectedVerseIndices.any(
                            (i) => _highlightedVerses.contains(verses[i].id))
                        ? 'Quitar resaltado'
                        : 'Resaltar',
                    onPressed: _highlightSelectedVerses,
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _multiSelectMode = false;
                        _selectedVerseIndices.clear();
                      });
                      overlayEntry?.remove();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      overlay.insert(overlayEntry);

      // Simplemente remover el overlay después de 5 segundos si no hay interacción
      Future.delayed(Duration(seconds: 5), () {
        if (_multiSelectMode && overlayEntry!.mounted) {
          overlayEntry.remove();
          setState(() {
            _multiSelectMode = false;
            _selectedVerseIndices.clear();
          });
        }
      });
    });
  }

  Stream<bool> _multiSelectModeStream() async* {
    while (_multiSelectMode) {
      await Future.delayed(Duration(milliseconds: 100));
      yield _multiSelectMode;
    }
    yield false;
  }

// Métodos para las acciones del toolbar
  void _copySelectedVerses() async {
    final selectedVerses = _selectedVerseIndices.map((i) => verses[i]).toList();
    final text = selectedVerses.map((v) => '${v.verse} ${v.text}').join('\n');

    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Versículos copiados al portapapeles')),
    );

    setState(() {
      _multiSelectMode = false;
      _selectedVerseIndices.clear();
    });
  }

  void _shareSelectedVerses() async {
    final selectedVerses = _selectedVerseIndices.map((i) => verses[i]).toList();
    final text = selectedVerses.map((v) => '${v.verse} ${v.text}').join('\n');

    await Share.share(text);

    setState(() {
      _multiSelectMode = false;
      _selectedVerseIndices.clear();
    });
  }

  void _addToFavoritesSelected() async {
    final selectedVerses = _selectedVerseIndices.map((i) => verses[i]).toList();

    setState(() {
      for (final verse in selectedVerses) {
        if (!_favoriteVerses.contains(verse.id)) {
          _favoriteVerses.add(verse.id);
        }
      }
      _multiSelectMode = false;
      _selectedVerseIndices.clear();
    });

    await _saveFavorites();
  }

  void _highlightSelectedVerses() async {
   
    final selectedVerses = _selectedVerseIndices.map((i) => verses[i]).toList();

    setState(() {
      for (final verse in selectedVerses) {
        if (!_highlightedVerses.contains(verse.id)) {
          // Para mostrar el diálogo y obtener el color seleccionado:
          _highlightedVerses.add(verse.id);
        } else {
          _highlightedVerses.remove(verse.id);
        }
      }
      _multiSelectMode = false;
      _selectedVerseIndices.clear();
    });

    await _saveHighlights();
  }

  void _showVerseOptions(
      BuildContext context, Color selectedColor, VerseModel verse) {
    final isFavorite = _favoriteVerses.contains(verse.id);
    final isHighlighted = _highlightedVerses.contains(verse.id);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Compartir versículo'),
                onTap: () {
                  Navigator.pop(context);
                  _shareVerse(verse);
                },
              ),
              ListTile(
                leading: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                title: Text(
                    isFavorite ? 'Quitar de favoritos' : 'Añadir a favoritos'),
                onTap: () {
                  Navigator.pop(context);
                  _toggleFavorite(verse);
                },
              ),
              ListTile(
                leading: Icon(
                  isHighlighted ? Icons.highlight : Icons.highlight_alt,
                  color: selectedColor,
                ),
                title: Text(
                    isHighlighted ? 'Quitar resaltado' : 'Resaltar versículo'),
                onTap: () {
                  Navigator.pop(context);
                  _toggleHighlight(verse);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copiar versículo'),
                onTap: () {
                  Navigator.pop(context);
                  _copyVerse(verse);
                },
              ),
            ],
          ),
        );
      },
    );
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

  List<TextSpan> _buildAllVersesText(BuildContext context) {
    List<TextSpan> spans = [];

    for (int i = 0; i < verses.length; i++) {
      final verse = verses[i];
      final isFavorite = _favoriteVerses.contains(verse.id);
      final isHighlighted = _highlightedVerses.contains(verse.id);
      final isSelected = _selectedVerseIndex == i;

      spans.add(TextSpan(
        text: " ${verse.verse} ",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isHighlighted ? selectedColor : Colors.black,
          backgroundColor: isSelected
              ? Colors.blue.withOpacity(0.2)
              : isFavorite
                  ? Colors.pink.withOpacity(0.1)
                  : null,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () => _handleVerseTap(i, verse),
      ));

      spans.add(TextSpan(
        text: "${verse.text}${i < verses.length - 1 ? '. ' : ''}",
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: isHighlighted ? Colors.yellow : Colors.black,
          backgroundColor: isSelected
              ? Colors.blue.withOpacity(0.2)
              : isFavorite
                  ? Colors.pink.withOpacity(0.1)
                  : null,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () => _handleVerseTap(i, verse),
      ));
    }

    return spans;
  }

  void _handleVerseTap(int index, VerseModel verse) {
    setState(() {
      if (_selectedVerseIndex == index) {
        _selectedVerseIndex = null;
        _selectedVerses.clear();
      } else {
        _selectedVerseIndex = index;
        _selectedVerses.clear();
        _selectedVerses.add(verse);
      }
    });
  }
}

class ColorPickerDialog extends StatelessWidget {
  final ValueChanged<Color> onColorSelected;

  const ColorPickerDialog({super.key, required this.onColorSelected});

  static final List<Color> colorPalette = [
    const Color(0xFFEE5A24),
    const Color(0xFFF79F1F),
    const Color(0xFFFFC312),
    const Color(0xFFFFD55F),
    const Color(0xFFC4E538),
    const Color(0xFFA3CB38),
    const Color(0xFF009432),
    const Color(0xFF006266),
    const Color(0xFF12CBC4),
    const Color(0xFF1289A7),
    const Color(0xFF0652DD),
    const Color(0xFF1B1464),
    const Color(0xFF5758BB),
    const Color(0xFF9980FA),
    const Color(0xFFD980FA),
    const Color(0xFFFDA7DF),
    const Color(0xFF833471),
    const Color(0xFFB53471),
    const Color(0xFF6F1E51),
    const Color(0xFFED4C67),
    const Color(0xFFEA2027),
  ];

  static Future<Color?> show(BuildContext context) {
    return showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return ColorPickerDialog(
          onColorSelected: (color) {
            Navigator.of(context).pop(color);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: () {
                    onColorSelected(color);
                  },
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
  }
}
