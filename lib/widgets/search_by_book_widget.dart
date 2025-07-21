import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class SearchByBookWidget extends StatefulWidget {
  final VersionModel version;
  final BookModel book;
  final ChapterModel chapter;
  final void Function(InputDataSearchModel searchData)? onActionBook;
  const SearchByBookWidget({
    super.key,
    required this.version,
    required this.book,
    required this.chapter,
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
            .map((v) => ModelData(value: v.id, label: v.version))
            .toList();
      });
      if (widget.version != null) {
        setState(() {
          versionSelected = ModelData(
              label: widget.version.version, value: widget.version.id);
        });
        await loadBookByVersion(versionSelected!.value);
      }
      if (widget.book != null) {
        setState(() {
          bookSelected =
              ModelData(label: widget.book.modernName, value: widget.book.id);
        });
      }
      await getChapterByBook(bookSelected!.value);
      if (widget.chapter != null) {
        setState(() {
          chapterSelected = widget.chapter;
          initialChapter = [chapterSelected!];
          _chaptersExpanded = false;
        });
      }
      await loadVerses(chapterSelected!.id);

      setState(() {
        _versesExpanded = true;
        _selectedItems.add(verses.first);
      });
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
              SizedBox(
                height: 25,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                constraints: BoxConstraints(
                  minWidth: 160.0,
                  maxWidth: StylesApp(context).sizeTextFormField.width,
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
                    await loadBookByVersion(version!.value);
                  },
                  selectedItem: versionSelected!.value.isNotEmpty
                      ? bibleVersions.firstWhere((element) =>
                          element.value.toLowerCase() ==
                          versionSelected?.value.toLowerCase())
                      : null,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                constraints: BoxConstraints(
                  minWidth: 160.0,
                  maxWidth: StylesApp(context).sizeTextFormField.width,
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
                  },
                  selectedItem: bookSelected!.value.isNotEmpty
                      ? books.firstWhere((element) =>
                          element.value.toLowerCase() ==
                          bookSelected?.value.toLowerCase())
                      : null,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  // Sección Capítulos
                  GestureDetector(
                    onTap: () =>
                        setState(() => _chaptersExpanded = !_chaptersExpanded),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Text(
                            "Capítulos",
                            style: StylesApp(context)
                                .textStyleBody16
                                .copyWith(color: currentTheme.textColor),
                          ),
                          Spacer(),
                          Icon(
                            _chaptersExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: currentTheme.textColor,
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
                      padding: const EdgeInsets.all(12.0),
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
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        height: 280,
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
                            await loadVerses(chapter.first.id);
                            setState(() {
                              chapterSelected = chapter.first;
                              _chaptersExpanded = false;
                              _versesExpanded = true;
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
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Text(
                            "Versículos",
                            style: StylesApp(context)
                                .textStyleBody16
                                .copyWith(color: currentTheme.textColor),
                          ),
                          Spacer(),
                          Icon(
                            _versesExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: currentTheme.textColor,
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
                      padding: const EdgeInsets.all(12.0),
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
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        height: 280,
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: ListTile(
                      title: Text(
                        'Rango de versículos',
                        style: StylesApp(context)
                            .textStyleBody12
                            .copyWith(color: currentTheme.textColor),
                      ),
                      trailing: Switch(
                        activeColor: currentTheme.buttonColor,
                        thumbColor:
                            WidgetStatePropertyAll(currentTheme.buttonColor),
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
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonThemeWidget(
                text: "Aceptar",
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
                    versionId: versionSelected!.value,
                    bookId: bookSelected!.value,
                    chapterId: chapterSelected!.id,
                    startVerseId: _selectedItems.first.id,
                    endVerseId: _selectedItems.last.id,
                  );
                  widget.onActionBook!(data);
                },
              )
            ],
          )
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
          .map((book) => ModelData(label: book.modernName, value: book.id))
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
          .firstWhere((ch) => ch.id == id)
          .verses
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
