import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../engine/engine.dart';
import '../storage/storage_service.dart';
import '../audio/audio_service.dart';

part 'app_providers.g.dart';

@riverpod
GameLoop gameLoop(Ref ref) {
  return GameLoop();
}

@riverpod
GameEngine gameEngine(Ref ref) {
  return GameEngine();
}

@riverpod
AudioService audioService(Ref ref) {
  return AudioService();
}

@riverpod
StorageService storageService(Ref ref) {
  return StorageService();
}

@riverpod
Future<Settings> settings(Ref ref) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.getSettings();
}

@riverpod
Future<Statistics> statistics(Ref ref) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.getStatistics();
}

@riverpod
class GameStateNotifier extends _$GameStateNotifier {
  @override
  GameState build() {
    return GameState.initial();
  }

  void updateState(GameState state) {
    this.state = state;
  }

  void reset() {
    state = GameState.initial(
      difficulty: state.difficulty,
      highScore: state.highScore,
    );
  }
}

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<Settings> build() async {
    final storage = ref.watch(storageServiceProvider);
    return storage.getSettings();
  }

  Future<void> updateSettings(Settings settings) async {
    state = AsyncValue.data(settings);
    final storage = ref.watch(storageServiceProvider);
    await storage.saveSettings(settings);
    ref.read(audioServiceProvider).updateSettings(settings);
  }

  Future<void> toggleSound() async {
    final current = state.value ?? Settings.defaultSettings();
    await updateSettings(current.copyWith(soundEnabled: !current.soundEnabled));
  }

  Future<void> toggleMusic() async {
    final current = state.value ?? Settings.defaultSettings();
    await updateSettings(current.copyWith(musicEnabled: !current.musicEnabled));
  }

  Future<void> setSoundVolume(double volume) async {
    final current = state.value ?? Settings.defaultSettings();
    await updateSettings(current.copyWith(soundVolume: volume.clamp(0.0, 1.0)));
  }

  Future<void> setMusicVolume(double volume) async {
    final current = state.value ?? Settings.defaultSettings();
    await updateSettings(current.copyWith(musicVolume: volume.clamp(0.0, 1.0)));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final current = state.value ?? Settings.defaultSettings();
    await updateSettings(current.copyWith(themeModeIndex: mode.index));
  }

  Future<void> setDifficulty(Difficulty difficulty) async {
    final current = state.value ?? Settings.defaultSettings();
    await updateSettings(current.copyWith(defaultDifficulty: difficulty));
  }
}

@riverpod
class StatisticsNotifier extends _$StatisticsNotifier {
  @override
  Future<Statistics> build() async {
    final storage = ref.watch(storageServiceProvider);
    return storage.getStatistics();
  }

  Future<void> addGame({
    required int score,
    required int linesCleared,
    required int levelReached,
    required Duration playTime,
    required Difficulty difficulty,
    required Map<BrickType, int> brickUsage,
  }) async {
    final current = state.value ?? Statistics.initial();
    final updated = current.addGame(
      score: score,
      linesCleared: linesCleared,
      levelReached: levelReached,
      playTime: playTime,
      difficulty: difficulty,
      brickUsage: brickUsage,
    );
    state = AsyncValue.data(updated);
    final storage = ref.watch(storageServiceProvider);
    await storage.saveStatistics(updated);
  }

  Future<void> reset() async {
    state = AsyncValue.data(Statistics.initial());
    final storage = ref.watch(storageServiceProvider);
    await storage.saveStatistics(Statistics.initial());
  }
}