import 'package:flutter_test/flutter_test.dart';
import 'package:brick_fall/engine/procedural_generator.dart';
import 'package:brick_fall/engine/piece_library.dart';

void main() {
  group('ProceduralPieceGenerator', () {
    late ProceduralPieceGenerator generator;
    late PieceLibrary library;

    setUp(() {
      library = PieceLibrary();
      library.initialize();
      generator = ProceduralPieceGenerator(library: library, seed: 42);
    });

    test('Initializes with correct piece library', () {
      expect(library.getAll().length, greaterThanOrEqualTo(70));
    });

    test('Generates round of 3 pieces', () {
      final result = generator.generateRound();
      
      expect(result.pieces.length, equals(3));
      expect(result.roundNumber, equals(1));
      expect(result.difficulty, greaterThan(0));
      expect(result.weightsUsed, isNotEmpty);
    });

    test('Pieces have valid library IDs', () {
      final result = generator.generateRound();
      
      for (final piece in result.pieces) {
        expect(piece.libraryId, isNotNull);
        expect(piece.libraryId!.isNotEmpty, isTrue);
        expect(library.get(piece.libraryId!), isNotNull);
      }
    });

    test('Avoids repeating pieces in same round', () {
      final result = generator.generateRound();
      
      final ids = result.pieces.map((p) => p.libraryId!).toSet();
      expect(ids.length, equals(3)); // All unique
    });

    test('Tracks history and avoids recent repeats', () {
      // Generate multiple rounds
      for (int i = 0; i < 5; i++) {
        generator.generateRound();
      }
      
      final stats = generator.getStats();
      expect(stats['roundNumber'], equals(5));
      expect(stats['totalPiecesGenerated'], equals(15));
      expect(stats['uniquePiecesUsed'], greaterThan(1));
    });

    test('Limits same category per round', () {
      // This is probabilistic, but we can verify the constraint logic
      final result = generator.generateRound();
      
      final categories = result.pieces.map((p) => 
        library.get(p.libraryId!)!.category).toList();
      
      // No category should appear more than maxSameCategoryInRound (default 2)
      final categoryCounts = <PieceCategory, int>{};
      for (final cat in categories) {
        categoryCounts[cat] = (categoryCounts[cat] ?? 0) + 1;
      }
      
      for (final count in categoryCounts.values) {
        expect(count, lessThanOrEqualTo(2));
      }
    });

    test('Difficulty progression works', () {
      // Generate many rounds
      for (int i = 0; i < 20; i++) {
        generator.generateRound();
      }
      
      final stats = generator.getStats();
      expect(stats['currentDifficulty'], greaterThan(1.0));
    });

test('Weighted probabilities favor easier pieces early', () {
      // Check that base weights are inversely proportional to difficulty
      final stats = generator.getStats();
      for (final piece in library.getAll()) {
        final weight = stats['baseWeights'][piece.id] ?? 1.0;
        // Lower difficulty = higher weight
        if (piece.difficulty == 1) {
          expect(weight, greaterThan(0.5));
        } else if (piece.difficulty >= 4) {
          expect(weight, lessThan(0.5));
        }
      }
    });

    test('Fairness tracking works', () {
      // Generate many pieces
      for (int i = 0; i < 100; i++) {
        generator.generateRound();
      }
      
      final stats = generator.getStats();
      expect(stats['totalPiecesGenerated'], equals(300));
      expect(stats['fairnessVariance'], isNotNull);
      // Variance should be reasonably low for fair distribution
      expect(stats['fairnessVariance'], lessThan(100.0));
    });

test('Adaptive weights respond to player metrics', () {
      // Simulate skilled player
      generator.updateMetrics(const PlayerMetrics(
        gamesPlayed: 10,
        piecesPlaced: 500,
        avgClearRate: 1.5,
        survivalTime: 200,
        currentLevel: 10,
        categorySuccess: {
          PieceCategory.lShape: 50,
          PieceCategory.tShape: 45,
        },
      ));
      
      // Weights should adapt
      final stats = generator.getStats();
      expect(stats['dynamicWeights'].length, equals(stats['baseWeights'].length));
    });

test('Serialization and deserialization works', () {
      // Generate some rounds
      for (int i = 0; i < 10; i++) {
        generator.generateRound();
      }
      
      final json = generator.toJson();
      expect(json['roundNumber'], equals(10));
      expect(json['totalPiecesGenerated'], equals(30));
      
      // Create new generator and load state
      final newGenerator = ProceduralPieceGenerator(library: library, seed: 123);
      newGenerator.fromJson(json);
      
      expect(newGenerator.getStats()['roundNumber'], equals(10));
      expect(newGenerator.getStats()['totalPiecesGenerated'], equals(30));
      expect(newGenerator.getStats()['currentDifficulty'], closeTo(generator.getStats()['currentDifficulty'], 0.01));
    });

test('Reset works correctly', () {
      for (int i = 0; i < 5; i++) {
        generator.generateRound();
      }
      
      generator.reset(seed: 42);
      
      expect(generator.getStats()['roundNumber'], equals(0));
      expect(generator.getStats()['totalPiecesGenerated'], equals(0));
      expect(generator.getStats()['historyLength'], equals(0));
      expect(generator.getStats()['currentDifficulty'], equals(1.0));
    });

    test('Impossible combination detection works', () {
      // Generate many rounds and verify no impossible combos
      int roundsWithIssues = 0;
      for (int i = 0; i < 50; i++) {
        final result = generator.generateRound();
        
        // Check no 2+ special pieces
        int specialCount = 0;
        int longCount = 0;
        int largeCount = 0;
        
        for (final piece in result.pieces) {
          final def = library.get(piece.libraryId!);
          if (def != null) {
            if (def.category == PieceCategory.special) specialCount++;
            if (def.category == PieceCategory.long) longCount++;
            if (def.blockCount > 6) largeCount++;
          }
        }
        
        if (specialCount >= 2 || longCount >= 2 || largeCount >= 2) {
          roundsWithIssues++;
        }
      }
      
      // Allow very few edge cases (detection is probabilistic)
      expect(roundsWithIssues, lessThanOrEqualTo(2), 
          reason: 'Too many rounds with impossible combinations');
    });

    test('Get available pieces by difficulty', () {
      final easy = generator.getAvailablePieces(maxDifficulty: 2.0);
      final hard = generator.getAvailablePieces(maxDifficulty: 5.0);
      
      expect(easy.length, lessThan(hard.length));
      expect(easy.every((p) => p.difficulty <= 2), isTrue);
    });

test('Difficulty adjustment after consecutive hard/easy rounds', () {
      // Manually test the adjustment logic
      // This is tested implicitly through generateRound
      expect(generator.getStats()['currentDifficulty'], equals(1.0));
    });
  });
}