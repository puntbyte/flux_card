import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

void main() {
  // ---------------------------------------------------------------------------
  // isGlobal
  // ---------------------------------------------------------------------------

  group('FluxOverlay — isGlobal', () {
    test('isGlobal is true when targets contains FluxTarget.card', () {
      const overlay = FluxOverlay(
        targets: {FluxTarget.card},
        children:[],
      );
      expect(overlay.isGlobal, isTrue);
    });

    test('isGlobal is true when all four slots are targeted', () {
      const overlay = FluxOverlay(
        targets: {FluxTarget.media, FluxTarget.header, FluxTarget.body, FluxTarget.footer},
        children:[],
      );
      expect(overlay.isGlobal, isTrue);
    });

    test('isGlobal is false when only media is targeted', () {
      const overlay = FluxOverlay(
        targets: {FluxTarget.media},
        children:[],
      );
      expect(overlay.isGlobal, isFalse);
    });

    test('isGlobal is false when only header and body are targeted', () {
      const overlay = FluxOverlay(
        targets: {FluxTarget.header, FluxTarget.body},
        children:[],
      );
      expect(overlay.isGlobal, isFalse);
    });

    test('default targets include FluxTarget.card — isGlobal is true', () {
      const overlay = FluxOverlay(children:[]);
      expect(overlay.isGlobal, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // targetsSlot
  // ---------------------------------------------------------------------------

  group('FluxOverlay — targetsSlot', () {
    test('targetsSlot returns true for targeted slot when not global', () {
      const overlay = FluxOverlay(
        targets: {FluxTarget.media},
        children:[],
      );
      expect(overlay.targetsSlot(FluxTarget.media), isTrue);
    });

    test('targetsSlot returns false for non-targeted slot', () {
      const overlay = FluxOverlay(
        targets: {FluxTarget.media},
        children:[],
      );
      expect(overlay.targetsSlot(FluxTarget.header), isFalse);
    });

    test('targetsSlot returns false for any slot when overlay is global', () {
      const overlay = FluxOverlay(targets: {FluxTarget.card}, children:[]);
      expect(overlay.targetsSlot(FluxTarget.media), isFalse);
      expect(overlay.targetsSlot(FluxTarget.header), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // Build behaviour
  // ---------------------------------------------------------------------------

  group('FluxOverlay — build', () {
    Widget wrap(Widget child) =>
        MaterialApp(home: Scaffold(body: Center(child: child)));

    testWidgets('renders children in a Wrap', (tester) async {
      await tester.pumpWidget(wrap(const FluxOverlay(
        children: [Text('A'), Text('B')],
      )));
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('returns SizedBox.shrink when children is empty', (tester) async {
      await tester.pumpWidget(wrap(const FluxOverlay(children:[])));

      final overlayFinder = find.byType(FluxOverlay);
      expect(overlayFinder, findsOneWidget);

      // If it returns SizedBox.shrink(), there should be no Align or Wrap descendants
      expect(
        find.descendant(of: overlayFinder, matching: find.byType(Align)),
        findsNothing,
      );
    });

    testWidgets('wraps in IgnorePointer when interactive is false', (tester) async {
      await tester.pumpWidget(wrap(const FluxOverlay(
        interactive: false,
        children:[Text('non-interactive')],
      )));

      final overlayFinder = find.byType(FluxOverlay);

      // Look specifically for an IgnorePointer inside the FluxOverlay
      final ignorePointerFinder = find.descendant(
        of: overlayFinder,
        matching: find.byWidgetPredicate((w) => w is IgnorePointer && w.ignoring == true),
      );

      expect(ignorePointerFinder, findsOneWidget);
    });

    testWidgets('no IgnorePointer when interactive is true', (tester) async {
      await tester.pumpWidget(wrap(const FluxOverlay(
        interactive: true,
        children: [Text('interactive')],
      )));

      final overlayFinder = find.byType(FluxOverlay);

      // There should be NO IgnorePointer(ignoring: true) inside our overlay
      final ignorePointerFinder = find.descendant(
        of: overlayFinder,
        matching: find.byWidgetPredicate((w) => w is IgnorePointer && w.ignoring == true),
      );

      expect(ignorePointerFinder, findsNothing);
    });

    testWidgets('applies Transform.translate when offset is set', (tester) async {
      await tester.pumpWidget(wrap(const FluxOverlay(
        offset: Offset(10, 20),
        children: [Text('offset')],
      )));

      final overlayFinder = find.byType(FluxOverlay);

      // Find Transform.translate (which uses Transform internally)
      final transformFinder = find.descendant(
        of: overlayFinder,
        matching: find.byType(Transform),
      );

      expect(transformFinder, findsOneWidget);
    });

    testWidgets('no Transform when offset is null', (tester) async {
      await tester.pumpWidget(wrap(const FluxOverlay(
        children:[Text('no offset')],
      )));

      final overlayFinder = find.byType(FluxOverlay);

      final transformFinder = find.descendant(
        of: overlayFinder,
        matching: find.byType(Transform),
      );

      expect(transformFinder, findsNothing);
    });

    testWidgets('wraps in Align with correct alignment', (tester) async {
      await tester.pumpWidget(wrap(const FluxOverlay(
        alignment: Alignment.bottomLeft,
        children:[Text('bottom left')],
      )));

      final overlayFinder = find.byType(FluxOverlay);

      final alignFinder = find.descendant(
        of: overlayFinder,
        matching: find.byType(Align),
      );

      expect(alignFinder, findsOneWidget);

      final align = tester.widget<Align>(alignFinder.first);
      expect(align.alignment, Alignment.bottomLeft);
    });
  });

  // ---------------------------------------------------------------------------
  // Integration — overlay in FluxCard
  // ---------------------------------------------------------------------------

  group('FluxOverlay — in FluxCard', () {
    Widget wrap(Widget child) =>
        MaterialApp(home: Scaffold(body: Center(child: child)));

    testWidgets('media-targeted overlay appears inside media slot', (tester) async {
      await tester.pumpWidget(wrap(const SizedBox(
        width: 300,
        child: FluxCard(
          media: SizedBox(height: 120, child: ColoredBox(color: Colors.grey)),
          overlays:[
            FluxOverlay(
              targets: {FluxTarget.media},
              alignment: Alignment.topRight,
              children:[Text('media badge')],
            ),
          ],
        ),
      )));
      expect(find.text('media badge'), findsOneWidget);
    });

    testWidgets('global overlay spans full card', (tester) async {
      await tester.pumpWidget(wrap(const SizedBox(
        width: 300,
        child: FluxCard(
          header: Text('header'),
          overlays:[
            FluxOverlay(
              targets: {FluxTarget.card},
              alignment: Alignment.bottomRight,
              children: [Text('global badge')],
            ),
          ],
        ),
      )));
      expect(find.text('global badge'), findsOneWidget);
    });

    testWidgets('zIndex ordering renders higher-index overlay last', (tester) async {
      // Both overlays render — z-index affects stack order not visibility
      await tester.pumpWidget(wrap(const SizedBox(
        width: 300,
        child: FluxCard(
          header: Text('header'),
          overlays:[
            FluxOverlay(zIndex: 0, children: [Text('low')]),
            FluxOverlay(zIndex: 1, children: [Text('high')]),
          ],
        ),
      )));
      expect(find.text('low'), findsOneWidget);
      expect(find.text('high'), findsOneWidget);
    });

    testWidgets('breakout overlay with Clip.none renders outside card bounds', (tester) async {
      await tester.pumpWidget(wrap(SizedBox(
        width: 300,
        child: FluxCard(
          clipBehavior: Clip.none,
          media: const SizedBox(height: 80, child: ColoredBox(color: Colors.blue)),
          overlays: const[
            FluxOverlay(
              targets: {FluxTarget.media},
              alignment: Alignment.topRight,
              offset: Offset(24, -24),
              children: [Text('breakout')],
            ),
          ],
        ),
      )));
      expect(find.text('breakout'), findsOneWidget);
    });
  });
}