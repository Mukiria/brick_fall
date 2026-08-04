// lib/engine/piece_generator.dart
/// PieceGenerator - 7-bag randomizer for fair piece distribution

import 'dart:math';
import 'types.dart';
import 'piece.dart';

class PieceGenerator {
  final Random _random;
  final List<PieceType> _bag = [];
  PieceType? _lastType;
  final bool _avoidRepeats;

  PieceGenerator({
    int? seed,
    bool avoidRepeats = true,
  })  : _random = seed != null ? Random(seed) : Random(),
        _avoidRepeats = avoidRepeats {
    _refillBag();
  }

  void _refillBag() {
    _bag.clear();
    _bag.addAll(PieceType.all);
    _bag.shuffle(_random);

    // Avoid getting the same piece twice in a row (when enabled)
    if (_avoidRepeats && _lastType != null && _bag.length > 1) {
      if (_bag.first == _lastType) {
        // Swap with a different piece
        for (int i = 1; i < _bag.length; i++) {
          if (_bag[i] != _lastType) {
            final temp = _bag[0];
            _bag[0] = _bag[i];
            _bag[i] = temp;
            break;
          }
        }
      }
    }
  }

  /// Get next piece type from bag
  PieceType nextType() {
    if (_bag.isEmpty) {
      _refillBag();
    }
    final type = _bag.removeAt(0);
    _lastType = type;
    return type;
  }

  /// Get next piece instance
  Piece nextPiece() => Piece.spawn(nextType());

  /// Peek at next N types without consuming
  List<PieceType> peek(int count) {
    final result = <PieceType>[];
    final tempBag = List<PieceType>.from(_bag);
    PieceType? tempLast = _lastType;
    
    for (int i = 0; i < count; i++) {
      if (tempBag.isEmpty) {
        tempBag.addAll(PieceType.all);
        tempBag.shuffle(_random);
        
        if (_avoidRepeats && tempLast != null && tempBag.length > 1) {
          if (tempBag.first == tempLast) {
            for (int j = 1; j < tempBag.length; j++) {
              if (tempBag[j] != tempLast) {
                final temp = tempBag[0];
                tempBag[0] = tempBag[j];
                tempBag[j] = temp;
                break;
              }
            }
          }
        }
      }
      final type = tempBag.removeAt(0);
      result.add(type);
      tempLast = type;
    }
    return result;
  }

  /// Peek next pieces as Piece instances
  List<Piece> peekPieces(int count) {
    return peek(count).map(Piece.spawn).toList();
  }

  /// Reset generator
  void reset({int? seed}) {
    _bag.clear();
    _lastType = null;
    if (seed != null) {
      // Can't change seed of existing Random, but we can note it
    }
    _refillBag();
  }

  /// Get remaining pieces in current bag
  int get remainingInBag => _bag.length;

  /// Get copy of current bag (for debugging/replay)
  List<PieceType> get currentBag => List.unmodifiable(_bag);

  /// Serialize state for replay
  Map<String, dynamic> toJson() => {
        'bag': _bag.map((e) => e.name).toList(),
        'lastType': _lastType?.name,
        'avoidRepeats': _avoidRepeats,
      };

  /// Deserialize state
  factory PieceGenerator.fromJson(Map<String, dynamic> json) {
    final gen = PieceGenerator(avoidRepeats: json['avoidRepeats'] as bool? ?? true);
    gen._bag.clear();
    gen._bag.addAll(
      (json['bag'] as List).map((e) => PieceType.values.firstWhere((t) => t.name == e)),
    );
    gen._lastType = json['lastType'] != null
        ? PieceType.values.firstWhere((t) => t.name == json['lastType'])
        : null;
    return gen;
  }
}