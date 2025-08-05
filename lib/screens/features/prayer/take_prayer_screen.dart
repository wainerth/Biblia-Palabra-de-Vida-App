import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TakePrayerScreen extends StatefulWidget {
  const TakePrayerScreen({super.key});

  @override
  State<TakePrayerScreen> createState() => _TakePrayerScreenState();
}

class _TakePrayerScreenState extends State<TakePrayerScreen> {
  List<ModelData> versions = [];
  ModelData? versionSelected;
  String? groupId;
  String? errorMessage;
  bool isLoading = true;
  List<PrayerModel> listRequest = [];
  int itemPerPageValue = 10;
  List<int> itemsPerPage = [
    5,
    10,
    15,
    25,
    50,
    100,
  ];
  PaginationInfo pagination = PaginationInfo(
    currentPage: 1,
    totalPages: 0,
    itemsPerPage: 0,
    totalItems: 0,
    hasPreviousPage: false,
    hasNextPage: false,
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadVersions();
      _generateData(context, pagination.currentPage, itemPerPageValue);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<BibleThemeProvider>(context);
    final currentTheme = themeProvider.themeData;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
              foregroundColor: WidgetStatePropertyAll(StyleColor.white)),
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pop(context);
          },
          splashColor: StyleColor.orange,
          color: StyleColor.white,
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        backgroundColor: StyleColor.white,
        actions: [
          Image.asset(
            "assets/kawaii_fire.png",
            height: 52.0,
            fit: BoxFit.contain,
          )
        ],
      ),
      backgroundColor: StyleColor.turquoise,
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/elipsisTop.png"),
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 48.0,
                ),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'Pedidos de Oración',
                    style: StylesApp(context).textStyleTitleOrange,
                  ),
                ),
                SizedBox(
                  height: 35.sp,
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
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
          await getAllRequestPrayerByGroupId(null, null, groupId, null);
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

  Container _cardListItem(BuildContext context, int index) {
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
                        text: "Fecha hora: ",
                        style: StylesApp(context).textStyleBody2_14),
                    TextSpan(
                        text: listRequest[index].requestDate,
                        style: StylesApp(context)
                            .textStyleBody2_14
                            .copyWith(color: Colors.black)),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: "Por: ",
                        style: StylesApp(context).textStyleBody2_14),
                    TextSpan(
                        text: listRequest[index].requestedBy,
                        style: StylesApp(context)
                            .textStyleBody2_14
                            .copyWith(color: Colors.black)),
                  ],
                ),
              ),
              Text.rich(
                softWrap: true,
                TextSpan(
                  children: [
                    TextSpan(
                        text: "Oración por: ",
                        style: StylesApp(context).textStyleBody2_14),
                    TextSpan(
                      text: listRequest[index].prayerCategory.name.trim(),
                      style: StylesApp(context)
                          .textStyleBody2_14
                          .copyWith(color: Colors.black),
                    ),
                    TextSpan(
                        text: " / ",
                        style: StylesApp(context).textStyleBody2_14),
                    TextSpan(
                        text: listRequest[index].prayerSubType.name,
                        style: StylesApp(context)
                            .textStyleBody2_14
                            .copyWith(color: Colors.black)),
                  ],
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Center(
                child: ButtonThemeWidget(
                  width: 180,
                  text: "Tomar el pedido",
                  buttonStyle: StylesApp(context).btnWidgetSmall,
                  onPressed: () {
                    _buildModalAskedRequest(listRequest[index]);
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _buildModalAskedRequest(PrayerModel listRequest) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        final TextEditingController messageController = TextEditingController();
        final TextEditingController verseController = TextEditingController();
        return Dialog(
          backgroundColor: StyleColor.white,
          insetPadding: EdgeInsets.zero,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  leading: IconButton.filled(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(StyleColor.orange),
                        foregroundColor:
                            WidgetStatePropertyAll(StyleColor.white)),
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    splashColor: StyleColor.orange,
                    color: StyleColor.white,
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                  ),
                  backgroundColor: StyleColor.white,
                  actions: [
                    Image.asset(
                      "assets/kawaii_fire.png",
                      height: 52.0,
                      fit: BoxFit.contain,
                    )
                  ],
                ),
                backgroundColor: StyleColor.turquoise,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 0,
                      right: 0,
                      top: 0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: const AssetImage("assets/elipsisTop.png"),
                              fit: BoxFit.cover,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 48.0,
                              ),
                              Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'Responder Pedido\n de Oración',
                                  style:
                                      StylesApp(context).textStyleTitleOrange,
                                ),
                              ),
                              SizedBox(
                                height: 35.sp,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: StyleColor.white,
                              borderRadius: BorderRadius.circular(8.0)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "Fecha hora: ",
                                        style: StylesApp(context)
                                            .textStyleBody2_14),
                                    TextSpan(
                                        text: listRequest.requestDate,
                                        style: StylesApp(context)
                                            .textStyleBody2_14
                                            .copyWith(color: Colors.black)),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "Solicitante: ",
                                        style: StylesApp(context)
                                            .textStyleBody2_14),
                                    TextSpan(
                                      text: listRequest.requestedBy,
                                      style: StylesApp(context)
                                          .textStyleBody2_14
                                          .copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "Pide por: ",
                                        style: StylesApp(context)
                                            .textStyleBody2_14),
                                    TextSpan(
                                      text: listRequest.prayedFor,
                                      style: StylesApp(context)
                                          .textStyleBody2_14
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
                                        text: "Oración por: ",
                                        style: StylesApp(context)
                                            .textStyleBody2_14),
                                    TextSpan(
                                      text: listRequest.prayerCategory.name
                                          .trim(),
                                      style: StylesApp(context)
                                          .textStyleBody2_14
                                          .copyWith(color: Colors.black),
                                    ),
                                    TextSpan(
                                        text: " / ",
                                        style: StylesApp(context)
                                            .textStyleBody2_14),
                                    TextSpan(
                                      text: listRequest.prayerSubType.name,
                                      style: StylesApp(context)
                                          .textStyleBody2_14
                                          .copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "Descripción: ",
                                        style: StylesApp(context)
                                            .textStyleBody2_14),
                                    TextSpan(
                                        text: listRequest.prayerDetails,
                                        style: StylesApp(context)
                                            .textStyleBody2_14
                                            .copyWith(color: Colors.black)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              AudioPlayerWidget(
                                pathUrl: listRequest.audioPrayer != null
                                    ? "${GraphQLConfig.urlServidor}${listRequest.audioPrayer!.url}"
                                    : '',
                                showImage: false,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 21.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                                labelText: "Mensaje (opcional)",
                                border: OutlineInputBorder(),
                                fillColor: StyleColor.white,
                                filled: true),
                            maxLines: 3,
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: CustomDropdownBottomWidget(
                            items: versions,
                            hintText: "Seleccione una versión",
                            onChanged: (ModelData? newValue) {
                              setState(() {
                                versionSelected = newValue;
                              });
                            },
                            selectedItem: versionSelected,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: verseController,
                            decoration: InputDecoration(
                                labelText:
                                    'Versículo (opcional, ej: Mateo 1:5 "Y Jehová Dios")',
                                border: OutlineInputBorder(),
                                fillColor: StyleColor.white,
                                filled: true),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(height: 24),
                        ButtonThemeWidget(
                          width: double.infinity,
                          text: "Tomar pedido",
                          buttonStyle: StylesApp(context).btnWidgetSmall,
                          onPressed: () async {
                            final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            final userData = userProvider.currentUser;
                            Navigator.of(context).pop();
                            setState(() {
                              isLoading = true;
                            });
                            // Llama al servicio para cambiar el statusRequest a "en proceso"
                            final response = await answerPrayerRequest(
                              messageController.text.trim().isEmpty
                                  ? null
                                  : messageController.text.trim(),
                              listRequest.requestId,
                              userData!.userId,
                              verseController.text.trim().isEmpty
                                  ? null
                                  : verseController.text.trim(),
                            );
                            if (response.error != null) {
                              setState(() {
                                errorMessage = response.error!;
                                isLoading = false;
                              });
                            } else {
                              await _generateData(context,
                                  pagination.currentPage, itemPerPageValue);
                            }
                          },
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> loadVersions() async {
    try {
      setState(() {
        versions = Provider.of<CatalogueProvider>(context, listen: false)
            .allBibleVersion
            .map<ModelData>((version) =>
                ModelData(label: version.version, value: version.id))
            .toList();
      });

      //
    } catch (e) {
      print(e.toString());
    }
  }
}
