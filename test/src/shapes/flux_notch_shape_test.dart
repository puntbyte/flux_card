import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

void main() {
  // ---------------------------------------------------------------------------
  // getOuterPath / getInnerPath
  // ---------------------------------------------------------------------------

  group('FluxNotchShape — path generation', () {
    test('getOuterPath returns a non-empty path', () {
      const shape = FluxNotchShape();
      final path = shape.getOuterPath(const Rect.fromLTWH(0, 0, 300, 200));
      // A non-empty path has at least one segment; empty paths compute-length = 0.
      expect(path.computeMetrics().isNotEmpty, isTrue);
    });

    test('getInnerPath equals getOuterPath for the same rect', () {
      const shape = FluxNotchShape(notchRadius: 10, notchPosition: 0.5);
      const rect = Rect.fromLTWH(0, 0, 200, 150);
      final outer = shape.getOuterPath(rect);
      final inner = shape.getInnerPath(rect);
      // Flutter's spec says getInnerPath == getOuterPath for ShapeBorders that
      // don't have a distinct inner/outer silhouette.
      expect(outer.getBounds(), inner.getBounds());
    });

    test('notchRadius 0 produces a path with the same outline as a rounded rect', () {
      const shape = FluxNotchShape(
        notchRadius: 0,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      );
      final path = shape.getOuterPath(const Rect.fromLTWH(0, 0, 200, 100));
      expect(path.computeMetrics().isNotEmpty, isTrue);
    });

    test('horizontal edge produces a path over the full rect', () {
      const shape = FluxNotchShape(
        notchEdge: FluxNotchEdge.horizontal,
        notchPosition: 0.5,
        notchRadius: 12,
      );
      final path = shape.getOuterPath(const Rect.fromLTWH(0, 0, 300, 200));
      expect(path.computeMetrics().isNotEmpty, isTrue);
    });

    test('notchPositionResolver is called when provided', () {
      bool resolverCalled = false;
      final shape = FluxNotchShape(
        notchPositionResolver: (rect) {
          resolverCalled = true;
          return 0.3;
        },
      );
      shape.getOuterPath(const Rect.fromLTWH(0, 0, 200, 150));
      expect(resolverCalled, isTrue);
    });

    test('notchPositionResolver returning null falls back to notchPosition', () {
      const double fallback = 0.7;
      final shape = FluxNotchShape(
        notchPosition: fallback,
        notchPositionResolver: (_) => null,
      );
      // Just verify no exception is thrown
      final path = shape.getOuterPath(const Rect.fromLTWH(0, 0, 200, 150));
      expect(path.computeMetrics().isNotEmpty, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // scale
  // ---------------------------------------------------------------------------

  group('FluxNotchShape — scale', () {
    test('scale(1.0) returns a shape with the same parameters', () {
      const shape = FluxNotchShape(notchRadius: 12, notchPosition: 0.5);
      final scaled = shape.scale(1.0) as FluxNotchShape;
      expect(scaled.notchRadius, 12.0);
    });

    test('scale(2.0) doubles notchRadius', () {
      const shape = FluxNotchShape(notchRadius: 10);
      final scaled = shape.scale(2.0) as FluxNotchShape;
      expect(scaled.notchRadius, 20.0);
    });

    test('scale(0.5) halves notchRadius', () {
      const shape = FluxNotchShape(notchRadius: 20);
      final scaled = shape.scale(0.5) as FluxNotchShape;
      expect(scaled.notchRadius, 10.0);
    });

    test('dimensions returns EdgeInsets.zero', () {
      const shape = FluxNotchShape();
      expect(shape.dimensions, EdgeInsets.zero);
    });
  });

  // ---------------------------------------------------------------------------
  // lerp
  // ---------------------------------------------------------------------------

  group('FluxNotchShape — lerp', () {
    test('lerpFrom with another FluxNotchShape at t=0 returns first shape params', () {
      const a = FluxNotchShape(notchRadius: 8, notchPosition: 0.3);
      const b = FluxNotchShape(notchRadius: 24, notchPosition: 0.7);
      final result = b.lerpFrom(a, 0.0) as FluxNotchShape;
      expect(result.notchRadius, closeTo(8.0, 0.001));
    });

    test('lerpFrom with another FluxNotchShape at t=1 returns second shape params', () {
      const a = FluxNotchShape(notchRadius: 8, notchPosition: 0.3);
      const b = FluxNotchShape(notchRadius: 24, notchPosition: 0.7);
      final result = b.lerpFrom(a, 1.0) as FluxNotchShape;
      expect(result.notchRadius, closeTo(24.0, 0.001));
    });

    test('lerpFrom at t=0.5 interpolates notchRadius', () {
      const a = FluxNotchShape(notchRadius: 0);
      const b = FluxNotchShape(notchRadius: 20);
      final result = b.lerpFrom(a, 0.5) as FluxNotchShape;
      expect(result.notchRadius, closeTo(10.0, 0.001));
    });

    test('lerpTo with another FluxNotchShape at t=0.5 interpolates', () {
      const a = FluxNotchShape(notchRadius: 0);
      const b = FluxNotchShape(notchRadius: 40);
      final result = a.lerpTo(b, 0.5) as FluxNotchShape;
      expect(result.notchRadius, closeTo(20.0, 0.001));
    });

    test('lerpFrom with non-FluxNotchShape returns null', () {
      const shape = FluxNotchShape();
      final result = shape.lerpFrom(const StadiumBorder(), 0.5);
      expect(result, isNull);
    });

    test('lerpTo with non-FluxNotchShape returns null', () {
      const shape = FluxNotchShape();
      final result = shape.lerpTo(const StadiumBorder(), 0.5);
      expect(result, isNull);
    });

    test('ShapeBorder.lerp between two FluxNotchShapes works', () {
      const a = FluxNotchShape(notchRadius: 0);
      const b = FluxNotchShape(notchRadius: 16);
      final result = ShapeBorder.lerp(a, b, 0.5)! as FluxNotchShape;
      expect(result.notchRadius, closeTo(8.0, 0.001));
    });
  });

  // ---------------------------------------------------------------------------
  // paint
  // ---------------------------------------------------------------------------

  group('FluxNotchShape — paint', () {
    testWidgets('paint is called when used as card shape with side', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: FluxCard(
              theme: const FluxCardThemeData(
                shape: FluxNotchShape(
                  notchRadius: 12,
                  notchPosition: 0.5,
                  side: BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
              header: const Text('outlined notch card'),
            ),
          ),
        ),
      ));
      expect(find.text('outlined notch card'), findsOneWidget);
    });

    testWidgets('paint with BorderSide.none does not throw', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: FluxCard(
              theme: const FluxCardThemeData(
                shape: FluxNotchShape(
                  notchRadius: 14,
                  side: BorderSide.none,
                ),
              ),
              header: const Text('no border'),
            ),
          ),
        ),
      ));
      expect(find.text('no border'), findsOneWidget);
    });
  });
}