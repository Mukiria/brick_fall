// lib/engine/constants.dart
/// Game constants - pure Dart, no Flutter dependencies

import 'types.dart';

class GameConstants {
  const GameConstants._();

  // Board dimensions
  static const int boardWidth = 10;
  static const int boardHeight = 20;
  static const int boardVisibleHeight = 20;
  static const int spawnRow = -1;
  static const int spawnCol = 3;

  // Gameplay
  static const int linesPerLevel = 10;
  static const int maxLevel = 15;
  static const int baseTickRateMs = 1000;
  static const int minTickRateMs = 50;
  static const int levelSpeedupMs = 50;

  // Scoring
  static const int singleLineScore = 100;
  static const int doubleLineScore = 300;
  static const int tripleLineScore = 500;
  static const int tetrisLineScore = 800;
  static const int softDropScore = 1;
  static const int hardDropScore = 2;

  // Combo
  static const int comboBonusBase = 50;
  static const int comboBonusIncrement = 25;

  // Difficulty modifiers
  static const Map<Difficulty, int> difficultyTickOffset = {
    Difficulty.easy: 200,
    Difficulty.normal: 0,
    Difficulty.hard: -150,
    Difficulty.expert: -300,
  };

  // Wall kick data (SRS - Super Rotation System)
  static const Map<PieceType, List<Offset>> wallKicks = {
    PieceType.I: [
      Offset(0, 0),
      Offset(-2, 0),
      Offset(1, 0),
      Offset(-2, -1),
      Offset(1, 2),
    ],
    PieceType.J: [
      Offset(0, 0),
      Offset(-1, 0),
      Offset(1, 0),
      Offset(-2, 0),
      Offset(2, 0),
      Offset(-1, -1),
      Offset(1, -1),
      Offset(-2, -1),
      Offset(2, -1),
    ],
    PieceType.L: [
      Offset(0, 0),
      Offset(-1, 0),
      Offset(1, 0),
      Offset(-2, 0),
      Offset(2, 0),
      Offset(-1, -1),
      Offset(1, -1),
      Offset(-2, -1),
      Offset(2, -1),
    ],
    PieceType.O: [
      Offset(0, 0),
    ],
    PieceType.S: [
      Offset(0, 0),
      Offset(-1, 0),
      Offset(1, 0),
      Offset(-2, 0),
      Offset(2, 0),
      Offset(-1, -1),
      Offset(1, -1),
      Offset(-2, -1),
      Offset(2, -1),
    ],
    PieceType.T: [
      Offset(0, 0),
      Offset(-1, 0),
      Offset(1, 0),
      Offset(-2, 0),
      Offset(2, 0),
      Offset(-1, -1),
      Offset(1, -1),
      Offset(-2, -1),
      Offset(2, -1),
    ],
    PieceType.Z: [
      Offset(0, 0),
      Offset(-1, 0),
      Offset(1, 0),
      Offset(-2, 0),
      Offset(2, 0),
      Offset(-1, -1),
      Offset(1, -1),
      Offset(-2, -1),
      Offset(2, -1),
    ],
  };

  // Piece spawn positions (relative to pivot)
  static const Map<PieceType, List<Offset>> pieceDefinitions = {
    PieceType.I: [
      Offset(-1, 0),
      Offset(0, 0),
      Offset(1, 0),
      Offset(2, 0),
    ],
    PieceType.J: [
      Offset(-1, -1),
      Offset(-1, 0),
      Offset(0, 0),
      Offset(1, 0),
    ],
    PieceType.L: [
      Offset(1, -1),
      Offset(-1, 0),
      Offset(0, 0),
      Offset(1, 0),
    ],
    PieceType.O: [
      Offset(0, -1),
      Offset(1, -1),
      Offset(0, 0),
      Offset(1, 0),
    ],
    PieceType.S: [
      Offset(0, -1),
      Offset(1, -1),
      Offset(-1, 0),
      Offset(0, 0),
    ],
    PieceType.T: [
      Offset(-1, -1),
      Offset(0, -1),
      Offset(1, -1),
      Offset(0, 0),
    ],
    PieceType.Z: [
      Offset(-1, -1),
      Offset(0, -1),
      Offset(0, 0),
      Offset(1, 0),
    ],
  };

  // Piece colors (ARGB)
  static const Map<PieceType, int> pieceColors = {
    PieceType.I: 0xFF00E5FF,
    PieceType.J: 0xFF2979FF,
    PieceType.L: 0xFFFF6D00,
    PieceType.O: 0xFFFFD600,
    PieceType.S: 0xFF76FF03,
    PieceType.T: 0xFFD500F9,
    PieceType.Z: 0xFFFF1744,
  };
}