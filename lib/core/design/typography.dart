// lib/core/design/typography.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Scalable typography system with game-focused font choices
class AppTextStyles {
  AppTextStyles._();

  // ============================================
  // FONT FAMILIES
  // ============================================
  
  // Game font - Press Start 2P or similar pixel font for scores/UI
  static const String gameFont = 'GameFont';
  // UI font - Clean modern font for general UI
  static const String uiFont = 'Inter';
  // Mono font - For numbers, timers
  static const String monoFont = 'JetBrainsMono';

  // ============================================
  // FONT WEIGHTS
  // ============================================
  
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // ============================================
  // DISPLAY STYLES (Large headlines)
  // ============================================
  
  static TextStyle displayLarge = TextStyle(
    fontFamily: uiFont,
    fontSize: 57.sp,
    fontWeight: bold,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static TextStyle displayMedium = TextStyle(
    fontFamily: uiFont,
    fontSize: 45.sp,
    fontWeight: bold,
    letterSpacing: 0,
    height: 1.16,
  );

  static TextStyle displaySmall = TextStyle(
    fontFamily: uiFont,
    fontSize: 36.sp,
    fontWeight: bold,
    letterSpacing: 0,
    height: 1.22,
  );

  // ============================================
  // HEADLINE STYLES
  // ============================================
  
  static TextStyle headlineLarge = TextStyle(
    fontFamily: uiFont,
    fontSize: 32.sp,
    fontWeight: bold,
    letterSpacing: 0,
    height: 1.25,
  );

  static TextStyle headlineMedium = TextStyle(
    fontFamily: uiFont,
    fontSize: 28.sp,
    fontWeight: bold,
    letterSpacing: 0,
    height: 1.29,
  );

  static TextStyle headlineSmall = TextStyle(
    fontFamily: uiFont,
    fontSize: 24.sp,
    fontWeight: semiBold,
    letterSpacing: 0,
    height: 1.33,
  );

  // ============================================
  // TITLE STYLES
  // ============================================
  
  static TextStyle titleLarge = TextStyle(
    fontFamily: uiFont,
    fontSize: 22.sp,
    fontWeight: semiBold,
    letterSpacing: 0,
    height: 1.27,
  );

  static TextStyle titleMedium = TextStyle(
    fontFamily: uiFont,
    fontSize: 16.sp,
    fontWeight: medium,
    letterSpacing: 0.15,
    height: 1.50,
  );

  static TextStyle titleSmall = TextStyle(
    fontFamily: uiFont,
    fontSize: 14.sp,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: 1.43,
  );

  // ============================================
  // BODY STYLES
  // ============================================
  
  static TextStyle bodyLarge = TextStyle(
    fontFamily: uiFont,
    fontSize: 16.sp,
    fontWeight: regular,
    letterSpacing: 0.5,
    height: 1.50,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: uiFont,
    fontSize: 14.sp,
    fontWeight: regular,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static TextStyle bodySmall = TextStyle(
    fontFamily: uiFont,
    fontSize: 12.sp,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // ============================================
  // LABEL STYLES
  // ============================================
  
  static TextStyle labelLarge = TextStyle(
    fontFamily: uiFont,
    fontSize: 14.sp,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static TextStyle labelMedium = TextStyle(
    fontFamily: uiFont,
    fontSize: 12.sp,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static TextStyle labelSmall = TextStyle(
    fontFamily: uiFont,
    fontSize: 11.sp,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.45,
  );

  // ============================================
  // GAME-SPECIFIC STYLES
  // ============================================
  
  // Score display - large, bold, monospace
  static TextStyle scoreDisplay = TextStyle(
    fontFamily: monoFont,
    fontSize: 32.sp,
    fontWeight: bold,
    letterSpacing: 2,
    height: 1.0,
  );

  static TextStyle scoreDisplaySmall = TextStyle(
    fontFamily: monoFont,
    fontSize: 24.sp,
    fontWeight: bold,
    letterSpacing: 1.5,
    height: 1.0,
  );

  // Level display
  static TextStyle levelDisplay = TextStyle(
    fontFamily: gameFont,
    fontSize: 18.sp,
    fontWeight: bold,
    letterSpacing: 1,
    height: 1.0,
  );

  // Timer display
  static TextStyle timerDisplay = TextStyle(
    fontFamily: monoFont,
    fontSize: 20.sp,
    fontWeight: medium,
    letterSpacing: 1,
    height: 1.0,
  );

  // Button text
  static TextStyle buttonLarge = TextStyle(
    fontFamily: uiFont,
    fontSize: 16.sp,
    fontWeight: semiBold,
    letterSpacing: 0.5,
    height: 1.0,
  );

  static TextStyle buttonMedium = TextStyle(
    fontFamily: uiFont,
    fontSize: 14.sp,
    fontWeight: semiBold,
    letterSpacing: 0.25,
    height: 1.0,
  );

  static TextStyle buttonSmall = TextStyle(
    fontFamily: uiFont,
    fontSize: 12.sp,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.0,
  );

  // Caption / hint text
  static TextStyle caption = TextStyle(
    fontFamily: uiFont,
    fontSize: 10.sp,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: 1.5,
  );

  static TextStyle overline = TextStyle(
    fontFamily: uiFont,
    fontSize: 10.sp,
    fontWeight: medium,
    letterSpacing: 1.5,
    height: 1.5,
    textBaseline: TextBaseline.alphabetic,
  );

  // ============================================
  // HELPER METHODS
  // ============================================
  
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size.sp);
  }

  static TextStyle withLetterSpacing(TextStyle style, double spacing) {
    return style.copyWith(letterSpacing: spacing);
  }
}