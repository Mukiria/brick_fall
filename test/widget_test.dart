// This is a basic Flutter widget test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brick_fall/app.dart';

void main() {
  testWidgets('App builds correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BrickFallApp(),
      ),
    );

    // Wait for the splash screen to show
    await tester.pumpAndSettle();

    // Verify the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}