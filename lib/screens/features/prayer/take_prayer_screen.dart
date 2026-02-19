import 'dart:async';

import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:provider/provider.dart';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class TakePrayerScreen extends StatefulWidget {
  const TakePrayerScreen({super.key});

  @override
  State<TakePrayerScreen> createState() => _TakePrayerScreenState();
}

class _TakePrayerScreenState extends State<TakePrayerScreen> {
  List<VersionModel> listBibleVersions = [];
  List<ModelData> versions = [];
  ModelData? versionSelected;
  String? groupId;
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

  bool itemExpanded = false;
  List<ModelData> books = [];
  ModelData? bookSelected;
  List<ChapterModel> selectedBookChapters = [];
  int selectedChapterIndex = 0;
  List<Verse> selectedChapterVerses = [];
  int selectedVerseIndex = 0;
  bool showRecordAudio = false;

  PrayerModel? dataSeleccionada;
  final _translationProvider = AppTranslationProvider();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
    isTablet(context);
    final themeProvider = Provider.of<BibleThemeProvider>(context);
    final currentTheme = themeProvider.themeData;

    return Scaffold(
        // backgroundColor: StyleColor.turquoise,
        body: SafeArea(
      child: ResponsiveLayout(
        mobile: _buildMobileLayout(context, currentTheme),
        tablet: _buildTabletLayout(context, currentTheme),
      ),
    ));
  }

  // DISEÑO PARA TABLET A DOS COLUMNAS
  Widget _buildTabletLayout(BuildContext context, BibleTheme currentTheme) {
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
                        _translationProvider
                            .tr('take_prayer_screen.title.take'),
                        style: StylesApp(context).textStyleBody1.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: StyleColor.blueDark,
                            ),
                      ),
                      Text(
                        _translationProvider
                            .tr('take_prayer_screen.title.prayer'),
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
                                hintText: _translationProvider.tr(
                                    'take_prayer_screen.search.placeholder'),
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
                                  _translationProvider.tr(
                                      'take_prayer_screen.stats.total_requests'),
                                  '${pagination.totalItems}',
                                  Icons.list_alt,
                                  StyleColor.orange,
                                ),
                                _buildStatCard(
                                  context,
                                  _translationProvider
                                      .tr('take_prayer_screen.stats.pending'),
                                  '${listRequest.length}',
                                  Icons.access_time,
                                  StyleColor.blue,
                                ),
                                _buildStatCard(
                                  context,
                                  _translationProvider
                                      .tr('take_prayer_screen.stats.per_page'),
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
                                      ? _buildEmptyState(context)
                                      : ListView.builder(
                                          padding: EdgeInsets.all(20.0),
                                          itemCount: listRequest.length,
                                          itemBuilder: (context, index) {
                                            return _buildTabletListItem(
                                                context, index);
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
                              currentTheme: currentTheme,
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
                        ? _buildDetailPanel(context)
                        : _buildEmptyDetailPanel(context),
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
  Widget _buildTabletListItem(BuildContext context, int index) {
    final prayer = listRequest[index];
    final bool isSelected = dataSeleccionada == listRequest[index];

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? StyleColor.white.withValues(alpha: 0.80)
            : StyleColor.white,
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
                // Fila superior: Fecha y estado
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
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                        ),
                      ],
                    ),

                    // Badge de estado
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: StyleColor.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _translationProvider
                            .tr('take_prayer_screen.stats.pending'),
                        style: TextStyle(
                          fontSize: 11,
                          color: StyleColor.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Información del solicitante
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
                                  fontWeight: FontWeight.w700,
                                  color: StyleColor.blueDark,
                                ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${_translationProvider.tr('take_prayer_screen.list_item.by')} ${prayer.prayedFor}',
                            style: StylesApp(context).textStyleBody14.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Categorías
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
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
                        style: TextStyle(
                          fontSize: 12,
                          color: StyleColor.orange,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
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
                        prayer.prayerSubType.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: StyleColor.blue,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15),

                // Botón de acción
                Center(
                  child: ButtonThemeWidget(
                    width: double.infinity,
                    height: 45,
                    text: _translationProvider
                        .tr('take_prayer_screen.list_item.assist_button'),
                    buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                          textStyle: WidgetStatePropertyAll(
                            TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    onPressed: () => _handleAssistPrayer(prayer, index),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Panel de detalles para columna derecha
  Widget _buildDetailPanel(BuildContext context) {
    final prayer = dataSeleccionada!;

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
                _translationProvider
                    .tr('take_prayer_screen.detail_panel.title'),
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
                      '${_translationProvider.tr('take_prayer_screen.detail_panel.date')} ${prayer.requestDate}',
                      style: TextStyle(
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
                      '${_translationProvider.tr('take_prayer_screen.detail_panel.requested_by')} ${prayer.requestedBy}',
                      style: TextStyle(
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
                    Icon(Icons.people, color: StyleColor.greenMedium, size: 20),
                    SizedBox(width: 10),
                    Text(
                      '${_translationProvider.tr('take_prayer_screen.detail_panel.prayer_for')} ${prayer.prayedFor}',
                      style: TextStyle(
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
            _translationProvider
                .tr('take_prayer_screen.detail_panel.categories_title'),
            style: TextStyle(
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
                        _translationProvider.tr(
                            'take_prayer_screen.detail_panel.main_category'),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        prayer.prayerCategory.name,
                        style: TextStyle(
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
                        _translationProvider
                            .tr('take_prayer_screen.detail_panel.subcategory'),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        prayer.prayerSubType.name,
                        style: TextStyle(
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
            _translationProvider
                .tr('take_prayer_screen.detail_panel.prayer_request'),
            style: TextStyle(
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
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                height: 1.6,
              ),
            ),
          ),

          SizedBox(height: 25),

          // Audio (si existe)
          if (prayer.audioPrayer != null) ...[
            Text(
              _translationProvider
                  .tr('take_prayer_screen.detail_panel.audio_title'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: StyleColor.blueDark,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.audio_file, color: StyleColor.blue, size: 30),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      _translationProvider.tr(
                          'take_prayer_screen.detail_panel.audio_available'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: StyleColor.blueDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],

          SizedBox(height: 30),

          // Botón principal de acción
          Center(
            child: ButtonThemeWidget(
              width: 300,
              height: 50,
              text: _translationProvider
                  .tr('take_prayer_screen.detail_panel.assist_button'),
              buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                    textStyle: WidgetStatePropertyAll(
                      TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              onPressed: () => _handleAssistPrayer(prayer, -1),
            ),
          ),
        ],
      ),
    );
  }

  // Panel vacío para columna derecha
  Widget _buildEmptyDetailPanel(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.handshake,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 20),
          Text(
            _translationProvider.tr('take_prayer_screen.empty_detail.title'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 10),
          Text(
            _translationProvider.tr('take_prayer_screen.empty_detail.subtitle'),
            textAlign: TextAlign.center,
            style: TextStyle(
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: StyleColor.blueDark,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
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
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: StyleColor.greenMedium.withValues(alpha: 0.5),
          ),
          SizedBox(height: 20),
          Text(
            _translationProvider.tr('take_prayer_screen.empty_state.title'),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: StyleColor.blueDark,
            ),
          ),
          SizedBox(height: 10),
          Text(
            _translationProvider.tr('take_prayer_screen.empty_state.subtitle'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.6,
            ),
          ),
          SizedBox(height: 30),
          ButtonThemeWidget(
            text: _translationProvider
                .tr('take_prayer_screen.empty_state.refresh_button'),
            buttonStyle: StylesApp(context).btnWidgetSmall,
            width: 200,
            height: 50,
            onPressed: () async {
              await _generateData(
                  context, pagination.currentPage, itemPerPageValue);
            },
          ),
        ],
      ),
    );
  }

  // DISEÑO MÓVIL (se mantiene exactamente igual)
  Widget _buildMobileLayout(BuildContext context, BibleTheme currentTheme) {
    return Container(
      decoration: BoxDecoration(color: StyleColor.turquoise),
      child: Column(
        children: [
          HeadScreenNotAvatar(
            title: _translationProvider.tr('take_prayer_screen.mobile.title'),
            onRoute: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 15),
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
                            hintText: _translationProvider
                                .tr('take_prayer_screen.search.hint'),
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
                child: ListView.builder(
                    itemCount: listRequest.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _cardListItem(context, index);
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
                  currentTheme: currentTheme,
                ),
              ),
            }
          }
        ],
      ),
    );
  }

  // Item de lista móvil (original)
  Container _cardListItem(BuildContext context, int index) {
    return Container(
      constraints: BoxConstraints(minHeight: 100.0),
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
                      text:
                          "${_translationProvider.tr('take_prayer_screen.mobile.date')} ",
                      style: StylesApp(context).textStyleBody12.copyWith(
                            color: StyleColor.orange,
                          ),
                    ),
                    TextSpan(
                      text: listRequest[index].requestDate,
                      style: StylesApp(context)
                          .textStyleBody14
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "${_translationProvider.tr('take_prayer_screen.mobile.by')} ",
                      style: StylesApp(context).textStyleBody12.copyWith(
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
                      text:
                          "${_translationProvider.tr('take_prayer_screen.mobile.prayer_for')} ",
                      style: StylesApp(context).textStyleBody12.copyWith(
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
                      style: StylesApp(context).textStyleBody12.copyWith(
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
              SizedBox(height: 12.0),
              Center(
                child: ButtonThemeWidget(
                  width: 180,
                  text: _translationProvider
                      .tr('take_prayer_screen.list_item.assist_button_mobile'),
                  buttonStyle: StylesApp(context).btnWidgetSmall,
                  onPressed: () async =>
                      _handleAssistPrayer(listRequest[index], index),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Método para manejar "Asistir Petición" (compartido)
  Future<void> _handleAssistPrayer(PrayerModel prayer, int index) async {
    LoadingService().showLoading(context);
    try {
      final responseChangeStatus =
          await changeStatusRequest(prayer.requestId, "En Proceso");
      if (responseChangeStatus.error != null) {
        LoadingService().hideLoading();
        if (mounted) {
          await showCustomDialog(
            context,
            message: responseChangeStatus.error!,
            dialogType: DialogType.error,
          );
        }
        return;
      }
      LoadingService().hideLoading();
    } catch (e) {
      LoadingService().hideLoading();
      if (mounted) {
        await showCustomDialog(
          context,
          message: e.toString(),
          dialogType: DialogType.error,
        );
      }
      return;
    }
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PrayerRequestModal(
          prayerRequest: prayer,
          emitUpdateList: () async {
            await _generateData(
                context, pagination.currentPage, itemPerPageValue);
          },
        ),
      );
    }
  }

  Future<void> _generateData(BuildContext context, int page, int limit) async {
    setState(() {
      errorMessage = null;
      isLoading = true;
    });
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      groupId = args['groupId'];
    }

    try {
      final responseListRequest =
          await getAllRequestPrayerByGroupId(page, limit, groupId, searchText);
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
      debugPrint(
          "${_translationProvider.tr('take_prayer_screen.messages.error_filter')} $e");
    }
  }
}
