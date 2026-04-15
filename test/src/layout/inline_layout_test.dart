import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/src/core/enums.dart';
import 'package:flux_card/src/core/theme.dart';
import 'package:flux_card/src/layout/boundary_tracker.dart';
import 'package:flux_card/src/layout/inline_layout.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));
  const theme = FluxCardThemeData(spacing: 10, padding: EdgeInsets.zero);

  group('FluxInlineLayout', () {
    testWidgets('mediaPosition.start splits layout: Header -> Media -> Body',
            (tester) async {
          const layout = FluxInlineLayout(
            mediaPosition: FluxMediaPosition.start,
            mediaSpan: FluxMediaSpan.all,
            theme: theme,
            resolvedPadding: EdgeInsets.zero,
          );

          await tester.pumpWidget(wrap(Builder(
            builder: (context) {
              return layout.build(
                context,
                mediaSlot: const SizedBox(height: 50, child: Text('Media')),
                header: const Text('Header'),
                body: const Text('Body'),
                footer: const Text('Footer'),
                underlaysByTarget: {},
                ovsByTarget: {},
                multiUnderlays: [],
                multiOvs: [],
              );
            },
          )));

          final headerY = tester.getTopLeft(find.text('Header')).dy;
          final mediaY = tester.getTopLeft(find.text('Media')).dy;
          final bodyY = tester.getTopLeft(find.text('Body')).dy;
          final footerY = tester.getTopLeft(find.text('Footer')).dy;

          expect(headerY, lessThan(mediaY));
          expect(mediaY, lessThan(bodyY));
          expect(bodyY, lessThan(footerY));
        });

    testWidgets('mediaPosition.end splits layout: Body -> Media -> Footer',
            (tester) async {
          const layout = FluxInlineLayout(
            mediaPosition: FluxMediaPosition.end,
            mediaSpan: FluxMediaSpan.all,
            theme: theme,
            resolvedPadding: EdgeInsets.zero,
          );

          await tester.pumpWidget(wrap(Builder(
            builder: (context) {
              return layout.build(
                context,
                mediaSlot: const SizedBox(height: 50, child: Text('Media')),
                header: const Text('Header'),
                body: const Text('Body'),
                footer: const Text('Footer'),
                underlaysByTarget: {},
                ovsByTarget: {},
                multiUnderlays: [],
                multiOvs: [],
              );
            },
          )));

          final headerY = tester.getTopLeft(find.text('Header')).dy;
          final bodyY = tester.getTopLeft(find.text('Body')).dy;
          final mediaY = tester.getTopLeft(find.text('Media')).dy;
          final footerY = tester.getTopLeft(find.text('Footer')).dy;

          expect(headerY, lessThan(bodyY));
          expect(bodyY, lessThan(mediaY));
          expect(mediaY, lessThan(footerY));
        });

    testWidgets('handles missing slots gracefully', (tester) async {
      const layout = FluxInlineLayout(
        mediaPosition: FluxMediaPosition.start,
        mediaSpan: FluxMediaSpan.all,
        theme: theme,
        resolvedPadding: EdgeInsets.zero,
      );

      await tester.pumpWidget(wrap(Builder(
        builder: (context) {
          return layout.build(
            context,
            mediaSlot: const SizedBox(height: 50, child: Text('Media')),
            footer: const Text('Footer'),
            underlaysByTarget: {},
            ovsByTarget: {},
            multiUnderlays: [],
            multiOvs: [],
          );
        },
      )));

      expect(find.text('Media'), findsOneWidget);
      expect(find.text('Footer'), findsOneWidget);

      // Header and body are omitted, so only the available slots should render.
      expect(find.text('Header'), findsNothing);
      expect(find.text('Body'), findsNothing);

      final mediaY = tester.getTopLeft(find.text('Media')).dy;
      final footerY = tester.getTopLeft(find.text('Footer')).dy;
      expect(mediaY, lessThan(footerY));
    });

    testWidgets('uses afterMedia boundary tracker when provided',
            (tester) async {
          final tracker = BoundaryTracker();

          const layout = FluxInlineLayout(
            mediaPosition: FluxMediaPosition.start,
            mediaSpan: FluxMediaSpan.all,
            theme: theme,
            resolvedPadding: EdgeInsets.zero,
            boundaryTrackers: null,
          );

          await tester.pumpWidget(wrap(Builder(
            builder: (context) {
              final customLayout = FluxInlineLayout(
                mediaPosition: layout.mediaPosition,
                mediaSpan: layout.mediaSpan,
                theme: layout.theme,
                resolvedPadding: layout.resolvedPadding,
                boundaryTrackers: {
                  FluxSlotBoundary.afterMedia: tracker,
                },
              );

              return customLayout.build(
                context,
                mediaSlot: const SizedBox(height: 50, child: Text('Media')),
                header: const Text('Header'),
                body: const Text('Body'),
                footer: const Text('Footer'),
                underlaysByTarget: {},
                ovsByTarget: {},
                multiUnderlays: [],
                multiOvs: [],
              );
            },
          )));

          expect(find.text('Media'), findsOneWidget);
          expect(find.text('Header'), findsOneWidget);
          expect(find.text('Body'), findsOneWidget);
          expect(find.text('Footer'), findsOneWidget);
          expect(tracker.renderBox, isNotNull);
        });
  });
}