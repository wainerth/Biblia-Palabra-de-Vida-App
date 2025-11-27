import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

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
  bool _versesExpanded = false;
  List<VerseModel> _selectedItems = [];

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
          chapterSelected = widget.chapter;
          initialChapter = [chapterSelected!];
          _chaptersExpanded = false;
        });
        await loadVerses(chapterSelected!.id!);
        setState(() {
          _versesExpanded = true;
          _selectedItems.add(verses.first);
        });
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
                  minWidth:
                      isTablet ? 200.0 : 160.0, // Min width mayor en tablet
                  maxWidth: maxDropdownWidth,
                ),
                child: CustomDropdownBottomWidget(
                  hintText: "Seleccione la version",
                  items: bibleVersions,
                  onChanged: (ModelData? version) async {
                    if (kDebugMode) {
                      print("version seleccionada ${version!.value}");
                    }
                    setState(() {
                      versionSelected = version;
                      _chaptersExpanded = true;
                      _versesExpanded = false;
                    });
                    // leemos los libros de esta version y tomamos el primero
                    await loadBookByVersion(version!.value);
                    setState(() {
                      bookSelected = ModelData(
                          label: books.first.label,
                          value: books.first.value,
                          originalData: books.first.originalData);
                      _chaptersExpanded = true;
                      _versesExpanded = false;
                    });
                    // leemos los capítulos de esta version y tomamos el primero
                    await getChapterByBook(bookSelected!.value);
                    if (chapters.isEmpty) return;
                    setState(() {
                      chapterSelected = chapters.first;
                      initialChapter = [chapterSelected!];
                      _chaptersExpanded = false;
                    });
                    // leemos los versículos y seleccionamos el primero
                    await loadVerses(chapterSelected!.id!);

                    setState(() {
                      _versesExpanded = true;
                      _selectedItems.add(verses.first);
                    });
                  },
                  selectedItem: versionSelected!.value.isNotEmpty
                      ? bibleVersions.firstWhere((element) =>
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
                child: CustomDropdownBottomWidget(
                  hintText: "Seleccione el Libro",
                  items: books,
                  onChanged: (ModelData? book) async {
                    if (kDebugMode) {
                      print("Libro seleccionada ${book!.value}");
                    }
                    setState(() {
                      bookSelected = book;
                      _chaptersExpanded = true;
                      _versesExpanded = false;
                    });

                    await getChapterByBook(book!.value);
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
                        _chaptersExpanded = false;
                      });
                      await loadVerses(chapterSelected!.id!);
                      setState(() {
                        _versesExpanded = true;
                        _selectedItems.add(verses.first);
                      });
                    }
                  },
                  selectedItem: bookSelected!.value.isNotEmpty
                      ? books.firstWhere((element) =>
                          element.value.toLowerCase() ==
                          bookSelected?.value.toLowerCase())
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
                            await loadVerses(chapter.first.id!);
                            setState(() {
                              chapterSelected = chapter.first;
                              _chaptersExpanded = false;
                              _selectedItems = [];
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
      bookSelected = ModelData(label: '', value: '');
      chapters = [];
      verses = [];
      final VersionModel currenVersion =
          listBibleVersions.firstWhere((x) => x.id == versionId);

      books = currenVersion.books
          .map((book) => ModelData(
              label: book.modernName, value: book.id, originalData: book))
          .toList();
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

  loadVerses(String id) {
    setState(() {
      loadingVerses = true;
      verses = chapters
          .firstWhere(
            (ch) => ch.id == id,
          )
          .verses!
          .map((verse) => verse)
          .toList();

      verses.sort((a, b) {
        final verseA = a.verse;
        final verseB = b.verse;

        return verseA.compareTo(verseB);
      });
      loadingVerses = false;
    });
  }
}
