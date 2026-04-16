import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: SizedBox(width: 320, child: child)),
      ),
    );
  }

  group('FluxNotch', () {
    group('ticket constructor', () {
      test('stores boundary and targeted state', () {
        const notch = FluxNotch.ticket(boundary: FluxSlotBoundary.afterHeader);

        expect(notch.kind, FluxNotchKind.ticket);
        expect(notch.boundary, FluxSlotBoundary.afterHeader);
        expect(notch.isTargeted, isTrue);
      });

      test('stores defaults correctly', () {
        const notch = FluxNotch.ticket(boundary: FluxSlotBoundary.afterHeader);

        expect(notch.fallbackPosition, 0.5);
        expect(notch.boundaryOffset, 0.0);
        expect(notch.boundaryAlignment, Alignment.center);
        expect(notch.notchDepth, 12.0);
        expect(notch.notchWidth, isNull);
        expect(notch.edge, FluxNotchEdge.vertical);
        expect(notch.notchSide, FluxNotchSide.both);
        expect(notch.borderRadius, isNull);
        expect(notch.effectiveNotchWidth, 24.0);
      });

      test('stores custom values correctly', () {
        const radius = BorderRadius.all(Radius.circular(18));

        const notch = FluxNotch.ticket(
          boundary: FluxSlotBoundary.afterBody,
          fallbackPosition: 0.3,
          boundaryOffset: 6,
          boundaryAlignment: Alignment.bottomCenter,
          notchDepth: 16,
          edge: FluxNotchEdge.horizontal,
          notchSide: FluxNotchSide.end,
          borderRadius: radius,
        );

        expect(notch.kind, FluxNotchKind.ticket);
        expect(notch.boundary, FluxSlotBoundary.afterBody);
        expect(notch.fallbackPosition, 0.3);
        expect(notch.boundaryOffset, 6);
        expect(notch.boundaryAlignment, Alignment.bottomCenter);
        expect(notch.notchDepth, 16);
        expect(notch.edge, FluxNotchEdge.horizontal);
        expect(notch.notchSide, FluxNotchSide.end);
        expect(notch.borderRadius, radius);
        expect(notch.effectiveNotchWidth, 32.0);
      });
    });

    group('ticket free constructor', () {
      test('stores free-position values correctly', () {
        const notch = FluxNotch.ticketFree(
          position: 0.72,
          notchDepth: 14,
          edge: FluxNotchEdge.horizontal,
          notchSide: FluxNotchSide.start,
        );

        expect(notch.kind, FluxNotchKind.ticket);
        expect(notch.boundary, isNull);
        expect(notch.isTargeted, isFalse);
        expect(notch.fallbackPosition, 0.72);
        expect(notch.notchDepth, 14);
        expect(notch.edge, FluxNotchEdge.horizontal);
        expect(notch.notchSide, FluxNotchSide.start);
        expect(notch.effectiveNotchWidth, 28.0);
      });
    });

    group('vShape constructor', () {
      test('stores targeted values correctly', () {
        const radius = BorderRadius.all(Radius.circular(20));

        const notch = FluxNotch.vShape(
          boundary: FluxSlotBoundary.afterHeader,
          fallbackPosition: 0.4,
          boundaryOffset: 4,
          boundaryAlignment: Alignment.topCenter,
          notchDepth: 10,
          notchWidth: 30,
          edge: FluxNotchEdge.vertical,
          notchSide: FluxNotchSide.both,
          borderRadius: radius,
        );

        expect(notch.kind, FluxNotchKind.vShape);
        expect(notch.boundary, FluxSlotBoundary.afterHeader);
        expect(notch.isTargeted, isTrue);
        expect(notch.fallbackPosition, 0.4);
        expect(notch.boundaryOffset, 4);
        expect(notch.boundaryAlignment, Alignment.topCenter);
        expect(notch.notchDepth, 10);
        expect(notch.notchWidth, 30);
        expect(notch.edge, FluxNotchEdge.vertical);
        expect(notch.notchSide, FluxNotchSide.both);
        expect(notch.borderRadius, radius);
        expect(notch.effectiveNotchWidth, 30);
      });

      test('derives default width when notchWidth is omitted', () {
        const notch = FluxNotch.vShape(boundary: FluxSlotBoundary.afterHeader, notchDepth: 12);

        expect(notch.notchWidth, isNull);
        expect(notch.effectiveNotchWidth, 27.0);
      });
    });

    group('vShape free constructor', () {
      test('stores free-position values correctly', () {
        const notch = FluxNotch.vShapeFree(
          position: 0.65,
          notchDepth: 11,
          notchWidth: 26,
          edge: FluxNotchEdge.horizontal,
          notchSide: FluxNotchSide.end,
        );

        expect(notch.kind, FluxNotchKind.vShape);
        expect(notch.boundary, isNull);
        expect(notch.isTargeted, isFalse);
        expect(notch.fallbackPosition, 0.65);
        expect(notch.notchDepth, 11);
        expect(notch.notchWidth, 26);
        expect(notch.edge, FluxNotchEdge.horizontal);
        expect(notch.notchSide, FluxNotchSide.end);
        expect(notch.effectiveNotchWidth, 26);
      });
    });

    group('slant constructor', () {
      test('stores targeted values correctly', () {
        const notch = FluxNotch.slant(
          boundary: FluxSlotBoundary.afterBody,
          fallbackPosition: 0.55,
          boundaryOffset: -2,
          boundaryAlignment: Alignment.centerRight,
          notchDepth: 15,
          notchWidth: 34,
          edge: FluxNotchEdge.vertical,
          notchSide: FluxNotchSide.start,
        );

        expect(notch.kind, FluxNotchKind.slant);
        expect(notch.boundary, FluxSlotBoundary.afterBody);
        expect(notch.isTargeted, isTrue);
        expect(notch.fallbackPosition, 0.55);
        expect(notch.boundaryOffset, -2);
        expect(notch.boundaryAlignment, Alignment.centerRight);
        expect(notch.notchDepth, 15);
        expect(notch.notchWidth, 34);
        expect(notch.edge, FluxNotchEdge.vertical);
        expect(notch.notchSide, FluxNotchSide.start);
        expect(notch.effectiveNotchWidth, 34);
      });

      test('derives default width when notchWidth is omitted', () {
        const notch = FluxNotch.slant(boundary: FluxSlotBoundary.afterHeader, notchDepth: 8);

        expect(notch.notchWidth, isNull);
        expect(notch.effectiveNotchWidth, 18.0);
      });
    });

    group('slant free constructor', () {
      test('stores free-position values correctly', () {
        const notch = FluxNotch.slantFree(
          position: 0.2,
          notchDepth: 13,
          notchWidth: 29,
          edge: FluxNotchEdge.horizontal,
          notchSide: FluxNotchSide.both,
        );

        expect(notch.kind, FluxNotchKind.slant);
        expect(notch.boundary, isNull);
        expect(notch.isTargeted, isFalse);
        expect(notch.fallbackPosition, 0.2);
        expect(notch.notchDepth, 13);
        expect(notch.notchWidth, 29);
        expect(notch.edge, FluxNotchEdge.horizontal);
        expect(notch.notchSide, FluxNotchSide.both);
        expect(notch.effectiveNotchWidth, 29);
      });
    });

    group('FluxCard integration', () {
      testWidgets('renders a ticket notch card', (tester) async {
        await tester.pumpWidget(
          wrap(
            FluxCard(
              notch: const FluxNotch.ticket(boundary: FluxSlotBoundary.afterHeader, notchDepth: 14),
              divider: const FluxDivider(afterHeader: Divider(height: 1)),
              theme: FluxCardThemeData.outlined.copyWith(
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              header: const Text('Ticket Header'),
              body: const Text('Ticket Body'),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(FluxCard), findsOneWidget);
        expect(find.text('Ticket Header'), findsOneWidget);
        expect(find.text('Ticket Body'), findsOneWidget);
      });

      testWidgets('renders a free ticket notch card', (tester) async {
        await tester.pumpWidget(
          wrap(
            FluxCard(
              notch: const FluxNotch.ticketFree(position: 0.5, notchDepth: 12),
              theme: FluxCardThemeData.outlined.copyWith(
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              header: const Text('Free Ticket'),
              body: const Text('Body'),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.text('Free Ticket'), findsOneWidget);
        expect(find.text('Body'), findsOneWidget);
      });

      testWidgets('renders a vShape notch card', (tester) async {
        await tester.pumpWidget(
          wrap(
            FluxCard(
              notch: const FluxNotch.vShape(
                boundary: FluxSlotBoundary.afterHeader,
                notchDepth: 12,
                notchWidth: 28,
              ),
              divider: const FluxDivider(afterHeader: Divider(height: 1)),
              theme: FluxCardThemeData.outlined.copyWith(
                borderSide: const BorderSide(color: Colors.blueGrey, width: 1),
              ),
              header: const Text('Voucher'),
              body: const Text('20% OFF'),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.text('Voucher'), findsOneWidget);
        expect(find.text('20% OFF'), findsOneWidget);
      });

      testWidgets('renders a free vShape notch card', (tester) async {
        await tester.pumpWidget(
          wrap(
            FluxCard(
              notch: const FluxNotch.vShapeFree(
                position: 0.62,
                notchDepth: 10,
                notchWidth: 24,
                edge: FluxNotchEdge.horizontal,
                notchSide: FluxNotchSide.end,
              ),
              theme: FluxCardThemeData.outlined.copyWith(
                borderSide: const BorderSide(color: Colors.blueGrey, width: 1),
              ),
              header: const Text('Horizontal V'),
              body: const Text('Body'),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.text('Horizontal V'), findsOneWidget);
        expect(find.text('Body'), findsOneWidget);
      });

      testWidgets('renders a slant notch card', (tester) async {
        await tester.pumpWidget(
          wrap(
            FluxCard(
              notch: const FluxNotch.slant(
                boundary: FluxSlotBoundary.afterHeader,
                notchDepth: 14,
                notchWidth: 30,
              ),
              divider: const FluxDivider(afterHeader: Divider(height: 1)),
              theme: FluxCardThemeData.outlined.copyWith(
                borderSide: const BorderSide(color: Colors.deepPurple, width: 1),
              ),
              header: const Text('Boarding Pass'),
              body: const Text('Gate 14'),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.text('Boarding Pass'), findsOneWidget);
        expect(find.text('Gate 14'), findsOneWidget);
      });

      testWidgets('renders a free slant notch card', (tester) async {
        await tester.pumpWidget(
          wrap(
            FluxCard(
              notch: const FluxNotch.slantFree(
                position: 0.35,
                notchDepth: 12,
                notchWidth: 26,
                notchSide: FluxNotchSide.end,
              ),
              theme: FluxCardThemeData.outlined.copyWith(
                borderSide: const BorderSide(color: Colors.deepPurple, width: 1),
              ),
              header: const Text('Slant Free'),
              body: const Text('Body'),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.text('Slant Free'), findsOneWidget);
        expect(find.text('Body'), findsOneWidget);
      });

      testWidgets('theme borderSide still drives outline for all notch kinds', (tester) async {
        final cards = [
          FluxCard(
            notch: const FluxNotch.ticketFree(),
            theme: FluxCardThemeData.outlined.copyWith(
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            header: const Text('Ticket'),
          ),
          FluxCard(
            notch: const FluxNotch.vShapeFree(),
            theme: FluxCardThemeData.outlined.copyWith(
              borderSide: const BorderSide(color: Colors.green, width: 1),
            ),
            header: const Text('V'),
          ),
          FluxCard(
            notch: const FluxNotch.slantFree(),
            theme: FluxCardThemeData.outlined.copyWith(
              borderSide: const BorderSide(color: Colors.blue, width: 1),
            ),
            header: const Text('Slant'),
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: Column(children: cards)),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.text('Ticket'), findsOneWidget);
        expect(find.text('V'), findsOneWidget);
        expect(find.text('Slant'), findsOneWidget);
      });

      testWidgets('FluxNotchShape can still be used directly with vShape and slant', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: const [
                  SizedBox(
                    width: 320,
                    child: FluxCard(
                      theme: FluxCardThemeData(
                        shape: FluxNotchShape(
                          kind: FluxNotchKind.vShape,
                          notchDepth: 12,
                          notchWidth: 28,
                          notchPosition: 0.5,
                          side: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      header: Text('Shape V'),
                    ),
                  ),

                  SizedBox(
                    width: 320,
                    child: FluxCard(
                      theme: FluxCardThemeData(
                        shape: FluxNotchShape(
                          kind: FluxNotchKind.slant,
                          notchDepth: 12,
                          notchWidth: 28,
                          notchPosition: 0.5,
                          side: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      header: Text('Shape Slant'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.text('Shape V'), findsOneWidget);
        expect(find.text('Shape Slant'), findsOneWidget);
      });
    });
  });
}
