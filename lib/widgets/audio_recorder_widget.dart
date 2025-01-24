import 'dart:async';

import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderWidget extends StatefulWidget {
  const AudioRecorderWidget({
    super.key,
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget>
    with SingleTickerProviderStateMixin {
  final FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();
  AudioPlayer audioPlayer = AudioPlayer();
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<void>? _playerCompleteSubscription;
  StreamSubscription<PlayerState>? _playerStateChangeSubscription;

  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isRecorderInitialized = false;
  bool _isRecording = false;
  bool _isPlaying = false;
  double volume = 0.5;
  Duration? _duration;
  Duration? _position;
  Duration _recordingDuration = Duration.zero;
  Timer? _recordingTimer;
  String get _durationText => _duration?.toString().split('.').first ?? '';
  String get _positionText => _position?.toString().split('.').first ?? '';
  String get _recordingDurationText =>
      _recordingDuration.toString().split('.').first;
  String? _audioPath;

  Future<bool> _hasMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  Future<void> initRecorder() async {
    try {
      if (await _hasMicrophonePermission()) {
        await _soundRecorder.openRecorder();
      } else {
        if (kDebugMode) {
          print('Microphone permission denied');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    setState(() {
      _isRecorderInitialized = true;
    });
  }

  Future<void> startRecording() async {
    try {
      setState(() {
        _isRecording = true;
        _recordingDuration = Duration.zero;
      });
      await _soundRecorder.startRecorder(toFile: 'audio.aac');
      _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _recordingDuration += Duration(seconds: 1);
        });
      });
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Codec not supported: $e');
      }
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error de codificación'),
              content: Text('El codec seleccionado no es compatible.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al iniciar la grabación: $e');
      }
    }
  }

  Future<void> stopRecording() async {
    final path = await _soundRecorder.stopRecorder();
    _recordingTimer?.cancel();
    if (kDebugMode) {
      print('Record finished: $path');
    }
    setState(() {
      _isRecording = false;
      _isPlaying = false;
      _audioPath = path;
    });
  }

  void _playAudio() async {
    audioPlayer.setVolume(volume);
    await audioPlayer.play(DeviceFileSource(_audioPath!));
    setState(() {
      _isPlaying = true;
    });
  }

  void _pauseAudio() async {
    await audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _initStreams() {
    _durationSubscription = audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = audioPlayer.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    _playerCompleteSubscription = audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _position = Duration.zero;
        _isPlaying = false;
      });
    });

    _playerStateChangeSubscription =
        audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        setState(() => _isPlaying = true);
      } else if (state == PlayerState.paused) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    initRecorder();
    _initStreams();
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    _recordingTimer?.cancel();
    audioPlayer.dispose();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 0,
                child: _isRecording
                  ? AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                      scale: _animation.value,
                      child: child,
                      );
                    },
                    child: IconButton(
                      iconSize: 35.sp,
                      onPressed: () {},
                      icon: Icon(
                      Icons.mic,
                      color: Colors.white,
                      ),
                    ),
                    )
                  : IconButton(
                    iconSize: 35.sp,
                    onPressed: startRecording,
                    icon: Icon(
                      Icons.mic,
                      color: Colors.black,
                    ),
                    ),
                ),
            SizedBox(
              width: 10,
            ),
            if (!_isRecording) ...{
              Expanded(
                flex: 2,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 36.sp,
                    maxHeight: 36.sp,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(0XFF8ADF85),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 0,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          iconSize: 24.sp,
                          icon:
                              Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                          onPressed: _audioPath == null
                              ? null
                              : _isPlaying
                                  ? _pauseAudio
                                  : _playAudio,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _position != null
                              ? '${_positionText.substring(3)} / ${_durationText.substring(3)}'
                              : _duration != null
                                  ? _durationText.substring(3)
                                  : '0:00 / 0:00',
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Slider(
                          value: (_position != null &&
                                  _duration != null &&
                                  _position!.inMilliseconds > 0 &&
                                  _position!.inMilliseconds <
                                      _duration!.inMilliseconds)
                              ? _position!.inMilliseconds /
                                  _duration!.inMilliseconds
                              : 0.0,
                          onChanged: (value) {
                            final duration = _duration;
                            if (duration == null) return;
                            final position = value * duration.inMilliseconds;
                            audioPlayer
                                .seek(Duration(milliseconds: position.round()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            } else ...{
              Expanded(
                flex: 2,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 36.sp,
                    maxHeight: 36.sp,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.redAccent,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 0,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          iconSize: 24.sp,
                          icon: Icon(Icons.stop),
                          onPressed: stopRecording,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Grabando: ${_recordingDurationText.substring(3)}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            }
          ],
        ),
        // Text.rich(
        //   style: TextStyle(color: Colors.white),
        //   TextSpan(
        //     text: _isRecording
        //         ? 'Grabando: ${_recordingDurationText.substring(3)}'
        //         : _position != null
        //             ? '${_positionText.substring(3)} / ${_durationText.substring(3)}'
        //             : _duration != null
        //                 ? _durationText.substring(3)
        //                 : '0:00 / 0:00',
        //   ),
        // )
      ],
    );
  }
}
