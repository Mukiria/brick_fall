import 'package:flutter_test/flutter_test.dart';
import 'package:brick_fall/engine/piece_library.dart';

void main() {
  test('PieceLibrary initializes with 70+ pieces', () {
    final lib = PieceLibrary();
    lib.initialize();
    
    final allPieces = lib.getAll();
    print('Total pieces: ${allPieces.length}');
    expect(allPieces.length, greaterThanOrEqualTo(70));
    
    for (var cat in PieceCategory.values) {
      final pieces = lib.getByCategory(cat);
      print('${cat.name}: ${pieces.length}');
      expect(pieces.length, greaterThanOrEqualTo(1));
    }
  });

  test('Each piece has required properties', () {
    final lib = PieceLibrary();
    lib.initialize();
    
    for (final piece in lib.getAll()) {
      expect(piece.id, isNotEmpty);
      expect(piece.name, isNotEmpty);
      expect(piece.blocks, isNotEmpty);
      expect(piece.color, greaterThan(0));
      expect(piece.category, isNotNull);
      expect(piece.difficulty, greaterThanOrEqualTo(1));
      expect(piece.difficulty, lessThanOrEqualTo(5));
      
      // Test bounding box
      final bbox = piece.getBoundingBox(0);
      expect(bbox.width, greaterThan(0));
      expect(bbox.height, greaterThan(0));
      
      // Test unique rotations
      final rotations = piece.getUniqueRotations();
      expect(rotations.length, greaterThanOrEqualTo(1));
      expect(rotations.length, lessThanOrEqualTo(4));
    }
  });

  test('Piece creation from library works', () {
    final lib = PieceLibrary();
    lib.initialize();
    
    final piece = lib.get('monomino')!;
    final p = piece.createPiece(x: 3, y: 0);
    
    expect(p.libraryId, equals('monomino'));
    expect(p.customBlocks, isNotNull);
    expect(p.color, equals(piece.color));
    expect(p.x, equals(3));
    expect(p.y, equals(0));
  });

  test('Piece rotation works', () {
    final lib = PieceLibrary();
    lib.initialize();
    
    final piece = lib.get('t_classic')!;
    final p0 = piece.createPiece(rotation: 0);
    final p1 = piece.createPiece(rotation: 1);
    final p2 = piece.createPiece(rotation: 2);
    final p3 = piece.createPiece(rotation: 3);
    
    expect(p0.rotation, equals(0));
    expect(p1.rotation, equals(1));
    expect(p2.rotation, equals(2));
    expect(p3.rotation, equals(3));
  });

  test('Categories have minimum pieces', () {
    final lib = PieceLibrary();
    lib.initialize();
    
    // Each category should have at least 2 pieces (except maybe single)
    for (var cat in PieceCategory.values) {
      if (cat != PieceCategory.single) {
        expect(lib.getByCategory(cat).length, greaterThanOrEqualTo(2), 
            reason: 'Category ${cat.name} should have at least 2 pieces');
      }
    }
  });

  test('Difficulty progression works', () {
    final lib = PieceLibrary();
    lib.initialize();
    
    final easyPieces = lib.getByDifficulty(1);
    final mediumPieces = lib.getByDifficulty(3);
    final allPieces = lib.getByDifficulty(5);
    
    expect(easyPieces.length, lessThanOrEqualTo(mediumPieces.length));
    expect(mediumPieces.length, lessThanOrEqualTo(allPieces.length));
  });
}