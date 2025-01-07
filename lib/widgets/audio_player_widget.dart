import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class AudioPlayerWidget extends StatefulWidget {
  final String pathUrl;
  const AudioPlayerWidget({super.key, required this.pathUrl});

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer player = AudioPlayer();
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<void>? _playerCompleteSubscription;
  StreamSubscription<PlayerState>? _playerStateChangeSubscription;

  Duration? _duration;
  Duration? _position;
  bool _isPlaying = false;
  double volume = 0.5;
  String get _durationText => _duration?.toString().split('.').first ?? '';
  String get _positionText => _position?.toString().split('.').first ?? '';

  @override
  void initState() {
    super.initState();
    _initStreams();
    // _play(); // Start playing audio on initialization
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    player.dispose();
    super.dispose();
  }

  Future<void> _downloadFile(url) async {
    try {
      // Obtener la dirección del directorio de documentos
      final directory = await getApplicationDocumentsDirectory();

      // Crear la ruta del archivo de destino
      final filePath = '${directory.path}/audio.mp3';

      // Descargar el archivo
      final response = await http.get(Uri.parse(url));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Descarga completada')),
      );
    } catch (e) {
      // Manejar errores
      print('Error al descargar el archivo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al descargar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      padding: EdgeInsets.all(0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          opacity: 0.3,
          image: AssetImage("/background_player.jpg"),
          fit: BoxFit.cover,
        ),
        color: Colors.black.withValues(alpha: 90.0)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: IconButton(
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints(
                minHeight: 24.0
              ),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _isPlaying = !_isPlaying;
                });
                if (_isPlaying) {
                  _play();
                } else {
                  player.pause();
                }
              },
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            ),
          ),
          Text.rich(
            style: TextStyle(color: Colors.white),
            TextSpan(
              text: _position != null
                  ? '$_positionText / $_durationText'
                  : _duration != null
                      ? _durationText
                      : '0:00:00 / 0:00:00',
            ),
          ),
          Expanded(
            child: Slider(
              onChanged: (value) {
                final duration = _duration;
                if (duration == null) return;
                final position = value * duration.inMilliseconds;
                player.seek(Duration(milliseconds: position.round()));
              },
              value: (_position != null &&
                      _duration != null &&
                      _position!.inMilliseconds > 0 &&
                      _position!.inMilliseconds < _duration!.inMilliseconds)
                  ? _position!.inMilliseconds / _duration!.inMilliseconds
                  : 0.0,
            ),
          ),
          // IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          IconButton(
             padding: EdgeInsets.all(0),
              constraints: BoxConstraints(
                minHeight: 24.0
              ),
            color: Colors.white,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.volume_up),
                        title: StatefulBuilder(
                          builder: (context, setState) {
                            return Slider(
                              value: volume,
                              onChanged: (newVolume) {
                                setState(() => volume = newVolume);
                                player.setVolume(volume);
                              },
                              min: 0.0,
                              max: 1.0,
                            );
                          },
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.download),
                        title: Text('Download'),
                        onTap: () async {
                          _downloadFile(widget.pathUrl);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.share),
                        title: Text('Share'),
                        onTap: () async {
                          final directory =
                              await getApplicationDocumentsDirectory();
                          final filePath =
                              '${directory.path}/${widget.pathUrl}';
                          final file = File(filePath);
                          if (await file.exists()) {
                            // Use the share package to share the file
                            Share.shareXFiles([XFile(filePath)],
                                text: '¡Mira este audio!');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Archivo de audio no encontrado')),
                            );
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _position = Duration.zero;
        _isPlaying = false;
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        setState(() => _isPlaying = true);
      } else if (state == PlayerState.paused) {
        setState(() => _isPlaying = false);
      }
    });
  }

  Future<void> _play() async {
    await player.play(AssetSource(widget.pathUrl));
  }
}
