import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerYoutubeWidget extends StatefulWidget {
  final String videoUrl;
  const PlayerYoutubeWidget({super.key, required this.videoUrl});

  @override
  State<PlayerYoutubeWidget> createState() => _PlayerYoutubeWidgetState();
}

class _PlayerYoutubeWidgetState extends State<PlayerYoutubeWidget> {
  late YoutubePlayerController _normalController;
  YoutubePlayerController? _fullScreenController;
  bool _isPlayerReady = false;
  OverlayEntry? _fullScreenOverlay;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _initializeNormalController();
  }

  void _initializeNormalController() {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    _normalController = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        enableCaption: false, // Deshabilitar captions puede ayudar
      ),
    );

    _normalController.addListener(() {
      if (_isPlayerReady && mounted && !_isFullScreen) {
        setState(() {});
      }
    });
  }

  void _initializeFullScreenController() {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    _fullScreenController = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        enableCaption: false,
      ),
    );
  }

  void _enterFullScreen(BuildContext context) {
    if (_isFullScreen) return;

    setState(() {
      _isFullScreen = true;
    });

    // Pausar el reproductor normal antes de entrar en fullscreen
    _normalController.pause();

    // Ocultar barras del sistema
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Inicializar controlador para fullscreen
    _initializeFullScreenController();

    // Crear overlay que cubre toda la pantalla
    _fullScreenOverlay = OverlayEntry(
      builder: (context) => Scaffold(
        backgroundColor: Colors.black,
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, result) {
            if (didPop) return;
            _exitFullScreen();
          },
          child: SafeArea(
            child: Stack(
              children: [
                // Reproductor a pantalla completa con controlador separado
                YoutubePlayer(
                  controller: _fullScreenController!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.blueAccent,
                  onReady: () {
                    // Sincronizar el estado con el reproductor normal
                    final currentPosition = _normalController.value.position;
                    if (currentPosition.inSeconds > 0) {
                      _fullScreenController!.seekTo(currentPosition);
                    }
                  },
                ),
                // Botón para salir del fullscreen
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: _exitFullScreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Mostrar el overlay
    Overlay.of(context).insert(_fullScreenOverlay!);
  }

  void _exitFullScreen() {
    if (!_isFullScreen) return;

    // Guardar la posición actual del video en fullscreen
    final currentPosition =
        _fullScreenController?.value.position ?? Duration.zero;

    // Limpiar el overlay
    if (_fullScreenOverlay != null) {
      _fullScreenOverlay!.remove();
      _fullScreenOverlay = null;
    }

    // Disposer el controlador de fullscreen
    if (_fullScreenController != null) {
      _fullScreenController!.dispose();
      _fullScreenController = null;
    }

    // Sincronizar la posición con el reproductor normal
    if (currentPosition.inSeconds > 0) {
      _normalController.seekTo(currentPosition);
    }

    // Restaurar UI del sistema
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    setState(() {
      _isFullScreen = false;
    });

    // Reanudar el video en el reproductor normal si estaba reproduciéndose
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _normalController.play();
      }
    });
  }

  @override
  void dispose() {
    _exitFullScreen();
    _normalController.dispose();
    _fullScreenController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 200,
        maxHeight: 300,
      ),
      child: Stack(
        children: [
          YoutubePlayer(
            controller: _normalController,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            onReady: () {
              setState(() {
                _isPlayerReady = true;
              });
            },
            onEnded: (data) {
              // Lógica cuando termina el video
            },
          ),
          // Positioned(
          //   bottom: 10,
          //   right: 10,
          //   child: IconButton(
          //     icon: const Icon(Icons.fullscreen, color: Colors.white),
          //     onPressed: _isPlayerReady && !_isFullScreen
          //         ? () => _enterFullScreen(context)
          //         : null,
          //   ),
          // ),
        ],
      ),
    );
  }
}
