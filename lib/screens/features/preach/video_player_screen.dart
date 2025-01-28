import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final DataPreach data;
  const VideoPlayerScreen({super.key, required this.data});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    String? videoId = YoutubePlayer.convertUrlToId(widget.data.urlVideo);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId!, // Reemplaza con el ID de tu video
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          controlsVisibleAtStart: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
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
                    child: widget.data.urlVideo.contains('youtube.com') ||
                            widget.data.urlVideo.contains('youtu.be')
                        ? YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.orange,
                          onReady: () {
                            // _controller.addListener(() {
                            // if (_controller.value.isReady && !_controller.value.isPlaying) {
                            //   _controller.play();
                            // }
                            // });
                          },
                          )
                        : playerNoYoutube(data: widget.data),
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
                                widget.data.author.replaceAll('.', '.\n'),
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
                                  "${widget.data.date}",
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
                          widget.data.title,
                          style: StylesApp(context)
                              .textStyleBody16
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
                  children: [
                    ButtonThemeWidget(
                      text: "Hebreos 11:6",
                      buttonStyle: StylesApp(context).btnSecondary.copyWith(
                          maximumSize: WidgetStatePropertyAll(
                              Size(double.infinity, double.infinity)),
                          minimumSize: WidgetStatePropertyAll(
                              Size(double.infinity, double.infinity))),
                      width: MediaQuery.sizeOf(context).width,
                      height: StylesApp(context).btnSizeSmall.height,
                    ),
                    ButtonThemeWidget(
                      text: "Salmo 34:17",
                      buttonStyle: StylesApp(context).btnSecondary.copyWith(
                          maximumSize: WidgetStatePropertyAll(
                              Size(double.infinity, double.infinity)),
                          minimumSize: WidgetStatePropertyAll(
                              Size(double.infinity, double.infinity))),
                      width: MediaQuery.sizeOf(context).width,
                      height: StylesApp(context).btnSizeSmall.height,
                    ),
                    ButtonThemeWidget(
                      text: "Gálatas 6:2-8",
                      buttonStyle: StylesApp(context).btnSecondary.copyWith(
                          maximumSize: WidgetStatePropertyAll(
                              Size(double.infinity, double.infinity)),
                          minimumSize: WidgetStatePropertyAll(
                              Size(double.infinity, double.infinity))),
                      width: MediaQuery.sizeOf(context).width,
                      height: StylesApp(context).btnSizeSmall.height,
                    ),
                    ButtonThemeWidget(
                      text: "Mateo 18:20-30",
                      buttonStyle: StylesApp(context).btnSecondary.copyWith(
                          maximumSize: WidgetStatePropertyAll(
                              Size(double.infinity, double.infinity)),
                          minimumSize: WidgetStatePropertyAll(
                              Size(double.infinity, double.infinity))),
                      width: MediaQuery.sizeOf(context).width,
                      height: StylesApp(context).btnSizeSmall.height,
                    ),
                    ButtonThemeWidget(
                      text: "Salmo 46:10",
                      buttonStyle: StylesApp(context).btnSecondary.copyWith(
                          maximumSize: WidgetStatePropertyAll(
                              Size(double.infinity, double.infinity)),
                          minimumSize: WidgetStatePropertyAll(
                              Size(double.infinity, double.infinity))),
                      width: MediaQuery.sizeOf(context).width,
                      height: StylesApp(context).btnSizeSmall.height,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomVideoPlayer extends StatefulWidget {
  final String url;
  const CustomVideoPlayer({Key? key, required this.url}) : super(key: key);

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
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
              AspectRatio(
                aspectRatio: 16 / 16,
                child: VideoPlayer(_videoController),
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

Widget playerNoYoutube({required DataPreach data}) {
  return CustomVideoPlayer(url: data.urlVideo);
}
