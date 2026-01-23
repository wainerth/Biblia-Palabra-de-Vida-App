import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class SearchByBookWidget extends StatefulWidget {
  final VersionModel? version;
  final BookModel? book;
  final ChapterModel? chapter;
  final bool showSelectedRange;
  final void Function(
    InputDataSearchModel searchData,
  )? onActionBook;
  const SearchByBookWidget({
    super.key,
    this.version,
    this.book,
    this.chapter,
    this.showSelectedRange = true,
    this.onActionBook,
  });

  @override
  State<SearchByBookWidget> createState() => _SearchByBookWidgetState();
}

class _SearchByBookWidgetState extends State<SearchByBookWidget> {
  late BibleTheme currentTheme;

  // variables para almacenar listas globales
  List<VersionModel> listBibleVersions = [];
  List<ChapterModel> chapters = [];
  List<VerseModel> verses = [];

  // variables de lista de  select
  List<ModelData> bibleVersions = [];
  List<ModelData> books = [];

  ModelData? versionSelected = ModelData(label: "", value: "");
  ModelData? bookSelected = ModelData(label: "", value: "");
  ChapterModel? chapterSelected;
  List<ChapterModel> initialChapter = [];
  bool loadingChapter = false;
  bool loadingVerses = false;
  bool verseRange = false;
  bool _chaptersExpanded = true;
  bool _versesExpanded = true;
  List<VerseModel> _selectedItems = [];
  VerseModel? verseSelected;

  final ScrollController _chaptersScrollController = ScrollController();
  GlobalKey _selectedChapterKey = GlobalKey();
  // Función para determinar si es tablet
  bool get isTablet {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.shortestSide >= 600;
  }

  // Función para obtener el ancho máximo del dropdown según el dispositivo
  double get maxDropdownWidth {
    if (isTablet) {
      return 400; // Ancho mayor para tablet
    }
    return StylesApp(context).sizeTextFormField.width;
  }

  // Función para obtener la altura de los grids según el dispositivo
  double get gridHeight {
    if (isTablet) {
      return 350; // Altura mayor para tablet
    }
    return 280;
  }

  // Función para obtener el padding horizontal según el dispositivo
  EdgeInsets get horizontalPadding {
    if (isTablet) {
      return EdgeInsets.symmetric(horizontal: 24.0);
    }
    return EdgeInsets.symmetric(horizontal: 12.0);
  }

  // Función para obtener el tamaño de los espacios según el dispositivo
  double get spacingHeight {
    if (isTablet) {
      return 35; // Más espacio en tablet
    }
    return 25;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final catalogueProvider =
            Provider.of<CatalogueProvider>(context, listen: false);
        setState(() {
          listBibleVersions =
              catalogueProvider.allBibleVersion.map((v) => v).toList();
          bibleVersions = catalogueProvider.allBibleVersion
              .map((v) =>
                  ModelData(value: v.id, label: v.version, originalData: v))
              .toList();
        });
        if (widget.version != null) {
          setState(() {
            versionSelected = ModelData(
                label: widget.version!.version,
                value: widget.version!.id,
                originalData: widget.version);
          });
          await loadBookByVersion(versionSelected!.value);
        }
        if (widget.book != null) {
          setState(() {
            bookSelected = ModelData(
                label: widget.book!.modernName,
                value: widget.book!.id,
                originalData: widget.book);
          });
          await getChapterByBook(bookSelected!.value);
        }
        if (widget.chapter != null) {
          setState(() {
            // Usar firstWhereOrNull en lugar de firstWhere
            chapterSelected = chapters.firstWhereOrNull(
                    (chapter) => chapter.chapter == widget.chapter!.chapter) ??
                chapters.first; // Usar null-aware operator
            initialChapter = chapterSelected != null ? [chapterSelected!] : [];
          });

          await loadVerses(chapterSelected!.id!);
          setState(() {
            _versesExpanded = true;
            _selectedItems.add(verses.first);
            verseSelected = verses.first;
          });
        }
      } catch (e) {
        if (!mounted) return;
        await showCustomDialog(context,
            message: 'Error al cargar los datos: $e',
            dialogType: DialogType.error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<BibleThemeProvider>(context, listen: false);
    currentTheme = themeProvider.themeData;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: spacingHeight),
              Container(
                padding: horizontalPadding,
                constraints: BoxConstraints(
                  minWidth: isTablet ? 200.0 : 160.0,
                  maxWidth: maxDropdownWidth,
                ),
                child: CustomDropdownBottomWidget(
                  hintText: "Seleccione la version",
                  items: bibleVersions,
                  onChanged: (ModelData? version) async {
                    if (version == null) return;

                    try {
                      setState(() {
                        versionSelected = version;
                        _chaptersExpanded = true;
                      });

                      // Cargar libros de la nueva versión
                      await loadBookByVersion(version.value);

                      // Verificar que hay libros
                      if (books.isEmpty) {
                        throw Exception(
                            'No hay libros disponibles para esta versión');
                      }

                      // Intentar mantener el libro seleccionado anteriormente
                      ModelData? newBookSelected;

                      if (bookSelected != null &&
                          bookSelected!.originalData != null) {
                        final currentBookNumber =
                            bookSelected!.originalData!.numberBook;

                        // Usar firstWhereOrNull en lugar de firstWhere
                        newBookSelected = books.firstWhereOrNull((book) =>
                            book.originalData!.numberBook == currentBookNumber);

                        // Si no encontramos el libro por número, usar el primero
                        if (newBookSelected == null) {
                          newBookSelected = books.first;
                        }
                      } else {
                        // Si no había libro seleccionado, usar el primero
                        newBookSelected = books.first;
                      }

                      setState(() {
                        bookSelected = newBookSelected;
                        _chaptersExpanded = true;
                      });

                      // Cargar capítulos del nuevo libro
                      await getChapterByBook(bookSelected!.value);

                      // Verificar que hay capítulos
                      if (chapters.isEmpty) {
                        throw Exception(
                            'No hay capítulos disponibles para este libro');
                      }

                      // Intentar mantener el capítulo seleccionado anteriormente
                      ChapterModel? newChapterSelected;

                      if (chapterSelected != null) {
                        final currentChapterNumber = chapterSelected!.chapter;

                        // Usar firstWhereOrNull en lugar de firstWhere
                        newChapterSelected = chapters.firstWhereOrNull(
                            (chapter) =>
                                chapter.chapter == currentChapterNumber);

                        // Si no encontramos el capítulo por número, usar el primero
                        if (newChapterSelected == null) {
                          newChapterSelected = chapters.first;
                        }
                      } else {
                        // Si no había capítulo seleccionado, usar el primero
                        newChapterSelected = chapters.first;
                      }

                      setState(() {
                        chapterSelected = newChapterSelected;
                        initialChapter = newChapterSelected != null
                            ? [newChapterSelected!]
                            : [];
                      });

                      // Cargar versículos del nuevo capítulo
                      if (chapterSelected != null) {
                        await loadVerses(chapterSelected!.id!);

                        // Seleccionar el primer versículo
                        setState(() {
                          _versesExpanded = true;
                          _selectedItems =
                              verses.isNotEmpty ? [verses.first] : [];
                          verseSelected =
                              verses.isNotEmpty ? verses.first : null;
                        });
                      }
                    } catch (e) {
                      // Manejo de errores
                      if (mounted) {
                        setState(() {
                          bookSelected = null;
                          chapterSelected = null;
                          verses = [];
                          _selectedItems = [];
                          verseSelected = null;
                        });

                        await showCustomDialog(context,
                            message:
                                'Error al cambiar versión: ${e.toString()}',
                            dialogType: DialogType.error);
                      }
                    }
                  },
                  selectedItem: versionSelected!.value.isNotEmpty
                      ? bibleVersions.firstWhereOrNull((element) =>
                          element.value.toLowerCase() ==
                          versionSelected?.value.toLowerCase())
                      : null,
                ),
              ),
              SizedBox(height: spacingHeight),
              Container(
                padding: horizontalPadding,
                constraints: BoxConstraints(
                  minWidth:
                      isTablet ? 200.0 : 160.0, // Min width mayor en tablet
                  maxWidth: maxDropdownWidth,
                ),
                // dropdown de libros de la biblia
                child: CustomDropdownBottomWidget(
                  hintText: "Seleccione el Libro",
                  items: books,
                  onChanged: (ModelData? book) async {
                   if (book == null) return;

                    setState(() {
                      bookSelected = book;
                      _chaptersExpanded = true;
                      // _versesExpanded = false;
                    });

                    await getChapterByBook(book.value);
                    setState(() {
                      initialChapter =
                          chapters.isNotEmpty ? [chapters.first] : [];
                      chapterSelected =
                          chapters.isNotEmpty ? chapters.first : null;
                      _versesExpanded = true;
                    });
                    if (chapterSelected != null) {
                      setState(() {
                        initialChapter = [chapterSelected!];
                        // _chaptersExpanded = false;
                      });
                      await loadVerses(chapterSelected!.id!);
                      setState(() {
                        _versesExpanded = true;
                        _selectedItems.add(verses.first);
                        verseSelected = verseSelected != null
                            ? verses.firstWhere(
                                (verse) => verse.verse == verseSelected!.verse,
                                orElse: () => verses.first)
                            : verses.first;
                      });
                    }
                  },
                  selectedItem: bookSelected!.value.isNotEmpty
                      ? books.firstWhereOrNull((element) =>
                          element.value.toLowerCase() ==
                          bookSelected?.value.toLowerCase())
                      : books.isNotEmpty
                          ? books.first
                          : null,
                ),
              ),
              SizedBox(height: spacingHeight),
              Column(
                children: [
                  // Sección Capítulos
                  GestureDetector(
                    onTap: () =>
                        setState(() => _chaptersExpanded = !_chaptersExpanded),
                    child: Padding(
                      padding: horizontalPadding,
                      child: Row(
                        children: [
                          Text(
                            "Capítulos",
                            style: StylesApp(context).textStyleBody16.copyWith(
                                  color: currentTheme.textColor,
                                  fontSize: isTablet
                                      ? 18
                                      : 16, // Texto más grande en tablet
                                ),
                          ),
                          Spacer(),
                          Icon(
                            _chaptersExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: currentTheme.textColor,
                            size: isTablet
                                ? 28
                                : 24, // Icono más grande en tablet
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    duration: Duration(milliseconds: 300),
                    crossFadeState: _chaptersExpanded
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Padding(
                      padding: horizontalPadding,
                      child: Container(
                        decoration: BoxDecoration(
                          color: currentTheme.backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          boxShadow: [
                            BoxShadow(
                                color: StyleColor.black.withValues(alpha: 0.25),
                                blurRadius: 4.0,
                                offset: Offset(0, 4)),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              isTablet ? 16.0 : 12.0, // Más padding en tablet
                        ),
                        height: gridHeight,
                        child: GridButtonWidget<ChapterModel>(
                          loading: loadingChapter,
                          data: chapters,
                          currentTheme: currentTheme,
                          initiallySelected: initialChapter,
                          onTap: (chapter) async {
                            if (chapter.isEmpty) return;
                            if (kDebugMode) {
                              print(
                                  'Capítulo seleccionado: ${chapter.first.id}');
                            }
                            // Hacer scroll después de un pequeño delay para que se renderice
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _scrollToSelectedChapter();
                            });
                            await loadVerses(chapter.first.id!);
                            setState(() {
                              chapterSelected = chapter.first;
                              _chaptersExpanded = false;
                              _selectedItems = [];
                              verseSelected = null;
                            });
                          },
                        ),
                      ),
                    ),
                    secondChild: Container(),
                  ),

                  // Sección Versículos
                  GestureDetector(
                    onTap: () =>
                        setState(() => _versesExpanded = !_versesExpanded),
                    child: Padding(
                      padding: horizontalPadding,
                      child: Row(
                        children: [
                          Text(
                            "Versículos",
                            style: StylesApp(context).textStyleBody16.copyWith(
                                  color: currentTheme.textColor,
                                  fontSize: isTablet
                                      ? 18
                                      : 16, // Texto más grande en tablet
                                ),
                          ),
                          Spacer(),
                          Icon(
                            _versesExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: currentTheme.textColor,
                            size: isTablet
                                ? 28
                                : 24, // Icono más grande en tablet
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    duration: Duration(milliseconds: 300),
                    crossFadeState: _versesExpanded
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Padding(
                      padding: horizontalPadding,
                      child: Container(
                        decoration: BoxDecoration(
                          color: currentTheme.backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          boxShadow: [
                            BoxShadow(
                                color: StyleColor.black.withValues(alpha: 0.25),
                                blurRadius: 4.0,
                                offset: Offset(0, 4)),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              isTablet ? 16.0 : 12.0, // Más padding en tablet
                        ),
                        height: gridHeight,
                        child: GridButtonWidget<VerseModel>(
                          loading: loadingVerses,
                          data: verses,
                          currentTheme: currentTheme,
                          rangeSelect: verseRange,
                          initiallySelected: _selectedItems,
                          onTap: (verse) {
                            setState(() {
                              _selectedItems = verse;
                              verseSelected =
                                  verse.isNotEmpty ? verse.first : null;
                            });
                          },
                        ),
                      ),
                    ),
                    secondChild: Container(),
                  ),
                ],
              ),
              if (widget.showSelectedRange)
                Padding(
                  padding: horizontalPadding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            'Rango de versículos',
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: currentTheme.textColor,
                                  fontSize: isTablet
                                      ? 14
                                      : 12, // Texto más grande en tablet
                                ),
                          ),
                          trailing: Transform.scale(
                            scale: isTablet
                                ? 1.2
                                : 1.0, // Switch más grande en tablet
                            child: Switch(
                              activeColor: currentTheme.buttonColor,
                              thumbColor: WidgetStatePropertyAll(
                                  currentTheme.buttonColor),
                              trackOutlineColor:
                                  WidgetStatePropertyAll(StyleColor.grayMedium),
                              value: verseRange,
                              onChanged: (bool value) {
                                setState(() {
                                  verseRange = value;
                                  _selectedItems = [];
                                  if (!value && verseSelected != null) {
                                    _selectedItems = [verseSelected!];
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: spacingHeight),
          Padding(
            padding: horizontalPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonThemeWidget(
                  text: "Aceptar",
                  width: isTablet ? 200 : null,
                  height: isTablet ? 50 : null,
                  buttonStyle: StylesApp(context).btnWidgetSmall,
                  onPressed: () {
                    if (versionSelected!.value.isEmpty ||
                        bookSelected!.value.isEmpty ||
                        chapterSelected == null ||
                        _selectedItems.isEmpty) {
                      showCustomDialog(context,
                          message: "Debe seleccionar todos los campos",
                          dialogType: DialogType.error);
                      return;
                    }

                    final data = InputDataSearchModel(
                        version: versionSelected!.originalData,
                        book: bookSelected!.originalData,
                        chapter: chapterSelected,
                        versionId: versionSelected!.value,
                        bookId: bookSelected!.value,
                        chapterId: chapterSelected!.id!,
                        startVerseId: _selectedItems.first.id!,
                        endVerseId: _selectedItems.last.id!,
                        verses: _selectedItems);
                    widget.onActionBook!(data);
                  },
                )
              ],
            ),
          ),
          SizedBox(height: spacingHeight),
        ],
      ),
    );
  }

  /// Leemos los libros que corresponden a la version de la biblia
  loadBookByVersion(String versionId) {
    setState(() {
      // bookSelected = ModelData(label: '', value: '');
      chapters = [];
      verses = [];
      final VersionModel currenVersion =
          listBibleVersions.firstWhere((x) => x.id == versionId);

      if (currenVersion != null && currenVersion.books.isNotEmpty) {
        books = currenVersion.books
            .map((book) => ModelData(
                label: book.modernName, value: book.id, originalData: book))
            .toList();
      } else {
        books = []; // Asegurar que books no sea null
      }
    });
  }

  /// leemos los capítulos de un libro
  Future<void> getChapterByBook(String bookId) async {
    setState(() {
      chapters = [];
      verses = [];
      loadingChapter = true;
    });
    final responseChapterWithVerses = await getChapterWithVerses(bookId);
    if (responseChapterWithVerses.error != null) {
      setState(() {
        loadingChapter = false;
      });
      if (mounted) {
        await showCustomDialog(context,
            message: responseChapterWithVerses.error!,
            dialogType: DialogType.error);
      }
      return;
    } else {
      setState(() {
        // guardamos los capítulos de un libro
        chapters = responseChapterWithVerses.data
            .map<ChapterModel>((chapter) => ChapterModel.fromJson(chapter))
            .toList();
      });
      chapters = chapters..sort((a, b) => a.chapter.compareTo(b.chapter));
      loadingChapter = false;
    }
  }

// Función para ordenar en isolate
  static List<VerseModel> _sortVerses(List<VerseModel> verses) {
    return [...verses]..sort((a, b) => a.verse.compareTo(b.verse));
  }

  Future<void> loadVerses(String id) async {
    if (!mounted) return;

    setState(() => loadingVerses = true);

    try {
      // Usar firstWhereOrNull en lugar de firstWhere
      final chapter = chapters.firstWhereOrNull((ch) => ch.id == id);

      if (chapter != null && chapter.verses != null) {
        // Ordenar en batches para no bloquear UI
        final sortedVerses = await compute(_sortVerses, chapter.verses!);

        if (mounted) {
          setState(() {
            verses = sortedVerses;
          });
        }
      } else {
        if (mounted) {
          setState(() => verses = []);
        }
      }
    } catch (e) {
      if (mounted) {
        if (mounted) {
          setState(() => verses = []);
        }
      }
    } finally {
      if (mounted) {
        setState(() => loadingVerses = false);
      }
    }
  }

  void _scrollToSelectedChapter() {
    if (_selectedChapterKey.currentContext != null) {
      Scrollable.ensureVisible(
        _selectedChapterKey.currentContext!,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1, // Aparece cerca del borde superior
      );
    }
  }
}
