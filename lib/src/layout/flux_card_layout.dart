import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../core/theme.dart';
import '../divider/flux_divider.dart';
import 'boundary_tracker.dart';
import 'slot_resolver.dart';

/// Stateless layout engine for [FluxCard].
class FluxCardLayout {
  const FluxCardLayout({
    required this.mode,
    required this.mediaPosition,
    required this.mediaSpan,
    required this.theme,
    required this.resolvedPadding,
    this.divider,
    this.boundaryTrackers,
    this.parentConstraints, // OPTIMIZATION: Added to check for bounded heights
  });

  final FluxLayoutMode mode;
  final FluxMediaPosition mediaPosition;
  final FluxMediaSpan mediaSpan;
  final FluxCardThemeData theme;
  final EdgeInsets resolvedPadding;
  final FluxDivider? divider;
  final Map<FluxSlotBoundary, BoundaryTracker>? boundaryTrackers;
  final BoxConstraints? parentConstraints; // OPTIMIZATION: Track parent constraints

  Widget build({
    Widget? media,
    Widget? header,
    Widget? body,
    Widget? footer,
    required Map<FluxTarget, List<Widget>> bgsByTarget,
    required Map<FluxTarget, List<Widget>> ovsByTarget,
  }) {
    assert(
      mode != FluxLayoutMode.responsive,
      'Resolve responsive layout before calling FluxCardLayout.build().',
    );

    final p = resolvedPadding;
    final s = theme.spacing;

    final mediaSlot = SlotResolver.wrapSlot(
      target: FluxTarget.media,
      child: media,
      bgsByTarget: bgsByTarget,
      ovsByTarget: ovsByTarget,
    );

    Widget? fullContentColumn() => SlotResolver.contentColumn(
      entries: [(FluxTarget.header, header), (FluxTarget.body, body), (FluxTarget.footer, footer)],
      bgsByTarget: bgsByTarget,
      ovsByTarget: ovsByTarget,
      padding: p,
      spacing: s,
      divider: divider,
      boundaryTrackers: boundaryTrackers,
    );

    Widget? subColumn(List<(FluxTarget, Widget?)> entries) => SlotResolver.contentColumn(
      entries: entries,
      bgsByTarget: bgsByTarget,
      ovsByTarget: ovsByTarget,
      padding: p,
      spacing: s,
      divider: divider,
      boundaryTrackers: boundaryTrackers,
    );

    Widget? afterMediaMarker() {
      final tracker = boundaryTrackers?[FluxSlotBoundary.afterMedia];
      if (tracker == null) return null;
      return BoundaryMarker(
        tracker: tracker,
        child: const SizedBox(height: 0, width: double.infinity),
      );
    }

    switch (mode) {
      case FluxLayoutMode.column:
        final content = fullContentColumn();
        if (mediaSlot == null) return content ?? const SizedBox.shrink();

        final marker = afterMediaMarker();
        final mediaDivider = divider?.afterMedia;

        return SlotResolver.verticalGroup(
          slots: mediaPosition == FluxMediaPosition.start
              ? [mediaSlot, marker, mediaDivider, content]
              : [content, marker, mediaDivider, mediaSlot],
          spacing: 0,
        );

      case FluxLayoutMode.row:
        if (mediaSlot == null) return fullContentColumn() ?? const SizedBox.shrink();

        final present = [
          (FluxTarget.header, header),
          (FluxTarget.body, body),
          (FluxTarget.footer, footer),
        ].where((e) => e.$2 != null).toList();

        if (present.isEmpty) return mediaSlot;

        int getSpanType(FluxTarget target) {
          switch (mediaSpan) {
            case FluxMediaSpan.all:
              return 0;
            case FluxMediaSpan.header:
              return target == FluxTarget.header ? 0 : 1;
            case FluxMediaSpan.body:
              if (target == FluxTarget.header) return -1;
              if (target == FluxTarget.body) return 0;
              return 1;
            case FluxMediaSpan.footer:
              return target == FluxTarget.footer ? 0 : -1;
            case FluxMediaSpan.headerAndBody:
              return target == FluxTarget.footer ? 1 : 0;
            case FluxMediaSpan.bodyAndFooter:
              return target == FluxTarget.header ? -1 : 0;
          }
        }

        final beforeCol = <Widget>[];
        final inCol = <Widget>[];
        final afterCol = <Widget>[];

        for (int i = 0; i < present.length; i++) {
          final target = present[i].$1;

          final slotPad = EdgeInsets.only(
            left: p.left,
            right: p.right,
            top: i == 0 ? p.top : s / 2,
            bottom: i == present.length - 1 ? p.bottom : s / 2,
          );

          final slotWidget = SlotResolver.wrapSlot(
            target: target,
            child: present[i].$2,
            bgsByTarget: bgsByTarget,
            ovsByTarget: ovsByTarget,
            contentPadding: slotPad,
          )!;

          final spanType = getSpanType(target);

          if (spanType < 0) {
            beforeCol.add(slotWidget);
          } else if (spanType == 0) {
            inCol.add(slotWidget);
          } else {
            afterCol.add(slotWidget);
          }

          if (i < present.length - 1) {
            final nextTarget = present[i + 1].$1;
            final boundary = SlotResolver.boundaryBetween(target, nextTarget);

            if (boundary != null) {
              final tracker = boundaryTrackers?[boundary];
              final div = divider?.widgetFor(boundary);

              if (tracker != null || div != null) {
                final boundaryWidget = Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (tracker != null)
                      BoundaryMarker(
                        tracker: tracker,
                        child: const SizedBox(height: 0, width: double.infinity),
                      ),
                    if (div != null) div,
                  ],
                );

                final nextSpanType = getSpanType(nextTarget);

                if (spanType < 0 && nextSpanType < 0) {
                  beforeCol.add(boundaryWidget);
                } else if (spanType == 0 && nextSpanType == 0) {
                  inCol.add(boundaryWidget);
                } else if (spanType > 0 && nextSpanType > 0) {
                  afterCol.add(boundaryWidget);
                } else if (spanType < 0 && nextSpanType >= 0) {
                  beforeCol.add(boundaryWidget);
                } else if (spanType == 0 && nextSpanType > 0) {
                  afterCol.add(boundaryWidget);
                }
              }
            }
          }
        }

        // OPTIMIZATION: Extract the Row out of the IntrinsicHeight.
        final rowContent = Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: mediaPosition == FluxMediaPosition.start
              ? [
                  Flexible(flex: theme.flexMedia, child: mediaSlot),
                  Expanded(
                    flex: theme.flexContent,
                    child: inCol.isNotEmpty
                        ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: inCol)
                        : const SizedBox.shrink(),
                  ),
                ]
              : [
                  Expanded(
                    flex: theme.flexContent,
                    child: inCol.isNotEmpty
                        ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: inCol)
                        : const SizedBox.shrink(),
                  ),
                  Flexible(flex: theme.flexMedia, child: mediaSlot),
                ],
        );

        // OPTIMIZATION: Only apply IntrinsicHeight if the vertical height is unbounded
        // (e.g. inside a ListView). If inside a GridView or given a fixed height constraint,
        // this skips the expensive double-layout pass entirely!
        final needsIntrinsicHeight =
            parentConstraints == null || !parentConstraints!.hasBoundedHeight;

        final rowWidget = needsIntrinsicHeight ? IntrinsicHeight(child: rowContent) : rowContent;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [...beforeCol, rowWidget, ...afterCol],
        );

      case FluxLayoutMode.inline:
        final beforeEntries = mediaPosition == FluxMediaPosition.start
            ? [(FluxTarget.header, header)]
            : [(FluxTarget.header, header), (FluxTarget.body, body)];

        final afterEntries = mediaPosition == FluxMediaPosition.start
            ? [(FluxTarget.body, body), (FluxTarget.footer, footer)]
            : [(FluxTarget.footer, footer)];

        return SlotResolver.verticalGroup(
          slots: [
            subColumn(beforeEntries),
            afterMediaMarker(),
            divider?.afterMedia,
            mediaSlot,
            subColumn(afterEntries),
          ],
          spacing: 0,
        );

      case FluxLayoutMode.responsive:
        return fullContentColumn() ?? const SizedBox.shrink();
    }
  }
}
