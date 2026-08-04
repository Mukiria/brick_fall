// lib/engine/procedural_generator.dart
/// Procedural Piece Generator - Balanced, Fair, Adaptive
///
/// Generates pieces with:
/// - Balanced randomness with weighted probabilities
/// - Anti-repeat history tracking
/// - Difficulty progression
/// - Adaptive generation based on player performance
/// - Fairness guarantees for long-term gameplay
/// - 3-piece round generation

import 'dart:math' as math;
import 'piece_library.dart';
import 'piece.dart';
import 'types.dart';

/// Configuration for the generator
class GeneratorConfig {
  final int historySize;
  final int roundSize;
  final double repeatPenalty;
  final double difficultyRampRate;
  final double adaptivityFactor;
  final int maxSameCategoryInRound;
  final bool enableImpossibleDetection;
  final Map<String, double> customWeights;

  const GeneratorConfig({
    this.historySize = 20,
    this.roundSize = 3,
    this.repeatPenalty = 0.15,
    this.difficultyRampRate = 0.05,
    this.adaptivityFactor = 0.3,
    this.maxSameCategoryInRound = 2,
    this.enableImpossibleDetection = true,
    this.customWeights = const {},
  });
}

/// Player performance metrics for adaptive generation
class PlayerMetrics {
  final int linesCleared;
  final int piecesPlaced;
  final int gamesPlayed;
  final double avgClearRate; // lines per piece
  final double survivalTime; // average game duration
  final Map<PieceCategory, int> categorySuccess;
  final int currentLevel;
  final int highScore;

  const PlayerMetrics({
    this.linesCleared = 0,
    this.piecesPlaced = 0,
    this.gamesPlayed = 0,
    this.avgClearRate = 0.0,
    this.survivalTime = 0.0,
    this.categorySuccess = const {},
    this.currentLevel = 1,
    this.highScore = 0,
  });

  /// Calculate skill rating (0.0 to 1.0)
  double get skillRating {
    if (gamesPlayed == 0) return 0.0;
    final clearScore = (avgClearRate / 2.0).clamp(0.0, 1.0);
    final survivalScore = (survivalTime / 300.0).clamp(0.0, 1.0);
    final levelScore = (currentLevel / 15.0).clamp(0.0, 1.0);
    return (clearScore * 0.4 + survivalScore * 0.3 + levelScore * 0.3);
  }

  /// Get category proficiency (0.0 to 1.0)
  double getCategoryProficiency(PieceCategory cat) {
    if (piecesPlaced == 0) return 0.5;
    final success = categorySuccess[cat] ?? 0;
    return (success / (piecesPlaced / 13.0)).clamp(0.0, 1.0);
  }

  PlayerMetrics copyWith({
    int? linesCleared,
    int? piecesPlaced,
    int? gamesPlayed,
    double? avgClearRate,
    double? survivalTime,
    Map<PieceCategory, int>? categorySuccess,
    int? currentLevel,
    int? highScore,
  }) {
    return PlayerMetrics(
      linesCleared: linesCleared ?? this.linesCleared,
      piecesPlaced: piecesPlaced ?? this.piecesPlaced,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      avgClearRate: avgClearRate ?? this.avgClearRate,
      survivalTime: survivalTime ?? this.survivalTime,
      categorySuccess: categorySuccess ?? this.categorySuccess,
      currentLevel: currentLevel ?? this.currentLevel,
      highScore: highScore ?? this.highScore,
    );
  }
}

/// Generation result with metadata
class GenerationResult {
  final List<Piece> pieces;
  final int roundNumber;
  final double difficulty;
  final Map<String, double> weightsUsed;
  final List<String> historySnapshot;

  const GenerationResult({
    required this.pieces,
    required this.roundNumber,
    required this.difficulty,
    required this.weightsUsed,
    required this.historySnapshot,
  });
}

/// Procedural Piece Generator
class ProceduralPieceGenerator {
  final PieceLibrary _library;
  final GeneratorConfig _config;
  final math.Random _random;
  
  // State
  final List<String> _history = [];
  final List<String> _roundHistory = [];
  final Map<String, int> _pieceCounts = {};
  final Map<PieceCategory, int> _categoryCounts = {};
  final Map<String, double> _baseWeights = {};
  final Map<String, double> _dynamicWeights = {};
  
  // Adaptive state
  PlayerMetrics _metrics = const PlayerMetrics();
  double _currentDifficulty = 1.0;
  int _roundNumber = 0;
  int _consecutiveEasyRounds = 0;
  int _consecutiveHardRounds = 0;
  
  // Fairness tracking
  final Map<String, int> _fairnessCounter = {};
  int _totalPiecesGenerated = 0;

  ProceduralPieceGenerator({
    PieceLibrary? library,
    GeneratorConfig? config,
    int? seed,
  })  : _library = library ?? PieceLibrary(),
        _config = config ?? const GeneratorConfig(),
        _random = seed != null ? math.Random(seed) : math.Random() {
    _initialize();
  }

  void _initialize() {
    _library.initialize();
    _buildBaseWeights();
    _dynamicWeights.addAll(_baseWeights);
  }

  void _buildBaseWeights() {
    for (final piece in _library.getAll()) {
      // Base weight inversely proportional to difficulty
      double weight = 1.0 / piece.difficulty;
      
      // Apply custom weights if provided
      if (_config.customWeights.containsKey(piece.id)) {
        weight *= _config.customWeights[piece.id]!;
      }
      
      // Category bonuses
      switch (piece.category) {
        case PieceCategory.single:
        case PieceCategory.double:
          weight *= 1.2; // More basic pieces
          break;
        case PieceCategory.special:
          weight *= 0.5; // Rare special pieces
          break;
        default:
          break;
      }
      
      _baseWeights[piece.id] = weight;
      _dynamicWeights[piece.id] = weight;
    }
    _normalizeWeights(_dynamicWeights);
  }

  void _normalizeWeights(Map<String, double> weights) {
    final sum = weights.values.fold(0.0, (a, b) => a + b);
    if (sum > 0) {
      weights.updateAll((key, value) => value / sum);
    }
  }

  /// Update player metrics for adaptive generation
  void updateMetrics(PlayerMetrics metrics) {
    _metrics = metrics;
    _adaptWeights();
  }

  void _adaptWeights() {
    if (_metrics.gamesPlayed < 3) return; // Need some data first
    
    final skill = _metrics.skillRating;
    
    // Adjust difficulty based on skill
    _currentDifficulty = (1.0 + skill * 2.0).clamp(0.5, 3.0);
    
    // Adapt weights based on category proficiency
    for (final piece in _library.getAll()) {
      final proficiency = _metrics.getCategoryProficiency(piece.category);
      final baseWeight = _baseWeights[piece.id] ?? 1.0;
      
      // If player struggles with a category, increase its weight slightly
      // If player excels, decrease slightly to encourage variety
      double adaptation = 1.0;
      if (proficiency < 0.3) {
        adaptation = 1.0 + _config.adaptivityFactor * (0.3 - proficiency);
      } else if (proficiency > 0.7) {
        adaptation = 1.0 - _config.adaptivityFactor * (proficiency - 0.7);
      }
      
      _dynamicWeights[piece.id] = baseWeight * adaptation;
    }
    
    _normalizeWeights(_dynamicWeights);
  }

  /// Generate a round of 3 pieces
  GenerationResult generateRound() {
    _roundNumber++;
    final roundPieces = <Piece>[];
    final usedInRound = <String>{};
    final usedCategories = <PieceCategory, int>{};
    
    // Temporarily adjust weights for this round
    final roundWeights = Map<String, double>.from(_dynamicWeights);
    _applyRoundConstraints(roundWeights, usedInRound, usedCategories);
    
    for (int i = 0; i < _config.roundSize; i++) {
      final piece = _selectPiece(roundWeights, usedInRound, usedCategories);
      if (piece == null) break;
      
      roundPieces.add(piece);
      usedInRound.add(piece.libraryId!);
      if (piece.category != null) {
        _updateCategoryCount(piece.category!, usedCategories);
      }
      
      // Remove from available for this round
      roundWeights.remove(piece.libraryId);
    }
    
    // Update history and fairness
    _updateHistory(roundPieces);
    _updateFairness(roundPieces);
    
    // Check for difficulty adjustment
    _checkDifficultyAdjustment(roundPieces);
    
    return GenerationResult(
      pieces: roundPieces,
      roundNumber: _roundNumber,
      difficulty: _currentDifficulty,
      weightsUsed: Map.from(_dynamicWeights),
      historySnapshot: List.from(_history),
    );
  }

  void _applyRoundConstraints(
    Map<String, double> weights,
    Set<String> usedInRound,
    Map<PieceCategory, int> usedCategories,
  ) {
    // Penalize recently used pieces
    for (final id in _history) {
      if (weights.containsKey(id)) {
        final penalty = _config.repeatPenalty * (1.0 - _history.indexOf(id) / _config.historySize);
        weights[id] = (weights[id]! * (1.0 - penalty)).clamp(0.0, double.infinity);
      }
    }
    
    // Limit same category in round
    for (final entry in usedCategories.entries) {
      if (entry.value >= _config.maxSameCategoryInRound) {
        for (final piece in _library.getByCategory(entry.key)) {
          if (weights.containsKey(piece.id)) {
            weights[piece.id] = weights[piece.id]! * 0.1;
          }
        }
      }
    }
    
    // Impossible combination detection
    if (_config.enableImpossibleDetection) {
      _detectImpossibleCombinations(weights);
    }
    
    _normalizeWeights(weights);
  }

  void _detectImpossibleCombinations(Map<String, double> weights) {
    // Detect pieces that are too large for remaining space
    // This is a simplified check - in practice would need board state
    
    // Detect 3+ long pieces in a round (hard to place)
    int longCount = 0;
    for (final id in weights.keys) {
      final piece = _library.get(id);
      if (piece != null && piece.category == PieceCategory.long) {
        longCount++;
      }
    }
    if (longCount >= 2) {
      for (final id in weights.keys) {
        final piece = _library.get(id);
        if (piece != null && piece.category == PieceCategory.long) {
          weights[id] = weights[id]! * 0.3;
        }
      }
    }
    
    // Detect 2+ special pieces (very hard)
    int specialCount = 0;
    for (final id in weights.keys) {
      final piece = _library.get(id);
      if (piece != null && piece.category == PieceCategory.special) {
        specialCount++;
      }
    }
    if (specialCount >= 2) {
      for (final id in weights.keys) {
        final piece = _library.get(id);
        if (piece != null && piece.category == PieceCategory.special) {
          weights[id] = weights[id]! * 0.2;
        }
      }
    }
    
    // Detect too many large pieces (>6 blocks)
    int largeCount = 0;
    for (final id in weights.keys) {
      final piece = _library.get(id);
      if (piece != null && piece.blockCount > 6) {
        largeCount++;
      }
    }
    if (largeCount >= 2) {
      for (final id in weights.keys) {
        final piece = _library.get(id);
        if (piece != null && piece.blockCount > 6) {
          weights[id] = weights[id]! * 0.4;
        }
      }
    }
    
    _normalizeWeights(weights);
  }

  Piece? _selectPiece(
    Map<String, double> weights,
    Set<String> usedInRound,
    Map<PieceCategory, int> usedCategories,
  ) {
    if (weights.isEmpty) return null;
    
    // Weighted random selection
    final totalWeight = weights.values.fold(0.0, (a, b) => a + b);
    if (totalWeight <= 0) return null;
    
    double r = _random.nextDouble() * totalWeight;
    
    for (final entry in weights.entries) {
      r -= entry.value;
      if (r <= 0) {
        final piece = _library.get(entry.key);
        if (piece != null) {
          return piece.createPiece();
        }
      }
    }
    
    // Fallback: return first available
    for (final entry in weights.entries) {
      final piece = _library.get(entry.key);
      if (piece != null && !usedInRound.contains(entry.key)) {
        return piece.createPiece();
      }
    }
    
    return null;
  }

  void _updateHistory(List<Piece> pieces) {
    for (final piece in pieces) {
      final id = piece.libraryId!;
      _history.insert(0, id);
      _roundHistory.add(id);
      
      if (_history.length > _config.historySize) {
        _history.removeLast();
      }
      
      _pieceCounts[id] = (_pieceCounts[id] ?? 0) + 1;
    }
  }

  void _updateCategoryCount(PieceCategory cat, Map<PieceCategory, int> counts) {
    counts[cat] = (counts[cat] ?? 0) + 1;
    _categoryCounts[cat] = (_categoryCounts[cat] ?? 0) + 1;
  }

  void _updateFairness(List<Piece> pieces) {
    _totalPiecesGenerated += pieces.length;
    
    for (final piece in pieces) {
      final id = piece.libraryId!;
      _fairnessCounter[id] = (_fairnessCounter[id] ?? 0) + 1;
    }
    
    // Log fairness stats periodically
    if (_totalPiecesGenerated % 100 == 0) {
      _logFairnessStats();
    }
  }

  void _logFairnessStats() {
    if (_fairnessCounter.isEmpty) return;
    
    final expected = _totalPiecesGenerated / _fairnessCounter.length;
    double variance = 0;
    
    for (final count in _fairnessCounter.values) {
      final diff = count - expected;
      variance += diff * diff;
    }
    variance /= _fairnessCounter.length;
    
    // Could log to analytics here
    // print('Fairness variance: $variance (expected: $expected)');
  }

  void _checkDifficultyAdjustment(List<Piece> pieces) {
    int hardCount = 0;
    int easyCount = 0;
    
    for (final piece in pieces) {
      if (piece.difficulty >= 4) hardCount++;
      if (piece.difficulty <= 2) easyCount++;
    }
    
    if (hardCount >= 2) {
      _consecutiveHardRounds++;
      _consecutiveEasyRounds = 0;
    } else if (easyCount >= 2) {
      _consecutiveEasyRounds++;
      _consecutiveHardRounds = 0;
    } else {
      _consecutiveHardRounds = 0;
      _consecutiveEasyRounds = 0;
    }
    
    // Adjust difficulty ramp
    if (_consecutiveHardRounds >= 3) {
      _currentDifficulty = (_currentDifficulty * 0.9).clamp(0.5, 3.0);
      _consecutiveHardRounds = 0;
    } else if (_consecutiveEasyRounds >= 3) {
      _currentDifficulty = (_currentDifficulty * 1.1).clamp(0.5, 3.0);
      _consecutiveEasyRounds = 0;
    }
    
    // Apply difficulty ramp over time
    _currentDifficulty += _config.difficultyRampRate;
    _currentDifficulty = _currentDifficulty.clamp(0.5, 3.0);
  }

  /// Get piece by ID (for testing/preview)
  Piece? getPiece(String id) {
    final def = _library.get(id);
    return def?.createPiece();
  }

  /// Get all available pieces filtered by difficulty
  List<PieceDefinition> getAvailablePieces({double maxDifficulty = 5.0}) {
    return _library.getAll()
        .where((p) => p.difficulty <= maxDifficulty)
        .toList();
  }

  /// Get generation statistics
  Map<String, dynamic> getStats() {
    return {
      'roundNumber': _roundNumber,
      'currentDifficulty': _currentDifficulty,
      'totalPiecesGenerated': _totalPiecesGenerated,
      'uniquePiecesUsed': _pieceCounts.length,
      'pieceCounts': Map.from(_pieceCounts),
      'categoryCounts': Map.from(_categoryCounts),
      'historyLength': _history.length,
      'fairnessVariance': _calculateFairnessVariance(),
      'playerSkill': _metrics.skillRating,
      'baseWeights': Map.from(_baseWeights),
      'dynamicWeights': Map.from(_dynamicWeights),
    };
  }

  double _calculateFairnessVariance() {
    if (_fairnessCounter.isEmpty) return 0.0;
    
    final expected = _totalPiecesGenerated / _fairnessCounter.length;
    double variance = 0;
    
    for (final count in _fairnessCounter.values) {
      final diff = count - expected;
      variance += diff * diff;
    }
    return variance / _fairnessCounter.length;
  }

  /// Reset generator state
  void reset({int? seed}) {
    _history.clear();
    _roundHistory.clear();
    _pieceCounts.clear();
    _categoryCounts.clear();
    _fairnessCounter.clear();
    _dynamicWeights.clear();
    _dynamicWeights.addAll(_baseWeights);
    _metrics = const PlayerMetrics();
    _currentDifficulty = 1.0;
    _roundNumber = 0;
    _consecutiveEasyRounds = 0;
    _consecutiveHardRounds = 0;
    _totalPiecesGenerated = 0;
    
    if (seed != null) {
      // Can't reseed existing Random, would need to recreate
    }
  }

  /// Serialize state for save/load
  Map<String, dynamic> toJson() {
    return {
      'history': _history,
      'roundHistory': _roundHistory,
      'pieceCounts': _pieceCounts,
      'categoryCounts': _categoryCounts,
      'dynamicWeights': _dynamicWeights,
      'metrics': {
        'linesCleared': _metrics.linesCleared,
        'piecesPlaced': _metrics.piecesPlaced,
        'gamesPlayed': _metrics.gamesPlayed,
        'avgClearRate': _metrics.avgClearRate,
        'survivalTime': _metrics.survivalTime,
        'categorySuccess': _metrics.categorySuccess.map((k, v) => MapEntry(k.name, v)),
        'currentLevel': _metrics.currentLevel,
        'highScore': _metrics.highScore,
      },
      'currentDifficulty': _currentDifficulty,
      'roundNumber': _roundNumber,
      'consecutiveEasyRounds': _consecutiveEasyRounds,
      'consecutiveHardRounds': _consecutiveHardRounds,
      'totalPiecesGenerated': _totalPiecesGenerated,
      'fairnessCounter': _fairnessCounter,
    };
  }

  /// Load state from JSON
  void fromJson(Map<String, dynamic> json) {
    _history.clear();
    _history.addAll((json['history'] as List?)?.cast<String>() ?? []);
    
    _roundHistory.clear();
    _roundHistory.addAll((json['roundHistory'] as List?)?.cast<String>() ?? []);
    
    _pieceCounts.clear();
    _pieceCounts.addAll((json['pieceCounts'] as Map?)?.cast<String, int>() ?? {});
    
    _categoryCounts.clear();
    _categoryCounts.addAll((json['categoryCounts'] as Map?)?.cast<PieceCategory, int>() ?? {});
    
    _dynamicWeights.clear();
    _dynamicWeights.addAll((json['dynamicWeights'] as Map?)?.cast<String, double>() ?? {});
    
    final metricsMap = json['metrics'] as Map? ?? {};
    _metrics = PlayerMetrics(
      linesCleared: metricsMap['linesCleared'] as int? ?? 0,
      piecesPlaced: metricsMap['piecesPlaced'] as int? ?? 0,
      gamesPlayed: metricsMap['gamesPlayed'] as int? ?? 0,
      avgClearRate: (metricsMap['avgClearRate'] as num?)?.toDouble() ?? 0.0,
      survivalTime: (metricsMap['survivalTime'] as num?)?.toDouble() ?? 0.0,
      categorySuccess: (metricsMap['categorySuccess'] as Map?)?.map((k, v) => 
        MapEntry(PieceCategory.values.firstWhere((c) => c.name == k), v as int)) ?? {},
      currentLevel: metricsMap['currentLevel'] as int? ?? 1,
      highScore: metricsMap['highScore'] as int? ?? 0,
    );
    
    _currentDifficulty = (json['currentDifficulty'] as num?)?.toDouble() ?? 1.0;
    _roundNumber = json['roundNumber'] as int? ?? 0;
    _consecutiveEasyRounds = json['consecutiveEasyRounds'] as int? ?? 0;
    _consecutiveHardRounds = json['consecutiveHardRounds'] as int? ?? 0;
    _totalPiecesGenerated = json['totalPiecesGenerated'] as int? ?? 0;
    
    _fairnessCounter.clear();
    _fairnessCounter.addAll((json['fairnessCounter'] as Map?)?.cast<String, int>() ?? {});
    
    _adaptWeights();
  }
}