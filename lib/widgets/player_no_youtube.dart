import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:video_player/video_player.dart';

class playerNoYoutube extends StatefulWidget {
  final String url;
  const playerNoYoutube({super.key, required this.url});

  @override
  playerNoYoutubeState createState() => playerNoYoutubeState();
}

class playerNoYoutubeState extends State<playerNoYoutube> {
  late VideoPlayerController _videoController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(
      widget.url,
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: true
      )
    )
      // _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {});
      });
    //  _initializeVideoPlayerFuture = _videoController.initialize();
    _videoController.addListener(() {
      setState(() {
        _isPlaying = _videoController.value.isPlaying;
      });
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _videoController.value.isInitialized
        ? Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 16 / 16,
                  child: VideoPlayer(_videoController),
                ),
              ),
              VideoProgressIndicator(_videoController, allowScrubbing: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: StyleColor.turquoise,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPlaying
                            ? _videoController.pause()
                            : _videoController.play();
                        _isPlaying = !_isPlaying;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.fast_rewind, color: StyleColor.turquoise,),
                    onPressed: () {
                      _videoController.seekTo(
                        _videoController.value.position - Duration(seconds: 10),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.fast_forward, color: StyleColor.turquoise,),
                    onPressed: () {
                      _videoController.seekTo(
                        _videoController.value.position + Duration(seconds: 10),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _videoController.value.volume == 0
                          ? Icons.volume_off
                          : Icons.volume_up,
                          color: StyleColor.turquoise,
                    ),
                    onPressed: () {
                      setState(() {
                        _videoController.setVolume(
                          _videoController.value.volume == 0 ? 1.0 : 0.0,
                        );
                      });
                    },
                  ),
                  Slider(
                    value: _videoController.value.volume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (value) {
                      setState(() {
                        _videoController.setVolume(value);
                      });
                    },
                  ),
                ],
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
