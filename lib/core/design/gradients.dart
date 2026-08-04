// lib/core/design/gradients.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'colors.dart';

/// Reusable gradient definitions for consistent visual design
class AppGradients {
  AppGradients._();

  // ============================================
  // PRIMARY GRADIENTS
  // ============================================
  
  // Main brand gradient
  static const LinearGradient primary = LinearGradient(
    colors: AppColors.primaryGradient,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryReverse = LinearGradient(
    colors: AppColors.primaryGradient,
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
  );

  static const LinearGradient primaryHorizontal = LinearGradient(
    colors: AppColors.primaryGradient,
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient primaryVertical = LinearGradient(
    colors: AppColors.primaryGradient,
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Primary with transparency
  static const LinearGradient primaryTransparent = LinearGradient(
    colors: [
      Color(0xFF7C4DFF),
      Color(0x007C4DFF),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ============================================
  // SECONDARY GRADIENTS
  // ============================================
  
  static const LinearGradient secondary = LinearGradient(
    colors: AppColors.secondaryGradient,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryHorizontal = LinearGradient(
    colors: AppColors.secondaryGradient,
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient secondaryVertical = LinearGradient(
    colors: AppColors.secondaryGradient,
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ============================================
  // TERTIARY GRADIENTS
  // ============================================
  
  static const LinearGradient tertiary = LinearGradient(
    colors: AppColors.tertiaryGradient,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tertiaryHorizontal = LinearGradient(
    colors: AppColors.tertiaryGradient,
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ============================================
  // SURFACE GRADIENTS
  // ============================================
  
  // Light theme surface gradient
  static const LinearGradient surfaceLight = LinearGradient(
    colors: AppColors.surfaceGradientLight,
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Dark theme surface gradient
  static const LinearGradient surfaceDark = LinearGradient(
    colors: AppColors.surfaceGradientDark,
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Subtle surface gradient for cards
  static const LinearGradient surfaceSubtleLight = LinearGradient(
    colors: [
      Color(0xFFF8FAFD),
      Color(0xFFF0F2F5),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceSubtleDark = LinearGradient(
    colors: [
      Color(0xFF1E2022),
      Color(0xFF1A1C1E),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================
  // NEUMORPHIC GRADIENTS
  // ============================================
  
  // Light neumorphic raised
  static const LinearGradient neumorphicRaisedLight = LinearGradient(
    colors: [
      AppColors.lightNeumorphicLight,
      AppColors.lightNeumorphicBase,
      AppColors.lightNeumorphicDark,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  // Light neumorphic pressed
  static const LinearGradient neumorphicPressedLight = LinearGradient(
    colors: [
      AppColors.lightNeumorphicDark,
      AppColors.lightNeumorphicBase,
      AppColors.lightNeumorphicLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  // Dark neumorphic raised
  static const LinearGradient neumorphicRaisedDark = LinearGradient(
    colors: [
      AppColors.darkNeumorphicLight,
      AppColors.darkNeumorphicBase,
      AppColors.darkNeumorphicDark,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  // Dark neumorphic pressed
  static const LinearGradient neumorphicPressedDark = LinearGradient(
    colors: [
      AppColors.darkNeumorphicDark,
      AppColors.darkNeumorphicBase,
      AppColors.darkNeumorphicLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  // ============================================
  // GLASSMORPHIC GRADIENTS
  // ============================================
  
  static const LinearGradient glassLight = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xCCFFFFFF),
      Color(0x99FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient glassDark = LinearGradient(
    colors: [
      Color(0x33FFFFFF),
      Color(0x22FFFFFF),
      Color(0x11FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  // ============================================
  // GAME-SPECIFIC GRADIENTS
  // ============================================
  
  // Next piece preview background
  static const LinearGradient nextPiecePreview = LinearGradient(
    colors: [
      Color(0xFF1E2022),
      Color(0xFF16181A),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Hold piece background
  static const LinearGradient holdPiecePreview = LinearGradient(
    colors: [
      Color(0xFF1A1C1E),
      Color(0xFF16181A),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Game area background
  static const LinearGradient gameAreaLight = LinearGradient(
    colors: [
      Color(0xFFF8FAFD),
      Color(0xFFE8ECF1),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient gameAreaDark = LinearGradient(
    colors: [
      Color(0xFF1E2022),
      Color(0xFF16181A),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Level up celebration
  static const LinearGradient levelUp = LinearGradient(
    colors: [
      Color(0xFFFFD600),
      Color(0xFFFF6D00),
      Color(0xFFEC407A),
      Color(0xFF7C4DFF),
      Color(0xFF00E5FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  );

  // Game over overlay
  static const LinearGradient gameOverOverlay = LinearGradient(
    colors: [
      Color(0xCC1A1C1E),
      Color(0x991A1C1E),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Pause overlay
  static const LinearGradient pauseOverlay = LinearGradient(
    colors: [
      Color(0x991A1C1E),
      Color(0x661A1C1E),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Score counter highlight
  static const LinearGradient scoreHighlight = LinearGradient(
    colors: [
      Color(0xFFFFD600),
      Color(0xFFFFEB3B),
      Color(0xFFFFD600),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.5, 1.0],
  );

  // Line clear flash
  static const LinearGradient lineClearFlash = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFE0F7FA),
      Color(0xFFFFFFFF),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.5, 1.0],
  );

  // ============================================
  // RADIAL GRADIENTS
  // ============================================
  
  static const RadialGradient radialPrimary = RadialGradient(
    colors: AppColors.primaryGradient,
    center: Alignment.center,
    radius: 1.0,
  );

  static const RadialGradient radialSecondary = RadialGradient(
    colors: AppColors.secondaryGradient,
    center: Alignment.center,
    radius: 1.0,
  );

  static const RadialGradient radialTertiary = RadialGradient(
    colors: AppColors.tertiaryGradient,
    center: Alignment.center,
    radius: 1.0,
  );

  // Glow effects
  static const RadialGradient glowPrimary = RadialGradient(
    colors: [
      Color(0xFF7C4DFF),
      Color(0x447C4DFF),
      Color(0x007C4DFF),
    ],
    center: Alignment.center,
    radius: 1.0,
    stops: [0.0, 0.5, 1.0],
  );

  static const RadialGradient glowSecondary = RadialGradient(
    colors: [
      Color(0xFF00BCD4),
      Color(0x4400BCD4),
      Color(0x0000BCD4),
    ],
    center: Alignment.center,
    radius: 1.0,
    stops: [0.0, 0.5, 1.0],
  );

  static const RadialGradient glowNeonCyan = RadialGradient(
    colors: [
      Color(0xFF00FFFF),
      Color(0x4400FFFF),
      Color(0x0000FFFF),
    ],
    center: Alignment.center,
    radius: 1.0,
    stops: [0.0, 0.5, 1.0],
  );

  static const RadialGradient glowNeonMagenta = RadialGradient(
    colors: [
      Color(0xFFFF00FF),
      Color(0x44FF00FF),
      Color(0x00FF00FF),
    ],
    center: Alignment.center,
    radius: 1.0,
    stops: [0.0, 0.5, 1.0],
  );

  // ============================================
  // SWEEP GRADIENTS (for loading spinners)
  // ============================================
  
  static const SweepGradient sweepPrimary = SweepGradient(
    colors: AppColors.primaryGradient,
    center: Alignment.center,
    startAngle: 0,
    endAngle: 2 * 3.14159,
  );

  static const SweepGradient sweepRainbow = SweepGradient(
    colors: [
      Color(0xFF7C4DFF),
      Color(0xFF00BCD4),
      Color(0xFFEC407A),
      Color(0xFF7C4DFF),
    ],
    center: Alignment.center,
    startAngle: 0,
    endAngle: 2 * 3.14159,
  );

  // ============================================
  // BUTTON GRADIENTS
  // ============================================
  
  static const LinearGradient buttonPrimary = LinearGradient(
    colors: [
      Color(0xFF7C4DFF),
      Color(0xFF9C6DFF),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient buttonPrimaryPressed = LinearGradient(
    colors: [
      Color(0xFF5E35B1),
      Color(0xFF7C4DFF),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient buttonSecondary = LinearGradient(
    colors: [
      Color(0xFF00BCD4),
      Color(0xFF26C6DA),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient buttonSecondaryPressed = LinearGradient(
    colors: [
      Color(0xFF00838F),
      Color(0xFF00BCD4),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient buttonTertiary = LinearGradient(
    colors: [
      Color(0xFFEC407A),
      Color(0xFFF06292),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient buttonTertiaryPressed = LinearGradient(
    colors: [
      Color(0xFFC2185B),
      Color(0xFFEC407A),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient buttonDanger = LinearGradient(
    colors: [
      Color(0xFFE53935),
      Color(0xFFEF5350),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient buttonDangerPressed = LinearGradient(
    colors: [
      Color(0xFFC62828),
      Color(0xFFE53935),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Ghost button
  static const LinearGradient buttonGhostLight = LinearGradient(
    colors: [
      Color(0x1A7C4DFF),
      Color(0x0D7C4DFF),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient buttonGhostDark = LinearGradient(
    colors: [
      Color(0x1AFFFFFF),
      Color(0x0DFFFFFF),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ============================================
  // PROGRESS BAR GRADIENTS
  // ============================================
  
  static const LinearGradient progressPrimary = LinearGradient(
    colors: AppColors.primaryGradient,
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient progressSecondary = LinearGradient(
    colors: AppColors.secondaryGradient,
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient progressTertiary = LinearGradient(
    colors: AppColors.tertiaryGradient,
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient progressRainbow = LinearGradient(
    colors: [
      Color(0xFF7C4DFF),
      Color(0xFF00BCD4),
      Color(0xFFEC407A),
      Color(0xFF76FF03),
      Color(0xFFFFD600),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ============================================
  // SHIMMER GRADIENTS
  // ============================================
  
  static const LinearGradient shimmerLight = LinearGradient(
    colors: [
      Color(0xFFF0F2F5),
      Color(0xFFE8ECF1),
      Color(0xFFF0F2F5),
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient shimmerDark = LinearGradient(
    colors: [
      Color(0xFF2A2D30),
      Color(0xFF35383C),
      Color(0xFF2A2D30),
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    stops: [0.0, 0.5, 1.0],
  );

  // ============================================
  // HELPER METHODS
  // ============================================
  
  static LinearGradient lerp(LinearGradient a, LinearGradient b, double t) {
    final begin = a.begin;
    final end = a.end;
    final beginB = b.begin;
    final endB = b.end;
    
    return LinearGradient(
      colors: List.generate(
        a.colors.length,
        (i) => Color.lerp(a.colors[i], b.colors[i], t)!,
      ),
      begin: _lerpAlignment(begin, beginB, t),
      end: _lerpAlignment(end, endB, t),
      stops: a.stops != null && b.stops != null
          ? List.generate(
              a.stops!.length,
              (i) => lerpDouble(a.stops![i], b.stops![i], t)!,
            )
          : null,
      tileMode: a.tileMode,
      transform: a.transform,
    );
  }

  static Alignment _lerpAlignment(AlignmentGeometry? a, AlignmentGeometry? b, double t) {
    if (a == null || b == null) return Alignment.center;
    return Alignment.lerp(a as Alignment, b as Alignment, t)!;
  }

  static RadialGradient lerpRadial(RadialGradient a, RadialGradient b, double t) {
    return RadialGradient(
      colors: List.generate(
        a.colors.length,
        (i) => Color.lerp(a.colors[i], b.colors[i], t)!,
      ),
      center: _lerpAlignment(a.center, b.center, t),
      radius: lerpDouble(a.radius, b.radius, t)!,
      stops: a.stops != null && b.stops != null
          ? List.generate(
              a.stops!.length,
              (i) => lerpDouble(a.stops![i], b.stops![i], t)!,
            )
          : null,
      tileMode: a.tileMode,
    );
  }
}