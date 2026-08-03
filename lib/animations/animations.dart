import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LineClearEffect extends StatefulWidget {
  final List<int> lines;
  final Duration duration;
  final VoidCallback? onComplete;

  const LineClearEffect({
    super.key,
    required this.lines,
    this.duration = const Duration(milliseconds: 500),
    this.onComplete,
  });

  @override
  State<LineClearEffect> createState() => _LineClearEffectState();
}

class _LineClearEffectState extends State<LineClearEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward().whenComplete(() {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: widget.lines.map((line) {
            return Positioned(
              top: line * 30.0,
              left: 0,
              right: 0,
              height: 30.0,
              child: Opacity(
                opacity: 1.0 - _animation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8 * (1.0 - _animation.value)),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '+${_getLineScore(widget.lines.length)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                      ),
                    ).animate().scale(duration: widget.duration, curve: Curves.elasticOut),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  int _getLineScore(int count) {
    switch (count) {
      case 1: return 100;
      case 2: return 300;
      case 3: return 500;
      case 4: return 800;
      default: return 0;
    }
  }
}

class PieceLockEffect extends StatelessWidget {
  final Widget child;
  final bool isLocked;

  const PieceLockEffect({
    super.key,
    required this.child,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return child.animate(target: isLocked ? 1 : 0)
        .scale(begin: const Offset(1.0, 1.0), end: const Offset(0.95, 0.95), duration: 50.ms)
        .then()
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0), duration: 100.ms, curve: Curves.elasticOut)
        .shake(duration: 200.ms, hz: 4, rotation: 0.05);
  }
}

class LevelUpEffect extends StatefulWidget {
  final int level;
  final VoidCallback? onComplete;

  const LevelUpEffect({
    super.key,
    required this.level,
    this.onComplete,
  });

  @override
  State<LevelUpEffect> createState() => _LevelUpEffectState();
}

class _LevelUpEffectState extends State<LevelUpEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _controller.reverse().whenComplete(() {
          widget.onComplete?.call();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _controller.value,
            child: Transform.scale(
              scale: 0.5 + 0.7 * _controller.value,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Theme.of(context).colorScheme.tertiary, width: 3),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up_rounded, size: 48, color: Theme.of(context).colorScheme.tertiary),
                    Text('LEVEL UP!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.w700)),
                    Text('Level ${widget.level}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onTertiaryContainer)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GameOverEffect extends StatelessWidget {
  final int score;
  final int level;
  final int lines;
  final Duration time;
  final VoidCallback onRetry;
  final VoidCallback onMenu;

  const GameOverEffect({
    super.key,
    required this.score,
    required this.level,
    required this.lines,
    required this.time,
    required this.onRetry,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Theme.of(context).colorScheme.error, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sentiment_very_dissatisfied_rounded, size: 64, color: Theme.of(context).colorScheme.error),
            Text('GAME OVER', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 24),
            _buildStat(context, 'Final Score', score.toString(), Theme.of(context).colorScheme.primary),
            _buildStat(context, 'Level Reached', level.toString(), Theme.of(context).colorScheme.secondary),
            _buildStat(context, 'Lines Cleared', lines.toString(), Theme.of(context).colorScheme.tertiary),
            _buildStat(context, 'Time', _formatTime(time), Theme.of(context).colorScheme.outline),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('PLAY AGAIN'),
                  onPressed: onRetry,
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('MAIN MENU'),
                  onPressed: onMenu,
                ),
              ],
            ),
          ],
        ),
      ).animate()
        .scale(duration: 600.ms, curve: Curves.elasticOut)
        .fadeIn(duration: 400.ms),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}