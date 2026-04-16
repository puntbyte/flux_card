import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/src/layout/match_height_row.dart';

void main() {
  // Wrap aligns the layout to the top-left (0,0) so we can easily test
  // coordinates mathematically without centering offsets getting in the way.
  Widget wrap(Widget child) => MaterialApp(
    home: Scaffold(
      body: Align(alignment: Alignment.topLeft, child: child),
    ),
  );

  group('FluxMatchHeightRow', () {
    // -------------------------------------------------------------------------
    // Sizing and Height Matching
    // -------------------------------------------------------------------------
    testWidgets('forces shorter child to match the height of the taller child', (tester) async {
      const mediaKey = Key('media');
      const contentKey = Key('content');

      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 400,
            child: FluxMatchHeightRow(
              flexMedia: 1,
              flexContent: 1,
              mediaStart: true,
              // Media wants to be 150px tall
              media: SizedBox(
                key: mediaKey,
                height: 150,
                child: ColoredBox(color: Colors.red),
              ),
              // Content only wants to be 50px tall
              content: SizedBox(
                key: contentKey,
                height: 50,
                child: ColoredBox(color: Colors.blue),
              ),
            ),
          ),
        ),
      );

      final mediaSize = tester.getSize(find.byKey(mediaKey));
      final contentSize = tester.getSize(find.byKey(contentKey));

      // Both must be exactly 150px tall due to the second pass tight constraints
      expect(mediaSize.height, 150.0);
      expect(contentSize.height, 150.0);

      // Flex 1:1 on a 400px parent = 200px each
      expect(mediaSize.width, 200.0);
      expect(contentSize.width, 200.0);
    });

    testWidgets('distributes width correctly according to flex ratios', (tester) async {
      const mediaKey = Key('media');
      const contentKey = Key('content');

      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 500,
            child: FluxMatchHeightRow(
              flexMedia: 2,
              // 2/5 of 500 = 200
              flexContent: 3,
              // 3/5 of 500 = 300
              mediaStart: true,
              media: SizedBox(key: mediaKey, height: 100),
              content: SizedBox(key: contentKey, height: 100),
            ),
          ),
        ),
      );

      final mediaSize = tester.getSize(find.byKey(mediaKey));
      final contentSize = tester.getSize(find.byKey(contentKey));

      expect(mediaSize.width, 200.0);
      expect(contentSize.width, 300.0);
    });

    // -------------------------------------------------------------------------
    // Ordering (mediaStart)
    // -------------------------------------------------------------------------
    testWidgets('mediaStart=true places media at x=0', (tester) async {
      const mediaKey = Key('media');
      const contentKey = Key('content');

      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 400,
            child: FluxMatchHeightRow(
              flexMedia: 1,
              flexContent: 3,
              mediaStart: true,
              media: SizedBox(key: mediaKey, height: 100),
              content: SizedBox(key: contentKey, height: 100),
            ),
          ),
        ),
      );

      final mediaPos = tester.getTopLeft(find.byKey(mediaKey));
      final contentPos = tester.getTopLeft(find.byKey(contentKey));

      expect(mediaPos.dx, 0.0);
      expect(contentPos.dx, 100.0); // Placed after the media (1/4 of 400 = 100)
    });

    testWidgets('mediaStart=false places content at x=0', (tester) async {
      const mediaKey = Key('media');
      const contentKey = Key('content');

      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 400,
            child: FluxMatchHeightRow(
              flexMedia: 1,
              flexContent: 3,
              mediaStart: false,
              media: SizedBox(key: mediaKey, height: 100),
              content: SizedBox(key: contentKey, height: 100),
            ),
          ),
        ),
      );

      final mediaPos = tester.getTopLeft(find.byKey(mediaKey));
      final contentPos = tester.getTopLeft(find.byKey(contentKey));

      expect(contentPos.dx, 0.0);
      expect(mediaPos.dx, 300.0); // Placed after the content (3/4 of 400 = 300)
    });

    // -------------------------------------------------------------------------
    // Unbounded Constraints (e.g. SingleChildScrollView)
    // -------------------------------------------------------------------------
    testWidgets('falls back to intrinsic width when parent width is unbounded', (tester) async {
      const mediaKey = Key('media');
      const contentKey = Key('content');

      await tester.pumpWidget(
        wrap(
          // UnconstrainedBox simulates an unbounded horizontal scroll view
          UnconstrainedBox(
            child: FluxMatchHeightRow(
              flexMedia: 1,
              flexContent: 1,
              mediaStart: true,
              // Children must provide their own natural widths here
              media: const SizedBox(key: mediaKey, width: 120, height: 100),
              content: const SizedBox(key: contentKey, width: 80, height: 50),
            ),
          ),
        ),
      );

      final mediaSize = tester.getSize(find.byKey(mediaKey));
      final contentSize = tester.getSize(find.byKey(contentKey));

      // Instead of failing with infinity, it reads the intrinsic widths!
      // However, because of the flex ratios (1:1), our layout algorithm calculates
      // the total available (120+80 = 200) and then splits it evenly according to flex!
      expect(mediaSize.width, 100.0);
      expect(contentSize.width, 100.0);

      // Heights should still perfectly match the tallest (100)
      expect(mediaSize.height, 100.0);
      expect(contentSize.height, 100.0);
    });

    // -------------------------------------------------------------------------
    // Missing Children
    // -------------------------------------------------------------------------
    testWidgets('renders safely with only one child', (tester) async {
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 400,
            child: FluxMatchHeightRow(
              flexMedia: 1,
              flexContent: 1,
              mediaStart: true,
              media: SizedBox(height: 100),
              // Missing content
              content: SizedBox.shrink(),
            ),
          ),
        ),
      );

      // Should not throw an assertion and should layout properly
      final rowSize = tester.getSize(find.byType(FluxMatchHeightRow));
      expect(rowSize.height, 100.0);
    });

    // -------------------------------------------------------------------------
    // Hit Testing
    // -------------------------------------------------------------------------
    testWidgets('correctly routes hit tests to its children', (tester) async {
      bool mediaTapped = false;
      bool contentTapped = false;

      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 400,
            child: FluxMatchHeightRow(
              flexMedia: 1,
              flexContent: 1,
              mediaStart: true,
              media: GestureDetector(
                onTap: () => mediaTapped = true,
                child: const SizedBox(height: 100, child: ColoredBox(color: Colors.red)),
              ),
              content: GestureDetector(
                onTap: () => contentTapped = true,
                child: const SizedBox(height: 100, child: ColoredBox(color: Colors.blue)),
              ),
            ),
          ),
        ),
      );

      // Tap on the media (left side, flex 1 -> 0 to 200px)
      await tester.tapAt(const Offset(100, 50));
      expect(mediaTapped, isTrue);
      expect(contentTapped, isFalse);

      mediaTapped = false;

      // Tap on the content (right side, flex 1 -> 200 to 400px)
      await tester.tapAt(const Offset(300, 50));
      expect(mediaTapped, isFalse);
      expect(contentTapped, isTrue);
    });
  });
}
