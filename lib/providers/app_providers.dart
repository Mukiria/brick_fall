import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import '../models/models.dart' as models;
import '../engine/engine.dart' as engine;
import '../storage/storage_service.dart';
import '../audio/audio_service.dart';

part 'app_providers.g.dart';

@riverpod
engine.GameLoop gameLoop(Ref ref) {
  return engine.GameLoop();
}

@riverpod
engine.GameEngine gameEngine(Ref ref) {
  return engine.GameEngine();
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
Future<models.Settings> settings(Ref ref) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.getSettings();
}

@riverpod
Future<models.Statistics> statistics(Ref ref) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.getStatistics();
}

@riverpod
class GameStateNotifier extends _$GameStateNotifier {
  @override
  engine.GameState build() {
    return engine.GameState.initial();
  }

  void updateState(engine.GameState state) {
    this.state = state;
  }

  void reset() {
    state = engine.GameState.initial(
      difficulty: state.difficulty,
      highScore: state.highScore,
    );
  }
}

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<models.Settings> build() async {
    final storage = ref.watch(storageServiceProvider);
    return storage.getSettings();
  }

  Future<void> updateSettings(models.Settings settings) async {
    state = AsyncValue.data(settings);
    final storage = ref.watch(storageServiceProvider);
    await storage.saveSettings(settings);
    ref.read(audioServiceProvider).updateSettings(settings);
  }

  Future<void> toggleSound() async {
    final current = state.value ?? models.Settings.defaultSettings();
    await updateSettings(current.copyWith(soundEnabled: !current.soundEnabled));
  }

  Future<void> toggleMusic() async {
    final current = state.value ?? models.Settings.defaultSettings();
    await updateSettings(current.copyWith(musicEnabled: !current.musicEnabled));
  }

  Future<void> setSoundVolume(double volume) async {
    final current = state.value ?? models.Settings.defaultSettings();
    await updateSettings(current.copyWith(soundVolume: volume.clamp(0.0, 1.0)));
  }

  Future<void> setMusicVolume(double volume) async {
    final current = state.value ?? models.Settings.defaultSettings();
    await updateSettings(current.copyWith(musicVolume: volume.clamp(0.0, 1.0)));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final current = state.value ?? models.Settings.defaultSettings();
    await updateSettings(current.copyWith(themeModeIndex: mode.index));
  }

  Future<void> setDifficulty(engine.Difficulty difficulty) async {
    final current = state.value ?? models.Settings.defaultSettings();
    final modelDifficulty = models.Difficulty.values.firstWhere((d) => d.name == difficulty.name);
    await updateSettings(current.copyWith(defaultDifficulty: modelDifficulty));
  }
}

@riverpod
class StatisticsNotifier extends _$StatisticsNotifier {
  @override
  Future<models.Statistics> build() async {
    final storage = ref.watch(storageServiceProvider);
    return storage.getStatistics();
  }

  Future<void> addGame({
    required int score,
    required int linesCleared,
    required int levelReached,
    required Duration playTime,
    required engine.Difficulty difficulty,
    required Map<engine.PieceType, int> brickUsage,
  }) async {
    final current = state.value ?? models.Statistics.initial();
    
    // Convert engine types to model types
    final modelDifficulty = models.Difficulty.values.firstWhere((d) => d.name == difficulty.name);
    final modelBrickUsage = brickUsage.map(
      (k, v) => MapEntry(models.BrickType.values.firstWhere((b) => b.name == k.name), v),
    );
    
    final updated = current.addGame(
      score: score,
      linesCleared: linesCleared,
      levelReached: levelReached,
      playTime: playTime,
      difficulty: modelDifficulty,
      brickUsage: modelBrickUsage,
    );
    state = AsyncValue.data(updated);
    final storage = ref.watch(storageServiceProvider);
    await storage.saveStatistics(updated);
  }

  Future<void> reset() async {
    state = AsyncValue.data(models.Statistics.initial());
    final storage = ref.watch(storageServiceProvider);
    await storage.saveStatistics(models.Statistics.initial());
  }
}