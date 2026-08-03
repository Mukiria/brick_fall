import 'package:hive/hive.dart';

part 'app_constants.g.dart';

class AppConstants {
  static const String appName = 'Brick Fall';
  static const String appVersion = '1.0.0';
  static const int gameWidth = 10;
  static const int gameHeight = 20;
  static const double brickSize = 32.0;
  static const Duration gameTickRate = Duration(milliseconds: 500);
  static const Duration fastDropRate = Duration(milliseconds: 50);
  static const int maxLevel = 15;
  static const int linesPerLevel = 10;
  static const int baseScore = 100;
  static const int comboMultiplier = 50;
}

@HiveType(typeId: 5)
enum CoreGameState {
  @HiveField(0)
  idle,
  @HiveField(1)
  playing,
  @HiveField(2)
  paused,
  @HiveField(3)
  gameOver,
  @HiveField(4)
  levelComplete,
}

@HiveType(typeId: 6)
enum BrickType {
  @HiveField(0)
  i,
  @HiveField(1)
  j,
  @HiveField(2)
  l,
  @HiveField(3)
  o,
  @HiveField(4)
  s,
  @HiveField(5)
  t,
  @HiveField(6)
  z,
}

@HiveType(typeId: 7)
enum Direction {
  @HiveField(0)
  left,
  @HiveField(1)
  right,
  @HiveField(2)
  down,
  @HiveField(3)
  rotate,
  @HiveField(4)
  drop,
}

@HiveType(typeId: 8)
enum Difficulty {
  @HiveField(0)
  easy,
  @HiveField(1)
  normal,
  @HiveField(2)
  hard,
  @HiveField(3)
  expert,
}