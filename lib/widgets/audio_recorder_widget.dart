import 'dart:async';
import 'dart:io';

import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound.dart' as fs;
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart' as ap;

class AudioRecorderWidget extends StatefulWidget {
  final bool saveToDevice;
  final Function(File) onAudioRecorded;
  const AudioRecorderWidget({
    super.key,
    this.saveToDevice = false,
    required this.onAudioRecorded,
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget>
    with SingleTickerProviderStateMixin {
  final fs.FlutterSoundRecorder _soundRecorder = fs.FlutterSoundRecorder();
  ap.AudioPlayer audioPlayer = ap.AudioPlayer();
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<void>? _playerCompleteSubscription;
  StreamSubscription<ap.PlayerState>? _playerStateChangeSubscription;

  late AnimationController _controller;
  late Animation<double> _animation;

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

  bool _isRecorderReady = false;
  bool _hasMicPermission = false;

  // CORREGIDO: Manejo de permisos más robusto
  Future<bool> _checkAndRequestMicrophonePermission() async {
    try {
      // Verificar estado actual
      PermissionStatus status = await Permission.microphone.status;

      if (kDebugMode) {
        print('🎤 Estado permiso micrófono: $status');
      }

      if (status.isGranted) {
        return true;
      }

      if (status.isDenied) {
        // Mostrar explicación si es la primera vez
        if (await Permission.microphone.shouldShowRequestRationale) {
          await _showPermissionExplanation();
        }

        // Solicitar permiso
        status = await Permission.microphone.request();

        if (kDebugMode) {
          print('🎤 Respuesta solicitud permiso: $status');
        }

        return status.isGranted;
      }

      if (status.isPermanentlyDenied) {
        // Guiar al usuario a configuraciones
        await _openAppSettings();
        return false;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('🎤 Error verificación permiso: $e');
      }
      return false;
    }
  }

  Future<void> initRecorder() async {
    try {
      // Primero verificar/obtener permiso
      _hasMicPermission = await _checkAndRequestMicrophonePermission();

      if (!_hasMicPermission) {
        if (kDebugMode) {
          print('🎤 Permiso de micrófono denegado');
        }
        if (mounted) {
          await _showPermissionDeniedDialog();
        }
        return;
      }

      // Abrir grabador solo si tenemos permiso
      await _soundRecorder.openRecorder();
      _isRecorderReady = true;

      if (kDebugMode) {
        print('🎤 Grabador inicializado exitosamente');
      }
    } catch (e) {
      if (kDebugMode) {
        print('🎤 Error inicializando grabador: $e');
      }
      _isRecorderReady = false;

      if (mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error de inicialización'),
              content: Text('No se pudo inicializar el grabador de audio.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> startRecording() async {
    try {
      // Verificar permiso nuevamente (por si cambió)
      if (!_hasMicPermission) {
        _hasMicPermission = await _checkAndRequestMicrophonePermission();
      }

      if (!_hasMicPermission) {
        if (mounted) {
          await _showPermissionDeniedDialog();
        }
        return;
      }

      // Verificar que el grabador esté abierto
      if (_isRecording) {
        if (kDebugMode) {
          print('🎤 Ya se está grabando');
        }
        return;
      }

      // Verificar que el grabador esté listo
      if (!_isRecorderReady) {
        await initRecorder();
      }

      if (!_isRecorderReady) {
        if (mounted) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('El grabador no está disponible.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Aceptar'),
                  ),
                ],
              );
            },
          );
        }
        return;
      }

      // Iniciar grabación
      setState(() {
        _isRecording = true;
        _recordingDuration = Duration.zero;
      });

      // ✅ IMPORTANTE: Usar AAC codec (compatible)
      await _soundRecorder.startRecorder(
        toFile: 'audio.aac',
        codec: fs.Codec.aacADTS, // Codec más compatible
      );

      // Iniciar timer para mostrar duración
      _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _recordingDuration += Duration(seconds: 1);
          });
        }
      });

      if (kDebugMode) {
        print('🎤 Grabación iniciada');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('🎤 Error codec: $e');
      }

      if (mounted) {
        setState(() {
          _isRecording = false;
          _isRecorderReady = false;
        });
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error de grabación'),
              content:
                  Text('No se pudo iniciar la grabación. Intente nuevamente.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }

      // Resetear estado
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('🎤 Error al iniciar grabación: $e');
      }

      if (mounted) {
        setState(() {
          _isRecording = false;
          _isRecorderReady = false;
        });
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Error inesperado al grabar.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> stopRecording() async {
    try {
      _recordingTimer?.cancel();

      if (!_isRecording) {
        return;
      }

      final path = await _soundRecorder.stopRecorder();

      if (kDebugMode) {
        print('🎤 Grabación detenida. Ruta: $path');
      }

      if (path != null && path.isNotEmpty) {
        final file = File(path);

        // Verificar que el archivo existe
        if (await file.exists()) {
          // Llamar callback con el archivo
          widget.onAudioRecorded.call(file);

          if (kDebugMode) {
            print(
                '🎤 Archivo guardado: ${file.path} (${await file.length()} bytes)');
          }
        } else {
          throw Exception('Archivo grabado no encontrado');
        }
      }

      if (mounted) {
        setState(() {
          _isRecording = false;
          _isPlaying = false;
          _audioPath = path;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('🎤 Error deteniendo grabación: $e');
      }

      if (mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Error al guardar la grabación.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _playAudio() async {
    if (_audioPath == null) return;

    try {
      audioPlayer.setVolume(volume);
      await audioPlayer.play(ap.DeviceFileSource(_audioPath!));
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print('🎤 Error reproduciendo audio: $e');
      }
    }
  }

  void _pauseAudio() async {
    try {
      await audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('🎤 Error pausando audio: $e');
      }
    }
  }

  void _initStreams() {
    _durationSubscription = audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration);
      }
    });

    _positionSubscription = audioPlayer.onPositionChanged.listen((p) {
      if (mounted) {
        setState(() => _position = p);
      }
    });

    _playerCompleteSubscription = audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _position = Duration.zero;
          _isPlaying = false;
        });
      }
    });

    _playerStateChangeSubscription =
        audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        if (state == ap.PlayerState.playing) {
          setState(() => _isPlaying = true);
        } else if (state == PlayerState.paused) {
          setState(() => _isPlaying = false);
        }
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
    // Inicializar grabador
    initRecorder();

    // Inicializar streams de reproducción
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
    if (_isRecorderReady) {
      _soundRecorder.closeRecorder();
    }

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
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            border: Border.all(
                              color: Colors.greenAccent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(100)),
                        child: IconButton(
                          iconSize: 30.sp,
                          onPressed: null,
                          icon: Icon(
                            Icons.mic,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          border: Border.all(
                            color: Colors.greenAccent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(100)),
                      child: IconButton(
                        iconSize: 35.sp,
                        onPressed: startRecording,
                        icon: Icon(
                          Icons.mic,
                          color: Colors.black,
                        ),
                      ),
                    ),
            ),
            SizedBox(
              width: 10,
            ),
            if (!_isRecording && _audioPath != null) ...{
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
            } else if (_isRecording) ...{
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
      ],
    );
  }

  Future<void> _showPermissionExplanation() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permiso de micrófono necesario'),
        content: Text(
            'Esta aplicación necesita acceso al micrófono para grabar audio. '
            'El audio grabado solo se usará dentro de la aplicación.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Continuar con solicitud
            },
            child: Text('Continuar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showPermissionDeniedDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permiso denegado'),
        content:
            Text('Necesitas permitir el acceso al micrófono para grabar audio. '
                'Puedes habilitarlo en la configuración de la aplicación.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openAppSettings();
            },
            child: Text('Abrir configuración'),
          ),
        ],
      ),
    );
  }

  Future<void> _openAppSettings() async {
    try {
      await openAppSettings();
    } catch (e) {
      if (kDebugMode) {
        print('🎤 Error abriendo configuración: $e');
      }
    }
  }
}
