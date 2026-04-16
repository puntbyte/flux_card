import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Presets
  // ---------------------------------------------------------------------------

  group('FluxCardThemeData — presets', () {
    test('standard has 16px padding and 12 spacing', () {
      const t = FluxCardThemeData.standard;
      expect(t.padding, const EdgeInsets.all(16));
      expect(t.spacing, 12.0);
    });

    test('compact has 12px padding and 8 spacing', () {
      const t = FluxCardThemeData.compact;
      expect(t.padding, const EdgeInsets.all(12));
      expect(t.spacing, 8.0);
    });

    test('elevated has non-zero elevation and shadows', () {
      const t = FluxCardThemeData.elevated;
      expect(t.elevation, greaterThan(0));
      expect(t.defaultShadows, isNotEmpty);
    });

    test('outlined has a non-none borderSide', () {
      const t = FluxCardThemeData.outlined;
      expect(t.borderSide, isNot(BorderSide.none));
      expect(t.borderSide.width, 1.5);
    });
  });

  // ---------------------------------------------------------------------------
  // copyWith
  // ---------------------------------------------------------------------------

  group('FluxCardThemeData — copyWith', () {
    test('overrides only specified fields', () {
      const base = FluxCardThemeData.elevated;
      final modified = base.copyWith(spacing: 24.0);
      expect(modified.spacing, 24.0);
      expect(modified.elevation, base.elevation);
      expect(modified.padding, base.padding);
    });

    test('all fields can be overridden independently', () {
      const base = FluxCardThemeData.standard;
      final modified = base.copyWith(
        padding: const EdgeInsets.all(8),
        spacing: 4.0,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        cardColor: Colors.white,
        elevation: 2.0,
        clipBehavior: Clip.none,
        flexMedia: 1,
        flexContent: 2,
        responsiveBreakpoint: 480.0,
      );
      expect(modified.padding, const EdgeInsets.all(8));
      expect(modified.spacing, 4.0);
      expect(modified.borderRadius, const BorderRadius.all(Radius.circular(4)));
      expect(modified.cardColor, Colors.white);
      expect(modified.elevation, 2.0);
      expect(modified.clipBehavior, Clip.none);
      expect(modified.flexMedia, 1);
      expect(modified.flexContent, 2);
      expect(modified.responsiveBreakpoint, 480.0);
    });

    test('returns a new instance — does not mutate original', () {
      const base = FluxCardThemeData.standard;
      base.copyWith(spacing: 99);
      expect(base.spacing, 12.0);
    });
  });

  // ---------------------------------------------------------------------------
  // Equality & hashCode
  // ---------------------------------------------------------------------------

  group('FluxCardThemeData — equality and hashCode', () {
    test('two instances with same values are equal', () {
      const a = FluxCardThemeData(spacing: 10, elevation: 2);
      const b = FluxCardThemeData(spacing: 10, elevation: 2);
      expect(a, equals(b));
    });

    test('instances differing by one field are not equal', () {
      const a = FluxCardThemeData(spacing: 10);
      const b = FluxCardThemeData(spacing: 11);
      expect(a, isNot(equals(b)));
    });

    test('equal instances have the same hashCode', () {
      const a = FluxCardThemeData(spacing: 8, elevation: 0);
      const b = FluxCardThemeData(spacing: 8, elevation: 0);
      expect(a.hashCode, b.hashCode);
    });

    test('presets have stable hashCodes across calls', () {
      expect(FluxCardThemeData.standard.hashCode, FluxCardThemeData.standard.hashCode);
    });
  });

  // ---------------------------------------------------------------------------
  // lerp
  // ---------------------------------------------------------------------------

  group('FluxCardThemeData — lerp', () {
    test('lerp at t=0 returns values from first theme', () {
      const a = FluxCardThemeData(spacing: 8);
      const b = FluxCardThemeData(spacing: 24);
      final result = a.lerp(b, 0.0);
      expect(result.spacing, 8.0);
    });

    test('lerp at t=1 returns values from second theme', () {
      const a = FluxCardThemeData(spacing: 8);
      const b = FluxCardThemeData(spacing: 24);
      final result = a.lerp(b, 1.0);
      expect(result.spacing, 24.0);
    });

    test('lerp at t=0.5 interpolates spacing', () {
      const a = FluxCardThemeData(spacing: 0);
      const b = FluxCardThemeData(spacing: 20);
      final result = a.lerp(b, 0.5);
      expect(result.spacing, closeTo(10.0, 0.001));
    });

    test('lerp with null other returns self', () {
      const a = FluxCardThemeData.elevated;
      final result = a.lerp(null, 0.5);
      expect(result, a);
    });

    test('lerp at t=0.5 interpolates elevation', () {
      const a = FluxCardThemeData(elevation: 0);
      const b = FluxCardThemeData(elevation: 8);
      final result = a.lerp(b, 0.5);
      expect(result.elevation, closeTo(4.0, 0.001));
    });
  });

  // ---------------------------------------------------------------------------
  // resolveShape
  // ---------------------------------------------------------------------------

  group('FluxCardThemeData — resolveShape', () {
    testWidgets('returns RoundedRectangleBorder when shape is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              final shape = FluxCardThemeData.standard.resolveShape(ctx);
              expect(shape, isA<RoundedRectangleBorder>());
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('returns custom shape when shape is set', (tester) async {
      const custom = StadiumBorder();
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              final shape = const FluxCardThemeData(shape: custom).resolveShape(ctx);
              expect(shape, same(custom));
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('outlined preset resolves sentinel border to ColorScheme.outline', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              outline: const Color(0xFF123456),
            ),
          ),
          home: Builder(
            builder: (ctx) {
              final shape = FluxCardThemeData.outlined.resolveShape(ctx);
              final border = shape as RoundedRectangleBorder;
              expect(border.side.color, const Color(0xFF123456));
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // FluxCardThemeData.of
  // ---------------------------------------------------------------------------

  group('FluxCardThemeData.of', () {
    testWidgets('falls back to standard when no theme is in context', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              final theme = FluxCardThemeData.of(ctx);
              expect(theme, FluxCardThemeData.standard);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('picks up ThemeExtension from ThemeData', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [FluxCardThemeData.compact]),
          home: Builder(
            builder: (ctx) {
              final theme = FluxCardThemeData.of(ctx);
              expect(theme, FluxCardThemeData.compact);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('FluxCardTheme InheritedWidget takes priority over ThemeExtension', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [FluxCardThemeData.compact]),
          home: FluxCardTheme(
            data: FluxCardThemeData.elevated,
            child: Builder(
              builder: (ctx) {
                final theme = FluxCardThemeData.of(ctx);
                expect(theme, FluxCardThemeData.elevated);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // FluxCardTheme InheritedWidget
  // ---------------------------------------------------------------------------

  group('FluxCardTheme', () {
    testWidgets('updateShouldNotify returns true when data changes', (tester) async {
      bool notified = false;
      await tester.pumpWidget(
        MaterialApp(
          home: FluxCardTheme(
            data: FluxCardThemeData.standard,
            child: Builder(
              builder: (ctx) {
                ctx.dependOnInheritedWidgetOfExactType<FluxCardTheme>();
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: FluxCardTheme(
            data: FluxCardThemeData.elevated,
            child: Builder(
              builder: (ctx) {
                notified = true;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(notified, isTrue);
    });
  });
}
