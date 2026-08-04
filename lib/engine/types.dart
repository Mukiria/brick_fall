// lib/engine/types.dart
/// Core engine types - pure Dart, no Flutter dependencies

/// Simple Offset class for pure Dart
class Offset {
  final int dx;
  final int dy;

  const Offset(this.dx, this.dy);

  Offset operator +(Offset other) => Offset(dx + other.dx, dy + other.dy);
  Offset operator -(Offset other) => Offset(dx - other.dx, dy - other.dy);
  Offset operator *(int scalar) => Offset(dx * scalar, dy * scalar);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Offset && runtimeType == other.runtimeType && dx == other.dx && dy == other.dy;

  @override
  int get hashCode => dx.hashCode ^ dy.hashCode;

  @override
  String toString() => 'Offset($dx, $dy)';
}

/// Game difficulty levels
enum Difficulty {
  easy,
  normal,
  hard,
  expert;

  String get displayName => name.toUpperCase();
}

/// Core game states
enum GameStateStatus {
  idle,
  playing,
  paused,
  gameOver;
}

/// Tetromino piece types (7-bag)
enum PieceType {
  I,
  J,
  L,
  O,
  S,
  T,
  Z;

  /// All piece types for bag generation
  static const List<PieceType> all = [
    PieceType.I,
    PieceType.J,
    PieceType.L,
    PieceType.O,
    PieceType.S,
    PieceType.T,
    PieceType.Z,
  ];
}

/// Rotation direction
enum RotationDirection {
  clockwise,
  counterClockwise;
}

/// Movement direction
enum MoveDirection {
  left,
  right,
  down,
  drop;
}

/// Result of a piece placement attempt
enum PlacementResult {
  success,
  collision,
  outOfBounds,
  gameOver;
}

/// Line clear types
enum LineClearType {
  single(1),
  double(2),
  triple(3),
  tetris(4);

  const LineClearType(this.lineCount);
  final int lineCount;

  static LineClearType fromCount(int count) {
    switch (count) {
      case 1: return LineClearType.single;
      case 2: return LineClearType.double;
      case 3: return LineClearType.triple;
      case 4: return LineClearType.tetris;
      default: return LineClearType.single;
    }
  }
}

/// Game action for replay/undo system
enum GameAction {
  moveLeft,
  moveRight,
  moveDown,
  hardDrop,
  rotateCW,
  rotateCCW,
  hold,
  pause,
  resume;
}

/// Serializable game action with timestamp
class GameActionRecord {
  final GameAction action;
  final int timestampMs;
  final int pieceId;

  const GameActionRecord({
    required this.action,
    required this.timestampMs,
    required this.pieceId,
  });

  Map<String, dynamic> toJson() => {
        'action': action.name,
        'timestampMs': timestampMs,
        'pieceId': pieceId,
      };

  factory GameActionRecord.fromJson(Map<String, dynamic> json) => GameActionRecord(
        action: GameAction.values.firstWhere((e) => e.name == json['action']),
        timestampMs: json['timestampMs'] as int,
        pieceId: json['pieceId'] as int,
      );
}