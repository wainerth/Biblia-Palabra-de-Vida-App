import 'dart:async';
import 'dart:io';

import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initStreams();
      getDirectory();
    });
    // _play(); // Start playing audio on initialization
  }

  getDirectory() async {
    final internalDir = await getApplicationDocumentsDirectory();
    if (!mounted) return;
    setState(() {
      internalStorage = internalDir;
    });
  }

  @override
  void dispose() {
    player.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
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

  // Future<void> downloadFile(
  //     BuildContext context1, String url, String fileName) async {
  //   LoadingService().showLoading(context);
  //   Directory? downloadDir;

  //   try {
  //     // Obtengo los diferentes directorios dependiendo de la plataforma
  //     if (Platform.isAndroid) {
  //       downloadDir = await _getInternalDownloadDirectory();
  //       // internalDir = await getExternalStorageDirectory();
  //     } else {
  //       downloadDir = await getApplicationDocumentsDirectory();
  //     }

  //     // tomo el directorio de descarga si tengo permisos uso el externo si no el interno
  //     // Crear directorio si no existe
  //     final savedDir = Directory('${downloadDir?.path}/Download');

  //     if (!await savedDir.exists()) {
  //       await savedDir.create(recursive: true);
  //     }

  //     // ✅ VERIFICAR que tenemos permisos de escritura (no storage)
  //     final canWrite = await _checkWritePermission(downloadDir!);
  //     if (!canWrite) {
  //       throw Exception('No se pudo escribir en el directorio');
  //     }

  //     Future.delayed(Duration(seconds: 1));
  //     final taskId = await FlutterDownloader.enqueue(
  //       url: url,
  //       savedDir: savedDir.path,
  //       fileName: "$fileName.mp3",
  //       showNotification: true,
  //       openFileFromNotification: Platform.isIOS ? false : true,
  //     );

  //     if (kDebugMode) {
  //       print('Descarga iniciada con ID: $taskId');
  //     }
  //     if (taskId != null) {
  //       if (mounted) {
  //         showSnackBar(
  //             '✅ Descarga iniciada. El archivo se guardará en: ${savedDir.path}',
  //             type: SnackBarType.success);
  //       }
  //     } else {
  //       if (mounted) {
  //         showSnackBar('Error al iniciar la descarga.',
  //             type: SnackBarType.error);
  //       }
  //     }

  //     LoadingService().hideLoading();
  //   } catch (e) {
  //     LoadingService().hideLoading();
  //     if (mounted) {
  //       await showCustomDialog(context,
  //           message: e.toString(), dialogType: DialogType.error);
  //     }
  //   } finally {
  //     LoadingService().hideLoading();
  //   }
  // }

  Future<void> downloadFile(
      BuildContext context1, String url, String fileName) async {
    LoadingService().showLoading(context);

    try {
      // 1. Obtener directorio INTERNO (NO requiere permisos)
      final directory = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${directory.path}/Biblia_Audios');

      // Crear directorio si no existe
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      // 2. Crear nombre de archivo seguro
      final safeFileName = _getSafeFileName(fileName);
      final filePath = '${downloadDir.path}/$safeFileName.mp3';

      // 3. Descargar directamente con Dio (más simple)
      final dio = Dio();
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (kDebugMode) {
            if (total != -1) {
              final progress = (received / total * 100).toStringAsFixed(0);
              print('📥 Descargando: $progress%');
            }
          }
        },
      );

      LoadingService().hideLoading();

      // 4. Mostrar éxito y opciones
      if (mounted) {
        showSnackBar(
          '✅ Audio descargado correctamente',
          type: SnackBarType.success,
        );

        // 5. Mostrar opciones al usuario
        await _showDownloadOptions(context, filePath, safeFileName);
      }
    } catch (e) {
      LoadingService().hideLoading();
      if (mounted) {
        showSnackBar(
          '❌ Error al descargar: ${e.toString()}',
          type: SnackBarType.error,
        );
      }
    }
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
                    disabledColor: widget.inactiveColor,
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
                      color: widget.controlsColor,
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
                      disabledColor: widget.inactiveColor,
                      padding: EdgeInsets.all(0),
                      iconSize: 25.sp,
                      constraints: BoxConstraints(minHeight: 25.sp),
                      color: widget.actionColor,
                      onPressed: widget.pathUrl.isEmpty
                          ? null
                          : () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      StatefulBuilder(
                                          builder: (context, setState) {
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
                                              setState(
                                                  () => volume = newVolume);
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
                                                await downloadFile(
                                                  context,
                                                  widget.pathUrl,
                                                  widget.fileName == null
                                                      ? 'audio'
                                                      : widget.fileName!,
                                                );
                                              },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.share),
                                        title: Text('Compartir'),
                                        onTap: widget.pathUrl.isEmpty
                                            ? null
                                            : () async {
                                                final String audioUrl = widget
                                                    .pathUrl; // Tu URL del audio

                                                try {
                                                  // 1. Descargar el archivo temporalmente
                                                  final response =
                                                      await Dio().get(
                                                    audioUrl,
                                                    options: Options(
                                                        responseType:
                                                            ResponseType.bytes),
                                                  );

                                                  // 2. Crear archivo temporal
                                                  final tempDir =
                                                      await getTemporaryDirectory();
                                                  final tempFile = File(
                                                      '${tempDir.path}/audio_temp.mp3');
                                                  await tempFile.writeAsBytes(
                                                      response.data);

                                                  // 3. Compartir el archivo
                                                  await SharePlus.instance
                                                      .share(ShareParams(
                                                    files: [
                                                      XFile(tempFile.path),
                                                    ],
                                                    text:
                                                        '¡Escucha este audio!',
                                                  ));

                                                  // 4. Opcional: Eliminar el temporal después de compartir
                                                  tempFile.delete();
                                                } catch (e) {
                                                  if (mounted) {
                                                    final currentContext =
                                                        context;
                                                    if (currentContext
                                                        .mounted) {
                                                      showSnackBar(
                                                          'Error al compartir el audio',
                                                          type: SnackBarType
                                                              .error);
                                                    }
                                                  }
                                                }

                                                if (mounted) {
                                                  final currentContext =
                                                      context;
                                                  if (currentContext.mounted) {
                                                    Navigator.pop(
                                                        currentContext);
                                                  }
                                                }
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
    try {
      await player.play(UrlSource(widget.pathUrl));
      setState(() {
        loading = false;
      });
    } catch (e) {
      await showCustomDialog(context,
          message: e.toString(), dialogType: DialogType.error);

      setState(() {
        _isPlaying = false;
        loading = false;
      });
    }
  }

  Future _checkWritePermission(Directory downloadDir) async {
    try {
      // Intentar crear un archivo temporal
      final testFile = File('${downloadDir.path}/.test_write_permission.tmp');
      await testFile.writeAsString('test');
      await testFile.delete();
      return true;
    } catch (e) {
      if (kDebugMode) print('🚫 Error escritura: $e');
      return false;
    }
  }

  Future<Directory?> _getInternalDownloadDirectory() async {
    if (Platform.isAndroid) {
      // Para Android 10+, usar el directorio específico de la app
      final appDocDir = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${appDocDir.path}/Download');

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      return downloadDir;
    } else {
      // Para iOS
      final appDocDir = await getApplicationDocumentsDirectory();
      return appDocDir;
    }
  }

  Future<void> downloadFileDirect(
      BuildContext context1, String url, String fileName) async {
    LoadingService().showLoading(context);

    try {
      // 1. Obtener directorio
      final directory = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${directory.path}/Download');

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      // 2. Descargar con Dio
      final dio = Dio();
      final savePath = '${downloadDir.path}/$fileName.mp3';

      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            if (kDebugMode) print('📥 Descargando: $progress%');
          }
        },
      );

      // 3. Notificar éxito
      if (mounted) {
        showSnackBar('✅ Descarga completada: $fileName.mp3',
            type: SnackBarType.success);
      }

      // 4. (Opcional) Abrir el archivo o notificar al sistema
      await _notifyDownloadComplete(savePath, fileName);
    } catch (e) {
      if (kDebugMode) print('🚫 Error descarga directa: $e');

      if (mounted) {
        showSnackBar('❌ Error descargando: ${e.toString()}',
            type: SnackBarType.error);
      }
    } finally {
      LoadingService().hideLoading();
    }
  }

  // ✅ Notificar al sistema que hay un nuevo archivo (Android)
  Future<void> _notifyDownloadComplete(String filePath, String fileName) async {
    if (Platform.isAndroid) {
      try {
        // Esto actualiza la galería/media scanner
        await FlutterDownloader.loadTasksWithRawQuery(
            query:
                'UPDATE downloaded_files SET status=3 WHERE file_path="$filePath"');
      } catch (e) {
        if (kDebugMode) print('⚠️ No se pudo notificar al sistema: $e');
      }
    }
  }

  // Agregar esta función en AudioPlayerWidgetState
  Future<void> _showDownloadOptions(
      BuildContext context, String filePath, String fileName) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Descarga completada'),
              subtitle: Text('$fileName.mp3'),
            ),
            Divider(height: 1),
            // ListTile(
            //   leading: Icon(Icons.play_arrow, color: Colors.blue),
            //   title: Text('Escuchar ahora'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     // Aquí puedes reproducir el audio descargado
            //     _playLocalAudio(filePath);
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.share, color: Colors.green),
              title: Text('Compartir audio'),
              onTap: () {
                Navigator.pop(context);
                _shareAudioFile(filePath, fileName);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt, color: Colors.orange),
              title: Text('Guardar en galería (opcional)'),
              subtitle: Text('Requiere permiso de almacenamiento'),
              onTap: () async {
                Navigator.pop(context);
                // SOLO aquí pedir permiso para guardar externamente
                await _saveToExternalStorage(filePath, fileName);
              },
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Future<void> _shareAudioFile(String filePath, String fileName) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await Share.shareXFiles(
          [XFile(filePath)],
          text: 'Audio de la Biblia - $fileName',
          subject: 'Palabra de Vida',
        );
      }
    } catch (e) {
      if (mounted) {
        showSnackBar('Error al compartir', type: SnackBarType.error);
      }
    }
  }

  Future<void> _saveToExternalStorage(String filePath, String fileName) async {
    try {
      // SOLO para Android
      if (Platform.isAndroid) {
        // Solicitar permiso SOLO cuando el usuario quiera guardar externamente
        final status = await Permission.storage.request();

        if (!status.isGranted) {
          if (mounted) {
            showSnackBar(
              'Permiso necesario para guardar en galería',
              type: SnackBarType.warning,
            );
          }
          return;
        }

        // Obtener directorio público de Descargas
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          final publicDir = Directory('${externalDir.path}/Download/Biblia');

          if (!await publicDir.exists()) {
            await publicDir.create(recursive: true);
          }

          final sourceFile = File(filePath);
          final destFile = File('${publicDir.path}/$fileName.mp3');

          await sourceFile.copy(destFile.path);

          if (mounted) {
            showSnackBar(
              '✅ Audio guardado en Descargas/Biblia',
              type: SnackBarType.success,
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar('Error al guardar: $e', type: SnackBarType.error);
      }
    }
  }

  String _getSafeFileName(String fileName) {
    // Limpiar nombre de archivo
    return fileName
        .replaceAll(RegExp(r'[^\w\s-]'), '') // Quitar caracteres especiales
        .replaceAll(RegExp(r'\s+'), '_') // Espacios a guiones bajos
        .toLowerCase();
  }

  Future<void> _playLocalAudio(String filePath) async {
    try {
      // Verificar si el archivo existe
      final file = File(filePath);
      if (!await file.exists()) {
        showSnackBar('El archivo no existe', type: SnackBarType.error);
        return;
      }

      // Detener reproducción actual si hay
      if (_isPlaying) {
        await player.stop();
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }

      // Reproducir archivo local
      setState(() {
        loading = true;
      });

      await player.play(DeviceFileSource(filePath));

      setState(() {
        loading = false;
        _isPlaying = true;
      });

      if (kDebugMode) {
        print('▶️ Reproduciendo audio local: $filePath');
      }
    } catch (e) {
      setState(() {
        loading = false;
        _isPlaying = false;
      });

      if (mounted) {
        showSnackBar(
          'Error al reproducir archivo local: ${e.toString()}',
          type: SnackBarType.error,
        );
      }

      if (kDebugMode) {
        print('❌ Error reproduciendo local: $e');
      }
    }
  }
}
