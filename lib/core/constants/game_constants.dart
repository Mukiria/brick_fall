// lib/core/constants/game_constants.dart
/// Game-specific constants that should not change with theme
import 'package:flutter/material.dart';

class GameConstants {
  GameConstants._();

  // Tetromino colors (consistent across themes for game logic)
  static const List<Color> tetrominoColors = [
    Color(0xFF00E5FF), // I - Cyan
    Color(0xFF2979FF), // J - Blue
    Color(0xFFFF6D00), // L - Orange
    Color(0xFFFFD600), // O - Yellow
    Color(0xFF76FF03), // S - Green
    Color(0xFFD500F9), // T - Purple
    Color(0xFFFF1744), // Z - Red
  ];

  // Grid
  static const int gameWidth = 10;
  static const int gameHeight = 20;
  static const int previewRows = 4;
  static const int previewCols = 4;

  // Scoring
  static const int baseLineScore = 100;
  static const int levelSpeedReduction = 50; // ms per level
  static const int minFallSpeed = 50; // ms

  // Ghost piece
  static const Color ghostColor = Color(0x44FFFFFF);

  // Overlays
  static const Color gameOverOverlay = Color(0xCC000000);
  static const Color pauseOverlay = Color(0x88000000);
  static const Color gridLineColor = Color(0xFF333333);
}