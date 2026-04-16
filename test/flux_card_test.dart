import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

void main() {
  group('FluxCard', () {
    group('rendering', () {
      testWidgets('renders media, header and content', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FluxCard(
                media: const SizedBox(
                  width: 200,
                  height: 120,
                  child: ColoredBox(color: Colors.red),
                ),
                header: const Text('Test Title'),
                body: const Text('Test Content'),
              ),
            ),
          ),
        );

        expect(find.text('Test Title'), findsOneWidget);
        expect(find.text('Test Content'), findsOneWidget);
        expect(find.byType(FluxCard), findsOneWidget);
      });
    });

    group('constraints', () {
      testWidgets('respects fullWidth constraint', (tester) async {
        const double cardWidth = 300;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  key: const Key('host'),
                  width: cardWidth,
                  child: const FluxCard(fullWidth: true, header: Text('Header')),
                ),
              ),
            ),
          ),
        );

        final hostRect = tester.getRect(find.byKey(const Key('host')));
        final cardRect = tester.getRect(
          find.descendant(of: find.byType(FluxCard), matching: find.byType(Material)).first,
        );

        expect(cardRect.width, hostRect.width);
      });
    });

    group('row layout', () {
      testWidgets('respects media position in row layout', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 400,
                  child: FluxCard(
                    layout: FluxLayoutMode.row,
                    mediaPosition: FluxMediaPosition.end,
                    media: const SizedBox(
                      key: Key('media'),
                      width: 80,
                      height: 80,
                      child: ColoredBox(color: Colors.blue),
                    ),
                    header: const Text('Header'),
                    body: const Text('Body'),
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.text('Header'), findsOneWidget);
        expect(find.text('Body'), findsOneWidget);
        expect(find.byKey(const Key('media')), findsOneWidget);

        final mediaX = tester.getTopLeft(find.byKey(const Key('media'))).dx;
        final headerX = tester.getTopLeft(find.text('Header')).dx;
        final bodyX = tester.getTopLeft(find.text('Body')).dx;

        expect(mediaX, greaterThan(headerX));
        expect(mediaX, greaterThan(bodyX));
      });
    });

    group('responsive layout', () {
      testWidgets('uses row layout when width is bounded and above the breakpoint', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 700,
                  child: FluxCard(
                    layout: FluxLayoutMode.responsive,
                    theme: FluxCardThemeData.elevated.copyWith(responsiveBreakpoint: 500),
                    media: const FluxMedia(
                      width: 80,
                      height: 80,
                      child: ColoredBox(key: Key('media_row'), color: Colors.blue),
                    ),
                    header: const Text('Header'),
                    body: const Text('Body'),
                  ),
                ),
              ),
            ),
          ),
        );

        final mediaPos = tester.getTopLeft(find.byKey(const Key('media_row')));
        final headerPos = tester.getTopLeft(find.text('Header'));

        expect(headerPos.dx, greaterThan(mediaPos.dx));
      });

      testWidgets('uses column layout when width is bounded and below the breakpoint', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 320,
                  child: FluxCard(
                    layout: FluxLayoutMode.responsive,
                    theme: FluxCardThemeData.elevated.copyWith(responsiveBreakpoint: 500),
                    media: const FluxMedia(
                      width: 80,
                      height: 80,
                      child: ColoredBox(key: Key('media_column'), color: Colors.blue),
                    ),
                    header: const Text('Header'),
                    body: const Text('Body'),
                  ),
                ),
              ),
            ),
          ),
        );

        final mediaPos = tester.getTopLeft(find.byKey(const Key('media_column')));
        final headerPos = tester.getTopLeft(find.text('Header'));

        expect(headerPos.dy, greaterThan(mediaPos.dy));
      });

      testWidgets('uses explicit card width for responsive layout in an unbounded parent', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: FluxCard(
                    width: 700,
                    layout: FluxLayoutMode.responsive,
                    theme: FluxCardThemeData.elevated.copyWith(responsiveBreakpoint: 500),
                    media: const FluxMedia(
                      width: 80,
                      height: 80,
                      child: ColoredBox(key: Key('media_explicit'), color: Colors.blue),
                    ),
                    header: const Text('Header'),
                    body: const Text('Body'),
                  ),
                ),
              ),
            ),
          ),
        );

        final mediaPos = tester.getTopLeft(find.byKey(const Key('media_explicit')));
        final headerPos = tester.getTopLeft(find.text('Header'));

        expect(headerPos.dx, greaterThan(mediaPos.dx));
      });
    });

    testWidgets('falls back to column layout when responsive width is unbounded', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: FluxCard(
                  layout: FluxLayoutMode.responsive,
                  theme: FluxCardThemeData.elevated.copyWith(responsiveBreakpoint: 500),
                  media: const FluxMedia(
                    width: 80,
                    height: 80,
                    child: ColoredBox(key: Key('media_unbounded'), color: Colors.blue),
                  ),
                  header: const Text('Header'),
                  body: const Text('Body'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(tester.takeException(), isNull);

      final mediaPos = tester.getTopLeft(find.byKey(const Key('media_unbounded')));
      final headerPos = tester.getTopLeft(find.text('Header'));

      expect(headerPos.dy, greaterThan(mediaPos.dy));
    });
  });
}
