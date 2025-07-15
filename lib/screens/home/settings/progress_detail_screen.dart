import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProgressDetailScreen extends StatefulWidget {
  const ProgressDetailScreen({super.key});

  @override
  State<ProgressDetailScreen> createState() => _ProgressDetailScreenState();
}

class _ProgressDetailScreenState extends State<ProgressDetailScreen> {
  List<UserTitle>? titles = [];
  LastProgressUser? progressUser;

  Future<void> _loadProgress(BuildContext context) async {
    LoadingService().showLoading(context);
    final userProvider = Provider.of<UserProvider>(context,
        listen:
            false); // listen: false para evitar reconstrucciones innecesarias
    LoginUser? dataUser = userProvider.currentUser;
    final progressResponse =
        await userProvider.getProgressUser(dataUser?.userId, null);
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
    final userProvider = Provider.of<UserProvider>(context);
    final LoginUser? userData = userProvider.currentUser;
    titles = userData?.title;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8.0)),
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
                                        text: userData!.createdAt.isNotEmpty
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
                                        text:
                                            "${userData.streakDaysCount} días"),
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
                          TextSpan(
                              style: StylesApp(context).chipLevels,
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
              if (progressUser != null) {
                Navigator.pushNamed(context, '/mapPage', arguments: {
                  'courseId': progressUser!.courseId,
                  'sectionId': progressUser!.sectionId
                });
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

    // Función para cargar los premios y la paginación
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
        // Usamos el StateSetter del StatefulBuilder
        awards = responsePrize.data['data']
            .map((award) => Award.fromJson(removeTypename(award)))
            .cast<Award>()
            .toList();

        pagination =
            PaginationInfo.fromJson(removeTypename(responsePrize.data["meta"]));
      });
    }

    // Llamada inicial para cargar los premios
    // No necesitamos el await aquí ya que showDialog lo esperará
    final response = await getAllAwards(1, limit, userData!.userId);
    if (response != null) {
      setState(() {
        awards = response["awards"] as List<Award>;
        pagination = response["pagination"] as PaginationInfo;
      });
    } else {
      return;
    }

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // La llamada inicial ahora se realiza fuera del StatefulBuilder,
            // pero necesitamos la referencia al setState del builder para las paginaciones.

            return Dialog(
              insetPadding:
                  EdgeInsets.only(left: 12.0, right: 12.0, top: 0.0, bottom: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
                      margin:
                          EdgeInsets.symmetric(horizontal: 14.0, vertical: 4),
                      constraints: BoxConstraints(minHeight: 38.0),
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Text(
                        "Piedras Preciosas usadas en el pectoral sacerdotal",
                        style: StylesApp(context).textStyleBody14,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 22.0),
                      constraints: BoxConstraints(maxHeight: 383),
                      height: double.infinity, // Adjust the height as needed
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: awards.length, // Usar la lista local
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
                                width: 80.0,
                                height: 80.0,
                                margin: EdgeInsets.only(bottom: 4),
                                padding: EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                    color: award.unLockPrize
                                        ? null
                                        : StyleColor.grayMedium
                                            .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: .25),
                                          offset: Offset(0, 4),
                                          blurRadius: 2,
                                          blurStyle: BlurStyle.outer)
                                    ]),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Image.network(
                                            GraphQLConfig.urlServidor +
                                                award.img.urlImg,
                                            fit: BoxFit.fill)),
                                    Text(award.biblicalName),
                                    Text(award.typeStone),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
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
                                                    .withValues(alpha: .25))),
                                onPressed: pagination.hasPreviousPage
                                    ? () async {
                                        await _loadAwards(
                                            pagination.currentPage - 1,
                                            limit,
                                            "77",
                                            setState); // Pasar el setState del StatefulBuilder
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
                                                    .withValues(alpha: .25))),
                                onPressed: pagination.hasNextPage
                                    ? () async {
                                        await _loadAwards(
                                            pagination.currentPage + 1,
                                            limit,
                                            "77",
                                            setState); // Pasar el setState del StatefulBuilder
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
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

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            textAlign: TextAlign.left,
            "Títulos Alcanzados",
            style: StylesApp(context).textStyCalendar,
          ),
          Container(
            constraints: BoxConstraints(minHeight: 75),
            height: 85.sp,
            decoration: BoxDecoration(
              color: Color(0XFFFFF2C2),
              borderRadius: BorderRadius.circular(8.0),
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
              thickness: 4.0,
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal, // Dirección horizontal
                itemCount: titles!.length, // Número de elementos
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5.0),
                        constraints: BoxConstraints(minWidth: 80.0),
                        decoration: BoxDecoration(
                          color: Color(0XFFC7AA34),
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                offset: Offset(0, 4),
                                blurRadius: 5)
                          ],
                        ),
                        width: 80.0,
                        height: 80.0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 3.0, top: 6.0, right: 6.0),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      '${GraphQLConfig.urlServidor}${titles![index].img.urlImg}',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    softWrap: true,
                                    '${titles?[index].title}',
                                    style: StylesApp(context).textStyleBody10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                                  item.id, userData!.userId
                                );
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
                        buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
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
}
