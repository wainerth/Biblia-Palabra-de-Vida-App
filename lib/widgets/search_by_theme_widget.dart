import 'dart:async';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/dialog_internal_teaching.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SearchByThemeWidget extends StatefulWidget {
  final void Function(InputDataSearchModel data)? onActionTheme;
  const SearchByThemeWidget({
    super.key,
    this.onActionTheme,
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
    setState(() {
      teachings = [];
    });
    final responseTeaching = await getAllTeaching(page, limit, filter, "");
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

      pagination = PaginationInfo.fromJson(
          removeTypename(responseTeaching.data["meta"]));
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
                        currentTheme: currentTheme,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DialogInternalTeaching(
                                  data: teachings[index],
                                  currentTheme: currentTheme,
                                  onActionReferences:
                                      (InputDataSearchModel data) {
                                    widget.onActionTheme!(data);
                                    Navigator.pop(context);
                                  },
                                );
                              });
                        });
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
            if (teachings.isNotEmpty) {
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
      _loadData(1,itemPerPageValue, query);
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
