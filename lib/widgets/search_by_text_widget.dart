import 'dart:async';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/custom_pagination.dart';
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
  bool loading = false;
  List<WordSearchResult> searchResult = [];
  List<int> itemsPerPage = [
    5,
    10,
    15,
    25,
    50,
    100,
  ];
  int itemPerPageValue = 50;
  PaginationInfo pagination = PaginationInfo(
    currentPage: 0,
    totalPages: 0,
    itemsPerPage: 0,
    totalItems: 0,
    hasPreviousPage: false,
    hasNextPage: false,
  );
  Timer? _debounceTimer;

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
  void dispose() {
    _debounceTimer?.cancel();
    searchTextController.dispose();
    super.dispose();
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
                readOnly: versionSelected!.value.isEmpty || loading,
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
                  _onSearchChanged(value);
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
          child: loading
              ? LoadingIndicator()
              : searchResult.isEmpty
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              "No hay resultados...",
                              style: StylesApp(context)
                                  .textStyleBody18
                                  .copyWith(color: currentTheme.textColor),
                            ),
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: searchResult.length,
                      itemBuilder: (context, int index) {
                        return CardSearchTextWidget(
                          data: searchResult[index],
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
                                                .copyWith(
                                                    color: currentTheme
                                                        .textColor)),
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
                                                .copyWith(
                                                    color: currentTheme
                                                        .textColor)),
                                        trailing: Icon(Icons.file_copy,
                                            color: currentTheme.buttonColor,
                                            size: 25),
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
                                                .copyWith(
                                                    color: currentTheme
                                                        .textColor)),
                                        trailing: Icon(Icons.star_border,
                                            color: currentTheme.buttonColor,
                                            size: 25),
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
       
        CustomPagination(
          pagination: PaginationInfo(
              currentPage: pagination.currentPage,
              itemsPerPage: pagination.itemsPerPage,
              totalPages: pagination.totalPages,
              hasPreviousPage: pagination.hasPreviousPage,
              hasNextPage: pagination.hasNextPage,
              totalItems: pagination.totalItems),
          itemPerPageValue: itemPerPageValue,
          currentTheme: currentTheme,
          onPageChanged: (newPage, newPerPage) async {
            if (versionSelected!.value.isNotEmpty) {
              await _loadData(
                newPage,
                newPerPage,
                versionSelected!.value,
                _searchText,
              );
            }
          },
          itemsPerPage: itemsPerPage, // Opcional: personaliza los valores
        )
      ],
    );
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 800), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) async {
    if (query.isEmpty) return; // No buscar si está vacío

    try {
      _loadData(1, itemPerPageValue, versionSelected!.value, query);
    } catch (e) {
      print("error al filtrar $e");
    }
  }

  void cleanSearch() {
    setState(() {
      _searchText = '';
      searchTextController.text = '';
    });
  }

  Future<void> _loadData(
      int page, int limit, String versionId, String searchWord) async {
    setState(() {
      loading = true;
    });
    final responseResult =
        await getWordsConcordance(page, limit, versionId, searchWord);
    if (responseResult.error != null) {
      await showCustomDialog(
        context,
        message: responseResult.error!,
        dialogType: DialogType.error,
      );
      setState(() {
        loading = false;
      });
      return;
    }

    setState(() {
      searchResult = responseResult.data['data']
          .map<WordSearchResult>(
              (wordSearch) => WordSearchResult.fromJson(wordSearch))
          .toList();

      pagination =
          PaginationInfo.fromJson(removeTypename(responseResult.data["meta"]));
      loading = false;
    });
  }
}
