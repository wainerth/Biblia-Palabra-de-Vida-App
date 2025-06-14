import 'dart:async';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchBibleWidget extends StatefulWidget {
  const SearchBibleWidget({
    super.key,
  });

  @override
  State<SearchBibleWidget> createState() => _SearchBibleWidgetState();
}

class _SearchBibleWidgetState extends State<SearchBibleWidget> {
  late BibleTheme currentTheme;
  LoginUser? userData;
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeAppData());
  }

  Future<void> _initializeAppData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userData = userProvider.currentUser;
    await Provider.of<BibleThemeProvider>(context, listen: false)
        .loadSavedTheme();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<BibleThemeProvider>(context, listen: false);
    currentTheme = themeProvider.themeData;
    return SafeArea(
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
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
                  width: MediaQuery.sizeOf(context).width,
                  // padding: const EdgeInsets.only(right: 65),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    )
                  ]),
                  child: TabBar(
                    // isScrollable: true,
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
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 100),
                          child: Container(
                            // width: double.infinity,
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
                            child: Center(
                              child: Text(
                                tab["title"],
                                maxLines: 1, // Asegura una sola línea
                                // overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Lista de mensajes
                Expanded(
                  child: TabBarView(
                    children: [
                      SearchByBookWidget(),
                      SearchByTextWidget(),
                      SearchByThemeWidget(),
                      SearchByCharacterWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchByCharacterWidget extends StatelessWidget {
  const SearchByCharacterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SearchByThemeWidget extends StatefulWidget {
  const SearchByThemeWidget({
    super.key,
  });

  @override
  State<SearchByThemeWidget> createState() => _SearchByThemeWidgetState();
}

class _SearchByThemeWidgetState extends State<SearchByThemeWidget> {
  LoginUser? userData;

  late BibleTheme currentTheme;
  TextEditingController searchTextController = TextEditingController();
  String _searchText = '';
  List<TeachingModel> teachings = [];
  Pagination pagination = Pagination(
    currentPage: 0,
    totalPages: 0,
    itemsPerPage: 0,
    totalItems: 0,
    hasPreviousPage: false,
    hasNextPage: false,
  );
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeAppData());
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchTextController.dispose();
    super.dispose();
  }

  Future<void> _initializeAppData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userData = userProvider.currentUser;
    await Provider.of<BibleThemeProvider>(context, listen: false)
        .loadSavedTheme();
    await _loadData(1, "");
  }

  Future<void> _loadData(page, filter) async {
    setState(() {
      teachings = [];
    });
    final responseTeaching = await getAllTeaching(page, 10, filter, "");
    if (responseTeaching.error != null) {
      await showCustomDialog(
        context,
        message: responseTeaching.error!,
        dialogType: DialogType.error,
      );
      return;
    }
    setState(() {
      teachings = responseTeaching.data['data']
          .map((teaching) => TeachingModel.fromJson(removeTypename(teaching)))
          .cast<TeachingModel>()
          .toList();

      pagination =
          Pagination.fromJson(removeTypename(responseTeaching.data["meta"]));
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<BibleThemeProvider>(context, listen: false);
    currentTheme = themeProvider.themeData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.0,
          ),
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: StylesApp(context).sizeTextFormField.width,
          ),
          child: TextFormField(
            controller: searchTextController,
            style: StylesApp(context).textStyleSmallBlack,
            decoration: StylesApp(context).inputDecorationOutlineStyle.copyWith(
                  hintText: 'Buscar Tema...',
                  border: OutlineInputBorder(),
                  suffixIcon: _searchText.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              cleanSearch();
                            });
                          },
                        )
                      : Icon(Icons.search),
                ),
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
              _onSearchChanged(value);
            },
          ),
        ),
        SizedBox(
          height: 25.0,
        ),
        // body de los resultados de la búsqueda
        Expanded(
          child: teachings.isEmpty
              ? LoadingIndicator()
              : ListView.builder(
                  itemCount: teachings.length,
                  itemBuilder: (context, int index) {
                    return CardTeachingWidget(
                        data: teachings[index],
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DialogInternalTeaching(
                                    data: teachings[index],
                                    currentTheme: currentTheme);
                              });
                        });
                  },
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: pagination.hasPreviousPage
                  ? () async {
                      _loadData(pagination.currentPage - 1, "");
                    }
                  : null,
              icon: Icon(Icons.arrow_back),
              color: currentTheme.buttonColor,
            ),
            IconButton(
              onPressed: pagination.hasNextPage
                  ? () async {
                      _loadData(pagination.currentPage + 1, "");
                    }
                  : null,
              icon: Icon(Icons.arrow_forward),
              color: currentTheme.buttonColor,
            ),
          ],
        )
      ],
    );
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) async {
    if (query.isEmpty) return; // No buscar si está vacío

    try {
      _loadData(1, query);
    } catch (e) {
      print("error al filtrar $e");
    }
  }

  void cleanSearch() {
    _debounceTimer?.cancel(); // Si usas la opción 2
    searchTextController.clear();
    _searchText = '';
    setState(() {
      _searchText = '';
    });
  }
}

class DialogInternalTeaching extends StatelessWidget {
  final TeachingModel data;
  const DialogInternalTeaching({
    super.key,
    required this.data,
    required this.currentTheme,
  });

  final BibleTheme currentTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: currentTheme.backgroundColor,
      child: Column(
        children: [
          AppBarHeaderWidget(
            backColor: StyleColor.turquoise,
            buttonColor: StyleColor.orange,
            textButtonColor: Colors.white,
            title: 'Enseñanza',
            styleText: StylesApp(context).textStyleBody7,
            onRoute: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 8),
          Container(
            constraints: BoxConstraints(maxWidth: 211.0),
            child: Column(
              children: [
                Center(
                  child: Image.network(
                      '${GraphQLConfig.urlServidor}${data.img.urlImg}'),
                ),
                Text(
                  textAlign: TextAlign.center,
                  data.title,
                  style: StylesApp(context)
                      .textStyleBody16
                      .copyWith(color: StyleColor.orange),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.0),
            height: 500, // Altura fija para hacer el scroll visible
            child: Scrollbar(
              thumbVisibility:
                  true, // Hace que el scrollbar sea siempre visible
              trackVisibility: true, // Opcional: muestra la pista del scroll
              thickness: 6.0, // Grosor del scrollbar
              radius: Radius.circular(10), // Bordes redondeados
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8), // Espacio interno
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    textAlign: TextAlign.justify,
                    data.description,
                    style: StylesApp(context)
                        .textStyleBody16
                        .copyWith(color: currentTheme.textColor),
                  ),
                ),
              ),
            ),
          ),
          ButtonThemeWidget(
            text: "Referencias Biblicas",
            buttonStyle: StylesApp(context).btnWidgetSmall,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogReference(currentTheme: currentTheme);
                  });
            },
          )
        ],
      ),
    );
  }
}

class DialogReference extends StatelessWidget {
  const DialogReference({
    super.key,
    required this.currentTheme,
  });

  final BibleTheme currentTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: currentTheme.backgroundColor,
      child: Column(
        children: [
          AppBarHeaderWidget(
            backColor: StyleColor.turquoise,
            buttonColor: StyleColor.orange,
            textButtonColor: Colors.white,
            title: 'Referencias',
            styleText: StylesApp(context).textStyleBody7,
            onRoute: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 8),
          Container(
            constraints: BoxConstraints(maxWidth: 230.0),
            child: Column(
              children: [
                Text(
                  textAlign: TextAlign.center,
                  "Como encontrar la ayuda de Dios",
                  style: StylesApp(context)
                      .textStyleBody18
                      .copyWith(color: StyleColor.turquoise),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, int index) {
                return Container(
                  // padding: EdgeInsets.all(8.0),
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    children: [
                      ButtonThemeWidget(
                        text: "Salmo 86:1-17",
                        buttonStyle: StylesApp(context).btnWidgetSmall,
                      ),
                      SizedBox(
                        height: 15.0,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardTeachingWidget extends StatefulWidget {
  final TeachingModel data;
  final void Function()? onTap;
  const CardTeachingWidget({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  State<CardTeachingWidget> createState() => _CardTeachingWidgetState();
}

class _CardTeachingWidgetState extends State<CardTeachingWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          padding: EdgeInsets.all(8.0),
          width: MediaQuery.sizeOf(context).width,
          child: Column(children: [
            Container(
                width: MediaQuery.sizeOf(context).width,
                constraints: BoxConstraints(minHeight: 150, maxHeight: 150),
                child: Image.network(
                    '${GraphQLConfig.urlServidor}${widget.data.img.urlImg}')
                //Image.asset("assets/ensenanza.jpeg"),
                ),
            SizedBox(
              height: 8.0,
            ),
            Text(widget.data.title)
          ])),
    );
  }
}

// widget para pestaña  libro
class SearchByTextWidget extends StatefulWidget {
  const SearchByTextWidget({
    super.key,
  });

  @override
  State<SearchByTextWidget> createState() => _SearchByTextWidgetState();
}

class _SearchByTextWidgetState extends State<SearchByTextWidget> {
  late BibleTheme currentTheme;
  TextEditingController searchTextController = TextEditingController();
  List<VersionModel> listBibleVersions = [];
  List<ModelData> bibleVersions = [];
  ModelData? versionSelected = ModelData(label: "", value: "");

  List searchResult = [
    {
      "moderName": "Deuteronomio",
      "chapter": "6",
      "verse": "4",
      "text": "Escucha, Israel: Jehová nuestro Dios, Jehová uno es."
    },
    {
      "moderName": "Deuteronomio",
      "chapter": "5",
      "verse": "1",
      "text":
          "Moisés convocó a todo Israel, y les dijo: Escucha, Israel, los estatutos y los decretos que hablo hoy a vuestros oídos."
    },
    {
      "moderName": "Deuteronomio 6:4",
      "chapter": "6",
      "verse": "4",
      "text": "Escucha, Israel: Jehová nuestro Dios, Jehová uno es."
    },
    {
      "moderName": "Deuteronomio 6:4",
      "chapter": "6",
      "verse": "4",
      "text": "Escucha, Israel: Jehová nuestro Dios, Jehová uno es."
    },
    {
      "moderName": "Deuteronomio 6:4",
      "chapter": "6",
      "verse": "4",
      "text": "Escucha, Israel: Jehová nuestro Dios, Jehová uno es."
    },
  ];
  String _searchText = '';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.0,
          ),
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: StylesApp(context).sizeTextFormField.width,
          ),
          child: Column(
            children: [
              Container(
                child: CustomDropdownBottomWidget(
                  hintText: "Seleccione la version",
                  items: bibleVersions,
                  onChanged: (ModelData? version) async {
                    if (kDebugMode) {
                      print("version seleccionada ${version!.value}");
                    }
                    setState(() {
                      versionSelected = version;
                    });
                  },
                  selectedItem: versionSelected!.value.isNotEmpty
                      ? bibleVersions.firstWhere((element) =>
                          element.value.toLowerCase() ==
                          versionSelected?.value.toLowerCase())
                      : null,
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              TextFormField(
                controller: searchTextController,
                style: StylesApp(context).textStyleSmallBlack,
                decoration:
                    StylesApp(context).inputDecorationOutlineStyle.copyWith(
                          hintText: 'Buscar...',
                          border: OutlineInputBorder(),
                          suffixIcon: _searchText.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      cleanSearch();
                                    });
                                  },
                                )
                              : Icon(Icons.search),
                        ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 25.0,
        ),
        // body de los resultados de la búsqueda
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, int index) {
              return CardSearchTextWidget(
                data: "",
                currentTheme: currentTheme,
                onAction: () {
                  showModalBottomSheet(
                      backgroundColor: currentTheme.backgroundColor,
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text("Ver Capitulo",
                                  style: StylesApp(context)
                                      .textStyleBody12
                                      .copyWith(color: currentTheme.textColor)),
                              trailing: Icon(
                                Icons.play_arrow_outlined,
                                color: currentTheme.buttonColor,
                                size: 25,
                              ),
                              onTap: () {},
                            ),
                            Divider(
                              color: StyleColor.grayMedium,
                              height: 2.0,
                              thickness: 4.0,
                            ),
                            ListTile(
                              title: Text("Copiar",
                                  style: StylesApp(context)
                                      .textStyleBody12
                                      .copyWith(color: currentTheme.textColor)),
                              trailing: Icon(Icons.file_copy,
                                  color: currentTheme.buttonColor, size: 25),
                              onTap: () {},
                            ),
                            Divider(
                              color: StyleColor.grayMedium,
                              height: 2,
                              thickness: 4.0,
                            ),
                            ListTile(
                              title: Text("Favoritos",
                                  style: StylesApp(context)
                                      .textStyleBody12
                                      .copyWith(color: currentTheme.textColor)),
                              trailing: Icon(Icons.star_border,
                                  color: currentTheme.buttonColor, size: 25),
                              onTap: () {},
                            ),
                            Divider(
                              color: StyleColor.grayMedium,
                              height: 2,
                              thickness: 4.0,
                            ),
                          ],
                        );
                      });
                },
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () async {},
              icon: Icon(Icons.arrow_back),
              color: currentTheme.buttonColor,
            ),
            IconButton(
              onPressed: () async {},
              icon: Icon(Icons.arrow_forward),
              color: currentTheme.buttonColor,
            ),
          ],
        )
      ],
    );
  }

  void cleanSearch() {
    setState(() {
      _searchText = '';
      searchTextController.text = '';
    });
  }
}

class CardSearchTextWidget extends StatelessWidget {
  const CardSearchTextWidget(
      {super.key,
      required this.currentTheme,
      required this.data,
      required this.onAction});

  final BibleTheme currentTheme;
  final data;
  final void Function()? onAction;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            constraints: BoxConstraints(minHeight: 75),
            decoration: BoxDecoration(
                color: currentTheme.backgroundColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.0,
                    offset: Offset(0, 4),
                    color: StyleColor.black.withValues(alpha: 0.25),
                  )
                ]),
            width: MediaQuery.sizeOf(context).width,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Deuteronomio 6:4",
                        style: StylesApp(context)
                            .textStyleBody14
                            .copyWith(color: StyleColor.orange),
                      ),
                      Text(
                        '"Escucha, Israel: Jehová nuestro Dios, Jehová uno es."',
                        style: StylesApp(context)
                            .textStyleBody12
                            .copyWith(color: currentTheme.textColor),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: IconButton(
                    icon: Icon(Icons.more_vert_rounded),
                    onPressed: onAction,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }
}

// widget para pestaña  libro
class SearchByBookWidget extends StatefulWidget {
  const SearchByBookWidget({
    super.key,
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
  bool loadingChapter = false;
  bool loadingVerses = false;
  bool verseRange = false;
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  print("version seleccionada ${book!.value}");
                }
                setState(() {
                  bookSelected = book;
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              textAlign: TextAlign.start,
              "Capítulos",
              style: StylesApp(context)
                  .textStyleBody16
                  .copyWith(color: currentTheme.textColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                  color: currentTheme.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: [
                    BoxShadow(
                        color: StyleColor.black.withValues(alpha: 0.25),
                        blurRadius: 4.0,
                        offset: Offset(0, 4))
                  ]),
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              height: 280,
              child: GridButtonWidget<ChapterModel>(
                  loading: loadingChapter,
                  data: chapters,
                  currentTheme: currentTheme,
                  onTap: (chapter) async {
                    if (kDebugMode) {
                      print('Capítulo seleccionado: ${chapter.chapter}');
                      loadVerses(chapter.id);
                    }
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              textAlign: TextAlign.start,
              "Versículos",
              style: StylesApp(context)
                  .textStyleBody16
                  .copyWith(color: currentTheme.textColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                  color: currentTheme.backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: [
                    BoxShadow(
                        color: StyleColor.black.withValues(alpha: 0.25),
                        blurRadius: 4.0,
                        offset: Offset(0, 4))
                  ]),
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              height: 280,
              child: GridButtonWidget<VerseModel>(
                  loading: loadingVerses,
                  data: verses, // List<VerseModel>
                  currentTheme: currentTheme,
                  onTap: (verse) {
                    if (kDebugMode) {
                      print('Versículo seleccionado: ${verse.verse}');
                    }
                  }),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: CheckboxListTile(
                  activeColor: currentTheme.buttonColor,
                  title: Text("Rango de versículos"),
                  value: verseRange,
                  onChanged: (bool? value) {
                    setState(() => verseRange = value!);
                  },
                ),
              ),
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
    } else {
      setState(() {
        // guardamos los capítulos de un libro
        chapters = responseChapterWithVerses.data
            .map<ChapterModel>((chapter) => ChapterModel.fromJson(chapter))
            .toList();
      });
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
      loadingVerses = false;
    });
  }
}
