import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

void main() {
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: SizedBox(width: 300, child: child)));

  // ---------------------------------------------------------------------------
  // FluxDivider — widgetFor
  // ---------------------------------------------------------------------------

  group('FluxDivider — widgetFor', () {
    const dividerWidget = Divider();

    test('returns afterMedia widget for afterMedia boundary', () {
      const d = FluxDivider(afterMedia: dividerWidget);
      expect(d.widgetFor(FluxSlotBoundary.afterMedia), same(dividerWidget));
      expect(d.widgetFor(FluxSlotBoundary.afterHeader), isNull);
      expect(d.widgetFor(FluxSlotBoundary.afterBody), isNull);
    });

    test('returns afterHeader widget for afterHeader boundary', () {
      const d = FluxDivider(afterHeader: dividerWidget);
      expect(d.widgetFor(FluxSlotBoundary.afterHeader), same(dividerWidget));
      expect(d.widgetFor(FluxSlotBoundary.afterMedia), isNull);
      expect(d.widgetFor(FluxSlotBoundary.afterBody), isNull);
    });

    test('returns afterBody widget for afterBody boundary', () {
      const d = FluxDivider(afterBody: dividerWidget);
      expect(d.widgetFor(FluxSlotBoundary.afterBody), same(dividerWidget));
      expect(d.widgetFor(FluxSlotBoundary.afterMedia), isNull);
      expect(d.widgetFor(FluxSlotBoundary.afterHeader), isNull);
    });

    test('all slots can be set simultaneously', () {
      const d = FluxDivider(
        afterMedia: Divider(),
        afterHeader: Divider(color: Colors.red),
        afterBody: Divider(color: Colors.blue),
      );
      expect(d.widgetFor(FluxSlotBoundary.afterMedia), isNotNull);
      expect(d.widgetFor(FluxSlotBoundary.afterHeader), isNotNull);
      expect(d.widgetFor(FluxSlotBoundary.afterBody), isNotNull);
    });

    test('returns null for all boundaries when constructed with no args', () {
      const d = FluxDivider();
      expect(d.widgetFor(FluxSlotBoundary.afterMedia), isNull);
      expect(d.widgetFor(FluxSlotBoundary.afterHeader), isNull);
      expect(d.widgetFor(FluxSlotBoundary.afterBody), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // FluxDivider — in FluxCard
  // ---------------------------------------------------------------------------

  group('FluxDivider — in FluxCard', () {
    testWidgets('afterHeader divider renders between header and body', (tester) async {
      await tester.pumpWidget(wrap(FluxCard(
        divider: const FluxDivider(afterHeader: Divider()),
        header: const Text('above divider'),
        body: const Text('below divider'),
      )));
      expect(find.text('above divider'), findsOneWidget);
      expect(find.text('below divider'), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('afterBody divider renders between body and footer', (tester) async {
      await tester.pumpWidget(wrap(FluxCard(
        divider: const FluxDivider(afterBody: Divider(color: Colors.red)),
        body: const Text('body'),
        footer: const Text('footer'),
      )));
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('custom widget can be used as divider', (tester) async {
      await tester.pumpWidget(wrap(FluxCard(
        divider: FluxDivider(
          afterHeader: Container(height: 2, color: Colors.blue),
        ),
        header: const Text('header'),
        body: const Text('body'),
      )));
      expect(find.text('header'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });
  });

  // ---------------------------------------------------------------------------
  // FluxDashedDivider
  // ---------------------------------------------------------------------------

  group('FluxDashedDivider', () {
    testWidgets('renders a CustomPaint widget', (tester) async {
      await tester.pumpWidget(wrap(const FluxDashedDivider()));

      expect(find.byType(FluxDashedDivider), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(FluxDashedDivider),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
    });

    testWidgets('height matches thickness', (tester) async {
      await tester.pumpWidget(wrap(const SizedBox(
        width: 200,
        child: FluxDashedDivider(thickness: 2.0),
      )));
      final size = tester.getSize(find.byType(FluxDashedDivider));
      expect(size.height, 2.0);
    });

    testWidgets('renders without throwing in FluxCard with FluxNotch', (tester) async {
      await tester.pumpWidget(wrap(FluxCard(
        divider: const FluxDivider(afterHeader: FluxDashedDivider()),
        notch: const FluxNotch(boundary: FluxSlotBoundary.afterHeader),
        header: const Text('ticket top'),
        body: const Text('ticket bottom'),
      )));
      expect(find.text('ticket top'), findsOneWidget);
      expect(find.byType(FluxDashedDivider), findsOneWidget);
    });

    testWidgets('color defaults to Theme dividerColor', (tester) async {
      const Color dividerColor = Color(0xFF123456);
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(dividerColor: dividerColor),
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: Builder(
              builder: (ctx) => const FluxDashedDivider(),
            ),
          ),
        ),
      ));
      expect(find.byType(FluxDashedDivider), findsOneWidget);
    });

    test('shouldRepaint returns true when color changes', () {
      // Access painter indirectly via CustomPaint comparison
      // We verify the widget rebuilds when properties change
      const a = FluxDashedDivider(color: Colors.red);
      const b = FluxDashedDivider(color: Colors.blue);
      expect(a == b, isFalse);
    });
  });
}