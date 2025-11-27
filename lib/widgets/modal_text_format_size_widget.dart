import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/bible_theme_provider.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
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
    return SafeArea(
      child: Container(
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
                        children: [
                          // temas predefinidos
                          ...BibleThemeType.values.map((theme) {
                            final currentTheme = BibleTheme.themes[theme];
                            final isSelected =
                                Provider.of<BibleThemeProvider>(context)
                                        .currentTheme ==
                                    theme;

                            return GestureDetector(
                              onTap: () => Provider.of<BibleThemeProvider>(
                                      context,
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
                                  color: currentTheme?.backgroundColor,
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
                                        color: currentTheme?.appBarColor,
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
                                            color: currentTheme?.textColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Nombre del tema
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.blue[50]
                                            : Colors.grey[50],
                                        borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(6)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          currentTheme != null
                                              ? currentTheme.name
                                              : '',
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
                          }),
                          ...Provider.of<BibleThemeProvider>(context)
                              .customThemes
                              .map((customTheme) {
                            final isSelected =
                                Provider.of<BibleThemeProvider>(context)
                                        .isCustomTheme &&
                                    Provider.of<BibleThemeProvider>(context)
                                            .currentCustomTheme
                                            ?.id ==
                                        customTheme.id;

                            return GestureDetector(
                              onTap: () => Provider.of<BibleThemeProvider>(
                                      context,
                                      listen: false)
                                  .applyCustomTheme(customTheme),
                              // onLongPress: () =>
                              //     _editCustomTheme(context, customTheme),
                              child: Stack(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                children: [
                                  Container(
                                    width: 100,
                                    margin: EdgeInsets.only(right: 12),
                                    constraints: BoxConstraints(
                                      minHeight: 100,
                                      maxHeight: 100,
                                    ),
                                    decoration: BoxDecoration(
                                      color: customTheme.backgroundColor,
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
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: customTheme.appBarColor,
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(6)),
                                          ),
                                        ),
                                        Flexible(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              "AaBbCc",
                                              style: TextStyle(
                                                color: customTheme.textColor,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.blue[50]
                                                : Colors.grey[50],
                                            borderRadius: BorderRadius.vertical(
                                                bottom: Radius.circular(6)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              customTheme.name,
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
                                  Positioned(
                                    top: -16,
                                    right: -10,
                                    child: IconButton(
                                      onPressed: () {
                                        _editCustomTheme(context, customTheme);
                                      },
                                      icon: Icon(Icons.mode_edit_outline_outlined),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          // botón para agregar nuevo tema
                          GestureDetector(
                              onTap: () => _showAddThemeDialog(context),
                              child: Container(
                                width: 100,
                                margin: EdgeInsets.only(right: 12),
                                constraints: BoxConstraints(
                                  minHeight: 100,
                                  maxHeight: 100,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 30,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Nuevo tema',
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                  ],
                                ),
                              ))
                        ]),
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
                ModelData(label: "Roboto", value: "3"),
                ModelData(label: "Ysabeau Infant", value: "4"),
                ModelData(label: "Handwriting", value: "5"),
              ],
              selectedItem: selectedFont,
              onChanged: (ModelData? newValue) {
                setState(() {
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
      ),
    );
  }

  void _showAddThemeDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ThemeEditorScreen()),
    );
  }

  void _editCustomTheme(BuildContext context, CustomTheme theme) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ThemeEditorScreen(existingTheme: theme),
      ),
    );
  }
}
