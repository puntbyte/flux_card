import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    home: Scaffold(body: SizedBox(width: 300, child: child)),
  );

  group('FluxNotch', () {
    group('boundary constructor', () {
      test('isTargeted is true when boundary is set', () {
        const notch = FluxNotch(boundary: FluxSlotBoundary.afterHeader);
        expect(notch.isTargeted, isTrue);
      });

      test('fallbackPosition defaults to 0.5', () {
        const notch = FluxNotch(boundary: FluxSlotBoundary.afterHeader);
        expect(notch.fallbackPosition, 0.5);
      });

      test('custom fallbackPosition is stored', () {
        const notch = FluxNotch(boundary: FluxSlotBoundary.afterBody, fallbackPosition: 0.3);
        expect(notch.fallbackPosition, 0.3);
      });

      test('notchRadius is stored correctly', () {
        const notch = FluxNotch(boundary: FluxSlotBoundary.afterHeader, notchRadius: 20.0);
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

      test('boundaryAlignment defaults to center', () {
        const notch = FluxNotch(boundary: FluxSlotBoundary.afterHeader);
        expect(notch.boundaryAlignment, Alignment.center);
      });

      test('custom boundaryOffset is stored', () {
        const notch = FluxNotch(boundary: FluxSlotBoundary.afterHeader, boundaryOffset: 8);
        expect(notch.boundaryOffset, 8);
      });

      test('custom borderRadius is stored', () {
        const radius = BorderRadius.all(Radius.circular(24));
        const notch = FluxNotch(boundary: FluxSlotBoundary.afterHeader, borderRadius: radius);
        expect(notch.borderRadius, radius);
      });
    });

    group('free constructor', () {
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

      test('custom borderRadius is stored', () {
        const radius = BorderRadius.all(Radius.circular(20));
        const notch = FluxNotch.free(borderRadius: radius);
        expect(notch.borderRadius, radius);
      });
    });

    group('integration in FluxCard', () {
      testWidgets('free notch renders card without throwing', (tester) async {
        await tester.pumpWidget(
          wrap(
            FluxCard(
              notch: const FluxNotch.free(position: 0.5, notchRadius: 14),
              header: const Text('ticket top'),
              divider: const FluxDivider(afterHeader: Divider()),
              body: const Text('ticket bottom'),
            ),
          ),
        );

        expect(find.text('ticket top'), findsOneWidget);
        expect(find.text('ticket bottom'), findsOneWidget);
      });

      testWidgets('boundary-targeted notch renders card without throwing', (tester) async {
        await tester.pumpWidget(
          wrap(
            FluxCard(
              notch: const FluxNotch(boundary: FluxSlotBoundary.afterHeader, notchRadius: 12),
              theme: FluxCardThemeData.outlined.copyWith(
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
              ),
              divider: FluxDivider(afterHeader: Divider(color: Colors.grey.shade300)),
              header: const Text('above notch'),
              body: const Text('below notch'),
            ),
          ),
        );

        expect(find.text('above notch'), findsOneWidget);
        expect(find.text('below notch'), findsOneWidget);
      });

      testWidgets('notch with FluxNotchSide.start only renders card without throwing', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrap(
            const FluxCard(
              notch: FluxNotch.free(notchSide: FluxNotchSide.start, notchRadius: 12),
              header: Text('one side notch'),
              body: Text('body'),
            ),
          ),
        );

        expect(find.byType(FluxCard), findsOneWidget);
        expect(find.text('one side notch'), findsOneWidget);
        expect(find.text('body'), findsOneWidget);
      });

      testWidgets('theme borderSide drives outline for notched cards', (tester) async {
        await tester.pumpWidget(
          wrap(
            FluxCard(
              notch: const FluxNotch.free(notchRadius: 14),
              theme: FluxCardThemeData.outlined.copyWith(
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              header: const Text('outlined notch'),
            ),
          ),
        );

        expect(find.text('outlined notch'), findsOneWidget);
      });

      testWidgets('FluxNotchShape used directly as card shape still renders correctly', (
        tester,
      ) async {
        await tester.pumpWidget(
          wrap(
            const FluxCard(
              theme: FluxCardThemeData(
                shape: FluxNotchShape(
                  notchRadius: 14,
                  notchPosition: 0.5,
                  side: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              header: Text('custom shape'),
            ),
          ),
        );

        expect(find.text('custom shape'), findsOneWidget);
      });
    });
  });
}
