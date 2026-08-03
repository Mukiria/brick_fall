import 'dart:async';
import '../models/models.dart';
import '../core/constants/app_constants.dart';
import 'game_engine.dart';

class GameLoop {
  final GameEngine _engine = GameEngine();
  Timer? _timer;
  Duration _accumulatedTime = Duration.zero;
  Duration _lastUpdate = Duration.zero;
  bool _isRunning = false;

  final StreamController<GameState> _stateController = StreamController<GameState>.broadcast();
  Stream<GameState> get stateStream => _stateController.stream;

  final StreamController<List<int>> _lineClearController = StreamController<List<int>>.broadcast();
  Stream<List<int>> get lineClearStream => _lineClearController.stream;

  final StreamController<int> _scoreController = StreamController<int>.broadcast();
  Stream<int> get scoreStream => _scoreController.stream;

  final StreamController<void> _gameOverController = StreamController<void>.broadcast();
  Stream<void> get gameOverStream => _gameOverController.stream;

  GameState _currentState = GameState.initial();

  GameState get currentState => _currentState;

  void start({Difficulty? difficulty}) {
    if (_isRunning) return;
    
    _engine.resetBag();
    _currentState = GameState.initial(
      difficulty: difficulty ?? _currentState.difficulty,
      highScore: _currentState.highScore,
    );
    
    _spawnNewBrick();
    _currentState = _currentState.copyWith(
      state: CoreGameState.playing,
      startTime: DateTime.now(),
    );
    _stateController.add(_currentState);
    
    _isRunning = true;
    _lastUpdate = Duration.zero;
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

    final now = DateTime.now();
    final delta = now.difference(DateTime.now().subtract(_lastUpdate));
    _lastUpdate = now.difference(DateTime.now().subtract(_lastUpdate));

    if (_currentState.state != CoreGameState.playing) return;

    _accumulatedTime += delta;
    final tickRate = _engine.getTickRate(_currentState.level, _currentState.difficulty);

    if (_accumulatedTime >= tickRate) {
      _accumulatedTime = Duration.zero;
      _tick();
    }

    _currentState = _currentState.copyWith(
      elapsedTime: _currentState.elapsedTime + delta,
    );
    _stateController.add(_currentState);
  }

  void _tick() {
    if (_currentState.currentBrick == null) {
      _spawnNewBrick();
      return;
    }

    final movedBrick = _currentState.currentBrick!.move(Direction.down);
    
    if (_engine.checkCollision(movedBrick, _currentState.grid)) {
      _lockBrick();
    } else {
      _currentState = _currentState.copyWith(currentBrick: movedBrick);
      _stateController.add(_currentState);
    }
  }

  void _spawnNewBrick() {
    final nextType = _currentState.nextBrick?.type ?? _engine.getNextType();
    final newNextType = _engine.getNextType();
    
    final newBrick = _engine.createBrick(nextType);
    final nextBrick = _engine.createBrick(newNextType);

    if (_engine.isGameOver(_currentState.grid, newBrick)) {
      _gameOver();
      return;
    }

    _currentState = _currentState.copyWith(
      currentBrick: newBrick,
      nextBrick: nextBrick,
      canHold: true,
    );
  }

  void _lockBrick() {
    if (_currentState.currentBrick == null) return;

    final grid = List<List<bool>>.from(_currentState.grid.map((row) => List<bool>.from(row)));
    final gridColors = List<List<int>>.from(_currentState.gridColors.map((row) => List<int>.from(row)));
    
    final brick = _currentState.currentBrick!;
    for (final block in brick.blocks) {
      if (block.y >= 0 && block.y < AppConstants.gameHeight && block.x >= 0 && block.x < AppConstants.gameWidth) {
        grid[block.y][block.x] = true;
        gridColors[block.y][block.x] = brick.color.value;
      }
    }

    final clearedLines = _engine.checkLines(grid);
    var newScore = _currentState.score;
    var newCombo = _currentState.combo;
    var newLinesCleared = _currentState.linesCleared;
    var newTotalLinesCleared = _currentState.totalLinesCleared;

    if (clearedLines.isNotEmpty) {
      _engine.clearLines(grid, gridColors, clearedLines);
      newLinesCleared = clearedLines.length;
      newTotalLinesCleared = _currentState.totalLinesCleared + clearedLines.length;
      newScore += _currentState.calculateScore(clearedLines.length);
      newCombo = _currentState.combo + 1;
      _lineClearController.add(clearedLines);
      _scoreController.add(newScore);
    } else {
      newCombo = 0;
    }

    final newLevel = _engine.calculateLevel(newTotalLinesCleared);

    _currentState = _currentState.copyWith(
      grid: grid,
      gridColors: gridColors,
      currentBrick: null,
      score: newScore,
      linesCleared: newLinesCleared,
      totalLinesCleared: newTotalLinesCleared,
      combo: newCombo,
      level: newLevel,
      highScore: newScore > _currentState.highScore ? newScore : _currentState.highScore,
    );

    _spawnNewBrick();
    _stateController.add(_currentState);
  }

  void _gameOver() {
    _isRunning = false;
    _timer?.cancel();
    _currentState = _currentState.copyWith(state: CoreGameState.gameOver);
    _stateController.add(_currentState);
    _gameOverController.add(null);
  }

  void pause() {
    if (_currentState.state == CoreGameState.playing) {
      _isRunning = false;
      _currentState = _currentState.copyWith(state: CoreGameState.paused);
      _stateController.add(_currentState);
    }
  }

  void resume() {
    if (_currentState.state == CoreGameState.paused) {
      _isRunning = true;
      _lastUpdate = Duration.zero;
      _currentState = _currentState.copyWith(state: CoreGameState.playing);
      _stateController.add(_currentState);
    }
  }

  void moveLeft() {
    _move(Direction.left);
  }

  void moveRight() {
    _move(Direction.right);
  }

  void moveDown() {
    _move(Direction.down);
  }

  void rotate() {
    if (_currentState.currentBrick == null) return;
    
    final rotated = _engine.tryRotate(_currentState.currentBrick!, _currentState.grid, true);
    if (rotated != _currentState.currentBrick) {
      _currentState = _currentState.copyWith(currentBrick: rotated);
      _stateController.add(_currentState);
    }
  }

  void rotateCounterClockwise() {
    if (_currentState.currentBrick == null) return;
    
    final rotated = _engine.tryRotate(_currentState.currentBrick!, _currentState.grid, false);
    if (rotated != _currentState.currentBrick) {
      _currentState = _currentState.copyWith(currentBrick: rotated);
      _stateController.add(_currentState);
    }
  }

  void hardDrop() {
    if (_currentState.currentBrick == null) return;
    
    final ghostBrick = _currentState.currentBrick!.hardDrop(_currentState.grid);
    _currentState = _currentState.copyWith(currentBrick: ghostBrick);
    _stateController.add(_currentState);
    _lockBrick();
  }

  void hold() {
    if (!_currentState.canHold || _currentState.currentBrick == null) return;

    Brick? newHeldBrick;
    Brick? newCurrentBrick;

    if (_currentState.heldBrick == null) {
      newHeldBrick = _currentState.currentBrick!;
      _spawnNewBrick();
      newCurrentBrick = _currentState.currentBrick;
    } else {
      newHeldBrick = _currentState.currentBrick!;
      newCurrentBrick = _engine.createBrick(_currentState.heldBrick!.type);
    }

    _currentState = _currentState.copyWith(
      currentBrick: newCurrentBrick,
      heldBrick: newHeldBrick,
      canHold: false,
    );
    _stateController.add(_currentState);
  }

  void _move(Direction direction) {
    if (_currentState.currentBrick == null) return;

    final movedBrick = _currentState.currentBrick!.move(direction);
    if (!_engine.checkCollision(movedBrick, _currentState.grid)) {
      _currentState = _currentState.copyWith(currentBrick: movedBrick);
      _stateController.add(_currentState);
    }
  }

  void dispose() {
    _isRunning = false;
    _timer?.cancel();
    _stateController.close();
    _lineClearController.close();
    _scoreController.close();
    _gameOverController.close();
  }
  
  List<Position> getGhostPosition(Brick brick, List<List<bool>> grid) {
    return _engine.getGhostPosition(brick, grid);
  }
}