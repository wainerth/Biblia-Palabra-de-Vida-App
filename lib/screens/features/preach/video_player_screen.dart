import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Preach data;
  const VideoPlayerScreen({super.key, required this.data});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final GlobalKey _playerKey = GlobalKey();

  // Función para determinar si es tablet
  bool get isTablet {
    final width = MediaQuery.of(context).size.width;
    return width >= 600;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isTablet ? _buildTabletLayout() : _buildMobileLayout();
  }

  _buildMobileLayout() {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: AppBarHeaderWidget(
              title: "Predicas",
              styleText: StylesApp(context).textStyleBody7,
              backColor: StyleColor.turquoise,
              textButtonColor: Colors.white,
              buttonColor: StyleColor.orange,
              onRoute: () {
                Navigator.pop(context);
              },
            ),
          ),

          // Reproductor de YouTube
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: const BoxConstraints(minHeight: 213),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: widget.data.video!.url!.contains('youtube.com') ||
                          widget.data.video!.url!.contains('youtu.be')
                      ? PlayerYoutubeWidget(
                          key: _playerKey,
                          videoUrl: widget.data.video!.url!,
                        )
                      : PlayerNoYoutube(url: widget.data.video!.url!),
                ),
              ),
            ),
          ),
          // Resto del contenido
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10),

              // Detalles del predicador
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                widget.data.preachers!.replaceAll('.', '.\n'),
                                style: StylesApp(context)
                                    .textStyleBody14
                                    .copyWith(color: StyleColor.turquoise),
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  widget.data.createdAt!,
                                  style: StylesApp(context)
                                      .textStyleBody12
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.data.title!,
                          style: StylesApp(context)
                              .textStyleBody12
                              .copyWith(color: StyleColor.orange),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Referencias
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Referencias",
                  style: StylesApp(context)
                      .textStyleBody14
                      .copyWith(color: StyleColor.turquoise),
                ),
              ),

              const SizedBox(height: 10),

              // Botones de referencias
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: widget.data.references!
                      .map(
                        (ref) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ButtonThemeWidget(
                            text:
                                "${ref.book?.modernName} ${ref.chapter?.chapter}:${ref.verse?.verse}",
                            buttonStyle: StylesApp(context)
                                .btnSecondary
                                .copyWith(
                                    maximumSize: const WidgetStatePropertyAll(
                                        Size(double.infinity, double.infinity)),
                                    minimumSize: const WidgetStatePropertyAll(
                                        Size(
                                            double.infinity, double.infinity))),
                            width: MediaQuery.sizeOf(context).width,
                            height: StylesApp(context).btnSizeSmall.height,
                            onPressed: () {
                              showModalBottomSheet(
                                  useSafeArea: true,
                                  isScrollControlled: true, // Añade esto
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _buildModalDetails(context, ref);
                                  });
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: 20), // Espacio final
            ]),
          )
        ]),
      ),
    );
  }

  _buildTabletLayout() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBarHeaderWidget(
              title: "Reproductor de Predicación",
              styleText:
                  StylesApp(context).textStyleBody7.copyWith(fontSize: 24),
              backColor: StyleColor.turquoise,
              textButtonColor: Colors.white,
              buttonColor: StyleColor.orange,
              onRoute: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // COLUMNA IZQUIERDA: Reproductor de video
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.only(right: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Encabezado del reproductor
                            Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: StyleColor.turquoise,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.play_circle_filled,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Reproduciendo",
                                    style: StylesApp(context)
                                        .textStyleBody18
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),

                            // Reproductor de video
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: widget.data.video!.url!
                                              .contains('youtube.com') ||
                                          widget.data.video!.url!
                                              .contains('youtu.be')
                                      ? PlayerYoutubeWidget(
                                          key: _playerKey,
                                          videoUrl: widget.data.video!.url!,
                                        )
                                      : PlayerNoYoutube(
                                          url: widget.data.video!.url!),
                                ),
                              ),
                            ),

                            // Información básica debajo del reproductor
                            Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.data.title!,
                                    style: StylesApp(context)
                                        .textStyleBody16
                                        .copyWith(
                                          color: StyleColor.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 16,
                                        color: StyleColor.turquoise,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          widget.data.preachers!
                                              .replaceAll('.', '. '),
                                          style: StylesApp(context)
                                              .textStyleBody14
                                              .copyWith(
                                                color: StyleColor.turquoise,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        widget.data.createdAt!,
                                        style: StylesApp(context)
                                            .textStyleBody12
                                            .copyWith(
                                              color: Colors.grey[600],
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // COLUMNA DERECHA: Información y referencias
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .1),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Encabezado de referencias
                            Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: StyleColor.orange.withValues(alpha: .1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                                border: Border.all(
                                  color: StyleColor.orange,
                                  width: 2.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.menu_book,
                                    color: StyleColor.orange,
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Referencias Bíblicas",
                                    style: StylesApp(context)
                                        .textStyleBody14
                                        .copyWith(
                                          color: StyleColor.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: StyleColor.orange,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "${widget.data.references!.length}",
                                      style: StylesApp(context)
                                          .textStyleBody12
                                          .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Lista de referencias
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: ListView.separated(
                                  itemCount: widget.data.references!.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final ref = widget.data.references![index];
                                    return ReferenceCardTablet(
                                      reference: ref,
                                      onTap: () {
                                        _showReferenceDetailsTablet(ref);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),

                            // Información adicional
                            Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                ),
                                border: Border.all(
                                  color: Colors.grey[200]!,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Información de la Predicación",
                                    style: StylesApp(context)
                                        .textStyleBody14
                                        .copyWith(
                                          color: StyleColor.turquoise,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Título: ${widget.data.title!}",
                                    style: StylesApp(context)
                                        .textStyleBody12
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Predicador: ${widget.data.preachers!}",
                                    style: StylesApp(context)
                                        .textStyleBody12
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Fecha: ${widget.data.createdAt!}",
                                    style: StylesApp(context)
                                        .textStyleBody12
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
    );
  }

  // Método para mostrar detalles de referencia en tablet
  void _showReferenceDetailsTablet(ReferenceModel data) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Container(
          width: 600,
          constraints: BoxConstraints(
            maxHeight: 600,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Encabezado del diálogo
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: StyleColor.turquoise,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.book!.modernName,
                      style: StylesApp(context).textStyleBody20.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => copyToClipboard(context, data),
                          icon: Icon(
                            Icons.content_copy,
                            color: Colors.white,
                            size: 24,
                          ),
                          tooltip: "Copiar",
                        ),
                        IconButton(
                          onPressed: () => shareVerse(context, data),
                          icon: Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 24,
                          ),
                          tooltip: "Compartir",
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Contenido del versículo
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        data.book!.modernName,
                        style: StylesApp(context).textStyleBody18.copyWith(
                              color: StyleColor.black,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.only(bottom: 20.0),
                        decoration: BoxDecoration(
                          color: StyleColor.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: StyleColor.orange,
                            width: 2.0,
                          ),
                        ),
                        child: Text(
                          "${data.chapter!.chapter}:${data.verse!.verse}",
                          style: isTablet
                              ? StylesApp(context).textStyleBody20.copyWith(
                                    color: StyleColor.orange,
                                    fontWeight: FontWeight.bold,
                                  )
                              : StylesApp(context).textStyleBody24.copyWith(
                                    color: StyleColor.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          data.verse!.text,
                          style: isTablet
                              ? StylesApp(context).textStyleBody14.copyWith(
                                    color: Colors.black,
                                    height: 1.6,
                                  )
                              : StylesApp(context).textStyleBody18.copyWith(
                                    color: Colors.black,
                                    height: 1.6,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ButtonThemeWidget(
                            text: "Cerrar",
                            width: 150,
                            height: 45,
                            buttonStyle: StylesApp(context)
                                .btnWidgetSmall
                                .copyWith(
                                  backgroundColor:
                                      WidgetStatePropertyAll(StyleColor.orange),
                                ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          ButtonThemeWidget(
                            icon: Icons.menu_book,
                            colorIcon: StyleColor.white,
                            showIcon: true,
                            text: "Leer Más",
                            width: 180,
                            height: 45,
                            buttonStyle:
                                StylesApp(context).btnWidgetSmall.copyWith(
                                      backgroundColor: WidgetStatePropertyAll(
                                        StyleColor.turquoise,
                                      ),
                                    ),
                            onPressed: () {
                              Navigator.pop(context);
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                if (mounted) {
                                  Navigator.pushReplacementNamed(
                                      context, "/layoutPage",
                                      arguments: {
                                        'selectedIndex': 1,
                                        'bibleId':
                                            data.book!.bibleId.toString(),
                                        'bookId': data.book!.id,
                                        'chapterId': data.chapter!.id!,
                                        'verseId': data.verse!.id!,
                                      });
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mantener el método original para móvil
  Container _buildModalDetails(BuildContext context, ReferenceModel data) {
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.only(
        top: 4.0,
        left: 4.0,
        right: 4.0,
        bottom: safeAreaBottom + 4.0,
      ),
      decoration: BoxDecoration(
        color: StyleColor.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4.0),
            spreadRadius: 4.0,
            color: StyleColor.black.withValues(alpha: 0.25),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Botones de acción (copiar y compartir)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: StyleColor.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 25.0,
                    onPressed: () => copyToClipboard(context, data),
                    icon: Icon(
                      Icons.file_copy_rounded,
                      color: StyleColor.turquoise,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 25.0,
                    onPressed: () => shareVerse(context, data),
                    icon: Icon(
                      Icons.share_rounded,
                      color: StyleColor.turquoise,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Contenido principal del diálogo
          Padding(
            padding:
                const EdgeInsets.only(top: 40.0), // Espacio para los botones
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  data.book!.modernName,
                  style: StylesApp(context).textStyleBody18.copyWith(
                        color: StyleColor.black,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  "${data.chapter!.chapter}:${data.verse!.verse}",
                  style: StylesApp(context).textStyleBody16.copyWith(
                        color: StyleColor.black,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  data.verse!.text,
                  style: StylesApp(context).textStyleBody14.copyWith(
                        color: StyleColor.black,
                      ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ButtonThemeWidget(
                      width: 120,
                      icon: Icons.read_more_outlined,
                      showIcon: true,
                      text: "Leer Más",
                      buttonStyle: StylesApp(context).btnWidgetSmall,
                      onPressed: () {
                        // Cerrar el modal primero
                        Navigator.pop(context);

                        // Pequeño delay para asegurar que el modal se cierre
                        Future.delayed(const Duration(milliseconds: 100), () {
                          // Navegar reemplazando la pantalla actual en lugar de apilar
                          if (mounted) {
                            Navigator.pushReplacementNamed(
                                context, "/layoutPage",
                                arguments: {
                                  'selectedIndex': 1,
                                  'bibleId': data.book!.bibleId.toString(),
                                  'bookId': data.book!.id,
                                  'chapterId': data.chapter!.id!,
                                  'verseId': data.verse!.id!,
                                });
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Nuevo widget para tarjetas de referencia en tablet
class ReferenceCardTablet extends StatelessWidget {
  final ReferenceModel reference;
  final VoidCallback onTap;

  const ReferenceCardTablet({
    super.key,
    required this.reference,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icono de libro
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: StyleColor.turquoise.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: StyleColor.turquoise,
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.book,
                  color: StyleColor.turquoise,
                  size: 20,
                ),
              ),
            ),

            SizedBox(width: 16),

            // Información de la referencia
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reference.book!.modernName,
                    style: StylesApp(context).textStyleBody14.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Capítulo ${reference.chapter!.chapter}:${reference.verse!.verse}",
                    style: StylesApp(context).textStyleBody12.copyWith(
                          color: StyleColor.orange,
                        ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 12),

            // Botón para ver detalles
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: StyleColor.turquoise,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
