import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/search_bible_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

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