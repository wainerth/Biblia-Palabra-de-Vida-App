import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/bible_theme_provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
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
  dynamic dataSeleccionada = {};
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

  _deleteItem(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirmación",
            style: StylesApp(context)
                .textStyleBody2
                .copyWith(color: StyleColor.black),
          ),
          content: Text(
            "¿Está seguro de que desea eliminar esta petición?",
            style: StylesApp(context)
                .textStyleBody16
                .copyWith(color: StyleColor.black),
          ),
          actions: [
            TextButton(
              child: Text(
                "No",
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
                "Sí",
                style: StylesApp(context)
                    .textStyleBody10
                    .copyWith(color: StyleColor.lavenderMist),
              ),
              onPressed: () async {
                try {
                  final responseDelete = await deleteRequestPrayer(id);
                  if (responseDelete.error != null) {
                    await showCustomDialog(context,
                        message: responseDelete.error!,
                        dialogType: DialogType.error);
                    return;
                  }
                  Navigator.of(context).pop();
                  setState(() {
                    listRequest.removeWhere((item) => item.requestId == id);
                  });
                } catch (e) {
                  await showCustomDialog(context,
                      message: e.toString(), dialogType: DialogType.error);
                  return;
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateData(context, pagination.currentPage, itemPerPageValue);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<BibleThemeProvider>(context);
    final currentTheme = themeProvider.themeData;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: StyleColor.turquoise,
          ),
          child: Column(
            children: [
              HeadScreenNotAvatar(
                title: "Respuestas de\n Pedidos de Oración",
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
        ),
      ),
    );
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
                      text: "${listRequest[index].prayerCategory.name.trim()}",
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
                    _deleteItem(listRequest[index].requestId);
                  },
                  icon: Icon(Icons.delete_outline)))
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
      final responseListRequest =
          await getAllRequestPrayerByUser(userData?.userId);
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
}
