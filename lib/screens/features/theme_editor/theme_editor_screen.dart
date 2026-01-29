import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/bible_theme_provider.dart';
import 'package:biblia_palabra_de_vida_app/models/custom_theme_model.dart';

class ThemeEditorScreen extends StatefulWidget {
  final CustomTheme? existingTheme;

  const ThemeEditorScreen({super.key, this.existingTheme});

  @override
  State<ThemeEditorScreen> createState() => _ThemeEditorScreenState();
}

class _ThemeEditorScreenState extends State<ThemeEditorScreen> {
  TextEditingController _nameController = TextEditingController();
  late Color _backgroundColor;
  late Color _textColor;
  late Color _appBarColor;
  late Color _buttonColor;
  late Color _buttonTextColor;
  late Color _verseHighlightColor;
  late BibleTheme currentTheme;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (widget.existingTheme != null) {
      _nameController.text = widget.existingTheme!.name;
      _backgroundColor = widget.existingTheme!.backgroundColor;
      _textColor = widget.existingTheme!.textColor;
      _appBarColor = widget.existingTheme!.appBarColor;
      _buttonColor = widget.existingTheme!.buttonColor;
      _buttonTextColor = widget.existingTheme!.buttonTextColor;
      _verseHighlightColor = widget.existingTheme!.verseHighlightColor;
    } else {
      _nameController = TextEditingController(text: "Tema Personalizado");
      _backgroundColor = Colors.white;
      _textColor = Colors.black;
      _appBarColor = Colors.blue;
      _buttonColor = Colors.blue;
      _buttonTextColor = Colors.white;
      _verseHighlightColor = Colors.yellow[200]!;
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<BibleThemeProvider>(context);
    currentTheme = themeProvider.themeData;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                  currentTheme.name != 'light'
                      ? currentTheme.buttonColor
                      : StyleColor.orange),
              foregroundColor:
                  WidgetStatePropertyAll(currentTheme.buttonTextColor)),
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pop(context);
          },
          splashColor: currentTheme.buttonColor,
          color: currentTheme.textColor,
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        backgroundColor: currentTheme.appBarColor,
        title: Text(
          widget.existingTheme != null ? 'Editar Tema' : 'Nuevo Tema',
          style: StylesApp(context)
              .textStyleBody16
              .copyWith(color: currentTheme.textColor),
        ),
        actions: [
          if (widget.existingTheme != null)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: currentTheme.buttonColor),
              child: IconButton(
                color: currentTheme.buttonTextColor,
                icon: Icon(Icons.delete),
                onPressed: () => _deleteTheme(context),
              ),
            ),
        ],
      ),
      backgroundColor: currentTheme.backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: currentTheme.textColor),
              decoration: InputDecoration(
                labelText: 'Nombre del tema',
                labelStyle: StylesApp(context)
                    .textStyleBody14
                    .copyWith(color: currentTheme.textColor),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
              // Appbar
             _buildColorPicker(
              'Color de AppBar',
              _appBarColor,
              (color) => setState(() => _appBarColor = color),
            ),
            _buildColorPicker('Color de fondo', _backgroundColor, (color) {
              setState(() {
                _backgroundColor = color;
              });
            }),
            _buildColorPicker(
              'Color de texto',
              _textColor,
              (color) => setState(() => _textColor = color),
            ),
           
            _buildColorPicker(
              'Color de botones',
              _buttonColor,
              (color) => setState(() => _buttonColor = color),
            ),
            _buildColorPicker(
              'Color de texto en botones',
              _buttonTextColor,
              (color) => setState(() => _buttonTextColor = color),
            ),
            _buildColorPicker(
              'Color de resaltado',
              _verseHighlightColor,
              (color) => setState(() => _verseHighlightColor = color),
            ),
            SizedBox(height: 30),
            _buildPreview(),
            SizedBox(height: 30),
            ButtonThemeWidget(
              text: widget.existingTheme != null
                  ? "MODIFICAR TEMA"
                  : "GUARDAR TEMA",
              buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                  backgroundColor: WidgetStatePropertyAll(
                    currentTheme.buttonColor,
                  ),
                  foregroundColor:
                      WidgetStatePropertyAll(currentTheme.buttonTextColor)),
              onPressed: () => _saveTheme(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker(
      String label, Color currentColor, ValueChanged<Color> onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: StylesApp(context)
                  .textStyleBody10
                  .copyWith(color: currentTheme.textColor),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await showDialog<Color>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: currentTheme.backgroundColor,
                  title: Text(
                    'Seleccionar color',
                    style: StylesApp(context)
                        .textStyleBody10
                        .copyWith(color: currentTheme.textColor),
                  ),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: currentColor,
                      onColorChanged: (color) {
                        setState(() {
                          currentColor = color;
                        });
                      },
                      showLabel: true,
                      pickerAreaHeightPercent: 0.7,
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        'Cancelar',
                        style: StylesApp(context)
                            .textStyleBody10
                            .copyWith(color: currentTheme.textColor),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text(
                        'Seleccionar',
                        style: StylesApp(context)
                            .textStyleBody10
                            .copyWith(color: currentTheme.textColor),
                      ),
                      onPressed: () => Navigator.of(context).pop(currentColor),
                    ),
                  ],
                ),
              );
              // if (currentColor != null)
              onChanged(currentColor);
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: currentColor,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      margin: EdgeInsets.only(right: 12),
      constraints: BoxConstraints(),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Distribuye el espacio
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barra superior (AppBar)
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: _appBarColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
            ),
          ),

          // Texto de muestra
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "AaBbCc",
                style: TextStyle(
                  color: _textColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          ButtonThemeWidget(
            buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                backgroundColor: WidgetStatePropertyAll(_buttonColor),
                foregroundColor: WidgetStatePropertyAll(_buttonTextColor)),
            onPressed: () {},
            text: 'Botón',
          ),
          SizedBox(height: 16),
          // Nombre del tema
          Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
            ),
            child: Center(
              child: Text(
                _nameController.text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveTheme(BuildContext context) async {
    if (_nameController.text.isEmpty) {
      showSnackBar("Por favor ingresa un nombre para el tema",
                        type: SnackBarType.info);
      return;
    }

    final themeProvider =
        Provider.of<BibleThemeProvider>(context, listen: false);
    final newTheme = CustomTheme(
      id: widget.existingTheme?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      backgroundColor: _backgroundColor,
      textColor: _textColor,
      appBarColor: _appBarColor,
      buttonColor: _buttonColor,
      buttonTextColor: _buttonTextColor,
      verseHighlightColor: _verseHighlightColor,
    );

    if (widget.existingTheme != null) {
      // Actualizar tema existente
      themeProvider.removeCustomTheme(widget.existingTheme!.id);
    }

    await themeProvider.addCustomTheme(newTheme);
    await themeProvider.applyCustomTheme(newTheme);

    Navigator.of(context).pop();
  }

  Future<void> _deleteTheme(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar tema'),
        content: Text('¿Estás seguro de que quieres eliminar este tema?'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Eliminar'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final themeProvider =
          Provider.of<BibleThemeProvider>(context, listen: false);
      await themeProvider.removeCustomTheme(widget.existingTheme!.id);
      Navigator.of(context).pop();
    }
  }
}
