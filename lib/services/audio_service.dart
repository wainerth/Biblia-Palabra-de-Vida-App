import 'package:audioplayers/audioplayers.dart';

class AudioService {
  late AudioPlayer _backgroundPlayer;
  late AudioPlayer _sfxPlayer; // Para efectos de sonido cortos y múltiples

  AudioService() {
    _backgroundPlayer = AudioPlayer();
    _sfxPlayer = AudioPlayer(); // Puedes tener múltiples para superposición

    // Configura el modo de audio para el fondo si es necesario
    _backgroundPlayer.setReleaseMode(ReleaseMode.loop); // Para que se repita
    _backgroundPlayer.setVolume(0.3); // Volumen bajo para la música de fondo
  }

  // --- Música de Fondo ---
  Future<void> playBackgroundMusic() async {
    await _backgroundPlayer.play(AssetSource('sounds/bg_music.mp3'));
  }

  Future<void> pauseBackgroundMusic() async {
    await _backgroundPlayer.pause();
  }

  Future<void> stopBackgroundMusic() async {
    await _backgroundPlayer.stop();
  }

  // --- Efectos de Sonido (SFX) ---
  Future<void> playCardTapSound() async {
    // Usar play(AssetSource) directamente para sonidos cortos
    await AudioPlayer()
        .play(AssetSource('sounds/card_tap.mp3'), mode: PlayerMode.lowLatency);
  }

  Future<void> playMatchSound() async {
    await AudioPlayer().play(AssetSource('sounds/match_success.mp3'),
        mode: PlayerMode.lowLatency);
  }

  Future<void> playNoMatchSound() async {
    await AudioPlayer().play(AssetSource('sounds/match_fail.mp3'),
        mode: PlayerMode.lowLatency);
  }

  Future<void> playTimeUpSound() async {
    await _sfxPlayer.play(AssetSource('sounds/time_up.mp3'),
        mode: PlayerMode.lowLatency);
  }

  Future<void> stopTimeUpSound() async {
    await _sfxPlayer.stop();
  }

  Future<void> playCounterClock() async {
    await _sfxPlayer.play(AssetSource('sounds/counter-clock.mp3'),
        mode: PlayerMode.lowLatency);
  }

  Future<void> playFailedAttempts() async {
    await AudioPlayer().play(AssetSource('sounds/failed-attempts.mp3'),
        mode: PlayerMode.lowLatency);
  }

  Future<void> stopCounterClock() async {
    await _sfxPlayer.stop();
  }

  Future<void> playCorrectAnswer() async {
    await AudioPlayer().play(AssetSource('sounds/correct-answer.mp3'),
        mode: PlayerMode.lowLatency);
  }

  Future<void> playWrongAnswer() async {
    await AudioPlayer().play(AssetSource('sounds/wrong-answer.mp3'),
        mode: PlayerMode.lowLatency);
  }

  Future<void> playWinSound() async {
    await _sfxPlayer.play(AssetSource('sounds/win_game.mp3'),
        mode: PlayerMode.lowLatency);
  }

  Future<void> playBackgroundMusicMap() async {
    await _backgroundPlayer.play(AssetSource('mar-aves.mp3'));
  }

  Future<void> stopBackgroundMusicMap() async {
    await _backgroundPlayer.stop();
  }

  Future<void> playSuccessSound() async {
    await AudioPlayer().play(AssetSource('sounds/win_game.mp3'),
        mode: PlayerMode.lowLatency);
  }

  Future<void> stopSuccessSound() async {
    await _sfxPlayer.stop();
  }

  // Liberar recursos
  void dispose() {
    _backgroundPlayer.dispose();
    _sfxPlayer.dispose();
  }
}
