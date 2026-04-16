import 'dart:async';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/info_modal_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ListRequestScreen extends StatefulWidget {
  const ListRequestScreen({super.key});

  @override
  State<ListRequestScreen> createState() => _ListRequestScreenState();
}

class _ListRequestScreenState extends State<ListRequestScreen> {
  PrayerModel? dataSeleccionada;
  String? errorMessage;
  bool isLoading = true;
  List<PrayerModel> listRequest = [];
  int itemPerPageValue = 10;
  List<int> itemsPerPage = [5, 10, 15, 25, 50, 100];
  PaginationInfo pagination = PaginationInfo(
    currentPage: 1,
    totalPages: 0,
    itemsPerPage: 0,
    totalItems: 0,
    hasPreviousPage: false,
    hasNextPage: false,
  );
  Timer? _debounceTimer;
  bool loading = false;
  TextEditingController searchTextController = TextEditingController();
  String searchText = '';
  late BibleThemeProvider? themeProvider;
  late BibleTheme? currentTheme;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeProvider = Provider.of<BibleThemeProvider>(context, listen: false);
      currentTheme = themeProvider!.themeData;
      _generateData(context, pagination.currentPage, itemPerPageValue);
    });
    super.initState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     
     final translationProvider = context.read<AppTranslationProvider>();

    return Scaffold(
      body: SafeArea(
        child: ResponsiveLayout(
            mobile: _buildMobileLayout(context, translationProvider),
            tablet: _buildTabletLayout(context, translationProvider)),
      ),
    );
  }

  // DISEÑO TABLET A DOS COLUMNAS
  Widget _buildTabletLayout(BuildContext context, AppTranslationProvider translationProvider) {
    return Container(
      decoration: BoxDecoration(color: StyleColor.turquoise),
      child: Column(
        children: [
          // Header para tablet
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 10.0,
                ),
                // Botón de regreso
                Container(
                  height: 35.0,
                  width: 35.0,
                  decoration: BoxDecoration(
                      color: Color(0XFFFD8C43),
                      borderRadius: BorderRadius.circular(35.0)),
                  child: IconButton(
                    constraints: BoxConstraints(maxHeight: 35.0),
                    padding: EdgeInsets.all(0),
                    iconSize: 32.0,
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      size: 32.0,
                    ),
                  ),
                ),
                SizedBox(width: 20),

                // Título
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translationProvider.tr('list_request_screen.title.responses_of'),
                        style: StylesApp(context).textStyleBody1.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: StyleColor.blueDark,
                            ),
                      ),
                      Text(
                       translationProvider.tr('list_request_screen.title.prayer_request'),
                        style: StylesApp(context).textStyleTitleOrange.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),

                // Logo o ícono decorativo
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Image.asset(
                    "assets/kawaii_fire.png",
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // COLUMNA IZQUIERDA - Lista de peticiones
                Expanded(
                  flex: 5,
                  child: Container(
                    color: StyleColor.turquoise.withValues(alpha: 0.1),
                    child: Column(
                      children: [
                        // Barra de búsqueda
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              readOnly: listRequest.isEmpty || loading,
                              controller: searchTextController,
                              style: StylesApp(context)
                                  .textStyleSmallBlack
                                  .copyWith(fontSize: 16),
                              decoration: InputDecoration(
                                hintText: translationProvider.tr('list_request_screen.search.placeholder'),
                                hintStyle: StylesApp(context)
                                    .textStyleBody14
                                    .copyWith(
                                        fontSize: 14, color: Colors.grey[500]),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16),
                                prefixIcon: Icon(Icons.search,
                                    color: StyleColor.orange),
                                suffixIcon: searchText.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.clear,
                                            color: Colors.grey),
                                        onPressed: () {
                                          setState(() {
                                            cleanSearch();
                                          });
                                        },
                                      )
                                    : null,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchText = value;
                                });
                                _onSearchChanged(value);
                              },
                            ),
                          ),
                        ),

                        // Información de estadísticas
                        if (!isLoading &&
                            errorMessage == null &&
                            listRequest.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStatCard(
                                  context,
                                 translationProvider.tr('list_request_screen.stats.total_requests'),
                                  '${pagination.totalItems}',
                                  Icons.list_alt,
                                  StyleColor.orange,
                                ),
                                _buildStatCard(
                                  context,
                                  translationProvider.tr('list_request_screen.stats.current_page'),
                                  '${pagination.currentPage}',
                                  Icons.pages,
                                  StyleColor.blue,
                                ),
                                _buildStatCard(
                                  context,
                                  translationProvider.tr('list_request_screen.stats.per_page'),
                                  '$itemPerPageValue',
                                  Icons.format_list_numbered,
                                  StyleColor.greenMedium,
                                ),
                              ],
                            ),
                          ),

                        // Lista de peticiones
                        Expanded(
                          child: isLoading
                              ? Center(child: LoadingIndicator())
                              : errorMessage != null
                                  ? BuildErrorWidget(
                                      errorMessage: errorMessage!,
                                      onRetry: () async => _generateData(
                                          context,
                                          pagination.currentPage,
                                          itemPerPageValue),
                                      onBack: () => Navigator.pop(context),
                                    )
                                  : listRequest.isEmpty
                                      ? _buildEmptyState(context, translationProvider)
                                      : ListView.builder(
                                          padding: EdgeInsets.all(20.0),
                                          itemCount: listRequest.length,
                                          itemBuilder: (context, index) {
                                            return _buildTabletListItem(
                                                context, index, translationProvider);
                                          },
                                        ),
                        ),

                        // Paginación para tablet
                        if (!isLoading &&
                            errorMessage == null &&
                            listRequest.isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: BorderSide(
                                    color: Colors.grey[300]!, width: 1),
                              ),
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
                              onPageChanged: (newPage, newPerPage) async {
                                if (listRequest.isNotEmpty) {
                                  setState(() {
                                    itemPerPageValue = newPerPage;
                                  });
                                  await _generateData(
                                      context, newPage, newPerPage);
                                }
                              },
                              itemsPerPage: itemsPerPage,
                              currentTheme: currentTheme!,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // COLUMNA DERECHA - Detalles de la petición seleccionada
                Expanded(
                  flex: 7,
                  child: Container(
                    color: Colors.white,
                    child: dataSeleccionada != null
                        ? _buildDetailPanel(context, translationProvider)
                        : _buildEmptyDetailPanel(context, translationProvider),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Item de lista para tablet
  Widget _buildTabletListItem(BuildContext context, int index,AppTranslationProvider translationProvider) {
    final prayer = listRequest[index];
    final bool isSelected = dataSeleccionada == listRequest[index];

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? StyleColor.white.withValues(alpha: 0.80)
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isSelected ? StyleColor.orange : Colors.transparent,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() {
              dataSeleccionada = prayer;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fila superior: Fecha y acciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 18, color: StyleColor.orange),
                        SizedBox(width: 8),
                        Text(
                          prayer.requestDate,
                          style: StylesApp(context).textStyleBody14.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                        ),
                      ],
                    ),

                    // Botones de acción
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.visibility,
                              size: 22, color: StyleColor.blue),
                          onPressed: () {
                            _showMOdalInfo(context, prayer);
                          },
                          tooltip: translationProvider.tr('list_request_screen.list_item.view_details'),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline,
                              size: 22, color: Colors.red[400]),
                          onPressed: () => _deleteItem(prayer.requestId, translationProvider),
                          tooltip: translationProvider.tr('list_request_screen.list_item.delete'),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Información de la petición
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: StyleColor.blueLight,
                      radius: 20,
                      child: Icon(Icons.person, size: 20, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prayer.requestedBy,
                            style: StylesApp(context).textStyleBody14.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                  color: StyleColor.blueDark,
                                ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${translationProvider.tr('list_request_screen.list_item.by')} ${prayer.prayedFor}',
                            style: StylesApp(context).textStyleBody14.copyWith(
                                  fontSize: 14.0,
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // En _buildTabletListItem, reemplaza la sección de categorías con:
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Categoría principal
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.3,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: StyleColor.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: StyleColor.orange.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        prayer.prayerCategory.name,
                        style: StylesApp(context).textStyleBody14.copyWith(
                              fontSize: 12,
                              color: StyleColor.orange,
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),

                    // Subcategoría
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.3,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: StyleColor.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: StyleColor.blue.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        prayer.prayerSubType.name.trim(),
                        style: StylesApp(context).textStyleBody14.copyWith(
                              fontSize: 12,
                              color: StyleColor.blue,
                              fontWeight: FontWeight.w600,
                            ),
                        // overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),

                    // Indicador de respuesta (si existe)
                    if (prayer.responser != null)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: Colors.green.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle,
                                size: 12, color: Colors.green),
                            SizedBox(width: 4),
                            Text(
                             translationProvider.tr('list_request_screen.list_item.with_response'),
                              style:
                                  StylesApp(context).textStyleBody14.copyWith(
                                        fontSize: 11,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Panel de detalles para columna derecha
  Widget _buildDetailPanel(BuildContext context, AppTranslationProvider translationProvider) {
    final prayer = dataSeleccionada as PrayerModel;

    return SingleChildScrollView(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del detalle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translationProvider.tr('list_request_screen.list_item.title'),
                style: StylesApp(context).textStyleBody24.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: StyleColor.blueDark,
                    ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    dataSeleccionada = null;
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 20),

          // Información principal
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: StyleColor.blueLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: StyleColor.blueLight, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: StyleColor.orange, size: 20),
                    SizedBox(width: 10),
                    Text(
                      '${translationProvider.tr('list_request_screen.detail_panel.date')} ${prayer.requestDate}',
                      style: StylesApp(context).textStyleBody16.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.person, color: StyleColor.blue, size: 20),
                    SizedBox(width: 10),
                    Text(
                      '${translationProvider.tr('list_request_screen.detail_panel.request_by')} ${prayer.requestedBy}',
                      style: StylesApp(context).textStyleBody16.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 25),

          // Categorías
          Text(
            translationProvider.tr('list_request_screen.detail_panel.categories_title'),
            style: StylesApp(context).textStyleBody18.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: StyleColor.blueDark,
                ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: StyleColor.orange.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: StyleColor.orange, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translationProvider.tr('list_request_screen.detail_panel.main_category'),
                        style: StylesApp(context).textStyleBody12.copyWith(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        prayer.prayerCategory.name,
                        style: StylesApp(context).textStyleBody16.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: StyleColor.orange,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: StyleColor.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: StyleColor.blue, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translationProvider.tr('list_request_screen.detail_panel.subcategory'),
                        style: StylesApp(context).textStyleBody14.copyWith(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        prayer.prayerSubType.name.trim(),
                        style: StylesApp(context).textStyleBody14.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: StyleColor.blue,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 25),

          // Detalle de la oración
          Text(
            translationProvider.tr('list_request_screen.detail_panel.prayer_request'),
            style: StylesApp(context).textStyleBody18.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: StyleColor.blueDark,
                ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(
              prayer.prayerDetails,
              style: StylesApp(context).textStyleBody15.copyWith(
                    fontSize: 15,
                    color: Colors.grey[800],
                    height: 1.6,
                  ),
            ),
          ),

          SizedBox(height: 25),

          // Respuestas (si existen)
          if (prayer.responser != null) ...[
            Text(
              translationProvider.tr('list_request_screen.detail_panel.prayer_request'),
              style: StylesApp(context).textStyleBody18.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: StyleColor.blueDark,
                  ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 10),
                      Text(
                        translationProvider.tr('list_request_screen.detail_panel.response_from_team'),
                        style: StylesApp(context).textStyleBody16.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.green[800],
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    prayer.responser!.message,
                    style: StylesApp(context).textStyleBody15.copyWith(
                          fontSize: 15,
                          color: Colors.grey[800],
                          height: 1.6,
                        ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 30),

          // Botones de acción
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _showMOdalInfo(context, prayer),
                style: ElevatedButton.styleFrom(
                  backgroundColor: StyleColor.orange,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.visibility, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      translationProvider.tr('list_request_screen.detail_panel.view_full'),
                      style: StylesApp(context).textStyleBody16.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15),
              OutlinedButton(
                onPressed: () => _deleteItem(prayer.requestId, translationProvider),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: Colors.red),
                ),
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      translationProvider.tr('list_request_screen.detail_panel.delete'),
                      style: StylesApp(context).textStyleBody16.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Panel vacío para columna derecha
  Widget _buildEmptyDetailPanel(BuildContext context, AppTranslationProvider translationProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.select_all,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 20),
          Text(
            translationProvider.tr('list_request_screen.empty_detail.title'),
            style: StylesApp(context).textStyleBody20.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                ),
          ),
          SizedBox(height: 10),
          Text(
            translationProvider.tr('list_request_screen.empty_detail.subtitle'),
            textAlign: TextAlign.center,
            style: StylesApp(context).textStyleBody15.copyWith(
                  fontSize: 15,
                  color: Colors.grey[400],
                ),
          ),
        ],
      ),
    );
  }

  // Tarjeta de estadísticas
  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(
              value,
              style: StylesApp(context).textStyleBody18.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: StyleColor.blueDark,
                  ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: StylesApp(context).textStyleBody10.copyWith(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // Estado vacío
  Widget _buildEmptyState(BuildContext context, AppTranslationProvider translationProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 20),
          Text(
            translationProvider.tr('list_request_screen.empty_state.title'),
            textAlign: TextAlign.center,
            style: StylesApp(context).textStyleBody16.copyWith(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
          ),
          SizedBox(height: 10),
          Text(
            translationProvider.tr('list_request_screen.empty_state.subtitle'),
            textAlign: TextAlign.center,
            style: StylesApp(context).textStyleBody14.copyWith(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
          ),
        ],
      ),
    );
  }

  // DISEÑO MÓVIL (se mantiene exactamente igual)
  Widget _buildMobileLayout(BuildContext context, AppTranslationProvider translationProvider) {
    return Container(
      decoration: BoxDecoration(
        color: StyleColor.turquoise,
      ),
      child: Column(
        children: [
          HeadScreenNotAvatar(
            title: "${translationProvider.tr('list_request_screen.title.responses_of')}\n ${translationProvider.tr('list_request_screen.title.prayer_requests')}",
            onRoute: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(
            height: 16.0,
          ),
          if (isLoading) ...{
            Center(
              child: LoadingIndicator(),
            )
          } else ...{
            if (errorMessage != null) ...{
              BuildErrorWidget(
                errorMessage: errorMessage!,
                onRetry: () async => _generateData(
                    context, pagination.currentPage, itemPerPageValue),
                onBack: () => Navigator.pop(context),
              )
            } else ...{
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: TextFormField(
                  readOnly: listRequest.isEmpty || loading,
                  controller: searchTextController,
                  style: StylesApp(context).textStyleSmallBlack,
                  decoration:
                      StylesApp(context).inputDecorationOutlineStyle.copyWith(
                            hintText: translationProvider.tr('list_request_screen.search.hint') ,
                            hintStyle: StylesApp(context)
                                .textStyleBody14
                                .copyWith(color: StyleColor.grayMedium),
                            border: OutlineInputBorder(),
                            suffixIcon: searchText.isNotEmpty
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
                      searchText = value;
                    });
                    _onSearchChanged(value);
                  },
                ),
              ),
              Expanded(
                child: listRequest.isEmpty
                    ? Center(
                        child: Container(
                          padding: EdgeInsets.all(18.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            translationProvider.tr('list_request_screen.empty_state.title'),
                            style: StylesApp(context).textStyleBody16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: listRequest.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _cardListItem(context, index, translationProvider);
                        }),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                  top: 8.0,
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
                  onPageChanged: (newPage, newPerPage) async {
                    if (listRequest.isNotEmpty) {
                      setState(() {
                        itemPerPageValue = newPerPage;
                      });
                      await _generateData(context, newPage, newPerPage);
                    }
                  },
                  itemsPerPage: itemsPerPage,
                  currentTheme: currentTheme!,
                ),
              ),
            }
          }
        ],
      ),
    );
  }

  // Métodos existentes (se mantienen igual)
  Container _cardListItem(BuildContext context, int index, AppTranslationProvider translationProvider) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 100.0,
      ),
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                textAlign: TextAlign.left,
                TextSpan(
                  children: [
                    TextSpan(
                      text: "${translationProvider.tr('list_request_screen.mobile.date')} ",
                      style: StylesApp(context).textStyleBody14.copyWith(
                            color: StyleColor.orange,
                          ),
                    ),
                    TextSpan(
                      text: listRequest[index].requestDate,
                      style: StylesApp(context).textStyleBody14.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "${translationProvider.tr('list_request_screen.mobile.by')} ",
                      style: StylesApp(context).textStyleBody14.copyWith(
                            color: StyleColor.orange,
                          ),
                    ),
                    TextSpan(
                      text: listRequest[index].requestedBy,
                      style: StylesApp(context)
                          .textStyleBody14
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Text.rich(
                softWrap: true,
                TextSpan(
                  children: [
                    TextSpan(
                      text:"${translationProvider.tr('list_request_screen.mobile.prayer_for')} ",
                      style: StylesApp(context).textStyleBody14.copyWith(
                            color: StyleColor.orange,
                          ),
                    ),
                    TextSpan(
                      text: listRequest[index].prayerCategory.name.trim(),
                      style: StylesApp(context)
                          .textStyleBody14
                          .copyWith(color: Colors.black),
                    ),
                    TextSpan(
                      text: " / ",
                      style: StylesApp(context).textStyleBody14.copyWith(
                            color: StyleColor.orange,
                          ),
                    ),
                    TextSpan(
                      text: listRequest[index].prayerSubType.name,
                      style: StylesApp(context)
                          .textStyleBody14
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: -10,
            right: 0,
            child: IconButton(
              onPressed: () {
                _showModal(context);
                setState(() {
                  dataSeleccionada = listRequest[index];
                });
              },
              icon: Icon(
                Icons.add_circle_outline_sharp,
                color: StyleColor.turquoise,
              ),
            ),
          ),
          Positioned(
            bottom: -15,
            right: 0,
            child: IconButton(
              onPressed: () {
                _deleteItem(listRequest[index].requestId, translationProvider);
              },
              icon: Icon(Icons.delete_outline),
            ),
          ),
        ],
      ),
    );
  }

  _showModal(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return LiabilityNoticeWidget(
          openModalInfo: () {
            _showMOdalInfo(context, dataSeleccionada);
          },
        );
      },
    );
  }

  void _showMOdalInfo(BuildContext context, infoData) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return InfoModalWidget(dataSeleccionada: infoData);
      },
    );
  }

  Future<void> _generateData(BuildContext context, int page, int limit) async {
    setState(() {
      errorMessage = null;
      isLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.currentUser;
    try {
      final responseListRequest = await getAllRequestPrayerByUser(
          userData?.userId, page, limit, searchText);
      if (responseListRequest.error != null) {
        setState(() {
          errorMessage = responseListRequest.error!;
          isLoading = false;
        });
        return;
      }

      setState(() {
        listRequest = responseListRequest.data['data']
            .map<PrayerModel>((request) => PrayerModel.fromJson(request))
            .toList();
        pagination = PaginationInfo.fromJson(responseListRequest.data['meta']);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void cleanSearch() {
    setState(() {
      searchText = '';
      searchTextController.text = '';
    });
  }

  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 800), () {
      FocusScope.of(context).unfocus();
      _performSearch(value);
    });
  }

  void _performSearch(String query) async {
    if (query.isEmpty) return;

    try {
      _generateData(context, pagination.currentPage, pagination.currentPage);
    } catch (e) {
      debugPrint("error al filtrar $e");
    }
  }

  _deleteItem(String id, AppTranslationProvider translationProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            translationProvider.tr('list_request_screen.delete_dialog.title'),
            style: StylesApp(context)
                .textStyleBody2
                .copyWith(color: StyleColor.black),
          ),
          content: Text(
            translationProvider.tr('list_request_screen.delete_dialog.message'),
            style: StylesApp(context)
                .textStyleBody16
                .copyWith(color: StyleColor.black),
          ),
          actions: [
            TextButton(
              child: Text(
               translationProvider.tr('list_request_screen.delete_dialog.cancel'),
                style: StylesApp(context)
                    .textStyleBody10
                    .copyWith(color: StyleColor.lavenderMist),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                translationProvider.tr('list_request_screen.delete_dialog.confirm'),
                style: StylesApp(context)
                    .textStyleBody10
                    .copyWith(color: StyleColor.lavenderMist),
              ),
              onPressed: () async {
                try {
                  final responseDelete = await deleteRequestPrayer(id);
                  if (responseDelete.error != null) {
                    if (mounted) {
                      await showCustomDialog(context,
                          messageDetail: responseDelete.error!,
                          message: responseDelete.userFriendlyError!,
                          showDetails: true,
                          dialogType: DialogType.error);
                    }
                    return;
                  }

                  if (mounted) {
                    Navigator.of(context).pop();

                    // Aquí está la clave: actualizar el estado COMPLETAMENTE
                    setState(() {
                      // 1. Eliminar el item de la lista
                      listRequest.removeWhere((item) => item.requestId == id);

                      // 2. Actualizar el total de items en la paginación
                      pagination = PaginationInfo(
                        currentPage: pagination.currentPage,
                        totalPages: pagination.totalPages,
                        itemsPerPage: pagination.itemsPerPage,
                        totalItems:
                            pagination.totalItems - 1, // Restar 1 del total
                        hasPreviousPage: pagination.hasPreviousPage,
                        hasNextPage: pagination.hasNextPage,
                      );

                      // 3. Verificar si necesitamos ajustar la página actual
                      if (listRequest.isEmpty && pagination.currentPage > 1) {
                        // Si la página actual quedó vacía y no es la primera página
                        // ir a la página anterior
                        _loadPreviousPageIfNeeded(translationProvider);
                      }

                      // 4. Limpiar selección si se eliminó
                      if (dataSeleccionada?.requestId == id) {
                        dataSeleccionada = null;
                      }
                    });
                    showSnackBar(translationProvider.tr('list_request_screen.message.deleted_success'),
                        type: SnackBarType.success);
                  }
                } catch (e) {
                  if (mounted) {
                    await showCustomDialog(context,
                        messageDetail:translationProvider.tr('list_request_screen.message.try_again_later'),
                        message: e.toString(),
                        dialogType: DialogType.error);
                  }
                  return;
                }
              },
            ),
          ],
        );
      },
    );
  }

// Método para cargar la página anterior si es necesario
  void _loadPreviousPageIfNeeded(AppTranslationProvider translationProvider) async {
    if (listRequest.isEmpty && pagination.currentPage > 1) {
      try {
        LoadingService().showLoading(context);
        await _generateData(
            context, pagination.currentPage - 1, itemPerPageValue);
        LoadingService().hideLoading();
      } catch (e) {
        LoadingService().hideLoading();
        showSnackBar("${translationProvider.tr('list_request_screen.message.load_previous_page_error')} ${e.toString()}",
            type: SnackBarType.error);
      }
    }
  }
}
