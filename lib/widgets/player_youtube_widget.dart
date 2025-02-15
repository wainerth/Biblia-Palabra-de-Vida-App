import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerYoutubeWidget extends StatefulWidget {
  final String videoUrl;
  const PlayerYoutubeWidget({
    super.key,
    required this.videoUrl,
  });


  @override
  State<PlayerYoutubeWidget> createState() => _PlayerYoutubeWidgetState();
}

class _PlayerYoutubeWidgetState extends State<PlayerYoutubeWidget> {
  late final YoutubePlayerController controllerPlayer;
   @override
  void initState() {
    super.initState();
    String? videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId != null) {
      controllerPlayer = YoutubePlayerController(
        initialVideoId: videoId, // Reemplaza con el ID de tu video
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          controlsVisibleAtStart: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: controllerPlayer,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.orange,
      onReady: () {
        // _controller.addListener(() {
        // if (_controller.value.isReady && !_controller.value.isPlaying) {
        //   _controller.play();
        // }
        // });
      },
      );
  }
}
