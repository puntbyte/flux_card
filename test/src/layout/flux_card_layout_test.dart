import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/src/core/enums.dart';
import 'package:flux_card/src/core/theme.dart';
import 'package:flux_card/src/layout/flux_card_layout.dart';
import 'package:flux_card/src/layout/match_height_row.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Align(alignment: Alignment.topLeft, child: child),
      ),
    );
  }

  Widget wrapWide(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: 400, child: child),
        ),
      ),
    );
  }

  const theme = FluxCardThemeData(
    spacing: 10,
    padding: EdgeInsets.zero,
    flexMedia: 1,
    flexContent: 1,
  );

  group('FluxCardLayout', () {
    testWidgets('builds a column layout when mode is column', (tester) async {
      const layout = FluxCardLayout(
        mode: FluxLayoutMode.column,
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
                media: const SizedBox(height: 40, child: Text('Media')),
                header: const Text('Header'),
                body: const Text('Body'),
                footer: const Text('Footer'),
                underlaysByTarget: const {},
                ovsByTarget: const {},
                multiUnderlays: const [],
                multiOvs: const [],
              );
            },
          ),
        ),
      );

      final mediaY = tester.getTopLeft(find.text('Media')).dy;
      final headerY = tester.getTopLeft(find.text('Header')).dy;
      final bodyY = tester.getTopLeft(find.text('Body')).dy;
      final footerY = tester.getTopLeft(find.text('Footer')).dy;

      expect(mediaY, lessThan(headerY));
      expect(headerY, lessThan(bodyY));
      expect(bodyY, lessThan(footerY));
    });

    testWidgets('builds a row layout when mode is row', (tester) async {
      const layout = FluxCardLayout(
        mode: FluxLayoutMode.row,
        mediaPosition: FluxMediaPosition.end,
        mediaSpan: FluxMediaSpan.all,
        theme: theme,
        resolvedPadding: EdgeInsets.zero,
      );

      await tester.pumpWidget(
        wrapWide(
          Builder(
            builder: (context) {
              return layout.build(
                context,
                media: const SizedBox(width: 100, height: 80, child: Text('Media')),
                header: const Text('Header'),
                body: const Text('Body'),
                footer: const Text('Footer'),
                underlaysByTarget: const {},
                ovsByTarget: const {},
                multiUnderlays: const [],
                multiOvs: const [],
              );
            },
          ),
        ),
      );

      expect(find.byType(FluxMatchHeightRow), findsOneWidget);

      final headerX = tester.getTopLeft(find.text('Header')).dx;
      final bodyX = tester.getTopLeft(find.text('Body')).dx;
      final mediaX = tester.getTopLeft(find.text('Media')).dx;

      expect(headerX, lessThan(mediaX));
      expect(bodyX, lessThan(mediaX));
    });

    testWidgets('builds an inline layout when mode is inline', (tester) async {
      const layout = FluxCardLayout(
        mode: FluxLayoutMode.inline,
        mediaPosition: FluxMediaPosition.end,
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
                media: const SizedBox(height: 40, child: Text('Media')),
                header: const Text('Header'),
                body: const Text('Body'),
                footer: const Text('Footer'),
                underlaysByTarget: const {},
                ovsByTarget: const {},
                multiUnderlays: const [],
                multiOvs: const [],
              );
            },
          ),
        ),
      );

      final headerY = tester.getTopLeft(find.text('Header')).dy;
      final bodyY = tester.getTopLeft(find.text('Body')).dy;
      final mediaY = tester.getTopLeft(find.text('Media')).dy;
      final footerY = tester.getTopLeft(find.text('Footer')).dy;

      expect(headerY, lessThan(mediaY));
      expect(bodyY, lessThan(mediaY));
      expect(mediaY, lessThan(footerY));
    });
  });
}
