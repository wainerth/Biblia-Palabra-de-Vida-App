import 'dart:async';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
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

    if (isTablet) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  // ============ DISEÑO PARA TABLET ============
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

  // ============ DISEÑO PARA MÓVIL ============
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: spacingHeight),
        Container(
          // color: currentTheme.backgroundColor,
          padding: horizontalPadding,
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: StylesApp(context).sizeTextFormField.width,
          ),
          child: FocusScope(
            node: FocusScopeNode(),
            child: TextFormField(
              controller: searchTextController,
              style: StylesApp(context).textStyleSmallBlack,
              decoration:
                  StylesApp(context).inputDecorationOutlineStyle.copyWith(
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
        ),
        SizedBox(height: spacingHeight),
        Expanded(
          child: _buildMobileResults(),
        ),
        _buildPagination(),
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
                Icons.people,
                color: currentTheme.buttonColor,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                "Búsqueda de Personajes Bíblicos",
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
                      controller: searchTextController,
                      style: StylesApp(context).textStyleSmallBlack.copyWith(
                            fontSize: 16,
                          ),
                      decoration: InputDecoration(
                        hintText: 'Escribe aquí el nombre del personaje...',
                        hintStyle: TextStyle(
                          color: currentTheme.textColor.withValues(alpha: 0.6),
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
          if (_searchText.isNotEmpty && characters.isNotEmpty)
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
                          Icons.people_outline,
                          color: currentTheme.buttonColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "${pagination.totalItems} personajes encontrados",
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
              "Buscando personajes...",
              style: StylesApp(context).textStyleBody14.copyWith(
                    color: currentTheme.textColor.withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
      );
    }

    if (characters.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          // childAspectRatio: 1.3, // Rectángulos más cuadrados
        ),
        itemCount: characters.length,
        itemBuilder: (context, index) {
          return _buildTabletCharacterCard(characters[index]);
        },
      ),
    );
  }

  // ============ RESULTADOS PARA MÓVIL (LISTA) ============
  Widget _buildMobileResults() {
    if (loading) {
      return LoadingIndicator();
    }

    if (characters.isEmpty) {
      return SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                textAlign: TextAlign.center,
                "No hay resultados...",
                style: StylesApp(context).textStyleBody18.copyWith(
                      color: currentTheme.textColor,
                    ),
              ),
            )
          ],
        ),
      );
    }

    return ListView.builder(
      padding: horizontalPadding,
      itemCount: characters.length,
      itemBuilder: (context, int index) {
        return CardCharacterWidget(
          currentTheme: currentTheme,
          data: characters[index],
          onTap: () {
            _showCharacterDetails(characters[index]);
          },
        );
      },
    );
  }

  // ============ TARJETA DE PERSONAJE PARA TABLET ============
  Widget _buildTabletCharacterCard(CharacterModel character) {
    final color = Color(int.parse('0XFF${character.color}')).withAlpha(77);

    return Card(
      color: color,
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
            // CABECERA CON COLOR
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),

            // CONTENIDO
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NOMBRE Y TIPO
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            character.name,
                            style: StylesApp(context).textStyleBody16.copyWith(
                                  color: currentTheme.textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (character.typeNameChar.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              character.typeNameChar,
                              style:
                                  StylesApp(context).textStyleBody10.copyWith(
                                        color: currentTheme.textColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 8),

                    // IMAGEN (si existe)
                    if (character.img.urlImg.isNotEmpty)
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(
                                "${GraphQLConfig.urlServidor}${character.img.urlImg}"),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),

                    SizedBox(height: character.img.urlImg.isNotEmpty ? 12 : 8),

                    // DESCRIPCIÓN
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          character.description,
                          style: StylesApp(context).textStyleBody14.copyWith(
                                color: currentTheme.textColor
                                    .withValues(alpha: 0.8),
                                fontSize: 13,
                                height: 1.4,
                              ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    // INDICADOR DE PERSONAJES RELACIONADOS
                    if (character.haveMoreCharacters)
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              currentTheme.buttonColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color:
                                currentTheme.buttonColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.group,
                              size: 12,
                              color: currentTheme.buttonColor,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Tiene ${character.relatedCharacters.length} relacionados',
                              style:
                                  StylesApp(context).textStyleBody12.copyWith(
                                        fontSize: 12,
                                        color: currentTheme.buttonColor,
                                      ),
                            ),
                          ],
                        ),
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
                  onPressed: () => _showCharacterDetails(character),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ver detalles',
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
              Icons.people_outline,
              size: isTablet ? 80 : 60,
              color: currentTheme.textColor.withValues(alpha: 0.3),
            ),
            SizedBox(height: 20),
            Text(
              "No se encontraron personajes",
              style: StylesApp(context).textStyleBody18.copyWith(
                    color: currentTheme.textColor,
                    fontSize: isTablet ? 22 : 18,
                  ),
            ),
            SizedBox(height: 12),
            Text(
              _searchText.isEmpty
                  ? "Comienza a buscar personajes bíblicos escribiendo en el campo de búsqueda"
                  : "No se encontraron resultados para '$_searchText'",
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
    if (characters.isEmpty) return SizedBox();

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
        itemsPerPage: itemsPerPage,
      ),
    );
  }

  // ============ MÉTODOS DE DETALLES DE PERSONAJE ============
  void _showCharacterDetails(CharacterModel character) {
    if (character.haveMoreCharacters) {
      _showRelatedCharactersDialog(character);
    } else {
      _showCharacterDialog(character);
    }
  }

  void _showRelatedCharactersDialog(CharacterModel character) {
    final relatedCharacters = character.relatedCharacters
        .map((related) => CharacterModel(
              id: related.id,
              name: related.name,
              description: related.description,
              relatedCharacters: [],
              color: related.color,
              newTestament: false,
              haveMoreCharacters: related.haveMoreCharacters,
              typeNameChar: related.typeNameChar,
              img: Img(urlImg: related.img.urlImg),
            ))
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: currentTheme.backgroundColor,
          insetPadding: isTablet ? EdgeInsets.all(40) : EdgeInsets.all(0),
          child: SizedBox(
            width: isTablet ? 600 : double.infinity,
            height: isTablet ? 700 : MediaQuery.of(context).size.height,
            child: Column(
              children: [
                // ENCABEZADO
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: StyleColor.turquoise,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Personajes Relacionados',
                          style: StylesApp(context).textStyleBody18.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // TÍTULO DEL PERSONAJE PRINCIPAL
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      if (character.img.urlImg.isNotEmpty)
                        Container(
                          width: 60,
                          height: 60,
                          margin: EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                              image: NetworkImage(GraphQLConfig.urlServidor +
                                  character.img.urlImg),
                              fit: BoxFit.fitHeight,
                            ),
                            border: Border.all(
                              color: currentTheme.buttonColor,
                              width: 2,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              character.name,
                              style:
                                  StylesApp(context).textStyleBody16.copyWith(
                                        color: currentTheme.textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                            if (character.typeNameChar.isNotEmpty)
                              Text(
                                character.typeNameChar,
                                style: TextStyle(
                                  color: currentTheme.textColor
                                      .withValues(alpha: 0.7),
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // LISTA DE PERSONAJES RELACIONADOS
                Expanded(
                  child: isTablet
                      ? GridView.builder(
                          padding: EdgeInsets.all(16),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: relatedCharacters.length,
                          itemBuilder: (context, index) {
                            return _buildRelatedCharacterCard(
                                relatedCharacters[index]);
                          },
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: relatedCharacters.length,
                          itemBuilder: (context, int index) {
                            return CardCharacterWidget(
                              showTypeName: true,
                              currentTheme: currentTheme,
                              data: relatedCharacters[index],
                              onTap: () {
                                Navigator.pop(context);
                                _showCharacterDialog(relatedCharacters[index]);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRelatedCharacterCard(CharacterModel character) {
    final color = Color(int.parse('0XFF${character.color}')).withAlpha(77);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          _showCharacterDialog(character);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // COLOR INDICADOR
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              SizedBox(height: 12),

              // IMAGEN
              if (character.img.urlImg.isNotEmpty)
                Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(
                      image: NetworkImage(
                          GraphQLConfig.urlServidor + character.img.urlImg),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),

              SizedBox(height: character.img.urlImg.isNotEmpty ? 12 : 8),

              // NOMBRE
              Text(
                character.name,
                style: StylesApp(context).textStyleBody14.copyWith(
                      color: currentTheme.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 4),

              // TIPO
              if (character.typeNameChar.isNotEmpty)
                Text(
                  character.typeNameChar,
                  style: TextStyle(
                    color: currentTheme.textColor.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),

              Spacer(),

              // BOTÓN VER DETALLES
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: currentTheme.buttonColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCharacterDialog(CharacterModel character) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogInternalCharacter(
          data: character,
          currentTheme: currentTheme,
          isTablet: isTablet,
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
    if (query.isEmpty) return;

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

// ============ DIALOG INTERNO ADAPTADO PARA TABLET ============
class DialogInternalCharacter extends StatelessWidget {
  final CharacterModel data;
  final BibleTheme currentTheme;
  final bool isTablet;

  const DialogInternalCharacter({
    super.key,
    required this.data,
    required this.currentTheme,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse('0XFF${data.color}')).withAlpha(77);

    return Dialog(
      backgroundColor: Color(int.parse('0XFF${data.color}')),
      insetPadding: isTablet ? EdgeInsets.all(40) : EdgeInsets.all(16),
      child: SizedBox(
        width: isTablet ? 600 : double.infinity,
        height: isTablet ? 700 : MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // ENCABEZADO
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: StyleColor.turquoise,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detalles del Personaje',
                    style: StylesApp(context).textStyleBody18.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // CONTENIDO CON SCROLL
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CABECERA CON IMAGEN E INFORMACIÓN
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // IMAGEN
                        if (data.img.urlImg.isNotEmpty)
                          Container(
                            width: isTablet ? 150 : 100,
                            height: isTablet ? 150 : 100,
                            margin: EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(GraphQLConfig.urlServidor +
                                    data.img.urlImg),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: color,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),

                        // INFORMACIÓN
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.name,
                                style:
                                    StylesApp(context).textStyleBody18.copyWith(
                                          color: currentTheme.textColor,
                                          fontSize: isTablet ? 24 : 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                              ),

                              SizedBox(height: 8),

                              if (data.typeNameChar.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    data.typeNameChar,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                              SizedBox(height: 12),

                              // COLOR INDICADOR
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Color identificador',
                                    style: TextStyle(
                                      color: currentTheme.textColor
                                          .withValues(alpha: 0.7),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // DESCRIPCIÓN
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            currentTheme.backgroundColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              currentTheme.buttonColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.description,
                                color: currentTheme.buttonColor,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Descripción',
                                style:
                                    StylesApp(context).textStyleBody16.copyWith(
                                          color: currentTheme.textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            data.description,
                            style: StylesApp(context).textStyleBody14.copyWith(
                                  color: currentTheme.textColor,
                                  fontSize: 15,
                                  height: 1.6,
                                ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // INFORMACIÓN ADICIONAL
                    if (data.newTestament)
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.book,
                              color: Colors.green,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Personaje del Nuevo Testamento',
                              style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
