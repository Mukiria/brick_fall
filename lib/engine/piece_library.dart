// lib/engine/piece_library.dart
/// Piece Library - 70+ Original Puzzle Shapes
///
/// This library contains original puzzle piece designs organized by category.
/// No pieces are copied from existing games (Tetris, Blokus, etc.).
/// Each piece is defined by coordinate offsets from its pivot point.

import 'dart:math' as math;
import 'types.dart';
import 'piece.dart';
import 'constants.dart';

/// Piece definition with all metadata
class PieceDefinition {
  final String id;
  final String name;
  final PieceCategory category;
  final List<Offset> blocks; // Relative to pivot (0,0)
  final int color;
  final List<Offset> pivotOffsets; // Pivot positions for each rotation
  final List<List<Offset>> wallKicks; // Wall kick data per rotation
  final PieceSymmetry symmetry;
  final int difficulty; // 1-5 for progression

  const PieceDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.blocks,
    required this.color,
    this.pivotOffsets = const [Offset(0, 0)],
    this.wallKicks = const [],
    this.symmetry = PieceSymmetry.none,
    this.difficulty = 1,
  });

  /// Get block count
  int get blockCount => blocks.length;

  /// Get bounding box for given rotation
  BoundingBox getBoundingBox(int rotation) {
    final rotated = _rotateBlocks(blocks, rotation);
    int minX = rotated.map((b) => b.dx).reduce(math.min);
    int maxX = rotated.map((b) => b.dx).reduce(math.max);
    int minY = rotated.map((b) => b.dy).reduce(math.min);
    int maxY = rotated.map((b) => b.dy).reduce(math.max);
    return BoundingBox(minX, maxX, minY, maxY);
  }

  /// Get all unique rotations (considering symmetry)
  List<List<Offset>> getUniqueRotations() {
    final rotations = <List<Offset>>[];
    final seen = <String>{};
    
    for (int r = 0; r < 4; r++) {
      final rotated = _rotateBlocks(blocks, r);
      final key = rotated.map((b) => '${b.dx},${b.dy}').join(';');
      if (!seen.contains(key)) {
        seen.add(key);
        rotations.add(rotated);
      }
    }
    return rotations;
  }

  List<Offset> _rotateBlocks(List<Offset> blocks, int rotation) {
    var result = List<Offset>.from(blocks);
    for (int i = 0; i < rotation; i++) {
      result = result.map((b) => Offset(-b.dy, b.dx)).toList();
    }
    return result;
  }

  /// Create Piece instance at spawn position
  Piece createPiece({int x = 0, int y = 0, int rotation = 0}) {
    final rotatedBlocks = _rotateBlocks(blocks, rotation);
    final piece = Piece.fromLibrary(
      id,
      rotatedBlocks,
      color,
      x: x,
      y: y,
    );
    // Set rotation after creation since fromLibrary doesn't take rotation
    return Piece(
      type: PieceType.O,
      x: piece.x,
      y: piece.y,
      rotation: rotation,
      color: piece.color,
      id: piece.id,
      customBlocks: piece.customBlocks,
      libraryId: piece.libraryId,
    );
  }
}

/// Piece categories
enum PieceCategory {
  single,
  double,
  triple,
  lShape,
  tShape,
  zShape,
  cross,
  square,
  rectangle,
  long,
  corner,
  asymmetric,
  special,
}

/// Symmetry type for rotation optimization
enum PieceSymmetry {
  none,       // 4 unique rotations
  half,       // 2 unique rotations (180° symmetry)
  quarter,    // 1 unique rotation (90° symmetry)
  full,       // 1 unique rotation (full symmetry)
}

/// Bounding box for collision and rendering
class BoundingBox {
  final int minX;
  final int maxX;
  final int minY;
  final int maxY;

  const BoundingBox(this.minX, this.maxX, this.minY, this.maxY);

  int get width => maxX - minX + 1;
  int get height => maxY - minY + 1;

  Offset get center => Offset(
    (minX + maxX) ~/ 2,
    (minY + maxY) ~/ 2,
  );

  bool contains(Offset point) =>
      point.dx >= minX && point.dx <= maxX &&
      point.dy >= minY && point.dy <= maxY;

  BoundingBox expand(int padding) => BoundingBox(
    minX - padding,
    maxX + padding,
    minY - padding,
    maxY + padding,
  );

  @override
  String toString() => 'BoundingBox($minX,$maxX x $minY,$maxY) ${width}x$height';
}

/// Piece registry with all definitions
class PieceLibrary {
  static final PieceLibrary _instance = PieceLibrary._internal();
  factory PieceLibrary() => _instance;
  PieceLibrary._internal();

  final Map<String, PieceDefinition> _definitions = {};
  final Map<PieceCategory, List<String>> _byCategory = {};
  final List<String> _allIds = [];

  void _register(PieceDefinition def) {
    _definitions[def.id] = def;
    _byCategory.putIfAbsent(def.category, () => []).add(def.id);
    _allIds.add(def.id);
  }

  PieceDefinition? get(String id) => _definitions[id];
  List<PieceDefinition> getByCategory(PieceCategory cat) => 
      (_byCategory[cat] ?? []).map((id) => _definitions[id]!).toList();
  List<PieceDefinition> getAll() => _allIds.map((id) => _definitions[id]!).toList();
  
  List<PieceDefinition> getByDifficulty(int maxDifficulty) => 
      getAll().where((d) => d.difficulty <= maxDifficulty).toList();

  List<PieceDefinition> getRandomSet(int count, {int maxDifficulty = 5}) {
    final pool = getByDifficulty(maxDifficulty);
    pool.shuffle(math.Random());
    return pool.take(count).toList();
  }

  PieceDefinition getRandom({int maxDifficulty = 5}) {
    final pool = getByDifficulty(maxDifficulty);
    return pool[math.Random().nextInt(pool.length)];
  }

  /// Initialize all piece definitions
  void initialize() {
    if (_definitions.isNotEmpty) return;
    
    _registerAll();
  }

  void _registerAll() {
    // ===== SINGLE (1 block) =====
    _register(PieceDefinition(
      id: 'monomino',
      name: 'Monomino',
      category: PieceCategory.single,
      blocks: [Offset(0, 0)],
      color: 0xFFE91E63, // Pink
      symmetry: PieceSymmetry.full,
      difficulty: 1,
    ));

    // ===== DOUBLE (2 blocks) =====
    _register(PieceDefinition(
      id: 'domino_h',
      name: 'Domino Horizontal',
      category: PieceCategory.double,
      blocks: [Offset(0, 0), Offset(1, 0)],
      color: 0xFF9C27B0, // Purple
      symmetry: PieceSymmetry.half,
      difficulty: 1,
    ));

    _register(PieceDefinition(
      id: 'domino_v',
      name: 'Domino Vertical',
      category: PieceCategory.double,
      blocks: [Offset(0, 0), Offset(0, 1)],
      color: 0xFF673AB7, // Deep Purple
      symmetry: PieceSymmetry.half,
      difficulty: 1,
    ));

    // ===== TRIPLE (3 blocks) =====
    _register(PieceDefinition(
      id: 'triomino_straight',
      name: 'Triomino Straight',
      category: PieceCategory.triple,
      blocks: [Offset(-1, 0), Offset(0, 0), Offset(1, 0)],
      color: 0xFF3F51B5, // Indigo
      symmetry: PieceSymmetry.half,
      difficulty: 1,
    ));

    _register(PieceDefinition(
      id: 'triomino_corner',
      name: 'Triomino Corner',
      category: PieceCategory.triple,
      blocks: [Offset(0, 0), Offset(1, 0), Offset(0, 1)],
      color: 0xFF2196F3, // Blue
      symmetry: PieceSymmetry.none,
      difficulty: 1,
    ));

    // ===== L-SHAPES (4 blocks) =====
    _register(PieceDefinition(
      id: 'l_small',
      name: 'Small L',
      category: PieceCategory.lShape,
      blocks: [Offset(0, 0), Offset(0, 1), Offset(0, 2), Offset(1, 2)],
      color: 0xFFFF9800, // Orange
      symmetry: PieceSymmetry.none,
      difficulty: 2,
    ));

    _register(PieceDefinition(
      id: 'l_mirror',
      name: 'Mirror L',
      category: PieceCategory.lShape,
      blocks: [Offset(1, 0), Offset(1, 1), Offset(1, 2), Offset(0, 2)],
      color: 0xFFFF5722, // Deep Orange
      symmetry: PieceSymmetry.none,
      difficulty: 2,
    ));

    _register(PieceDefinition(
      id: 'l_fat',
      name: 'Fat L',
      category: PieceCategory.lShape,
      blocks: [Offset(0, 0), Offset(1, 0), Offset(0, 1), Offset(0, 2)],
      color: 0xFFFFC107, // Amber
      symmetry: PieceSymmetry.none,
      difficulty: 2,
    ));

    _register(PieceDefinition(
      id: 'l_extended',
      name: 'Extended L',
      category: PieceCategory.lShape,
      blocks: [Offset(0, 0), Offset(0, 1), Offset(0, 2), Offset(0, 3), Offset(1, 3)],
      color: 0xFFFFEB3B, // Yellow
      symmetry: PieceSymmetry.none,
      difficulty: 3,
    ));

    // ===== T-SHAPES (4-5 blocks) =====
    _register(PieceDefinition(
      id: 't_classic',
      name: 'Classic T',
      category: PieceCategory.tShape,
      blocks: [Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(0, 1)],
      color: 0xFF00BCD4, // Cyan
      symmetry: PieceSymmetry.none,
      difficulty: 2,
    ));

    _register(PieceDefinition(
      id: 't_inverted',
      name: 'Inverted T',
      category: PieceCategory.tShape,
      blocks: [Offset(-1, 1), Offset(0, 1), Offset(1, 1), Offset(0, 0)],
      color: 0xFF009688, // Teal
      symmetry: PieceSymmetry.none,
      difficulty: 2,
    ));

    _register(PieceDefinition(
      id: 't_wide',
      name: 'Wide T',
      category: PieceCategory.tShape,
      blocks: [Offset(-2, 0), Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(2, 0), Offset(0, 1)],
      color: 0xFF4CAF50, // Green
      symmetry: PieceSymmetry.half,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 't_double',
      name: 'Double T',
      category: PieceCategory.tShape,
      blocks: [Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(0, 1), Offset(0, -1)],
      color: 0xFF8BC34A, // Light Green
      symmetry: PieceSymmetry.quarter,
      difficulty: 3,
    ));

    // ===== Z/S-SHAPES (4 blocks) =====
    _register(PieceDefinition(
      id: 'z_shape',
      name: 'Z Shape',
      category: PieceCategory.zShape,
      blocks: [Offset(0, 0), Offset(1, 0), Offset(-1, 1), Offset(0, 1)],
      color: 0xFFF44336, // Red
      symmetry: PieceSymmetry.half,
      difficulty: 2,
    ));

    _register(PieceDefinition(
      id: 's_shape',
      name: 'S Shape',
      category: PieceCategory.zShape,
      blocks: [Offset(-1, 0), Offset(0, 0), Offset(0, 1), Offset(1, 1)],
      color: 0xFFE91E63, // Pink
      symmetry: PieceSymmetry.half,
      difficulty: 2,
    ));

    _register(PieceDefinition(
      id: 'z_long',
      name: 'Long Z',
      category: PieceCategory.zShape,
      blocks: [Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(-2, 1), Offset(-1, 1), Offset(0, 1)],
      color: 0xFF9C27B0, // Purple
      symmetry: PieceSymmetry.half,
      difficulty: 3,
    ));

    // ===== CROSS SHAPES (5 blocks) =====
    _register(PieceDefinition(
      id: 'cross_plus',
      name: 'Plus Cross',
      category: PieceCategory.cross,
      blocks: [Offset(0, 0), Offset(-1, 0), Offset(1, 0), Offset(0, -1), Offset(0, 1)],
      color: 0xFF673AB7, // Deep Purple
      symmetry: PieceSymmetry.quarter,
      difficulty: 2,
    ));

    _register(PieceDefinition(
      id: 'cross_x',
      name: 'X Cross',
      category: PieceCategory.cross,
      blocks: [Offset(-1, -1), Offset(1, -1), Offset(0, 0), Offset(-1, 1), Offset(1, 1)],
      color: 0xFF3F51B5, // Indigo
      symmetry: PieceSymmetry.quarter,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'cross_maltese',
      name: 'Maltese Cross',
      category: PieceCategory.cross,
      blocks: [
        Offset(0, -2), Offset(-1, -1), Offset(0, -1), Offset(1, -1),
        Offset(-2, 0), Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(2, 0),
        Offset(-1, 1), Offset(0, 1), Offset(1, 1), Offset(0, 2)
      ],
      color: 0xFF2196F3, // Blue
      symmetry: PieceSymmetry.quarter,
      difficulty: 4,
    ));

    // ===== SQUARES (4, 9, 16 blocks) =====
    _register(PieceDefinition(
      id: 'square_2x2',
      name: '2x2 Square',
      category: PieceCategory.square,
      blocks: [Offset(0, 0), Offset(1, 0), Offset(0, 1), Offset(1, 1)],
      color: 0xFF00BCD4, // Cyan
      symmetry: PieceSymmetry.full,
      difficulty: 1,
    ));

    _register(PieceDefinition(
      id: 'square_3x3',
      name: '3x3 Square',
      category: PieceCategory.square,
      blocks: [
        Offset(-1, -1), Offset(0, -1), Offset(1, -1),
        Offset(-1, 0), Offset(0, 0), Offset(1, 0),
        Offset(-1, 1), Offset(0, 1), Offset(1, 1),
      ],
      color: 0xFF009688, // Teal
      symmetry: PieceSymmetry.full,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'square_hollow',
      name: 'Hollow Square',
      category: PieceCategory.square,
      blocks: [
        Offset(-1, -1), Offset(0, -1), Offset(1, -1),
        Offset(-1, 0), Offset(1, 0),
        Offset(-1, 1), Offset(0, 1), Offset(1, 1),
      ],
      color: 0xFF4CAF50, // Green
      symmetry: PieceSymmetry.quarter,
      difficulty: 3,
    ));

    // ===== RECTANGLES (various) =====
    _register(PieceDefinition(
      id: 'rect_1x3',
      name: '1x3 Rectangle',
      category: PieceCategory.rectangle,
      blocks: [Offset(0, 0), Offset(0, 1), Offset(0, 2)],
      color: 0xFF8BC34A, // Light Green
      symmetry: PieceSymmetry.half,
      difficulty: 1,
    ));

    _register(PieceDefinition(
      id: 'rect_2x3',
      name: '2x3 Rectangle',
      category: PieceCategory.rectangle,
      blocks: [
        Offset(0, 0), Offset(1, 0),
        Offset(0, 1), Offset(1, 1),
        Offset(0, 2), Offset(1, 2),
      ],
      color: 0xFFCDDC39, // Lime
      symmetry: PieceSymmetry.half,
      difficulty: 2,
    ));

    _register(PieceDefinition(
      id: 'rect_2x4',
      name: '2x4 Rectangle',
      category: PieceCategory.rectangle,
      blocks: [
        Offset(0, 0), Offset(1, 0),
        Offset(0, 1), Offset(1, 1),
        Offset(0, 2), Offset(1, 2),
        Offset(0, 3), Offset(1, 3),
      ],
      color: 0xFFFFEB3B, // Yellow
      symmetry: PieceSymmetry.half,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'rect_3x4',
      name: '3x4 Rectangle',
      category: PieceCategory.rectangle,
      blocks: [
        Offset(0, 0), Offset(1, 0), Offset(2, 0),
        Offset(0, 1), Offset(1, 1), Offset(2, 1),
        Offset(0, 2), Offset(1, 2), Offset(2, 2),
        Offset(0, 3), Offset(1, 3), Offset(2, 3),
      ],
      color: 0xFFFFC107, // Amber
      symmetry: PieceSymmetry.half,
      difficulty: 4,
    ));

    // ===== LONG PIECES (5+ blocks in line) =====
    _register(PieceDefinition(
      id: 'long_5',
      name: 'Long 5',
      category: PieceCategory.long,
      blocks: [Offset(-2, 0), Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(2, 0)],
      color: 0xFFFF9800, // Orange
      symmetry: PieceSymmetry.half,
      difficulty: 2,
    ));

    _register(PieceDefinition(
      id: 'long_6',
      name: 'Long 6',
      category: PieceCategory.long,
      blocks: [Offset(-2, 0), Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(2, 0), Offset(3, 0)],
      color: 0xFFFF5722, // Deep Orange
      symmetry: PieceSymmetry.half,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'long_7',
      name: 'Long 7',
      category: PieceCategory.long,
      blocks: [Offset(-3, 0), Offset(-2, 0), Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(2, 0), Offset(3, 0)],
      color: 0xFF795548, // Brown
      symmetry: PieceSymmetry.half,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'long_8',
      name: 'Long 8',
      category: PieceCategory.long,
      blocks: [Offset(-3, 0), Offset(-2, 0), Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(2, 0), Offset(3, 0), Offset(4, 0)],
      color: 0xFF607D8B, // Blue Grey
      symmetry: PieceSymmetry.half,
      difficulty: 4,
    ));

    // ===== CORNER PIECES =====
    _register(PieceDefinition(
      id: 'corner_2x2',
      name: '2x2 Corner',
      category: PieceCategory.corner,
      blocks: [Offset(0, 0), Offset(1, 0), Offset(0, 1)],
      color: 0xFFE91E63, // Pink
      symmetry: PieceSymmetry.none,
      difficulty: 1,
    ));

    _register(PieceDefinition(
      id: 'corner_3x3',
      name: '3x3 Corner',
      category: PieceCategory.corner,
      blocks: [Offset(0, 0), Offset(1, 0), Offset(2, 0), Offset(0, 1), Offset(0, 2)],
      color: 0xFF9C27B0, // Purple
      symmetry: PieceSymmetry.none,
      difficulty: 2,
    ));

    _register(PieceDefinition(
      id: 'corner_4x4',
      name: '4x4 Corner',
      category: PieceCategory.corner,
      blocks: [
        Offset(0, 0), Offset(1, 0), Offset(2, 0), Offset(3, 0),
        Offset(0, 1), Offset(0, 2), Offset(0, 3),
      ],
      color: 0xFF673AB7, // Deep Purple
      symmetry: PieceSymmetry.none,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'corner_rounded',
      name: 'Rounded Corner',
      category: PieceCategory.corner,
      blocks: [
        Offset(0, 0), Offset(1, 0), Offset(2, 0),
        Offset(0, 1), Offset(1, 1),
        Offset(0, 2),
      ],
      color: 0xFF3F51B5, // Indigo
      symmetry: PieceSymmetry.none,
      difficulty: 2,
    ));

    _register(PieceDefinition(
      id: 'corner_stair',
      name: 'Stair Corner',
      category: PieceCategory.corner,
      blocks: [
        Offset(0, 0), Offset(1, 0),
        Offset(0, 1), Offset(1, 1),
        Offset(0, 2),
      ],
      color: 0xFF2196F3, // Blue
      symmetry: PieceSymmetry.none,
      difficulty: 2,
    ));

    // ===== ASYMMETRIC / RANDOM SHAPES =====
    _register(PieceDefinition(
      id: 'asym_hook',
      name: 'Hook',
      category: PieceCategory.asymmetric,
      blocks: [Offset(0, 0), Offset(0, 1), Offset(0, 2), Offset(1, 1)],
      color: 0xFF00BCD4, // Cyan
      symmetry: PieceSymmetry.none,
      difficulty: 2,
    ));

    _register(PieceDefinition(
      id: 'asym_lightning',
      name: 'Lightning',
      category: PieceCategory.asymmetric,
      blocks: [Offset(0, 0), Offset(1, 0), Offset(1, 1), Offset(2, 1), Offset(2, 2)],
      color: 0xFFFFEB3B, // Yellow
      symmetry: PieceSymmetry.none,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'asym_stairs',
      name: 'Stairs',
      category: PieceCategory.asymmetric,
      blocks: [Offset(0, 0), Offset(1, 0), Offset(1, 1), Offset(2, 1), Offset(2, 2), Offset(3, 2)],
      color: 0xFF4CAF50, // Green
      symmetry: PieceSymmetry.none,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'asym_spiral',
      name: 'Spiral',
      category: PieceCategory.asymmetric,
      blocks: [Offset(0, 0), Offset(1, 0), Offset(1, 1), Offset(0, 1), Offset(-1, 1), Offset(-1, 0)],
      color: 0xFF9C27B0, // Purple
      symmetry: PieceSymmetry.none,
      difficulty: 4,
    ));

    _register(PieceDefinition(
      id: 'asym_tree',
      name: 'Tree',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(0, -2), Offset(0, -1), Offset(0, 0), Offset(0, 1),
        Offset(-1, 0), Offset(1, 0), Offset(-1, -1), Offset(1, -1),
      ],
      color: 0xFF8BC34A, // Light Green
      symmetry: PieceSymmetry.half,
      difficulty: 4,
    ));

    _register(PieceDefinition(
      id: 'asym_worm',
      name: 'Worm',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(0, 0), Offset(1, 0), Offset(2, 0),
        Offset(2, 1), Offset(2, 2),
        Offset(1, 2), Offset(0, 2),
        Offset(0, 1),
      ],
      color: 0xFF795548, // Brown
      symmetry: PieceSymmetry.none,
      difficulty: 4,
    ));

    _register(PieceDefinition(
      id: 'asym_zigzag',
      name: 'ZigZag',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(0, 0), Offset(1, 0),
        Offset(1, 1), Offset(2, 1),
        Offset(2, 2), Offset(3, 2),
        Offset(3, 3), Offset(4, 3),
      ],
      color: 0xFF00BCD4, // Cyan
      symmetry: PieceSymmetry.half,
      difficulty: 4,
    ));

    // ===== SPECIAL SHAPES =====
    _register(PieceDefinition(
      id: 'special_ring',
      name: 'Ring',
      category: PieceCategory.special,
      blocks: [
        Offset(-2, 0), Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(2, 0),
        Offset(-2, 1), Offset(2, 1),
        Offset(-2, -1), Offset(2, -1),
        Offset(-2, 2), Offset(-1, 2), Offset(0, 2), Offset(1, 2), Offset(2, 2),
        Offset(-2, -2), Offset(-1, -2), Offset(0, -2), Offset(1, -2), Offset(2, -2),
      ],
      color: 0xFFFFD700, // Gold
      symmetry: PieceSymmetry.quarter,
      difficulty: 5,
    ));

    _register(PieceDefinition(
      id: 'special_pinwheel',
      name: 'Pinwheel',
      category: PieceCategory.special,
      blocks: [
        Offset(0, 0),
        Offset(1, 0), Offset(2, 0),
        Offset(-1, 0), Offset(-2, 0),
        Offset(0, 1), Offset(0, 2),
        Offset(0, -1), Offset(0, -2),
      ],
      color: 0xFFFF69B4, // Hot Pink
      symmetry: PieceSymmetry.quarter,
      difficulty: 4,
    ));

    _register(PieceDefinition(
      id: 'special_asterisk',
      name: 'Asterisk',
      category: PieceCategory.special,
      blocks: [
        Offset(0, 0),
        Offset(1, 0), Offset(2, 0),
        Offset(-1, 0), Offset(-2, 0),
        Offset(0, 1), Offset(0, 2),
        Offset(0, -1), Offset(0, -2),
        Offset(1, 1), Offset(-1, 1), Offset(1, -1), Offset(-1, -1),
      ],
      color: 0xFF00FFFF, // Cyan
      symmetry: PieceSymmetry.quarter,
      difficulty: 5,
    ));

    _register(PieceDefinition(
      id: 'special_diamond',
      name: 'Diamond',
      category: PieceCategory.special,
      blocks: [
        Offset(0, -2),
        Offset(-1, -1), Offset(0, -1), Offset(1, -1),
        Offset(-2, 0), Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(2, 0),
        Offset(-1, 1), Offset(0, 1), Offset(1, 1),
        Offset(0, 2),
      ],
      color: 0xFFE040FB, // Purple Accent
      symmetry: PieceSymmetry.quarter,
      difficulty: 4,
    ));

    _register(PieceDefinition(
      id: 'special_hexagon',
      name: 'Hexagon',
      category: PieceCategory.special,
      blocks: [
        Offset(-1, -1), Offset(0, -1), Offset(1, -1),
        Offset(-2, 0), Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(2, 0),
        Offset(-1, 1), Offset(0, 1), Offset(1, 1),
      ],
      color: 0xFF76FF03, // Green Accent
      symmetry: PieceSymmetry.quarter,
      difficulty: 4,
    ));

    // Additional asymmetric pieces to reach 70+
    _register(PieceDefinition(
      id: 'asym_arrow',
      name: 'Arrow',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(0, -2),
        Offset(-1, -1), Offset(0, -1), Offset(1, -1),
        Offset(0, 0),
        Offset(0, 1), Offset(0, 2),
      ],
      color: 0xFFFF5722, // Deep Orange
      symmetry: PieceSymmetry.half,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'asym_boomerang',
      name: 'Boomerang',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(-2, 0), Offset(-1, 0), Offset(0, 0),
        Offset(-2, 1), Offset(-1, 1),
        Offset(-2, 2),
      ],
      color: 0xFF00BCD4, // Cyan
      symmetry: PieceSymmetry.none,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'asym_snake',
      name: 'Snake',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(0, 0), Offset(1, 0),
        Offset(1, 1), Offset(2, 1),
        Offset(2, 2), Offset(3, 2),
        Offset(3, 3), Offset(4, 3),
      ],
      color: 0xFF8BC34A, // Light Green
      symmetry: PieceSymmetry.none,
      difficulty: 4,
    ));

    _register(PieceDefinition(
      id: 'asym_tetromino_y',
      name: 'Y Piece',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(0, -2),
        Offset(0, -1), Offset(0, 0), Offset(0, 1),
        Offset(-1, 0), Offset(1, 0),
      ],
      color: 0xFFFFEB3B, // Yellow
      symmetry: PieceSymmetry.none,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'asym_cross_thick',
      name: 'Thick Cross',
      category: PieceCategory.cross,
      blocks: [
        Offset(0, -2),
        Offset(-1, -1), Offset(0, -1), Offset(1, -1),
        Offset(-2, 0), Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(2, 0),
        Offset(-1, 1), Offset(0, 1), Offset(1, 1),
        Offset(0, 2),
      ],
      color: 0xFFE91E63, // Pink
      symmetry: PieceSymmetry.quarter,
      difficulty: 4,
    ));

    _register(PieceDefinition(
      id: 'asym_pentomino_f',
      name: 'F Pentomino',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(0, 0), Offset(1, 0),
        Offset(0, 1), Offset(1, 1),
        Offset(-1, 1),
      ],
      color: 0xFF673AB7, // Deep Purple
      symmetry: PieceSymmetry.none,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'asym_pentomino_n',
      name: 'N Pentomino',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(-1, 0), Offset(0, 0),
        Offset(0, 1), Offset(1, 1),
        Offset(1, 2),
      ],
      color: 0xFF3F51B5, // Indigo
      symmetry: PieceSymmetry.none,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'asym_pentomino_p',
      name: 'P Pentomino',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(0, 0), Offset(1, 0),
        Offset(0, 1), Offset(1, 1),
        Offset(0, -1),
      ],
      color: 0xFF2196F3, // Blue
      symmetry: PieceSymmetry.none,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'asym_pentomino_u',
      name: 'U Pentomino',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(-1, 0), Offset(0, 0), Offset(1, 0),
        Offset(-1, 1), Offset(1, 1),
      ],
      color: 0xFF00BCD4, // Cyan
      symmetry: PieceSymmetry.half,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'asym_pentomino_v',
      name: 'V Pentomino',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(-1, -1), Offset(0, -1), Offset(1, -1),
        Offset(-1, 0),
        Offset(-1, 1),
      ],
      color: 0xFF4CAF50, // Green
      symmetry: PieceSymmetry.none,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'asym_pentomino_w',
      name: 'W Pentomino',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(-1, 0), Offset(0, 0),
        Offset(0, 1), Offset(1, 1),
        Offset(1, 2),
      ],
      color: 0xFF8BC34A, // Light Green
      symmetry: PieceSymmetry.none,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'asym_pentomino_x',
      name: 'X Pentomino',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(0, -1),
        Offset(-1, 0), Offset(0, 0), Offset(1, 0),
        Offset(0, 1),
      ],
      color: 0xFFCDDC39, // Lime
      symmetry: PieceSymmetry.quarter,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'asym_pentomino_z',
      name: 'Z Pentomino',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(-1, -1), Offset(0, -1),
        Offset(0, 0), Offset(1, 0),
        Offset(1, 1),
      ],
      color: 0xFFFFC107, // Amber
      symmetry: PieceSymmetry.half,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'asym_heptomino_1',
      name: 'Heptomino Spiral',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(0, 0), Offset(1, 0), Offset(2, 0),
        Offset(2, 1),
        Offset(2, 2), Offset(1, 2), Offset(0, 2),
        Offset(0, 1),
      ],
      color: 0xFF795548, // Brown
      symmetry: PieceSymmetry.none,
      difficulty: 5,
    ));

    _register(PieceDefinition(
      id: 'asym_octomino_1',
      name: 'Octomino Cross',
      category: PieceCategory.special,
      blocks: [
        Offset(0, -2),
        Offset(-1, -1), Offset(0, -1), Offset(1, -1),
        Offset(-2, 0), Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(2, 0),
        Offset(-1, 1), Offset(0, 1), Offset(1, 1),
        Offset(0, 2),
      ],
      color: 0xFF9C27B0, // Purple
      symmetry: PieceSymmetry.quarter,
      difficulty: 5,
    ));

    _register(PieceDefinition(
      id: 'asym_nonomino_1',
      name: 'Nonomino Tree',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(0, -3),
        Offset(0, -2),
        Offset(-1, -1), Offset(0, -1), Offset(1, -1),
        Offset(-2, 0), Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(2, 0),
        Offset(0, 1),
      ],
      color: 0xFF673AB7, // Deep Purple
      symmetry: PieceSymmetry.half,
      difficulty: 5,
    ));

    _register(PieceDefinition(
      id: 'asym_decomino_1',
      name: 'Decomino Snake',
      category: PieceCategory.long,
      blocks: [
        Offset(0, 0), Offset(1, 0),
        Offset(1, 1), Offset(2, 1),
        Offset(2, 2), Offset(3, 2),
        Offset(3, 3), Offset(4, 3),
        Offset(4, 4), Offset(5, 4),
      ],
      color: 0xFF00BCD4, // Cyan
      symmetry: PieceSymmetry.none,
      difficulty: 5,
    ));

    _register(PieceDefinition(
      id: 'special_star_5',
      name: '5-Point Star',
      category: PieceCategory.special,
      blocks: [
        Offset(0, -2),
        Offset(-1, -1), Offset(0, -1), Offset(1, -1),
        Offset(-2, 0), Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(2, 0),
        Offset(-1, 1), Offset(0, 1), Offset(1, 1),
        Offset(0, 2),
      ],
      color: 0xFFFFD700, // Gold
      symmetry: PieceSymmetry.quarter,
      difficulty: 4,
    ));

    _register(PieceDefinition(
      id: 'special_snowflake',
      name: 'Snowflake',
      category: PieceCategory.special,
      blocks: [
        Offset(0, -3),
        Offset(0, -2),
        Offset(-1, -1), Offset(0, -1), Offset(1, -1),
        Offset(-2, 0), Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(2, 0),
        Offset(-1, 1), Offset(0, 1), Offset(1, 1),
        Offset(0, 2),
        Offset(0, 3),
      ],
      color: 0xFFE0F7FA, // Cyan Light
      symmetry: PieceSymmetry.quarter,
      difficulty: 5,
    ));

    _register(PieceDefinition(
      id: 'asym_hexomino_stair',
      name: 'Stair Hexomino',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(0, 0), Offset(1, 0),
        Offset(1, 1), Offset(2, 1),
        Offset(2, 2), Offset(3, 2),
      ],
      color: 0xFF4CAF50, // Green
      symmetry: PieceSymmetry.none,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'asym_hexomino_hook',
      name: 'Hook Hexomino',
      category: PieceCategory.asymmetric,
      blocks: [
        Offset(0, 0), Offset(0, 1), Offset(0, 2), Offset(0, 3),
        Offset(1, 3), Offset(2, 3),
      ],
      color: 0xFFFF9800, // Orange
      symmetry: PieceSymmetry.none,
      difficulty: 3,
    ));

    _register(PieceDefinition(
      id: 'asym_hexomino_long_l',
      name: 'Long L Hexomino',
      category: PieceCategory.lShape,
      blocks: [
        Offset(0, 0), Offset(0, 1), Offset(0, 2), Offset(0, 3), Offset(0, 4),
        Offset(1, 4),
      ],
      color: 0xFFFF5722, // Deep Orange
      symmetry: PieceSymmetry.none,
      difficulty: 4,
    ));

    _register(PieceDefinition(
      id: 'asym_heptomino_t',
      name: 'T Heptomino',
      category: PieceCategory.tShape,
      blocks: [
        Offset(-2, 0), Offset(-1, 0), Offset(0, 0), Offset(1, 0), Offset(2, 0),
        Offset(0, 1), Offset(0, -1),
      ],
      color: 0xFF00BCD4, // Cyan
      symmetry: PieceSymmetry.half,
      difficulty: 4,
    ));

    _register(PieceDefinition(
      id: 'asym_octomino_rect_hollow',
      name: 'Hollow Rectangle',
      category: PieceCategory.square,
      blocks: [
        Offset(-1, -2), Offset(0, -2), Offset(1, -2),
        Offset(-1, -1), Offset(1, -1),
        Offset(-1, 0), Offset(1, 0),
        Offset(-1, 1), Offset(0, 1), Offset(1, 1),
      ],
      color: 0xFF009688, // Teal
      symmetry: PieceSymmetry.quarter,
      difficulty: 4,
    ));
  }
}

/// Singleton accessor
final pieceLibrary = PieceLibrary();