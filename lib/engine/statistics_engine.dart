// lib/engine/statistics_engine.dart
/// StatisticsEngine - Tracks game statistics, piece usage, performance metrics

import 'types.dart';
import 'piece.dart';

class StatisticsEngine {
  int _gamesPlayed = 0;
  int _totalScore = 0;
  int _highScore = 0;
  int _totalLinesCleared = 0;
  int _maxLevelReached = 1;
  int _totalPlayTimeMs = 0;
  final Map<PieceType, int> _pieceCounts = {};
  final Map<Difficulty, int> _difficultyGamesPlayed = {};
  final Map<Difficulty, int> _difficultyHighScores = {};
  DateTime? _lastPlayed;
  
  // Session stats
  int _sessionGames = 0;
  int _sessionScore = 0;
  int _sessionLines = 0;
  int _sessionTimeMs = 0;
  final Map<PieceType, int> _sessionPieceCounts = {};

  StatisticsEngine();

  // Getters
  int get gamesPlayed => _gamesPlayed;
  int get totalScore => _totalScore;
  int get highScore => _highScore;
  int get totalLinesCleared => _totalLinesCleared;
  int get maxLevelReached => _maxLevelReached;
  Duration get totalPlayTime => Duration(milliseconds: _totalPlayTimeMs);
  Map<PieceType, int> get pieceCounts => Map.unmodifiable(_pieceCounts);
  Map<Difficulty, int> get difficultyGamesPlayed => Map.unmodifiable(_difficultyGamesPlayed);
  Map<Difficulty, int> get difficultyHighScores => Map.unmodifiable(_difficultyHighScores);
  DateTime? get lastPlayed => _lastPlayed;

  // Session getters
  int get sessionGames => _sessionGames;
  int get sessionScore => _sessionScore;
  int get sessionLines => _sessionLines;
  Duration get sessionTime => Duration(milliseconds: _sessionTimeMs);
  Map<PieceType, int> get sessionPieceCounts => Map.unmodifiable(_sessionPieceCounts);

  double get averageScore => _gamesPlayed > 0 ? _totalScore / _gamesPlayed : 0;
  double get averageLinesPerGame => _gamesPlayed > 0 ? _totalLinesCleared / _gamesPlayed : 0;
  double get sessionAverageScore => _sessionGames > 0 ? _sessionScore / _sessionGames : 0;
  double get sessionAverageLines => _sessionGames > 0 ? _sessionLines / _sessionGames : 0;

  /// Record a completed game
  void recordGame({
    required int score,
    required int linesCleared,
    required int levelReached,
    required Duration playTime,
    required Difficulty difficulty,
    required Map<PieceType, int> pieceUsage,
  }) {
    _gamesPlayed++;
    _totalScore += score;
    _highScore = score > _highScore ? score : _highScore;
    _totalLinesCleared += linesCleared;
    _maxLevelReached = levelReached > _maxLevelReached ? levelReached : _maxLevelReached;
    _totalPlayTimeMs += playTime.inMilliseconds;
    _lastPlayed = DateTime.now();

    // Update piece counts
    for (final entry in pieceUsage.entries) {
      _pieceCounts[entry.key] = (_pieceCounts[entry.key] ?? 0) + entry.value;
    }

    // Update difficulty stats
    _difficultyGamesPlayed[difficulty] = (_difficultyGamesPlayed[difficulty] ?? 0) + 1;
    final currentHigh = _difficultyHighScores[difficulty] ?? 0;
    if (score > currentHigh) {
      _difficultyHighScores[difficulty] = score;
    }

    // Update session
    _sessionGames++;
    _sessionScore += score;
    _sessionLines += linesCleared;
    _sessionTimeMs += playTime.inMilliseconds;
    for (final entry in pieceUsage.entries) {
      _sessionPieceCounts[entry.key] = (_sessionPieceCounts[entry.key] ?? 0) + entry.value;
    }
  }

  /// Record piece spawn
  void recordPieceSpawn(PieceType type) {
    _pieceCounts[type] = (_pieceCounts[type] ?? 0) + 1;
    _sessionPieceCounts[type] = (_sessionPieceCounts[type] ?? 0) + 1;
  }

  /// Reset session stats
  void resetSession() {
    _sessionGames = 0;
    _sessionScore = 0;
    _sessionLines = 0;
    _sessionTimeMs = 0;
    _sessionPieceCounts.clear();
  }

  /// Reset all stats
  void resetAll() {
    _gamesPlayed = 0;
    _totalScore = 0;
    _highScore = 0;
    _totalLinesCleared = 0;
    _maxLevelReached = 1;
    _totalPlayTimeMs = 0;
    _pieceCounts.clear();
    _difficultyGamesPlayed.clear();
    _difficultyHighScores.clear();
    _lastPlayed = null;
    resetSession();
  }

  /// Get most used piece
  PieceType? get mostUsedPiece {
    if (_pieceCounts.isEmpty) return null;
    return _pieceCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Get least used piece
  PieceType? get leastUsedPiece {
    if (_pieceCounts.isEmpty) return null;
    return _pieceCounts.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;
  }

  /// Get piece distribution percentages
  Map<PieceType, double> getPieceDistribution() {
    final total = _pieceCounts.values.fold(0, (a, b) => a + b);
    if (total == 0) return {};
    return _pieceCounts.map((k, v) => MapEntry(k, v / total * 100));
  }

  /// Get session piece distribution
  Map<PieceType, double> getSessionPieceDistribution() {
    final total = _sessionPieceCounts.values.fold(0, (a, b) => a + b);
    if (total == 0) return {};
    return _sessionPieceCounts.map((k, v) => MapEntry(k, v / total * 100));
  }

  /// Get best difficulty
  Difficulty? get bestDifficulty {
    if (_difficultyHighScores.isEmpty) return null;
    return _difficultyHighScores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Serialize
  Map<String, dynamic> toJson() => {
        'gamesPlayed': _gamesPlayed,
        'totalScore': _totalScore,
        'highScore': _highScore,
        'totalLinesCleared': _totalLinesCleared,
        'maxLevelReached': _maxLevelReached,
        'totalPlayTimeMs': _totalPlayTimeMs,
        'pieceCounts': _pieceCounts.map((k, v) => MapEntry(k.name, v)),
        'difficultyGamesPlayed': _difficultyGamesPlayed.map((k, v) => MapEntry(k.name, v)),
        'difficultyHighScores': _difficultyHighScores.map((k, v) => MapEntry(k.name, v)),
        'lastPlayed': _lastPlayed?.toIso8601String(),
      };

  /// Deserialize
  factory StatisticsEngine.fromJson(Map<String, dynamic> json) {
    final engine = StatisticsEngine();
    engine._gamesPlayed = json['gamesPlayed'] as int? ?? 0;
    engine._totalScore = json['totalScore'] as int? ?? 0;
    engine._highScore = json['highScore'] as int? ?? 0;
    engine._totalLinesCleared = json['totalLinesCleared'] as int? ?? 0;
    engine._maxLevelReached = json['maxLevelReached'] as int? ?? 1;
    engine._totalPlayTimeMs = json['totalPlayTimeMs'] as int? ?? 0;
    engine._pieceCounts.addAll(
      (json['pieceCounts'] as Map? ?? {}).map((k, v) => 
        MapEntry(PieceType.values.firstWhere((e) => e.name == k), v as int),
      ),
    );
    engine._difficultyGamesPlayed.addAll(
      (json['difficultyGamesPlayed'] as Map? ?? {}).map((k, v) => 
        MapEntry(Difficulty.values.firstWhere((e) => e.name == k), v as int),
      ),
    );
    engine._difficultyHighScores.addAll(
      (json['difficultyHighScores'] as Map? ?? {}).map((k, v) => 
        MapEntry(Difficulty.values.firstWhere((e) => e.name == k), v as int),
      ),
    );
    engine._lastPlayed = json['lastPlayed'] != null
        ? DateTime.parse(json['lastPlayed'] as String)
        : null;
    return engine;
  }
}