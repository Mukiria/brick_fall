import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';

part 'statistics.g.dart';

@HiveType(typeId: 3)
class Statistics extends Equatable {
  @HiveField(0)
  final int gamesPlayed;

  @HiveField(1)
  final int totalScore;

  @HiveField(2)
  final int highScore;

  @HiveField(3)
  final int totalLinesCleared;

  @HiveField(4)
  final int maxLevelReached;

  @HiveField(5)
  final Duration totalPlayTime;

  @HiveField(6)
  final Map<String, int> brickCounts;

  @HiveField(7)
  final Map<String, int> difficultyGamesPlayed;

  @HiveField(8)
  final Map<String, int> difficultyHighScores;

  @HiveField(9)
  final DateTime lastPlayed;

  const Statistics({
    this.gamesPlayed = 0,
    this.totalScore = 0,
    this.highScore = 0,
    this.totalLinesCleared = 0,
    this.maxLevelReached = 1,
    this.totalPlayTime = Duration.zero,
    this.brickCounts = const {},
    this.difficultyGamesPlayed = const {},
    this.difficultyHighScores = const {},
    required this.lastPlayed,
  });

  factory Statistics.initial() {
    return Statistics(lastPlayed: DateTime.now());
  }

  Statistics copyWith({
    int? gamesPlayed,
    int? totalScore,
    int? highScore,
    int? totalLinesCleared,
    int? maxLevelReached,
    Duration? totalPlayTime,
    Map<String, int>? brickCounts,
    Map<String, int>? difficultyGamesPlayed,
    Map<String, int>? difficultyHighScores,
    DateTime? lastPlayed,
  }) {
    return Statistics(
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      totalScore: totalScore ?? this.totalScore,
      highScore: highScore ?? this.highScore,
      totalLinesCleared: totalLinesCleared ?? this.totalLinesCleared,
      maxLevelReached: maxLevelReached ?? this.maxLevelReached,
      totalPlayTime: totalPlayTime ?? this.totalPlayTime,
      brickCounts: brickCounts ?? this.brickCounts,
      difficultyGamesPlayed: difficultyGamesPlayed ?? this.difficultyGamesPlayed,
      difficultyHighScores: difficultyHighScores ?? this.difficultyHighScores,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }

  Statistics addGame({
    required int score,
    required int linesCleared,
    required int levelReached,
    required Duration playTime,
    required Difficulty difficulty,
    required Map<BrickType, int> brickUsage,
  }) {
    final newBrickCounts = Map<String, int>.from(brickCounts);
    brickUsage.forEach((type, count) {
      newBrickCounts[type.name] = (newBrickCounts[type.name] ?? 0) + count;
    });

    final newDifficultyGames = Map<String, int>.from(difficultyGamesPlayed);
    newDifficultyGames[difficulty.name] = (newDifficultyGames[difficulty.name] ?? 0) + 1;

    final newDifficultyHighScores = Map<String, int>.from(difficultyHighScores);
    final currentHigh = newDifficultyHighScores[difficulty.name] ?? 0;
    if (score > currentHigh) {
      newDifficultyHighScores[difficulty.name] = score;
    }

    return copyWith(
      gamesPlayed: gamesPlayed + 1,
      totalScore: totalScore + score,
      highScore: score > highScore ? score : highScore,
      totalLinesCleared: totalLinesCleared + linesCleared,
      maxLevelReached: levelReached > maxLevelReached ? levelReached : maxLevelReached,
      totalPlayTime: totalPlayTime + playTime,
      brickCounts: newBrickCounts,
      difficultyGamesPlayed: newDifficultyGames,
      difficultyHighScores: newDifficultyHighScores,
      lastPlayed: DateTime.now(),
    );
  }

  double get averageScore => gamesPlayed > 0 ? totalScore / gamesPlayed : 0;
  double get averageLinesPerGame => gamesPlayed > 0 ? totalLinesCleared / gamesPlayed : 0;

  @override
  List<Object?> get props => [
    gamesPlayed,
    totalScore,
    highScore,
    totalLinesCleared,
    maxLevelReached,
    totalPlayTime,
    brickCounts,
    difficultyGamesPlayed,
    difficultyHighScores,
    lastPlayed,
  ];
}