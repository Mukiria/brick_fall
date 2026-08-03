import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/models.dart';
import '../../core/themes/app_theme.dart';

class DifficultyCard extends StatelessWidget {
  final Difficulty difficulty;
  final int gamesPlayed;
  final int highScore;
  final Color color;

  const DifficultyCard({
    super.key,
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
                  Text('$gamesPlayed games played', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
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