import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

void main() {
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: child));

  // ---------------------------------------------------------------------------
  // isGlobal
  // ---------------------------------------------------------------------------

  group('FluxUnderlay — isGlobal', () {
    test('isGlobal is true when targets contains FluxTarget.card', () {
      const underlay = FluxUnderlay(
        targets: {FluxTarget.card},
        decoration: BoxDecoration(color: Colors.blue),
      );
      expect(underlay.isGlobal, isTrue);
    });

    test('isGlobal is true when all four slots are targeted', () {
      const underlay = FluxUnderlay(
        targets: {FluxTarget.media, FluxTarget.header, FluxTarget.body, FluxTarget.footer},
        decoration: BoxDecoration(color: Colors.blue),
      );
      expect(underlay.isGlobal, isTrue);
    });

    test('isGlobal is false when only one slot is targeted', () {
      const underlay = FluxUnderlay(
        targets: {FluxTarget.media},
        decoration: BoxDecoration(color: Colors.blue),
      );
      expect(underlay.isGlobal, isFalse);
    });

    test('default targets contain FluxTarget.card — isGlobal is true', () {
      const underlay = FluxUnderlay(decoration: BoxDecoration());
      expect(underlay.isGlobal, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // targetsSlot
  // ---------------------------------------------------------------------------

  group('FluxUnderlay — targetsSlot', () {
    test('targetsSlot returns true for targeted slot when not global', () {
      const underlay = FluxUnderlay(
        targets: {FluxTarget.header},
        decoration: BoxDecoration(color: Colors.red),
      );
      expect(underlay.targetsSlot(FluxTarget.header), isTrue);
    });

    test('targetsSlot returns false for non-targeted slot', () {
      const underlay = FluxUnderlay(
        targets: {FluxTarget.header},
        decoration: BoxDecoration(color: Colors.red),
      );
      expect(underlay.targetsSlot(FluxTarget.body), isFalse);
    });

    test('targetsSlot returns false when underlay is global', () {
      const underlay = FluxUnderlay(
        targets: {FluxTarget.card},
        decoration: BoxDecoration(color: Colors.blue),
      );
      expect(underlay.targetsSlot(FluxTarget.media), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // Integration — underlay in FluxCard
  // ---------------------------------------------------------------------------

  group('FluxUnderlay — in FluxCard', () {
    testWidgets('global underlay renders without obscuring content', (tester) async {
      await tester.pumpWidget(wrap(SizedBox(
        width: 300,
        child: FluxCard(
          header: const Text('visible above underlay'),
          underlays: [
            FluxUnderlay(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.blue.shade100],
                ),
              ),
            ),
          ],
        ),
      )));
      expect(find.text('visible above underlay'), findsOneWidget);
    });

    testWidgets('underlay is IgnorePointer — taps pass through to content', (tester) async {
      int taps = 0;
      await tester.pumpWidget(wrap(SizedBox(
        width: 300,
        child: FluxCard(
          header: const Text('tappable'),
          onTap: () => taps++,
          underlays: [
            const FluxUnderlay(
              decoration: BoxDecoration(color: Colors.red),
            ),
          ],
        ),
      )));
      await tester.tap(find.byType(FluxCard));
      expect(taps, 1);
    });

    testWidgets('slot-targeted underlay renders in that slot', (tester) async {
      await tester.pumpWidget(wrap(const SizedBox(
        width: 300,
        child: FluxCard(
          header: Text('header'),
          body: Text('body'),
          underlays: [
            FluxUnderlay(
              targets: {FluxTarget.header},
              decoration: BoxDecoration(color: Colors.amber),
            ),
          ],
        ),
      )));
      // Both slots still render — underlay is behind header only
      expect(find.text('header'), findsOneWidget);
      expect(find.text('body'), findsOneWidget);
    });

    testWidgets('multi-target underlay spans header and body', (tester) async {
      await tester.pumpWidget(wrap(const SizedBox(
        width: 300,
        child: FluxCard(
          header: Text('header'),
          body: Text('body'),
          underlays: [
            FluxUnderlay(
              targets: {FluxTarget.header, FluxTarget.body},
              decoration: BoxDecoration(color: Colors.green),
            ),
          ],
        ),
      )));
      expect(find.text('header'), findsOneWidget);
      expect(find.text('body'), findsOneWidget);
    });

    testWidgets('negative margin extrudes underlay beyond slot', (tester) async {
      // Verify no exception is thrown with negative margin
      await tester.pumpWidget(wrap(const SizedBox(
        width: 300,
        child: FluxCard(
          header: Text('header'),
          body: Text('body'),
          underlays: [
            FluxUnderlay(
              targets: {FluxTarget.body},
              margin: EdgeInsets.only(top: -16),
              decoration: BoxDecoration(color: Colors.purple),
            ),
          ],
        ),
      )));
      expect(find.text('body'), findsOneWidget);
    });
  });
}