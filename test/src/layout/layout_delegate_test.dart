import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/src/core/enums.dart';
import 'package:flux_card/src/core/theme.dart';
import 'package:flux_card/src/layout/boundary_tracker.dart';
import 'package:flux_card/src/layout/layout_delegate.dart';

// Dummy implementation of the abstract delegate for testing shared methods
class _TestLayoutDelegate extends FluxLayoutDelegate {
  const _TestLayoutDelegate({
    required super.mediaPosition,
    required super.mediaSpan,
    required super.theme,
    required super.resolvedPadding,
    super.boundaryTrackers,
  });

  @override
  Widget build(
      BuildContext context, {
        Widget? mediaSlot,
        Widget? header,
        Widget? body,
        Widget? footer,
        required Map<FluxTarget, List<Widget>> underlaysByTarget,
        required Map<FluxTarget, List<Widget>> ovsByTarget,
        required List<Widget> multiUnderlays,
        required List<Widget> multiOvs,
      }) {
    return const SizedBox.shrink();
  }
}

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('FluxLayoutDelegate — Shared Helpers', () {
    const theme = FluxCardThemeData(spacing: 10, padding: EdgeInsets.zero);

    testWidgets('afterMediaMarker returns null when no tracker is mapped', (tester) async {
      const delegate = _TestLayoutDelegate(
        mediaPosition: FluxMediaPosition.start,
        mediaSpan: FluxMediaSpan.all,
        theme: theme,
        resolvedPadding: EdgeInsets.zero,
        boundaryTrackers: {}, // Empty
      );

      expect(delegate.afterMediaMarker(), isNull);
    });

    testWidgets('afterMediaMarker returns BoundaryMarker when mapped', (tester) async {
      final tracker = BoundaryTracker();
      final delegate = _TestLayoutDelegate(
        mediaPosition: FluxMediaPosition.start,
        mediaSpan: FluxMediaSpan.all,
        theme: theme,
        resolvedPadding: EdgeInsets.zero,
        boundaryTrackers: {FluxSlotBoundary.afterMedia: tracker},
      );

      final markerWidget = delegate.afterMediaMarker();
      expect(markerWidget, isNotNull);
      expect(markerWidget, isA<BoundaryMarker>());
    });

    testWidgets('buildFullContentColumn renders header, body, and footer', (tester) async {
      const delegate = _TestLayoutDelegate(
        mediaPosition: FluxMediaPosition.start,
        mediaSpan: FluxMediaSpan.all,
        theme: theme,
        resolvedPadding: EdgeInsets.zero,
      );

      await tester.pumpWidget(wrap(Builder(
        builder: (context) {
          return delegate.buildFullContentColumn(
            context,
            const Text('Header'),
            const Text('Body'),
            const Text('Footer'),
            {}, {}, [],[],
          ) ?? const SizedBox.shrink();
        },
      )));

      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(find.text('Footer'), findsOneWidget);

      // Verify order via Y coordinates
      final headerY = tester.getTopLeft(find.text('Header')).dy;
      final bodyY = tester.getTopLeft(find.text('Body')).dy;
      final footerY = tester.getTopLeft(find.text('Footer')).dy;

      expect(headerY, lessThan(bodyY));
      expect(bodyY, lessThan(footerY));
    });
  });
}