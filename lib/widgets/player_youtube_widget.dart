import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerYoutubeWidget extends StatefulWidget {
  final String videoUrl;
  const PlayerYoutubeWidget({super.key, required this.videoUrl});

  @override
  State<PlayerYoutubeWidget> createState() => _PlayerYoutubeWidgetState();
}

class _PlayerYoutubeWidgetState extends State<PlayerYoutubeWidget>
    with WidgetsBindingObserver {
  late YoutubePlayerController _normalController;
  YoutubePlayerController? _fullScreenController;
  bool _isPlayerReady = false;
  OverlayEntry? _fullScreenOverlay;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
          showLiveFullscreenButton: false),
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
          showLiveFullscreenButton: false),
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
                  topActions: [
                    if (_fullScreenController != null && _isPlayerReady)
                      GestureDetector(
                        onTap: _openInYouTube,
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // ✅ No expandir
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width -
                                    50, // ✅ Reservar espacio para el icono
                              ),
                              child: Text(
                                _fullScreenController!.metadata.title,
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.open_in_new,
                              size: 18,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      )
                  ],
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
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.fullscreen, color: Colors.white),
                    onPressed: _isPlayerReady && _isFullScreen
                        ? () => _exitFullScreen()
                        : null,
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
    WidgetsBinding.instance.removeObserver(this);
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
            topActions: [
              if (_normalController != null && _isPlayerReady)
                GestureDetector(
                  onTap: _openInYouTube,
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // ✅ No expandir
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width -
                              60, // ✅ Reservar espacio para el icono
                        ),
                        child: Text(
                          _normalController.metadata.title,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.open_in_new,
                        size: 18,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                )
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.fullscreen, color: Colors.white),
              onPressed: _isPlayerReady && !_isFullScreen
                  ? () => _enterFullScreen(context)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  void _openInYouTube() async {
    final youtubeUrl = widget.videoUrl;

    if (await canLaunchUrl(Uri.parse(youtubeUrl))) {
      await launchUrl(
        Uri.parse(youtubeUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se puede abrir YouTube'),
          ),
        );
      }
    }
  }
}
