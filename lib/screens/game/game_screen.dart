import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/themes/app_theme.dart';
import '../../core/extensions/extensions.dart';
import '../../models/models.dart';
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
      if (state.state == CoreGameState.paused && !_showPauseOverlay) {
        _showPauseOverlay = true;
        _pauseController.forward();
      } else if (state.state == CoreGameState.playing && _showPauseOverlay) {
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
    final brickUsage = <BrickType, int>{};
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
      onPopInvoked: (didPop) {
        if (!didPop && gameState.state == CoreGameState.playing) {
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
            theme.colorScheme.background,
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(ThemeData theme, GameState gameState, AsyncValue<Settings> settings) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.pause_rounded, color: theme.colorScheme.primary, size: 28.sp),
            onPressed: () => ref.read(gameLoopProvider).pause(),
          ),
          Expanded(
            child: Center(
              child: Text(
                'LEVEL ${gameState.level}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          _buildScoreDisplay(theme, gameState),
        ],
      ),
    );
  }

  Widget _buildScoreDisplay(ThemeData theme, GameState gameState) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('SCORE', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(
            gameState.score.toString().padLeft(8, '0'),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontFamily: 'GameFont',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoldArea(ThemeData theme, GameState gameState) {
    return Container(
      width: 80.w,
      margin: EdgeInsets.only(left: 16.w, right: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('HOLD', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          SizedBox(height: 8.h),
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: gameState.heldBrick != null
                ? Center(
                    child: _buildMiniBrick(theme, gameState.heldBrick!, scale: 0.8),
                  )
                : Center(
                    child: Icon(Icons.remove_rounded, color: theme.colorScheme.outline, size: 24.sp),
                  ),
          ),
          if (!gameState.canHold)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Icon(Icons.lock_rounded, color: theme.colorScheme.error, size: 20.sp),
            ),
        ],
      ),
    );
  }

  Widget _buildGameArea(ThemeData theme, GameState gameState, AsyncValue<Settings> settings) {
    final showGrid = settings.value?.gridEnabled ?? true;
    final showGhost = settings.value?.ghostPieceEnabled ?? true;

    return Expanded(
      flex: 3,
      child: Center(
        child: AspectRatio(
          aspectRatio: AppConstants.gameWidth / AppConstants.gameHeight,
          child: Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: theme.colorScheme.primary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                if (showGrid) _buildGrid(theme),
                if (showGhost && gameState.currentBrick != null)
                  _buildGhostPiece(theme, gameState),
                if (gameState.currentBrick != null)
                  _buildCurrentBrick(theme, gameState),
                _buildLockedBricks(theme, gameState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(ThemeData theme) {
    return CustomPaint(
      painter: _GridPainter(
        rows: AppConstants.gameHeight,
        cols: AppConstants.gameWidth,
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.1),
      ),
      size: Size.infinite,
    );
  }

  Widget _buildGhostPiece(ThemeData theme, GameState gameState) {
    final gameLoop = ref.read(gameLoopProvider);
    final ghostPositions = gameLoop.getGhostPosition(gameState.currentBrick!, gameState.grid);
    
    return Stack(
      children: ghostPositions.map((pos) => _buildBrickCell(
        theme,
        pos,
        gameState.currentBrick!.color.withValues(alpha: 0.3),
        isGhost: true,
      )).toList(),
    );
  }

  Widget _buildCurrentBrick(ThemeData theme, GameState gameState) {
    return Stack(
      children: gameState.currentBrick!.blocks.map((pos) => _buildBrickCell(
        theme,
        pos,
        gameState.currentBrick!.color,
      )).toList(),
    );
  }

  Widget _buildLockedBricks(ThemeData theme, GameState gameState) {
    return Stack(
      children: [
        for (int y = 0; y < AppConstants.gameHeight; y++)
          for (int x = 0; x < AppConstants.gameWidth; x++)
            if (gameState.grid[y][x])
              _buildBrickCell(
                theme,
                Position(x, y),
                Color(gameState.gridColors[y][x]),
              ),
      ],
    );
  }

  Widget _buildBrickCell(ThemeData theme, Position pos, Color color, {bool isGhost = false}) {
    final cellSize = (MediaQuery.of(context).size.width * 0.6) / AppConstants.gameWidth;
    
    return Positioned(
      left: pos.x * cellSize + 8.w,
      top: pos.y * cellSize + 8.h,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        width: cellSize - 2,
        height: cellSize - 2,
        decoration: BoxDecoration(
          color: isGhost ? color.withValues(alpha: 0.3) : color,
          borderRadius: BorderRadius.circular(4.r),
          border: isGhost
              ? Border.all(color: color.withValues(alpha: 0.5), width: 2, strokeAlign: BorderSide.strokeAlignInside)
              : Border.all(color: color.lighter, width: 1),
          boxShadow: isGhost
              ? null
              : [
                  BoxShadow(color: color.darker, offset: Offset(1, 1), blurRadius: 0),
                  BoxShadow(color: color.lighter, offset: Offset(-1, -1), blurRadius: 0),
                ],
        ),
      ),
    );
  }

  Widget _buildMiniBrick(ThemeData theme, Brick brick, {double scale = 1.0}) {
    final cellSize = 20.0 * scale;
    final minX = brick.blocks.map((b) => b.x).reduce((a, b) => a < b ? a : b);
    final minY = brick.blocks.map((b) => b.y).reduce((a, b) => a < b ? a : b);
    
    return Center(
      child: Stack(
        children: brick.blocks.map((pos) {
          return Positioned(
            left: (pos.x - minX) * cellSize,
            top: (pos.y - minY) * cellSize,
            child: Container(
              width: cellSize - 1,
              height: cellSize - 1,
              decoration: BoxDecoration(
                color: brick.color,
                borderRadius: BorderRadius.circular(3.r),
                border: Border.all(color: brick.color.lighter, width: 1),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSidePanel(ThemeData theme, GameState gameState, AsyncValue<Settings> settings) {
    final showNext = settings.value?.nextPieceEnabled ?? true;
    
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.only(right: 16.w, left: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showNext) ...[
              Text('NEXT', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                height: 120.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: gameState.nextBrick != null
                    ? Center(child: _buildMiniBrick(theme, gameState.nextBrick!))
                    : const SizedBox.shrink(),
              ),
              SizedBox(height: 24.h),
            ],
            _buildInfoPanel(theme, gameState),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPanel(ThemeData theme, GameState gameState) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          children: [
            _InfoRow(label: 'LINES', value: gameState.linesCleared.toString(), icon: Icons.format_list_numbered_rounded, color: theme.colorScheme.secondary),
            _InfoRow(label: 'TOTAL', value: gameState.totalLinesCleared.toString(), icon: Icons.summarize_rounded, color: theme.colorScheme.primary),
            _InfoRow(label: 'COMBO', value: gameState.combo > 0 ? 'x${gameState.combo}' : '0', icon: Icons.local_fire_department_rounded, color: theme.colorScheme.tertiary),
            const Spacer(),
            _InfoRow(label: 'TIME', value: gameState.elapsedTime.formattedTime, icon: Icons.timer_rounded, color: theme.colorScheme.outline),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(ThemeData theme, GameState gameState, AsyncValue<Settings> settings) {
    final leftHanded = settings.value?.leftHandedMode ?? false;
    
    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ControlButton(
                      icon: leftHanded ? Icons.rotate_right_rounded : Icons.rotate_left_rounded,
                      onTap: () => gameState.currentBrick != null ? ref.read(gameLoopProvider).rotateCounterClockwise() : null,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 16.w),
                    _ControlButton(
                      icon: leftHanded ? Icons.rotate_left_rounded : Icons.rotate_right_rounded,
                      onTap: () => gameState.currentBrick != null ? ref.read(gameLoopProvider).rotate() : null,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ControlButton(
                      icon: Icons.keyboard_arrow_left_rounded,
                      onTap: () => gameState.currentBrick != null ? ref.read(gameLoopProvider).moveLeft() : null,
                      color: theme.colorScheme.secondary,
                    ),
                    SizedBox(width: 16.w),
                    _ControlButton(
                      icon: Icons.keyboard_arrow_down_rounded,
                      onTap: () => gameState.currentBrick != null ? ref.read(gameLoopProvider).moveDown() : null,
                      color: theme.colorScheme.secondary,
                    ),
                    SizedBox(width: 16.w),
                    _ControlButton(
                      icon: Icons.keyboard_arrow_right_rounded,
                      onTap: () => gameState.currentBrick != null ? ref.read(gameLoopProvider).moveRight() : null,
                      color: theme.colorScheme.secondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          _ControlButton(
            icon: Icons.keyboard_arrow_up_rounded,
            onTap: () => gameState.currentBrick != null ? ref.read(gameLoopProvider).hardDrop() : null,
            color: theme.colorScheme.tertiary,
            size: 64.sp,
            isLarge: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPauseOverlay(ThemeData theme) {
    return FadeTransition(
      opacity: _pauseController,
      child: Container(
        color: AppColors.pauseOverlay,
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
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('RESUME'),
                        onPressed: () => ref.read(gameLoopProvider).resume(),
                      ),
                      SizedBox(width: 16.w),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.home_rounded),
                        label: const Text('MENU'),
                        onPressed: () {
                          ref.read(gameLoopProvider).dispose();
                          context.go('/home');
                        },
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

  Widget _buildGameOverOverlay(ThemeData theme, GameState gameState) {
    if (gameState.state != CoreGameState.gameOver) return const SizedBox.shrink();
    
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
              color: AppColors.gameOverOverlay,
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
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('PLAY AGAIN'),
                            onPressed: () {
                              ref.read(gameLoopProvider).start(difficulty: gameState.difficulty);
                            },
                          ),
                          SizedBox(width: 16.w),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.home_rounded),
                            label: const Text('MAIN MENU'),
                            onPressed: () {
                              ref.read(gameLoopProvider).dispose();
                              context.go('/home');
                            },
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
      },
    );
  }

  Widget _buildLevelUpOverlay(ThemeData theme) {
    return AnimatedBuilder(
      animation: _levelUpController,
      builder: (context, child) {
        if (!_levelUpController.isAnimating) return const SizedBox.shrink();
        
        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: _levelUpController, curve: const Interval(0.0, 0.3, curve: Curves.easeOut)),
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.2).animate(
              CurvedAnimation(parent: _levelUpController, curve: const Interval(0.0, 0.5, curve: Curves.elasticOut)),
            ),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: theme.colorScheme.tertiary, width: 3),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up_rounded, size: 48.sp, color: theme.colorScheme.tertiary),
                    Text('LEVEL UP!', style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.tertiary, fontWeight: FontWeight.w700)),
                    Text('Level ${ref.read(gameLoopProvider).currentState.level}', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onTertiaryContainer)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  final int rows;
  final int cols;
  final Color color;

  _GridPainter({required this.rows, required this.cols, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 0.5;
    final cellWidth = size.width / cols;
    final cellHeight = size.height / rows;

    for (int i = 1; i < cols; i++) {
      canvas.drawLine(Offset(i * cellWidth, 0), Offset(i * cellWidth, size.height), paint);
    }
    for (int i = 1; i < rows; i++) {
      canvas.drawLine(Offset(0, i * cellHeight), Offset(size.width, i * cellHeight), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final double size;
  final bool isLarge;

  const _ControlButton({
    required this.icon,
    this.onTap,
    required this.color,
    this.size = 56,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isLarge ? 32.r : 16.r),
        child: Container(
          width: size.sp,
          height: size.sp,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(isLarge ? 32.r : 16.r),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
          ),
          child: Icon(icon, color: color, size: isLarge ? 32.sp : 24.sp),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(width: 12.w),
          Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const Spacer(),
          Text(value, style: theme.textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.w700, fontFamily: 'GameFont')),
        ],
      ),
    );
  }
}

class _GameOverStatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _GameOverStatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(value, style: theme.textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.w700, fontFamily: 'GameFont')),
        ],
      ),
    );
  }
}