// lib/engine/game_loop.dart
/// GameLoop - Bridges GameEngine with Flutter streams

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'game_engine.dart';
import 'types.dart' as engine_types;
import 'game_state.dart';
import 'piece.dart';
import 'board.dart';

class GameLoop extends ChangeNotifier {
  final GameEngine _engine;
  Timer? _timer;
  Duration _accumulatedTime = Duration.zero;
  DateTime? _lastFrameTime;
  bool _isRunning = false;

  final StreamController<GameState> _stateController = StreamController<GameState>.broadcast();
  Stream<GameState> get stateStream => _stateController.stream;

  final StreamController<List<int>> _lineClearController = StreamController<List<int>>.broadcast();
  Stream<List<int>> get lineClearStream => _lineClearController.stream;

  final StreamController<int> _scoreController = StreamController<int>.broadcast();
  Stream<int> get scoreStream => _scoreController.stream;

  final StreamController<void> _gameOverController = StreamController<void>.broadcast();
  Stream<void> get gameOverStream => _gameOverController.stream;

  final StreamController<int> _levelUpController = StreamController<int>.broadcast();
  Stream<int> get levelUpStream => _levelUpController.stream;

  final StreamController<bool> _tSpinController = StreamController<bool>.broadcast();
  Stream<bool> get tSpinStream => _tSpinController.stream;

  GameState _currentState;

  GameState get currentState => _currentState;

  GameLoop({
    engine_types.Difficulty difficulty = engine_types.Difficulty.normal,
    int highScore = 0,
  })  : _engine = GameEngine(
          difficulty: difficulty,
          highScore: highScore,
        ),
        _currentState = GameState.initial(
          difficulty: difficulty,
          highScore: highScore,
        ) {
    _setupCallbacks();
  }

  void _setupCallbacks() {
    _engine.setOnStateChange(_onStateChange);
    _engine.setOnLinesCleared(_onLinesCleared);
    _engine.setOnScoreChange(_onScoreChange);
    _engine.setOnGameOver(_onGameOver);
    _engine.setOnLevelUp(_onLevelUp);
    _engine.setOnTSpin(_onTSpin);
  }

  void _onStateChange(GameState state) {
    _currentState = state;
    _stateController.add(state);
    notifyListeners();
  }

  void _onLinesCleared(List<int> lines) {
    _lineClearController.add(lines);
  }

  void _onScoreChange(int score) {
    _scoreController.add(score);
  }

  void _onGameOver() {
    _isRunning = false;
    _timer?.cancel();
    _gameOverController.add(null);
  }

  void _onLevelUp(int level) {
    _levelUpController.add(level);
  }

  void _onTSpin(bool isTSpin) {
    _tSpinController.add(isTSpin);
  }

  /// Start new game
  void start({engine_types.Difficulty? difficulty}) {
    if (_isRunning) return;
    
    _engine.start(difficulty: difficulty);
    _currentState = _engine.state;
    
    _isRunning = true;
    _lastFrameTime = DateTime.now();
    _accumulatedTime = Duration.zero;
    _runLoop();
  }

  void _runLoop() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), _update);
  }

  void _update(Timer timer) {
    if (!_isRunning) {
      timer.cancel();
      return;
    }

    if (_currentState.status != engine_types.GameStateStatus.playing) return;

    final now = DateTime.now();
    final delta = now.difference(_lastFrameTime!);
    _lastFrameTime = now;

    _accumulatedTime += delta;
    final tickRate = _engine.getTickRate();

    if (_accumulatedTime >= tickRate) {
      _accumulatedTime = Duration.zero;
      _engine.tick();
    } else {
      // Still update elapsed time for smooth UI
      _engine.tick();
    }
  }

  /// Game controls
  void moveLeft() => _engine.moveLeft();
  void moveRight() => _engine.moveRight();
  void moveDown() => _engine.moveDown();
  void hardDrop() => _engine.hardDrop();
  void rotateClockwise() => _engine.rotateClockwise();
  void rotateCounterClockwise() => _engine.rotateCounterClockwise();
  void hold() => _engine.hold();

  void pause() {
    if (_currentState.status == engine_types.GameStateStatus.playing) {
      _isRunning = false;
      _engine.pause();
    }
  }

  void resume() {
    if (_currentState.status == engine_types.GameStateStatus.paused) {
      _isRunning = true;
      _lastFrameTime = DateTime.now();
      _engine.resume();
    }
  }

  /// Get ghost piece position
  List<engine_types.Offset> getGhostPosition() {
    final ghost = _engine.getGhostPiece();
    if (ghost == null) return [];
    return ghost.absoluteBlocks;
  }

  /// Get current piece
  Piece? get currentPiece => _engine.currentPiece;

  /// Get next piece
  Piece? get nextPiece => _engine.nextPiece;

  /// Get held piece
  Piece? get heldPiece => _engine.heldPiece;

  /// Get score
  int get score => _engine.score;

  /// Get high score
  int get highScore => _engine.highScore;

  /// Get level
  int get level => _engine.level;

  /// Get lines cleared
  int get linesCleared => _engine.linesCleared;

  /// Get total lines cleared
  int get totalLinesCleared => _engine.totalLinesCleared;

  /// Get combo
  int get combo => _engine.combo;

  /// Get elapsed time
  Duration get elapsedTime => _engine.elapsedTime;

  /// Get status
  engine_types.GameStateStatus get status => _engine.status;

  /// Get difficulty
  engine_types.Difficulty get difficulty => _engine.difficulty;

  /// Move piece to absolute position (for drag-and-drop)
  void moveToPosition(int x, int y) {
    _engine.moveToPosition(x, y);
  }

  /// Serialize for save
  Map<String, dynamic> toJson() => _engine.toJson();

  @override
  void dispose() {
    _isRunning = false;
    _timer?.cancel();
    _stateController.close();
    _lineClearController.close();
    _scoreController.close();
    _gameOverController.close();
    _levelUpController.close();
    _tSpinController.close();
    super.dispose();
  }
}