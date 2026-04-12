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
              width: cardWidth,
              child: FluxCard(
                fullWidth: true,
                // background: Container(key: const Key('bg')),
              ),
            ),
          ),
        ),
      ),
    );

    final Size size = tester.getSize(find.byKey(const Key('bg')));
    expect(size.width, cardWidth);
  });

  testWidgets('FluxCard respects media position in row layout', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FluxCard(
            layout: FluxLayoutMode.row,
            mediaPosition: FluxMediaPosition.end,
            media: SizedBox(width: 80, height: 80, child: ColoredBox(color: Colors.blue)),
            header: Text('Header'),
            body: Text('Body'),
          ),
        ),
      ),
    );

    expect(find.text('Header'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);
  });
}
