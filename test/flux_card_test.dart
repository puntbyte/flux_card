import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

void main() {
  testWidgets('FluxCard renders media, header and content', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FluxCard(
            media: const SizedBox(width: 200, height: 120, child: ColoredBox(color: Colors.red)),
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

  testWidgets('FluxCard respects fullWidth constraint', (tester) async {
    const double cardWidth = 300;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              key: const Key('host'),
              width: cardWidth,
              child: const FluxCard(
                fullWidth: true,
                header: Text('Header'),
              ),
            ),
          ),
        ),
      ),
    );

    final hostRect = tester.getRect(find.byKey(const Key('host')));
    final cardRect = tester.getRect(
      find.descendant(
        of: find.byType(FluxCard),
        matching: find.byType(Material),
      ).first,
    );

    expect(cardRect.width, hostRect.width);
  });

  testWidgets('FluxCard respects media position in row layout', (tester) async {
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
}