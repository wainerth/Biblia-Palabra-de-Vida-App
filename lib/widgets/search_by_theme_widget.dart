import 'dart:async';

import 'package:biblia_palabra_de_vida_app/config/api_config.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
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
  final translationProvider = AppTranslationProvider();

  LoginUser? userData;

  late BibleTheme currentTheme;
  TextEditingController searchTextController = TextEditingController();
  String _searchText = '';
  List<TeachingModel> teachings = [];
  int itemPerPageValue = 50;
  bool loading = false;

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

  // Función para determinar si es tablet
  bool get isTablet {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width >= 600;
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
      loading = true;
    });
    try {
      final responseTeaching = await getAllTeaching(page, limit, filter, "");
      if (responseTeaching.error != null) {
        loading = false;
        if (!mounted) return;

        // Guardar el contexto localmente para usar después de async
        final currentContext = context;

        await showCustomDialogWithAction(context,
            message: responseTeaching.error!,
            dialogType: DialogTypeAction.error,
            buttonOk: translationProvider.tr("common.cancel"),
            actionCallbackOk: () {
              Navigator.pop(currentContext);
            },
            showAction: true,
            textButton: translationProvider.tr("common.retry"),
            actionCallback: () async {
              Navigator.pop(currentContext);
              _loadData(1, itemPerPageValue, _searchText);
            });
        return;
      }
      setState(() {
        teachings = responseTeaching.data['data']
            .map((teaching) => TeachingModel.fromJson(removeTypename(teaching)))
            .cast<TeachingModel>()
            .toList();

        pagination = PaginationInfo.fromJson(
            removeTypename(responseTeaching.data["meta"]));
        loading = false;
      });
    } catch (e) {
      loading = false;
      if (!mounted) return;

      // Guardar el contexto localmente para usar después de async
      final currentContext = context;

      await showCustomDialogWithAction(context,
          message: e.toString(),
          dialogType: DialogTypeAction.error,
          buttonOk: translationProvider.tr("common.cancel"),
          actionCallbackOk: () {
            Navigator.pop(currentContext);
          },
          showAction: true,
          textButton: translationProvider.tr("common.retry"),
          actionCallback: () async {
            Navigator.pop(currentContext);
            _loadData(1, itemPerPageValue, _searchText);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<BibleThemeProvider>();
    currentTheme = themeProvider.themeData;
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
    );
  }

  // ============ LAYOUT PARA TABLET ============
  Widget _buildTabletLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: spacingHeight),

        // CABECERA DE BÚSQUEDA PARA TABLET
        _buildTabletSearchHeader(),

        SizedBox(height: spacingHeight),

        // RESULTADOS EN GRID DE 2 COLUMNAS
        Expanded(
          child: _buildTabletResults(),
        ),

        // PAGINACIÓN
        _buildPagination(),
      ],
    );
  }

  // ============ LAYOUT PARA MÓVIL (MANTENIDO) ============
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.0,
          ),
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: currentTheme.buttonColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            constraints: BoxConstraints(
              minWidth: 160.0,
              maxWidth: StylesApp(context).sizeTextFormField.width,
            ),
            child: TextFormField(
              controller: searchTextController,
              style: StylesApp(context).textStyleSmallBlack.copyWith(
                    color: currentTheme.textColor,
                    fontSize: 16,
                  ),
              decoration: InputDecoration(
                fillColor: currentTheme.backgroundColor,
                filled: true,
                hintStyle: StylesApp(context).textStyleBody15.copyWith(
                      color: currentTheme.textColor.withValues(alpha: 0.6),
                      fontSize: 15,
                    ),
                hintText: translationProvider
                    .tr("search_by_theme.search.placeholder"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, // Sin borde visible
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: currentTheme.textColor
                        .withValues(alpha: 0.6), // Borde cuando está habilitado
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: currentTheme.textColor, // Borde cuando está enfocado
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red, // Borde de error
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: currentTheme.textColor.withValues(
                        alpha: 0.3), // Borde cuando está deshabilitado
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: currentTheme.buttonColor,
                        ),
                        onPressed: () {
                          setState(() {
                            cleanSearch();
                          });
                        },
                      )
                    : Icon(Icons.search, color: currentTheme.buttonColor),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
                _onSearchChanged(value);
              },
            ),
          ),
        ),
        SizedBox(
          height: 25.0,
        ),
        // body de los resultados de la búsqueda
        Expanded(
          child: loading
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

  // ============ CABECERA DE BÚSQUEDA PARA TABLET ============
  Widget _buildTabletSearchHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TÍTULO
          Row(
            children: [
              Icon(
                Icons.category,
                color: currentTheme.buttonColor,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                translationProvider.tr("search_by_theme.search.label_text"),
                style: StylesApp(context).textStyleBody18.copyWith(
                      color: currentTheme.textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // CAMPO DE BÚSQUEDA
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: currentTheme.buttonColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchTextController,
                    style: StylesApp(context).textStyleSmallBlack.copyWith(
                          color: currentTheme.textColor,
                          fontSize: 16,
                        ),
                    decoration: InputDecoration(
                      hintText: translationProvider
                          .tr("search_by_theme.search.placeholder_tablet"),
                      hintStyle: StylesApp(context).textStyleBody15.copyWith(
                            color:
                                currentTheme.textColor.withValues(alpha: 0.6),
                            fontSize: 15,
                          ),
                      fillColor: currentTheme.backgroundColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        borderSide: BorderSide.none, // Sin borde visible
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      suffixIcon: _searchText.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear,
                                  color: currentTheme.textColor
                                      .withValues(alpha: 0.7)),
                              onPressed: () {
                                cleanSearch();
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                      _onSearchChanged(value);
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: currentTheme.buttonColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.search, color: Colors.white, size: 28),
                    onPressed: () {
                      if (_searchText.isNotEmpty) {
                        _performSearch(_searchText);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // INFORMACIÓN DE BÚSQUEDA
          if (_searchText.isNotEmpty && teachings.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: currentTheme.buttonColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: currentTheme.buttonColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.library_books,
                          color: currentTheme.buttonColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          translationProvider.trParams(
                              "search_by_theme.search.result_count",
                              {"count": pagination.totalItems.toString()}),
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: currentTheme.textColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: currentTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: currentTheme.buttonColor,
                      ),
                    ),
                    child: Text(
                      translationProvider
                          .trParams("search_by_theme.search.page_info", {
                        "current": pagination.currentPage.toString(),
                        "total": pagination.totalPages.toString()
                      }),
                      style: StylesApp(context).textStyleBody12.copyWith(
                            color:
                                currentTheme.textColor.withValues(alpha: 0.7),
                          ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ============ RESULTADOS PARA TABLET (GRID 2 COLUMNAS) ============
  Widget _buildTabletResults() {
    if (loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: currentTheme.buttonColor,
            ),
            SizedBox(height: 16),
            Text(
              translationProvider.tr("search_by_theme.search.searching"),
              style: StylesApp(context).textStyleBody14.copyWith(
                    color: currentTheme.textColor.withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
      );
    }

    if (teachings.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          // childAspectRatio: 1.2, // Rectángulos más cuadrados
        ),
        itemCount: teachings.length,
        itemBuilder: (context, index) {
          return _buildTabletTeachingCard(teachings[index]);
        },
      ),
    );
  }

  // ============ TARJETA DE TEMA PARA TABLET ============
  Widget _buildTabletTeachingCard(TeachingModel teaching) {
    return Card(
      color: currentTheme.backgroundColor,
      shadowColor: currentTheme.backgroundColor,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: currentTheme.buttonColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CABECERA CON TÍTULO
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: currentTheme.buttonColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: currentTheme.buttonColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      translationProvider.tr("search_by_theme.card.tag"),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      teaching.title,
                      style: StylesApp(context).textStyleBody16.copyWith(
                            color: currentTheme.textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // CONTENIDO
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        // width: MediaQuery.,
                        constraints:
                            BoxConstraints(minHeight: 81, maxHeight: 81),
                        child: Image.network(
                            // color: widget.currentTheme.textColor,
                            '${ApiConfig.baseUrl}${teaching.img.urlImg}'),
                      ),
                    ),
                    // DESCRIPCIÓN
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          teaching.description,
                          style: StylesApp(context).textStyleBody14.copyWith(
                                color: currentTheme.textColor
                                    .withValues(alpha: 0.8),
                                fontSize: 14,
                                height: 1.4,
                              ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // INFORMACIÓN ADICIONAL
                    Row(
                      children: [
                        Icon(
                          Icons.category,
                          size: 16,
                          color: currentTheme.buttonColor,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            translationProvider
                                .tr("search_by_theme.card.category"),
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  currentTheme.textColor.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // BOTÓN DE ACCIÓN
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: currentTheme.buttonColor,
                  ),
                ),
              ),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    _showTeachingDetails(teaching);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        translationProvider
                            .tr("search_by_theme.card.view_button"),
                        style: TextStyle(
                          color: currentTheme.buttonColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: currentTheme.buttonColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ ESTADO VACÍO ============
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 100 : 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: isTablet ? 80 : 60,
              color: currentTheme.textColor.withValues(alpha: 0.3),
            ),
            SizedBox(height: 20),
            Text(
              translationProvider.tr("search_by_theme.results.empty.title"),
              style: StylesApp(context).textStyleBody18.copyWith(
                    color: currentTheme.textColor,
                    fontSize: isTablet ? 22 : 18,
                  ),
            ),
            SizedBox(height: 12),
            Text(
              _searchText.isEmpty
                  ? translationProvider
                      .tr("search_by_theme.results.empty.message_start")
                  : translationProvider.trParams(
                      "search_by_theme.results.empty.message_not_found",
                      {"query": _searchText}),
              textAlign: TextAlign.center,
              style: StylesApp(context).textStyleBody14.copyWith(
                    color: currentTheme.textColor.withValues(alpha: 0.6),
                    fontSize: isTablet ? 16 : 14,
                  ),
            ),
            SizedBox(height: isTablet ? 100 : 50),
          ],
        ),
      ),
    );
  }

  // ============ PAGINACIÓN ============
  Widget _buildPagination() {
    if (teachings.isEmpty) return SizedBox();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 12,
        vertical: 12,
      ),
      child: CustomPagination(
        pagination: PaginationInfo(
          currentPage: pagination.currentPage,
          itemsPerPage: pagination.itemsPerPage,
          totalPages: pagination.totalPages,
          hasPreviousPage: pagination.hasPreviousPage,
          hasNextPage: pagination.hasNextPage,
          totalItems: pagination.totalItems,
        ),
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
        itemsPerPage: itemsPerPage,
      ),
    );
  }

  // ============ MÉTODO PARA MOSTRAR DETALLES ============
  void _showTeachingDetails(TeachingModel teaching) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: currentTheme.backgroundColor,
          insetPadding: EdgeInsets.symmetric(
            horizontal:
                isTablet ? MediaQuery.of(context).size.width * 0.12 : 16.0,
            vertical: isTablet ? 40.0 : 24.0,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 600.0 : double.infinity,
              maxHeight: isTablet
                  ? MediaQuery.of(context).size.height * 0.85
                  : double.infinity,
            ),
            child: DialogInternalTeaching(
              data: teaching,
              currentTheme: currentTheme,
              onActionReferences: (InputDataSearchModel data) {
                if (widget.onActionTheme != null) {
                  widget.onActionTheme!(data);
                }
                Navigator.pop(context);
              },
              isTablet: isTablet,
            ),
          ),
        );
      },
    );
  }

  // ============ MÉTODOS DE BÚSQUEDA ============
  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) async {
    // if (query.isEmpty) return;

    try {
      _loadData(1, itemPerPageValue, query);
    } catch (e) {
      if (kDebugMode) {
        print("error al filtrar $e");
      }
    }
  }

  void cleanSearch() {
    _debounceTimer?.cancel();
    searchTextController.clear();
    _searchText = '';
    setState(() {
      _searchText = '';
    });
    _performSearch('');
  }
}
