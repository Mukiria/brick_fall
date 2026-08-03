import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/models.dart';
import '../../core/themes/app_theme.dart';

class BrickStatCard extends StatelessWidget {
  final BrickType brickType;
  final int count;
  final double percentage;
  final Color color;

  const BrickStatCard({
    super.key,
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