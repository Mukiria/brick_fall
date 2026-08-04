// lib/core/design/colors.dart
import 'package:flutter/material.dart';

/// Modern game UI color system with vibrant colors and neumorphic influences
class AppColors {
  AppColors._();

  // ============================================
  // SEMANTIC COLORS (Light Theme)
  // ============================================
  
  // Primary - Vibrant electric purple
  static const Color lightPrimary = Color(0xFF7C4DFF);
  static const Color lightPrimaryContainer = Color(0xFFEDE7F6);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnPrimaryContainer = Color(0xFF1F0058);
  static const Color lightPrimaryFixed = Color(0xFFEDE7F6);
  static const Color lightPrimaryFixedDim = Color(0xFFD1C4E9);
  static const Color lightOnPrimaryFixed = Color(0xFF1F0058);
  static const Color lightOnPrimaryFixedVariant = Color(0xFF4527A0);

  // Secondary - Vibrant cyan
  static const Color lightSecondary = Color(0xFF00BCD4);
  static const Color lightSecondaryContainer = Color(0xFFE0F7FA);
  static const Color lightOnSecondary = Color(0xFF006064);
  static const Color lightOnSecondaryContainer = Color(0xFF006064);
  static const Color lightSecondaryFixed = Color(0xFFE0F7FA);
  static const Color lightSecondaryFixedDim = Color(0xFFB2EBF2);
  static const Color lightOnSecondaryFixed = Color(0xFF006064);
  static const Color lightOnSecondaryFixedVariant = Color(0xFF00838F);

  // Tertiary - Vibrant pink
  static const Color lightTertiary = Color(0xFFEC407A);
  static const Color lightTertiaryContainer = Color(0xFFFCE4EC);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightOnTertiaryContainer = Color(0xFF781C3A);
  static const Color lightTertiaryFixed = Color(0xFFFCE4EC);
  static const Color lightTertiaryFixedDim = Color(0xFFF8BBD0);
  static const Color lightOnTertiaryFixed = Color(0xFF781C3A);
  static const Color lightOnTertiaryFixedVariant = Color(0xFFC2185B);

  // Error
  static const Color lightError = Color(0xFFE53935);
  static const Color lightErrorContainer = Color(0xFFFFEBEE);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightOnErrorContainer = Color(0xFF781C3A);

  // Surface
  static const Color lightSurface = Color(0xFFF8FAFD);
  static const Color lightOnSurface = Color(0xFF1A1C1E);
  static const Color lightSurfaceVariant = Color(0xFFE8ECF1);
  static const Color lightOnSurfaceVariant = Color(0xFF4A4D53);
  static const Color lightSurfaceContainer = Color(0xFFF0F2F5);
  static const Color lightSurfaceContainerHigh = Color(0xFFE8ECF1);
  static const Color lightSurfaceContainerHighest = Color(0xFFE0E4E9);
  static const Color lightSurfaceContainerLow = Color(0xFFF5F7FA);
  static const Color lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color lightSurfaceTint = Color(0xFF7C4DFF);

  // Outline
  static const Color lightOutline = Color(0xFFB0B4BB);
  static const Color lightOutlineVariant = Color(0xFFD0D4DA);

  // Shadow
  static const Color lightShadow = Color(0xFF1A1C1E);
  static const Color lightScrim = Color(0xFF1A1C1E);

  // Inverse
  static const Color lightInverseSurface = Color(0xFF2D2F31);
  static const Color lightInverseOnSurface = Color(0xFFF0F2F5);
  static const Color lightInversePrimary = Color(0xFFD1C4E9);

  // Background
  static const Color lightBackground = Color(0xFFF8FAFD);
  static const Color lightOnBackground = Color(0xFF1A1C1E);

  // ============================================
  // SEMANTIC COLORS (Dark Theme)
  // ============================================
  
  // Primary
  static const Color darkPrimary = Color(0xFFB39DDB);
  static const Color darkPrimaryContainer = Color(0xFF4527A0);
  static const Color darkOnPrimary = Color(0xFF1F0058);
  static const Color darkOnPrimaryContainer = Color(0xFFEDE7F6);
  static const Color darkPrimaryFixed = Color(0xFFEDE7F6);
  static const Color darkPrimaryFixedDim = Color(0xFFD1C4E9);
  static const Color darkOnPrimaryFixed = Color(0xFF1F0058);
  static const Color darkOnPrimaryFixedVariant = Color(0xFF4527A0);

  // Secondary
  static const Color darkSecondary = Color(0xFF4DD0E1);
  static const Color darkSecondaryContainer = Color(0xFF006064);
  static const Color darkOnSecondary = Color(0xFF00363A);
  static const Color darkOnSecondaryContainer = Color(0xFFE0F7FA);
  static const Color darkSecondaryFixed = Color(0xFFE0F7FA);
  static const Color darkSecondaryFixedDim = Color(0xFFB2EBF2);
  static const Color darkOnSecondaryFixed = Color(0xFF006064);
  static const Color darkOnSecondaryFixedVariant = Color(0xFF00838F);

  // Tertiary
  static const Color darkTertiary = Color(0xFFF06292);
  static const Color darkTertiaryContainer = Color(0xFF781C3A);
  static const Color darkOnTertiary = Color(0xFF781C3A);
  static const Color darkOnTertiaryContainer = Color(0xFFFCE4EC);
  static const Color darkTertiaryFixed = Color(0xFFFCE4EC);
  static const Color darkTertiaryFixedDim = Color(0xFFF8BBD0);
  static const Color darkOnTertiaryFixed = Color(0xFF781C3A);
  static const Color darkOnTertiaryFixedVariant = Color(0xFFC2185B);

  // Error
  static const Color darkError = Color(0xFFEF5350);
  static const Color darkErrorContainer = Color(0xFF781C3A);
  static const Color darkOnError = Color(0xFF781C3A);
  static const Color darkOnErrorContainer = Color(0xFFFFEBEE);

  // Surface
  static const Color darkSurface = Color(0xFF16181A);
  static const Color darkOnSurface = Color(0xFFE8ECEF);
  static const Color darkSurfaceVariant = Color(0xFF3A3D42);
  static const Color darkOnSurfaceVariant = Color(0xFFB8BBC0);
  static const Color darkSurfaceContainer = Color(0xFF1E2022);
  static const Color darkSurfaceContainerHigh = Color(0xFF2A2D30);
  static const Color darkSurfaceContainerHighest = Color(0xFF35383C);
  static const Color darkSurfaceContainerLow = Color(0xFF1A1C1E);
  static const Color darkSurfaceContainerLowest = Color(0xFF101214);
  static const Color darkSurfaceTint = Color(0xFFB39DDB);

  // Outline
  static const Color darkOutline = Color(0xFF787C82);
  static const Color darkOutlineVariant = Color(0xFF4A4D53);

  // Shadow
  static const Color darkShadow = Color(0xFF000000);
  static const Color darkScrim = Color(0xFF000000);

  // Inverse
  static const Color darkInverseSurface = Color(0xFFE8ECEF);
  static const Color darkInverseOnSurface = Color(0xFF2D2F31);
  static const Color darkInversePrimary = Color(0xFF4527A0);

  // Background
  static const Color darkBackground = Color(0xFF16181A);
  static const Color darkOnBackground = Color(0xFFE8ECEF);

  // ============================================
  // GAME-SPECIFIC COLORS
  // ============================================
  
  // Tetromino colors (vibrant, high contrast)
  static const List<Color> tetrominoColors = [
    Color(0xFF00E5FF), // I - Cyan
    Color(0xFF2979FF), // J - Blue
    Color(0xFFFF6D00), // L - Orange
    Color(0xFFFFD600), // O - Yellow
    Color(0xFF76FF03), // S - Green
    Color(0xFFD500F9), // T - Purple
    Color(0xFFFF1744), // Z - Red
  ];

  static const List<Color> tetrominoColorsDark = [
    Color(0xFF18FFFF), // I - Cyan (brighter for dark)
    Color(0xFF82B1FF), // J - Blue (brighter for dark)
    Color(0xFFFFB74D), // L - Orange (brighter for dark)
    Color(0xFFFFEB3B), // O - Yellow (brighter for dark)
    Color(0xFFB2FF59), // S - Green (brighter for dark)
    Color(0xFFEA80FC), // T - Purple (brighter for dark)
    Color(0xFFFF5252), // Z - Red (brighter for dark)
  ];

  // Neon accent colors for effects
  static const Color neonCyan = Color(0xFF00FFFF);
  static const Color neonMagenta = Color(0xFFFF00FF);
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color neonOrange = Color(0xFFFF6EC7);
  static const Color neonBlue = Color(0xFF1F51FF);

  // Neumorphic base colors
  static const Color lightNeumorphicBase = Color(0xFFF0F2F5);
  static const Color lightNeumorphicLight = Color(0xFFFFFFFF);
  static const Color lightNeumorphicDark = Color(0xFFAEB5BE);
  static const Color darkNeumorphicBase = Color(0xFF1E2022);
  static const Color darkNeumorphicLight = Color(0xFF2A2D30);
  static const Color darkNeumorphicDark = Color(0xFF16181A);

  // Gradient stops
  static const List<Color> primaryGradient = [
    Color(0xFF7C4DFF),
    Color(0xFFB388FF),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF00BCD4),
    Color(0xFF00E5FF),
  ];

  static const List<Color> tertiaryGradient = [
    Color(0xFFEC407A),
    Color(0xFFFF80AB),
  ];

  static const List<Color> surfaceGradientLight = [
    Color(0xFFF8FAFD),
    Color(0xFFE8ECF1),
  ];

  static const List<Color> surfaceGradientDark = [
    Color(0xFF1E2022),
    Color(0xFF16181A),
  ];

  // Game over overlay
  static const Color gameOverOverlayLight = Color(0xCC1A1C1E);
  static const Color gameOverOverlayDark = Color(0xCC000000);
  static const Color pauseOverlayLight = Color(0x991A1C1E);
  static const Color pauseOverlayDark = Color(0x99000000);
}