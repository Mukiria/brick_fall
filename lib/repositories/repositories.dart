import '../models/models.dart';
import '../storage/storage_service.dart';

abstract class SettingsRepository {
  Future<Settings> getSettings();
  Future<void> saveSettings(Settings settings);
}

class SettingsRepositoryImpl implements SettingsRepository {
  final StorageService _storage;

  SettingsRepositoryImpl(this._storage);

  @override
  Future<Settings> getSettings() async {
    return _storage.getSettings();
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    await _storage.saveSettings(settings);
  }
}

abstract class StatisticsRepository {
  Future<Statistics> getStatistics();
  Future<void> saveStatistics(Statistics statistics);
  Future<void> resetStatistics();
}

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StorageService _storage;

  StatisticsRepositoryImpl(this._storage);

  @override
  Future<Statistics> getStatistics() async {
    return _storage.getStatistics();
  }

  @override
  Future<void> saveStatistics(Statistics statistics) async {
    await _storage.saveStatistics(statistics);
  }

  @override
  Future<void> resetStatistics() async {
    await _storage.saveStatistics(Statistics.initial());
  }
}

abstract class GameStateRepository {
  Future<GameState?> getSavedGameState();
  Future<void> saveGameState(GameState gameState);
  Future<void> clearGameState();
}

class GameStateRepositoryImpl implements GameStateRepository {
  final StorageService _storage;

  GameStateRepositoryImpl(this._storage);

  @override
  Future<GameState?> getSavedGameState() async {
    return _storage.getSavedGameState();
  }

  @override
  Future<void> saveGameState(GameState gameState) async {
    await _storage.saveGameState(gameState);
  }

  @override
  Future<void> clearGameState() async {
    await _storage.clearGameState();
  }
}