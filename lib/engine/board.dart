// lib/engine/board.dart
/// Board - Grid management, line clearing, collision detection

import 'constants.dart';
import 'piece.dart';

class Board {
  final List<List<bool>> _grid;
  final List<List<int>> _colorGrid;

  Board()
      : _grid = List.generate(
          GameConstants.boardHeight,
          (_) => List.filled(GameConstants.boardWidth, false),
        ),
        _colorGrid = List.generate(
          GameConstants.boardHeight,
          (_) => List.filled(GameConstants.boardWidth, 0),
        );

  Board.fromState({
    required List<List<bool>> grid,
    required List<List<int>> colorGrid,
  })  : _grid = grid.map((row) => List<bool>.from(row)).toList(),
        _colorGrid = colorGrid.map((row) => List<int>.from(row)).toList();

  // Getters
  List<List<bool>> get grid => _grid.map((row) => List<bool>.from(row)).toList();
  List<List<int>> get colorGrid => _colorGrid.map((row) => List<int>.from(row)).toList();
  int get width => GameConstants.boardWidth;
  int get height => GameConstants.boardHeight;

  /// Check if a cell is occupied
  bool isOccupied(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) return true;
    return _grid[y][x];
  }

  /// Get color at cell
  int getColor(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) return 0;
    return _colorGrid[y][x];
  }

  /// Set cell occupancy and color
  void setCell(int x, int y, bool occupied, {int color = 0}) {
    if (x >= 0 && x < width && y >= 0 && y < height) {
      _grid[y][x] = occupied;
      _colorGrid[y][x] = occupied ? color : 0;
    }
  }

  /// Check if row is full
  bool isRowFull(int y) {
    if (y < 0 || y >= height) return false;
    for (int x = 0; x < width; x++) {
      if (!_grid[y][x]) return false;
    }
    return true;
  }

  /// Find all full lines
  List<int> findFullLines() {
    final lines = <int>[];
    for (int y = height - 1; y >= 0; y--) {
      if (isRowFull(y)) {
        lines.add(y);
      }
    }
    return lines;
  }

  /// Clear lines and shift down
  void clearLines(List<int> lines) {
    if (lines.isEmpty) return;

    // Sort lines descending to clear from bottom up
    lines.sort((a, b) => b.compareTo(a));

    for (final line in lines) {
      // Shift rows down
      for (int y = line; y > 0; y--) {
        for (int x = 0; x < width; x++) {
          _grid[y][x] = _grid[y - 1][x];
          _colorGrid[y][x] = _colorGrid[y - 1][x];
        }
      }
      // Clear top row
      for (int x = 0; x < width; x++) {
        _grid[0][x] = false;
        _colorGrid[0][x] = 0;
      }
    }
  }

  /// Place piece on board
  void placePiece(Piece piece) {
    for (final block in piece.blocks) {
      final x = piece.x + block.dx;
      final y = piece.y + block.dy;
      if (x >= 0 && x < width && y >= 0 && y < height) {
        _grid[y][x] = true;
        _colorGrid[y][x] = piece.color;
      }
    }
  }

  /// Check if piece collides with board
  bool collides(Piece piece, {int dx = 0, int dy = 0}) {
    for (final block in piece.blocks) {
      final x = piece.x + block.dx + dx;
      final y = piece.y + block.dy + dy;

      if (x < 0 || x >= width) return true;
      if (y >= height) return true;
      if (y >= 0 && _grid[y][x]) return true;
    }
    return false;
  }

  /// Get ghost piece drop distance
  int getGhostDropDistance(Piece piece) {
    int distance = 0;
    while (!collides(piece, dy: distance + 1)) {
      distance++;
    }
    return distance;
  }

  /// Check if game over (piece spawns in occupied space)
  bool isGameOver(Piece piece) {
    for (final block in piece.blocks) {
      final x = piece.x + block.dx;
      final y = piece.y + block.dy;
      if (y >= 0 && y < height && x >= 0 && x < width && _grid[y][x]) {
        return true;
      }
    }
    return false;
  }

  /// Get column heights for AI/evaluation
  List<int> getColumnHeights() {
    final heights = <int>[];
    for (int x = 0; x < width; x++) {
      int height = 0;
      for (int y = 0; y < this.height; y++) {
        if (_grid[y][x]) {
          height = this.height - y;
          break;
        }
      }
      heights.add(height);
    }
    return heights;
  }

  /// Count holes (empty cells with filled cells above)
  int countHoles() {
    int holes = 0;
    for (int x = 0; x < width; x++) {
      bool foundBlock = false;
      for (int y = 0; y < height; y++) {
        if (_grid[y][x]) {
          foundBlock = true;
        } else if (foundBlock) {
          holes++;
        }
      }
    }
    return holes;
  }

  /// Count complete lines
  int countCompleteLines() {
    int count = 0;
    for (int y = 0; y < height; y++) {
      if (isRowFull(y)) count++;
    }
    return count;
  }

  /// Get bumpiness (sum of height differences between adjacent columns)
  int getBumpiness() {
    final heights = getColumnHeights();
    int bumpiness = 0;
    for (int i = 0; i < width - 1; i++) {
      bumpiness += (heights[i] - heights[i + 1]).abs();
    }
    return bumpiness;
  }

  /// Get aggregate height
  int getAggregateHeight() {
    return getColumnHeights().reduce((a, b) => a + b);
  }

  /// Create deep copy
  Board copy() => Board.fromState(grid: _grid, colorGrid: _colorGrid);

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Board:');
    for (int y = 0; y < height; y++) {
      buffer.write('|');
      for (int x = 0; x < width; x++) {
        buffer.write(_grid[y][x] ? '#' : '.');
      }
      buffer.writeln('|');
    }
    return buffer.toString();
  }
}