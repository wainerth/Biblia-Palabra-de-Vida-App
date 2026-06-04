import 'package:biblia_palabra_de_vida_app/config/api_config.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class DialogInternalTeaching extends StatefulWidget {
  final void Function(InputDataSearchModel data)? onActionReferences;
  final TeachingModel data;
  final BibleTheme currentTheme;
  final bool isTablet;

  const DialogInternalTeaching({
    super.key,
    required this.data,
    required this.currentTheme,
    this.onActionReferences,
    this.isTablet = false,
  });

  @override
  State<DialogInternalTeaching> createState() => _DialogInternalTeachingState();
}

class _DialogInternalTeachingState extends State<DialogInternalTeaching> {
  final translationProvider = AppTranslationProvider();

  List<ReferenceBiblicalModel> references = [];
  bool loadingReferences = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadReferences());
  }

  Future<void> _loadReferences() async {
    setState(() => loadingReferences = true);

    final responseReferences = await getReferenceTeaching(widget.data.id);

    if (responseReferences.error != null && mounted) {
      await showCustomDialog(
        context,
        message: responseReferences.error!,
        dialogType: DialogType.error,
      );
    }

    if (mounted) {
      setState(() {
        references = responseReferences.error == null
            ? responseReferences.data
                .map<ReferenceBiblicalModel>(
                    (reference) => ReferenceBiblicalModel.fromJson(reference))
                .toList()
            : [];
        loadingReferences = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobile: _buildMobileDialog(), tablet: _buildTabletDialog());
  }

  // ============ DIALOG PARA TABLET ============
  Widget _buildTabletDialog() {
    return Dialog(
      backgroundColor: widget.currentTheme.backgroundColor,
      insetPadding: EdgeInsets.all(0),
      child: SizedBox(
        width: 700,
        height: 800,
        child: Column(
          children: [
            // ENCABEZADO
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: StyleColor.turquoise,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translationProvider
                              .tr("dialog_internal_teaching.title"),
                          style: StylesApp(context).textStyleBody18.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.data.title,
                          style: StylesApp(context).textStyleBody14.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 16,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // CONTENIDO CON SCROLL
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGEN PRINCIPAL
                    if (widget.data.img.urlImg.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 200,
                        margin: EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(
                                '${ApiConfig.baseUrl}${widget.data.img.urlImg}'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),

                    // TÍTULO DESTACADO
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: widget.currentTheme.buttonColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.currentTheme.buttonColor
                              .withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.library_books,
                            color: widget.currentTheme.buttonColor,
                            size: 36,
                          ),
                          SizedBox(height: 12),
                          Text(
                            widget.data.title,
                            style: StylesApp(context).textStyleBody18.copyWith(
                                  color: widget.currentTheme.textColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // DESCRIPCIÓN
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: widget.currentTheme.backgroundColor
                            .withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.currentTheme.buttonColor
                              .withValues(alpha: 0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.description,
                                color: widget.currentTheme.buttonColor,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Text(
                                translationProvider.tr(
                                    "dialog_internal_teaching.description_title"),
                                style:
                                    StylesApp(context).textStyleBody16.copyWith(
                                          color: widget.currentTheme.textColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            widget.data.description,
                            style: StylesApp(context).textStyleBody14.copyWith(
                                  color: widget.currentTheme.textColor
                                      .withValues(alpha: 0.9),
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),

                    // REFERENCIAS BÍBLICAS
                    SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: widget.currentTheme.backgroundColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.currentTheme.buttonColor
                              .withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.format_list_bulleted,
                                    color: widget.currentTheme.buttonColor,
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    translationProvider.tr(
                                        "dialog_internal_teaching.references_title"),
                                    style: StylesApp(context)
                                        .textStyleBody16
                                        .copyWith(
                                          color: widget.currentTheme.textColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: widget.currentTheme.buttonColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  translationProvider.trParams(
                                      "dialog_internal_teaching.references_count",
                                      {
                                        'count': references.length.toString(),
                                      }),
                                  style: TextStyle(
                                    color: widget.currentTheme.buttonColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          // LOADING O LISTA DE REFERENCIAS
                          if (loadingReferences)
                            Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                    color: widget.currentTheme.buttonColor,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    translationProvider.tr("dialog_internal_teaching.loading_references"),
                                    style: TextStyle(
                                      color: widget.currentTheme.textColor
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (references.isEmpty)
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: widget.currentTheme.backgroundColor
                                    .withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.book_outlined,
                                    size: 48,
                                    color: widget.currentTheme.textColor
                                        .withValues(alpha: 0.3),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    translationProvider.tr("dialog_internal_teaching.no_references"),
                                    style: TextStyle(
                                      color: widget.currentTheme.textColor
                                          .withValues(alpha: 0.6),
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          else
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.0,
                              ),
                              itemCount: references.length,
                              itemBuilder: (context, index) {
                                return _buildTabletReferenceCard(
                                    references[index]);
                              },
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ TARJETA DE REFERENCIA PARA TABLET ============
  Widget _buildTabletReferenceCard(ReferenceBiblicalModel reference) {
    final GlobalKey widgetKey = GlobalKey();

    return Card(
      color: widget.currentTheme.backgroundColor,
      key: widgetKey,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.currentTheme.buttonColor.withValues(alpha: 0.05),
              widget.currentTheme.buttonColor.withValues(alpha: 0.15),
            ],
          ),
          border: Border.all(
            color: widget.currentTheme.buttonColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // REFERENCIA BÍBLICA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.currentTheme.buttonColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${reference.book.modernName} ${reference.chapter.chapter}:${reference.verse.verse}${reference.numberEndVerse > 0 ? '-${reference.numberEndVerse}' : ''}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      size: 16,
                      color: widget.currentTheme.buttonColor,
                    ),
                    onPressed: () {
                      _showContextMenuForCard(widgetKey, reference);
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),

            // TEXTO DEL VERSÍCULO (ABREVIADO)
            Expanded(
              child: Text(
                reference.verse.text,
                style: StylesApp(context).textStyleBody12.copyWith(
                      color:
                          widget.currentTheme.textColor.withValues(alpha: 0.8),
                      fontSize: 13,
                      height: 1.4,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // BOTÓN VER
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.currentTheme.buttonColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color:
                        widget.currentTheme.buttonColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.onActionReferences != null) {
                          final referenceData = InputDataSearchModel(
                            versionId: reference.book.bibleId.toString(),
                            bookId: reference.book.id,
                            chapterId: reference.chapter.id!,
                            startVerseId: reference.verse.id!,
                            endVerseId: reference.numberEndVerse.toString(),
                          );
                          widget.onActionReferences!(referenceData);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        translationProvider.tr("dialog_internal_teaching.go_to_verse")  ,
                        style: TextStyle(
                          color: widget.currentTheme.buttonColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.open_in_new,
                      size: 12,
                      color: widget.currentTheme.buttonColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ DIALOG PARA MÓVIL (MANTENIDO) ============
  Widget _buildMobileDialog() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: widget.currentTheme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          AppBarHeaderWidget(
            backColor: StyleColor.turquoise,
            buttonColor: StyleColor.orange,
            textButtonColor: Colors.white,
            title: translationProvider.tr("dialog_internal_teaching.title_mobile"),
            styleText: StylesApp(context).textStyleBody7,
            onRoute: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 8),
          Container(
            constraints: BoxConstraints(maxWidth: 211.0),
            child: Column(
              children: [
                Center(
                  child: Image.network(
                      '${ApiConfig.baseUrl}${widget.data.img.urlImg}'),
                ),
                Text(
                  textAlign: TextAlign.center,
                  widget.data.title,
                  style: StylesApp(context)
                      .textStyleBody16
                      .copyWith(color: StyleColor.orange),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12.0),
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 6.0,
                radius: Radius.circular(10),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      textAlign: TextAlign.justify,
                      widget.data.description,
                      style: StylesApp(context)
                          .textStyleBody16
                          .copyWith(color: widget.currentTheme.textColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          SizedBox(
            width: isTablet(context) ? 300 : double.infinity,
            child: ButtonThemeWidget(
              text: translationProvider.tr("dialog_internal_teaching.button_references"),
              disabled: references.isEmpty,
              buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(),
              onPressed: references.isEmpty
                  ? null
                  : () {
                      _showDialogReferenceDetail();
                    },
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  void _showDialogReferenceDetail() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogReference(
            currentTheme: widget.currentTheme,
            title: widget.data.title,
            data: references,
            onActionReferences: (InputDataSearchModel data) {
              if (widget.onActionReferences != null) {
                widget.onActionReferences!(data);
              }
              Navigator.pop(context);
            },
          );
        });
  }

  void _showContextMenuForCard(
      GlobalKey widgetKey, ReferenceBiblicalModel reference) {
    // Encontrar el render box de esta tarjeta específica
    final RenderBox renderBox =
        widgetKey.currentContext?.findRenderObject() as RenderBox;

    if (renderBox == null) return;

    // Calcular la posición global de la tarjeta
    final offset = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx + renderBox.size.width - 40, // Ajuste para posición del icono
        offset.dy + 40, // Bajar un poco desde el borde superior
        offset.dx + renderBox.size.width,
        offset.dy + renderBox.size.height,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: widget.currentTheme.buttonColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      color: widget.currentTheme.backgroundColor,
      elevation: 4,
      items: [
        PopupMenuItem(
          value: 'copy',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.content_copy,
                size: 18,
                color: widget.currentTheme.buttonColor,
              ),
              SizedBox(width: 10),
              Text(
                translationProvider.tr("dialog_internal_teaching.copy_verse"),
                style: TextStyle(
                  color: widget.currentTheme.textColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'share',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.share,
                size: 18,
                color: widget.currentTheme.buttonColor,
              ),
              SizedBox(width: 10),
              Text(
                translationProvider.tr("dialog_internal_teaching.share"),
                style: TextStyle(
                  color: widget.currentTheme.textColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        _handleMenuSelection(value, reference);
      }
    });
  }

  void _handleMenuSelection(String value, ReferenceBiblicalModel reference) {
    switch (value) {
      case 'copy':
        copyToClipboard(context, reference);
        break;
      case 'share':
        shareVerse(context, reference);
        break;
    }
  }
}
