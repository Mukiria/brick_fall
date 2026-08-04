// lib/engine/placement_validator.dart
/// PlacementValidator - Collision detection, wall kicks, valid placements

import 'constants.dart';
import 'types.dart';
import 'board.dart';
import 'piece.dart';

class PlacementValidator {
  const PlacementValidator();

  /// Check if piece can be placed at position
  PlacementResult canPlace(Board board, Piece piece, {int dx = 0, int dy = 0}) {
    final newX = piece.x + dx;
    final newY = piece.y + dy;

    // Check bounds
    for (final block in piece.blocks) {
      final x = newX + block.dx;
      final y = newY + block.dy;

      if (x < 0 || x >= GameConstants.boardWidth) {
        return PlacementResult.outOfBounds;
      }
      if (y >= GameConstants.boardHeight) {
        return PlacementResult.collision;
      }
      if (y >= 0 && board.isOccupied(x, y)) {
        return PlacementResult.collision;
      }
    }

    // Check if piece would spawn in occupied space (game over)
    if (piece.y < 0 && dy <= 0) {
      for (final block in piece.blocks) {
        final x = newX + block.dx;
        final y = newY + block.dy;
        if (y >= 0 && board.isOccupied(x, y)) {
          return PlacementResult.gameOver;
        }
      }
    }

    return PlacementResult.success;
  }

  /// Try to rotate piece with wall kicks (SRS)
  Piece? tryRotate(Board board, Piece piece, RotationDirection direction) {
    final rotated = direction == RotationDirection.clockwise
        ? piece.rotateClockwise()
        : piece.rotateCounterClockwise();

    // No wall kicks needed for O piece
    if (piece.isSquare) {
      return canPlace(board, rotated) == PlacementResult.success ? rotated : null;
    }

    // Get wall kick data
    final kicks = GameConstants.wallKicks[piece.type]!;
    final isClockwise = direction == RotationDirection.clockwise;

    // Try each kick
    for (final kick in kicks) {
      final kickedX = rotated.x + (isClockwise ? kick.dx : -kick.dx);
      final kickedY = rotated.y + kick.dy;

      final kickedPiece = Piece(
        type: rotated.type,
        x: kickedX,
        y: kickedY,
        rotation: rotated.rotation,
        color: rotated.color,
        id: rotated.id,
      );

      if (canPlace(board, kickedPiece) == PlacementResult.success) {
        return kickedPiece;
      }
    }

    return null;
  }

  /// Get all valid positions for a piece (for AI)
  List<Piece> getValidPlacements(Board board, Piece piece) {
    final placements = <Piece>[];
    
    // Try all rotations
    for (int rot = 0; rot < 4; rot++) {
      var rotated = piece;
      for (int i = 0; i < rot; i++) {
        rotated = rotated.rotateClockwise();
      }

      // Try all horizontal positions
      for (int x = -2; x <= GameConstants.boardWidth; x++) {
        final testPiece = Piece(
          type: rotated.type,
          x: x,
          y: rotated.y,
          rotation: rotated.rotation,
          color: rotated.color,
          id: rotated.id,
        );

        // Hard drop to find landing position
        final ghost = hardDrop(board, testPiece);
        
        if (canPlace(board, ghost) == PlacementResult.success) {
          placements.add(ghost);
        }
      }
    }

    return placements;
  }

  /// Get all valid rotations at current x position
  List<Piece> getValidRotations(Board board, Piece piece) {
    final rotations = <Piece>[];
    var current = piece;
    
    for (int i = 0; i < 4; i++) {
      if (canPlace(board, current) == PlacementResult.success) {
        rotations.add(current);
      }
      current = current.rotateClockwise();
    }
    
    return rotations;
  }

  /// Hard drop - returns piece at lowest valid position
  Piece hardDrop(Board board, Piece piece) {
    int dropY = piece.y;
    while (canPlace(board, piece.moveBy(0, dropY - piece.y + 1)) == PlacementResult.success) {
      dropY++;
    }
    return piece.moveBy(0, dropY - piece.y);
  }

  /// Check if piece is on ground (can't move down)
  bool isOnGround(Board board, Piece piece) {
    return canPlace(board, piece, dy: 1) != PlacementResult.success;
  }

  /// Check if piece can move left
  bool canMoveLeft(Board board, Piece piece) {
    return canPlace(board, piece, dx: -1) == PlacementResult.success;
  }

  /// Check if piece can move right
  bool canMoveRight(Board board, Piece piece) {
    return canPlace(board, piece, dx: 1) == PlacementResult.success;
  }

  /// Check if piece can move down
  bool canMoveDown(Board board, Piece piece) {
    return canPlace(board, piece, dy: 1) == PlacementResult.success;
  }

  /// Get lock delay (time piece can move before locking)
  int getLockDelay(Board board, Piece piece, int moveCount) {
    // Standard Tetris: 0.5s lock delay, resets on move/rotate (max 15 resets)
    const baseDelayMs = 500;
    const maxResets = 15;
    
    if (moveCount >= maxResets) return 0;
    return baseDelayMs;
  }

  /// Check for T-spin (T piece with 3+ corners filled)
  bool isTSpin(Board board, Piece piece, RotationDirection? lastRotation) {
    if (piece.type != PieceType.T || lastRotation == null) return false;
    
    // Check 4 corners around T piece center
    int filledCorners = 0;
    final corners = [
      Offset(piece.x - 1, piece.y - 1),
      Offset(piece.x + 1, piece.y - 1),
      Offset(piece.x - 1, piece.y + 1),
      Offset(piece.x + 1, piece.y + 1),
    ];

    for (final corner in corners) {
      if (corner.dy < 0 || board.isOccupied(corner.dx, corner.dy)) {
        filledCorners++;
      }
    }

    return filledCorners >= 3;
  }

  /// Check for mini T-spin (T piece with 2 corners filled on one side)
  bool isMiniTSpin(Board board, Piece piece, RotationDirection? lastRotation) {
    if (piece.type != PieceType.T || lastRotation == null) return false;
    
    // Check front two corners (relative to rotation)
    int filledCorners = 0;
    final frontCorners = switch (piece.rotation) {
      0 => [Offset(piece.x - 1, piece.y - 1), Offset(piece.x + 1, piece.y - 1)],
      1 => [Offset(piece.x + 1, piece.y - 1), Offset(piece.x + 1, piece.y + 1)],
      2 => [Offset(piece.x - 1, piece.y + 1), Offset(piece.x + 1, piece.y + 1)],
      3 => [Offset(piece.x - 1, piece.y - 1), Offset(piece.x - 1, piece.y + 1)],
      _ => <Offset>[],
    };

    for (final corner in frontCorners) {
      if (corner.dy < 0 || board.isOccupied(corner.dx, corner.dy)) {
        filledCorners++;
      }
    }

    return filledCorners >= 2;
  }
}