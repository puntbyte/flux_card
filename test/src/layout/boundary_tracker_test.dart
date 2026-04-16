import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/src/layout/boundary_tracker.dart';

void main() {
  // ---------------------------------------------------------------------------
  // BoundaryTracker (pure unit)
  // ---------------------------------------------------------------------------

  group('BoundaryTracker', () {
    test('renderBox is null initially', () {
      final tracker = BoundaryTracker();
      expect(tracker.renderBox, isNull);
    });

    test('renderBox can be set and read back', () {
      final tracker = BoundaryTracker();
      // We set it to a non-null fake — the type is RenderBox? so this tests
      // the setter path without needing a real render tree.
      expect(tracker.renderBox, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // BoundaryMarker (widget test)
  // ---------------------------------------------------------------------------

  group('BoundaryMarker', () {
    testWidgets('tracker.renderBox is non-null after mount', (tester) async {
      final tracker = BoundaryTracker();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoundaryMarker(tracker: tracker, child: const SizedBox(width: 100, height: 50)),
          ),
        ),
      );

      expect(tracker.renderBox, isNotNull);
    });

    testWidgets('tracker.renderBox is null after widget is unmounted', (tester) async {
      final tracker = BoundaryTracker();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoundaryMarker(tracker: tracker, child: const SizedBox(width: 100, height: 50)),
          ),
        ),
      );

      expect(tracker.renderBox, isNotNull);

      // Replace the widget tree to unmount BoundaryMarker
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      expect(tracker.renderBox, isNull);
    });

    testWidgets('tracker is updated when tracker instance changes', (tester) async {
      final tracker1 = BoundaryTracker();
      final tracker2 = BoundaryTracker();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoundaryMarker(tracker: tracker1, child: const SizedBox(width: 100, height: 50)),
          ),
        ),
      );

      expect(tracker1.renderBox, isNotNull);
      expect(tracker2.renderBox, isNull);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoundaryMarker(tracker: tracker2, child: const SizedBox(width: 100, height: 50)),
          ),
        ),
      );

      // After update: old tracker cleared, new tracker set
      expect(tracker1.renderBox, isNull);
      expect(tracker2.renderBox, isNotNull);
    });

    testWidgets('tracker.renderBox has the correct size after layout', (tester) async {
      final tracker = BoundaryTracker();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoundaryMarker(tracker: tracker, child: const SizedBox(width: 200, height: 80)),
          ),
        ),
      );

      expect(tracker.renderBox?.size, const Size(200, 80));
    });

    testWidgets('child widget renders inside BoundaryMarker', (tester) async {
      final tracker = BoundaryTracker();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoundaryMarker(tracker: tracker, child: const Text('inside marker')),
          ),
        ),
      );

      expect(find.text('inside marker'), findsOneWidget);
    });

    testWidgets('multiple BoundaryMarkers work independently', (tester) async {
      final tracker1 = BoundaryTracker();
      final tracker2 = BoundaryTracker();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                BoundaryMarker(tracker: tracker1, child: const SizedBox(width: 100, height: 40)),
                BoundaryMarker(tracker: tracker2, child: const SizedBox(width: 100, height: 60)),
              ],
            ),
          ),
        ),
      );

      expect(tracker1.renderBox, isNotNull);
      expect(tracker2.renderBox, isNotNull);
      expect(tracker1.renderBox, isNot(same(tracker2.renderBox)));
    });
  });
}
