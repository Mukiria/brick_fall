import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import '../../core/design/design_system.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _themeTransitionController;
  late final AnimationController _statsController;
  late final AnimationController _buttonHoverController;

  ThemeMode _selectedThemeMode = ThemeMode.system;
  bool _showThemeSelector = false;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
    
    _themeTransitionController = AnimationController(
      duration: AppAnimations.pageTransition,
      vsync: this,
    );
    
    _statsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _buttonHoverController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    
    _statsController.forward();
    
    // Start background music
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).playMusic('audio/background_music.mp3');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = ref.read(settingsProvider).value;
    if (settings != null) {
      _selectedThemeMode = ThemeMode.values[settings.themeModeIndex];
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    _themeTransitionController.dispose();
    _statsController.dispose();
    _buttonHoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statisticsAsync = ref.watch(statisticsProvider);
    final gameLoop = ref.watch(gameLoopProvider);
    final hasSavedGame = gameLoop.currentState.state != CoreGameState.idle && 
                         gameLoop.currentState.state != CoreGameState.gameOver;
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(theme),
          
          // Floating geometric shapes
          _buildFloatingShapes(theme),
          
          // Main Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWide ? 48.w : AppSpacing.screenPaddingHorizontal.w,
                          vertical: 24.h,
                        ),
                        child: Column(
                          children: [
                            // Header with theme selector
                            _buildHeader(theme, isWide)
                              .animate()
                              .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                              .slideY(begin: -0.3, duration: 600.ms, curve: Curves.easeOut),
                            
                            SizedBox(height: 40.h),
                            
                            // Title Section
                            _buildTitleSection(theme, isWide)
                              .animate()
                              .fadeIn(duration: 800.ms, delay: 200.ms, curve: Curves.easeOut)
                              .slideY(begin: 0.3, duration: 800.ms, delay: 200.ms, curve: Curves.easeOut),
                            
                            SizedBox(height: 48.h),
                            
                            // Main Action Buttons
                            _buildMainActions(theme, hasSavedGame, isWide)
                              .animate()
                              .fadeIn(duration: 600.ms, delay: 400.ms, curve: Curves.easeOut)
                              .slideY(begin: 0.3, duration: 600.ms, delay: 400.ms, curve: Curves.easeOut),
                            
                            SizedBox(height: 32.h),
                            
                            // Secondary Actions
                            _buildSecondaryActions(theme, isWide)
                              .animate()
                              .fadeIn(duration: 600.ms, delay: 600.ms, curve: Curves.easeOut)
                              .slideY(begin: 0.3, duration: 600.ms, delay: 600.ms, curve: Curves.easeOut),
                            
                            SizedBox(height: 40.h),
                            
                            // Stats Preview
                            _buildStatsPreview(theme, statisticsAsync, isWide)
                              .animate()
                              .fadeIn(duration: 800.ms, delay: 800.ms, curve: Curves.easeOut)
                              .slideY(begin: 0.3, duration: 800.ms, delay: 800.ms, curve: Curves.easeOut),
                            
                            const Spacer(),
                            
                            // Footer
                            _buildFooter(theme)
                              .animate()
                              .fadeIn(duration: 600.ms, delay: 1000.ms, curve: Curves.easeOut),
                            
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Theme Selector Overlay
          if (_showThemeSelector) _buildThemeSelectorOverlay(theme),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(ThemeData theme) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return CustomPaint(
          painter: _PremiumBackgroundPainter(
            progress: _bgController.value,
            theme: theme,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildFloatingShapes(ThemeData theme) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return CustomPaint(
          painter: _FloatingShapesPainter(
            progress: _bgController.value,
            theme: theme,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, bool isWide) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo/Brand
        Row(
          children: [
            Container(
              width: isWide ? 48.w : 40.w,
              height: isWide ? 48.w : 40.w,
              decoration: BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.games_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: isWide ? 28.sp : 24.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => AppGradients.primary.createShader(bounds),
                  child: Text(
                    'Brick Fall',
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                Text(
                  'Classic Arcade Action',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
        
        // Theme Selector Button
        _buildThemeSelectorButton(theme),
      ],
    );
  }

  Widget _buildThemeSelectorButton(ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() => _showThemeSelector = true);
          _themeTransitionController.forward();
          ref.read(audioServiceProvider).playTap();
        },
        borderRadius: BorderRadius.circular(AppSpacing.radiusRound.r),
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(AppSpacing.radiusRound.r),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getThemeIcon(_selectedThemeMode),
                color: theme.colorScheme.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                _getThemeLabel(_selectedThemeMode),
                style: AppTextStyles.labelMedium.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSelectorOverlay(ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Backdrop
          GestureDetector(
            onTap: () {
              _themeTransitionController.reverse().then((_) {
                if (mounted) setState(() => _showThemeSelector = false);
              });
            },
            child: AnimatedContainer(
              duration: AppAnimations.modalEnter,
              curve: Curves.easeOut,
              color: Colors.black.withValues(alpha: 0.5 * _themeTransitionController.value),
            ),
          ),
          
          // Selector Panel
          Align(
            alignment: Alignment.topRight,
            child: AnimatedBuilder(
              animation: _themeTransitionController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -20 * (1 - _themeTransitionController.value)),
                  child: Opacity(
                    opacity: _themeTransitionController.value,
                    child: child!,
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 16.h, right: 16.w),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius.r),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ThemeMode.values.map((mode) {
                    final isSelected = mode == _selectedThemeMode;
                    return _ThemeOptionTile(
                      mode: mode,
                      isSelected: isSelected,
                      onTap: () => _selectTheme(mode),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectTheme(ThemeMode mode) {
    setState(() => _selectedThemeMode = mode);
    _themeTransitionController.reverse().then((_) {
      if (mounted) setState(() => _showThemeSelector = false);
    });
    
    final settings = ref.read(settingsProvider).value ?? Settings.defaultSettings();
    ref.read(settingsNotifierProvider.notifier).updateSettings(
      settings.copyWith(themeModeIndex: mode.index),
    );
    
    ref.read(audioServiceProvider).playTap();
  }

  Widget _buildTitleSection(ThemeData theme, bool isWide) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppGradients.primary.createShader(bounds),
          child: Text(
            'READY TO PLAY?',
            style: AppTextStyles.displaySmall.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Stack. Clear. Conquer.',
          style: AppTextStyles.titleMedium.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMainActions(ThemeData theme, bool hasSavedGame, bool isWide) {
    final buttonWidth = isWide ? 320.w : double.infinity;
    
    return Column(
      children: [
        // Continue Game (if available)
        if (hasSavedGame) ...[
          _AnimatedActionButton(
            label: 'CONTINUE GAME',
            icon: Icons.play_arrow_rounded,
            gradient: AppGradients.primary,
            iconColor: theme.colorScheme.onPrimary,
            onTap: () {
              ref.read(audioServiceProvider).playTap();
              context.push('/game');
            },
            width: buttonWidth,
            isPrimary: true,
          ),
          SizedBox(height: 16.h),
        ],
        
        // New Game
        _AnimatedActionButton(
          label: 'NEW GAME',
          icon: Icons.refresh_rounded,
          gradient: AppGradients.tertiary,
          iconColor: theme.colorScheme.onPrimary,
          onTap: () => _showDifficultyDialog(context),
          width: buttonWidth,
          isPrimary: true,
        ),
      ],
    );
  }

  Widget _buildSecondaryActions(ThemeData theme, bool isWide) {
    final buttonWidth = isWide ? 152.w : double.infinity;
    final spacing = isWide ? 16.w : 16.h;
    
    final actions = [
      _SecondaryActionConfig(
        label: 'Statistics',
        icon: Icons.bar_chart_rounded,
        gradient: AppGradients.secondary,
        onTap: () {
          ref.read(audioServiceProvider).playTap();
          context.push('/statistics');
        },
      ),
      _SecondaryActionConfig(
        label: 'Achievements',
        icon: Icons.emoji_events_rounded,
        gradient: AppGradients.levelUp,
        onTap: () {
          ref.read(audioServiceProvider).playTap();
          context.push('/achievements');
        },
      ),
      _SecondaryActionConfig(
        label: 'Settings',
        icon: Icons.settings_rounded,
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surfaceContainerHighest,
            theme.colorScheme.surfaceContainerHigh,
          ],
        ),
        onTap: () {
          ref.read(audioServiceProvider).playTap();
          context.push('/settings');
        },
      ),
    ];

    if (isWide) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: actions.map((action) => 
          Expanded(
            child: _AnimatedActionButton(
              label: action.label,
              icon: action.icon,
              gradient: action.gradient,
              iconColor: theme.colorScheme.onSurface,
              onTap: action.onTap,
              width: buttonWidth,
              isPrimary: false,
            ),
          ),
        ).expand((widget) => [widget, SizedBox(width: spacing)]).take(actions.length * 2 - 1).toList(),
      );
    } else {
      return Column(
        children: actions.map((action) => 
          Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: _AnimatedActionButton(
              label: action.label,
              icon: action.icon,
              gradient: action.gradient,
              iconColor: theme.colorScheme.onSurface,
              onTap: action.onTap,
              width: buttonWidth,
              isPrimary: false,
            ),
          ),
        ).toList(),
      );
    }
  }

  void _showDifficultyDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _DifficultyDialog(
        onSelect: (difficulty) {
          ref.read(gameLoopProvider).start(difficulty: difficulty);
          context.push('/game');
        },
      ),
    );
  }

  Widget _buildStatsPreview(ThemeData theme, AsyncValue<Statistics> statisticsAsync, bool isWide) {
    return statisticsAsync.when(
      data: (stats) => _StatsPreviewCard(stats: stats, isWide: isWide),
      loading: () => _StatsPreviewSkeleton(isWide: isWide),
      error: (_, __) => _StatsPreviewSkeleton(isWide: isWide),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Column(
      children: [
        Divider(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          height: 1,
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.code_rounded,
              size: 16.sp,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            SizedBox(width: 8.w),
            Text(
              'v1.0.0 • Built with Flutter & ❤️',
              style: AppTextStyles.labelSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.system:
      default:
        return Icons.settings_brightness_rounded;
    }
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
      default:
        return 'System';
    }
  }
}

class _SecondaryActionConfig {
  final String label;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  _SecondaryActionConfig({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });
}

class _AnimatedActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Gradient gradient;
  final Color iconColor;
  final VoidCallback onTap;
  final double width;
  final bool isPrimary;

  const _AnimatedActionButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.iconColor,
    required this.onTap,
    required this.width,
    required this.isPrimary,
  });

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton> 
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final AnimationController _hoverController;
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: AppAnimations.micro,
      vsync: this,
    );
    _hoverController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pressController.dispose();
    _hoverController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _pressController.reverse();
  }

  void _handleTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    
    return MouseRegion(
      onEnter: (_) {
        _hoverController.forward();
      },
      onExit: (_) {
        _hoverController.reverse();
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pressController, _hoverController, _shimmerController]),
          builder: (context, child) {
            final pressScale = 1.0 - _pressController.value * 0.05;
            final hoverScale = 1.0 + _hoverController.value * 0.02;
            final scale = pressScale * hoverScale;
            final elevation = widget.isPrimary 
                ? 4.0 + _hoverController.value * 8.0
                : 2.0 + _hoverController.value * 4.0;
            final glowOpacity = _hoverController.value * 0.4;
            
            return Transform.scale(
              scale: scale,
              child: Container(
                width: widget.width,
                height: widget.isPrimary ? 64.h : 56.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusLarge.r),
                  gradient: widget.gradient,
                  boxShadow: [
                    BoxShadow(
                      color: widget.gradient.colors.first.withValues(alpha: glowOpacity),
                      blurRadius: 20 * elevation / 4,
                      spreadRadius: 2,
                      offset: Offset(0, elevation / 2),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1 * elevation / 4),
                      blurRadius: 8 * elevation / 4,
                      offset: Offset(0, elevation / 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Shimmer sweep
                    if (widget.isPrimary)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusLarge.r),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withValues(alpha: 0.2),
                                  Colors.transparent,
                                ],
                                stops: [
                                  (_shimmerController.value - 0.3).clamp(0.0, 1.0),
                                  _shimmerController.value.clamp(0.0, 1.0),
                                  (_shimmerController.value + 0.3).clamp(0.0, 1.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    
                    // Content
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.icon,
                            color: widget.iconColor,
                            size: widget.isPrimary ? 28.sp : 24.sp,
                          ),
                          SizedBox(width: 12.w),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [widget.iconColor, widget.iconColor.withValues(alpha: 0.7)],
                            ).createShader(bounds),
                            child: Text(
                              widget.label,
                              style: AppTextStyles.buttonLarge.copyWith(
                                color: widget.iconColor,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatsPreviewCard extends StatelessWidget {
  final Statistics stats;
  final bool isWide;

  const _StatsPreviewCard({
    required this.stats,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: isWide ? 600.w : double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
            theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge.r),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: AppGradients.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
                ),
                child: Icon(
                  Icons.analytics_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'YOUR STATS',
                style: AppTextStyles.labelLarge.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          
          if (isWide)
            Row(
              children: _buildStatItems(theme, stats).map((item) => 
                Expanded(child: item),
              ).toList(),
            )
          else
            Wrap(
              spacing: 16.w,
              runSpacing: 16.h,
              alignment: WrapAlignment.center,
              children: _buildStatItems(theme, stats).map((item) => 
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 80.w) / 2,
                  child: item,
                ),
              ).toList(),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildStatItems(ThemeData theme, Statistics stats) {
    final statItems = [
      _StatItemConfig(
        label: 'Games Played',
        value: stats.gamesPlayed.toString(),
        icon: Icons.games_rounded,
        color: theme.colorScheme.primary,
        gradient: AppGradients.primary,
      ),
      _StatItemConfig(
        label: 'Best Score',
        value: _formatScore(stats.highScore),
        icon: Icons.star_rounded,
        color: theme.colorScheme.tertiary,
        gradient: AppGradients.tertiary,
      ),
      _StatItemConfig(
        label: 'Current Streak',
        value: '${stats.gamesPlayed > 0 ? 1 : 0}',
        icon: Icons.local_fire_department_rounded,
        color: theme.colorScheme.error,
        gradient: AppGradients.buttonDanger,
      ),
      _StatItemConfig(
        label: 'Lines Cleared',
        value: stats.totalLinesCleared.toString(),
        icon: Icons.format_list_numbered_rounded,
        color: theme.colorScheme.secondary,
        gradient: AppGradients.secondary,
      ),
    ];

    return statItems.map((config) => _AnimatedStatItem(config: config)).toList();
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

class _StatItemConfig {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Gradient gradient;

  _StatItemConfig({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.gradient,
  });
}

class _AnimatedStatItem extends StatefulWidget {
  final _StatItemConfig config;

  const _AnimatedStatItem({required this.config});

  @override
  State<_AnimatedStatItem> createState() => _AnimatedStatItemState();
}

class _AnimatedStatItemState extends State<_AnimatedStatItem> 
    with SingleTickerProviderStateMixin {
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
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: Curves.easeOut.transform(_controller.value),
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _controller.value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius.r),
          border: Border.all(
            color: widget.config.color.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: widget.config.gradient,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
                boxShadow: [
                  BoxShadow(
                    color: widget.config.color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                widget.config.icon,
                color: Colors.white,
                size: 28.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              widget.config.value,
              style: AppTextStyles.headlineSmall.copyWith(
                color: widget.config.color,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              widget.config.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsPreviewSkeleton extends StatelessWidget {
  final bool isWide;

  const _StatsPreviewSkeleton({required this.isWide});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: isWide ? 600.w : double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge.r),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
                ),
                child: Icon(
                  Icons.analytics_rounded,
                  color: theme.colorScheme.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 100.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
                ),
              ).animate().shimmer(),
            ],
          ),
          SizedBox(height: 20.h),
          if (isWide)
            Row(
              children: List.generate(4, (index) => 
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: _SkeletonStatItem(),
                  ),
                ),
              ),
            )
          else
            Wrap(
              spacing: 16.w,
              runSpacing: 16.h,
              children: List.generate(4, (index) => 
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 80.w) / 2,
                  child: _SkeletonStatItem(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SkeletonStatItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius.r),
      ),
      child: Column(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
            ),
          ).animate().shimmer(),
          SizedBox(height: 12.h),
          Container(
            width: 60.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
            ),
          ).animate().shimmer(),
          SizedBox(height: 4.h),
          Container(
            width: 80.w,
            height: 14.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
            ),
          ).animate().shimmer(),
        ],
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final ThemeMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected 
                ? theme.colorScheme.primaryContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
            border: isSelected
                ? Border.all(color: theme.colorScheme.primary, width: 2)
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r),
                ),
                child: Icon(
                  _getIcon(mode),
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                _getLabel(mode),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: theme.colorScheme.primary,
                  size: 24.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.system:
      default:
        return Icons.settings_brightness_rounded;
    }
  }

  String _getLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
      default:
        return 'System';
    }
  }
}

class _DifficultyDialog extends ConsumerStatefulWidget {
  final Function(Difficulty) onSelect;

  const _DifficultyDialog({required this.onSelect});

  @override
  ConsumerState<_DifficultyDialog> createState() => _DifficultyDialogState();
}

class _DifficultyDialogState extends ConsumerState<_DifficultyDialog> 
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  Difficulty _selectedDifficulty = Difficulty.normal;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.modalEnter,
      vsync: this,
    )..forward();
    
    final settings = ref.read(settingsProvider).value;
    if (settings != null) {
      _selectedDifficulty = settings.defaultDifficulty;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _controller.value,
            child: Transform.scale(
              scale: 0.9 + 0.1 * Curves.easeOut.transform(_controller.value),
              child: Dialog(
                backgroundColor: theme.colorScheme.surface,
                surfaceTintColor: theme.colorScheme.surfaceTint,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.dialogRadius.r),
                ),
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.dialogRadius.r),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.surface,
                        theme.colorScheme.surfaceContainerLow,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select Difficulty',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Choose your challenge level',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      ...Difficulty.values.map((difficulty) => 
                        _DifficultyTile(
                          difficulty: difficulty,
                          isSelected: difficulty == _selectedDifficulty,
                          onTap: () => setState(() => _selectedDifficulty = difficulty),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.buttonRadius.r),
                                ),
                              ),
                              child: Text('Cancel', style: AppTextStyles.buttonMedium),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                widget.onSelect(_selectedDifficulty);
                                Navigator.pop(context);
                              },
                              style: FilledButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.buttonRadius.r),
                                ),
                              ),
                              child: Text('Start Game', style: AppTextStyles.buttonMedium),
                            ),
                          ),
                        ],
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

class _DifficultyTile extends StatelessWidget {
  final Difficulty difficulty;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyTile({
    required this.difficulty,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = _getDifficultyConfig(difficulty);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius.r),
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius.r),
            border: Border.all(
              color: isSelected 
                  ? config.color 
                  : theme.colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected
                ? config.color.withValues(alpha: 0.1)
                : theme.colorScheme.surfaceContainerLowest,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: config.color.withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  gradient: config.gradient,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd.r),
                ),
                child: Icon(
                  config.icon,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      difficulty.name.toUpperCase(),
                      style: AppTextStyles.titleMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      config.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: config.color,
                  size: 28.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }

  _DifficultyConfig _getDifficultyConfig(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return _DifficultyConfig(
          color: Colors.green,
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade600],
          ),
          icon: Icons.sentiment_very_satisfied_rounded,
          description: 'Relaxed pace, perfect for learning',
        );
      case Difficulty.normal:
        return _DifficultyConfig(
          color: Colors.orange,
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.orange.shade600],
          ),
          icon: Icons.sentiment_satisfied_rounded,
          description: 'Classic Tetris experience',
        );
      case Difficulty.hard:
        return _DifficultyConfig(
          color: Colors.red,
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade600],
          ),
          icon: Icons.sentiment_very_dissatisfied_rounded,
          description: 'Fast drops, high intensity',
        );
      case Difficulty.expert:
        return _DifficultyConfig(
          color: Colors.purple,
          gradient: LinearGradient(
            colors: [Colors.purple.shade400, Colors.purple.shade600],
          ),
          icon: Icons.whatshot_rounded,
          description: 'Maximum speed, for masters only',
        );
    }
  }
}

class _DifficultyConfig {
  final Color color;
  final Gradient gradient;
  final IconData icon;
  final String description;

  _DifficultyConfig({
    required this.color,
    required this.gradient,
    required this.icon,
    required this.description,
  });
}

class _PremiumBackgroundPainter extends CustomPainter {
  final double progress;
  final ThemeData theme;

  _PremiumBackgroundPainter({
    required this.progress,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Base gradient
    final baseRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final baseGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        theme.colorScheme.surface,
        theme.colorScheme.surfaceContainerLow,
        theme.colorScheme.surfaceContainer,
      ],
      stops: const [0.0, 0.5, 1.0],
    );
    canvas.drawRect(baseRect, Paint()..shader = baseGradient.createShader(baseRect));

    // Grid pattern
    final gridPaint = Paint()
      ..color = theme.colorScheme.primary.withValues(alpha: 0.03)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    
    const gridSpacing = 40.0;
    final offsetX = (progress * gridSpacing) % gridSpacing;
    final offsetY = (progress * gridSpacing * 0.5) % gridSpacing;
    
    for (double x = -offsetX; x < size.width + gridSpacing; x += gridSpacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }
    for (double y = -offsetY; y < size.height + gridSpacing; y += gridSpacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Subtle diagonal lines
    final diagonalPaint = Paint()
      ..color = theme.colorScheme.secondary.withValues(alpha: 0.02)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    const diagonalSpacing = 80.0;
    final diagonalOffset = (progress * diagonalSpacing) % diagonalSpacing;
    
    for (double i = -diagonalOffset - size.height; i < size.width + diagonalSpacing; i += diagonalSpacing) {
      final path = Path()
        ..moveTo(i, 0)
        ..lineTo(i + size.height, size.height);
      canvas.drawPath(path, diagonalPaint);
    }

    // Radial gradient orbs
    for (int i = 0; i < 3; i++) {
      final angle = progress * 2 * math.pi + i * 2 * math.pi / 3;
      final radius = math.min(size.width, size.height) * 0.4;
      final centerX = size.width * 0.5 + radius * 0.6 * math.cos(angle);
      final centerY = size.height * 0.5 + radius * 0.6 * math.sin(angle);
      
      final orbRadius = math.min(size.width, size.height) * 0.35;
      final orbPaint = Paint()..shader = RadialGradient(
        colors: [
          _getOrbColor(i).withValues(alpha: 0.15),
          _getOrbColor(i).withValues(alpha: 0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: orbRadius,
      ));
      
      canvas.drawCircle(Offset(centerX, centerY), orbRadius, orbPaint);
    }
  }

  Color _getOrbColor(int index) {
    switch (index) {
      case 0: return theme.colorScheme.primary;
      case 1: return theme.colorScheme.secondary;
      case 2: return theme.colorScheme.tertiary;
      default: return theme.colorScheme.primary;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _FloatingShapesPainter extends CustomPainter {
  final double progress;
  final ThemeData theme;

  _FloatingShapesPainter({
    required this.progress,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Draw tetromino-like shapes floating
    for (int i = 0; i < 8; i++) {
      final baseX = size.width * (i / 8.0);
      final baseY = size.height * 0.2;
      
      final x = baseX + size.width * 0.12 * math.sin(progress * 2 * math.pi + i * 1.5);
      final y = baseY + size.height * 0.5 * (0.5 + 0.5 * math.sin(progress * 1.5 * math.pi + i * 0.8));
      
      final rotation = progress * math.pi * 0.5 + i * 0.7;
      final scale = 0.8 + 0.2 * math.sin(progress * 2 * math.pi + i);
      final opacity = 0.15 + 0.1 * math.sin(progress * math.pi + i);
      
      final colors = [
        theme.colorScheme.primary,
        theme.colorScheme.secondary,
        theme.colorScheme.tertiary,
        theme.colorScheme.error,
      ];
      
      paint.color = colors[i % colors.length].withValues(alpha: opacity);
      
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      canvas.scale(scale);
      
      _drawTetromino(canvas, paint, i % 7, 20.0);
      
      canvas.restore();
    }
  }

  void _drawTetromino(Canvas canvas, Paint paint, int type, double blockSize) {
    final blocks = _getTetrominoBlocks(type);
    final radius = blockSize * 0.15;
    
    for (final block in blocks) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(block.dx * blockSize, block.dy * blockSize),
          width: blockSize * 0.9,
          height: blockSize * 0.9,
        ),
        Radius.circular(radius),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  List<Offset> _getTetrominoBlocks(int type) {
    switch (type) {
      case 0: // I
        return [Offset(-1.5, 0), Offset(-0.5, 0), Offset(0.5, 0), Offset(1.5, 0)];
      case 1: // J
        return [Offset(-1, -1), Offset(-1, 0), Offset(0, 0), Offset(1, 0)];
      case 2: // L
        return [Offset(1, -1), Offset(-1, 0), Offset(0, 0), Offset(1, 0)];
      case 3: // O
        return [Offset(-0.5, -0.5), Offset(0.5, -0.5), Offset(-0.5, 0.5), Offset(0.5, 0.5)];
      case 4: // S
        return [Offset(-0.5, -1), Offset(0.5, -1), Offset(-1, 0), Offset(0, 0)];
      case 5: // T
        return [Offset(-1, -1), Offset(0, -1), Offset(1, -1), Offset(0, 0)];
      case 6: // Z
        return [Offset(-1, -1), Offset(0, -1), Offset(0, 0), Offset(1, 0)];
      default:
        return [];
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}