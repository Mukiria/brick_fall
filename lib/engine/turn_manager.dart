// lib/engine/turn_manager.dart
/// TurnManager - Manages piece spawning, hold, turn flow

import 'types.dart';
import 'piece.dart';
import 'piece_generator.dart';
import 'board.dart';
import 'placement_validator.dart';

class TurnManager {
  final PieceGenerator _generator;
  final PlacementValidator _validator = const PlacementValidator();
  
  Piece? _currentPiece;
  Piece? _nextPiece;
  Piece? _heldPiece;
  bool _canHold = true;
  int _pieceId = 0;
  int _moveCount = 0;
  int _lockDelayRemaining = 0;
  bool _isPieceLocked = false;

  TurnManager({int? seed}) : _generator = PieceGenerator(seed: seed) {
    _spawnInitialPieces();
  }

  void _spawnInitialPieces() {
    _currentPiece = _generator.nextPiece();
    _nextPiece = _generator.nextPiece();
    _heldPiece = null;
    _canHold = true;
    _moveCount = 0;
    _lockDelayRemaining = 0;
    _isPieceLocked = false;
  }

  // Getters
  Piece? get currentPiece => _currentPiece;
  Piece? get nextPiece => _nextPiece;
  Piece? get heldPiece => _heldPiece;
  bool get canHold => _canHold;
  int get moveCount => _moveCount;
  int get lockDelayRemaining => _lockDelayRemaining;
  bool get isPieceLocked => _isPieceLocked;

  /// Get ghost piece position
  Piece? getGhostPiece(Board board) {
    if (_currentPiece == null) return null;
    return _validator.isOnGround(board, _currentPiece!) 
        ? _currentPiece 
        : _validator.hardDrop(board, _currentPiece!);
  }

  /// Try to move current piece
  MoveResult tryMove(Board board, MoveDirection direction) {
    if (_currentPiece == null || _isPieceLocked) {
      return MoveResult.failure('No active piece');
    }

    final moved = _currentPiece!.move(direction);
    final result = _validator.canPlace(board, moved);
    
    if (result == PlacementResult.success) {
      _currentPiece = moved;
      _moveCount++;
      _lockDelayRemaining = 500; // Reset lock delay
      return MoveResult.success(_currentPiece!);
    }
    
    return MoveResult.failure(result.name);
  }

  /// Try to rotate current piece
  MoveResult tryRotate(Board board, RotationDirection direction) {
    if (_currentPiece == null || _isPieceLocked) {
      return MoveResult.failure('No active piece');
    }

    final rotated = _validator.tryRotate(board, _currentPiece!, direction);
    
    if (rotated != null) {
      _currentPiece = rotated;
      _moveCount++;
      _lockDelayRemaining = 500; // Reset lock delay
      return MoveResult.success(_currentPiece!);
    }
    
    return MoveResult.failure('Rotation blocked');
  }

  /// Hard drop
  MoveResult hardDrop(Board board) {
    if (_currentPiece == null || _isPieceLocked) {
      return MoveResult.failure('No active piece');
    }

    final dropped = _validator.hardDrop(board, _currentPiece!);
    _currentPiece = dropped;
    _isPieceLocked = true;
    return MoveResult.success(_currentPiece!, isHardDrop: true);
  }

  /// Hold current piece
  HoldResult hold() {
    if (!_canHold || _currentPiece == null) {
      return HoldResult.failure('Hold not available');
    }

    Piece? newHeld;
    Piece? newCurrent;

    if (_heldPiece == null) {
      newHeld = _currentPiece;
      _spawnNext();
      newCurrent = _currentPiece;
    } else {
      newHeld = _currentPiece;
      newCurrent = Piece.spawn(_heldPiece!.type);
    }

    _heldPiece = newHeld;
    _currentPiece = newCurrent;
    _canHold = false;
    _moveCount = 0;
    _lockDelayRemaining = 0;

    return HoldResult.success(
      held: newHeld!,
      current: newCurrent!,
      next: _nextPiece!,
    );
  }

  /// Lock current piece and spawn next
  LockResult lockPiece(Board board) {
    if (_currentPiece == null) {
      return LockResult.failure('No piece to lock');
    }

    if (!_validator.isOnGround(board, _currentPiece!)) {
      return LockResult.failure('Piece not on ground');
    }

    // Place piece on board
    board.placePiece(_currentPiece!);
    
    // Check lines
    final clearedLines = board.findFullLines();
    
    // Spawn next piece
    _spawnNext();
    
    // Check game over
    if (_currentPiece != null && board.isGameOver(_currentPiece!)) {
      return LockResult.gameOver(clearedLines);
    }

    _canHold = true;
    _moveCount = 0;
    _lockDelayRemaining = 0;
    _isPieceLocked = false;

    return LockResult.success(clearedLines);
  }

  /// Update lock delay timer
  void updateLockDelay(int deltaMs) {
    if (_lockDelayRemaining > 0) {
      _lockDelayRemaining = (_lockDelayRemaining - deltaMs).clamp(0, 500);
      if (_lockDelayRemaining == 0 && _currentPiece != null) {
        _isPieceLocked = true;
      }
    }
  }

  void _spawnNext() {
    _currentPiece = _nextPiece;
    _nextPiece = _generator.nextPiece();
    _pieceId++;
  }

  /// Reset for new game
  void reset({int? seed}) {
    if (seed != null) {
      // Can't reseed, but we can recreate
    }
    _generator.reset();
    _spawnInitialPieces();
  }

  /// Serialize
  Map<String, dynamic> toJson() => {
        'currentPiece': _currentPiece?.toJson(),
        'nextPiece': _nextPiece?.toJson(),
        'heldPiece': _heldPiece?.toJson(),
        'canHold': _canHold,
        'moveCount': _moveCount,
        'lockDelayRemaining': _lockDelayRemaining,
        'isPieceLocked': _isPieceLocked,
        'generator': _generator.toJson(),
      };

  /// Deserialize
  factory TurnManager.fromJson(Map<String, dynamic> json) {
    final manager = TurnManager();
    manager._currentPiece = json['currentPiece'] != null 
        ? Piece.fromJson(json['currentPiece'] as Map<String, dynamic>)
        : null;
    manager._nextPiece = json['nextPiece'] != null
        ? Piece.fromJson(json['nextPiece'] as Map<String, dynamic>)
        : null;
    manager._heldPiece = json['heldPiece'] != null
        ? Piece.fromJson(json['heldPiece'] as Map<String, dynamic>)
        : null;
    manager._canHold = json['canHold'] as bool;
    manager._moveCount = json['moveCount'] as int;
    manager._lockDelayRemaining = json['lockDelayRemaining'] as int;
    manager._isPieceLocked = json['isPieceLocked'] as bool;
    return manager;
  }

  /// Move piece to absolute position (for drag-and-drop)
  MoveResult moveToPosition(Board board, int x, int y) {
    if (_currentPiece == null || _isPieceLocked) {
      return MoveResult.failure('No active piece');
    }

    final moved = _currentPiece!.moveBy(x - _currentPiece!.x, y - _currentPiece!.y);
    final result = _validator.canPlace(board, moved);
    
    if (result == PlacementResult.success) {
      _currentPiece = moved;
      _moveCount++;
      _lockDelayRemaining = 500; // Reset lock delay
      return MoveResult.success(_currentPiece!);
    }
    
    return MoveResult.failure(result.name);
  }
}

/// Result of move attempt
class MoveResult {
  final bool success;
  final String? error;
  final Piece? piece;
  final bool isHardDrop;

  MoveResult._({
    required this.success,
    this.error,
    this.piece,
    this.isHardDrop = false,
  });

  factory MoveResult.success(Piece piece, {bool isHardDrop = false}) => MoveResult._(
        success: true,
        piece: piece,
        isHardDrop: isHardDrop,
      );

  factory MoveResult.failure(String error) => MoveResult._(
        success: false,
        error: error,
      );
}

/// Result of hold attempt
class HoldResult {
  final bool success;
  final String? error;
  final Piece? held;
  final Piece? current;
  final Piece? next;

  HoldResult._({
    required this.success,
    this.error,
    this.held,
    this.current,
    this.next,
  });

  factory HoldResult.success({
    required Piece held,
    required Piece current,
    required Piece next,
  }) => HoldResult._(
        success: true,
        held: held,
        current: current,
        next: next,
      );

  factory HoldResult.failure(String error) => HoldResult._(
        success: false,
        error: error,
      );
}

/// Result of piece lock
class LockResult {
  final bool success;
  final String? error;
  final List<int> clearedLines;
  final bool gameOver;

  LockResult._({
    required this.success,
    this.error,
    this.clearedLines = const [],
    this.gameOver = false,
  });

  factory LockResult.success(List<int> clearedLines) => LockResult._(
        success: true,
        clearedLines: clearedLines,
      );

  factory LockResult.failure(String error) => LockResult._(
        success: false,
        error: error,
      );

  factory LockResult.gameOver(List<int> clearedLines) => LockResult._(
        success: true,
        clearedLines: clearedLines,
        gameOver: true,
      );
}