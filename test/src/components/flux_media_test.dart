import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

// A valid 1x1 transparent PNG image for safe image testing
final Uint8List transparentImage = Uint8List.fromList(const <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
]);

void main() {
  // We use Center here to provide "loose" constraints, allowing FluxMedia
  // to expand via its Align widget when fixed sizes are provided.
  Widget wrap(Widget child) => MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );

  // ---------------------------------------------------------------------------
  // Child rendering
  // ---------------------------------------------------------------------------

  group('FluxMedia — child widget', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(wrap(const FluxMedia(child: Text('media child'))));
      expect(find.text('media child'), findsOneWidget);
    });

    testWidgets('renders specific child', (tester) async {
      const childKey = Key('media_child');
      await tester.pumpWidget(
        wrap(
          const FluxMedia(
            aspectRatio: 16 / 9,
            child: SizedBox(key: childKey),
          ),
        ),
      );
      expect(find.byKey(childKey), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Sizing
  // ---------------------------------------------------------------------------

  group('FluxMedia — sizing', () {
    testWidgets('aspectRatio constrains height relative to width', (tester) async {
      const ratio = 16 / 9;
      const childKey = Key('media_child');
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 400, // Force parent to 400
            child: FluxMedia(
              aspectRatio: ratio,
              child: SizedBox(key: childKey),
            ),
          ),
        ),
      );
      // Measure the inner child to see the exact constraints applied
      final size = tester.getSize(find.byKey(childKey));
      expect(size.width, 400.0);
      expect(size.height, closeTo(400.0 / ratio, 1.0));
    });

    testWidgets('explicit width produces correct widget width', (tester) async {
      const childKey = Key('media_child');
      await tester.pumpWidget(
        wrap(const FluxMedia(width: 120, height: 80, child: SizedBox(key: childKey))),
      );
      // FluxMedia wraps this in an Align which expands to the parent (800.0),
      // but the actual child is tightly constrained to exactly 120x80.
      final size = tester.getSize(find.byKey(childKey));
      expect(size.width, 120.0);
      expect(size.height, 80.0);
    });

    testWidgets('width without height fills infinite height with natural child', (tester) async {
      const childKey = Key('media_child');
      await tester.pumpWidget(
        wrap(
          UnconstrainedBox( // Let FluxMedia size itself without loose center bounds
            child: FluxMedia(width: 100, child: SizedBox(key: childKey, height: 50)),
          ),
        ),
      );
      final size = tester.getSize(find.byKey(childKey));
      expect(size.width, 100.0);
      expect(size.height, 50.0); // Child dictates height when FluxMedia height is null
    });

    testWidgets('padding wraps content with correct insets', (tester) async {
      await tester.pumpWidget(
        wrap(
          const FluxMedia(
            aspectRatio: 1.0,
            padding: EdgeInsets.all(8),
            child: SizedBox(),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate((w) => w is Padding && w.padding == const EdgeInsets.all(8)),
        findsOneWidget,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Clipping
  // ---------------------------------------------------------------------------

  group('FluxMedia — borderRadius clipping', () {
    testWidgets('borderRadius adds ClipRRect', (tester) async {
      await tester.pumpWidget(
        wrap(
          const FluxMedia(
            aspectRatio: 1.0,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            child: SizedBox(),
          ),
        ),
      );
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('no ClipRRect when borderRadius is null', (tester) async {
      await tester.pumpWidget(
        wrap(const FluxMedia(aspectRatio: 1.0, child: SizedBox())),
      );
      expect(find.byType(ClipRRect), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // Background & foreground layers
  // ---------------------------------------------------------------------------

  group('FluxMedia — scrim layers', () {
    testWidgets('background gradient adds a Stack', (tester) async {
      await tester.pumpWidget(
        wrap(
          FluxMedia(
            aspectRatio: 1.0,
            gradient: const LinearGradient(colors: [Colors.transparent, Colors.black]),
            child: const SizedBox(),
          ),
        ),
      );
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('foreground gradient adds a Stack', (tester) async {
      await tester.pumpWidget(
        wrap(
          FluxMedia(
            aspectRatio: 1.0,
            foregroundGradient: const LinearGradient(colors: [Colors.transparent, Colors.black54]),
            child: const SizedBox(),
          ),
        ),
      );
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('background and foreground scrim layers are IgnorePointer', (tester) async {
      await tester.pumpWidget(
        wrap(
          FluxMedia(
            aspectRatio: 1.0,
            gradient: const LinearGradient(colors: [Colors.transparent, Colors.black12]),
            foregroundGradient: const LinearGradient(colors: [Colors.transparent, Colors.black12]),
            child: const SizedBox(),
          ),
        ),
      );
      // Both background and foreground Positioned children wrap IgnorePointer
      expect(find.byType(IgnorePointer), findsWidgets);
    });
  });

  // ---------------------------------------------------------------------------
  // FluxMedia.image factory
  // ---------------------------------------------------------------------------

  group('FluxMedia.image', () {
    testWidgets('renders without throwing', (tester) async {
      await tester.pumpWidget(
        wrap(
          FluxMedia.image(
            aspectRatio: 16 / 9,
            image: MemoryImage(transparentImage),
          ),
        ),
      );
      // The Ink widget is used for image — verify widget tree is intact
      expect(find.byType(FluxMedia), findsOneWidget);
    });

    testWidgets('borderRadius is forwarded to ClipRRect', (tester) async {
      await tester.pumpWidget(
        wrap(
          FluxMedia.image(
            aspectRatio: 16 / 9,
            image: MemoryImage(transparentImage),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );
      expect(find.byType(ClipRRect), findsOneWidget); // Or Ink decoration based on internal updates
    });
  });

  // ---------------------------------------------------------------------------
  // AspectRatio takes priority over height
  // ---------------------------------------------------------------------------

  group('FluxMedia — sizing priority', () {
    testWidgets('aspectRatio takes priority over explicit height', (tester) async {
      const ratio = 1.0;
      const childKey = Key('media_child');
      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 200,
            child: FluxMedia(
              aspectRatio: ratio,
              height: 999, // should be ignored when aspectRatio is set
              child: SizedBox(key: childKey),
            ),
          ),
        ),
      );
      final size = tester.getSize(find.byKey(childKey));
      // Height should be exactly 200 (200 / 1.0), ignoring the 999
      expect(size.width, 200.0);
      expect(size.height, 200.0);
    });
  });
}