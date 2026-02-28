import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
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
  final translationProvider = AppTranslationProvider();
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
    if (widget.existingTheme != null) {
      _nameController.text = widget.existingTheme!.name;
      _backgroundColor = widget.existingTheme!.backgroundColor;
      _textColor = widget.existingTheme!.textColor;
      _appBarColor = widget.existingTheme!.appBarColor;
      _buttonColor = widget.existingTheme!.buttonColor;
      _buttonTextColor = widget.existingTheme!.buttonTextColor;
      _verseHighlightColor = widget.existingTheme!.verseHighlightColor;
    } else {
      _nameController = TextEditingController(
          text: translationProvider.tr("theme_editor_screen.title.text_input"));
      _backgroundColor = Colors.white;
      _textColor = Colors.black;
      _appBarColor = Colors.blue;
      _buttonColor = Colors.blue;
      _buttonTextColor = Colors.white;
      _verseHighlightColor = Colors.yellow[200]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<BibleThemeProvider>(context);
    currentTheme = themeProvider.themeData;

    // Usar layout diferente según el dispositivo
    return ResponsiveLayout(
      mobile: _buildMobileLayout(context, themeProvider),
      tablet: _buildTabletLayout(context, themeProvider),
    );
  }

  // LAYOUT PARA MÓVIL (manteniendo tu diseño actual)
  Widget _buildMobileLayout(
      BuildContext context, BibleThemeProvider themeProvider) {
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
          widget.existingTheme != null
              ? translationProvider.tr("theme_editor_screen.title.edit")
              : translationProvider.tr("theme_editor_screen.title.new"),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                style: StylesApp(context)
                    .textStyleBody12
                    .copyWith(color: currentTheme.textColor),
                decoration: InputDecoration(
                  labelText: translationProvider
                      .tr("theme_editor_screen.fields.theme_name"),
                  labelStyle: StylesApp(context)
                      .textStyleBody14
                      .copyWith(color: currentTheme.textColor),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Selectores de color
              _buildColorPicker(
                translationProvider.tr("theme_editor_screen.fields.color_appbar"),
                _appBarColor,
                (color) => setState(() => _appBarColor = color),
              ),
              _buildColorPicker(
                  translationProvider
                      .tr("theme_editor_screen.fields.color_background"),
                  _backgroundColor, (color) {
                setState(() {
                  _backgroundColor = color;
                });
              }),
              _buildColorPicker(
                translationProvider.tr("theme_editor_screen.fields.color_text"),
                _textColor,
                (color) => setState(() => _textColor = color),
              ),
              _buildColorPicker(
                translationProvider.tr("theme_editor_screen.fields.color_button"),
                _buttonColor,
                (color) => setState(() => _buttonColor = color),
              ),
              _buildColorPicker(
                translationProvider
                    .tr("theme_editor_screen.fields.color_button_text"),
                _buttonTextColor,
                (color) => setState(() => _buttonTextColor = color),
              ),
              _buildColorPicker(
                translationProvider
                    .tr("theme_editor_screen.fields.color_highlight"),
                _verseHighlightColor,
                (color) => setState(() => _verseHighlightColor = color),
              ),
              SizedBox(height: 30),
              _buildPreview(),
              SizedBox(height: 30),
              ButtonThemeWidget(
                text: widget.existingTheme != null
                    ? translationProvider.tr("theme_editor_screen.buttons.update")
                    : translationProvider.tr("theme_editor_screen.buttons.save"),
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
      ),
    );
  }

  // LAYOUT PARA TABLET (nuevo diseño optimizado)
  Widget _buildTabletLayout(
      BuildContext context, BibleThemeProvider themeProvider) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              currentTheme.name != 'light'
                  ? currentTheme.buttonColor
                  : StyleColor.orange,
            ),
            foregroundColor:
                WidgetStatePropertyAll(currentTheme.buttonTextColor),
          ),
          padding: EdgeInsets.all(0),
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, size: 30),
        ),
        backgroundColor: currentTheme.appBarColor,
        title: Text(
          widget.existingTheme != null
              ? translationProvider.tr("theme_editor_screen.title.editor")
              : translationProvider.tr("theme_editor_screen.title.create"),
          style: StylesApp(context).textStyleBody18.copyWith(
              color: currentTheme.textColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (widget.existingTheme != null)
            IconButton(
              icon: Icon(Icons.delete_outline, size: 28),
              color: Colors.red,
              onPressed: () => _deleteTheme(context),
              // tooltip: 'Eliminar tema',
            ),
          SizedBox(width: 16),
        ],
      ),
      backgroundColor: currentTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // COLUMNA IZQUIERDA: Configuración de colores
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del tema
                    _buildTabletSectionTitle(translationProvider
                        .tr("theme_editor_screen.fields.theme_name")),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: currentTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: currentTheme.textColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _nameController,
                        style: StylesApp(context)
                            .textStyleBody16
                            .copyWith(color: currentTheme.textColor),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: translationProvider
                              .tr("theme_editor_screen.fields.theme_name_hint"),
                          hintStyle: StylesApp(context)
                              .textStyleBody14
                              .copyWith(
                                  color: currentTheme.textColor
                                      .withValues(alpha: 0.5)),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),

                    // Selectores de color en grid para tablet
                    _buildTabletSectionTitle(translationProvider
                        .tr("theme_editor_screen.sections.colors")),
                    SizedBox(height: 20),

                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 3.5,
                      children: [
                        _buildTabletColorPickerItem(
                          translationProvider
                              .tr("theme_editor_screen.preview.appbar"),
                          _appBarColor,
                          (color) => setState(() => _appBarColor = color),
                        ),
                        _buildTabletColorPickerItem(
                          translationProvider
                              .tr("theme_editor_screen.preview.background"),
                          _backgroundColor,
                          (color) => setState(() => _backgroundColor = color),
                        ),
                        _buildTabletColorPickerItem(
                          translationProvider
                              .tr("theme_editor_screen.preview.text"),
                          _textColor,
                          (color) => setState(() => _textColor = color),
                        ),
                        _buildTabletColorPickerItem(
                          translationProvider
                              .tr("theme_editor_screen.preview.buttons"),
                          _buttonColor,
                          (color) => setState(() => _buttonColor = color),
                        ),
                        _buildTabletColorPickerItem(
                          translationProvider
                              .tr("theme_editor_screen.preview.button_text"),
                          _buttonTextColor,
                          (color) => setState(() => _buttonTextColor = color),
                        ),
                        _buildTabletColorPickerItem(
                          translationProvider
                              .tr("theme_editor_screen.preview.highlight"),
                          _verseHighlightColor,
                          (color) =>
                              setState(() => _verseHighlightColor = color),
                        ),
                      ],
                    ),

                    SizedBox(height: 40),

                    // Botón de guardar
                    Center(
                      child: SizedBox(
                        width: 300,
                        child: ButtonThemeWidget(
                          text: widget.existingTheme != null
                              ? translationProvider
                                  .tr("theme_editor_screen.buttons.update")
                              : translationProvider
                                  .tr("theme_editor_screen.buttons.create"),
                          buttonStyle:
                              StylesApp(context).btnWidgetSmall.copyWith(
                                    backgroundColor: WidgetStatePropertyAll(
                                        currentTheme.buttonColor),
                                    foregroundColor: WidgetStatePropertyAll(
                                        currentTheme.buttonTextColor),
                                  ),
                          onPressed: () => _saveTheme(context),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            SizedBox(width: 40),

            // COLUMNA DERECHA: Vista previa
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildTabletSectionTitle(translationProvider
                      .tr("theme_editor_screen.sections.preview")),
                  SizedBox(height: 20),
                  Expanded(
                    child: _buildTabletPreview(),
                  ),
                  SizedBox(height: 30),

                  // Información adicional para tablet
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: currentTheme.appBarColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: currentTheme.appBarColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: currentTheme.textColor
                                    .withValues(alpha: 0.7),
                                size: 20),
                            SizedBox(width: 10),
                            Text(
                              translationProvider
                                  .tr("theme_editor_screen.sections.tip"),
                              style:
                                  StylesApp(context).textStyleBody14.copyWith(
                                        color: currentTheme.textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          translationProvider
                              .tr("theme_editor_screen.messages.tip_message"),
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: currentTheme.textColor
                                    .withValues(alpha: 0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para título de sección en tablet
  Widget _buildTabletSectionTitle(String title) {
    return Text(
      title,
      style: StylesApp(context).textStyleBody16.copyWith(
            color: currentTheme.textColor,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  // Selector de color optimizado para tablet
  Widget _buildTabletColorPickerItem(
      String label, Color currentColor, ValueChanged<Color> onChanged) {
    return InkWell(
      onTap: () => _showTabletColorPicker(label, currentColor, onChanged),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: currentTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: currentTheme.textColor.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: currentColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: currentTheme.textColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: StylesApp(context).textStyleBody14.copyWith(
                      color: currentTheme.textColor,
                    ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: currentTheme.textColor.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Diálogo de selección de color optimizado para tablet
  Future<void> _showTabletColorPicker(
      String label, Color currentColor, ValueChanged<Color> onChanged) async {
    Color tempColor = currentColor;

    await showDialog<Color>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: currentTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600,
            maxHeight: 700,
          ),
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      translationProvider.trParams(
                          "theme_editor_screen.color_picker.title",
                          {"label": label}),
                      style: StylesApp(context).textStyleBody16.copyWith(
                            color: currentTheme.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: currentTheme.textColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: currentColor,
                    onColorChanged: (color) {
                      tempColor = color;
                    },
                    labelTypes: const [],
                    pickerAreaHeightPercent: 0.8,
                    enableAlpha: true,
                    displayThumbColor: true,
                    portraitOnly: true,
                    hexInputBar: true,
                    pickerAreaBorderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      translationProvider.tr("theme_editor_screen.color_picker.cancel"),
                      style: StylesApp(context).textStyleBody14.copyWith(
                            color:
                                currentTheme.textColor.withValues(alpha: 0.7),
                          ),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentTheme.buttonColor,
                      foregroundColor: currentTheme.buttonTextColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      onChanged(tempColor);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      translationProvider.tr("theme_editor_screen.color_picker.apply"),
                      style: StylesApp(context).textStyleBody14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Vista previa optimizada para tablet
  Widget _buildTabletPreview() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: currentTheme.textColor.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // AppBar simulada
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: _appBarColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                translationProvider.tr("theme_editor_screen.preview.appbar"),
                style: TextStyle(
                  color: _buttonTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: 24),

          // Contenido de ejemplo
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    translationProvider.tr("theme_editor_screen.preview.sample_text"),
                    style: StylesApp(context).textStyleBody18.copyWith(
                          color: _textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    translationProvider.tr("theme_editor_screen.preview.sample_description"),
                    style: StylesApp(context).textStyleBody14.copyWith(
                          color: _textColor.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _verseHighlightColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      translationProvider.tr("theme_editor_screen.preview.highlighted_verse"),
                      style: StylesApp(context).textStyleBody14.copyWith(
                            color: _textColor,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),

          // Botones de ejemplo
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: _buttonColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      translationProvider.tr("theme_editor_screen.preview.primary_button"),
                      style: StylesApp(context).textStyleBody18.copyWith(
                            color: _buttonTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: _buttonColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.favorite,
                  color: _buttonTextColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Nombre del tema
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: currentTheme.backgroundColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _nameController.text.isNotEmpty
                    ? _nameController.text
                    : translationProvider.tr("theme_editor_screen.fields.theme_name"),
                style: StylesApp(context).textStyleBody14.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _textColor.withValues(alpha: 0.9),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mantener los métodos originales sin cambios
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
                    translationProvider.tr(
                        "theme_editor_screen.color_picker.title_color"),
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
                      labelTypes: const [],
                      pickerAreaHeightPercent: 0.7,
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        translationProvider.tr("theme_editor_screen.color_picker.cancel"),
                        style: StylesApp(context)
                            .textStyleBody10
                            .copyWith(color: currentTheme.textColor),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text(
                        translationProvider.tr("theme_editor_screen.color_picker.select"),
                        style: StylesApp(context)
                            .textStyleBody10
                            .copyWith(color: currentTheme.textColor),
                      ),
                      onPressed: () => Navigator.of(context).pop(currentColor),
                    ),
                  ],
                ),
              );
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: _appBarColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
            ),
          ),
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
            text: translationProvider.tr("theme_editor_screen.preview.buttons"),
          ),
          SizedBox(height: 16),
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
      showSnackBar(translationProvider.tr("theme_editor_screen.messages.name_required"),
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
        title: Text(translationProvider.tr("theme_editor_screen.delete_dialog.title")),
        content: Text(translationProvider.tr("theme_editor_screen.delete_dialog.message")),
        actions: [
          TextButton(
            child: Text(translationProvider.tr("theme_editor_screen.delete_dialog.cancel")),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text(translationProvider.tr("theme_editor_screen.delete_dialog.delete")),
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
