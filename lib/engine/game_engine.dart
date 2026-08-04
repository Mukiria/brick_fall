// lib/engine/game_engine.dart
/// GameEngine - Main coordinator, pure Dart game logic

import 'types.dart';
import 'constants.dart';
import 'board.dart';
import 'piece.dart';
import 'piece_generator.dart';
import 'placement_validator.dart';
import 'score_engine.dart';
import 'combo_engine.dart';
import 'statistics_engine.dart';
import 'turn_manager.dart';
import 'game_state.dart';

class GameEngine {
  // Core components
  final Board _board;
  final PieceGenerator _pieceGenerator;
  final PlacementValidator _validator;
  final ScoreEngine _scoreEngine;
  final ComboEngine _comboEngine;
  final StatisticsEngine _statisticsEngine;
  final TurnManager _turnManager;
  
  // Game state
  GameState _state;
  
  // Callbacks
  void Function(GameState)? _onStateChange;
  void Function(List<int>)? _onLinesCleared;
  void Function(int)? _onScoreChange;
  void Function()? _onGameOver;
  void Function(int)? _onLevelUp;
  void Function(bool)? _onTSpin;

  GameEngine({
    Difficulty difficulty = Difficulty.normal,
    int highScore = 0,
    int? rngSeed,
  })  : _board = Board(),
        _pieceGenerator = PieceGenerator(seed: rngSeed),
        _validator = const PlacementValidator(),
        _scoreEngine = const ScoreEngine(),
        _comboEngine = ComboEngine(),
        _statisticsEngine = StatisticsEngine(),
        _turnManager = TurnManager(seed: rngSeed),
        _state = GameState.initial(
          difficulty: difficulty,
          highScore: highScore,
          rngSeed: rngSeed,
        ) {
    // Initialize with first pieces
    _state = _state.copyWith(
      turnManager: _turnManager,
    );
  }

  // Public getters
  GameState get state => _state;
  Board get board => _board;
  TurnManager get turnManager => _turnManager;
  ScoreEngine get scoreEngine => _scoreEngine;
  ComboEngine get comboEngine => _comboEngine;
  StatisticsEngine get statisticsEngine => _statisticsEngine;

  // Callback setters
  void setOnStateChange(void Function(GameState) callback) => _onStateChange = callback;
  void setOnLinesCleared(void Function(List<int>) callback) => _onLinesCleared = callback;
  void setOnScoreChange(void Function(int) callback) => _onScoreChange = callback;
  void setOnGameOver(void Function() callback) => _onGameOver = callback;
  void setOnLevelUp(void Function(int) callback) => _onLevelUp = callback;
  void setOnTSpin(void Function(bool) callback) => _onTSpin = callback;

  /// Start new game
  void start({Difficulty? difficulty}) {
    _resetGame(difficulty: difficulty ?? _state.difficulty);
    _state = _state.copyWith(
      status: GameStateStatus.playing,
      startTime: DateTime.now(),
      turnManager: _turnManager,
    );
    _notifyStateChange();
  }

  /// Pause game
  void pause() {
    if (_state.status == GameStateStatus.playing) {
      _state = _state.copyWith(status: GameStateStatus.paused);
      _notifyStateChange();
    }
  }

  /// Resume game
  void resume() {
    if (_state.status == GameStateStatus.paused) {
      _state = _state.copyWith(status: GameStateStatus.playing);
      _notifyStateChange();
    }
  }

  /// Move left
  void moveLeft() {
    if (!_state.isActive) return;
    _executeMove(MoveDirection.left);
  }

  /// Move right
  void moveRight() {
    if (!_state.isActive) return;
    _executeMove(MoveDirection.right);
  }

  /// Move down (soft drop)
  void moveDown() {
    if (!_state.isActive) return;
    _executeMove(MoveDirection.down);
  }

  /// Hard drop
  void hardDrop() {
    if (!_state.isActive) return;
    _executeHardDrop();
  }

  /// Rotate clockwise
  void rotateClockwise() {
    if (!_state.isActive) return;
    _executeRotate(RotationDirection.clockwise);
  }

  /// Rotate counter-clockwise
  void rotateCounterClockwise() {
    if (!_state.isActive) return;
    _executeRotate(RotationDirection.counterClockwise);
  }

  /// Hold piece
  void hold() {
    if (!_state.isActive) return;
    _executeHold();
  }

  /// Tick - called periodically by game loop
  void tick() {
    if (!_state.isActive) return;
    
    // Update lock delay
    _turnManager.updateLockDelay(16); // ~60fps
    
    // Auto-move down if piece is not locked
    if (!_turnManager.isPieceLocked) {
      final result = _turnManager.tryMove(_board, MoveDirection.down);
      if (!result.success) {
        // Piece hit bottom, lock it
        _lockPiece();
      }
    } else {
      // Lock delay expired, force lock
      _lockPiece();
    }
    
    _state = _state.copyWith(
      elapsedTime: _state.elapsedTime + const Duration(milliseconds: 16),
    );
    _notifyStateChange();
  }

  /// Get current tick rate
  Duration getTickRate() {
    return _scoreEngine.getTickRate(_state.level, _state.difficulty);
  }

  /// Get ghost piece
  Piece? getGhostPiece() {
    return _turnManager.getGhostPiece(_board);
  }

  /// Get current piece
  Piece? get currentPiece => _turnManager.currentPiece;

  /// Get next piece
  Piece? get nextPiece => _turnManager.nextPiece;

  /// Get held piece
  Piece? get heldPiece => _turnManager.heldPiece;

  /// Check if can hold
  bool get canHold => _turnManager.canHold;

  /// Get score
  int get score => _state.score;

  /// Get high score
  int get highScore => _state.highScore;

  /// Get level
  int get level => _state.level;

  /// Get lines cleared this game
  int get linesCleared => _state.linesCleared;

  /// Get total lines cleared
  int get totalLinesCleared => _state.totalLinesCleared;

  /// Get combo
  int get combo => _comboEngine.combo;

  /// Get elapsed time
  Duration get elapsedTime => _state.elapsedTime;

  /// Get status
  GameStateStatus get status => _state.status;

  /// Get difficulty
  Difficulty get difficulty => _state.difficulty;

  // Private methods

  void _resetGame({required Difficulty difficulty}) {
    for (final row in _board.grid) {
      row.fillRange(0, GameConstants.boardWidth, false);
    }
    for (final row in _board.colorGrid) {
      row.fillRange(0, GameConstants.boardWidth, 0);
    }
    _pieceGenerator.reset();
    _comboEngine.reset();
    _turnManager.reset();
    _statisticsEngine.resetSession();
    
    _state = GameState.initial(
      difficulty: difficulty,
      highScore: _state.highScore,
    );
  }

  void _executeMove(MoveDirection direction) {
    final result = _turnManager.tryMove(_board, direction);
    if (result.success) {
      _state = _state.copyWith(
        turnManager: _turnManager,
        pieceId: _state.pieceId + 1,
      ).addAction(_directionToAction(direction));
      _notifyStateChange();
    }
  }

  void _executeHardDrop() {
    final result = _turnManager.hardDrop(_board);
    if (result.success) {
      _state = _state.copyWith(
        turnManager: _turnManager,
        pieceId: _state.pieceId + 1,
      ).addAction(GameAction.hardDrop);
      _notifyStateChange();
      // Immediately lock
      _lockPiece();
    }
  }

  void _executeRotate(RotationDirection direction) {
    final result = _turnManager.tryRotate(_board, direction);
    if (result.success) {
      _state = _state.copyWith(
        turnManager: _turnManager,
        pieceId: _state.pieceId + 1,
      ).addAction(direction == RotationDirection.clockwise 
          ? GameAction.rotateCW 
          : GameAction.rotateCCW);
      _notifyStateChange();
    }
  }

  void _executeHold() {
    final result = _turnManager.hold();
    if (result.success) {
      _state = _state.copyWith(
        turnManager: _turnManager,
      ).addAction(GameAction.hold);
      _notifyStateChange();
    }
  }

  void _lockPiece() {
    final result = _turnManager.lockPiece(_board);
    
    if (result.gameOver) {
      _gameOver();
      return;
    }

    if (result.clearedLines.isNotEmpty) {
      _processLineClear(result.clearedLines);
    } else {
      _comboEngine.reset();
    }

    _state = _state.copyWith(
      board: _board.copy(),
      turnManager: _turnManager,
      pieceId: _state.pieceId + 1,
    );
    _notifyStateChange();
  }

  void _processLineClear(List<int> lines) {
    final linesCleared = lines.length;
    final clearType = LineClearType.fromCount(linesCleared);
    
    // Check for T-spin
    final currentPiece = _turnManager.currentPiece;
    bool isTSpin = false;
    bool isMiniTSpin = false;
    
    if (currentPiece?.type == PieceType.T) {
      isTSpin = _validator.isTSpin(_board, currentPiece!, null);
      isMiniTSpin = _validator.isMiniTSpin(_board, currentPiece!, null);
    }

    // Calculate score
    final scoreBreakdown = _scoreEngine.getBreakdown(
      linesCleared: linesCleared,
      level: _state.level,
      combo: _comboEngine.combo,
      isTSpin: isTSpin,
      isMiniTSpin: isMiniTSpin,
    );

    // Update combo
    final comboResult = _comboEngine.processClear(
      linesCleared: linesCleared,
      isTSpin: isTSpin,
      isMiniTSpin: isMiniTSpin,
    );

    // Calculate total score addition
    int scoreAddition = scoreBreakdown.total;
    if (comboResult.isBackToBack) {
      scoreAddition = (scoreAddition * 1.5).round(); // Back-to-back bonus
    }

    // Update state
    final newScore = _state.score + scoreAddition;
    final newTotalLines = _state.totalLinesCleared + linesCleared;
    final newLevel = _scoreEngine.calculateLevel(newTotalLines);
    final leveledUp = newLevel > _state.level;

    _state = _state.copyWith(
      score: newScore,
      highScore: newScore > _state.highScore ? newScore : _state.highScore,
      level: newLevel,
      linesCleared: linesCleared,
      totalLinesCleared: newTotalLines,
      comboEngine: _comboEngine,
      turnManager: _turnManager,
    );

    // Notify callbacks
    _onLinesCleared?.call(lines);
    _onScoreChange?.call(newScore);
    if (leveledUp) _onLevelUp?.call(newLevel);
    if (isTSpin || isMiniTSpin) _onTSpin?.call(true);

    _notifyStateChange();
  }

  void _gameOver() {
    _state = _state.copyWith(
      status: GameStateStatus.gameOver,
      board: _board.copy(),
      turnManager: _turnManager,
    );
    
    // Record statistics
    _statisticsEngine.recordGame(
      score: _state.score,
      linesCleared: _state.totalLinesCleared,
      levelReached: _state.level,
      playTime: _state.elapsedTime,
      difficulty: _state.difficulty,
      pieceUsage: _statisticsEngine.sessionPieceCounts,
    );

    _onGameOver?.call();
    _notifyStateChange();
  }

  void _notifyStateChange() {
    _onStateChange?.call(_state);
  }

  GameAction _directionToAction(MoveDirection direction) {
    switch (direction) {
      case MoveDirection.left: return GameAction.moveLeft;
      case MoveDirection.right: return GameAction.moveRight;
      case MoveDirection.down: return GameAction.moveDown;
      case MoveDirection.drop: return GameAction.hardDrop;
    }
  }

  /// Serialize game state for save/replay
  Map<String, dynamic> toJson() => _state.toJson();

  /// Load game state
  void fromJson(Map<String, dynamic> json) {
    _state = GameState.fromJson(json);
    // Note: Board and engines would need to be restored from state
    // This is a simplified version - full restore requires more work
  }

  /// Reset to initial state
  void reset() {
    _resetGame(difficulty: _state.difficulty);
    _state = _state.copyWith(
      status: GameStateStatus.idle,
      turnManager: _turnManager,
    );
    _notifyStateChange();
  }
}