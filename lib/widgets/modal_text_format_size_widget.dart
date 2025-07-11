import 'package:biblia_palabra_de_vida_app/models/model_data.dart';
import 'package:biblia_palabra_de_vida_app/providers/bible_theme_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ModalTextFormatSizeWidget extends StatefulWidget {
  final double fontSize;
  final ModelData selectedItem;
  final void Function(double?) onChangedFontSize;
  final void Function(ModelData?) onChangedFont;

  const ModalTextFormatSizeWidget({
    super.key,
    required this.onChangedFontSize,
    required this.onChangedFont,
    required this.fontSize,
    required this.selectedItem,
  });

  @override
  State<ModalTextFormatSizeWidget> createState() =>
      _ModalTextFormatSizeWidgetState();
}

class _ModalTextFormatSizeWidgetState extends State<ModalTextFormatSizeWidget> {
  late double fontSizeValue;
  late ModelData selectedFont;
  late BibleThemeProvider themeProvider;
  @override
  void initState() {
    super.initState();
    setState(() {
      fontSizeValue = widget.fontSize;
      selectedFont = widget.selectedItem;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeProvider = Provider.of<BibleThemeProvider>(context, listen: false);
    });
  }
@override
  void didUpdateWidget(covariant ModalTextFormatSizeWidget oldWidget) {
    setState(() {
      fontSizeValue = widget.fontSize;
      selectedFont = widget.selectedItem;
    });
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 120, // Altura fija para el contenedor padre
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    children: BibleThemeType.values.map((theme) {
                      final currentTheme = BibleTheme.themes[theme]!;
                      final isSelected =
                          Provider.of<BibleThemeProvider>(context)
                                  .currentTheme ==
                              theme;

                      return GestureDetector(
                        onTap: () => Provider.of<BibleThemeProvider>(context,
                                listen: false)
                            .changeTheme(theme),
                        child: Container(
                          width: 100,
                          // height: 100.0,
                          margin: EdgeInsets.only(right: 12),
                          constraints: BoxConstraints(
                            minHeight: 100, // Altura mínima
                            maxHeight: 100, // Altura máxima
                          ),
                          decoration: BoxDecoration(
                            color: currentTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? StyleColor.turquoise
                                  : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2))
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Distribuye el espacio
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Barra superior (AppBar)
                              Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  color: currentTheme.appBarColor,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(6)),
                                ),
                              ),

                              // Texto de muestra
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "AaBbCc",
                                    style: TextStyle(
                                      color: currentTheme.textColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),

                              // Nombre del tema
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue[50]
                                      : Colors.grey[50],
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(6)),
                                ),
                                child: Center(
                                  child: Text(
                                    currentTheme.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.blue[800]
                                          : Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CustomDropdownBottomWidget(
            items: [
              ModelData(label: "Aclonica", value: "1"),
              ModelData(label: "All sane", value: "2"),
              // ModelData(label: "Erica One", value: "3"),
              ModelData(label: "Roboto", value: "3"),
              ModelData(label: "Ysabeau Infant", value: "4"),
            ],
            selectedItem: selectedFont,
            onChanged: (ModelData? newValue) {
              setState((){
                selectedFont = newValue!;
                
              });
              widget.onChangedFont(newValue);
            },
            hintText: "Tipo de fuente",
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  flex: 0,
                  child: GestureDetector(
                    onTap: () {
                      if (fontSizeValue >= 12) {
                        setState(() {
                          fontSizeValue = fontSizeValue - 1;
                        });

                        widget.onChangedFontSize(fontSizeValue);
                      }
                    },
                    child: Icon(
                      Icons.text_decrease,
                      color: StyleColor.turquoise,
                    ),
                  )),
              Expanded(
                flex: 1,
                child: Slider(
                    max: 48.0,
                    min: 12.0,
                    activeColor: Colors.grey,
                    inactiveColor: Colors.grey,
                    thumbColor: StyleColor.orange,
                    value: fontSizeValue,
                    onChanged: (value) {
                      setState(() {
                        fontSizeValue = value;
                      });
                      widget.onChangedFontSize(value);
                    }),
              ),
              Expanded(
                  flex: 0,
                  child: GestureDetector(
                    onTap: () {
                      if (fontSizeValue <= 48) {
                        setState(() {
                          fontSizeValue = fontSizeValue + 1;
                        });

                        widget.onChangedFontSize(fontSizeValue);
                      }
                    },
                    child: Icon(
                      Icons.text_increase_rounded,
                      color: StyleColor.turquoise,
                    ),
                  ))
            ],
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
