import 'dart:async';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SearchByTextWidget extends StatefulWidget {
  final VersionModel? version;
  final void Function(InputDataSearchModel data)? onActionTabText;
  const SearchByTextWidget({
    super.key,
    this.version,
    this.onActionTabText,
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
      if (widget.version != null) {
        setState(() {
          versionSelected = ModelData(
              label: widget.version!.version,
              value: widget.version!.id,
              originalData: widget.version);
        });
      }
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
              SizedBox(
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: versionSelected!.value.isEmpty || loading,
                      controller: searchTextController,
                      style: StylesApp(context).textStyleSmallBlack,
                      decoration: StylesApp(context)
                          .inputDecorationOutlineStyle
                          .copyWith(
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
                  ),
                  SizedBox(width: 8.0), // Espacio entre el input y el botón
                  ElevatedButton(
                    onPressed: _searchText.isNotEmpty
                        ? () {
                            _onSearchChanged(_searchText);
                          }
                        : null,
                    child: Text(
                      'Buscar',
                      style: StylesApp(context)
                          .textStyleBody14
                          .copyWith(color: currentTheme.buttonTextColor),
                    ),
                  ),
                ],
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
                  ? SizedBox(
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
                                        onTap: () {
                                          final InputDataSearchModel inputData =
                                              InputDataSearchModel(
                                            bookId: searchResult[index].book.id,
                                            chapterId:
                                                searchResult[index].chapter.id!,
                                            startVerseId:
                                                searchResult[index].verse.id,
                                            endVerseId: "",
                                            versionId: versionSelected!.value,
                                          );
                                          if (widget.onActionTabText != null) {
                                            widget.onActionTabText!(inputData);
                                          }
                                          Navigator.pop(context);
                                        },
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
                                        onTap: () {
                                          _copyToClipboard(
                                              context, searchResult[index]);
                                        },
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
                                        onTap: () {
                                          addVerseFavorite(
                                              context, searchResult[index]);
                                        },
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
              setState(() {
                itemPerPageValue = newPerPage;
              });
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
      FocusScope.of(context).unfocus();
      _performSearch(query);
    });
  }

  void _performSearch(String query) async {
    if (query.isEmpty) return; // No buscar si está vacío

    try {
      _loadData(1, itemPerPageValue, versionSelected!.value, query);
    } catch (e) {
      if (kDebugMode) {
        print("error al filtrar $e");
      }
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
      searchResult = [];
      loading = true;
    });
    final responseResult =
        await getWordsConcordance(page, limit, versionId, searchWord);
    if (responseResult.error != null) {
      if (!mounted) return;
      await showCustomDialog(
        context,
        message: responseResult.error!,
        dialogType: DialogType.error,
      );
      setState(() => loading = false);
      return;
    }
    setState(() {
      if (responseResult.data['data'] != null &&
          responseResult.data['data'].isNotEmpty) {
        searchResult = responseResult.data['data']
            .map<WordSearchResult>(
                (wordSearch) => WordSearchResult.fromJson(wordSearch))
            .toList();

        pagination = PaginationInfo.fromJson(
            removeTypename(responseResult.data["meta"]));
      }

      loading = false;
    });
  }

  Future<void> _copyToClipboard(
      BuildContext context, WordSearchResult data) async {
    final baseUrl = "${GraphQLConfig.urlServidor}OfficialBible";
    final copyString =
        "${data.book.modernName} ${data.chapter.chapter}:${data.verse.verse} \n${data.verse.text}\n$baseUrl";
    await Clipboard.setData(ClipboardData(text: copyString));
    if (mounted) {
      final currentContext = context;

      if (currentContext.mounted) {
        // Mostrar diálogo de confirmación
        await showCustomDialog(
          currentContext,
          message:
              "El capítulo ${data.chapter.chapter} del libro ${data.book.modernName}\nse ha copiado con éxito al portapapeles",
          dialogType: DialogType.info,
        );
      }
    }
  }

  void addVerseFavorite(BuildContext context, WordSearchResult data) async {
    LoadingService().showLoading(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.currentUser;
    final responseFavorite =
        await createNewVerseFavoriteByUser(userData!.userId, data.verse.id);
    if (responseFavorite.error != null) {
      LoadingService().hideLoading();
      if (mounted) {
        final currentContext = context;

        if (currentContext.mounted) {
          await showCustomDialog(currentContext,
              message: responseFavorite.error!, dialogType: DialogType.error);
        }
      }
    } else {
      LoadingService().hideLoading();
      if (mounted) {
        final currentContext = context;

        if (currentContext.mounted) {
          await showCustomDialog(currentContext,
              message: "Versículo Agregado a Favoritos",
              dialogType: DialogType.info);
        }
      }
    }
  }
}
