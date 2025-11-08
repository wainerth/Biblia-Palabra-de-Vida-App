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
  // controlador para manejar el estado del reproductor
  final GlobalKey _playerKey = GlobalKey();

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

  Container _buildModalDetails(BuildContext context, ReferenceModel data) {
    return Container(
      padding: const EdgeInsets.all(4.0),
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
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/layoutPage", arguments: {
                          'selectedIndex': 1,
                          'bibleId': data.book!.bibleId.toString(),
                          'bookId': data.book!.id,
                          'chapterId': data.chapter!.id!,
                          'verseId': data.verse!.id!,
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
