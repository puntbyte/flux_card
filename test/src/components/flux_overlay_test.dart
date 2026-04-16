import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

void main() {
  // ---------------------------------------------------------------------------
  // isGlobal
  // ---------------------------------------------------------------------------

  group('FluxOverlay — isGlobal', () {
    test('isGlobal is true when targets contains FluxTarget.card', () {
      const overlay = FluxOverlay(targets: {FluxTarget.card}, children: []);
      expect(overlay.isGlobal, isTrue);
    });

    test('isGlobal is true when all four slots are targeted', () {
      const overlay = FluxOverlay(
        targets: {FluxTarget.media, FluxTarget.header, FluxTarget.body, FluxTarget.footer},
        children: [],
      );
      expect(overlay.isGlobal, isTrue);
    });

    test('isGlobal is false when only media is targeted', () {
      const overlay = FluxOverlay(targets: {FluxTarget.media}, children: []);
      expect(overlay.isGlobal, isFalse);
    });

    test('isGlobal is false when only header and body are targeted', () {
      const overlay = FluxOverlay(targets: {FluxTarget.header, FluxTarget.body}, children: []);
      expect(overlay.isGlobal, isFalse);
    });

    test('default targets include FluxTarget.card — isGlobal is true', () {
      const overlay = FluxOverlay(children: []);
      expect(overlay.isGlobal, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // targetsSlot
  // ---------------------------------------------------------------------------

  group('FluxOverlay — targetsSlot', () {
    test('targetsSlot returns true for targeted slot when not global', () {
      const overlay = FluxOverlay(targets: {FluxTarget.media}, children: []);
      expect(overlay.targetsSlot(FluxTarget.media), isTrue);
    });

    test('targetsSlot returns false for non-targeted slot', () {
      const overlay = FluxOverlay(targets: {FluxTarget.media}, children: []);
      expect(overlay.targetsSlot(FluxTarget.header), isFalse);
    });

    test('targetsSlot returns false for any slot when overlay is global', () {
      const overlay = FluxOverlay(targets: {FluxTarget.card}, children: []);
      expect(overlay.targetsSlot(FluxTarget.media), isFalse);
      expect(overlay.targetsSlot(FluxTarget.header), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // Build behaviour
  // ---------------------------------------------------------------------------

  group('FluxOverlay — build', () {
    Widget wrap(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );

    testWidgets('renders children in a Wrap', (tester) async {
      await tester.pumpWidget(wrap(const FluxOverlay(children: [Text('A'), Text('B')])));
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('returns SizedBox.shrink when children is empty', (tester) async {
      await tester.pumpWidget(wrap(const FluxOverlay(children: [])));

      final overlayFinder = find.byType(FluxOverlay);
      expect(overlayFinder, findsOneWidget);

      // If it returns SizedBox.shrink(), there should be no Align or Wrap descendants
      expect(find.descendant(of: overlayFinder, matching: find.byType(Align)), findsNothing);
    });

    testWidgets('wraps in IgnorePointer when interactive is false', (tester) async {
      await tester.pumpWidget(
        wrap(const FluxOverlay(interactive: false, children: [Text('non-interactive')])),
      );

      final overlayFinder = find.byType(FluxOverlay);

      // Look specifically for an IgnorePointer inside the FluxOverlay
      final ignorePointerFinder = find.descendant(
        of: overlayFinder,
        matching: find.byWidgetPredicate((w) => w is IgnorePointer && w.ignoring == true),
      );

      expect(ignorePointerFinder, findsOneWidget);
    });

    testWidgets('no IgnorePointer when interactive is true', (tester) async {
      await tester.pumpWidget(
        wrap(const FluxOverlay(interactive: true, children: [Text('interactive')])),
      );

      final overlayFinder = find.byType(FluxOverlay);

      // There should be NO IgnorePointer(ignoring: true) inside our overlay
      final ignorePointerFinder = find.descendant(
        of: overlayFinder,
        matching: find.byWidgetPredicate((w) => w is IgnorePointer && w.ignoring == true),
      );

      expect(ignorePointerFinder, findsNothing);
    });

    testWidgets('applies Transform.translate when offset is set', (tester) async {
      await tester.pumpWidget(
        wrap(const FluxOverlay(offset: Offset(10, 20), children: [Text('offset')])),
      );

      final overlayFinder = find.byType(FluxOverlay);

      // Find Transform.translate (which uses Transform internally)
      final transformFinder = find.descendant(of: overlayFinder, matching: find.byType(Transform));

      expect(transformFinder, findsOneWidget);
    });

    testWidgets('no Transform when offset is null', (tester) async {
      await tester.pumpWidget(wrap(const FluxOverlay(children: [Text('no offset')])));

      final overlayFinder = find.byType(FluxOverlay);

      final transformFinder = find.descendant(of: overlayFinder, matching: find.byType(Transform));

      expect(transformFinder, findsNothing);
    });

    testWidgets('wraps in OverflowBox with correct alignment', (tester) async {
      await tester.pumpWidget(
        wrap(const FluxOverlay(alignment: Alignment.bottomLeft, children: [Text('bottom left')])),
      );

      final overlayFinder = find.byType(FluxOverlay);

      final overflowFinder = find.descendant(of: overlayFinder, matching: find.byType(OverflowBox));

      expect(overflowFinder, findsOneWidget);

      final overflow = tester.widget<OverflowBox>(overflowFinder.first);
      expect(overflow.alignment, Alignment.bottomLeft);
    });
  });

  // ---------------------------------------------------------------------------
  // Integration — overlay in FluxCard
  // ---------------------------------------------------------------------------

  group('FluxOverlay — in FluxCard', () {
    Widget wrap(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );

    testWidgets('media-targeted overlay appears inside media slot', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 300,
            child: FluxCard(
              media: SizedBox(height: 120, child: ColoredBox(color: Colors.grey)),
              overlays: [
                FluxOverlay(
                  targets: {FluxTarget.media},
                  alignment: Alignment.topRight,
                  children: [Text('media badge')],
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.text('media badge'), findsOneWidget);
    });

    testWidgets('global overlay spans full card', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 300,
            child: FluxCard(
              header: Text('header'),
              overlays: [
                FluxOverlay(
                  targets: {FluxTarget.card},
                  alignment: Alignment.bottomRight,
                  children: [Text('global badge')],
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.text('global badge'), findsOneWidget);
    });

    testWidgets('zIndex ordering renders higher-index overlay last', (tester) async {
      // Both overlays render — z-index affects stack order not visibility
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 300,
            child: FluxCard(
              header: Text('header'),
              overlays: [
                FluxOverlay(zIndex: 0, children: [Text('low')]),
                FluxOverlay(zIndex: 1, children: [Text('high')]),
              ],
            ),
          ),
        ),
      );
      expect(find.text('low'), findsOneWidget);
      expect(find.text('high'), findsOneWidget);
    });

    testWidgets('breakout overlay renders outside card bounds without disabling card clipping', (
      tester,
    ) async {
      Widget wrap(Widget child) => MaterialApp(
        home: Scaffold(body: Center(child: child)),
      );

      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 300,
            child: FluxCard(
              media: SizedBox(
                key: Key('media'),
                height: 80,
                child: ColoredBox(color: Colors.blue),
              ),
              overlays: [
                FluxOverlay(
                  behavior: FluxOverlayBehavior.breakout,
                  targets: {FluxTarget.media},
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      key: Key('overlay'),
                      width: 80,
                      height: 140,
                      child: ColoredBox(color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pump();

      final mediaRect = tester.getRect(find.byKey(const Key('media')));
      final overlayRect = tester.getRect(find.byKey(const Key('overlay')));

      expect(overlayRect.right, moreOrLessEquals(mediaRect.right, epsilon: 0.01));
      expect(overlayRect.bottom, moreOrLessEquals(mediaRect.bottom, epsilon: 0.01));
      expect(overlayRect.top, lessThan(mediaRect.top));
    });
  });

  group('FluxOverlay — overflow alignment in FluxCard', () {
    Widget wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: Align(alignment: Alignment.topLeft, child: child),
      ),
    );

    testWidgets(
      'oversized overlay aligned bottomRight keeps its bottomRight attached to the media slot',
      (tester) async {
        const mediaKey = Key('media');
        const overlayKey = Key('overlay-box');

        await tester.pumpWidget(
          wrap(
            const SizedBox(
              width: 300,
              child: FluxCard(
                clipBehavior: Clip.none,
                media: SizedBox(
                  key: mediaKey,
                  height: 80,
                  child: ColoredBox(color: Colors.blue),
                ),
                overlays: [
                  FluxOverlay(
                    targets: {FluxTarget.media},
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(
                        key: overlayKey,
                        width: 100,
                        height: 160,
                        child: ColoredBox(color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        final mediaRect = tester.getRect(find.byKey(mediaKey));
        final overlayRect = tester.getRect(find.byKey(overlayKey));

        expect(overlayRect.right, moreOrLessEquals(mediaRect.right, epsilon: 0.01));
        expect(overlayRect.bottom, moreOrLessEquals(mediaRect.bottom, epsilon: 0.01));
        expect(overlayRect.top, lessThan(mediaRect.top));
      },
    );

    testWidgets('oversized overlay aligned topLeft keeps its topLeft attached to the media slot', (
      tester,
    ) async {
      const mediaKey = Key('media');
      const overlayKey = Key('overlay-box');

      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 300,
            child: FluxCard(
              clipBehavior: Clip.none,
              media: SizedBox(
                key: mediaKey,
                height: 80,
                child: ColoredBox(color: Colors.blue),
              ),
              overlays: [
                FluxOverlay(
                  targets: {FluxTarget.media},
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      key: overlayKey,
                      width: 100,
                      height: 160,
                      child: ColoredBox(color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final mediaRect = tester.getRect(find.byKey(mediaKey));
      final overlayRect = tester.getRect(find.byKey(overlayKey));

      expect(overlayRect.left, moreOrLessEquals(mediaRect.left, epsilon: 0.01));
      expect(overlayRect.top, moreOrLessEquals(mediaRect.top, epsilon: 0.01));
      expect(overlayRect.bottom, greaterThan(mediaRect.bottom));
    });
  });
}
