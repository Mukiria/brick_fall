// lib/engine/piece.dart
/// Piece - Tetromino representation, rotations, movement

import 'constants.dart';
import 'types.dart';
import 'piece_library.dart';

class Piece {
  final PieceType type;
  final int x;
  final int y;
  final int rotation; // 0, 1, 2, 3 (90 degree increments)
  final int color;
  final int id;
  final List<Offset>? customBlocks; // For custom pieces from library
  final String? libraryId; // Reference to PieceLibrary definition

  static int _nextId = 0;

  Piece({
    required this.type,
    required this.x,
    required this.y,
    this.rotation = 0,
    required this.color,
    int? id,
    this.customBlocks,
    this.libraryId,
  }) : id = id ?? _nextId++;

  /// Get the category from library definition (for custom pieces)
  PieceCategory? get category {
    if (libraryId != null) {
      final library = PieceLibrary();
      final def = library.get(libraryId!);
      return def?.category;
    }
    // Map standard PieceType to category
    return _typeToCategory(type);
  }

  /// Get the difficulty from library definition (for custom pieces)
  int get difficulty {
    if (libraryId != null) {
      final library = PieceLibrary();
      final def = library.get(libraryId!);
      return def?.difficulty ?? 1;
    }
    return 1;
  }

  PieceCategory? _typeToCategory(PieceType type) {
    switch (type) {
      case PieceType.I: return PieceCategory.long;
      case PieceType.J: return PieceCategory.lShape;
      case PieceType.L: return PieceCategory.lShape;
      case PieceType.O: return PieceCategory.square;
      case PieceType.S: return PieceCategory.zShape;
      case PieceType.T: return PieceCategory.tShape;
      case PieceType.Z: return PieceCategory.zShape;
    }
  }

  /// Create standard piece at spawn position
  factory Piece.spawn(PieceType type) {
    final definition = GameConstants.pieceDefinitions[type]!;
    final blocks = definition.map((o) => Offset(o.dx, o.dy)).toList();
    final color = GameConstants.pieceColors[type]!;
    
    // Calculate spawn position (centered horizontally)
    int minX = blocks.map((b) => b.dx).reduce((a, b) => a < b ? a : b);
    int maxX = blocks.map((b) => b.dx).reduce((a, b) => a > b ? a : b);
    int pieceWidth = maxX - minX + 1;
    int spawnX = GameConstants.spawnCol - minX + (GameConstants.boardWidth - pieceWidth) ~/ 2;
    
    return Piece(
      type: type,
      x: spawnX,
      y: GameConstants.spawnRow,
      color: color,
    );
  }

  /// Create custom piece from library definition
  factory Piece.fromLibrary(String libraryId, List<Offset> blocks, int color, {int x = 0, int y = 0}) {
    return Piece(
      type: PieceType.O, // Use O as base for custom pieces
      x: x,
      y: y,
      color: color,
      customBlocks: blocks,
      libraryId: libraryId,
    );
  }

  /// Get block positions relative to piece origin
  List<Offset> get blocks {
    if (customBlocks != null) {
      var blocks = List<Offset>.from(customBlocks!);
      
      // Apply rotation
      for (int i = 0; i < rotation; i++) {
        blocks = blocks.map((b) => Offset(-b.dy, b.dx)).toList();
      }
      return blocks;
    }
    
    final definition = GameConstants.pieceDefinitions[type]!;
    var blocks = definition.map((o) => Offset(o.dx, o.dy)).toList();
    
    // Apply rotation
    for (int i = 0; i < rotation; i++) {
      blocks = blocks.map((b) => Offset(-b.dy, b.dx)).toList();
    }
    
    return blocks;
  }

  /// Get absolute block positions on board
  List<Offset> get absoluteBlocks {
    return blocks.map((b) => Offset(x + b.dx, y + b.dy)).toList();
  }

  /// Get bounding box
  (int minX, int maxX, int minY, int maxY) get bounds {
    final blocks = this.blocks;
    int minX = blocks.map((b) => b.dx).reduce((a, b) => a < b ? a : b);
    int maxX = blocks.map((b) => b.dx).reduce((a, b) => a > b ? a : b);
    int minY = blocks.map((b) => b.dy).reduce((a, b) => a < b ? a : b);
    int maxY = blocks.map((b) => b.dy).reduce((a, b) => a > b ? a : b);
    return (minX, maxX, minY, maxY);
  }

  /// Get width
  int get width {
    final b = bounds;
    return b.$2 - b.$1 + 1;
  }

  /// Get height
  int get height {
    final b = bounds;
    return b.$4 - b.$3 + 1;
  }

  /// Move piece
  Piece move(MoveDirection direction) {
    switch (direction) {
      case MoveDirection.left:
        return Piece(
          type: type,
          x: x - 1,
          y: y,
          rotation: rotation,
          color: color,
          id: id,
          customBlocks: customBlocks,
          libraryId: libraryId,
        );
      case MoveDirection.right:
        return Piece(
          type: type,
          x: x + 1,
          y: y,
          rotation: rotation,
          color: color,
          id: id,
          customBlocks: customBlocks,
          libraryId: libraryId,
        );
      case MoveDirection.down:
        return Piece(
          type: type,
          x: x,
          y: y + 1,
          rotation: rotation,
          color: color,
          id: id,
          customBlocks: customBlocks,
          libraryId: libraryId,
        );
      case MoveDirection.drop:
        return Piece(
          type: type,
          x: x,
          y: y,
          rotation: rotation,
          color: color,
          id: id,
          customBlocks: customBlocks,
          libraryId: libraryId,
        );
    }
  }

  /// Move by offset
  Piece moveBy(int dx, int dy) {
    return Piece(
      type: type,
      x: x + dx,
      y: y + dy,
      rotation: rotation,
      color: color,
      id: id,
      customBlocks: customBlocks,
      libraryId: libraryId,
    );
  }

  /// Rotate clockwise
  Piece rotateClockwise() {
    return Piece(
      type: type,
      x: x,
      y: y,
      rotation: (rotation + 1) % 4,
      color: color,
      id: id,
      customBlocks: customBlocks,
      libraryId: libraryId,
    );
  }

  /// Rotate counter-clockwise
  Piece rotateCounterClockwise() {
    return Piece(
      type: type,
      x: x,
      y: y,
      rotation: (rotation + 3) % 4,
      color: color,
      id: id,
      customBlocks: customBlocks,
      libraryId: libraryId,
    );
  }

  /// Check if piece is O type (square, no rotation change)
  bool get isSquare => type == PieceType.O && customBlocks == null;

  /// Check if piece is I type (needs special wall kicks)
  bool get isI => type == PieceType.I && customBlocks == null;

  /// Check if this is a custom library piece
  bool get isCustom => customBlocks != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Piece &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          x == other.x &&
          y == other.y &&
          rotation == other.rotation &&
          color == other.color &&
          id == other.id &&
          customBlocks == other.customBlocks &&
          libraryId == other.libraryId;

  @override
  int get hashCode =>
      type.hashCode ^ x.hashCode ^ y.hashCode ^ rotation.hashCode ^ color.hashCode ^ id.hashCode ^ 
      customBlocks.hashCode ^ libraryId.hashCode;

  @override
  String toString() => 'Piece(type: $type, x: $x, y: $y, rot: $rotation, id: $id, custom: $isCustom)';

  /// Serialize to JSON
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'x': x,
        'y': y,
        'rotation': rotation,
        'color': color,
        'id': id,
        'customBlocks': customBlocks?.map((b) => {'dx': b.dx, 'dy': b.dy}).toList(),
        'libraryId': libraryId,
      };

  /// Deserialize from JSON
  factory Piece.fromJson(Map<String, dynamic> json) => Piece(
        type: PieceType.values.firstWhere((e) => e.name == json['type']),
        x: json['x'] as int,
        y: json['y'] as int,
        rotation: json['rotation'] as int,
        color: json['color'] as int,
        id: json['id'] as int,
        customBlocks: (json['customBlocks'] as List?)?.map((b) => Offset(b['dx'] as int, b['dy'] as int)).toList(),
        libraryId: json['libraryId'] as String?,
      );
}