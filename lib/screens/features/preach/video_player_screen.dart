import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Preach data;
  const VideoPlayerScreen({super.key, required this.data});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  // late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // String? videoId = YoutubePlayer.convertUrlToId(widget.data.video!.url!);
    // if (videoId != null) {
    //   _controller = YoutubePlayerController(
    //     initialVideoId: videoId, // Reemplaza con el ID de tu video
    //     flags: const YoutubePlayerFlags(
    //       autoPlay: false,
    //       mute: false,
    //       controlsVisibleAtStart: true,
    //     ),
    //   );
    // }
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarHeaderWidget(
                title: "Predicas",
                styleText: StylesApp(context).textStyleBody7,
                backColor: StyleColor.turquoise,
                textButtonColor: Colors.white,
                buttonColor: StyleColor.orange,
                onRoute: () {
                  Navigator.pop(context);
                },
              ),
              // Reproductor de YouTube
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  constraints: BoxConstraints(minHeight: 213),
                  // height: 213,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: widget.data.video!.url!.contains('youtube.com') ||
                            widget.data.video!.url!.contains('youtu.be')
                        ? PlayerYoutubeWidget(videoUrl: widget.data.video!.url!)
                        : PlayerNoYoutube(url: widget.data.video!.url!),
                  ),
                ),
              ),
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
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.data.references!.map((ref) => 
ButtonThemeWidget(
                      text: "${ref.book?.modernName} ${ref.chapter?.chapter}:${ref.verse?.verse}",
                      buttonStyle: StylesApp(context).btnSecondary.copyWith(
                          maximumSize: WidgetStatePropertyAll(
                              Size(double.infinity, double.infinity)),
                          minimumSize: WidgetStatePropertyAll(
                              Size(double.infinity, double.infinity))),
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
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildModalDetails(BuildContext context, ReferenceModel data) {
    return  Container(
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
                           Navigator.pushNamed(context, "/layoutPage",
                                      arguments: {
                                        'selectedIndex': 1,
                                        'bibleId':data.book!.bibleId.toString(),
                                        'bookId': data.book!.id,
                                        'chapterId':data.chapter!.id!,
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
