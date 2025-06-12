import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/models/model_data.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/catalogue_provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchBibleWidget extends StatefulWidget {
  const SearchBibleWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchBibleWidget> createState() => _SearchBibleWidgetState();
}

class _SearchBibleWidgetState extends State<SearchBibleWidget> {
  late BibleTheme currentTheme;

  var _selectedIndex = 0;
  List tabs = [
    {
      "title": 'Libro',
      "placeholder": 'Mensaje a buscar',
    },
    {
      "title": 'Texto',
      "placeholder": 'Nombre del predicador a buscar',
    },
    {
      "title": 'Tema',
      "placeholder": 'Favorito a buscar',
    },
    {
      "title": 'Personajes',
      "placeholder": 'Favorito a buscar',
    }
  ];
  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<BibleThemeProvider>(context, listen: false);
    currentTheme = themeProvider.themeData;
    return SafeArea(
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          body: Column(
            children: [
              AppBarHeaderWidget(
                backColor: StyleColor.turquoise,
                buttonColor: StyleColor.orange,
                textButtonColor: Colors.white,
                title: 'Búsqueda',
                styleText: StylesApp(context).textStyleBody7,
                onRoute: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.only(right: 65),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  )
                ]),
                child: TabBar(
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.white,
                  labelStyle: StylesApp(context).textStyleBody12,
                  indicatorSize: TabBarIndicatorSize.tab,
                  automaticIndicatorColorAdjustment: true,
                  indicatorWeight: 0,
                  indicatorPadding: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  dividerColor: Color(0XFFFFFDFD),
                  dividerHeight: 0,
                  labelPadding: EdgeInsets.symmetric(horizontal: 2),
                  indicator: BoxDecoration(
                    color: Colors.orange, // Color de la pestaña seleccionada
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ), // Bordes redondeados
                  ),
                  tabs: tabs.asMap().entries.map((entry) {
                    int index = entry.key;
                    var tab = entry.value;
                    return Tab(
                      height: 32.sp,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? Colors.orange
                              : Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Center(child: Text(tab["title"])),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Lista de mensajes
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(child: searchByBookWidget()),
                    SingleChildScrollView(child: searchByTextWidget()),
                   SingleChildScrollView(child:  searchByTitleWidget()),
                    SingleChildScrollView(child: searchByCharacterWidget()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class searchByCharacterWidget extends StatelessWidget {
  const searchByCharacterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class searchByTitleWidget extends StatelessWidget {
  const searchByTitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class searchByTextWidget extends StatelessWidget {
  const searchByTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class searchByBookWidget extends StatefulWidget {
  const searchByBookWidget({
    super.key,
  });

  @override
  State<searchByBookWidget> createState() => _searchByBookWidgetState();
}

class _searchByBookWidgetState extends State<searchByBookWidget> {
  late BibleTheme currentTheme;

  // variables para almacenar listas globales
  List<VersionModel> listBibleVersions = [];
  List<ChapterModel> chapters = [];
  List<VerseModel> verses = [];

  // varibales de lista de  select
  List<ModelData> bibleVersions = [];
  List<ModelData> books = [];

  ModelData? versionSelected = ModelData(label: "", value: "");
  ModelData? bookSelected = ModelData(label: "", value: "");
  bool loadingChapter = false;
  bool loadingVerses = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        listBibleVersions =
            Provider.of<CatalogueProvider>(context, listen: false)
                .allBibleVersion
                .map((v) => v)
                .toList();
        bibleVersions = Provider.of<CatalogueProvider>(context, listen: false)
            .allBibleVersion
            .map((v) => ModelData(value: v.id, label: v.version))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<BibleThemeProvider>(context, listen: false);
    currentTheme = themeProvider.themeData;
    return Column(children: [
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
            print("version seleccionada ${version!.value}");
            setState(() {
              versionSelected = version;
            });
            await loadBookByVersion(version.value);
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
            print("version seleccionada ${book!.value}");
            setState(() {
              bookSelected = book;
            });

            await getChapterByBook(book.value);
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
      Text(
        "Capítulos",
        style: StylesApp(context)
            .textStyleBody16
            .copyWith(color: currentTheme.textColor),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: loadingChapter
              ? Center(child: LoadingIndicator())
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        await loadVerses(chapters[index].id);
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            color: currentTheme.buttonColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      StyleColor.black.withValues(alpha: .35),
                                  blurRadius: 5.0,
                                  offset: Offset(5, 3))
                            ]),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            '${chapters[index].chapter}',
                            style: StylesApp(context).textStyleBody18.copyWith(
                                  color: currentTheme.buttonTextColor,
                                ),
                          ),
                        ),
                      ),
                    );
                  }),
        ),
      ),
      Text(
        "Versículos",
        style: StylesApp(context)
            .textStyleBody16
            .copyWith(color: currentTheme.textColor),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: verses.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: currentTheme.buttonColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        boxShadow: [
                          BoxShadow(
                              color: StyleColor.black.withValues(alpha: .35),
                              blurRadius: 5.0,
                              offset: Offset(5, 3))
                        ]),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        '${verses[index].verse}',
                        style: StylesApp(context).textStyleBody18.copyWith(
                              color: currentTheme.buttonTextColor,
                            ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: verses.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        color: currentTheme.buttonColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        boxShadow: [
                          BoxShadow(
                              color: StyleColor.black.withValues(alpha: .35),
                              blurRadius: 5.0,
                              offset: Offset(5, 3))
                        ]),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        '${verses[index].verse}',
                        style: StylesApp(context).textStyleBody18.copyWith(
                              color: currentTheme.buttonTextColor,
                            ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    ]);
  }

  /// Leemos los libros que corresponden a la version de la biblia
  loadBookByVersion(String versionId) {
    setState(() {
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
      await showCustomDialog(context,
          message: responseChapterWithVerses.error!,
          dialogType: DialogType.error);
    }
    setState(() {
      // guardamos los capítulos de un libro
      chapters = responseChapterWithVerses.data
          .map<ChapterModel>((chapter) => ChapterModel.fromJson(chapter))
          .toList();
    });
    loadingChapter = false;
  }

  loadVerses(String id) {
    setState(() {
      loadingVerses = true;
      verses = chapters
          .firstWhere((ch) => ch.id == id)
          .verses
          .map((verse) => verse)
          .toList();
      loadingVerses = false;
    });
  }
}
