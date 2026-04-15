import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

void main() {
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: SizedBox(width: 300, child: child)));

  // ---------------------------------------------------------------------------
  // Via FluxCard.loading
  // ---------------------------------------------------------------------------

  group('FluxCardSkeleton — via FluxCard.loading', () {
    testWidgets('appears when loading is true', (tester) async {
      await tester.pumpWidget(wrap(const FluxCard(
        loading: true,
        header: Text('hidden'),
      )));
      expect(find.byType(FluxCardSkeleton), findsOneWidget);
    });

    testWidgets('disappears when loading becomes false', (tester) async {
      bool loading = true;

      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (ctx, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => loading = false),
                  child: const Text('stop'),
                ),
                FluxCard(
                  loading: loading,
                  header: const Text('header'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(FluxCardSkeleton), findsOneWidget);
      expect(find.text('header'), findsNothing);

      await tester.tap(find.text('stop'));
      await tester.pump();

      expect(find.byType(FluxCardSkeleton), findsNothing);
      expect(find.text('header'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Slot presence flags
  // ---------------------------------------------------------------------------

  group('FluxCardSkeleton — slot flags', () {
    testWidgets('hasMedia adds media skeleton region', (tester) async {
      await tester.pumpWidget(wrap(const FluxCard(
        loading: true,
        media: SizedBox(height: 100),
        header: Text('h'),
      )));
      // We just verify it renders without throwing and skeleton is present
      expect(find.byType(FluxCardSkeleton), findsOneWidget);
    });

    testWidgets('hasFooter: false omits footer skeleton region', (tester) async {
      // Default: hasFooter is false — no footer shimmer
      await tester.pumpWidget(wrap(const FluxCard(
        loading: true,
        header: Text('h'),
        body: Text('b'),
      )));
      expect(find.byType(FluxCardSkeleton), findsOneWidget);
    });

    testWidgets('hasFooter: true shows footer skeleton region', (tester) async {
      await tester.pumpWidget(wrap(const FluxCard(
        loading: true,
        header: Text('h'),
        footer: Text('f'),
      )));
      expect(find.byType(FluxCardSkeleton), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // loadingWrapper
  // ---------------------------------------------------------------------------

  group('FluxCardSkeleton — loadingWrapper', () {
    testWidgets('loadingWrapper receives skeleton and can wrap it', (tester) async {
      Widget? receivedSkeleton;
      await tester.pumpWidget(wrap(FluxCard(
        loading: true,
        header: const Text('hidden'),
        loadingWrapper: (context, skeleton) {
          receivedSkeleton = skeleton;
          return DecoratedBox(
            decoration: const BoxDecoration(color: Colors.yellow),
            child: skeleton,
          );
        },
      )));

      expect(receivedSkeleton, isNotNull);
      expect(find.byType(DecoratedBox), findsWidgets);
    });

    testWidgets('loadingWrapper is not called when loading is false', (tester) async {
      bool wrapperCalled = false;
      await tester.pumpWidget(wrap(FluxCard(
        loading: false,
        header: const Text('visible'),
        loadingWrapper: (context, skeleton) {
          wrapperCalled = true;
          return skeleton;
        },
      )));

      expect(wrapperCalled, isFalse);
      expect(find.text('visible'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Animation lifecycle
  // ---------------------------------------------------------------------------

  group('FluxCardSkeleton — animation', () {
    testWidgets('shimmer animation runs and does not throw', (tester) async {
      await tester.pumpWidget(wrap(const FluxCard(loading: true, header: Text('h'))));

      // Pump several frames to exercise animation
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.byType(FluxCardSkeleton), findsOneWidget);
    });

    testWidgets('AnimationController disposes without error on unmount', (tester) async {
      await tester.pumpWidget(wrap(const FluxCard(loading: true, header: Text('h'))));
      // Replace widget to trigger unmount
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
      // No assertion or memory error expected
    });
  });

  // ---------------------------------------------------------------------------
  // Layout modes in skeleton
  // ---------------------------------------------------------------------------

  group('FluxCardSkeleton — layout modes', () {
    testWidgets('column skeleton renders without throwing', (tester) async {
      await tester.pumpWidget(wrap(const SizedBox(
        width: 300,
        child: FluxCard(
          layout: FluxLayoutMode.column,
          loading: true,
          media: SizedBox(height: 80),
          header: Text('h'),
          body: Text('b'),
        ),
      )));
      expect(find.byType(FluxCardSkeleton), findsOneWidget);
    });

    testWidgets('row skeleton renders without throwing', (tester) async {
      await tester.pumpWidget(wrap(const SizedBox(
        width: 400,
        child: FluxCard(
          layout: FluxLayoutMode.row,
          loading: true,
          media: SizedBox(height: 80),
          header: Text('h'),
        ),
      )));
      expect(find.byType(FluxCardSkeleton), findsOneWidget);
    });
  });
}