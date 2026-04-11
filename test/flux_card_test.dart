import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

void main() {
  testWidgets('FluxCard renders header and content', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FluxCard(
            header: FluxHeader(title: Text('Test Title')),
            content: Text('Test Content'),
          ),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Content'), findsOneWidget);

    // Instead of counting columns, check that they are descendant of FluxCard
    expect(
        find.descendant(of: find.byType(FluxCard), matching: find.byType(Column)),
        findsAtLeastNWidgets(1)
    );
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
                background: Container(key: const Key('bg')),
              ),
            ),
          ),
        ),
      ),
    );

    // Get the actual rendered size of the background container
    final Size size = tester.getSize(find.byKey(const Key('bg')));
    expect(size.width, cardWidth);
  });
}