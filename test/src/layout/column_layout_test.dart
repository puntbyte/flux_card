import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/src/core/enums.dart';
import 'package:flux_card/src/core/theme.dart';
import 'package:flux_card/src/layout/column_layout.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));
  const theme = FluxCardThemeData(spacing: 10, padding: EdgeInsets.zero);

  group('FluxColumnLayout', () {
    testWidgets('mediaPosition.start places media at the top', (tester) async {
      const layout = FluxColumnLayout(
        mediaPosition: FluxMediaPosition.start,
        mediaSpan: FluxMediaSpan.all,
        isMediaExpanded: false,
        theme: theme,
        resolvedPadding: EdgeInsets.zero,
      );

      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              return layout.build(
                context,
                mediaSlot: const SizedBox(height: 50, child: Text('Media')),
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

      final mediaY = tester.getTopLeft(find.text('Media')).dy;
      final headerY = tester.getTopLeft(find.text('Header')).dy;

      expect(mediaY, lessThan(headerY));
    });

    testWidgets('mediaPosition.end places media at the bottom', (tester) async {
      const layout = FluxColumnLayout(
        mediaPosition: FluxMediaPosition.end,
        mediaSpan: FluxMediaSpan.all,
        isMediaExpanded: false,
        theme: theme,
        resolvedPadding: EdgeInsets.zero,
      );

      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              return layout.build(
                context,
                mediaSlot: const SizedBox(height: 50, child: Text('Media')),
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

      final headerY = tester.getTopLeft(find.text('Header')).dy;
      final bodyY = tester.getTopLeft(find.text('Body')).dy;
      final mediaY = tester.getTopLeft(find.text('Media')).dy;

      expect(headerY, lessThan(bodyY));
      expect(bodyY, lessThan(mediaY));
    });

    testWidgets('renders content without media', (tester) async {
      const layout = FluxColumnLayout(
        mediaPosition: FluxMediaPosition.start,
        mediaSpan: FluxMediaSpan.all,
        isMediaExpanded: false,
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
                header: const Text('Header Only'),
                underlaysByTarget: {},
                ovsByTarget: {},
                multiUnderlays: [],
                multiOvs: [],
              );
            },
          ),
        ),
      );

      expect(find.text('Header Only'), findsOneWidget);
    });
  });
}
