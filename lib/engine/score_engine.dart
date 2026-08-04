// lib/engine/score_engine.dart
/// ScoreEngine - Scoring system, level calculation, line clear rewards

import 'types.dart';
import 'constants.dart';

class ScoreEngine {
  const ScoreEngine();

  /// Calculate score for line clear
  int calculateLineClearScore(LineClearType type, int level, int combo) {
    int baseScore = 0;
    
    switch (type) {
      case LineClearType.single:
        baseScore = GameConstants.singleLineScore;
        break;
      case LineClearType.double:
        baseScore = GameConstants.doubleLineScore;
        break;
      case LineClearType.triple:
        baseScore = GameConstants.tripleLineScore;
        break;
      case LineClearType.tetris:
        baseScore = GameConstants.tetrisLineScore;
        break;
    }

    // Level multiplier
    final levelMultiplier = level;
    
    // Combo bonus
    final comboBonus = combo > 0 
        ? (GameConstants.comboBonusBase + (combo - 1) * GameConstants.comboBonusIncrement) * level
        : 0;

    return (baseScore + comboBonus) * levelMultiplier;
  }

  /// Calculate score for soft drop
  int calculateSoftDropScore(int cellsDropped) {
    return cellsDropped * GameConstants.softDropScore;
  }

  /// Calculate score for hard drop
  int calculateHardDropScore(int cellsDropped) {
    return cellsDropped * GameConstants.hardDropScore;
  }

  /// Calculate score for T-spin
  int calculateTSpinScore(LineClearType type, int level) {
    int baseScore = 0;
    
    switch (type) {
      case LineClearType.single:
        baseScore = 400;
        break;
      case LineClearType.double:
        baseScore = 1200;
        break;
      case LineClearType.triple:
        baseScore = 1600;
        break;
      case LineClearType.tetris:
        baseScore = 2000; // T-spin tetris (rare)
        break;
    }

    return baseScore * level;
  }

  /// Calculate score for mini T-spin
  int calculateMiniTSpinScore(int level) {
    return 100 * level;
  }

  /// Calculate level from total lines cleared
  int calculateLevel(int totalLinesCleared) {
    return (totalLinesCleared ~/ GameConstants.linesPerLevel) + 1;
  }

  /// Get lines needed for next level
  int linesForNextLevel(int totalLinesCleared) {
    final currentLevel = calculateLevel(totalLinesCleared);
    return currentLevel * GameConstants.linesPerLevel - totalLinesCleared;
  }

  /// Get tick rate for level and difficulty
  Duration getTickRate(int level, Difficulty difficulty) {
    final baseRate = GameConstants.baseTickRateMs;
    final levelFactor = (level - 1) * GameConstants.levelSpeedupMs;
    final difficultyOffset = GameConstants.difficultyTickOffset[difficulty] ?? 0;
    
    final rate = (baseRate - levelFactor + difficultyOffset)
        .clamp(GameConstants.minTickRateMs, GameConstants.baseTickRateMs);
    
    return Duration(milliseconds: rate);
  }

  /// Get gravity (cells per second) for level
  double getGravity(int level) {
    final tickRate = getTickRate(level, Difficulty.normal);
    return 1000.0 / tickRate.inMilliseconds;
  }

  /// Calculate total score from components
  int calculateTotalScore({
    required int lineClearScore,
    required int softDropScore,
    required int hardDropScore,
    required int tSpinScore,
    required int miniTSpinScore,
  }) {
    return lineClearScore + softDropScore + hardDropScore + tSpinScore + miniTSpinScore;
  }

  /// Get score breakdown for display
  ScoreBreakdown getBreakdown({
    required int linesCleared,
    required int level,
    required int combo,
    required bool isTSpin,
    required bool isMiniTSpin,
  }) {
    LineClearType type = LineClearType.fromCount(linesCleared);
    int lineScore = calculateLineClearScore(type, level, combo);
    int tSpinScore = isTSpin ? calculateTSpinScore(type, level) : 0;
    int miniTSpinScore = isMiniTSpin ? calculateMiniTSpinScore(level) : 0;
    
    return ScoreBreakdown(
      lineClearType: type,
      lineClearScore: lineScore,
      combo: combo,
      comboBonus: combo > 0 
          ? (GameConstants.comboBonusBase + (combo - 1) * GameConstants.comboBonusIncrement) * level
          : 0,
      tSpinScore: tSpinScore,
      miniTSpinScore: miniTSpinScore,
      total: lineScore + tSpinScore + miniTSpinScore,
    );
  }
}

/// Score breakdown for UI display
class ScoreBreakdown {
  final LineClearType lineClearType;
  final int lineClearScore;
  final int combo;
  final int comboBonus;
  final int tSpinScore;
  final int miniTSpinScore;
  final int total;

  const ScoreBreakdown({
    required this.lineClearType,
    required this.lineClearScore,
    required this.combo,
    required this.comboBonus,
    required this.tSpinScore,
    required this.miniTSpinScore,
    required this.total,
  });

  bool get hasCombo => combo > 0;
  bool get hasTSpin => tSpinScore > 0;
  bool get hasMiniTSpin => miniTSpinScore > 0;

  Map<String, dynamic> toJson() => {
        'lineClearType': lineClearType.name,
        'lineClearScore': lineClearScore,
        'combo': combo,
        'comboBonus': comboBonus,
        'tSpinScore': tSpinScore,
        'miniTSpinScore': miniTSpinScore,
        'total': total,
      };
}