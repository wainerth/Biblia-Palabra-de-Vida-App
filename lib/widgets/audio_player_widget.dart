import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_filex/open_filex.dart';

import 'package:http/http.dart' as http;

class AudioPlayerWidget extends StatefulWidget {
  final String pathUrl;
  final String? fileName;
  final bool showImage;
  final Color backgroundColor;
  final bool showAction;
  final Color actionColor;
  final Color controlsColor;
  final Color inactiveColor;
  const AudioPlayerWidget(
      {super.key,
      required this.pathUrl,
      this.showImage = true,
      this.showAction = true,
      this.backgroundColor = Colors.green,
      this.actionColor = Colors.black,
      this.controlsColor = Colors.white,
      this.inactiveColor = const Color.fromRGBO(128, 128, 128, 0.5),
      this.fileName});

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer player = AudioPlayer();
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<void>? _playerCompleteSubscription;
  StreamSubscription<PlayerState>? _playerStateChangeSubscription;
  Directory? externalStorage;
  Directory? internalStorage;

  Duration? _duration;
  Duration? _position;
  bool _isPlaying = false;
  bool loading = false;
  double volume = 0.5;
  String get _durationText => _duration?.toString().split('.').first ?? '';
  String get _positionText => _position?.toString().split('.').first ?? '';
  @override
  void initState() {
    super.initState();
    // FlutterDownloader.initialize is already called in main.dart
    _initStreams();
    getDirectory();
    // _play(); // Start playing audio on initialization
  }

  getDirectory() async {
    final externalDir = await getExternalStorageDirectory();
    final internalDir = await getApplicationDocumentsDirectory();
    setState(() {
      externalStorage = externalDir;
      internalStorage = internalDir;
    });
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    player.stop();
    player.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pathUrl != widget.pathUrl) {
      player.stop();
      setState(() {
        _duration = null;
        _position = null;
        _isPlaying = false;
      });
      _initStreams();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && !route.isCurrent && _isPlaying) {
      // La pantalla ya no es la actual y el audio estaba reproduciéndose
      player.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }

  Future<void> downloadFile(
      BuildContext context1, String url, String fileName) async {
    LoadingService().showLoading(context);
    // declaración de variables
    Directory? externalDir;
    Directory? internalDir;

    PermissionStatus storageStatus = PermissionStatus.denied;

    // Obtengo los diferentes directorios dependiendo de la plataforma
    if (Platform.isAndroid) {
      final newStatus = await Permission.storage.request();
      setState(() {
        storageStatus = newStatus;
      });
      externalDir = await getExternalStorageDirectory();
      internalDir = await getApplicationDocumentsDirectory();
    } else {
      internalDir = await getApplicationDocumentsDirectory();
    }

    // tomo el directorio de descarga si tengo permisos uso el externo si no el interno
    Directory? savedDir;
    if (Platform.isAndroid && storageStatus.isGranted && externalDir != null) {
      savedDir = Directory(
          '${externalDir.path}/Download'); //externalDir!.path + '/Download';
    } else if (internalDir != null) {
      savedDir = Directory('${internalDir.path}/Download');
    }
    if (savedDir != null && !await savedDir.exists()) {
      await savedDir.create(recursive: true);
    }

    if (savedDir != null) {
      Future.delayed(Duration(seconds: 1));
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: savedDir.path,
        fileName: "$fileName.mp3",
        showNotification: true,
        openFileFromNotification: Platform.isIOS ? false : true,
      );

      if (kDebugMode) {
        print('Descarga iniciada con ID: $taskId');
      }
      if (taskId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: StyleColor.turquoise,
            content: Text(
              'Descarga iniciada en ${savedDir == externalDir ? 'almacenamiento externo' : 'almacenamiento interno'}. Revisar notificaciones.',
              style: StylesApp(context).textStyleBody12,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: StyleColor.redLight,
            content: Text(
              'Error al iniciar la descarga.',
              style: StylesApp(context).textStyleBody12,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: StyleColor.redLight,
          content: Text(
            'No se pudo acceder al almacenamiento.',
            style: StylesApp(context).textStyleBody12,
          ),
        ),
      );
    }
    LoadingService().hideLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        padding: EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 4,
              color: Colors.black
                  .withValues(alpha: 0.25), // Negro con 25% de transparencia
            ),
          ],
          image: widget.showImage
              ? DecorationImage(
                  opacity: 0.3,
                  image: AssetImage("assets/background_player.jpg"),
                  fit: BoxFit.cover,
                )
              : null,
          color: widget.showImage
              ? Colors.black.withValues(alpha: 0.9)
              : widget.backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (loading) //_isPlaying && _position == null && _duration == null)
                    SizedBox(
                      width: 25.sp,
                      height: 25.sp,
                      child: CircularProgressIndicator(
                        color: widget.controlsColor,
                        strokeWidth: 2.0,
                      ),
                    ),
                  IconButton(
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(minHeight: 24.sp),
                    color: widget.controlsColor,
                    onPressed: widget.pathUrl.isEmpty
                        ? null
                        : () {
                            setState(() {
                              _isPlaying = !_isPlaying;
                            });
                            if (_isPlaying) {
                              _play();
                            } else {
                              player.pause();
                            }
                          },
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 25.sp,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text.rich(
                style: TextStyle(color: widget.actionColor, fontSize: 12.sp),
                TextSpan(
                  text: _position != null && _durationText.isNotEmpty
                      ? '${_positionText.substring(3)} / ${_durationText.substring(3)}'
                      : _duration != null
                          ? _durationText
                          : '0:00 / 0:00',
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Slider(
                thumbColor: widget.controlsColor,
                activeColor: widget.controlsColor,
                inactiveColor: widget.inactiveColor,
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
            Expanded(
              flex: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30.0,
                    padding: EdgeInsets.all(0),
                    child: IconButton(
                      iconSize: 24.0,
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(minHeight: 24.0),
                      onPressed: () {
                        setState(() {
                          if (volume > 0) {
                            volume = 0;
                          } else {
                            volume = 0.5; // Default volume level
                          }
                          player.setVolume(volume);
                        });
                      },
                      icon: Icon(
                        volume > 0 ? Icons.volume_up : Icons.volume_off,
                        color: widget.controlsColor,
                        size: 25.sp,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(0),
                    width: 30.sp,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      iconSize: 25.sp,
                      constraints: BoxConstraints(minHeight: 25.sp),
                      color: widget.actionColor,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                StatefulBuilder(builder: (context, setState) {
                                  return ListTile(
                                    leading: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (volume > 0) {
                                            volume = 0;
                                          } else {
                                            volume =
                                                0.5; // Default volume level
                                          }
                                          player.setVolume(volume);
                                        });
                                      },
                                      icon: Icon(volume > 0
                                          ? Icons.volume_up
                                          : Icons.volume_off),
                                    ),
                                    title: Slider(
                                      value: volume,
                                      onChanged: (newVolume) {
                                        setState(() => volume = newVolume);
                                        player.setVolume(volume);
                                      },
                                      min: 0.0,
                                      max: 1.0,
                                    ),
                                  );
                                }),
                                ListTile(
                                  leading: Icon(Icons.download),
                                  title: Text('Descargar'),
                                  onTap: widget.pathUrl.isEmpty
                                      ? null
                                      : () async {
                                          Navigator.pop(context);
                                          downloadFile(
                                              context,
                                              widget.pathUrl,
                                              widget.fileName == null
                                                  ? 'audio.mp3'
                                                  : widget.fileName!);
                                        },
                                ),
                                ListTile(
                                  leading: Icon(Icons.share),
                                  title: Text('Compartir'),
                                  onTap: widget.pathUrl.isEmpty
                                      ? null
                                      : () async {
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
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  backgroundColor:
                                                      StyleColor.redLight,
                                                  content: Text(
                                                      'Archivo de audio no encontrado')),
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
                      icon: const Icon(
                        Icons.more_vert,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
    setState(() {
      loading = true;
    });
    await player.play(UrlSource(widget.pathUrl));
    setState(() {
      loading = false;
    });
  }
}
