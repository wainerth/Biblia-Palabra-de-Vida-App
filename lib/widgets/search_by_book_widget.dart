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

  final translationProvider = AppTranslationProvider();
  
  late BibleTheme currentTheme;

  // variables para almacenar listas globales
  List<VersionModel> listBibleVersions = [];
  List<ChapterModel> chapters = [];
  List<VerseModel> verses = [];

  // variables de lista de select
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

  // Función para determinar si es tablet
  bool get isTablet {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width >= 600;
  }

  // Función para obtener el ancho máximo del dropdown según el dispositivo
  double get maxDropdownWidth {
    if (isTablet) {
      return 400;
    }
    return StylesApp(context).sizeTextFormField.width;
  }

  // Función para obtener la altura de los grids según el dispositivo
  double get gridHeight {
    if (isTablet) {
      return 350;
    }
    return 280;
  }

  // Función para obtener el padding horizontal según el dispositivo
  EdgeInsets get horizontalPadding {
    if (isTablet) {
      return const EdgeInsets.symmetric(horizontal: 24.0);
    }
    return const EdgeInsets.symmetric(horizontal: 12.0);
  }

  // Función para obtener el tamaño de los espacios según el dispositivo
  double get spacingHeight {
    if (isTablet) {
      return 35;
    }
    return 25;
  }

  // Número de columnas para los grids
  int get columnCount {
    if (isTablet) {
      return verseRange ? 6 : 6;
    }
    return 5;
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
            chapterSelected = chapters.firstWhereOrNull(
                    (chapter) => chapter.chapter == widget.chapter!.chapter) ??
                chapters.first;
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
            message: translationProvider.trParams('search_by_book.messages.error_loading_data', {'error': e.toString()}),
            dialogType: DialogType.error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<BibleThemeProvider>(context, listen: false);
    currentTheme = themeProvider.themeData;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Layout condicional según dispositivo

        Expanded(
          child: SingleChildScrollView(
            child: Container(
              child: !isTablet ? _buildMobileLayout() : _buildTabletLayout(),
            ),
          ),
        ),

        // Botón Aceptar (compartido)
        SizedBox(height: spacingHeight),
        Padding(
          padding: horizontalPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonThemeWidget(
                text: translationProvider.tr('search_by_book.button'),
                width: isTablet ? 200 : null,
                height: isTablet ? 50 : null,
                buttonStyle: StylesApp(context).btnWidgetSmall,
                onPressed: _onAcceptPressed,
              )
            ],
          ),
        ),
        SizedBox(height: spacingHeight),
      ],
    );
  }

  // ============ LAYOUT PARA MÓVIL (UNA COLUMNA) ============
  Widget _buildMobileLayout() {
    return Column(
      children: [
        SizedBox(height: spacingHeight),

        // Selector de versión
        Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: currentTheme.buttonColor,
            ),
          ),
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: maxDropdownWidth,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: CustomDropdownBottomWidget(
            hintText: translationProvider.tr('search_by_book.dropdowns.version'),
            items: bibleVersions,
            border: false,
            currentTheme: currentTheme,
            onChanged: _onVersionChanged,
            selectedItem: versionSelected!.value.isNotEmpty
                ? bibleVersions.firstWhereOrNull((element) =>
                    element.value.toLowerCase() ==
                    versionSelected?.value.toLowerCase())
                : null,
          ),
        ),

        SizedBox(height: spacingHeight),

        // Selector de libro
        Container(
          padding: horizontalPadding,
           clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: currentTheme.buttonColor,
            ),
          ),
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: maxDropdownWidth,
          ),
          child: CustomDropdownBottomWidget(
            hintText: translationProvider.tr('search_by_book.dropdowns.book'),
            items: books,
            border: false,
            currentTheme: currentTheme,
            onChanged: _onBookChanged,
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

        // Sección de Capítulos (acordeón)
        _buildChaptersSectionMobile(),

        // Sección de Versículos (acordeón)
        _buildVersesSectionMobile(),

        // Switch de rango
        if (widget.showSelectedRange) _buildRangeSwitchMobile(),
      ],
    );
  }

  // ============ LAYOUT PARA TABLET (DOS COLUMNAS) ============
  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          SizedBox(height: spacingHeight),

          // Selectores en una fila
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildVersionSelectorTablet(),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildBookSelectorTablet(),
              ),
            ],
          ),

          SizedBox(height: spacingHeight * 1.5),

          // Capítulos y Versículos en dos columnas
          SizedBox(
            height: 450, // Altura fija para las dos columnas
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // COLUMNA IZQUIERDA: CAPÍTULOS
                Expanded(
                  child: Card(
                    shadowColor: currentTheme.buttonColor,
                    color: currentTheme.backgroundColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título de Capítulos
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.list,
                                  color: currentTheme.buttonColor,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  translationProvider.tr('search_by_book.sections.chapters'),
                                  style: StylesApp(context)
                                      .textStyleBody16
                                      .copyWith(
                                        color: currentTheme.textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Spacer(),
                                Text(
                                  translationProvider.trParams('search_by_book.sections.total_chapters', {'count': chapters.length.toString()}),
                                  style: StylesApp(context)
                                      .textStyleBody12
                                      .copyWith(
                                        color: currentTheme.textColor
                                            .withValues(alpha: 0.7),
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // Grid de Capítulos
                          Expanded(
                            child: loadingChapter
                                ? Center(child: LoadingIndicator())
                                : chapters.isEmpty
                                    ? Center(
                                        child: Text(
                                          translationProvider.tr('search_by_book.sections.select_book'),
                                          style: StylesApp(context)
                                              .textStyleBody14
                                              .copyWith(
                                                color: currentTheme.textColor
                                                    .withValues(alpha: 0.5),
                                              ),
                                        ),
                                      )
                                    : GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 6,
                                          childAspectRatio: 1.0,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                        ),
                                        itemCount: chapters.length,
                                        itemBuilder: (context, index) {
                                          final chapter = chapters[index];
                                          final isSelected =
                                              chapterSelected?.id == chapter.id;

                                          return _buildChapterItem(
                                              chapter, isSelected);
                                        },
                                      ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16),

                // COLUMNA DERECHA: VERSÍCULOS
                Expanded(
                  child: Card(
                    shadowColor: currentTheme.buttonColor,
                    color: currentTheme.backgroundColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título de Versículos
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.format_list_numbered,
                                  color: currentTheme.buttonColor,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  translationProvider.tr('search_by_book.sections.verses'),
                                  style: StylesApp(context)
                                      .textStyleBody16
                                      .copyWith(
                                        color: currentTheme.textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Spacer(),
                                if (chapterSelected != null)
                                  Text(
                                    translationProvider.trParams('search_by_book.sections.chapter', {'number': chapterSelected!.chapter.toString()}),
                                    style: StylesApp(context)
                                        .textStyleBody12
                                        .copyWith(
                                          color: currentTheme.buttonColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                              ],
                            ),
                          ),

                          // Grid de Versículos
                          Expanded(
                            child: loadingVerses
                                ? Center(child: LoadingIndicator())
                                : verses.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.book_outlined,
                                              color: currentTheme.textColor
                                                  .withValues(alpha: 0.3),
                                              size: 48,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              translationProvider.tr('search_by_book.sections.select_chapter'),
                                              style: StylesApp(context)
                                                  .textStyleBody14
                                                  .copyWith(
                                                    color: currentTheme
                                                        .textColor
                                                        .withValues(alpha: 0.5),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: columnCount,
                                          childAspectRatio: 1.0,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                        ),
                                        itemCount: verses.length,
                                        itemBuilder: (context, index) {
                                          final verse = verses[index];
                                          final isSelected = _selectedItems
                                              .any((v) => v.id == verse.id);

                                          return _buildVerseItem(
                                              verse, isSelected);
                                        },
                                      ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Switch de rango (en tablet va en la columna de versículos)
          if (widget.showSelectedRange) ...[
            SizedBox(height: spacingHeight),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildRangeSwitchTablet(),
            ),
          ]
        ],
      ),
    );
  }

  // ============ COMPONENTES REUTILIZABLES ============

  Widget _buildVersionSelectorTablet() {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: currentTheme.buttonColor,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: CustomDropdownBottomWidget(
        hintText: translationProvider.tr('search_by_book.dropdowns.version'),
        items: bibleVersions,
        border: false,
        currentTheme: currentTheme,
        onChanged: _onVersionChanged,
        selectedItem: versionSelected!.value.isNotEmpty
            ? bibleVersions.firstWhereOrNull((element) =>
                element.value.toLowerCase() ==
                versionSelected?.value.toLowerCase())
            : null,
      ),
    );
  }

  Widget _buildBookSelectorTablet() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: currentTheme.buttonColor,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: CustomDropdownBottomWidget(
        hintText: translationProvider.tr('search_by_book.dropdowns.book'),
        items: books,
        onChanged: _onBookChanged,
        border: false,
        currentTheme: currentTheme,
        selectedItem: bookSelected!.value.isNotEmpty
            ? books.firstWhereOrNull((element) =>
                element.value.toLowerCase() ==
                bookSelected?.value.toLowerCase())
            : books.isNotEmpty
                ? books.first
                : null,
      ),
    );
  }

  Widget _buildChapterItem(ChapterModel chapter, bool isSelected) {
    return GestureDetector(
      onTap: () => _onChapterSelected(chapter),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? currentTheme.buttonColor
              : currentTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? currentTheme.buttonColor
                : currentTheme.buttonColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: currentTheme.buttonColor.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          '${chapter.chapter}',
          style: StylesApp(context).textStyleBody16.copyWith(
                color: isSelected ? Colors.white : currentTheme.textColor,
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 16 : 14,
              ),
        ),
      ),
    );
  }

  Widget _buildVerseItem(VerseModel verse, bool isSelected) {
    return GestureDetector(
      onTap: () => _onVerseSelected(verse),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? currentTheme.buttonColor
              : currentTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? currentTheme.buttonColor
                : currentTheme.buttonColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: currentTheme.buttonColor.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          '${verse.verse}',
          style: StylesApp(context).textStyleBody16.copyWith(
                color: isSelected ? Colors.white : currentTheme.textColor,
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 16 : 14,
              ),
        ),
      ),
    );
  }

  Widget _buildChaptersSectionMobile() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _chaptersExpanded = !_chaptersExpanded),
          child: Padding(
            padding: horizontalPadding,
            child: Row(
              children: [
                Text(
                  translationProvider.tr('search_by_book.sections.chapters'),
                  style: StylesApp(context).textStyleBody16.copyWith(
                        color: currentTheme.textColor,
                        fontSize: 16,
                      ),
                ),
                Spacer(),
                Icon(
                  _chaptersExpanded ? Icons.expand_less : Icons.expand_more,
                  color: currentTheme.textColor,
                  size: 24,
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
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              height: gridHeight,
              child: GridButtonWidget<ChapterModel>(
                loading: loadingChapter,
                data: chapters,
                currentTheme: currentTheme,
                initiallySelected: initialChapter,
                onTap: (chapter) async {
                  if (chapter.isEmpty) return;
                  await _onChapterSelected(chapter.first);
                },
              ),
            ),
          ),
          secondChild: Container(),
        ),
      ],
    );
  }

  Widget _buildVersesSectionMobile() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _versesExpanded = !_versesExpanded),
          child: Padding(
            padding: horizontalPadding,
            child: Row(
              children: [
                Text(
                  translationProvider.tr('search_by_book.sections.verses'),
                  style: StylesApp(context).textStyleBody16.copyWith(
                        color: currentTheme.textColor,
                        fontSize: 16,
                      ),
                ),
                Spacer(),
                Icon(
                  _versesExpanded ? Icons.expand_less : Icons.expand_more,
                  color: currentTheme.textColor,
                  size: 24,
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
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              height: gridHeight,
              child: GridButtonWidget<VerseModel>(
                loading: loadingVerses,
                data: verses,
                currentTheme: currentTheme,
                rangeSelect: verseRange,
                initiallySelected: _selectedItems,
                onTap: (List<VerseModel> verse) {
                  setState(() {
                    _selectedItems = verse;
                    verseSelected = verse.isNotEmpty ? verse.first : null;
                  });
                },
              ),
            ),
          ),
          secondChild: Container(),
        ),
      ],
    );
  }

  Widget _buildRangeSwitchMobile() {
    return Padding(
      padding: horizontalPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListTile(
              title: Text(
                translationProvider.tr('search_by_book.range.title'),
                style: StylesApp(context).textStyleBody12.copyWith(
                      color: currentTheme.textColor,
                      fontSize: 12,
                    ),
              ),
              trailing: Switch(
                activeColor: currentTheme.buttonColor,
                thumbColor: WidgetStatePropertyAll(currentTheme.buttonColor),
                trackOutlineColor:
                    WidgetStatePropertyAll(StyleColor.grayMedium),
                value: verseRange,
                onChanged: (bool value) {
                  _switchRangeSelected(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeSwitchTablet() {
    return Container(
      decoration: BoxDecoration(
        color: currentTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: currentTheme.buttonColor,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.swap_horiz,
            color: currentTheme.buttonColor,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            translationProvider.tr('search_by_book.range.select_range'),
            style: StylesApp(context).textStyleBody14.copyWith(
                  color: currentTheme.textColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
          Spacer(),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              activeColor: currentTheme.buttonColor,
              thumbColor: WidgetStatePropertyAll(currentTheme.buttonColor),
              trackOutlineColor: WidgetStatePropertyAll(StyleColor.grayMedium),
              value: verseRange,
              onChanged: (bool value) {
                _switchRangeSelected(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============ MÉTODOS DE EVENTOS ============

  Future<void> _onVersionChanged(ModelData? version) async {
    if (version == null) return;

    try {
      // guardamos la version y expando chapters
      setState(() {
        versionSelected = version;
        _chaptersExpanded = true;
      });

      await loadBookByVersion(version.value);

      if (books.isEmpty) {
        throw Exception(translationProvider.tr('search_by_book.messages.no_books_available'));
      }

      // guardamos libros
      ModelData? newBookSelected;
      if (bookSelected != null && bookSelected!.originalData != null) {
        final currentBookNumber = bookSelected!.originalData!.numberBook;
        newBookSelected = books.firstWhereOrNull(
            (book) => book.originalData!.numberBook == currentBookNumber);
      }

      newBookSelected ??= books.first;

      setState(() {
        bookSelected = newBookSelected;
      });

      await getChapterByBook(bookSelected!.value);

      if (chapters.isEmpty) {
        throw Exception(translationProvider.tr('search_by_book.messages.no_chapters_available'));
      }
      // buscamos chapter si ya hay uno previo usar ese si no el primero
      ChapterModel? newChapterSelected;
      // if (chapterSelected != null) {
      // final currentChapterNumber = chapterSelected!.chapter;
      newChapterSelected = chapterSelected != null
          ? chapters.firstWhere(
              (chapter) => chapter.chapter == chapterSelected?.chapter,
              orElse: () => chapters.first)
          : chapters.first;
      // }

      setState(() {
        chapterSelected = newChapterSelected;
        initialChapter = newChapterSelected != null ? [newChapterSelected] : [];
      });

      if (chapterSelected != null) {
        await loadVerses(chapterSelected!.id!);
        setState(() {
          _versesExpanded = true;
          if (_selectedItems.isNotEmpty) {
            final startVerse = _selectedItems
                .map((v) => v.verse)
                .reduce((a, b) => a < b ? a : b);
            final endVerse = _selectedItems
                .map((v) => v.verse)
                .reduce((a, b) => a > b ? a : b);

            final rangeVerses = verses
                .where((v) => v.verse >= startVerse && v.verse <= endVerse)
                .toList();
            _selectedItems =
                rangeVerses.isNotEmpty ? rangeVerses : [verses.first];
          } else {
            _selectedItems = verses.isNotEmpty ? [verses.first] : [];
          }
          verseSelected = verseSelected != null
              ? verses.firstWhere((verse) => verse.id == versionSelected?.value,
                  orElse: () => verses.first)
              : verses.isNotEmpty
                  ? verses.first
                  : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          bookSelected = null;
          chapterSelected = null;
          verses = [];
          _selectedItems = [];
          verseSelected = null;
        });

        await showCustomDialog(context,
            message: translationProvider.trParams('search_by_book.messages.error_changing_version', {'error': e.toString()}),
            dialogType: DialogType.error);
      }
    }
  }

  Future<void> _onBookChanged(ModelData? book) async {
    if (book == null) return;

    setState(() {
      bookSelected = book;
      _chaptersExpanded = true;
    });

    await getChapterByBook(book.value);
    setState(() {
      initialChapter = chapters.isNotEmpty ? [chapters.first] : [];
      chapterSelected = chapters.isNotEmpty ? chapters.first : null;
      _versesExpanded = true;
    });

    if (chapterSelected != null) {
      setState(() {
        initialChapter = [chapterSelected!];
      });
      await loadVerses(chapterSelected!.id!);
      setState(() {
        _versesExpanded = true;
        _selectedItems.add(verses.first);
        verseSelected = verseSelected != null
            ? verses.firstWhere((verse) => verse.verse == verseSelected!.verse,
                orElse: () => verses.first)
            : verses.first;
      });
    }
  }

  Future<void> _onChapterSelected(ChapterModel chapter) async {
    await loadVerses(chapter.id!);
    setState(() {
      chapterSelected = chapter;
      if (!isTablet) {
        _chaptersExpanded = false;
      }
      _selectedItems = [];
      verseSelected = null;
    });
  }

  void _onVerseSelected(VerseModel verse) {
    setState(() {
      if (verseRange) {
        // Lógica para selección de rango
        if (_selectedItems.isEmpty) {
          _selectedItems = [verse];
        } else if (_selectedItems.length == 1) {
          final firstVerse = _selectedItems.first;
          final start =
              firstVerse.verse < verse.verse ? firstVerse.verse : verse.verse;
          final end =
              firstVerse.verse > verse.verse ? firstVerse.verse : verse.verse;

          _selectedItems =
              verses.where((v) => v.verse >= start && v.verse <= end).toList();
        } else {
          _selectedItems = [verse];
        }
      } else {
        _selectedItems = [verse];
      }
      verseSelected = verse;
    });
  }

  void _onAcceptPressed() {
    if (versionSelected!.value.isEmpty ||
        bookSelected!.value.isEmpty ||
        chapterSelected == null ||
        _selectedItems.isEmpty) {
      showCustomDialog(context,
          message: translationProvider.tr('search_by_book.messages.fields_required'),
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
      verses: _selectedItems,
    );

    if (widget.onActionBook != null) {
      widget.onActionBook!(data);
    }
  }

  // ============ MÉTODOS EXISTENTES ============

  loadBookByVersion(String versionId) {
    setState(() {
      final VersionModel currenVersion =
          listBibleVersions.firstWhere((x) => x.id == versionId);

      if (currenVersion.books.isNotEmpty) {
        books = currenVersion.books
            .map((book) => ModelData(
                label: book.modernName, value: book.id, originalData: book))
            .toList();
      } else {
        books = [];
      }
    });
  }

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
        chapters = responseChapterWithVerses.data
            .map<ChapterModel>((chapter) => ChapterModel.fromJson(chapter))
            .toList();
        chapters = chapters..sort((a, b) => a.chapter.compareTo(b.chapter));
        loadingChapter = false;
      });
    }
  }

  static List<VerseModel> _sortVerses(List<VerseModel> verses) {
    return [...verses]..sort((a, b) => a.verse.compareTo(b.verse));
  }

  Future<void> loadVerses(String id) async {
    if (!mounted) return;

    setState(() => loadingVerses = true);

    try {
      final chapter = chapters.firstWhereOrNull((ch) => ch.id == id);

      if (chapter != null && chapter.verses != null) {
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
        setState(() => verses = []);
      }
    } finally {
      if (mounted) {
        setState(() => loadingVerses = false);
      }
    }
  }

  void _switchRangeSelected(bool value) {
    setState(() {
      verseRange = value;
      _selectedItems = [];
      if (!value && verseSelected != null) {
        _selectedItems = [verseSelected!];
      }
    });
  }
}
