import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await loadVersions();
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: TextFormField(
                  readOnly: listRequest.isEmpty || loading,
                  controller: searchTextController,
                  style: StylesApp(context).textStyleSmallBlack,
                  decoration:
                      StylesApp(context).inputDecorationOutlineStyle.copyWith(
                            hintText: 'Buscar...',
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
                  text: "Asistir Petición",
                  buttonStyle: StylesApp(context).btnWidgetSmall,
                  onPressed: () async {
                    LoadingService().showLoading(context);
                    try {
                      final responseChangeStatus = await changeStatusRequest(
                          listRequest[index].requestId, "En Proceso");
                      if (responseChangeStatus.error != null) {
                        LoadingService().hideLoading();
                        await showCustomDialog(
                          context,
                          message: responseChangeStatus.error!,
                          dialogType: DialogType.error,
                        );
                        return;
                      }
                      LoadingService().hideLoading();
                    } catch (e) {
                      LoadingService().hideLoading();
                      await showCustomDialog(
                        context,
                        message: e.toString(),
                        dialogType: DialogType.error,
                      );
                      return;
                    }

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => PrayerRequestModal(
                        prayerRequest: listRequest[index],
                        emitUpdateList: () async {
                          await _generateData(context, pagination.currentPage,
                              itemPerPageValue);
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
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
    if (query.isEmpty) return; // No buscar si está vacío

    try {
      _generateData(context, pagination.currentPage, pagination.currentPage);
    } catch (e) {
      debugPrint("error al filtrar $e");
    }
  }
}
