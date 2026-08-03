import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'brick.dart';
import 'position.dart';
import '../core/constants/app_constants.dart';

part 'game_state.g.dart';

@HiveType(typeId: 2)
class GameState extends Equatable {
  @HiveField(0)
  final List<List<bool>> grid;

  @HiveField(1)
  final List<List<int>> gridColors;

  @HiveField(2)
  final Brick? currentBrick;

  @HiveField(3)
  final Brick? nextBrick;

  @HiveField(4)
  final Brick? heldBrick;

  @HiveField(5)
  final bool canHold;

  @HiveField(6)
  final int score;

  @HiveField(7)
  final int level;

  @HiveField(8)
  final int linesCleared;

  @HiveField(9)
  final int totalLinesCleared;

  @HiveField(10)
  final int combo;

  @HiveField(11)
  final CoreGameState state;

  @HiveField(12)
  final DateTime? startTime;

  @HiveField(13)
  final Duration elapsedTime;

  @HiveField(14)
  final Difficulty difficulty;

  @HiveField(15)
  final int highScore;

  const GameState({
    required this.grid,
    required this.gridColors,
    this.currentBrick,
    this.nextBrick,
    this.heldBrick,
    this.canHold = true,
    this.score = 0,
    this.level = 1,
    this.linesCleared = 0,
    this.totalLinesCleared = 0,
    this.combo = 0,
    this.state = CoreGameState.idle,
    this.startTime,
    this.elapsedTime = Duration.zero,
    this.difficulty = Difficulty.normal,
    this.highScore = 0,
  });

  factory GameState.initial({Difficulty difficulty = Difficulty.normal, int highScore = 0}) {
    return GameState(
      grid: List.generate(AppConstants.gameHeight, (_) => List.filled(AppConstants.gameWidth, false)),
      gridColors: List.generate(AppConstants.gameHeight, (_) => List.filled(AppConstants.gameWidth, 0)),
      difficulty: difficulty,
      highScore: highScore,
    );
  }

  GameState copyWith({
    List<List<bool>>? grid,
    List<List<int>>? gridColors,
    Brick? currentBrick,
    Brick? nextBrick,
    Brick? heldBrick,
    bool? canHold,
    int? score,
    int? level,
    int? linesCleared,
    int? totalLinesCleared,
    int? combo,
    CoreGameState? state,
    DateTime? startTime,
    Duration? elapsedTime,
    Difficulty? difficulty,
    int? highScore,
  }) {
    return GameState(
      grid: grid ?? this.grid,
      gridColors: gridColors ?? this.gridColors,
      currentBrick: currentBrick ?? this.currentBrick,
      nextBrick: nextBrick ?? this.nextBrick,
      heldBrick: heldBrick ?? this.heldBrick,
      canHold: canHold ?? this.canHold,
      score: score ?? this.score,
      level: level ?? this.level,
      linesCleared: linesCleared ?? this.linesCleared,
      totalLinesCleared: totalLinesCleared ?? this.totalLinesCleared,
      combo: combo ?? this.combo,
      state: state ?? this.state,
      startTime: startTime ?? this.startTime,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      difficulty: difficulty ?? this.difficulty,
      highScore: highScore ?? this.highScore,
    );
  }

  Duration getTickRate() {
    final baseRate = AppConstants.gameTickRate.inMilliseconds;
    final levelFactor = (level - 1) * 50;
    final difficultyFactor = switch (difficulty) {
      Difficulty.easy => 100,
      Difficulty.normal => 0,
      Difficulty.hard => -100,
      Difficulty.expert => -200,
    };
    final rate = (baseRate - levelFactor + difficultyFactor).clamp(50, 1000);
    return Duration(milliseconds: rate);
  }

  int calculateScore(int linesCleared) {
    if (linesCleared == 0) return 0;
    
    final basePoints = switch (linesCleared) {
      1 => 100,
      2 => 300,
      3 => 500,
      4 => 800,
      _ => 0,
    };
    
    final levelMultiplier = level;
    final comboBonus = combo * AppConstants.comboMultiplier;
    
    return (basePoints * levelMultiplier) + comboBonus;
  }

  @override
  List<Object?> get props => [
    grid,
    gridColors,
    currentBrick,
    nextBrick,
    heldBrick,
    canHold,
    score,
    level,
    linesCleared,
    totalLinesCleared,
    combo,
    state,
    startTime,
    elapsedTime,
    difficulty,
    highScore,
  ];
}