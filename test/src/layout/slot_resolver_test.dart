import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/src/components/flux_overlay.dart';
import 'package:flux_card/src/components/flux_underlay.dart';
import 'package:flux_card/src/core/enums.dart';
import 'package:flux_card/src/divider/flux_divider.dart';
import 'package:flux_card/src/layout/boundary_tracker.dart';
import 'package:flux_card/src/layout/slot_resolver.dart';

class DummySlotWrapper extends StatelessWidget implements FluxSlotWrapper {
  const DummySlotWrapper({
    super.key,
    required this.child,
    this.externalPaddingOverride,
  });

  final Widget child;

  @override
  final EdgeInsetsGeometry? externalPaddingOverride;

  @override
  Widget build(BuildContext context) => child;
}

void main() {
  Widget wrap(Widget child) {
    return Material(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: child,
      ),
    );
  }

  group('SlotResolver.boundaryBetween', () {
    test('maps header and body to afterHeader', () {
      expect(
        SlotResolver.boundaryBetween(FluxTarget.header, FluxTarget.body),
        FluxSlotBoundary.afterHeader,
      );
    });

    test('maps body and footer to afterBody', () {
      expect(
        SlotResolver.boundaryBetween(FluxTarget.body, FluxTarget.footer),
        FluxSlotBoundary.afterBody,
      );
    });

    test('maps header and footer to afterHeader', () {
      expect(
        SlotResolver.boundaryBetween(FluxTarget.header, FluxTarget.footer),
        FluxSlotBoundary.afterHeader,
      );
    });

    test('returns null for unrelated slots', () {
      expect(
        SlotResolver.boundaryBetween(FluxTarget.media, FluxTarget.body),
        isNull,
      );
    });
  });

  group('SlotResolver.verticalGroup', () {
    testWidgets('filters null slots and injects spacing', (tester) async {
      await tester.pumpWidget(
        wrap(
          SlotResolver.verticalGroup(
            slots: const [Text('A'), null, Text('B'), Text('C'), null],
            spacing: 16.0,
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);

      final sizedBoxes = tester
          .widgetList<SizedBox>(find.byType(SizedBox))
          .where((sb) => sb.height == 16.0)
          .toList();

      expect(sizedBoxes.length, 2);
    });

    testWidgets('returns SizedBox.shrink when all slots are empty or null',
            (tester) async {
          await tester.pumpWidget(
            wrap(
              SlotResolver.verticalGroup(
                slots: [null, null],
                spacing: 10,
              ),
            ),
          );

          expect(find.byType(Column), findsNothing);
          expect(find.byType(SizedBox), findsOneWidget);
        });
  });

  group('SlotResolver.wrapSlot', () {
    testWidgets('returns padded child when no underlays/overlays exist',
            (tester) async {
          await tester.pumpWidget(
            wrap(
              Builder(
                builder: (context) {
                  final widget = SlotResolver.wrapSlot(
                    context,
                    target: FluxTarget.header,
                    child: const Text('Header'),
                    underlaysByTarget: {},
                    ovsByTarget: {},
                    contentPadding: const EdgeInsets.all(12),
                  );
                  return widget ?? const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(find.text('Header'), findsOneWidget);

          expect(
            find.byWidgetPredicate(
                  (widget) =>
              widget is Stack &&
                  widget.fit == StackFit.passthrough &&
                  widget.clipBehavior == Clip.none,
            ),
            findsNothing,
          );

          final padding = tester.widget<Padding>(
            find.ancestor(
              of: find.text('Header'),
              matching: find.byType(Padding),
            ),
          );

          expect(padding.padding, const EdgeInsets.all(12));
        });

    testWidgets('wraps child in Stack when layers exist', (tester) async {
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              final widget = SlotResolver.wrapSlot(
                context,
                target: FluxTarget.body,
                child: const Text('Body'),
                underlaysByTarget: {
                  FluxTarget.body: [const FluxUnderlay()],
                },
                ovsByTarget: {
                  FluxTarget.body: [const FluxOverlay(children: [Text('Badge')])],
                },
                contentPadding: EdgeInsets.zero,
              );
              return widget ?? const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
              (widget) =>
          widget is Stack &&
              widget.fit == StackFit.passthrough &&
              widget.clipBehavior == Clip.none,
        ),
        findsOneWidget,
      );
      expect(find.text('Body'), findsOneWidget);
      expect(find.text('Badge'), findsOneWidget);
      expect(find.byType(FluxUnderlay), findsOneWidget);
      expect(find.byType(Positioned), findsWidgets);
    });
  });

  group('SlotResolver.contentColumn', () {
    testWidgets(
      'respects externalPaddingOverride from FluxSlotWrapper',
          (tester) async {
        await tester.pumpWidget(
          wrap(
            Builder(
              builder: (context) {
                final widget = SlotResolver.contentColumn(
                  context,
                  entries: const [
                    (
                    FluxTarget.body,
                    DummySlotWrapper(
                      externalPaddingOverride: EdgeInsets.all(42),
                      child: Text('Override Me'),
                    ),
                    ),
                  ],
                  underlaysByTarget: {},
                  ovsByTarget: {},
                  multiUnderlays: [],
                  multiOvs: [],
                  padding: const EdgeInsets.all(10),
                  spacing: 0,
                );
                return widget ?? const SizedBox.shrink();
              },
            ),
          ),
        );

        final padding = tester.widget<Padding>(
          find
              .ancestor(
            of: find.text('Override Me'),
            matching: find.byType(Padding),
          )
              .first,
        );

        expect(padding.padding, const EdgeInsets.all(42));
      },
    );

    testWidgets('injects boundary trackers and dividers between slots',
            (tester) async {
          final tracker = BoundaryTracker();

          await tester.pumpWidget(
            wrap(
              Builder(
                builder: (context) {
                  final widget = SlotResolver.contentColumn(
                    context,
                    entries: const [
                      (FluxTarget.header, Text('Header')),
                      (FluxTarget.body, Text('Body')),
                    ],
                    underlaysByTarget: {},
                    ovsByTarget: {},
                    multiUnderlays: [],
                    multiOvs: [],
                    padding: EdgeInsets.zero,
                    spacing: 20,
                    divider: const FluxDivider(afterHeader: Text('--- DIVIDER ---')),
                    boundaryTrackers: {FluxSlotBoundary.afterHeader: tracker},
                  );
                  return widget ?? const SizedBox.shrink();
                },
              ),
            ),
          );

          expect(find.text('Header'), findsOneWidget);
          expect(find.text('Body'), findsOneWidget);
          expect(find.text('--- DIVIDER ---'), findsOneWidget);
          expect(tracker.renderBox, isNotNull);
        });

    testWidgets(
      'groups adjacent slots when multi-target layers are provided',
          (tester) async {
        await tester.pumpWidget(
          wrap(
            Builder(
              builder: (context) {
                final widget = SlotResolver.contentColumn(
                  context,
                  entries: const [
                    (FluxTarget.header, Text('Header')),
                    (FluxTarget.body, Text('Body')),
                  ],
                  underlaysByTarget: {},
                  ovsByTarget: {},
                  multiUnderlays: [
                    FluxUnderlay(
                      targets: const {FluxTarget.header, FluxTarget.body},
                      decoration: const BoxDecoration(color: Colors.red),
                    ),
                  ],
                  multiOvs: [
                    const FluxOverlay(
                      targets: {FluxTarget.header, FluxTarget.body},
                      children: [Text('Multi OV')],
                    ),
                  ],
                  padding: EdgeInsets.zero,
                  spacing: 0,
                );
                return widget ?? const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(find.text('Header'), findsOneWidget);
        expect(find.text('Body'), findsOneWidget);
        expect(find.text('Multi OV'), findsOneWidget);

        final stackFinder = find.byWidgetPredicate(
              (widget) =>
          widget is Stack &&
              widget.alignment == AlignmentDirectional.topStart &&
              widget.fit == StackFit.passthrough &&
              widget.clipBehavior == Clip.none,
        );

        expect(stackFinder, findsAtLeastNWidgets(2));
        expect(find.byType(FluxUnderlay), findsOneWidget);
        expect(find.byType(FluxOverlay), findsOneWidget);
      },
    );

    testWidgets('returns null when every entry is null', (tester) async {
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              final widget = SlotResolver.contentColumn(
                context,
                entries: const [
                  (FluxTarget.header, null),
                  (FluxTarget.body, null),
                ],
                underlaysByTarget: {},
                ovsByTarget: {},
                multiUnderlays: [],
                multiOvs: [],
                padding: EdgeInsets.zero,
                spacing: 12,
              );
              return widget ?? const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(find.byType(Column), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });
}