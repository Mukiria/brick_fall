import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import '../../core/themes/app_theme.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    ref.read(audioServiceProvider).playMusic('audio/background_music.mp3');
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(settingsProvider);
    final statisticsAsync = ref.watch(statisticsProvider);
    final gameLoop = ref.watch(gameLoopProvider);
    final hasSavedGame = gameLoop.currentState.state != CoreGameState.idle && 
                         gameLoop.currentState.state != CoreGameState.gameOver;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(theme),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  _buildHeader(theme),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTitle(theme),
                            SizedBox(height: 48.h),
                            _buildMenuButtons(theme, hasSavedGame),
                            SizedBox(height: 32.h),
                            _buildStatsPreview(theme, statisticsAsync),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildFooter(theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(ThemeData theme) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return CustomPaint(
          painter: _BackgroundPainter(
            progress: _bgController.value,
            primaryColor: theme.colorScheme.primary,
            secondaryColor: theme.colorScheme.secondary,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Brick Fall',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3),
        IconButton(
          icon: Icon(Icons.settings_rounded, color: theme.colorScheme.primary, size: 28.sp),
          onPressed: () => context.push('/settings'),
        ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideX(begin: 0.3),
      ],
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Column(
      children: [
        Text(
          'READY TO PLAY?',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            letterSpacing: 2,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: -0.3),
        SizedBox(height: 8.h),
        Text(
          'Classic Tetris-style action',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: -0.3),
      ],
    );
  }

  Widget _buildMenuButtons(ThemeData theme, bool hasSavedGame) {
    return Column(
      children: [
        if (hasSavedGame)
          _MenuButton(
            label: 'CONTINUE GAME',
            icon: Icons.play_arrow_rounded,
            color: theme.colorScheme.primary,
            onTap: () => context.push('/game'),
          ).animate().fadeIn(duration: 600.ms, delay: 500.ms).slideY(begin: 0.3),
        if (hasSavedGame) SizedBox(height: 16.h),
        _MenuButton(
          label: 'NEW GAME',
          icon: Icons.refresh_rounded,
          color: theme.colorScheme.tertiary,
          onTap: () => _showDifficultyDialog(context),
        ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideY(begin: 0.3),
        SizedBox(height: 16.h),
        _MenuButton(
          label: 'STATISTICS',
          icon: Icons.bar_chart_rounded,
          color: theme.colorScheme.secondary,
          onTap: () => context.push('/statistics'),
        ).animate().fadeIn(duration: 600.ms, delay: 700.ms).slideY(begin: 0.3),
        SizedBox(height: 16.h),
        _MenuButton(
          label: 'SETTINGS',
          icon: Icons.settings_rounded,
          color: theme.colorScheme.outline,
          outlined: true,
          onTap: () => context.push('/settings'),
        ).animate().fadeIn(duration: 600.ms, delay: 800.ms).slideY(begin: 0.3),
      ],
    );
  }

  Widget _buildStatsPreview(ThemeData theme, AsyncValue<Statistics> statisticsAsync) {
    return statisticsAsync.when(
      data: (stats) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              label: 'Games',
              value: stats.gamesPlayed.toString(),
              icon: Icons.games_rounded,
              color: theme.colorScheme.primary,
            ),
            _StatItem(
              label: 'High Score',
              value: _formatScore(stats.highScore),
              icon: Icons.star_rounded,
              color: theme.colorScheme.tertiary,
            ),
            _StatItem(
              label: 'Lines',
              value: stats.totalLinesCleared.toString(),
              icon: Icons.format_list_numbered_rounded,
              color: theme.colorScheme.secondary,
            ),
            _StatItem(
              label: 'Max Level',
              value: stats.maxLevelReached.toString(),
              icon: Icons.trending_up_rounded,
              color: theme.colorScheme.error,
            ),
          ],
        ),
      ).animate().fadeIn(duration: 600.ms, delay: 900.ms).slideY(begin: 0.3),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Text(
      'v1.0.0 • Built with Flutter',
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 1000.ms);
  }

  void _showDifficultyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Difficulty', style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Difficulty.values.map((difficulty) {
            return ListTile(
              title: Text(difficulty.name.toUpperCase()),
              leading: Radio<Difficulty>(
                value: difficulty,
                groupValue: ref.read(settingsProvider).value?.defaultDifficulty ?? Difficulty.normal,
                onChanged: (value) {
                  Navigator.pop(context);
                  if (value != null) {
                    _startNewGame(value);
                  }
                },
              ),
              onTap: () {
                Navigator.pop(context);
                _startNewGame(difficulty);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _startNewGame(Difficulty difficulty) {
    ref.read(gameLoopProvider).start(difficulty: difficulty);
    context.push('/game');
  }

  String _formatScore(int score) {
    if (score >= 1000000) {
      return '${(score / 1000000).toStringAsFixed(1)}M';
    } else if (score >= 1000) {
      return '${(score / 1000).toStringAsFixed(1)}K';
    }
    return score.toString();
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool outlined;

  const _MenuButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: outlined
          ? OutlinedButton.icon(
              icon: Icon(icon, size: 24.sp),
              label: Text(label, style: theme.textTheme.labelLarge),
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              ),
              onPressed: onTap,
            )
          : FilledButton.icon(
              icon: Icon(icon, size: 24.sp),
              label: Text(label, style: theme.textTheme.labelLarge),
              style: FilledButton.styleFrom(
                backgroundColor: color,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                elevation: 4,
              ),
              onPressed: onTap,
            ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: color, size: 28.sp),
        SizedBox(height: 4.h),
        Text(value, style: theme.textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.w700)),
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  _BackgroundPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Draw grid pattern
    final gridPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.05)
      ..strokeWidth = 1;
    
    const spacing = 50.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw floating bricks
    for (int i = 0; i < 10; i++) {
      final x = (size.width * (i / 10)) + (size.width * 0.1 * sin(progress * 2 * pi + i));
      final y = (size.height * 0.3) + (size.height * 0.4 * sin(progress * 2 * pi + i * 0.5));
      
      paint.color = [primaryColor, secondaryColor, primaryColor.withValues(alpha: 0.3)][i % 3];
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x, y), width: 30, height: 30),
          Radius.circular(8),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}