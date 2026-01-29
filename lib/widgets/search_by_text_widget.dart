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

  final FocusNode _searchFocusNode = FocusNode();

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
    // Inicializar datos de manera sincronía
    final catalogueProvider =
        Provider.of<CatalogueProvider>(context, listen: false);
    listBibleVersions = catalogueProvider.allBibleVersion;
    bibleVersions = catalogueProvider.allBibleVersion
        .map((v) => ModelData(value: v.id, label: v.version))
        .toList();

    if (widget.version != null) {
      versionSelected = ModelData(
        label: widget.version!.version,
        value: widget.version!.id,
        originalData: widget.version,
      );
    }
  }

  @override
  void dispose() {
    if (mounted) {
      _searchFocusNode.dispose();
      _debounceTimer?.cancel();
      searchTextController.dispose();
    }
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
        SizedBox(height: spacingHeight),

        if (!isTablet)
          _buildMobileSearchHeader()
        else
          _buildTabletSearchHeader(),

        SizedBox(height: spacingHeight),

        // Resultados de búsqueda
        Expanded(
          child: _buildSearchResults(),
        ),

        // Paginación
        _buildPagination(),
      ],
    );
  }

  // ============ MÓVIL: Cabecera de búsqueda ============
  Widget _buildMobileSearchHeader() {
    return Container(
      padding: horizontalPadding,
      constraints: BoxConstraints(
        minWidth: 160.0,
        maxWidth: StylesApp(context).sizeTextFormField.width,
      ),
      child: Column(
        children: [
          CustomDropdownBottomWidget(
            hintText: "Seleccione la versión",
            items: bibleVersions,
            currentTheme: currentTheme,
            onChanged: (ModelData? version) async {
              if (kDebugMode) {
                print("Versión seleccionada ${version!.value}");
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
          SizedBox(height: spacingHeight),
          Row(
            children: [
              Expanded(
                child: FocusScope(
                  node: FocusScopeNode(),
                  child: TextFormField(
                    focusNode: _searchFocusNode,
                    readOnly: versionSelected!.value.isEmpty || loading,
                    controller: searchTextController,
                    style: StylesApp(context).textStyleSmallBlack.copyWith(
                          color: currentTheme.textColor,
                          fontSize: isTablet ? 16 : 14,
                        ),
                    decoration: StylesApp(context)
                        .inputDecorationOutlineStyle
                        .copyWith(
                          fillColor: currentTheme.backgroundColor,
                          hintText: 'Buscar palabra o frase...',
                          hintStyle: StylesApp(context)
                              .textStyleBody12
                              .copyWith(
                                color: currentTheme.textColor.withOpacity(0.7),
                                fontSize: isTablet ? 15 : 14,
                              ),
                          // Border configurado con currentTheme
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  currentTheme.buttonColor, // Color del borde
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: currentTheme.textColor.withOpacity(
                                  0.6), // Borde cuando está habilitado
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: currentTheme
                                  .textColor, // Borde cuando está enfocado
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
                              color: currentTheme.textColor.withOpacity(
                                  0.3), // Borde cuando está deshabilitado
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: _searchText.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: currentTheme
                                        .buttonColor, // Color del icono
                                  ),
                                  onPressed: () {
                                    _safeClearSearch();
                                  },
                                )
                              : null,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 20 : 16,
                            vertical: isTablet ? 18 : 14,
                          ),
                          // Icono de búsqueda a la izquierda
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.search,
                              color: currentTheme.buttonColor,
                              size: isTablet ? 24 : 20,
                            ),
                          ),
                          // Estilo del texto dentro
                          filled: true,
                          labelStyle: TextStyle(
                            color: currentTheme.textColor,
                          ),
                        ),
                    onChanged: (value) {
                      if (!mounted) return;
                      _handleSearchChange(value);
                    },
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // Pequeño delay para asegurar que el teclado se muestra suavemente
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _searchText.isNotEmpty
                      ? currentTheme.buttonColor
                      : currentTheme.buttonColor.withValues(alpha: 0.5),
                ),
                child: IconButton(
                  icon: Icon(Icons.search,
                      color: Colors.white, size: isTablet ? 28 : 24),
                  onPressed: _searchText.isNotEmpty
                      ? () {
                          _onSearchChanged(_searchText);
                        }
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============ TABLET: Cabecera de búsqueda ============
  Widget _buildTabletSearchHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // Título de búsqueda
          Row(
            children: [
              Icon(
                Icons.search,
                color: currentTheme.buttonColor,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                "Búsqueda por Texto",
                style: StylesApp(context).textStyleBody18.copyWith(
                      color: currentTheme.textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Selector de versión y campo de búsqueda en fila
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de versión
              Container(
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: currentTheme.buttonColor,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: CustomDropdownBottomWidget(
                  border: false,
                  hintText: "Versión bíblica",
                  currentTheme: currentTheme,
                  items: bibleVersions,
                  onChanged: (ModelData? version) async {
                    if (kDebugMode) {
                      print("Versión seleccionada ${version!.value}");
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

              SizedBox(width: 16),

              // Campo de búsqueda
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
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
                        child: FocusScope(
                          node: FocusScopeNode(),
                          child: TextFormField(
                            focusNode: _searchFocusNode,
                            readOnly: versionSelected!.value.isEmpty || loading,
                            controller: searchTextController,
                            style:
                                StylesApp(context).textStyleSmallBlack.copyWith(
                                      color: currentTheme.textColor,
                                      fontSize: 16,
                                    ),
                            decoration: InputDecoration(
                              hintText:
                                  'Escribe aquí la palabra o frase a buscar...',
                              hintStyle: TextStyle(
                                color: currentTheme.textColor
                                    .withValues(alpha: 0.6),
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
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
                                        _safeClearSearch();
                                      },
                                    )
                                  : null,
                            ),
                            onChanged: (value) {
                              if (!mounted) return;
                              _handleSearchChange(value);
                            },
                            onTap: () {
                              _searchFocusNode.requestFocus();
                            },
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: _searchText.isNotEmpty
                              ? currentTheme.buttonColor
                              : currentTheme.buttonColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: IconButton(
                          icon:
                              Icon(Icons.search, color: Colors.white, size: 28),
                          onPressed: _searchText.isNotEmpty
                              ? () {
                                  _onSearchChanged(_searchText);
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Información de búsqueda
          if (_searchText.isNotEmpty && searchResult.isNotEmpty)
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
                          Icons.info_outline,
                          color: currentTheme.buttonColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "${pagination.totalItems} resultados para '$_searchText'",
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
                      "Página ${pagination.currentPage} de ${pagination.totalPages}",
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

  // ============ Resultados de búsqueda ============
  Widget _buildSearchResults() {
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
              "Buscando...",
              style: StylesApp(context).textStyleBody14.copyWith(
                    color: currentTheme.textColor.withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
      );
    }

    if (searchResult.isEmpty) {
      return _buildEmptyState();
    }

    return _buildResultsList();
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Padding(
        padding: horizontalPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: isTablet ? 100 : 50),
            Icon(
              Icons.search_off,
              size: isTablet ? 80 : 60,
              color: currentTheme.textColor.withValues(alpha: 0.3),
            ),
            SizedBox(height: 20),
            Text(
              "No hay resultados",
              style: StylesApp(context).textStyleBody18.copyWith(
                    color: currentTheme.textColor,
                    fontSize: isTablet ? 22 : 18,
                  ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 100 : 20,
              ),
              child: Text(
                versionSelected!.value.isEmpty
                    ? "Selecciona una versión bíblica para comenzar tu búsqueda"
                    : "Escribe una palabra o frase en el campo de búsqueda para encontrar versículos relacionados",
                textAlign: TextAlign.center,
                style: StylesApp(context).textStyleBody14.copyWith(
                      color: currentTheme.textColor.withValues(alpha: 0.6),
                      fontSize: isTablet ? 16 : 14,
                    ),
              ),
            ),
            SizedBox(height: isTablet ? 100 : 50),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    if (isTablet) {
      // Diseño para tablet (grid de 2 columnas)
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            // childAspectRatio: 2.0, // Rectángulos más anchos
          ),
          itemCount: searchResult.length,
          itemBuilder: (context, index) {
            return _buildTabletResultCard(searchResult[index]);
          },
        ),
      );
    } else {
      // Diseño para móvil (lista)
      return ListView.builder(
        padding: horizontalPadding,
        itemCount: searchResult.length,
        itemBuilder: (context, int index) {
          return _buildMobileResultCard(searchResult[index]);
        },
      );
    }
  }

  Widget _buildMobileResultCard(WordSearchResult data) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: CardSearchTextWidget(
        data: data,
        currentTheme: currentTheme,
        onAction: () {
          _showMobileOptionsModal(data);
        },
      ),
    );
  }

  Widget _buildTabletResultCard(WordSearchResult data) {
    return Card(
      color: currentTheme.backgroundColor,
      shadowColor: currentTheme.buttonColor,
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
            // Encabezado con referencia bíblica
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
                      "${data.book.modernName} ${data.chapter.chapter}:${data.verse.verse}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                ],
              ),
            ),

            // Texto del versículo
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(
                    data.verse.text,
                    style: StylesApp(context).textStyleBody14.copyWith(
                          color: currentTheme.textColor,
                          fontSize: 15,
                          height: 1.4,
                        ),
                  ),
                ),
              ),
            ),

            // Acciones
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: currentTheme.buttonColor,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabletActionButton(
                    icon: Icons.play_arrow,
                    label: "Ver",
                    onTap: () => _navigateToChapter(data),
                  ),
                  _buildTabletActionButton(
                    icon: Icons.content_copy,
                    label: "Copiar",
                    onTap: () => _copyToClipboard(context, data),
                  ),
                  _buildTabletActionButton(
                    icon: Icons.star_border,
                    label: "Favorito",
                    onTap: () => addVerseFavorite(context, data),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: currentTheme.buttonColor,
            size: 22,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: StylesApp(context).textStyleBody12.copyWith(
                  color: currentTheme.textColor.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }

  // ============ Paginación ============
  Widget _buildPagination() {
    if (searchResult.isEmpty) return SizedBox();

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
        itemsPerPage: itemsPerPage,
      ),
    );
  }

  // ============ MÉTODOS AUXILIARES ============
  void _showMobileOptionsModal(WordSearchResult data) {
    showModalBottomSheet(
      backgroundColor: currentTheme.backgroundColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Encabezado del modal
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: currentTheme.buttonColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: currentTheme.buttonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${data.book.numberBook} ${data.chapter.chapter}:${data.verse.verse}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        data.book.modernName,
                        style: StylesApp(context).textStyleBody14.copyWith(
                              color: currentTheme.textColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              // Opciones
              ListTile(
                leading: Icon(
                  Icons.play_arrow_outlined,
                  color: currentTheme.buttonColor,
                  size: 28,
                ),
                title: Text(
                  "Ver Capítulo",
                  style: StylesApp(context).textStyleBody14.copyWith(
                        color: currentTheme.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: currentTheme.textColor.withValues(alpha: 0.5),
                  size: 18,
                ),
                onTap: () {
                  Navigator.pop(context);
                  final InputDataSearchModel inputData = InputDataSearchModel(
                    bookId: data.book.id,
                    chapterId: data.chapter.id!,
                    startVerseId: data.verse.id,
                    endVerseId: "",
                    versionId: versionSelected!.value,
                  );
                  if (widget.onActionTabText != null) {
                    widget.onActionTabText!(inputData);
                  }
                },
              ),

              Divider(
                color: currentTheme.buttonColor,
                height: 1,
              ),

              ListTile(
                leading: Icon(
                  Icons.content_copy,
                  color: currentTheme.buttonColor,
                  size: 28,
                ),
                title: Text(
                  "Copiar Versículo",
                  style: StylesApp(context).textStyleBody14.copyWith(
                        color: currentTheme.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: currentTheme.textColor.withValues(alpha: 0.5),
                  size: 18,
                ),
                onTap: () {
                  _copyToClipboard(context, data);
                  Navigator.pop(context);
                },
              ),

              Divider(
                color: currentTheme.buttonColor,
                height: 1,
              ),

              ListTile(
                leading: Icon(
                  Icons.star_border,
                  color: currentTheme.buttonColor,
                  size: 28,
                ),
                title: Text(
                  "Agregar a Favoritos",
                  style: StylesApp(context).textStyleBody14.copyWith(
                        color: currentTheme.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: currentTheme.textColor.withValues(alpha: 0.5),
                  size: 18,
                ),
                onTap: () {
                  addVerseFavorite(context, data);
                  Navigator.pop(context);
                },
              ),

              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _navigateToChapter(WordSearchResult data) {
    final InputDataSearchModel inputData = InputDataSearchModel(
      bookId: data.book.id,
      chapterId: data.chapter.id!,
      startVerseId: data.verse.id,
      endVerseId: "",
      versionId: versionSelected!.value,
    );

    if (widget.onActionTabText != null) {
      widget.onActionTabText!(inputData);
    }
  }

  // ============ MÉTODOS EXISTENTES (MANTENIDOS) ============
  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 800), () {
      if (!mounted) return;
      _safeUnfocus();
      _performSearch(query);
    });
  }

  void _safeUnfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _performSearch(String query) async {
    if (query.isEmpty) return;
    try {
      _loadData(1, itemPerPageValue, versionSelected!.value, query);
    } catch (e) {
      if (kDebugMode) {
        print("error al filtrar $e");
      }
    }
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
          showDetails: false,
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

  void _safeClearSearch() {
    if (!mounted) return;

    setState(() {
      _searchText = '';
      searchTextController.text = '';
    });

    // Future.delayed(Duration(milliseconds: 100), () {
    //   if (mounted && _searchFocusNode.hasFocus) {
    //     _searchFocusNode.unfocus();
    //   }
    // });
  }

  void _handleSearchChange(String value) {
    if (!mounted) return;

    setState(() {
      _searchText = value;
    });
  }
}
