import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class ProgressDetailScreen extends StatefulWidget {
  const ProgressDetailScreen({super.key});

  @override
  State<ProgressDetailScreen> createState() => _ProgressDetailScreenState();
}

class _ProgressDetailScreenState extends State<ProgressDetailScreen> {
  List<UserTitle>? titles = [];
  ResponseProgress? progressUser;
  late Map<String, dynamic> config;
  int maxScore = 0;
  int mediumScore = 0;
  int lowScore = 0;

  Future<void> _loadProgress(BuildContext context) async {
    LoadingService().showLoading(context);
    final userProvider = Provider.of<UserProvider>(context,
        listen:
            false); // listen: false para evitar reconstrucciones innecesarias
    LoginUser? dataUser = userProvider.currentUser;
    final progressResponse =
        await userProvider.getProgressUser(dataUser!.userId, null);
    if (progressResponse!.error != null) {
      LoadingService().hideLoading();
      await showCustomDialog(
        context,
        message: progressResponse.error!,
        dialogType: DialogType.error,
      );
      return;
    }
    progressUser = progressResponse.data;
    LoadingService().hideLoading();
    setState(() {}); // Fuerza una reconstrucción para mostrar los datos
  }

  @override
  Widget build(BuildContext context) {
    config = Provider.of<CatalogueProvider>(context, listen: false).allConfig;
    maxScore = config["highScore"];
    mediumScore = config["mediumScore"];
    lowScore = config["lowScore"];
    final userProvider = Provider.of<UserProvider>(context);
    final LoginUser? userData = userProvider.currentUser;
    titles = userData?.title;

    return Scaffold(
      body: SafeArea(
        child: ResponsiveLayout(
          mobile: _buildMobileLayout(context, userData!),
          tablet: _buildTabletLayout(context, userData),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, LoginUser userData) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidgetProgress(),
          SizedBox(
            height: 4.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 7.0),
            padding: EdgeInsets.symmetric(horizontal: 11.0, vertical: 6),
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 80.0),
            decoration: BoxDecoration(
                color: Colors.orange, borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      flex: 0,
                      child: SizedBox(
                        width: 40.0,
                        child: Image.asset(
                          "assets/Flag.png",
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              style: StylesApp(context).textStyleBody6,
                              children: [
                                TextSpan(text: "Registro: "),
                                TextSpan(
                                    text: userData.createdAt.isNotEmpty
                                        ? getFormattedDate(
                                            int.parse(userData.createdAt))
                                        : ""),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              style: StylesApp(context).textStyleBody6,
                              children: [
                                TextSpan(text: "Racha: "),
                                TextSpan(
                                    text: "${userData.streakDaysCount} días"),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              style: StylesApp(context).textStyleBody6,
                              children: [
                                TextSpan(text: "Energía: "),
                                TextSpan(text: "${userData.energyPoints}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0XFFC7AA34),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text.rich(
                      TextSpan(style: StylesApp(context).chipLevels, children: [
                        TextSpan(
                            text:
                                "${userData.league != null ? userData.league?.leagueName : ''} "),
                        TextSpan(
                            text:
                                "${userData.league != null ? userData.league?.currentPoints : '0'}"),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CurrentMonthCalendarWidget(
            registrationDate: userData.createdAt.isNotEmpty
                ? DateTime.fromMillisecondsSinceEpoch(
                    int.parse(userData.createdAt))
                : DateTime.now(),
          ),
          _buildAchievements(context),
          SizedBox(
            height: 8.0,
          ),
          _buildCollections(context)
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, LoginUser userData) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header en fila completa
            HeaderWidgetProgress(),
            SizedBox(height: 16.0),

            // Contenedor principal de dos columnas
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // COLUMNA IZQUIERDA - Información del usuario y colección de premios
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Sección de información del usuario
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Colección de Premios",
                              style: StylesApp(context)
                                  .textStyCalendar
                                  .copyWith(fontSize: 20),
                            ),
                            ButtonThemeWidget(
                              onPressed: () {
                                _dialogAwards(context);
                              },
                              text: "Ver Colección",
                              width: 150.0,
                              height: 40.0,
                              buttonStyle:
                                  StylesApp(context).btnWidgetSmall.copyWith(
                                        textStyle: WidgetStatePropertyAll(
                                            TextStyle(fontSize: 16)),
                                      ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 60.0,
                                    child: Image.asset(
                                      "assets/Flag.png",
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            style: StylesApp(context)
                                                .textStyleBody4
                                                .copyWith(fontSize: 18),
                                            children: [
                                              TextSpan(text: "Registro: "),
                                              TextSpan(
                                                  text: userData
                                                          .createdAt.isNotEmpty
                                                      ? getFormattedDate(
                                                          int.parse(userData
                                                              .createdAt))
                                                      : ""),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text.rich(
                                          TextSpan(
                                            style: StylesApp(context)
                                                .textStyleBody4
                                                .copyWith(fontSize: 18),
                                            children: [
                                              TextSpan(text: "Racha: "),
                                              TextSpan(
                                                  text:
                                                      "${userData.streakDaysCount} días"),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text.rich(
                                          TextSpan(
                                            style: StylesApp(context)
                                                .textStyleBody4
                                                .copyWith(fontSize: 18),
                                            children: [
                                              TextSpan(text: "Energía: "),
                                              TextSpan(
                                                  text:
                                                      "${userData.energyPoints}"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  color: Color(0XFFC7AA34),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text.rich(
                                  TextSpan(
                                      style: StylesApp(context)
                                          .chipLevels
                                          .copyWith(fontSize: 18),
                                      children: [
                                        TextSpan(
                                            text:
                                                "${userData.league != null ? userData.league?.leagueName : ''} "),
                                        TextSpan(
                                            text:
                                                "${userData.league != null ? userData.league?.currentPoints : '0'}"),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Sección de colección de premios
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.grey[50],
                          ),
                          child: Column(
                            children: [
                              // Logros/títulos (versión expandida)
                              _buildAchievementsTablet(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 16.0),

                  // COLUMNA DERECHA - Calendario y logros
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        // Calendario
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.grey[50],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Progreso Mensual",
                                style: StylesApp(context)
                                    .textStyCalendar
                                    .copyWith(fontSize: 20),
                              ),
                              // Calendario
                              // FractionallySizedBox(
                              //   widthFactor: 0.7, // 90% del ancho disponible
                              //   heightFactor:
                              //       0.8, // 80% de la altura disponible
                              //   child: CurrentMonthCalendarWidget(
                              //     registrationDate:
                              //         userData.createdAt.isNotEmpty
                              //             ? DateTime.fromMillisecondsSinceEpoch(
                              //                 int.parse(userData.createdAt))
                              //             : DateTime.now(),
                              //   ),
                              // ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 400, // Ancho máximo para tablet
                                  maxHeight: 350, // Altura máxima para tablet
                                ),
                                child: CurrentMonthCalendarWidget(
                                  registrationDate:
                                      userData.createdAt.isNotEmpty
                                          ? DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(userData.createdAt))
                                          : DateTime.now(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Botón Continuar centrado
            Center(
              child: SizedBox(
                width: 300,
                child: ButtonThemeWidget(
                  text: "Continuar Aventura",
                  height: 50.0,
                  buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                        textStyle: WidgetStatePropertyAll(TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                  onPressed: () async {
                    await _loadProgress(context);
                    if (progressUser != null && progressUser?.success == true) {
                      if (progressUser!.message
                          .contains('El curso ya fue finalizado')) {
                        await showCustomDialogWithAction(
                          context,
                          message: progressUser!.message,
                          dialogType: DialogTypeAction.info,
                          buttonOk: "Cerrar",
                          textButton: "ir Al curso",
                          showAction: true,
                          actionCallbackOk: () {
                            Navigator.pop(context);
                          },
                          actionCallback: () {
                            Navigator.pushNamed(context, '/mapPage',
                                arguments: {
                                  'courseId': progressUser?.data?.courseId,
                                  'sectionId': progressUser?.data?.sectionId
                                });
                          },
                        );
                        return;
                      } else {
                        Navigator.pushNamed(context, '/mapPage', arguments: {
                          'courseId': progressUser?.data?.courseId,
                          'sectionId': progressUser!.data?.sectionId
                        });
                      }
                    } else {
                      Navigator.pushNamed(context, '/introAventurePage');
                    }
                  },
                ),
              ),
            ),

            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  // Versión tablet de los logros
  Widget _buildAchievementsTablet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.grey[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Títulos Alcanzados",
                style:
                    StylesApp(context).textStyCalendar.copyWith(fontSize: 20),
              ),
              if (titles != null && titles!.isNotEmpty)
                Text(
                  "${titles!.length} títulos",
                  style:
                      StylesApp(context).textStyleBody6.copyWith(fontSize: 16),
                ),
            ],
          ),
          SizedBox(height: 16.0),
          Container(
            constraints: BoxConstraints(minHeight: 120),
            decoration: BoxDecoration(
              color: Color(0XFFFFF2C2),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    offset: Offset(0, 4),
                    blurRadius: 5)
              ],
            ),
            child: titles == null || titles!.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Aún no has obtenido títulos",
                        style: StylesApp(context).textStyleBody6.copyWith(
                          color: StyleColor.grayDark
                        ),
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 0.9,
                    ),
                    padding: EdgeInsets.all(16.0),
                    itemCount: titles!.length,
                    itemBuilder: (context, index) {
                      final userProvider =
                          Provider.of<UserProvider>(context, listen: false);
                      final LoginUser? userData = userProvider.currentUser;
                      return _buildTitleItemTablet(
                          context, titles![index], userData!);
                    },
                  ),
          ),
        ],
      ),
    );
  }

// Item de título para tablet
  Widget _buildTitleItemTablet(
      BuildContext context, UserTitle title, LoginUser userData) {
    return GestureDetector(
      onTap: () {
        _showTitleDetailModal(context, title, userData);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0XFFC7AA34),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                offset: Offset(0, 4),
                blurRadius: 5)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(
                      '${GraphQLConfig.urlServidor}${title.img.urlImg}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: Text(
                  title.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      StylesApp(context).textStyleBody10.copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildCollections(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Row(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Colección de Premios",
                style: StylesApp(context).textStyCalendar,
              ),
              ButtonThemeWidget(
                onPressed: () {
                  _dialogAwards(context);
                },
                text: "Ver",
                width: 73.0,
                height: 31.0,
                buttonStyle: StylesApp(context).btnWidgetSmall,
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: ButtonThemeWidget(
            text: "Continuar",
            width: 239.0,
            height: 41.0,
            buttonStyle: StylesApp(context).btnWidgetSmall,
            onPressed: () async {
              await _loadProgress(context);
              if (progressUser != null && progressUser?.success == true) {
                if (progressUser!.message
                    .contains('El curso ya fue finalizado')) {
                  await showCustomDialogWithAction(
                    context,
                    message: progressUser!.message,
                    dialogType: DialogTypeAction.info,
                    buttonOk: "Cerrar",
                    textButton: "ir Al curso",
                    showAction: true,
                    actionCallbackOk: () {
                      Navigator.pop(context);
                    },
                    actionCallback: () {
                      Navigator.pushNamed(context, '/mapPage', arguments: {
                        'courseId': progressUser?.data?.courseId,
                        'sectionId': progressUser?.data?.sectionId
                      });
                    },
                  );
                  return;
                } else {
                  Navigator.pushNamed(context, '/mapPage', arguments: {
                    'courseId': progressUser?.data?.courseId,
                    'sectionId': progressUser!.data?.sectionId
                  });
                }
              } else {
                Navigator.pushNamed(context, '/introAventurePage');
              }
            },
          ),
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Future<dynamic> _dialogAwards(BuildContext context) async {
    // Detectar si estamos en tablet
    final bool _isTablet = isTablet(context);

    // Variables locales para el estado del diálogo
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.currentUser;
    List awards = [];
    PaginationInfo pagination = PaginationInfo(
      currentPage: 0,
      totalPages: 0,
      itemsPerPage: 0,
      totalItems: 0,
      hasPreviousPage: false,
      hasNextPage: false,
    );
    int limit = 12;

    // Función para cargar los premios y la pagination
    Future<void> _loadAwards(
        int page, int limit, String userId, StateSetter setStateDialog) async {
      LoadingService().showLoading(context);

      final responsePrize = await getAllPrize(page, limit, userId);
      if (responsePrize.error != null) {
        LoadingService().hideLoading();
        await showCustomDialog(
          context,
          message: responsePrize.error!,
          dialogType: DialogType.error,
        );
        return;
      }

      LoadingService().hideLoading();
      setStateDialog(() {
        awards = responsePrize.data['data']
            .map((award) => Award.fromJson(removeTypename(award)))
            .cast<Award>()
            .toList();

        pagination =
            PaginationInfo.fromJson(removeTypename(responsePrize.data["meta"]));
      });
    }

    // Llamada inicial para cargar los premios
    final response = await getAllAwards(1, limit, userData!.userId);
    if (response != null) {
      setState(() {
        awards = response["awards"] as List<Award>;
        pagination = response["pagination"] as PaginationInfo;
      });
    } else {
      return;
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: 600, // Máximo ancho para tablet
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header arrastrable
                    Container(
                      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 22.0, vertical: 12.0),
                      margin:
                          EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        "Piedras Preciosas usadas en el pectoral sacerdotal",
                        textAlign: TextAlign.center,
                        style: StylesApp(context).textStyleBody14.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),

                    // Grid de premios para tablet
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      constraints: BoxConstraints(
                        maxHeight: 400,
                        minHeight: 200,
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              _isTablet ? 4 : 3, // Más columnas en tablet
                          crossAxisSpacing: _isTablet ? 12 : 8.0,
                          mainAxisSpacing: _isTablet ? 12 : 8.0,
                          childAspectRatio: _isTablet ? 0.9 : 1.0,
                        ),
                        itemCount: awards.length,
                        itemBuilder: (BuildContext context, int index) {
                          final award = awards[index];
                          return GestureDetector(
                            onTap: award.unLockPrize
                                ? () {
                                    Navigator.pop(context);
                                    _dialogDetailsAdware(award);
                                  }
                                : null,
                            child: Opacity(
                              opacity: award.unLockPrize ? 1 : 0.5,
                              child: Container(
                                width: _isTablet ? null : 80.0,
                                height: _isTablet ? null : 80.0,
                                margin: _isTablet
                                    ? null
                                    : EdgeInsets.only(bottom: 4),
                                decoration: BoxDecoration(
                                  color: award.unLockPrize
                                      ? null
                                      : StyleColor.grayMedium
                                          .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: .15),
                                      offset: Offset(0, 3),
                                      blurRadius: 6,
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: _isTablet ? 60 : 40,
                                        height: _isTablet ? 60 : 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              GraphQLConfig.urlServidor +
                                                  award.img.urlImg,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        award.biblicalName,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: StylesApp(context)
                                            .textStyleBody10
                                            .copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        award.typeStone,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: StylesApp(context)
                                            .textStyleBody10
                                            .copyWith(
                                              color: Colors.grey[700],
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: _isTablet ? 16 : 10.0),

                    // Controles de paginación para tablet
                    if (_isTablet) ...{
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Página ${pagination.currentPage} de ${pagination.totalPages}",
                                  style: StylesApp(context)
                                      .textStyleBody6
                                      .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ButtonThemeWidget(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    text: "Salir",
                                    height: 40.0,
                                    buttonStyle:
                                        StylesApp(context).btnWidgetSmall,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ButtonThemeWidget(
                                        icon: Icons.arrow_back,
                                        colorIcon: Colors.white,
                                        width: 50.0,
                                        height: 40.0,
                                        buttonStyle: StylesApp(context)
                                            .btnWidgetSmall
                                            .copyWith(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      pagination.hasPreviousPage
                                                          ? StyleColor.orange
                                                          : StyleColor
                                                              .grayMedium
                                                              .withValues(
                                                                  alpha: .25)),
                                            ),
                                        onPressed: pagination.hasPreviousPage
                                            ? () async {
                                                await _loadAwards(
                                                  pagination.currentPage - 1,
                                                  limit,
                                                  userData.userId,
                                                  setState,
                                                );
                                              }
                                            : null,
                                      ),
                                      SizedBox(width: 12),
                                      ButtonThemeWidget(
                                        icon: Icons.arrow_forward,
                                        colorIcon: Colors.white,
                                        width: 50.0,
                                        height: 40.0,
                                        buttonStyle: StylesApp(context)
                                            .btnWidgetSmall
                                            .copyWith(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      pagination.hasNextPage
                                                          ? StyleColor.orange
                                                          : StyleColor
                                                              .grayMedium
                                                              .withValues(
                                                                  alpha: .25)),
                                            ),
                                        onPressed: pagination.hasNextPage
                                            ? () async {
                                                await _loadAwards(
                                                  pagination.currentPage + 1,
                                                  limit,
                                                  userData.userId,
                                                  setState,
                                                );
                                              }
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    } else ...{
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ButtonThemeWidget(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              text: "Salir",
                              width: 129.0,
                              height: 35.0,
                              buttonStyle: StylesApp(context).btnWidgetSmall,
                            ),
                            Row(
                              spacing: 10.0,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ButtonThemeWidget(
                                  icon: Icons.arrow_back,
                                  colorIcon: Colors.white,
                                  width: 70.0,
                                  height: 35.0,
                                  buttonStyle: StylesApp(context)
                                      .btnWidgetSmall
                                      .copyWith(
                                        backgroundColor: WidgetStatePropertyAll(
                                            pagination.hasPreviousPage
                                                ? StyleColor.orange
                                                : StyleColor.grayMedium
                                                    .withValues(alpha: .25)),
                                      ),
                                  onPressed: pagination.hasPreviousPage
                                      ? () async {
                                          await _loadAwards(
                                            pagination.currentPage - 1,
                                            limit,
                                            userData.userId,
                                            setState,
                                          );
                                        }
                                      : null,
                                ),
                                ButtonThemeWidget(
                                  icon: Icons.arrow_forward,
                                  colorIcon: Colors.white,
                                  width: 70.0,
                                  height: 35.0,
                                  buttonStyle: StylesApp(context)
                                      .btnWidgetSmall
                                      .copyWith(
                                        backgroundColor: WidgetStatePropertyAll(
                                            pagination.hasNextPage
                                                ? StyleColor.orange
                                                : StyleColor.grayMedium
                                                    .withValues(alpha: .25)),
                                      ),
                                  onPressed: pagination.hasNextPage
                                      ? () async {
                                          await _loadAwards(
                                            pagination.currentPage + 1,
                                            limit,
                                            userData.userId,
                                            setState,
                                          );
                                        }
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    },

                    SizedBox(height: 20),

                    // Espacio para el notch en dispositivos con notch
                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAchievements(BuildContext context) {
    ScrollController scrollController = ScrollController();

    // Detectar si estamos en tablet
    final bool _isTablet = isTablet(context);

    return Container(
      margin: _isTablet
          ? EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
          : EdgeInsets.symmetric(horizontal: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: _isTablet
                ? EdgeInsets.only(left: 8.0, bottom: 12.0)
                : EdgeInsets.zero,
            child: Text(
              textAlign: TextAlign.left,
              "Títulos Alcanzados",
              style: _isTablet
                  ? StylesApp(context).textStyCalendar.copyWith(fontSize: 20)
                  : StylesApp(context).textStyCalendar,
            ),
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: _isTablet ? 110 : 75,
            ),
            height: _isTablet ? 110.sp : 85.sp,
            decoration: BoxDecoration(
              color: Color(0XFFFFF2C2),
              borderRadius: BorderRadius.circular(_isTablet ? 12.0 : 8.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    offset: Offset(0, 4),
                    blurRadius: 5)
              ],
            ),
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              thickness: _isTablet ? 6.0 : 4.0,
              radius: Radius.circular(_isTablet ? 3.0 : 2.0),
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                padding: _isTablet
                    ? EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0)
                    : EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                itemCount: titles!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: _isTablet
                        ? EdgeInsets.only(right: 12.0)
                        : EdgeInsets.only(right: 5.0),
                    child: GestureDetector(
                      onTap: () {
                        final userProvider = Provider.of<UserProvider>(
                          context,
                          listen: false,
                        );
                        LoginUser? userData = userProvider.currentUser;
                        _showTitleDetailModal(
                            context, titles![index], userData!);
                      },
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: _isTablet ? 100.0 : 80.0,
                        ),
                        width: _isTablet ? 100.0 : 80.0,
                        height: _isTablet ? 100.0 : 80.0,
                        decoration: BoxDecoration(
                          color: Color(0XFFC7AA34),
                          borderRadius:
                              BorderRadius.circular(_isTablet ? 12.0 : 8.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                offset: Offset(0, 4),
                                blurRadius: 5)
                          ],
                        ),
                        child: Padding(
                          padding: _isTablet
                              ? EdgeInsets.all(8.0)
                              : EdgeInsets.only(
                                  left: 3.0, top: 6.0, right: 6.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: _isTablet ? 70 : 60,
                                height: _isTablet ? 50 : 40,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(_isTablet ? 10 : 8),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      '${GraphQLConfig.urlServidor}${titles![index].img.urlImg}',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: _isTablet ? 6 : 4),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    titles?[index].title ?? '',
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: _isTablet
                                        ? StylesApp(context)
                                            .textStyleBody10
                                            .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            )
                                        : StylesApp(context).textStyleBody10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _dialogDetailsAdware(item) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding:
              EdgeInsets.only(left: 12.0, right: 12.0, top: 0.0, bottom: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Container(
              width: isTablet(context)
                  ? MediaQuery.sizeOf(context).width * 0.65
                  : MediaQuery.sizeOf(context).width,
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
                    margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 4),
                    constraints: BoxConstraints(minHeight: 38.0),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      "${item.typeStone} es una Piedra preciosa usada en el pectoral sacerdotal",
                      style: StylesApp(context).textStyleBody14,
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 80.0,
                          height: 84.0,
                          child: Image.network(
                              GraphQLConfig.urlServidor + item.img.urlImg,
                              fit: BoxFit.fill),
                        ),
                        Text(item.biblicalName),
                        Text(item.typeStone),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(6.0),
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      constraints: BoxConstraints(minHeight: 233),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: 0.25), // Color de la sombra
                            spreadRadius: 2, // Extensión de la sombra
                            blurRadius: 5, // Difuminado de la sombra
                            offset: Offset(0, 3), // Desplazamiento de la sombra
                          ),
                        ],
                      ),
                      child: Column(
                        spacing: 10.0,
                        children: [
                          Text(
                            item.description,
                            style:
                                StylesApp(context).textStyleBodyWhite4.copyWith(
                                      color: Colors.black,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          item.redeemed
                              ? "Este Premio ya fue canjeado"
                              : "Puedes canjear esta gema por ${item.exchangeValue.toInt()}Lsm de energía",
                          style: StylesApp(context)
                              .textStyleBody14
                              .copyWith(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 7.0,
                      ),
                      Opacity(
                        opacity: item.redeemed ? 0.5 : 1,
                        child: ButtonThemeWidget(
                          onPressed: item.redeemed
                              ? null
                              : () async {
                                  final userProvider =
                                      Provider.of<UserProvider>(context);
                                  final LoginUser? userData =
                                      userProvider.currentUser;
                                  LoadingService().showLoading(context);
                                  final responseRedime = await redeemedPrize(
                                      item.id, userData!.userId);
                                  if (responseRedime.error != null) {
                                    LoadingService().hideLoading();
                                    await showCustomDialog(
                                      context,
                                      message: responseRedime.error!,
                                      dialogType: DialogType.error,
                                    );
                                    return;
                                  } else {
                                    LoadingService().hideLoading();
                                    await showCustomDialog(
                                      context,
                                      message: responseRedime.data,
                                      dialogType: DialogType.info,
                                    );
                                  }
                                  LoadingService().hideLoading();
                                  Navigator.pop(context);
                                },
                          text: "Canjear",
                          width: 132.0,
                          height: 32.0,
                          buttonStyle:
                              StylesApp(context).btnWidgetSmall.copyWith(
                                    backgroundColor: WidgetStatePropertyAll(
                                        item.redeemed
                                            ? StyleColor.grayMedium
                                            : StyleColor.turquoise),
                                  ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonThemeWidget(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: "Aceptar",
                        width: 129.0,
                        height: 35.0,
                        buttonStyle: StylesApp(context).btnWidgetSmall,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>?> getAllAwards(
      int page, int limit, String userId) async {
    LoadingService().showLoading(context);

    final responsePrize = await getAllPrize(page, limit, userId);
    if (responsePrize.error != null) {
      LoadingService().hideLoading();
      await showCustomDialog(
        context,
        message: responsePrize.error!,
        dialogType: DialogType.error,
      );
      return null;
    }

    LoadingService().hideLoading();
    return {
      "awards": responsePrize.data['data']
          .map((award) => Award.fromJson(removeTypename(award)))
          .cast<Award>()
          .toList(),
      "pagination":
          PaginationInfo.fromJson(removeTypename(responsePrize.data["meta"]))
    };
  }

// Método para mostrar el modal del título
  void _showTitleDetailModal(
      BuildContext context, UserTitle title, LoginUser userData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Permite que el modal ocupe casi toda la pantalla
      backgroundColor: Colors.transparent, // Fondo transparente para el modal
      builder: (context) => _buildTitleDetailContent(context, title, userData),
    );
  }

// Widget con el contenido del modal
  Widget _buildTitleDetailContent(
      BuildContext context, UserTitle title, LoginUser userData) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/boxOrange.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 27),
                  Text(
                    "Haz obtenido\n el titulo de\n ${title.title}!",
                    textAlign: TextAlign.center,
                    style: StylesApp(context)
                        .textStyleCongratulation
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 29),
                ],
              ),
            ),
            SizedBox(height: 29),
            Container(
              width: 190,
              decoration: BoxDecoration(
                color: Color(0XFFC7AA34),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.network(
                      GraphQLConfig.urlServidor + title.img.urlImg,
                      height: 80,
                    ),
                    Text(
                      title.title,
                      style: StylesApp(context).textStyleBody12,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 29),
            ButtonThemeWidget(
              width: 245,
              height: 32,
              buttonStyle: StylesApp(context).btnPrimary,
              text: "Descargar certificado",
              onPressed: () async {
                try {
                  final responseDownloadCertificate =
                      await getUrlCertificate(userData.userId, title.courseId);

                  if (responseDownloadCertificate.error != null) {
                    await showCustomDialog(
                      context,
                      message: responseDownloadCertificate.error!,
                      dialogType: DialogType.error,
                    );
                    return;
                  }
                  if (responseDownloadCertificate.data != null) {
                    final url =
                        "${GraphQLConfig.urlServidor}${responseDownloadCertificate.data['url']}";
                    try {
                      final response = await http.get(Uri.parse(url));
                      if (response.statusCode == 200) {
                        final directory =
                            Directory("/storage/emulated/0/Download");
                        if (!directory.existsSync()) {
                          directory.createSync(recursive: true);
                        }
                        final filePath = "${directory.path}/certificado.pdf";
                        final file = File(filePath);
                        await file.writeAsBytes(response.bodyBytes);

                        await showCustomDialogWithAction(
                          context,
                          message:
                              "Certificado descargado exitosamente en: $filePath",
                          dialogType: DialogTypeAction.info,
                          buttonOk: "Ok",
                          actionCallbackOk: () {
                            Navigator.pop(context);
                          },
                          textButton: "Abrir directorio",
                          actionCallback: () async {
                            try {
                              await launchUrl(Uri.file(directory.path));
                            } catch (e) {
                              await showCustomDialog(
                                context,
                                message:
                                    "No se pudo abrir la carpeta de descargas.",
                                dialogType: DialogType.error,
                              );
                            }
                          },
                        );
                      } else {
                        await showCustomDialog(
                          context,
                          message: "No se pudo descargar el certificado.",
                          dialogType: DialogType.error,
                        );
                      }
                    } catch (e) {
                      await showCustomDialog(
                        context,
                        message: "Error al descargar el certificado: $e",
                        dialogType: DialogType.error,
                      );
                    }
                  }
                } catch (e) {
                  await showCustomDialog(
                    context,
                    message: e.toString(),
                    dialogType: DialogType.error,
                  );
                  return;
                }
              },
            ),
            SizedBox(height: 29),
            ButtonThemeWidget(
              showIcon: true,
              icon: Icons.share,
              width: 245,
              height: 32,
              colorIcon: Colors.white,
              buttonStyle: StylesApp(context).btnPrimary,
              text: "Compartir logro",
              onPressed: () async {
                await SharePlus.instance.share(ShareParams(
                  text:
                      "¡He obtenido el titulo de ${title.title}! \n ${GraphQLConfig.urlServidor}OfficialBible",
                  subject: "¡Felicita a ${userData.username}! ",
                ));
              },
            ),
            SizedBox(height: 29),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(
                      "assets/kawaii_fire.png",
                      height: calculateHeight(userData.energyPoints.toDouble()),
                      fit: BoxFit.contain,
                    ),
                    Text(
                      "${userData.energyPoints} lms",
                      style: StylesApp(context)
                          .textStyleBody12
                          .copyWith(color: StyleColor.orange),
                    ),
                  ],
                ),
                ButtonThemeWidget(
                  text: "Aceptar",
                  width: 132,
                  height: 32,
                  buttonStyle: StylesApp(context).btnWidgetSmall,
                  onPressed: () {
                    Navigator.pop(context); // Cierra el modal
                  },
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  double calculateHeight(double score) {
    score = score.abs();

    double maxPossibleHeight = score / 1000 * 112;

    if (score >= maxScore) {
      return 112; // Alto fijo cuando los puntos son mayores o iguales a 1000
    } else {
      double width = ((maxPossibleHeight * 100)) / 112;

      return width > 30 ? ((maxPossibleHeight * 100)) / 112 : 40;
    }
  }
}
