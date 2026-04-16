import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/src/core/enums.dart';
import 'package:flux_card/src/core/theme.dart';
import 'package:flux_card/src/layout/match_height_row.dart';
import 'package:flux_card/src/layout/row_layout.dart';
import 'package:flux_card/src/layout/slot_resolver.dart';

// Dummy wrapper for testing external padding overrides
class DummySlotWrapper extends StatelessWidget implements FluxSlotWrapper {
  const DummySlotWrapper({super.key, required this.child, this.externalPaddingOverride});

  final Widget child;

  @override
  final EdgeInsetsGeometry? externalPaddingOverride;

  @override
  Widget build(BuildContext context) => child;
}

void main() {
  Widget wrap(Widget child) => MaterialApp(
    home: Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: 400, child: child),
      ),
    ),
  );

  const theme = FluxCardThemeData(
    spacing: 10,
    padding: EdgeInsets.zero,
    flexMedia: 1,
    flexContent: 1,
  );

  group('FluxRowLayout', () {
    testWidgets('renders entirely as column if media is null', (tester) async {
      const layout = FluxRowLayout(
        mediaPosition: FluxMediaPosition.start,
        mediaSpan: FluxMediaSpan.all,
        theme: theme,
        resolvedPadding: EdgeInsets.zero,
      );

      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              return layout.build(
                context,
                mediaSlot: null,
                header: const Text('Header'),
                body: const Text('Body'),
                underlaysByTarget: {},
                ovsByTarget: {},
                multiUnderlays: [],
                multiOvs: [],
              );
            },
          ),
        ),
      );

      expect(find.byType(FluxMatchHeightRow), findsNothing);

      final headerY = tester.getTopLeft(find.text('Header')).dy;
      final bodyY = tester.getTopLeft(find.text('Body')).dy;
      expect(headerY, lessThan(bodyY));
    });

    testWidgets('FluxMediaSpan.all places all content inside the Row', (tester) async {
      const layout = FluxRowLayout(
        mediaPosition: FluxMediaPosition.start,
        mediaSpan: FluxMediaSpan.all,
        theme: theme,
        resolvedPadding: EdgeInsets.zero,
      );

      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              return layout.build(
                context,
                mediaSlot: const SizedBox(height: 100, child: Text('Media')),
                header: const Text('Header'),
                body: const Text('Body'),
                footer: const Text('Footer'),
                underlaysByTarget: {},
                ovsByTarget: {},
                multiUnderlays: [],
                multiOvs: [],
              );
            },
          ),
        ),
      );

      expect(find.byType(FluxMatchHeightRow), findsOneWidget);

      // Verify they are all grouped vertically inside the same row space
      final mediaX = tester.getTopLeft(find.text('Media')).dx;
      final headerX = tester.getTopLeft(find.text('Header')).dx;
      final bodyX = tester.getTopLeft(find.text('Body')).dx;

      expect(mediaX, 0.0); // Media is on the left
      expect(headerX, 200.0); // Flex 1:1 on 400px width
      expect(bodyX, 200.0);
    });

    testWidgets('FluxMediaSpan.body places header before, footer after the Row', (tester) async {
      const layout = FluxRowLayout(
        mediaPosition: FluxMediaPosition.start,
        mediaSpan: FluxMediaSpan.body,
        theme: theme,
        resolvedPadding: EdgeInsets.zero,
      );

      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              return layout.build(
                context,
                mediaSlot: const SizedBox(height: 100, child: Text('Media')),
                header: const SizedBox(height: 50, child: Text('Header')),
                body: const SizedBox(height: 100, child: Text('Body')),
                footer: const SizedBox(height: 50, child: Text('Footer')),
                underlaysByTarget: {},
                ovsByTarget: {},
                multiUnderlays: [],
                multiOvs: [],
              );
            },
          ),
        ),
      );

      expect(find.byType(FluxMatchHeightRow), findsOneWidget);

      final headerY = tester.getTopLeft(find.text('Header')).dy;
      final mediaY = tester.getTopLeft(find.text('Media')).dy;
      final bodyY = tester.getTopLeft(find.text('Body')).dy;
      final footerY = tester.getTopLeft(find.text('Footer')).dy;

      // Mathematical proof of the layout structure
      expect(headerY, 0.0);
      expect(mediaY, 60.0); // Header height (50) + spacing (10)
      expect(bodyY, 60.0); // Body aligns with media top
      expect(footerY, 170.0); // Media Y (60) + Media Height (100) + spacing (10)
    });

    testWidgets('respects external padding override from FluxSlotWrapper', (tester) async {
      const layout = FluxRowLayout(
        mediaPosition: FluxMediaPosition.start,
        mediaSpan: FluxMediaSpan.all,
        theme: theme,
        resolvedPadding: EdgeInsets.all(20), // Card default padding
      );

      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              return layout.build(
                context,
                mediaSlot: const SizedBox(height: 100, child: Text('Media')),
                header: const DummySlotWrapper(
                  externalPaddingOverride: EdgeInsets.all(50), // Force override
                  child: Text('Override'),
                ),
                underlaysByTarget: {},
                ovsByTarget: {},
                multiUnderlays: [],
                multiOvs: [],
              );
            },
          ),
        ),
      );

      // Find the Padding widget wrapping our Override text
      final paddingWidget = tester.widget<Padding>(
        find.ancestor(of: find.text('Override'), matching: find.byType(Padding)).first,
      );

      // Verify the slot successfully bypassed the card's 20px padding
      expect(paddingWidget.padding, const EdgeInsets.all(50));
    });
  });
}
