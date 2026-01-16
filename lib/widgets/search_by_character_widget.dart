import 'dart:async';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class SearchByCharacterWidget extends StatefulWidget {
  const SearchByCharacterWidget({
    super.key,
  });

  @override
  State<SearchByCharacterWidget> createState() =>
      _SearchByCharacterWidgetState();
}

class _SearchByCharacterWidgetState extends State<SearchByCharacterWidget> {
  LoginUser? userData;
  TextEditingController searchTextController = TextEditingController();
  String _searchText = '';
  late BibleTheme currentTheme;
  List<CharacterModel> characters = [];
  bool loading = false;
  int itemPerPageValue = 50;
  List<int> itemsPerPage = [
    5,
    10,
    15,
    25,
    50,
    100,
  ];
  PaginationInfo pagination = PaginationInfo(
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
    await _loadData(1, itemPerPageValue, "");
  }

  Future<void> _loadData(int page, int limit, filter) async {
    try {
      setState(() {
        loading = true;
        characters = [];
      });
      final responseCharacter =
          await getAllCharacters(page, limit, filter, false);
      if (responseCharacter.error != null) {
        setState(() {
          loading = false;
        });
        if (mounted) {
          await showCustomDialogWithAction(context,
              message: responseCharacter.error!,
              dialogType: DialogTypeAction.info,
              buttonOk: 'Volver',
              actionCallbackOk: () {
                Navigator.pop(context);
              },
              showAction: true,
              textButton: 'Reintentar',
              actionCallback: () async {
                Navigator.pop(context);
                await _loadData(1, limit, "");
              });
        }

        return;
      }
      setState(() {
        characters = responseCharacter.data['data']
            .map((character) =>
                CharacterModel.fromJson(removeTypename(character)))
            .cast<CharacterModel>()
            .toList();

        pagination = PaginationInfo.fromJson(
            removeTypename(responseCharacter.data["meta"]));
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      if (mounted) {
        await showCustomDialogWithAction(context,
            message: e.toString(),
            dialogType: DialogTypeAction.info,
            buttonOk: 'Volver',
            actionCallbackOk: () {
              Navigator.pop(context);
            },
            showAction: true,
            textButton: 'Reintentar',
            actionCallback: () async {
              Navigator.pop(context);
              await _loadData(1, limit, "");
            });
      }
    }
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
                  hintText: 'Buscar Personaje...',
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
          child: loading
              ? LoadingIndicator()
              : characters.isEmpty
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
                      itemCount: characters.length,
                      itemBuilder: (context, int index) {
                        return CardCharacterWidget(
                          currentTheme: currentTheme,
                          data: characters[index],
                          onTap: () {
                            if (characters[index].haveMoreCharacters) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    final relatedCharacters = characters[index]
                                        .relatedCharacters
                                        .map((related) => CharacterModel(
                                              id: related.id,
                                              name: related.name,
                                              description: related.description,
                                              relatedCharacters: [],
                                              color: related.color,
                                              newTestament: false,
                                              haveMoreCharacters:
                                                  related.haveMoreCharacters,
                                              typeNameChar:
                                                  related.typeNameChar,
                                              img: Img(
                                                  urlImg: related.img.urlImg),
                                              // Mapea todas las propiedades necesarias
                                            ))
                                        .toList();
                                    return Column(
                                      children: [
                                        AppBarHeaderWidget(
                                          backColor: StyleColor.turquoise,
                                          buttonColor: StyleColor.orange,
                                          textButtonColor: Colors.white,
                                          title: 'Personajes',
                                          styleText:
                                              StylesApp(context).textStyleBody7,
                                          onRoute: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(top: 12.0),
                                            color: currentTheme.backgroundColor,
                                            child: ListView.builder(
                                              itemCount:
                                                  relatedCharacters.length,
                                              itemBuilder:
                                                  (context, int index) {
                                                return CardCharacterWidget(
                                                  showTypeName: true,
                                                  currentTheme: currentTheme,
                                                  data:
                                                      relatedCharacters[index],
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return DialogInternalCharacter(
                                                              data:
                                                                  relatedCharacters[
                                                                      index],
                                                              currentTheme:
                                                                  currentTheme);
                                                        });
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogInternalCharacter(
                                        data: characters[index],
                                        currentTheme: currentTheme);
                                  });
                            }
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
            if (characters.isNotEmpty) {
              setState(() {
                itemPerPageValue = newPerPage;
              });
              await _loadData(
                newPage,
                newPerPage,
                _searchText,
              );
            }
          },
          itemsPerPage: itemsPerPage, // Opcional: personaliza los valores
        )
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     IconButton(
        //       onPressed: pagination.hasPreviousPage
        //           ? () async {
        //               _loadData(pagination.currentPage - 1, "");
        //             }
        //           : null,
        //       icon: Icon(Icons.arrow_back),
        //       color: currentTheme.buttonColor,
        //     ),
        //     IconButton(
        //       onPressed: pagination.hasNextPage
        //           ? () async {
        //               _loadData(pagination.currentPage + 1, "");
        //             }
        //           : null,
        //       icon: Icon(Icons.arrow_forward),
        //       color: currentTheme.buttonColor,
        //     ),
        //   ],
        // )
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
      _loadData(1, itemPerPageValue, query);
    } catch (e) {
      if (kDebugMode) {
        print("error al filtrar $e");
      }
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
