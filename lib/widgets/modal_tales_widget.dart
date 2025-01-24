import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModalTalesWidget extends StatefulWidget {
  final List<ButtonData> data;

  const ModalTalesWidget({super.key, required this.data});

  @override
  State<ModalTalesWidget> createState() => _ModalTalesWidgetState();
}

class _ModalTalesWidgetState extends State<ModalTalesWidget> {
  ButtonData? taleSelected;

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
              child: Container(
                constraints: BoxConstraints(minHeight: 44.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                width: double.infinity,
                decoration: BoxDecoration(color: StyleColor.turquoise),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 10,
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                            color: StyleColor.orange,
                            borderRadius: BorderRadius.circular(32.0)),
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            iconSize: 30.0,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Cuentos",
                        style: StylesApp(context).textStyleBody7,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Autocomplete<ButtonData>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<ButtonData>.empty();
                  }
                  return widget.data.where(
                    (ButtonData option) {
                      return option.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    },
                  );
                },
                displayStringForOption: (ButtonData option) => option.name,
                onSelected: (ButtonData selection) {
                  print('You just selected ${selection.name}');
                  setState(() {
                    taleSelected = selection;
                  });
                  print(taleSelected!.name);
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
                          color: Colors.black.withOpacity(0.15),
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
              child: ListView.builder(
                itemCount: widget.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    constraints: BoxConstraints(minHeight: 40.sp),
                    height: 40.sp,
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: ButtonThemeWidget(
                      text: widget.data[index].name,
                      buttonStyle: StylesApp(context).btnWidgetSmall,
                      width: MediaQuery.sizeOf(context).width * 0.7,
                      onPressed: () {
                        setState(() {
                          taleSelected = widget.data[index];
                        });
                      },
                    ),
                  );
                },
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
                    color: Colors.black
                        .withOpacity(0.25), // Negro con 25% de transparencia
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
                      pathUrl:
                          taleSelected != null ? taleSelected!.urlAudio : ''),
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
