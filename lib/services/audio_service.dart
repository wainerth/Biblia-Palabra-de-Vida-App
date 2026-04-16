import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  late AudioPlayer _backgroundPlayer;
  late AudioPlayer _sfxPlayer;
  
  // Cache para sonidos cortos
  final Map<String, AudioPlayer> _soundCache = {};
  
  bool _isDisposed = false;
  bool _isBackgroundPlaying = false;
  bool _isCacheInitialized = false;

  AudioService() {
    _initialize();
  }

  Future<void> _initialize() async {
    _backgroundPlayer = AudioPlayer()
      ..setReleaseMode(ReleaseMode.loop)
      ..setVolume(0.3)
      ..setPlayerMode(PlayerMode.mediaPlayer);

    _sfxPlayer = AudioPlayer()
      ..setPlayerMode(PlayerMode.lowLatency);

    _setupBackgroundMusicListeners();
    
    // Inicializar caché de sonidos
    await _initializeSoundCache();
  }

  void _setupBackgroundMusicListeners() {
    _backgroundPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.stopped) {
        _isBackgroundPlaying = false;
      } else if (state == PlayerState.playing) {
        _isBackgroundPlaying = true;
      }
    });

    _backgroundPlayer.onPlayerComplete.listen((event) {
      if (!_isDisposed && _isBackgroundPlaying) {
        _backgroundPlayer.resume();
      }
    });
  }

  Future<void> _initializeSoundCache() async {
    if (_isCacheInitialized) return;
    
    final stopwatch = Stopwatch()..start();
    
    try {
      final soundFiles = [
        'sounds/card_tap.mp3',
        'sounds/match_success.mp3',
        'sounds/match_fail.mp3',
        'sounds/time_up.mp3',
        'sounds/counter-clock.mp3',
        'sounds/failed-attempts.mp3',
        'sounds/correct-answer.mp3',
        'sounds/wrong-answer.mp3',
        'sounds/win_game.mp3',
      ];
      
      await Future.wait(soundFiles.map((file) => _preloadSound(file)));
      
      _isCacheInitialized = true;
      
      if (kDebugMode) {
        print('✅ Cache de audios inicializado en ${stopwatch.elapsedMilliseconds}ms');
        print('📊 Sonidos cacheados: ${_soundCache.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error inicializando caché de audios: $e');
      }
    }
  }

  Future<void> _preloadSound(String source) async {
    if (_soundCache.containsKey(source)) return;
    
    try {
      final player = AudioPlayer()..setPlayerMode(PlayerMode.lowLatency);
      await player.setSource(AssetSource(source));
      await player.setVolume(1.0);
      
      _soundCache[source] = player;
      
      if (kDebugMode) {
        print('✅ Sonido precargado: $source');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error precargando $source: $e');
      }
    }
  }

  // 🔥 MÉTODO CORREGIDO - Versión simplificada que funciona
  Future<void> _playShortSound(String source) async {
    if (_isDisposed) return;

    try {
      // Crear un player NUEVO cada vez (más confiable)
      final player = AudioPlayer()..setPlayerMode(PlayerMode.lowLatency);
      
      await player.setSource(AssetSource(source));
      await player.setVolume(1.0);
      
      // Reproducir
      await player.resume();
      
      if (kDebugMode) {
        print('🔊 Reproduciendo: $source');
      }
      
      // Auto-limpiar después de reproducir
      Future.delayed(const Duration(seconds: 2), () {
        if (player.state == PlayerState.playing) {
          player.stop();
        }
        player.dispose();
      });
      
    } catch (e) {
      if (!_isDisposed && kDebugMode) {
        print('Error reproduciendo $source: $e');
      }
    }
    
    _ensureBackgroundMusic();
  }

  // 🔥 VERSIÓN ALTERNATIVA - Usando AudioCache para mayor confiabilidad
  /*
  Future<void> _playShortSound(String source) async {
    if (_isDisposed) return;
    
    try {
      final player = AudioPlayer();
      final result = await player.play(AssetSource(source));
      
      if (kDebugMode) {
        print('🔊 Reproduciendo: $source');
      }
      
      // Auto-limpiar después de reproducir
      Future.delayed(const Duration(seconds: 2), () {
        player.dispose();
      });
      
    } catch (e) {
      if (!_isDisposed && kDebugMode) {
        print('Error reproduciendo $source: $e');
      }
    }
    
    _ensureBackgroundMusic();
  }
  */

  // --- Música de Fondo ---
  Future<void> playBackgroundMusic() async {
    if (_isDisposed) return;

    try {
      if (!_isBackgroundPlaying) {
        await _backgroundPlayer.setSource(AssetSource('sounds/bg_music.mp3'));
        await _backgroundPlayer.resume();
        _isBackgroundPlaying = true;
        
        if (kDebugMode) {
          print('🎵 Música de fondo iniciada');
        }
      }
    } catch (e) {
      if (!_isDisposed) {
        if (kDebugMode) {
          print('Error playing background music: $e');
        }
        _isBackgroundPlaying = false;
      }
    }
  }

  Future<void> pauseBackgroundMusic() async {
    if (_isDisposed || !_isBackgroundPlaying) return;
    try {
      await _backgroundPlayer.pause();
      _isBackgroundPlaying = false;
      
      if (kDebugMode) {
        print('🎵 Música de fondo pausada');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error pausing background music: $e');
      }
    }
  }

  Future<void> stopBackgroundMusic() async {
    if (_isDisposed) return;
    try {
      await _backgroundPlayer.stop();
      _isBackgroundPlaying = false;
      
      if (kDebugMode) {
        print('🎵 Música de fondo detenida');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping background music: $e');
      }
      _isBackgroundPlaying = false;
    }
  }

  Future<void> _ensureBackgroundMusic() async {
    if (_isBackgroundPlaying && !_isDisposed) {
      final state = _backgroundPlayer.state;
      if (state == PlayerState.stopped || state == PlayerState.completed) {
        if (kDebugMode) {
          print('Restaurando música de fondo...');
        }
        await playBackgroundMusic();
      }
    }
  }

  bool get isBackgroundMusicPlaying => _isBackgroundPlaying;

  Future<void> restoreBackgroundMusic() async {
    if (_isDisposed) return;

    if (!_isBackgroundPlaying) {
      if (kDebugMode) {
        print('Restaurando música de fondo manualmente...');
      }
      await playBackgroundMusic();
    } else {
      final state = _backgroundPlayer.state;
      if (state != PlayerState.playing) {
        if (kDebugMode) {
          print('Música marcada como playing pero no lo está. Restaurando...');
        }
        _isBackgroundPlaying = false;
        await playBackgroundMusic();
      }
    }
  }

  // --- Efectos de Sonido (SFX) ---
  Future<void> playCardTapSound() => _playShortSound('sounds/card_tap.mp3');
  Future<void> playMatchSound() => _playShortSound('sounds/match_success.mp3');
  Future<void> playNoMatchSound() => _playShortSound('sounds/match_fail.mp3');
  Future<void> playFailedAttempts() => _playShortSound('sounds/failed-attempts.mp3');
  Future<void> playCorrectAnswer() => _playShortSound('sounds/correct-answer.mp3');
  Future<void> playWrongAnswer() => _playShortSound('sounds/wrong-answer.mp3');
  Future<void> playWinSound() => _playShortSound('sounds/win_game.mp3');
  Future<void> playSuccessSound() => _playShortSound('sounds/win_game.mp3');

  Future<void> playTimeUpSound() async {
    if (_isDisposed) return;

    try {
      await _sfxPlayer.setSource(AssetSource('sounds/time_up.mp3'));
      await _sfxPlayer.resume();
      
      if (kDebugMode) {
        print('🔊 Time up sound');
      }

      _sfxPlayer.onPlayerComplete.listen((_) async {
        await _ensureBackgroundMusic();
      });
    } catch (e) {
      if (!_isDisposed) {
        if (kDebugMode) {
          print('Error playing time up sound: $e');
        }
        await _ensureBackgroundMusic();
      }
    }
  }

  Future<void> stopTimeUpSound() async {
    if (_isDisposed) return;
    try {
      await _sfxPlayer.stop();
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping time up sound: $e');
      }
    }
  }

  Future<void> playCounterClock() async {
    if (_isDisposed) return;

    try {
      await _sfxPlayer.setSource(AssetSource('sounds/counter-clock.mp3'));
      await _sfxPlayer.resume();
      
      if (kDebugMode) {
        print('🔊 Counter clock');
      }
    } catch (e) {
      if (!_isDisposed) {
        if (kDebugMode) {
          print('Error playing counter clock: $e');
        }
      }
    }
  }

  Future<void> stopCounterClock() async {
    if (_isDisposed) return;
    try {
      await _sfxPlayer.stop();
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping counter clock: $e');
      }
    }
  }

  Future<void> stopSuccessSound() async {
    await _sfxPlayer.stop();
  }

  // Liberar recursos
  void dispose() {
    _isDisposed = true;
    _isBackgroundPlaying = false;

    _backgroundPlayer.dispose();
    _sfxPlayer.dispose();

    for (var player in _soundCache.values) {
      player.dispose();
    }
    _soundCache.clear();
    
    if (kDebugMode) {
      print('🔇 AudioService disposed');
    }
  }
}