import 'dart:convert';
import 'dart:math';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/class/bible_version_selector.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class BibleScreen extends StatefulWidget {
  const BibleScreen({super.key});

  @override
  State<BibleScreen> createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen> {
  late final userProvider;
  LoginUser? userData;
  final ScrollController scrollController = ScrollController();
  SharedPreferences? prefs;
  String? errorMessage;
  bool isLoading = true;
  VersionModel? currentVersion;
  BookModel? currentBook;
  ChapterModel? currentChapter;
  List<VerseModel> verses = [];
  String? lastVersionsSelected;
  bool versionConSaltos = true;
  Color? selectedColor;
  String preferenceKey = 'selectedBibleVersion';
  double fontSizeNumber = 16.sp;
  double fontSizeVerse = 14.sp;
  ModelData fontFamilySet = ModelData(label: "Aclonica", value: "1");
  //  Variable para controlar el overlay
  List<String> _favoriteVerses = [];
  List<HighlightRangeModel> _highlights = [];
  final GlobalKey _selectableTextKey = GlobalKey();
  late BibleTheme currentTheme;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userData = userProvider.currentUser;
      // Cargar el tema guardado primero
      await Provider.of<BibleThemeProvider>(context, listen: false)
          .loadSavedTheme();
      await _loadPersistedData();
      await _initDataLoad();
      _loadHighlights();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<BibleThemeProvider>(context);
    currentTheme = themeProvider.themeData;

    return Consumer<BibleThemeProvider>(
        builder: (context, themeProvider, child) {
      final currentTheme = themeProvider.themeData;
      return Scaffold(
        backgroundColor: currentTheme.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              if (isLoading) ...{
                Container()
              } else ...{
                if (errorMessage != null) ...{
                  BuildErrorWidget(
                    errorMessage: errorMessage!,
                    onRetry: () async => _loadChapterByBook(
                        currentVersion, currentBook, currentChapter, context),
                    onBack: () => Navigator.pop(context),
                  )
                } else ...{
                  // cabecera
                  BibleHeaderWidget(
                    versionName:
                        currentVersion != null ? currentVersion!.version : '',
                    title: currentBook != null ? currentBook!.modernName : '',
                    chapter: currentChapter != null
                        ? '${currentChapter!.chapter}'
                        : '',
                    onAudioTap: () {},
                    onBack: () {
                      Navigator.pushNamed(
                        context,
                        '/layoutPage',
                        arguments: {'selectedIndex': 0},
                      );
                    },
                    onVersionTap: () async {
                      final bibleVersions = Provider.of<CatalogueProvider>(
                              context,
                              listen: false)
                          .allBibleVersion
                          .map((v) => ModelData(value: v.id, label: v.version))
                          .toList();

                      final selectedVersion = await BibleVersionSelector.show(
                          context: context,
                          versions: bibleVersions,
                          preferenceKey: preferenceKey,
                          savedId: lastVersionsSelected);

                      if (selectedVersion != null) {
                        // Aquí manejas la versión seleccionada
                        if (kDebugMode) {
                          print(
                              'Versión seleccionada: ${selectedVersion.label}');
                        }
                        setState(() {
                          lastVersionsSelected = selectedVersion
                              .value; // actualizo la version de la biblia

                          // removemos los datos de la cache para iniciar de nuevo
                          prefs!.remove('bookSelected');
                          prefs!.remove('chapterSelected');
                        });
                        prefs!.setString(preferenceKey, lastVersionsSelected!);
                        _initDataLoad();
                      }
                    },
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          // body
                          Scrollbar(
                            controller: scrollController,
                            thumbVisibility: true,
                            thickness: 6.0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (versionConSaltos) ...{
                                      Expanded(
                                        child: ListView(
                                          controller: scrollController,
                                          children: [
                                            // Otros widgets de la lista...
                                            const SizedBox(height: 40),
                                            _buildContinuousText(), // Tu texto formateado como un widget
                                            const SizedBox(height: 16),
                                            // Más widgets...
                                          ],
                                        ),
                                      ),
                                    }
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // opciones de copiado, compartir y configuración
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: currentTheme.backgroundColor),
                              // width: MediaQuery.sizeOf(context).width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 25.0,
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return modalTextFormatSizeWidget(
                                                fontSize: fontSizeVerse,
                                                selectedItem: fontFamilySet,
                                                onChangedFontSize: (fontSize) {
                                                  if (kDebugMode) {
                                                    print(
                                                        'el nuevo tamaño de fuente $fontSize');
                                                  }
                                                  setState(() {
                                                    fontSizeNumber =
                                                        fontSize! + 2;
                                                    fontSizeVerse = fontSize;
                                                  });
                                                },
                                                onChangedFont: (newFont) {
                                                  if (kDebugMode) {
                                                    print(
                                                        'la nueva fuente ${newFont!.label}');
                                                  }
                                                  setState(() {
                                                    fontFamilySet = newFont!;
                                                  });
                                                },
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        CupertinoIcons.textformat_size,
                                        color: currentTheme.buttonColor,
                                      )),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 25.0,
                                    onPressed: () async {
                                      Clipboard.setData(ClipboardData(
                                          text: await copyChapter(
                                              currentChapter)));
                                      await showCustomDialog(
                                        context,
                                        message:
                                            "El capitulo ${currentChapter!.chapter} del libro ${currentBook!.modernName}  \n se ha copiado con éxito al\n portapapeles",
                                        dialogType: DialogType.info,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.file_copy_rounded,
                                      color: currentTheme.buttonColor,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 25.0,
                                    onPressed: () async {
                                      await Share.share(
                                        await copyChapter(currentChapter),
                                        subject:
                                            "Palabra de Vida - ${currentChapter!.chapter} ${currentBook!.modernName}",
                                      );
                                    },
                                    icon: Icon(
                                      Icons.share_rounded,
                                      color: StyleColor.turquoise,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 25.0,
                                    onPressed: () {
                                      showGeneralDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        transitionDuration:
                                            Duration(milliseconds: 500),
                                        pageBuilder: (_, __, ___) {
                                          return Dialog(
                                            insetPadding: EdgeInsets.zero,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              child: SearchBibleWidget(),
                                            ),
                                          );
                                        },
                                        transitionBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return ScaleTransition(
                                            scale: animation.drive(CurveTween(
                                                curve: Curves
                                                    .fastOutSlowIn)), // ← Solución segura
                                            child: child,
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.search_rounded,
                                      color: currentTheme.buttonColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 7.0),
                              width: MediaQuery.sizeOf(context).width,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: currentTheme.buttonColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                      child: IconButton(
                                        padding: EdgeInsets.all(0),
                                        alignment: Alignment.center,
                                        iconSize: 35,
                                        //  color: currentTheme.buttonColor,
                                        onPressed: currentBook != null &&
                                                currentBook!.numberBook == 1 &&
                                                (currentChapter != null &&
                                                    currentChapter!.chapter ==
                                                        1)
                                            ? null
                                            : () {
                                                // Lógica para ir al capítulo anterior
                                                _goToPreviousChapter();
                                              },
                                        icon: Icon(
                                          Icons.keyboard_arrow_left_rounded,
                                          size: 35,
                                          color: currentTheme.buttonTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: currentTheme.buttonColor,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                      child: IconButton(
                                        padding: EdgeInsets.all(0),
                                        alignment: Alignment.center,
                                        iconSize: 35,
                                        onPressed: currentBook != null &&
                                                currentBook!.numberBook ==
                                                    currentBook!.chapters &&
                                                currentChapter!.chapter ==
                                                    currentBook!.chapters
                                            ? null
                                            : () {
                                                // Lógica para ir al siguiente capítulo
                                                _goToNextChapter();
                                              },
                                        icon: Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                          size: 35,
                                          color: currentTheme.buttonTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                }
              }
            ],
          ),
        ),
      );
    });
  }

  /// Widget realiza la construcción de los textSpan para selección
  /// continua
  Widget _buildContinuousText() {
    final fullText = verses.map((v) => "${v.verse} ${v.text}").join(' ');

    return SelectableText.rich(
      key: _selectableTextKey,
      TextSpan(
        children: verses
            .expand((verse) => [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Stack(
                      alignment:
                          Alignment.center, // Centra los hijos en el Stack
                      children: [
                        // Estrella de favorito (superpuesta y centrada)
                        if (_isFavorite(verse))
                          Positioned(
                            top: -1, // Ajusta esta posición según necesites
                            left: 3, // Ajusta esta posición según necesites
                            child: Icon(
                              Icons.star,
                              size: 20, // Tamaño un poco más pequeño
                              color: StyleColor.yellowLight,
                            ),
                          ),
                        // Número del versículo (no seleccionable)
                        SelectionContainer.disabled(
                          child: GestureDetector(
                            onTap: () {
                              print("favoritos");
                              _showVersePopupMenu(context, verse);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: verse.verse == 1 ? 4.0 : 4.0,
                                right: 4.0,
                              ),
                              child: Text(
                                "${verse.verse}",
                                style:
                                    StylesApp(context).textStyleBody16.copyWith(
                                          fontFamily: fontFamilySet.label,
                                          fontSize: fontSizeNumber,
                                          fontWeight: FontWeight.bold,
                                          color: currentTheme.textColor,
                                        ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ..._buildHighlightedTextSpans(verse),
                ])
            .toList(),
      ),
      contextMenuBuilder: (context, selectableRegionState) {
        final selection = selectableRegionState.textEditingValue.selection;
        final selectedText = selection.textInside(fullText);
        final selectedVerses = _getVersesInSelection(selection, fullText);
        final overlapsHighlights =
            _selectionOverlapsHighlights(selection, fullText);

        return CustomContextMenu(
          anchors: selectableRegionState.contextMenuAnchors,
          children: [
            CustomContextMenuItem(
              icon: Icons.content_copy,
              label: 'Copiar versículo',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: selectedText));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Versículo copiado')),
                );
              },
            ),
            CustomContextMenuItem(
              icon: Icons.share,
              label: 'Compartir versículo',
              onPressed: () {
                Share.share(
                  selectedText,
                  subject: 'Versículo de ${currentBook?.modernName}',
                );
              },
            ),
            if (!overlapsHighlights)
              CustomContextMenuItem(
                icon: selectedVerses.length > 1
                    ? Icons.format_paint
                    : Icons.highlight,
                label: selectedVerses.length > 1
                    ? 'Resaltar ${selectedVerses.length} versículos'
                    : 'Resaltar versículo',
                onPressed: () {
                  _showColorPickerForSelection(
                    context,
                    selectedVerses,
                    selection.start,
                    selection.end,
                    selectedVerses.length > 1,
                  );
                },
              ),
          ],
        );
      },
      onSelectionChanged: (selection, cause) {
        if (selection.isValid && !selection.isCollapsed) {
          final overlaps = _selectionOverlapsHighlights(selection, fullText);
          if (overlaps) {
            // Usar un Future para esperar al siguiente frame y luego limpiar la selección
            Future.delayed(Duration.zero, () {
              final renderObject =
                  _selectableTextKey.currentContext?.findRenderObject();
              if (renderObject is RenderEditable) {
                renderObject.selection =
                    TextSelection.collapsed(offset: selection.baseOffset);
              }
            });
          }
        }
      },
    );
  }

  bool _isFavorite(VerseModel verse) {
    final verseId = '${verse.id}';
    return _favoriteVerses.contains(verseId);
  }

  void _showVersePopupMenu(BuildContext context, VerseModel verse) {
    final verseId = '${verse.id}';
    final isFavorite = _isFavorite(verse);

    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(isFavorite ? Icons.star_outline : Icons.star),
            title: Text(
                isFavorite ? 'Remover de favoritos' : 'Agregar a favoritos'),
            onTap: () {
              _toggleFavorite(verse);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(isFavorite ? Icons.star_outline : Icons.star),
            title: Text('Ver Versículo favorito'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final favoriteVerse = verses.firstWhere(
                        (verse) => verse.id == _favoriteVerses.first);
                    return Column(
                      mainAxisAlignment : MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          constraints: BoxConstraints(
                            minHeight: 60
                          ),
                            decoration: BoxDecoration(
                            color: currentTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                              BoxShadow(
                                  color: StyleColor.black.withValues(alpha: .25),
                                  spreadRadius: 4.0,
                                  offset: Offset(0, 4.0))
                            ]),
                            child: Column(
                              children: [
                                Text("Versículo Favorito", style: StylesApp(context).textStyleBody18.copyWith(
                                  color: StyleColor.orange
                                )),
                                // ${favoriteVerse.chapterId} :
                                Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        textAlign:TextAlign.center,
                                          "${favoriteVerse.verse}  \n${favoriteVerse.text}", style: StylesApp(context).textStyleBody12.copyWith(
                                            color: currentTheme.textColor
                                          ),),
                                    )),
                              ],
                            )),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
    );
  }

  /// Método para la creación de los resaltados
  List<TextSpan> _buildHighlightedTextSpans(VerseModel verse) {
    final text = verse.text;
    final spans = <TextSpan>[];
    int currentPos = 0;

    // Ordenar resaltados por posición de inicio (opcional, pero recomendado)
    verse.highlights.sort((a, b) => a!.startIndex.compareTo(b!.startIndex));

    for (final highlight in verse.highlights) {
      // 1. Texto antes del resaltado (si hay espacio no cubierto)
      if (currentPos < highlight!.startIndex) {
        spans.add(TextSpan(
          text: text.substring(
              currentPos,
              (highlight.startIndex > 0
                  ? highlight.startIndex - 1
                  : highlight.startIndex)),
          style: StylesApp(context).textStyleBody14.copyWith(
                fontFamily: fontFamilySet.label,
                fontSize: fontSizeVerse,
                color: currentTheme.textColor,
                fontWeight: FontWeight.w400,
              ),
        ));
      }

      // 2. Aplicar el resaltado
      spans.add(TextSpan(
        recognizer: LongPressGestureRecognizer()
          ..onLongPress = () {
            if (kDebugMode) {
              print('Long press en versículo ${verse.verse}');
            }
            _showHighlightOptions(context, highlight);
          },
        text: text.substring(
            (highlight.startIndex > 0
                ? highlight.startIndex - 1
                : highlight.startIndex),
            highlight.endIndex - 1),
        style: StylesApp(context).textStyleBody14.copyWith(
              fontFamily: fontFamilySet.label,
              fontSize: fontSizeVerse,
              backgroundColor:
                  Color(int.parse('0XFF${highlight.color}')).withOpacity(0.3),
              color: currentTheme.textColor,
              fontWeight: FontWeight.w400,
            ),
      ));

      // Actualizar posición actual al final del resaltado actual
      currentPos = highlight.endIndex - 1;
    }

    // 3. Texto restante después del último resaltado
    if (currentPos < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentPos),
        style: StylesApp(context).textStyleBody14.copyWith(
              fontFamily: fontFamilySet.label,
              fontSize: fontSizeVerse,
              color: currentTheme.textColor,
              fontWeight: FontWeight.w400,
            ),
      ));
    }

    return spans;
  }

  /// Método que me muestra la modal bottom Sheet pata la elección del color de resaltado
  ///
  void _showColorPickerForSelection(BuildContext context,
      List<VerseModel> verses, int start, int end, bool isContinue) {
    final colors = [
      const Color(0xFFEE5A24),
      const Color(0xFFF79F1F),
      const Color(0xFFFFC312),
      const Color(0xFFFFD55F),
      const Color(0xFFC4E538),
      const Color(0xFFA3CB38),
      const Color(0xFF009432),
      const Color(0xFF006266),
      const Color(0xFF12CBC4),
      const Color(0xFF1289A7),
      const Color(0xFF0652DD),
      const Color(0xFF1B1464),
      const Color(0xFF5758BB),
      const Color(0xFF9980FA),
      const Color(0xFFD980FA),
      const Color(0xFFFDA7DF),
      const Color(0xFF833471),
      const Color(0xFFB53471),
      const Color(0xFF6F1E51),
      const Color(0xFFED4C67),
      const Color(0xFFEA2027),
    ];

    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Resaltar selección',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Divider(),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    final hexColor =
                        '${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
                    final List<VerseModel> newVerses = [];

                    for (final verse in verses) {
                      // Calcular los índices correctos para cada versículo
                      final verseText = "${verse.verse} ${verse.text}";
                      final start = max(0, verse.posIni!);
                      final end = min(verse.posFin!, verseText.length);
                      if (kDebugMode) {
                        print('Color seleccionado: $hexColor');
                      }
                      if (start < end) {
                        newVerses.add(verse);
                      }
                    }
                    _addHighlight(newVerses, hexColor);

                    Navigator.pop(ctx);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(color.value),
                      shape: BoxShape.circle,
                      border: Border.all(width: 2),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          ListTile(
            leading: Icon(Icons.cancel),
            title: Text('Cancelar'),
            onTap: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  /// Método que agrega el resaltado
  void _addHighlight(List<VerseModel> listVerses, String color) async {
    // Verificar si ya existe un resaltado en esta posición
    final List<HighlightRangeModel> inputHighlight = [];
    for (final verse in listVerses) {
      final newHighlight = HighlightRangeModel(
        id: verse.id,
        verse: verse.verse,
        startIndex: verse.posIni!,
        endIndex: verse.posFin!,
        color: color,
      );
      inputHighlight.add(newHighlight); // actualizo temporal
    }
    LoadingService().showLoading(context);
    final responseCreate = await crateHighLighters(inputHighlight,
        userData!.userId, int.parse(currentVersion!.id), currentChapter!.id);
    if (responseCreate.error != null) {
      LoadingService().hideLoading();
      // ignore: use_build_context_synchronously
      await showCustomDialog(context,
          message: responseCreate.error!, dialogType: DialogType.error);
      return;
    }
    LoadingService().hideLoading();
    for (final lighter in inputHighlight) {
      _highlights.add(lighter); // actualizo local
      final encontrado = verses.indexWhere((verse) => verse.id == lighter.id);
      if (encontrado != -1) {
        verses[encontrado].highlights.add(lighter); // actualizo verses
      }
    }

    setState(() {});
  }

  /// Método que verifica si ya esta resaltado la elección
  bool _selectionOverlapsHighlights(TextSelection selection, String fullText) {
    for (final verse in verses) {
      for (final highlight in verse.highlights) {
        // Calcular las posiciones globales del resaltado en el texto completo
        final verseStart = _getVerseGlobalStart(verse, fullText);
        final highlightStart = verseStart + highlight!.startIndex;
        final highlightEnd = verseStart + highlight.endIndex;

        // Verificar si la selección se superpone con este resaltado
        if (selection.start < highlightEnd && selection.end > highlightStart) {
          return true;
        }
      }
    }
    return false;
  }

  /// Método que se encarga de mostrar dialogo para eliminar el resaltado
  void _showHighlightOptions(
      BuildContext context, HighlightRangeModel highlight) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Resaltado"),
        content: Text("¿Qué deseas hacer con este resaltado?"),
        actions: [
          TextButton(
            child: Text("Eliminar"),
            onPressed: () {
              _removeHighlight(highlight);
              Navigator.pop(ctx);
            },
          ),
          TextButton(
            child: Text("Cancelar"),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  /// Función auxiliar para obtener la posición inicial global de un versículo
  int _getVerseGlobalStart(VerseModel verse, String fullText) {
    int position = 0;
    for (final v in verses) {
      if (v.id == verse.id) break;
      position += "${v.verse} ${v.text}".length + 1; // +1 por el espacio
    }
    return position;
  }

  /// Método para obtener versículo(s) seleccionado
  ///
  List<VerseModel> _getVersesInSelection(
      TextSelection selection, String fullText) {
    int currentPosition = 0;
    final selectedVerses = <VerseModel>[];

    // recorremos verses para asignar posición inicial y final
    for (VerseModel verse in verses) {
      final verseText = verse.text;
      final verseStart = currentPosition;
      final verseEnd = currentPosition + verseText.length;
      int initial = 0;
      int posFinal = 0;
      // Verificar si la selección se superpone con este versículo
      if (selection.start < verseEnd && selection.end > verseStart) {
        initial = ((selection.start - 8) > verseStart
                ? selection.start
                : verseStart) -
            verseStart;
        posFinal = selection.end > verseEnd
            ? verseEnd - verseStart
            : selection.end - verseStart;

        // Guarda la nueva instancia en la list/
        verse = verse.copyWith(
          // <- Asigna el resultado
          posIni: initial == 1 ? initial - 1 : initial,
          posFin: posFinal,
        );
        selectedVerses.add(verse);
      }

      currentPosition = verseEnd + 1; // +1 por el espacio entre versículos
    }

    return selectedVerses;
  }

  /// Método que se encarga de remover el resaltado
  void _removeHighlight(HighlightRangeModel highlight) async {
    // llamamos servicio de remover resaltado
    LoadingService().showLoading(context);
    final responseRemove = await removeHighLighters(highlight.id);
    if (responseRemove.error != null) {
      LoadingService().hideLoading();
      // ignore: use_build_context_synchronously
      await showCustomDialog(context,
          message: responseRemove.error!, dialogType: DialogType.error);
      return;
    }
    LoadingService().hideLoading();
    setState(() {
      _highlights.remove(highlight);
      for (final verse in verses) {
        verse.highlights.removeWhere((h) =>
            h!.id == highlight.id &&
            h.startIndex == highlight.startIndex &&
            h.endIndex == highlight.endIndex);
      }
    });
    // _saveHighlights();
  }

// Manejar favoritos
  void _toggleFavorite(VerseModel verse) async {
    LoadingService().showLoading(context);
    final responseFavorite =
        await updateFavoriteVerse(userData!.userId, verse.id);
    if (responseFavorite.error != null) {
      LoadingService().hideLoading();
      // ignore: use_build_context_synchronously
      await showCustomDialog(context,
          message: responseFavorite.error!, dialogType: DialogType.error);
      return;
    }
    LoadingService().hideLoading();
    setState(() {
      // if (_favoriteVerses.contains(verse.id)) {
      _favoriteVerses[0] = verse.id;
      // }
      //else {
      //   _favoriteVerses.add(verse.id);
      // }
    });
  }

  /// Método que se encarga de cargar los versículos resaltados
  Future<void> _loadHighlights() async {
    final responseHighLighter = await getAllHighLighters(
        userData!.userId, int.parse(currentVersion!.id), currentChapter!.id);
    if (responseHighLighter.error != null) {
      errorMessage = responseHighLighter.error;
      return;
    }

    if (responseHighLighter.data.length > 0) {
      setState(() {
        _highlights = responseHighLighter.data
            .map<HighlightRangeModel>((h) => HighlightRangeModel(
                id: h['verse']['id'],
                verse: h['verse']['verse'],
                startIndex: h['startIndex'],
                endIndex: h['endIndex'],
                color: h['color']))
            .toList();

        for (final verse in verses) {
          verse.highlights.clear();
          verse.highlights.addAll(_highlights.where((h) => h.id == verse.id));
        }
      });
    }
  }

  /// Método que se encarga de cargar la data persistente de lso resaltados
  Future<void> _loadPersistedData() async {
    // cargar los favoritos
    final responseFavorite = await getFavoriteVerseByUser(userData!.userId);
    if (responseFavorite.data != null && responseFavorite.data.length > 0) {
      _favoriteVerses.add(responseFavorite
          .data); // =responseFavorite.data.map((favorite) => favorite);
    }

    if (mounted) setState(() {});
  }

  /// Método de carga inicial de datos
  Future<void> _initDataLoad() async {
    prefs = await SharedPreferences.getInstance();
    lastVersionsSelected =
        prefs!.getString(preferenceKey); //  cargo la version almacena en cache
    final loadBook =
        prefs!.getString('bookSelected'); // cargo el libro almacenado en cache

    // si hay version en cache
    setState(() {
      if (lastVersionsSelected != null) {
        // busco esa version
        currentVersion = Provider.of<CatalogueProvider>(context, listen: false)
            .allBibleVersion
            .firstWhere((version) => version.id == lastVersionsSelected);

        if (loadBook != null) {
          currentBook =
              currentVersion!.books.firstWhere((book) => book.id == loadBook);
          // cargamos el capitulo correspondiente
        } else {
          currentBook = currentVersion!.books[0];
        }
      } else {
        currentVersion = Provider.of<CatalogueProvider>(context, listen: false)
            .allBibleVersion[0];
        currentBook = currentVersion!.books[0];
      }
      currentBook = currentBook!.copyWith(
        chapters: currentVersion!.books.length, // Usamos el mapa de capítulos
      );
    });

    await _loadChapterByBook(currentVersion, currentBook, null, context);
  }

  /// Método para cargar los capítulos de un libro
  Future<void> _loadChapterByBook(
      version, book, chapterId, BuildContext context) async {
    setState(() {
      errorMessage = null;
    });
    LoadingService().showLoading(context);
    try {
      if (chapterId == null) {
        // consultamos un capitulo si chapter es null
        final responseChapterByBook =
            await getChapterWithVerses(currentBook!.id);
        if (responseChapterByBook.error != null) {
          setState(() {
            errorMessage = responseChapterByBook.error;
          });
        }

        chapterId = responseChapterByBook.data[0]!['id'];
      }
      final responseChapter = await getOneChapterWithVerses(chapterId);
      if (responseChapter.error != null) {
        errorMessage = responseChapter.error;
      }
      setState(() {
        currentChapter = ChapterModel.fromJson(responseChapter.data);

        verses = currentChapter!.verses
            .map<VerseModel>((verse) => VerseModel.fromJson(verse.toJson()))
            .toList();
      });

      // actualizamos la cache
      prefs!.setString(preferenceKey, version.id);
      prefs!.setString('bookSelected', book!.id);
      prefs!.setString('chapterSelected', chapterId);
    } catch (e) {
      errorMessage = 'Error cargar un capitulo $e';
      setState(() {
        isLoading = false;
      });
    } finally {
      LoadingService().hideLoading();
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Método para ir al siguiente capítulo
  Future<void> _goToPreviousChapter() async {
    if (currentChapter!.chapter > 1) {
      await _loadChapterByBook(currentVersion, currentBook,
          '${currentBook!.id}_${currentChapter!.chapter - 1}', context);
    } else if (currentBook!.numberBook > 1) {
      // Ir al último capítulo del libro anterior
      final prevBook = currentVersion!.books
          .firstWhere((b) => b.numberBook == currentBook!.numberBook - 1);
      await _loadChapterByBook(currentVersion, prevBook,
          '${prevBook.id}_${prevBook.chapters}', context);
    }
  }

  /// Método para regresar al capítulo anterior
  Future<void> _goToNextChapter() async {
    if (currentChapter!.chapter < currentBook!.chapters) {
      await _loadChapterByBook(currentVersion, currentBook,
          '${currentBook!.id}_${currentChapter!.chapter + 1}', context);
    } else if (currentBook!.numberBook < currentVersion!.books.length) {
      // Ir al primer capítulo del siguiente libro
      final nextBook = currentVersion!.books
          .firstWhere((b) => b.numberBook == currentBook!.numberBook + 1);
      await _loadChapterByBook(
          currentVersion, nextBook, '${nextBook.id}_1', context);
    }
  }
}
