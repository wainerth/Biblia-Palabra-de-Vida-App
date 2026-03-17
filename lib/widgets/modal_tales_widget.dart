import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ModalTalesWidget extends StatefulWidget {
  final List<ButtonData> data;
  final PaginationInfo pagination;

  const ModalTalesWidget(
      {super.key, required this.data, required this.pagination});

  @override
  State<ModalTalesWidget> createState() => _ModalTalesWidgetState();
}

class _ModalTalesWidgetState extends State<ModalTalesWidget> {
  ButtonData? taleSelected;
  List<ButtonData>? _localReflection;
  PaginationInfo? _localPagination;
  String title = '';
  int limit = 12;

  // Detectar si es tablet
  bool get isTablet => 1.sw > 550.0; // Ancho mayor a 600 puntos

  @override
  void initState() {
    super.initState();
    setState(() {
      _localReflection = widget.data;
      _localPagination = widget.pagination;
    });
  }

  Future<void> loadMoreReflection(
    int page,
    int limit,
    String title,
  ) async {
    LoadingService().showLoading(context);
    final response = await getAllReflections(page, limit, title);
    if (response.error != null) {
      LoadingService().hideLoading();
      if (mounted) {
        await showCustomDialog(
          context,
          message: response.error!,
          dialogType: DialogType.error,
        );
      }
      return;
    }
    LoadingService().hideLoading();
    setState(() {
      final reflections = response.data['data']
          .map<Reflection>(
              (reflex) => Reflection.fromJson(removeTypename(reflex)))
          .toList();
      _localReflection = reflections
          .map<ButtonData>((reflection) => ButtonData(
              id: reflection.id,
              name: reflection.title,
              urlAudio: reflection.url))
          .toList();
      _localPagination =
          PaginationInfo.fromJson(removeTypename(response.data['meta']));
    });
  }

  @override
  Widget build(BuildContext context) {
    final translationProvider = context.read<AppTranslationProvider>();
    return Dialog(
      insetPadding: isTablet
          ? EdgeInsets.symmetric(
              horizontal: 50.w, vertical: 40.h) // Más margen en tablet
          : EdgeInsets.all(0), // Pantalla completa en móvil
      child: Container(
        width: isTablet ? 600 : double.infinity,
        height: isTablet ? 0.8.sh : null, // Altura fija en tablet
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: SimpleHeaderWidget(
                title: translationProvider.tr('modal_tales.title'),
                onRoute: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(
                  isTablet ? 24.0 : 16.0), // Más padding en tablet
              child: Autocomplete<ButtonData>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<ButtonData>.empty();
                  }
                  return _localReflection!.where(
                    (ButtonData option) {
                      return option.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    },
                  );
                },
                displayStringForOption: (ButtonData option) => option.name,
                onSelected: (ButtonData selection) {
                  if (kDebugMode) {
                    print('You just selected ${selection.name}');
                  }
                  setState(() {
                    taleSelected = selection;
                  });
                  if (kDebugMode) {
                    print(taleSelected!.name);
                  }
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  textEditingController.clear();
                  return TextField(
                    controller: textEditingController,
                    style: StylesApp(context).textStyleBody12.copyWith(
                          color: Colors.black,
                          fontSize: isTablet
                              ? 16
                              : 12.sp, // Texto más grande en tablet
                        ),
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText:translationProvider.tr('modal_tales.search_placeholder'),
                      suffixIcon: Icon(
                        Icons.search,
                        size: isTablet
                            ? 24.sp
                            : 20.sp, // Ícono más grande en tablet
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.black.withValues(alpha: 0.15),
                        ),
                      ),
                      contentPadding: isTablet
                          ? EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 12.0)
                          : null,
                    ),
                    onSubmitted: (String value) {
                      textEditingController.clear();
                    },
                  );
                },
                optionsViewBuilder: (BuildContext context,
                    AutocompleteOnSelected<ButtonData> onSelected,
                    Iterable<ButtonData> options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            (isTablet ? 0.6 : 0.8),
                        color: Colors.white,
                        child: ListView.builder(
                          padding: EdgeInsets.all(8.0),
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final ButtonData option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                title: Text(
                                  option.name,
                                  style: StylesApp(context)
                                      .textStyleBody12
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: isTablet ? 14.sp : 12.sp,
                                      ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  // Layout diferente para tablet vs móvil
                  ResponsiveLayout(
                    mobile: _buildMobileLayout(),
                    tablet: _buildTabletLayout(),
                  ),
                  Positioned(
                    bottom: isTablet ? 15.h : 5.h,
                    left: isTablet ? 15.w : 5.w,
                    child: Container(
                      width: isTablet ? 50.w : 40.w,
                      height: isTablet ? 50.h : 40.h,
                      decoration: BoxDecoration(
                        color: StyleColor.orange,
                        boxShadow: [
                          BoxShadow(
                              color: StyleColor.black.withValues(alpha: .75),
                              offset: Offset(0, 3),
                              blurRadius: 10)
                        ],
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: _localPagination!.hasPreviousPage
                              ? () async {
                                  await loadMoreReflection(
                                      _localPagination!.currentPage - 1,
                                      limit,
                                      title);
                                }
                              : null,
                          icon: Icon(
                            Icons.arrow_back,
                            size: isTablet ? 20.sp : 20.sp,
                          ),
                          color: Colors.white,
                           tooltip: translationProvider.tr('modal_tales.prev_page'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: isTablet ? 15.h : 5.h,
                    right: isTablet ? 15.w : 5.w,
                    child: Container(
                      width: isTablet ? 50.w : 40.w,
                      height: isTablet ? 50.h : 40.h,
                      decoration: BoxDecoration(
                        color: StyleColor.orange,
                        boxShadow: [
                          BoxShadow(
                              color: StyleColor.black.withValues(alpha: .75),
                              offset: Offset(0, 3),
                              blurRadius: 10)
                        ],
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: _localPagination!.hasNextPage
                              ? () async {
                                  await loadMoreReflection(
                                      _localPagination!.currentPage + 1,
                                      limit,
                                      title);
                                }
                              : null,
                          icon: Icon(
                            Icons.arrow_forward,
                            size: isTablet ? 18.sp : 20.sp,
                          ),
                          color: Colors.white,
                          tooltip: translationProvider.tr('modal_tales.next_page'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -4),
                    blurRadius: 4,
                    color: Colors.black.withValues(alpha: 0.25),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: isTablet ? 18.0 : 13.0,
                  ),
                  Text(
                    taleSelected?.name ?? '',
                    style: StylesApp(context).textStyleBody12.copyWith(
                          color: StyleColor.turquoise,
                          fontSize: isTablet ? 16 : 12.sp,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isTablet ? 8.0 : 0),
                  AudioPlayerWidget(
                      controlsColor: StyleColor.turquoise,
                      inactiveColor: StyleColor.orange,
                      showImage: false,
                      backgroundColor: Colors.white,
                      fileName: taleSelected != null ? taleSelected!.name : '',
                      pathUrl: taleSelected != null
                          ? "${GraphQLConfig.urlServidor}${taleSelected!.urlAudio}"
                          : ''),
                  SizedBox(height: isTablet ? 20.0 : 13.0)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Layout para móvil (el original)
  Widget _buildMobileLayout() {
    return ListView.builder(
      itemCount: _localReflection!.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          constraints: BoxConstraints(minHeight: 40.sp),
          height: 40.sp,
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: ButtonThemeWidget(
            text: _localReflection![index].name,
            buttonStyle: StylesApp(context).btnWidgetSmall,
            width: MediaQuery.sizeOf(context).width * 0.7,
            height: 27.0,
            onPressed: () {
              setState(() {
                taleSelected = _localReflection![index];
              });
            },
          ),
        );
      },
    );
  }

  // Layout para tablet
  Widget _buildTabletLayout() {
    return GridView.builder(
      padding: EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Dos columnas en tablet
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 4.0, // Relación ancho/alto de los botones
      ),
      itemCount: _localReflection!.length,
      itemBuilder: (BuildContext context, int index) {
        return ButtonThemeWidget(
          text: _localReflection![index].name,
          buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                textStyle: WidgetStatePropertyAll(
                  StylesApp(context).textStyleBody12.copyWith(
                        fontSize: 14, // Texto más grande en tablet
                      ),
                ),
              ),
          width: double.infinity,
          height: 50.0, // Botones más altos en tablet
          onPressed: () {
            setState(() {
              taleSelected = _localReflection![index];
            });
          },
        );
      },
    );
  }
}
