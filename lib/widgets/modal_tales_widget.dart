import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      await showCustomDialog(
        context,
        message: response.error!,
        dialogType: DialogType.error,
      );
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
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: SimpleHeaderWidget(
                title: 'Cuentos',
                onRoute: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
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
                    style: StylesApp(context)
                        .textStyleBody12
                        .copyWith(color: Colors.black),
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'Buscar cuento',
                      suffixIcon: Icon(
                        Icons.search,
                        size: 20.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.black.withValues(alpha: 0.15),
                        ),
                      ),
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
                        width: MediaQuery.of(context).size.width * 0.8,
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
                                      .copyWith(color: Colors.black),
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
                  ListView.builder(
                    itemCount: _localReflection!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        constraints: BoxConstraints(minHeight: 40.sp),
                        height: 40.sp,
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
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
                  ),
                  Positioned(
                    bottom: 5,
                    left: 5,
                    child: Container(
                      width: 40,
                      height: 40,
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
                      child: IconButton(
                        onPressed: _localPagination!.hasPreviousPage
                            ? () async {
                                await loadMoreReflection(
                                    _localPagination!.currentPage - 1,
                                    limit,
                                    title);
                              }
                            : null,
                        icon: Icon(Icons.arrow_back),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      width: 40,
                      height: 40,
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
                      child: IconButton(
                        onPressed: _localPagination!.hasNextPage
                            ? () async {
                                await loadMoreReflection(
                                    _localPagination!.currentPage + 1,
                                    limit,
                                    title);
                              }
                            : null,
                        icon: Icon(Icons.arrow_forward),
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Color de fondo del contenedor
                borderRadius: BorderRadius.circular(
                    10), // Opcional: Si deseas esquinas redondeadas
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -4),
                    blurRadius: 4,
                    color: Colors.black.withValues(
                        alpha: 0.25), // Negro con 25% de transparencia
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 13.0,
                  ),
                  Text(
                    taleSelected?.name ?? '',
                    style: StylesApp(context)
                        .textStyleBody12
                        .copyWith(color: StyleColor.turquoise),
                  ),
                  AudioPlayerWidget(
                      controlsColor: StyleColor.turquoise,
                      inactiveColor: StyleColor.orange,
                      showImage: false,
                      backgroundColor: Colors.white,
                      fileName: taleSelected != null ?  taleSelected!.name : '',
                      pathUrl:
                          taleSelected != null ? "${GraphQLConfig.urlServidor}${taleSelected!.urlAudio}" : ''),
                  SizedBox(height: 13.0)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
