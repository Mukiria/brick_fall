import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/design_system.dart';
import '../../audio/audio_service.dart';
import '../../storage/storage_service.dart';
import '../../providers/providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _backgroundController;
  late final AnimationController _particleController;
  late final AnimationController _loadingController;
  
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();
  
  double _initializationProgress = 0.0;
  String _initializationStatus = 'Initializing...';
  bool _initializationComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _generateParticles();
    _startAnimations();
    _initializeApp();
  }

  void _initializeControllers() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  void _generateParticles() {
    _particles.clear();
    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 4 + 2,
        speed: _random.nextDouble() * 0.5 + 0.2,
        opacity: _random.nextDouble() * 0.5 + 0.2,
        colorIndex: _random.nextInt(3),
      ));
    }
  }

  void _startAnimations() {
    _logoController.forward();
    
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _initializationComplete) {
        _navigateToHome();
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize Hive
      _updateProgress(0.15, 'Initializing storage...');
      final storage = ref.read(storageServiceProvider);
      await storage.init();
      
      // Load settings (preferences)
      _updateProgress(0.35, 'Loading preferences...');
      final settings = storage.getSettings();
      
      // Initialize Audio
      _updateProgress(0.55, 'Initializing audio...');
      final audio = ref.read(audioServiceProvider);
      await audio.init(settings);
      
      // Preload critical audio assets
      _updateProgress(0.7, 'Preloading assets...');
      await _preloadAudio(audio);
      
      // Initialize game providers
      _updateProgress(0.85, 'Starting game engine...');
      await _initializeGameProviders();
      
      // Final step
      _updateProgress(1.0, 'Ready!');
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        setState(() {
          _initializationComplete = true;
        });
        
        // If logo animation already complete, navigate immediately
        if (_logoController.status == AnimationStatus.completed) {
          _navigateToHome();
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  Future<void> _preloadAudio(AudioService audio) async {
    // Audio assets will be loaded on demand, just verify service is ready
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _initializeGameProviders() async {
    // Trigger provider initialization by reading them
    await ref.read(settingsProvider.future);
    await ref.read(statisticsProvider.future);
    await Future.delayed(const Duration(milliseconds: 200));
  }

  void _updateProgress(double progress, String status) {
    if (mounted) {
      setState(() {
        _initializationProgress = progress;
        _initializationStatus = status;
      });
    }
  }

  void _navigateToHome() {
    if (mounted) {
      context.go('/home');
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Initialization Failed', style: AppTextStyles.titleLarge),
        content: Text('Failed to initialize app: $error', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => _initializeApp(),
            child: Text('Retry', style: AppTextStyles.buttonLarge),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          _buildBackground(isDark),
          
          // Animated gradient overlay
          _buildGradientOverlay(isDark),
          
          // Floating particles
          _buildParticles(),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top spacing
                SizedBox(height: 60.h),
                
                // Logo with animations
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAnimatedLogo(),
                        SizedBox(height: 32.h),
                        _buildAppTitle(),
                        SizedBox(height: 12.h),
                        _buildSubtitle(),
                      ],
                    ),
                  ),
                ),
                
                // Loading section
                _buildLoadingSection(theme),
                
                // Bottom spacing
                SizedBox(height: 48.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(bool isDark) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Image.asset(
          'assets/images/m6-splash-screen.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          color: isDark 
              ? Colors.black.withValues(alpha: 0.3 + _backgroundController.value * 0.2)
              : Colors.white.withValues(alpha: 0.1 + _backgroundController.value * 0.1),
          colorBlendMode: BlendMode.dstATop,
        );
      },
    );
  }

  Widget _buildGradientOverlay(bool isDark) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF0D0D0D).withValues(alpha: 0.9),
                      const Color(0xFF1A0A2E).withValues(alpha: 0.85),
                      const Color(0xFF16213E).withValues(alpha: 0.9),
                    ]
                  : [
                      const Color(0xFF0F0F1A).withValues(alpha: 0.95),
                      const Color(0xFF1A1A2E).withValues(alpha: 0.9),
                      const Color(0xFF16213E).withValues(alpha: 0.95),
                    ],
              stops: [
                0.0,
                0.5 + math.sin(_backgroundController.value * 2 * math.pi) * 0.1,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlePainter(
            particles: _particles,
            progress: _particleController.value,
            theme: Theme.of(context),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        final scale = Curves.elasticOut.transform(
          _logoController.value.clamp(0.0, 1.0),
        );
        final opacity = Curves.easeOut.transform(
          (_logoController.value * 1.5).clamp(0.0, 1.0),
        );
        final rotation = (_logoController.value - 1.0) * 0.1 * math.sin(_logoController.value * 4 * math.pi);
        
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(scale)
            ..rotateZ(rotation),
          child: Opacity(
            opacity: opacity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow ring
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    final glowScale = 1.0 + 0.3 * math.sin(_logoController.value * 2 * math.pi);
                    final glowOpacity = 0.3 + 0.2 * math.sin(_logoController.value * 4 * math.pi);
                    
                    return Transform.scale(
                      scale: glowScale,
                      child: Container(
                        width: 160.w,
                        height: 160.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.lightPrimary.withValues(alpha: glowOpacity),
                              AppColors.lightPrimary.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                // Logo image
                Image.asset(
                  'assets/images/m6-logo.png',
                  width: 140.w,
                  height: 140.w,
                  fit: BoxFit.contain,
                )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .shimmer(
                    duration: 3000.ms,
                    color: AppColors.lightPrimary.withValues(alpha: 0.5),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => AppGradients.primary.createShader(bounds),
      child: Text(
        'Brick Fall',
        style: AppTextStyles.displayMedium.copyWith(
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: -1.5,
          height: 1.1,
        ),
      ),
    )
      .animate()
      .fadeIn(duration: 800.ms, delay: 600.ms, curve: Curves.easeOut)
      .slideY(begin: 0.4, duration: 800.ms, delay: 600.ms, curve: Curves.easeOut);
  }

  Widget _buildSubtitle() {
    return Text(
      'Classic Arcade Action',
      style: AppTextStyles.titleMedium.copyWith(
        color: AppColors.lightOnSurface.withValues(alpha: 0.7),
        letterSpacing: 2.0,
        fontWeight: FontWeight.w500,
      ),
    )
      .animate()
      .fadeIn(duration: 800.ms, delay: 900.ms, curve: Curves.easeOut)
      .slideY(begin: 0.4, duration: 800.ms, delay: 900.ms, curve: Curves.easeOut);
  }

  Widget _buildLoadingSection(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPaddingHorizontal.w),
      child: Column(
        children: [
          // Status text
          AnimatedSwitcher(
            duration: AppAnimations.fast,
            child: Text(
              _initializationStatus,
              key: ValueKey(_initializationStatus),
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Progress bar
          Container(
            width: double.infinity,
            height: 6.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusRound.r),
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background track
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusRound.r),
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.surfaceContainerHighest,
                        theme.colorScheme.surfaceContainerHigh,
                      ],
                    ),
                  ),
                ),
                
                // Animated progress fill
                AnimatedBuilder(
                  animation: _loadingController,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      widthFactor: _initializationProgress,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusRound.r),
                          gradient: AppGradients.primary,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lightPrimary.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: _initializationProgress > 0.1
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: Icon(
                                    Icons.bolt_rounded,
                                    size: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
                
                // Shimmer sweep
                AnimatedBuilder(
                  animation: _loadingController,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      widthFactor: _initializationProgress,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusRound.r),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.3),
                              Colors.transparent,
                            ],
                            stops: [
                              (_loadingController.value - 0.3).clamp(0.0, 1.0),
                              _loadingController.value.clamp(0.0, 1.0),
                              (_loadingController.value + 0.3).clamp(0.0, 1.0),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          
          // Percentage
          AnimatedBuilder(
            animation: _loadingController,
            builder: (context, child) {
              return Text(
                '${(_initializationProgress * 100).toInt()}%',
                style: AppTextStyles.labelMedium.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              );
            },
          ),
        ],
      ),
    )
      .animate()
      .fadeIn(duration: 600.ms, delay: 1200.ms, curve: Curves.easeOut)
      .slideY(begin: 0.3, duration: 600.ms, delay: 1200.ms, curve: Curves.easeOut);
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final int colorIndex;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.colorIndex,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final ThemeData theme;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      AppColors.lightPrimary,
      AppColors.lightSecondary,
      AppColors.lightTertiary,
    ];

    for (final particle in particles) {
      final x = particle.x * size.width;
      final y = (particle.y + progress * particle.speed) % 1.0 * size.height;
      final radius = particle.size * (1.0 + 0.3 * math.sin(progress * 4 * math.pi + particle.x * 10));
      final opacity = particle.opacity * (0.5 + 0.5 * math.sin(progress * 2 * math.pi + particle.y * 10));
      
      final paint = Paint()
        ..color = colors[particle.colorIndex].withValues(alpha: opacity)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _ParticlePainter && oldDelegate.progress != progress;
  }
}