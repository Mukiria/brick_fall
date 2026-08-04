import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/game_constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(statisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard_rounded)),
            Tab(text: 'By Difficulty', icon: Icon(Icons.speed_rounded)),
            Tab(text: 'Bricks', icon: Icon(Icons.crop_square_rounded)),
          ],
        ),
      ),
      body: statsAsync.when(
        data: (stats) => TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(theme, stats),
            _buildDifficultyTab(theme, stats),
            _buildBricksTab(theme, stats),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildOverviewTab(ThemeData theme, Statistics stats) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildMainStats(theme, stats),
          SizedBox(height: 24.h),
          _buildDetailedStats(theme, stats),
          SizedBox(height: 24.h),
          _buildRecentActivity(theme, stats),
        ],
      ),
    );
  }

  Widget _buildMainStats(ThemeData theme, Statistics stats) {
    return Row(
      children: [
        Expanded(child: _StatCard(
          title: 'Games Played',
          value: stats.gamesPlayed.toString(),
          icon: Icons.games_rounded,
          color: theme.colorScheme.primary,
          trend: null,
        )),
        SizedBox(width: 12.w),
        Expanded(child: _StatCard(
          title: 'High Score',
          value: _formatNumber(stats.highScore),
          icon: Icons.star_rounded,
          color: theme.colorScheme.tertiary,
          trend: null,
        )),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3);
  }

  Widget _buildDetailedStats(ThemeData theme, Statistics stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 1.3,
      children: [
        _StatCard(
          title: 'Total Score',
          value: _formatNumber(stats.totalScore),
          icon: Icons.score_rounded,
          color: theme.colorScheme.primary,
          subtitle: 'Avg: ${_formatNumber(stats.averageScore.round())}',
        ),
        _StatCard(
          title: 'Lines Cleared',
          value: _formatNumber(stats.totalLinesCleared),
          icon: Icons.format_list_numbered_rounded,
          color: theme.colorScheme.secondary,
          subtitle: 'Avg: ${stats.averageLinesPerGame.toStringAsFixed(1)}/game',
        ),
        _StatCard(
          title: 'Max Level',
          value: stats.maxLevelReached.toString(),
          icon: Icons.trending_up_rounded,
          color: theme.colorScheme.tertiary,
          subtitle: 'Best achievement',
        ),
        _StatCard(
          title: 'Play Time',
          value: _formatDuration(stats.totalPlayTime),
          icon: Icons.timer_rounded,
          color: theme.colorScheme.error,
          subtitle: 'Total time played',
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.3);
  }

  Widget _buildRecentActivity(ThemeData theme, Statistics stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Summary', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
        SizedBox(height: 12.h),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _InfoRow(label: 'Last Played', value: _formatDate(stats.lastPlayed), icon: Icons.calendar_today_rounded, color: theme.colorScheme.primary),
                _InfoRow(label: 'Favorite Difficulty', value: _getFavoriteDifficulty(stats), icon: Icons.speed_rounded, color: theme.colorScheme.secondary),
                _InfoRow(label: 'Most Used Brick', value: _getMostUsedBrick(stats), icon: Icons.crop_square_rounded, color: theme.colorScheme.tertiary),
              ],
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.3);
  }

  Widget _buildDifficultyTab(ThemeData theme, Statistics stats) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: Difficulty.values.map((difficulty) {
          final gamesPlayed = stats.difficultyGamesPlayed[difficulty.name] ?? 0;
          final highScore = stats.difficultyHighScores[difficulty.name] ?? 0;
          
          return _DifficultyCard(
            difficulty: difficulty,
            gamesPlayed: gamesPlayed,
            highScore: highScore,
            color: _getDifficultyColor(theme, difficulty),
          ).animate().fadeIn(duration: 600.ms, delay: (difficulty.index * 100).ms).slideX(begin: 0.3);
        }).toList(),
      ),
    );
  }

  Widget _buildBricksTab(ThemeData theme, Statistics stats) {
    final totalBricks = stats.brickCounts.values.fold(0, (a, b) => a + b);
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: BrickType.values.map((brick) {
          final count = stats.brickCounts[brick.name] ?? 0;
          final percentage = totalBricks > 0 ? (count / totalBricks * 100) : 0.0;
          
          return _BrickStatCard(
            brickType: brick,
            count: count,
            percentage: percentage,
            color: GameConstants.tetrominoColors[brick.index],
          ).animate().fadeIn(duration: 600.ms, delay: (brick.index * 100).ms).slideX(begin: -0.3);
        }).toList(),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getFavoriteDifficulty(Statistics stats) {
    if (stats.difficultyGamesPlayed.isEmpty) return 'Normal';
    return stats.difficultyGamesPlayed.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key
        .toUpperCase();
  }

  String _getMostUsedBrick(Statistics stats) {
    if (stats.brickCounts.isEmpty) return 'T';
    return stats.brickCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key
        .toUpperCase();
  }

  Color _getDifficultyColor(ThemeData theme, Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.normal:
        return theme.colorScheme.primary;
      case Difficulty.hard:
        return Colors.orange;
      case Difficulty.expert:
        return Colors.red;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final String? trend;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, color: color, size: 24.sp),
                ),
                const Spacer(),
                if (trend != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(trend!, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.tertiary)),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(value, style: theme.textTheme.headlineMedium?.copyWith(color: color, fontWeight: FontWeight.w700, fontFamily: 'GameFont')),
            Text(title, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            if (subtitle != null) ...[
              SizedBox(height: 4.h),
              Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ],
        ),
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  final Difficulty difficulty;
  final int gamesPlayed;
  final int highScore;
  final Color color;

  const _DifficultyCard({
    required this.difficulty,
    required this.gamesPlayed,
    required this.highScore,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  difficulty.name[0].toUpperCase(),
                  style: theme.textTheme.headlineMedium?.copyWith(color: color, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(difficulty.name.toUpperCase(), style: theme.textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.w700)),
                  Text('${gamesPlayed} games played', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('HIGH SCORE', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                Text(_formatNumber(highScore), style: theme.textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.w700, fontFamily: 'GameFont')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toString();
  }
}

class _BrickStatCard extends StatelessWidget {
  final BrickType brickType;
  final int count;
  final double percentage;
  final Color color;

  const _BrickStatCard({
    required this.brickType,
    required this.count,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  brickType.name.toUpperCase(),
                  style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${brickType.name.toUpperCase()} Piece', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text('$count used', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      SizedBox(width: 12.w),
                      Text('${percentage.toStringAsFixed(1)}%', style: theme.textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ],
              ),
            ),
          ],
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
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const Spacer(),
          Text(value, style: theme.textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}