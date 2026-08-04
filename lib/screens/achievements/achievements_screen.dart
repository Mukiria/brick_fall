import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/design_system.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> 
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Achievements', style: AppTextStyles.titleLarge),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _controller.value,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - _controller.value)),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          gradient: AppGradients.levelUp,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusXxl.r),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.tertiary.withValues(alpha: 0.4),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.emoji_events_rounded,
                          color: Colors.white,
                          size: 60.sp,
                        ),
                      )
                        .animate(onPlay: (controller) => controller.repeat(reverse: true))
                        .scale(duration: 2000.ms, begin: Offset(1.0, 1.0), end: Offset(1.05, 1.05), curve: Curves.easeInOut),
                      
                      SizedBox(height: 32.h),
                      
                      Text(
                        'Achievements',
                        style: AppTextStyles.displaySmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      
                      SizedBox(height: 12.h),
                      
                      Text(
                        'Coming Soon!',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      SizedBox(height: 24.h),
                      
                      Text(
                        'Track your progress, unlock badges,\nand compete with friends.',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: 48.h),
                      
                      FilledButton.icon(
                        onPressed: () => context.pop(),
                        icon: Icon(Icons.arrow_back_rounded, size: 20.sp),
                        label: Text('Back to Home', style: AppTextStyles.buttonLarge),
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusLarge.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}