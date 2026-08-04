import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/design_system.dart';
import '../../core/design/spacing.dart';
import '../../core/extensions/extensions.dart';
import '../../engine/engine.dart' as engine;
import '../../models/models.dart' as models;
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';
import '../../animations/animations.dart';
import '../../audio/audio_service.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _pauseController;
  late AnimationController _levelUpController;
  late AnimationController _gameOverController;
  bool _showPauseOverlay = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _pauseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _levelUpController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _gameOverController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _listenToGameLoop();
  }

  void _listenToGameLoop() {
    final gameLoop = ref.read(gameLoopProvider);
    
    gameLoop.stateStream.listen((state) {
      if (state.status == engine.GameStateStatus.paused && !_showPauseOverlay) {
        _showPauseOverlay = true;
        _pauseController.forward();
      } else if (state.status == engine.GameStateStatus.playing && _showPauseOverlay) {
        _showPauseOverlay = false;
        _pauseController.reverse();
      }
    });

    gameLoop.lineClearStream.listen((lines) {
      if (lines.length >= 4) {
        _levelUpController.forward(from: 0);
      }
      _triggerLineClearAnimation(lines);
    });

    gameLoop.gameOverStream.listen((_) {
      _gameOverController.forward();
      _handleGameOver();
    });
  }

  void _triggerLineClearAnimation(List<int> lines) {
    // Animation handled by LineClearEffect widget
  }

  void _handleGameOver() async {
    final gameLoop = ref.read(gameLoopProvider);
    final state = gameLoop.currentState;
    final audioService = ref.read(audioServiceProvider);
    
    await audioService.playGameOver();
    
    // Save statistics
    final brickUsage = <engine.PieceType, int>{};
    // Track brick usage from game
    
    await ref.read(statisticsNotifierProvider.notifier).addGame(
      score: state.score,
      linesCleared: state.totalLinesCleared,
      levelReached: state.level,
      playTime: state.elapsedTime,
      difficulty: state.difficulty,
      brickUsage: brickUsage,
    );

    // Update high score in settings
    final settings = ref.read(settingsProvider).value;
    if (settings != null && state.score > state.highScore) {
      // High score is saved in game state
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pauseController.dispose();
    _levelUpController.dispose();
    _gameOverController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      ref.read(gameLoopProvider).pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final gameLoop = ref.watch(gameLoopProvider);
    final gameState = gameLoop.currentState;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && gameState.status == engine.GameStateStatus.playing) {
          gameLoop.pause();
        } else if (!didPop) {
          context.pop();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(theme),
            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(theme, gameState, settings),
                  Expanded(
                    child: Row(
                      children: [
                        if (settings.value?.holdPieceEnabled ?? true) _buildHoldArea(theme, gameState),
                        _buildGameArea(theme, gameState, settings),
                        _buildSidePanel(theme, gameState, settings),
                      ],
                    ),
                  ),
                  _buildControls(theme, gameState, settings),
                ],
              ),
            ),
            if (_showPauseOverlay) _buildPauseOverlay(theme),
            _buildGameOverOverlay(theme, gameState),
            _buildLevelUpOverlay(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(ThemeData theme, engine.GameState gameState, AsyncValue<models.Settings> settings) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Text(
            'Level ${gameState.level}',
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            'Score: ${gameState.score}',
            style: AppTextStyles.headlineSmall.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 24.w),
          Icon(
            Icons.delete_outline_rounded,
            color: theme.colorScheme.primary,
            size: 24.sp,
          ),
          SizedBox(width: 4.w),
          Text(
            '${gameState.linesCleared}',
            style: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreDisplay(ThemeData theme, engine.GameState gameState) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text('SCORE', style: AppTextStyles.labelSmall.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          SizedBox(height: 4.h),
          Text(
            gameState.score.toString(),
            style: AppTextStyles.displaySmall.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoldArea(ThemeData theme, engine.GameState gameState) {
    final heldPiece = gameState.heldPiece;
    
    return Container(
      width: 80.w,
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text('HOLD', style: AppTextStyles.labelSmall.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          SizedBox(height: 12.h),
          if (heldPiece != null)
            _buildPiecePreview(theme, heldPiece)
          else
            SizedBox(
              height: 60.h,
              child: Center(
                child: Icon(
                  Icons.drag_handle_rounded,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  size: 24.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPiecePreview(ThemeData theme, engine.Piece piece) {
    return SizedBox(
      width: 60.w,
      height: 60.h,
      child: CustomPaint(
        painter: _PiecePreviewPainter(
          piece: piece,
          theme: theme,
          blockSize: 12,
        ),
      ),
    );
  }

  Widget _buildGameArea(ThemeData theme, engine.GameState gameState, AsyncValue<models.Settings> settings) {
    final boardWidth = 10;
    final boardHeight = 20;
    final blockSize = MediaQuery.of(context).size.width / (boardWidth + 6);
    
    return Container(
      width: (boardWidth * blockSize).clamp(0, MediaQuery.of(context).size.width - 160.w),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Stack(
        children: [
          // Grid lines
          CustomPaint(
            size: Size(boardWidth * blockSize, boardHeight * blockSize),
            painter: _GridPainter(
              rows: boardHeight,
              cols: boardWidth,
              blockSize: blockSize,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          // Locked bricks
          _buildLockedBricks(theme, gameState, blockSize),
          // Ghost piece
          _buildGhostPiece(theme, gameState, blockSize),
          // Current piece
          _buildCurrentBrick(theme, gameState, blockSize),
        ],
      ),
    );
  }

  Widget _buildGhostPiece(ThemeData theme, engine.GameState gameState, double blockSize) {
    final ghost = gameState.ghostPiece;
    if (ghost == null) return const SizedBox.shrink();
    
    return Positioned.fill(
      child: CustomPaint(
        painter: _GhostPiecePainter(
          piece: ghost,
          blockSize: blockSize,
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildCurrentBrick(ThemeData theme, engine.GameState gameState, double blockSize) {
    final piece = gameState.currentPiece;
    if (piece == null) return const SizedBox.shrink();
    
    return DraggablePiece(
      key: ValueKey(piece.id),
      piece: piece,
      blockSize: blockSize.toInt(),
      board: gameState.board,
      gameState: gameState,
      enabled: gameState.status == engine.GameStateStatus.playing,
      onPositionChanged: (x, y) {
        // Update piece position in game loop
        ref.read(gameLoopProvider).moveToPosition(x, y);
      },
    );
  }

  Widget _buildLockedBricks(ThemeData theme, engine.GameState gameState, double blockSize) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _LockedBricksPainter(
          board: gameState.board,
          blockSize: blockSize,
          theme: theme,
        ),
      ),
    );
  }

  Widget _buildSidePanel(ThemeData theme, engine.GameState gameState, AsyncValue<models.Settings> settings) {
    return Container(
      width: 100.w,
      margin: EdgeInsets.only(left: 8.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('NEXT', style: AppTextStyles.labelSmall.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          SizedBox(height: 12.h),
          _buildPiecePreview(theme, gameState.nextPiece ?? engine.Piece.spawn(engine.PieceType.I)),
          SizedBox(height: 24.h),
          Text('LEVEL', style: AppTextStyles.labelSmall.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          SizedBox(height: 4.h),
          Text(
            '${gameState.level}',
            style: AppTextStyles.headlineSmall.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          LinearProgressIndicator(
            value: gameState.levelProgress,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(4.r),
            minHeight: 6.h,
          ),
          SizedBox(height: 24.h),
          Text('LINES', style: AppTextStyles.labelSmall.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          SizedBox(height: 4.h),
          Text(
            '${gameState.totalLinesCleared}',
            style: AppTextStyles.headlineSmall.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPanel(ThemeData theme, engine.GameState gameState) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _InfoRow(label: 'Combo', value: '${gameState.comboEngine.combo}x', color: theme.colorScheme.tertiary),
          _InfoRow(label: 'B2B', value: gameState.comboEngine.backToBack ? 'YES' : 'NO', color: theme.colorScheme.error),
        ],
      ),
    );
  }

  Widget _buildControls(ThemeData theme, engine.GameState gameState, AsyncValue<models.Settings> settings) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ControlButton(
            icon: Icons.rotate_left_rounded,
            onTap: () => ref.read(gameLoopProvider).rotateCounterClockwise(),
            color: theme.colorScheme.secondary,
          ),
          _ControlButton(
            icon: Icons.keyboard_arrow_left_rounded,
            onTap: () => ref.read(gameLoopProvider).moveLeft(),
            color: theme.colorScheme.primary,
          ),
          _ControlButton(
            icon: Icons.keyboard_arrow_down_rounded,
            onTap: () => ref.read(gameLoopProvider).moveDown(),
            color: theme.colorScheme.primary,
            isHold: true,
          ),
          _ControlButton(
            icon: Icons.keyboard_arrow_right_rounded,
            onTap: () => ref.read(gameLoopProvider).moveRight(),
            color: theme.colorScheme.primary,
          ),
          _ControlButton(
            icon: Icons.rotate_right_rounded,
            onTap: () => ref.read(gameLoopProvider).rotateClockwise(),
            color: theme.colorScheme.tertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildPauseOverlay(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return FadeTransition(
      opacity: _pauseController,
      child: Container(
        color: isDark ? AppColors.pauseOverlayDark : AppColors.pauseOverlayLight,
        child: Center(
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: _pauseController, curve: Curves.elasticOut),
            ),
            child: Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: theme.colorScheme.primary, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pause_circle_filled_rounded, size: 64.sp, color: theme.colorScheme.primary),
                  SizedBox(height: 16.h),
                  Text('PAUSED', style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.primary)),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FilledButton.icon(
                        onPressed: () {
                          ref.read(gameLoopProvider).resume();
                          setState(() => _showPauseOverlay = false);
                          _pauseController.reverse();
                        },
                        icon: Icon(Icons.play_arrow_rounded, size: 20.sp),
                        label: Text('Resume', style: AppTextStyles.buttonLarge),
                      ),
                      SizedBox(width: 16.w),
                      OutlinedButton.icon(
                        onPressed: () {
                          ref.read(gameLoopProvider).pause();
                          context.pop();
                        },
                        icon: Icon(Icons.home_rounded, size: 20.sp),
                        label: Text('Quit', style: AppTextStyles.buttonLarge),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverOverlay(ThemeData theme, engine.GameState gameState) {
    if (gameState.status != engine.GameStateStatus.gameOver) return const SizedBox.shrink();
    
    final isDark = theme.brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _gameOverController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _gameOverController,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: _gameOverController, curve: Curves.elasticOut),
            ),
            child: Container(
              color: isDark ? AppColors.gameOverOverlayDark : AppColors.gameOverOverlayLight,
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(32.w),
                  padding: EdgeInsets.all(32.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: theme.colorScheme.error, width: 2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sentiment_very_dissatisfied_rounded, size: 64.sp, color: theme.colorScheme.error),
                      SizedBox(height: 16.h),
                      Text('GAME OVER', style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.error)),
                      SizedBox(height: 24.h),
                      _GameOverStatRow(label: 'Final Score', value: gameState.score.toString(), color: theme.colorScheme.primary),
                      _GameOverStatRow(label: 'Level Reached', value: gameState.level.toString(), color: theme.colorScheme.secondary),
                      _GameOverStatRow(label: 'Lines Cleared', value: gameState.totalLinesCleared.toString(), color: theme.colorScheme.tertiary),
                      _GameOverStatRow(label: 'Time', value: gameState.elapsedTime.formattedTime, color: theme.colorScheme.outline),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FilledButton.icon(
                            onPressed: () {
                              final modelDifficulty = ref.read(settingsProvider).value?.defaultDifficulty ?? models.Difficulty.normal;
                              final difficulty = engine.Difficulty.values.firstWhere((d) => d.name == modelDifficulty.name);
                              ref.read(gameLoopProvider).start(difficulty: difficulty);
                              _gameOverController.reset();
                            },
                            icon: Icon(Icons.refresh_rounded, size: 20.sp),
                            label: Text('Play Again', style: AppTextStyles.buttonLarge),
                          ),
                          SizedBox(width: 16.w),
                          OutlinedButton.icon(
                            onPressed: () => context.pop(),
                            icon: Icon(Icons.home_rounded, size: 20.sp),
                            label: Text('Main Menu', style: AppTextStyles.buttonLarge),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));
      },
    );
  }

  Widget _buildLevelUpOverlay(ThemeData theme) {
    return AnimatedBuilder(
      animation: _levelUpController,
      builder: (context, child) {
        return Opacity(
          opacity: Curves.easeOut.transform(1 - _levelUpController.value),
          child: Transform.scale(
            scale: 0.8 + 0.2 * _levelUpController.value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              decoration: BoxDecoration(
                gradient: AppGradients.levelUp,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.tertiary.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Text(
                'LEVEL UP!',
                style: AppTextStyles.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PiecePreviewPainter extends CustomPainter {
  final engine.Piece piece;
  final ThemeData theme;
  final double blockSize;

  _PiecePreviewPainter({
    required this.piece,
    required this.theme,
    required this.blockSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final blocks = piece.blocks;
    
    // Center the piece
    int minX = blocks.map((b) => b.dx).reduce((a, b) => a < b ? a : b);
    int maxX = blocks.map((b) => b.dx).reduce((a, b) => a > b ? a : b);
    int minY = blocks.map((b) => b.dy).reduce((a, b) => a < b ? a : b);
    int maxY = blocks.map((b) => b.dy).reduce((a, b) => a > b ? a : b);
    
    int pieceWidth = maxX - minX + 1;
    int pieceHeight = maxY - minY + 1;
    
    double offsetX = (size.width - pieceWidth * blockSize) / 2 - minX * blockSize;
    double offsetY = (size.height - pieceHeight * blockSize) / 2 - minY * blockSize;
    
    for (final block in blocks) {
      final x = offsetX + block.dx * blockSize;
      final y = offsetY + block.dy * blockSize;
      
      paint.color = Color(piece.color);
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, blockSize * 0.9, blockSize * 0.9),
        Radius.circular(blockSize * 0.15),
      );
      canvas.drawRRect(rrect, paint);
      
      // Highlight
      paint.color = Colors.white.withValues(alpha: 0.3);
      canvas.drawRRect(rrect.deflate(blockSize * 0.1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PiecePainter extends CustomPainter {
  final engine.Piece piece;
  final double blockSize;

  _PiecePainter({required this.piece, required this.blockSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    for (final block in piece.blocks) {
      final x = piece.x * blockSize + block.dx * blockSize;
      final y = piece.y * blockSize + block.dy * blockSize;
      
      paint.color = Color(piece.color);
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 1, y + 1, blockSize * 0.95, blockSize * 0.95),
        Radius.circular(blockSize * 0.15),
      );
      canvas.drawRRect(rrect, paint);
      
      // Highlight
      paint.color = Colors.white.withValues(alpha: 0.3);
      canvas.drawRRect(rrect.deflate(blockSize * 0.1), paint);
      
      // Shadow
      paint.color = Colors.black.withValues(alpha: 0.2);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + blockSize * 0.05, y + blockSize * 0.05, blockSize * 0.9, blockSize * 0.9),
          Radius.circular(blockSize * 0.15),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _GhostPiecePainter extends CustomPainter {
  final engine.Piece piece;
  final double blockSize;
  final Color color;

  _GhostPiecePainter({required this.piece, required this.blockSize, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color;
    
    for (final block in piece.blocks) {
      final x = piece.x * blockSize + block.dx * blockSize;
      final y = piece.y * blockSize + block.dy * blockSize;
      
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 1, y + 1, blockSize * 0.95, blockSize * 0.95),
        Radius.circular(blockSize * 0.15),
      );
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _LockedBricksPainter extends CustomPainter {
  final engine.Board board;
  final double blockSize;
  final ThemeData theme;

  _LockedBricksPainter({required this.board, required this.blockSize, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    for (int y = 0; y < board.height; y++) {
      for (int x = 0; x < board.width; x++) {
        if (board.isOccupied(x, y)) {
          final drawX = x * blockSize;
          final drawY = y * blockSize;
          final color = board.getColor(x, y);
          
          paint.color = Color(color);
          final rrect = RRect.fromRectAndRadius(
            Rect.fromLTWH(drawX + 1, drawY + 1, blockSize * 0.95, blockSize * 0.95),
            Radius.circular(blockSize * 0.15),
          );
          canvas.drawRRect(rrect, paint);
          
          // Highlight
          paint.color = Colors.white.withValues(alpha: 0.2);
          canvas.drawRRect(rrect.deflate(blockSize * 0.1), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _GridPainter extends CustomPainter {
  final int rows;
  final int cols;
  final double blockSize;
  final Color color;

  _GridPainter({required this.rows, required this.cols, required this.blockSize, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;
    
    for (int i = 0; i <= cols; i++) {
      canvas.drawLine(
        Offset(i * blockSize, 0),
        Offset(i * blockSize, rows * blockSize),
        paint,
      );
    }
    for (int i = 0; i <= rows; i++) {
      canvas.drawLine(
        Offset(0, i * blockSize),
        Offset(cols * blockSize, i * blockSize),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoRow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Text('$label: ', style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _GameOverStatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _GameOverStatRow({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final bool isHold;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    required this.color,
    this.isHold = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      onLongPress: isHold ? onTap : null,
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 28.sp),
        ),
      ),
    ).animate().scale(duration: 100.ms, curve: Curves.easeOut);
  }
}