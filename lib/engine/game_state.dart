// lib/engine/game_state.dart
/// GameState - Immutable game state for engine

import 'types.dart';
import 'board.dart';
import 'piece.dart';
import 'turn_manager.dart';
import 'combo_engine.dart';
import 'statistics_engine.dart';

class GameState {
  final GameStateStatus status;
  final Difficulty difficulty;
  final Board board;
  final TurnManager turnManager;
  final ComboEngine comboEngine;
  final StatisticsEngine statisticsEngine;
  
  final int score;
  final int highScore;
  final int level;
  final int linesCleared;
  final int totalLinesCleared;
  final Duration elapsedTime;
  final DateTime? startTime;
  final int pieceId;
  
  final List<GameActionRecord> actionHistory;
  final int rngSeed;

  const GameState({
    required this.status,
    required this.difficulty,
    required this.board,
    required this.turnManager,
    required this.comboEngine,
    required this.statisticsEngine,
    required this.score,
    required this.highScore,
    required this.level,
    required this.linesCleared,
    required this.totalLinesCleared,
    required this.elapsedTime,
    this.startTime,
    required this.pieceId,
    this.actionHistory = const [],
    this.rngSeed = 0,
  });

  /// Create initial game state
  factory GameState.initial({
    Difficulty difficulty = Difficulty.normal,
    int highScore = 0,
    int? rngSeed,
  }) {
    return GameState(
      status: GameStateStatus.idle,
      difficulty: difficulty,
      board: Board(),
      turnManager: TurnManager(seed: rngSeed),
      comboEngine: ComboEngine(),
      statisticsEngine: StatisticsEngine(),
      score: 0,
      highScore: highScore,
      level: 1,
      linesCleared: 0,
      totalLinesCleared: 0,
      elapsedTime: Duration.zero,
      startTime: null,
      pieceId: 0,
      rngSeed: rngSeed ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Create copy with updated fields
  GameState copyWith({
    GameStateStatus? status,
    Difficulty? difficulty,
    Board? board,
    TurnManager? turnManager,
    ComboEngine? comboEngine,
    StatisticsEngine? statisticsEngine,
    int? score,
    int? highScore,
    int? level,
    int? linesCleared,
    int? totalLinesCleared,
    Duration? elapsedTime,
    DateTime? startTime,
    int? pieceId,
    List<GameActionRecord>? actionHistory,
  }) {
    return GameState(
      status: status ?? this.status,
      difficulty: difficulty ?? this.difficulty,
      board: board ?? this.board,
      turnManager: turnManager ?? this.turnManager,
      comboEngine: comboEngine ?? this.comboEngine,
      statisticsEngine: statisticsEngine ?? this.statisticsEngine,
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
      level: level ?? this.level,
      linesCleared: linesCleared ?? this.linesCleared,
      totalLinesCleared: totalLinesCleared ?? this.totalLinesCleared,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      startTime: startTime ?? this.startTime,
      pieceId: pieceId ?? this.pieceId,
      actionHistory: actionHistory ?? this.actionHistory,
      rngSeed: this.rngSeed,
    );
  }

  /// Add action to history
  GameState addAction(GameAction action) {
    return copyWith(
      actionHistory: [
        ...actionHistory,
        GameActionRecord(
          action: action,
          timestampMs: elapsedTime.inMilliseconds,
          pieceId: pieceId,
        ),
      ],
    );
  }

  /// Get current piece
  Piece? get currentPiece => turnManager.currentPiece;

  /// Get next piece
  Piece? get nextPiece => turnManager.nextPiece;

  /// Get held piece
  Piece? get heldPiece => turnManager.heldPiece;

  /// Get ghost piece
  Piece? get ghostPiece => turnManager.getGhostPiece(board);

  /// Check if game is active
  bool get isActive => status == GameStateStatus.playing;

  /// Check if game is paused
  bool get isPaused => status == GameStateStatus.paused;

  /// Check if game is over
  bool get isGameOver => status == GameStateStatus.gameOver;

  /// Calculate score for line clear
  int calculateScore(int linesCleared) {
    if (linesCleared <= 0) return 0;
    
    int baseScore = 0;
    switch (linesCleared) {
      case 1: baseScore = 100; break;
      case 2: baseScore = 300; break;
      case 3: baseScore = 500; break;
      case 4: baseScore = 800; break;
    }
    
    final comboBonus = comboEngine.combo > 0 
        ? (50 + (comboEngine.combo - 1) * 25) * level 
        : 0;
    
    return (baseScore + comboBonus) * level;
  }

  /// Get lines needed for next level
  int get linesForNextLevel {
    return level * 10 - totalLinesCleared;
  }

  /// Get progress to next level (0.0 to 1.0)
  double get levelProgress {
    final linesInLevel = totalLinesCleared % 10;
    return linesInLevel / 10.0;
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() => {
        'status': status.name,
        'difficulty': difficulty.name,
        'board': {
          'grid': board.grid,
          'colorGrid': board.colorGrid,
        },
        'turnManager': turnManager.toJson(),
        'comboEngine': comboEngine.toJson(),
        'statisticsEngine': statisticsEngine.toJson(),
        'score': score,
        'highScore': highScore,
        'level': level,
        'linesCleared': linesCleared,
        'totalLinesCleared': totalLinesCleared,
        'elapsedTimeMs': elapsedTime.inMilliseconds,
        'startTime': startTime?.toIso8601String(),
        'pieceId': pieceId,
        'actionHistory': actionHistory.map((a) => a.toJson()).toList(),
        'rngSeed': rngSeed,
      };

  /// Deserialize from JSON
  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      status: GameStateStatus.values.firstWhere((e) => e.name == json['status']),
      difficulty: Difficulty.values.firstWhere((e) => e.name == json['difficulty']),
      board: Board.fromState(
        grid: List<List<bool>>.from((json['board']['grid'] as List).map(
          (row) => List<bool>.from(row as List),
        )),
        colorGrid: List<List<int>>.from((json['board']['colorGrid'] as List).map(
          (row) => List<int>.from(row as List),
        )),
      ),
      turnManager: TurnManager.fromJson(json['turnManager'] as Map<String, dynamic>),
      comboEngine: ComboEngine.fromJson(json['comboEngine'] as Map<String, dynamic>),
      statisticsEngine: StatisticsEngine.fromJson(json['statisticsEngine'] as Map<String, dynamic>),
      score: json['score'] as int,
      highScore: json['highScore'] as int,
      level: json['level'] as int,
      linesCleared: json['linesCleared'] as int,
      totalLinesCleared: json['totalLinesCleared'] as int,
      elapsedTime: Duration(milliseconds: json['elapsedTimeMs'] as int),
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime'] as String) : null,
      pieceId: json['pieceId'] as int,
      actionHistory: (json['actionHistory'] as List)
          .map((a) => GameActionRecord.fromJson(a as Map<String, dynamic>))
          .toList(),
      rngSeed: json['rngSeed'] as int,
    );
  }
}