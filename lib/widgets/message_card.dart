import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/screens/features/preach/video_player_screen.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:transparent_image/transparent_image.dart';

class MessageCard extends StatefulWidget {
  final String id;
  final String imageUrl;
  final String urlVideo;
  final String title;
  final String author;
  final String date;
  final List<ReferenceModel>? references;
  final Icon iconFavorite;
  final void Function()? onPressed;

  const MessageCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.date,
    this.references,
    required this.urlVideo,
    this.onPressed,
    required this.iconFavorite,
    required this.id,
  });

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    Preach valores = Preach(
      id: widget.id,
      title: widget.title,
      video: VideoPreach(img: null, url: widget.urlVideo),
      preachers: widget.author,
      references: widget.references,
      createdAt: widget.date,
    );
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(data: valores),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Imagen
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GestureDetector(
                    key: GlobalKey(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VideoPlayerScreen(data: valores),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 200,
                      height: 110,
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: widget.imageUrl,
                        width: 100,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
            ),
            const SizedBox(width: 16),
            // Contenido
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: StylesApp(context).textStyleBody14.copyWith(
                          color: StyleColor.turquoise,
                        ),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.author.replaceAll(". ", ".\n"),
                    style: StylesApp(context).textStyleBody14.copyWith(
                          color: StyleColor.orange,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.date,
                    style: StylesApp(context).textStyleBody14.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: widget.iconFavorite,
              onPressed: widget.onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
