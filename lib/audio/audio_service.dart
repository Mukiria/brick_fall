import 'package:audioplayers/audioplayers.dart';
import '../models/settings.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final Map<String, AudioPlayer> _sfxPlayers = {};

  Settings _settings = Settings.defaultSettings();
  bool _initialized = false;

  Future<void> init(Settings settings) async {
    _settings = settings;
    _musicPlayer.setReleaseMode(ReleaseMode.loop);
    _sfxPlayer.setReleaseMode(ReleaseMode.release);
    
    await _musicPlayer.setVolume(_settings.musicEnabled ? _settings.musicVolume : 0.0);
    await _sfxPlayer.setVolume(_settings.soundEnabled ? _settings.soundVolume : 0.0);
    
    _initialized = true;
  }

  void updateSettings(Settings settings) {
    _settings = settings;
    _musicPlayer.setVolume(_settings.musicEnabled ? _settings.musicVolume : 0.0);
    _sfxPlayer.setVolume(_settings.soundEnabled ? _settings.soundVolume : 0.0);
  }

  Future<void> playMusic(String asset) async {
    if (!_initialized || !_settings.musicEnabled) return;
    try {
      await _musicPlayer.play(AssetSource(asset));
    } catch (e) {
      // Ignore audio errors
    }
  }

  Future<void> stopMusic() async {
    await _musicPlayer.stop();
  }

  Future<void> pauseMusic() async {
    await _musicPlayer.pause();
  }

  Future<void> resumeMusic() async {
    if (_settings.musicEnabled) {
      await _musicPlayer.resume();
    }
  }

  Future<void> playSfx(String asset) async {
    if (!_initialized || !_settings.soundEnabled) return;
    try {
      final player = AudioPlayer();
      player.setReleaseMode(ReleaseMode.release);
      player.setVolume(_settings.soundVolume);
      await player.play(AssetSource(asset));
      _sfxPlayers[asset] = player;
      
      // Clean up after playing
      player.onPlayerComplete.listen((_) {
        player.dispose();
        _sfxPlayers.remove(asset);
      });
    } catch (e) {
      // Ignore audio errors
    }
  }

  Future<void> playMove() async {
    await playSfx('audio/move.mp3');
  }

  Future<void> playRotate() async {
    await playSfx('audio/rotate.mp3');
  }

  Future<void> playDrop() async {
    await playSfx('audio/drop.mp3');
  }

  Future<void> playLineClear() async {
    await playSfx('audio/line_clear.mp3');
  }

  Future<void> playLevelUp() async {
    await playSfx('audio/level_up.mp3');
  }

  Future<void> playGameOver() async {
    await playSfx('audio/game_over.mp3');
  }

  Future<void> playTap() async {
    await playSfx('audio/tap.mp3');
  }

  void dispose() {
    _musicPlayer.dispose();
    _sfxPlayer.dispose();
    for (final player in _sfxPlayers.values) {
      player.dispose();
    }
    _sfxPlayers.clear();
  }
}