import 'dart:math';
import '../models/models.dart';
import '../core/constants/app_constants.dart';

class GameEngine {
  final Random _random = Random();
  final List<BrickType> _bag = [];
  BrickType? _lastType;

  GameEngine() {
    _refillBag();
  }

  void _refillBag() {
    _bag.clear();
    _bag.addAll(BrickType.values);
    _bag.shuffle(_random);
    
    // Ensure we don't get the same piece twice in a row
    if (_lastType != null && _bag.first == _lastType && _bag.length > 1) {
      final temp = _bag[0];
      _bag[0] = _bag[1];
      _bag[1] = temp;
    }
  }

  BrickType getNextType() {
    if (_bag.isEmpty) {
      _refillBag();
    }
    final type = _bag.removeAt(0);
    _lastType = type;
    return type;
  }

  Brick createBrick(BrickType type) {
    return Brick.create(type);
  }

  List<int> checkLines(List<List<bool>> grid) {
    final clearedLines = <int>[];
    for (int y = AppConstants.gameHeight - 1; y >= 0; y--) {
      bool full = true;
      for (int x = 0; x < AppConstants.gameWidth; x++) {
        if (!grid[y][x]) {
          full = false;
          break;
        }
      }
      if (full) {
        clearedLines.add(y);
      }
    }
    return clearedLines;
  }

  void clearLines(List<List<bool>> grid, List<List<int>> gridColors, List<int> lines) {
    for (final line in lines) {
      for (int y = line; y > 0; y--) {
        for (int x = 0; x < AppConstants.gameWidth; x++) {
          grid[y][x] = grid[y - 1][x];
          gridColors[y][x] = gridColors[y - 1][x];
        }
      }
      for (int x = 0; x < AppConstants.gameWidth; x++) {
        grid[0][x] = false;
        gridColors[0][x] = 0;
      }
    }
  }

  bool isGameOver(List<List<bool>> grid, Brick brick) {
    for (final block in brick.blocks) {
      if (block.y < 0 && grid[0][block.x]) return true;
      if (block.y >= 0 && grid[block.y][block.x]) return true;
    }
    return false;
  }

  bool checkCollision(Brick brick, List<List<bool>> grid, {int dx = 0, int dy = 0}) {
    for (final block in brick.blocks) {
      final newX = block.x + dx;
      final newY = block.y + dy;
      
      if (newX < 0 || newX >= AppConstants.gameWidth) return true;
      if (newY >= AppConstants.gameHeight) return true;
      if (newY >= 0 && grid[newY][newX]) return true;
    }
    return false;
  }

  Brick tryRotate(Brick brick, List<List<bool>> grid, bool clockwise) {
    final rotated = clockwise ? brick.rotateClockwise() : brick.rotateCounterClockwise();
    
    // Wall kicks
    final kicks = _getWallKicks(brick.type);
    for (final kick in kicks) {
      final kicked = Brick(
        type: rotated.type,
        blocks: rotated.blocks.map((b) => b.translate(kick.x, kick.y)).toList(),
        pivot: rotated.pivot.translate(kick.x, kick.y),
        colorValue: rotated.colorValue,
      );
      if (!checkCollision(kicked, grid)) {
        return kicked;
      }
    }
    return brick;
  }

  List<Position> _getWallKicks(BrickType type) {
    if (type == BrickType.i) {
      return [
        const Position(0, 0),
        const Position(-2, 0),
        const Position(1, 0),
        const Position(-2, -1),
        const Position(1, 2),
      ];
    }
    return [
      const Position(0, 0),
      const Position(-1, 0),
      const Position(1, 0),
      const Position(-2, 0),
      const Position(2, 0),
      const Position(-1, -1),
      const Position(1, -1),
      const Position(-2, -1),
      const Position(2, -1),
    ];
  }

  List<Position> getGhostPosition(Brick brick, List<List<bool>> grid) {
    var ghostBrick = brick;
    while (!checkCollision(ghostBrick, grid, dy: 1)) {
      ghostBrick = ghostBrick.move(Direction.down);
    }
    return ghostBrick.blocks;
  }

  int calculateLevel(int totalLinesCleared) {
    return (totalLinesCleared ~/ AppConstants.linesPerLevel) + 1;
  }

  Duration getTickRate(int level, Difficulty difficulty) {
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

  void resetBag() {
    _bag.clear();
    _lastType = null;
    _refillBag();
  }
}