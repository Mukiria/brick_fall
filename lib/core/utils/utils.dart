// Utility functions and helpers

import 'package:flutter/material.dart';

class AppUtils {
  static String formatScore(int score) {
    if (score >= 1000000) {
      return '${(score / 1000000).toStringAsFixed(1)}M';
    } else if (score >= 1000) {
      return '${(score / 1000).toStringAsFixed(1)}K';
    }
    return score.toString();
  }

  static String formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static Color getBrickColor(int typeIndex) {
    const colors = [
      Color(0xFF00FFFF), // I - Cyan
      Color(0xFF0000FF), // J - Blue
      Color(0xFFFFA500), // L - Orange
      Color(0xFFFFFFFF), // O - Yellow
      Color(0xFF00FF00), // S - Green
      Color(0xFF800080), // T - Purple
      Color(0xFFFF0000), // Z - Red
    ];
    return colors[typeIndex.clamp(0, colors.length - 1)];
  }

  static double clampDouble(double value, double min, double max) {
    return value.clamp(min, max);
  }
}

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  MediaQueryData get media => MediaQuery.of(this);
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}