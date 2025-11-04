import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PlayerYoutubeWidget extends StatefulWidget {
  final String videoUrl;
  final Function(bool)? onFullScreenChanged;

  const PlayerYoutubeWidget({
    super.key,
    required this.videoUrl,
    this.onFullScreenChanged,
  });

  @override
  State<PlayerYoutubeWidget> createState() => _PlayerYoutubeWidgetState();
}

class _PlayerYoutubeWidgetState extends State<PlayerYoutubeWidget> {
  late  YoutubePlayerController _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    try {
      final videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);

      if (videoId != null) {
        print('🎬 Inicializando reproductor con ID: $videoId');

        _controller = YoutubePlayerController(
          params: const YoutubePlayerParams(
            // 🔥 CONFIGURACIÓN DE IDIOMA ESPAÑOL
            interfaceLanguage: 'es',
            origin: 'https://www.youtube.com',

            // Configuración básica
            showControls: true,
            showFullscreenButton: true,

            mute: false,
            strictRelatedVideos: false,
            enableJavaScript: true,

            // Configuración adicional
            playsInline: false,
            showVideoAnnotations: true,
            color: 'red',
            loop: false,
          ),
        );

        // 🔥 CARGAR EL VIDEO - MÉTODO CORRECTO PARA v5.2.2
        _controller.loadVideoById(videoId: videoId);

        // 🔥 LISTENERS CORRECTOS PARA v5.2.2
        // _controller.listen((event) {
        //   if (event is YoutubePlayerEvent) {
        //     print('✅ Reproductor listo - Idioma: Español');
        //   }
        // });
      }
    } catch (e) {
      print('❌ Error inicializando reproductor: $e');
    }
  }

  void _enterFullScreen() async {
    widget.onFullScreenChanged?.call(true);
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      setState(() {
        _isFullScreen = true;
      });
    } catch (e) {
      widget.onFullScreenChanged?.call(false);
    }
  }

  void _exitFullScreen() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      setState(() {
        _isFullScreen = false;
      });
      widget.onFullScreenChanged?.call(false);
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget _buildNormalPlayer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: YoutubePlayerControllerProvider(
          // 🔥 WRAPPER NECESARIO
          controller: _controller,
          child: YoutubePlayer(
            // 🔥 CORRECTO PARA v5.2.2
            controller: _controller,
            aspectRatio: 16 / 9,
          ),
        ),
      ),
    );
  }

  Widget _buildFullScreenPlayer() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: YoutubePlayerControllerProvider(
                // 🔥 WRAPPER NECESARIO
                controller: _controller,
                child: YoutubePlayer(
                  controller: _controller,
                  aspectRatio: 16 / 9,
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: _exitFullScreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isFullScreen ? _buildFullScreenPlayer() : _buildNormalPlayer();
  }

  @override
  void dispose() {
    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    _controller.close();
    super.dispose();
  }
}
