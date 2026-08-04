import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'position.dart';
import '../core/constants/game_constants.dart';
import '../core/constants/app_constants.dart';
import '../models/models.dart';

part 'brick.g.dart';

@HiveType(typeId: 1)
class Brick extends Equatable {
  @HiveField(0)
  final BrickType type;

  @HiveField(1)
  final List<Position> blocks;

  @HiveField(2)
  final Position pivot;

  @HiveField(3)
  final int colorValue;

  const Brick({
    required this.type,
    required this.blocks,
    required this.pivot,
    required this.colorValue,
  });

  Color get color => Color(colorValue);

  factory Brick.create(BrickType type, {int startX = 3, int startY = 0}) {
    final List<Position> blocks;
    final Position pivot;
    final int colorValue = GameConstants.tetrominoColors[type.index].value;

    switch (type) {
      case BrickType.i:
        blocks = [
          Position(startX, startY),
          Position(startX + 1, startY),
          Position(startX + 2, startY),
          Position(startX + 3, startY),
        ];
        pivot = Position(startX + 1, startY);
        break;
      case BrickType.j:
        blocks = [
          Position(startX, startY),
          Position(startX, startY + 1),
          Position(startX + 1, startY + 1),
          Position(startX + 2, startY + 1),
        ];
        pivot = Position(startX + 1, startY + 1);
        break;
      case BrickType.l:
        blocks = [
          Position(startX + 2, startY),
          Position(startX, startY + 1),
          Position(startX + 1, startY + 1),
          Position(startX + 2, startY + 1),
        ];
        pivot = Position(startX + 1, startY + 1);
        break;
      case BrickType.o:
        blocks = [
          Position(startX, startY),
          Position(startX + 1, startY),
          Position(startX, startY + 1),
          Position(startX + 1, startY + 1),
        ];
        pivot = Position(startX + 1, startY + 1);
        break;
      case BrickType.s:
        blocks = [
          Position(startX + 1, startY),
          Position(startX + 2, startY),
          Position(startX, startY + 1),
          Position(startX + 1, startY + 1),
        ];
        pivot = Position(startX + 1, startY + 1);
        break;
      case BrickType.t:
        blocks = [
          Position(startX + 1, startY),
          Position(startX, startY + 1),
          Position(startX + 1, startY + 1),
          Position(startX + 2, startY + 1),
        ];
        pivot = Position(startX + 1, startY + 1);
        break;
      case BrickType.z:
        blocks = [
          Position(startX, startY),
          Position(startX + 1, startY),
          Position(startX + 1, startY + 1),
          Position(startX + 2, startY + 1),
        ];
        pivot = Position(startX + 1, startY + 1);
        break;
    }

    return Brick(type: type, blocks: blocks, pivot: pivot, colorValue: colorValue);
  }

  Brick rotateClockwise() {
    if (type == BrickType.o) return this;

    final rotatedBlocks = blocks.map((block) {
      final dx = block.x - pivot.x;
      final dy = block.y - pivot.y;
      return Position(pivot.x - dy, pivot.y + dx);
    }).toList();

    return Brick(
      type: type,
      blocks: rotatedBlocks,
      pivot: pivot,
      colorValue: colorValue,
    );
  }

  Brick rotateCounterClockwise() {
    if (type == BrickType.o) return this;

    final rotatedBlocks = blocks.map((block) {
      final dx = block.x - pivot.x;
      final dy = block.y - pivot.y;
      return Position(pivot.x + dy, pivot.y - dx);
    }).toList();

    return Brick(
      type: type,
      blocks: rotatedBlocks,
      pivot: pivot,
      colorValue: colorValue,
    );
  }

  Brick move(Direction direction) {
    int dx = 0, dy = 0;
    switch (direction) {
      case Direction.left:
        dx = -1;
        break;
      case Direction.right:
        dx = 1;
        break;
      case Direction.down:
        dy = 1;
        break;
      case Direction.rotate:
        return rotateClockwise();
      case Direction.drop:
        return this;
    }

    return Brick(
      type: type,
      blocks: blocks.map((b) => b.translate(dx, dy)).toList(),
      pivot: pivot.translate(dx, dy),
      colorValue: colorValue,
    );
  }

  Brick hardDrop(List<List<bool>> grid) {
    var newBrick = this;
    while (canMove(newBrick.move(Direction.down), grid)) {
      newBrick = newBrick.move(Direction.down);
    }
    return newBrick;
  }

  bool canMove(Brick newBrick, List<List<bool>> grid) {
    for (final block in newBrick.blocks) {
      if (block.x < 0 || block.x >= AppConstants.gameWidth) return false;
      if (block.y >= AppConstants.gameHeight) return false;
      if (block.y >= 0 && grid[block.y][block.x]) return false;
    }
    return true;
  }

  List<Position> getGhostPosition(List<List<bool>> grid) {
    var ghostBrick = this;
    while (canMove(ghostBrick.move(Direction.down), grid)) {
      ghostBrick = ghostBrick.move(Direction.down);
    }
    return ghostBrick.blocks;
  }

  @override
  List<Object?> get props => [type, blocks, pivot, colorValue];
}