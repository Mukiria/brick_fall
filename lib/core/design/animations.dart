// lib/core/design/animations.dart
import 'package:flutter/material.dart';

/// Animation durations and curves for consistent motion design
class AppAnimations {
  AppAnimations._();

  // ============================================
  // DURATIONS
  // ============================================
  
  // Micro interactions (50-100ms)
  static const Duration instant = Duration(milliseconds: 0);
  static const Duration micro = Duration(milliseconds: 50);
  static const Duration microFast = Duration(milliseconds: 75);
  static const Duration microSlow = Duration(milliseconds: 100);

  // Standard transitions (150-300ms)
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration mediumSlow = Duration(milliseconds: 300);

  // Complex transitions (400-600ms)
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration slowMedium = Duration(milliseconds: 500);
  static const Duration slowLong = Duration(milliseconds: 600);

  // Page/screen transitions
  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Duration pageTransitionSlow = Duration(milliseconds: 400);

  // Modal/dialog
  static const Duration modalEnter = Duration(milliseconds: 200);
  static const Duration modalExit = Duration(milliseconds: 150);
  static const Duration modalEnterSlow = Duration(milliseconds: 300);
  static const Duration modalExitSlow = Duration(milliseconds: 200);

  // Game-specific
  static const Duration pieceMove = Duration(milliseconds: 100);
  static const Duration pieceRotate = Duration(milliseconds: 80);
  static const Duration pieceLock = Duration(milliseconds: 50);
  static const Duration lineClear = Duration(milliseconds: 400);
  static const Duration lineClearFlash = Duration(milliseconds: 100);
  static const Duration levelUp = Duration(milliseconds: 800);
  static const Duration gameOver = Duration(milliseconds: 600);
  static const Duration scoreCount = Duration(milliseconds: 500);

  // Loading/spinner
  static const Duration spinner = Duration(milliseconds: 1000);
  static const Duration pulse = Duration(milliseconds: 1500);
  static const Duration shimmer = Duration(milliseconds: 1500);

  // ============================================
  // CURVES
  // ============================================
  
  // Standard easing
  static const Curve linear = Curves.linear;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;

  // Material curves
  static const Curve standard = Curves.easeInOut;
  static const Curve decelerate = Curves.decelerate;
  static const Curve accelerate = Curves.easeIn;
  static const Curve sharp = Curves.easeIn;

  // Expressive curves
  static const Curve emphasized = Curves.easeInOutCubic;
  static const Curve emphasizedDecelerate = Curves.easeOutCubic;
  static const Curve emphasizedAccelerate = Curves.easeInCubic;

  // Spring-like curves
  static const Curve spring = Curves.elasticOut;
  static const Curve springIn = Curves.elasticIn;
  static const Curve springInOut = Curves.elasticInOut;
  static const Curve bounce = Curves.bounceOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceInOut = Curves.bounceInOut;

  // Custom curves for game feel
  static const Curve gameMove = Cubic(0.25, 0.46, 0.45, 0.94); // Smooth, responsive
  static const Curve gameRotate = Cubic(0.34, 1.56, 0.64, 1); // Slight overshoot
  static const Curve gameLock = Cubic(0.55, 0.055, 0.675, 0.19); // Quick snap
  static const Curve gameLineClear = Cubic(0.68, -0.55, 0.265, 1.55); // Bouncy
  static const Curve gameLevelUp = Cubic(0.175, 0.885, 0.32, 1.275); // Celebration
  static const Curve gameGameOver = Cubic(0.6, -0.28, 0.735, 0.045); // Dramatic

  // ============================================
  // CURVE HELPERS
  // ============================================
  
  static Curve getForDuration(Duration duration) {
    if (duration <= micro) return easeOut;
    if (duration <= fast) return standard;
    if (duration <= medium) return emphasized;
    if (duration <= slow) return emphasizedDecelerate;
    return spring;
  }

  // ============================================
  // STAGGER DELAYS
  // ============================================
  
  static const int staggerDelayShort = 50; // ms
  static const int staggerDelayMedium = 80; // ms
  static const int staggerDelayLong = 120; // ms

  static Duration stagger(int index, {int baseDelay = staggerDelayMedium}) {
    return Duration(milliseconds: index * baseDelay);
  }

  // ============================================
  // TRANSITION PRESETS
  // ============================================
  
  // Fade transitions
  static const Duration fadeInDuration = fast;
  static const Duration fadeOutDuration = fast;
  static const Curve fadeCurve = easeOut;

  // Scale transitions
  static const Duration scaleDuration = normal;
  static const Curve scaleCurve = spring;

  // Slide transitions
  static const Duration slideDuration = medium;
  static const Curve slideCurve = emphasizedDecelerate;

  // Size transitions
  static const Duration sizeDuration = medium;
  static const Curve sizeCurve = standard;

  // Rotation transitions
  static const Duration rotateDuration = pieceRotate;
  static const Curve rotateCurve = gameRotate;

  // ============================================
  // PAGE TRANSITION CONFIGS
  // ============================================
  
  static const PageTransitionConfig pageFade = PageTransitionConfig(
    duration: pageTransition,
    curve: standard,
    reverseDuration: pageTransition,
    reverseCurve: standard,
  );

  static const PageTransitionConfig pageSlide = PageTransitionConfig(
    duration: pageTransition,
    curve: emphasizedDecelerate,
    reverseDuration: pageTransition,
    reverseCurve: emphasizedAccelerate,
  );

  static const PageTransitionConfig pageScale = PageTransitionConfig(
    duration: pageTransitionSlow,
    curve: spring,
    reverseDuration: pageTransition,
    reverseCurve: standard,
  );

  static const PageTransitionConfig modalFade = PageTransitionConfig(
    duration: modalEnter,
    curve: easeOut,
    reverseDuration: modalExit,
    reverseCurve: easeIn,
  );

  static const PageTransitionConfig modalScale = PageTransitionConfig(
    duration: modalEnterSlow,
    curve: spring,
    reverseDuration: modalExitSlow,
    reverseCurve: standard,
  );
}

class PageTransitionConfig {
  final Duration duration;
  final Curve curve;
  final Duration reverseDuration;
  final Curve reverseCurve;

  const PageTransitionConfig({
    required this.duration,
    required this.curve,
    required this.reverseDuration,
    required this.reverseCurve,
  });
}