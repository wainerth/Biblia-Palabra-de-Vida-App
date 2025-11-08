import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';

class PlayerNoYoutube extends StatefulWidget {
  final String url;
  const PlayerNoYoutube({super.key, required this.url});

  @override
  PlayerNoYoutubeState createState() => PlayerNoYoutubeState();
}

class PlayerNoYoutubeState extends State<PlayerNoYoutube> {
  late VideoPlayerController _videoController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
      videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true),
    )..initialize().then((_) {
        setState(() {});
      });

    _videoController.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = _videoController.value.isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: _videoController.value.isInitialized
          ? Column(
              children: [
                Expanded(
                  flex: 5,
                  child: AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                ),
                VideoProgressIndicator(_videoController, allowScrubbing: true),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
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
                            icon: Icon(
                              Icons.fast_rewind,
                              color: StyleColor.turquoise,
                            ),
                            onPressed: () {
                              _videoController.seekTo(
                                _videoController.value.position -
                                    Duration(seconds: 10),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.fast_forward,
                              color: StyleColor.turquoise,
                            ),
                            onPressed: () {
                              _videoController.seekTo(
                                _videoController.value.position +
                                    Duration(seconds: 10),
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
                                  _videoController.value.volume == 0
                                      ? 1.0
                                      : 0.0,
                                );
                              });
                            },
                          ),
                          SizedBox(
                            width: 150,
                            child: Slider(
                              value: _videoController.value.volume,
                              min: 0.0,
                              max: 1.0,
                              activeColor: StyleColor.turquoise,
                              inactiveColor: Colors.grey[300],
                              onChanged: (value) {
                                setState(() {
                                  _videoController.setVolume(value);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
