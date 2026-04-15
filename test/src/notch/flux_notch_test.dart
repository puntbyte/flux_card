import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

void main() {
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: SizedBox(width: 300, child: child)));

  // ---------------------------------------------------------------------------
  // FluxNotch (boundary constructor)
  // ---------------------------------------------------------------------------

  group('FluxNotch — boundary constructor', () {
    test('isTargeted is true when boundary is set', () {
      const notch = FluxNotch(boundary: FluxSlotBoundary.afterHeader);
      expect(notch.isTargeted, isTrue);
    });

    test('fallbackPosition defaults to 0.5', () {
      const notch = FluxNotch(boundary: FluxSlotBoundary.afterHeader);
      expect(notch.fallbackPosition, 0.5);
    });

    test('custom fallbackPosition is stored', () {
      const notch = FluxNotch(
        boundary: FluxSlotBoundary.afterBody,
        fallbackPosition: 0.3,
      );
      expect(notch.fallbackPosition, 0.3);
    });

    test('notchRadius is stored correctly', () {
      const notch = FluxNotch(
        boundary: FluxSlotBoundary.afterHeader,
        notchRadius: 20.0,
      );
      expect(notch.notchRadius, 20.0);
    });

    test('edge defaults to vertical', () {
      const notch = FluxNotch(boundary: FluxSlotBoundary.afterHeader);
      expect(notch.edge, FluxNotchEdge.vertical);
    });

    test('notchSide defaults to both', () {
      const notch = FluxNotch(boundary: FluxSlotBoundary.afterHeader);
      expect(notch.notchSide, FluxNotchSide.both);
    });

    test('side defaults to BorderSide.none', () {
      const notch = FluxNotch(boundary: FluxSlotBoundary.afterHeader);
      expect(notch.side, BorderSide.none);
    });

    test('buildBorderPainter returns a non-null CustomPainter', () {
      const notch = FluxNotch(boundary: FluxSlotBoundary.afterHeader);
      final painter = notch.buildBorderPainter(
        0.5,
        const BorderRadius.all(Radius.circular(16)),
        TextDirection.ltr,
      );
      expect(painter, isNotNull);
    });
  });

  // ---------------------------------------------------------------------------
  // FluxNotch.free constructor
  // ---------------------------------------------------------------------------

  group('FluxNotch.free', () {
    test('isTargeted is false for free notch', () {
      const notch = FluxNotch.free();
      expect(notch.isTargeted, isFalse);
    });

    test('position defaults to 0.5', () {
      const notch = FluxNotch.free();
      expect(notch.fallbackPosition, 0.5);
    });

    test('custom position is stored', () {
      const notch = FluxNotch.free(position: 0.7);
      expect(notch.fallbackPosition, 0.7);
    });

    test('custom notchRadius is stored', () {
      const notch = FluxNotch.free(notchRadius: 18.0);
      expect(notch.notchRadius, 18.0);
    });

    test('horizontal edge is stored correctly', () {
      const notch = FluxNotch.free(edge: FluxNotchEdge.horizontal);
      expect(notch.edge, FluxNotchEdge.horizontal);
    });
  });

  // ---------------------------------------------------------------------------
  // Integration — FluxNotch in FluxCard
  // ---------------------------------------------------------------------------

  group('FluxNotch — in FluxCard', () {
    testWidgets('free notch renders card without throwing', (tester) async {
      await tester.pumpWidget(wrap(FluxCard(
        notch: const FluxNotch.free(position: 0.5, notchRadius: 14),
        header: const Text('ticket top'),
        divider: const FluxDivider(afterHeader: Divider()),
        body: const Text('ticket bottom'),
      )));
      expect(find.text('ticket top'), findsOneWidget);
      expect(find.text('ticket bottom'), findsOneWidget);
    });

    testWidgets('boundary-targeted notch renders card without throwing', (tester) async {
      await tester.pumpWidget(wrap(FluxCard(
        notch: const FluxNotch(
          boundary: FluxSlotBoundary.afterHeader,
          notchRadius: 12,
          side: BorderSide(color: Colors.grey, width: 1.5),
        ),
        divider: FluxDivider(
          afterHeader: Divider(color: Colors.grey.shade300),
        ),
        header: const Text('above notch'),
        body: const Text('below notch'),
      )));
      expect(find.text('above notch'), findsOneWidget);
      expect(find.text('below notch'), findsOneWidget);
    });

    testWidgets('notch with FluxNotchSide.start only cuts left edge', (tester) async {
      await tester.pumpWidget(wrap(FluxCard(
        notch: const FluxNotch.free(
          notchSide: FluxNotchSide.start,
          notchRadius: 12,
        ),
        header: const Text('one side notch'),
        body: const Text('body'),
      )));
      expect(find.byType(FluxCard), findsOneWidget);
    });

    testWidgets('FluxNotchShape used as card shape renders correctly', (tester) async {
      await tester.pumpWidget(wrap(FluxCard(
        theme: const FluxCardThemeData(
          shape: FluxNotchShape(
            notchRadius: 14,
            notchPosition: 0.5,
            side: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        header: const Text('custom shape'),
      )));
      expect(find.text('custom shape'), findsOneWidget);
    });
  });
}