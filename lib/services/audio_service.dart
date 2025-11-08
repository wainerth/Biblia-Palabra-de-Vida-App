import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  late AudioPlayer _backgroundPlayer;
  late AudioPlayer _sfxPlayer; // Para efectos de sonido largos
  final Map<String, AudioPlayer> _shortSoundPlayers = {};
  bool _isDisposed = false;
  bool _isBackgroundPlaying = false;

  AudioService() {
    _initialize();
  }
  Future<void> _initialize() async {
    _backgroundPlayer = AudioPlayer()
      ..setReleaseMode(ReleaseMode.loop)
      ..setVolume(0.3)
      ..setPlayerMode(
          PlayerMode.mediaPlayer); // 🔥 Modo media para música larga

    _sfxPlayer = AudioPlayer()
      ..setPlayerMode(PlayerMode.lowLatency); // 🔥 Modo baja latencia para SFX

    // 🔥 Configurar manejado de eventos para la música de fondo
    _backgroundPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.stopped) {
        _isBackgroundPlaying = false;
      } else if (state == PlayerState.playing) {
        _isBackgroundPlaying = true;
      }
    });

    _backgroundPlayer.onPlayerComplete.listen((event) {
      // 🔥 Asegurar que la música continúe en loop
      if (!_isDisposed && _isBackgroundPlaying) {
        _backgroundPlayer.resume();
      }
    });
  }

  // --- Música de Fondo ---
  Future<void> playBackgroundMusic() async {
    if (_isDisposed) return;

    try {
      if (!_isBackgroundPlaying) {
        await _backgroundPlayer.setSource(AssetSource('sounds/bg_music.mp3'));
        await _backgroundPlayer.resume();
        _isBackgroundPlaying = true;
      }
    } catch (e) {
      if (!_isDisposed) {
        if (kDebugMode) {
          print('Error playing background music: $e');
        }
        // 🔥 Reintentar en caso de error
        _isBackgroundPlaying = false;
      }
    }
  }

  Future<void> pauseBackgroundMusic() async {
    if (_isDisposed || !_isBackgroundPlaying) return;
    try {
      await _backgroundPlayer.pause();
      _isBackgroundPlaying = false;
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
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping background music: $e');
      }
      _isBackgroundPlaying = false;
    }
  }

  // 🔥 Verificar y restaurar música de fondo si se detuvo
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

  // --- Efectos de Sonido (SFX) ---
  Future<void> playCardTapSound() async {
    await _playShortSound('sounds/card_tap.mp3');
    await _ensureBackgroundMusic(); // 🔥 Verificar música después del sonido
  }

  Future<void> playMatchSound() async {
    await _playShortSound('sounds/match_success.mp3');
    await _ensureBackgroundMusic();
  }

  Future<void> playNoMatchSound() async {
    await _playShortSound('sounds/match_fail.mp3');
    await _ensureBackgroundMusic();
  }

  Future<void> playTimeUpSound() async {
    if (_isDisposed) return;

    try {
      // 🔥 Usar player separado para no interferir con música
      await _sfxPlayer.setSource(AssetSource('sounds/time_up.mp3'));
      await _sfxPlayer.resume();

      // Verificar música después de que termine el sonido
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

      // La música sigue sonando mientras el contador corre
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

  Future<void> playFailedAttempts() async {
    await _playShortSound('sounds/failed-attempts.mp3');
    await _ensureBackgroundMusic();
  }

  Future<void> playCorrectAnswer() async {
    await _playShortSound('sounds/correct-answer.mp3');
    await _ensureBackgroundMusic();
  }

  Future<void> playWrongAnswer() async {
    await _playShortSound('sounds/wrong-answer.mp3');
    await _ensureBackgroundMusic();
  }

  Future<void> playWinSound() async {
    await _playShortSound('sounds/win_game.mp3');
    await _ensureBackgroundMusic();
  }

  Future<void> playSuccessSound() async {
    await _playShortSound('sounds/win_game.mp3');
    await _ensureBackgroundMusic();
  }

  // 🔥 Método optimizado para sonidos cortos
  Future<void> _playShortSound(String source) async {
    if (_isDisposed) return;

    final player = AudioPlayer()..setPlayerMode(PlayerMode.lowLatency);

    try {
      await player.setSource(AssetSource(source));
      await player.resume();

      // Limpieza automática sin afectar música
      player.onPlayerComplete.listen((_) {
        _safeDisposePlayer(player);
      });

      // Timeout de seguridad
      Future.delayed(const Duration(seconds: 3), () {
        _safeDisposePlayer(player);
      });
    } catch (e) {
      _safeDisposePlayer(player);
      if (!_isDisposed) {
        if (kDebugMode) {
          print('Error playing short sound $source: $e');
        }
      }
    }
  }

  void _safeDisposePlayer(AudioPlayer player) {
    player.dispose();
  }

  // 🔥 Método para verificar estado de la música
  bool get isBackgroundMusicPlaying => _isBackgroundPlaying;

  // 🔥 Método para restaurar música si se perdió
  Future<void> restoreBackgroundMusic() async {
    if (_isDisposed) return;

    if (!_isBackgroundPlaying) {
      if (kDebugMode) {
        print('Restaurando música de fondo manualmente...');
      }
      await playBackgroundMusic();
    } else {
      // Verificar que realmente esté sonando
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

  Future<void> stopSuccessSound() async {
    await _sfxPlayer.stop();
  }

  // Liberar recursos
  void dispose() {
    _isDisposed = true;
    _isBackgroundPlaying = false;

    _backgroundPlayer.dispose();
    _sfxPlayer.dispose();

    _shortSoundPlayers.forEach((key, player) {
      _safeDisposePlayer(player);
    });
    _shortSoundPlayers.clear();
  }
}
