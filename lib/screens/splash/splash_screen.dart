import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/themes/app_theme.dart';
import '../../providers/providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.games_rounded,
              size: 120.sp,
              color: theme.colorScheme.primary,
            )
                .animate()
                .scale(duration: 800.ms, curve: Curves.elasticOut)
                .shimmer(duration: 1500.ms, color: theme.colorScheme.primaryContainer),
            SizedBox(height: 24.h),
            Text(
              'Brick Fall',
              style: theme.textTheme.displayLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 300.ms)
                .slideY(begin: 0.3, duration: 600.ms, delay: 300.ms, curve: Curves.easeOut),
            SizedBox(height: 8.h),
            Text(
              'Classic Arcade Action',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 500.ms)
                .slideY(begin: 0.3, duration: 600.ms, delay: 500.ms, curve: Curves.easeOut),
            SizedBox(height: 48.h),
            SizedBox(
              width: 200.w,
              child: LinearProgressIndicator(
                backgroundColor: theme.colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                borderRadius: BorderRadius.circular(4.r),
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 700.ms)
                .slideY(begin: 0.3, duration: 600.ms, delay: 700.ms, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }
}