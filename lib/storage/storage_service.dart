import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';
import '../core/constants/app_constants.dart';

class StorageService {
  static const String _settingsBox = 'settings';
  static const String _statisticsBox = 'statistics';
  static const String _gameStateBox = 'game_state';

  late Box<Settings> _settingsBoxInstance;
  late Box<Statistics> _statisticsBoxInstance;
  late Box<GameState> _gameStateBoxInstance;

  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    Hive.registerAdapter(SettingsAdapter());
    Hive.registerAdapter(StatisticsAdapter());
    Hive.registerAdapter(GameStateAdapter());
    Hive.registerAdapter(PositionAdapter());
    Hive.registerAdapter(BrickAdapter());
    Hive.registerAdapter(BrickTypeAdapter());
    Hive.registerAdapter(CoreGameStateAdapter());
    Hive.registerAdapter(DifficultyAdapter());

    _settingsBoxInstance = await Hive.openBox<Settings>(_settingsBox);
    _statisticsBoxInstance = await Hive.openBox<Statistics>(_statisticsBox);
    _gameStateBoxInstance = await Hive.openBox<GameState>(_gameStateBox);
  }

  // Settings
  Settings getSettings() {
    return _settingsBoxInstance.get('settings') ?? Settings.defaultSettings();
  }

  Future<void> saveSettings(Settings settings) async {
    await _settingsBoxInstance.put('settings', settings);
  }

  // Statistics
  Statistics getStatistics() {
    return _statisticsBoxInstance.get('statistics') ?? Statistics.initial();
  }

  Future<void> saveStatistics(Statistics statistics) async {
    await _statisticsBoxInstance.put('statistics', statistics);
  }

  // Game State
  GameState? getSavedGameState() {
    return _gameStateBoxInstance.get('game_state');
  }

  Future<void> saveGameState(GameState gameState) async {
    await _gameStateBoxInstance.put('game_state', gameState);
  }

  Future<void> clearGameState() async {
    await _gameStateBoxInstance.delete('game_state');
  }

  Future<void> close() async {
    await _settingsBoxInstance.close();
    await _statisticsBoxInstance.close();
    await _gameStateBoxInstance.close();
  }
}