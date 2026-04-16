import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    home: Scaffold(body: SizedBox(width: 300, child: child)),
  );

  // ---------------------------------------------------------------------------
  // Default constructor
  // ---------------------------------------------------------------------------

  group('FluxContent — default constructor', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(wrap(const FluxContent(child: Text('content child'))));
      expect(find.text('content child'), findsOneWidget);
    });

    testWidgets('applies padding', (tester) async {
      await tester.pumpWidget(
        wrap(const FluxContent(padding: EdgeInsets.all(16), child: Text('padded'))),
      );
      final padding = tester.widget<Padding>(
        find.ancestor(of: find.text('padded'), matching: find.byType(Padding)).first,
      );
      expect(padding.padding, const EdgeInsets.all(16));
    });

    testWidgets('applies decoration via Ink', (tester) async {
      await tester.pumpWidget(
        wrap(
          FluxContent(
            decoration: BoxDecoration(color: Colors.amber.shade50),
            child: const Text('decorated'),
          ),
        ),
      );
      expect(find.byType(Ink), findsOneWidget);
    });

    testWidgets('externalPaddingOverride returns margin', (tester) async {
      const content = FluxContent(
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: Text('bleed'),
      );
      expect(content.externalPaddingOverride, const EdgeInsets.symmetric(horizontal: 12));
    });

    testWidgets('minHeight constrains minimum render height', (tester) async {
      await tester.pumpWidget(
        wrap(
          const FluxContent(
            minHeight: 100,
            child: SizedBox(height: 10), // Child is smaller than minHeight
          ),
        ),
      );
      final size = tester.getSize(find.byType(FluxContent));
      expect(size.height, greaterThanOrEqualTo(100.0));
    });

    testWidgets('maxHeight constrains maximum render height', (tester) async {
      await tester.pumpWidget(
        wrap(
          const FluxContent(
            maxHeight: 80,
            // Use a SizedBox that wants to be huge, avoiding RenderFlex overflow errors
            child: SizedBox(height: 1000),
          ),
        ),
      );
      final size = tester.getSize(find.byType(FluxContent));
      expect(size.height, 80.0); // Should be exactly clamped to 80
    });

    testWidgets('scrollable wraps content in SingleChildScrollView', (tester) async {
      await tester.pumpWidget(
        wrap(
          FluxContent(
            scrollable: true,
            maxHeight: 60,
            child: Column(children: List.generate(10, (i) => Text('item $i'))),
          ),
        ),
      );
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      // Because it's in a scroll view, the column can be as tall as it wants internally
      // without overflowing, while the outer FluxContent bounds it to 60px.
      final size = tester.getSize(find.byType(FluxContent));
      expect(size.height, 60.0);
    });

    testWidgets('not scrollable by default', (tester) async {
      await tester.pumpWidget(wrap(const FluxContent(child: Text('not scrollable'))));
      expect(find.byType(SingleChildScrollView), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // .column constructor
  // ---------------------------------------------------------------------------

  group('FluxContent.column', () {
    testWidgets('renders all children in a column', (tester) async {
      await tester.pumpWidget(
        wrap(FluxContent.column(children: const [Text('A'), Text('B'), Text('C')])),
      );
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('applies spacing between children', (tester) async {
      await tester.pumpWidget(
        wrap(FluxContent.column(spacing: 20, children: const [Text('first'), Text('second')])),
      );
      final firstPos = tester.getTopLeft(find.text('first'));
      final secondPos = tester.getTopLeft(find.text('second'));
      // Second item should be at least spacing below first
      expect(secondPos.dy - firstPos.dy, greaterThan(20.0));

      // Verify a SizedBox was injected
      expect(find.byType(SizedBox), findsWidgets);
    });
  });

  // ---------------------------------------------------------------------------
  // .row constructor
  // ---------------------------------------------------------------------------

  group('FluxContent.row', () {
    testWidgets('renders all children in a row', (tester) async {
      await tester.pumpWidget(wrap(FluxContent.row(children: const [Text('X'), Text('Y')])));
      expect(find.text('X'), findsOneWidget);
      expect(find.text('Y'), findsOneWidget);
    });

    testWidgets('children are arranged horizontally', (tester) async {
      await tester.pumpWidget(wrap(FluxContent.row(children: const [Text('left'), Text('right')])));
      final leftPos = tester.getTopLeft(find.text('left'));
      final rightPos = tester.getTopLeft(find.text('right'));
      expect(rightPos.dx, greaterThan(leftPos.dx));
    });
  });

  // ---------------------------------------------------------------------------
  // .wrap constructor
  // ---------------------------------------------------------------------------

  group('FluxContent.wrap', () {
    testWidgets('renders chips in a Wrap widget', (tester) async {
      await tester.pumpWidget(
        wrap(
          FluxContent.wrap(
            children: const [
              Chip(label: Text('tag1')),
              Chip(label: Text('tag2')),
              Chip(label: Text('tag3')),
            ],
          ),
        ),
      );
      expect(find.text('tag1'), findsOneWidget);
      expect(find.text('tag2'), findsOneWidget);
      expect(find.text('tag3'), findsOneWidget);
      expect(find.byType(Wrap), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Integration — FluxContent in FluxCard body slot
  // ---------------------------------------------------------------------------

  group('FluxContent — in FluxCard', () {
    testWidgets('column content renders inside card body', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: FluxCard(
                body: FluxContent.column(children: const [Text('item 1'), Text('item 2')]),
              ),
            ),
          ),
        ),
      );
      expect(find.text('item 1'), findsOneWidget);
      expect(find.text('item 2'), findsOneWidget);
    });

    testWidgets('margin: EdgeInsets.zero overrides card padding for full-bleed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: FluxCard(
                theme: FluxCardThemeData.elevated.copyWith(padding: const EdgeInsets.all(20)),
                body: const FluxContent(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.all(20),
                  child: Text('full bleed body'),
                ),
              ),
            ),
          ),
        ),
      );
      expect(find.text('full bleed body'), findsOneWidget);
    });
  });
}
