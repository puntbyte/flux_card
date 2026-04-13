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
    required this.theme,
    required this.resolvedPadding,
    this.divider,
    this.boundaryTrackers,
  });

  final FluxLayoutMode mode;
  final FluxMediaPosition mediaPosition;
  final FluxCardThemeData theme;
  final EdgeInsets resolvedPadding;

  /// Optional divider widgets for slot boundaries.
  final FluxDivider? divider;

  /// RenderBox trackers at slot boundaries for synchronous position measurement.
  final Map<FluxSlotBoundary, BoundaryTracker>? boundaryTrackers;

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

    // Media fills its slot edge-to-edge — no padding applied here.
    final mediaSlot = SlotResolver.wrapSlot(
      target: FluxTarget.media,
      child: media,
      bgsByTarget: bgsByTarget,
      ovsByTarget: ovsByTarget,
    );

    Widget? fullContentColumn() => SlotResolver.contentColumn(
      entries:[(FluxTarget.header, header), (FluxTarget.body, body), (FluxTarget.footer, footer)],
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

    // Marker between the media slot and the content group.
    Widget? afterMediaMarker() {
      final tracker = boundaryTrackers?[FluxSlotBoundary.afterMedia];
      if (tracker == null) return null;
      return BoundaryMarker(
          tracker: tracker,
          child: const SizedBox(height: 0, width: double.infinity)
      );
    }

    Widget buildColumnWithMedia(Widget? content) {
      final marker = afterMediaMarker();
      final mediaDivider = divider?.afterMedia;

      final List<Widget?> slots;
      if (mediaPosition == FluxMediaPosition.start) {
        slots =[mediaSlot, marker, mediaDivider, content];
      } else {
        slots =[content, marker, mediaDivider, mediaSlot];
      }
      return SlotResolver.verticalGroup(slots: slots, spacing: 0);
    }

    switch (mode) {
      case FluxLayoutMode.column:
        final content = fullContentColumn();
        if (mediaSlot == null) return content ?? const SizedBox.shrink();
        return buildColumnWithMedia(content);

      case FluxLayoutMode.row:
        final content = fullContentColumn();
        if (mediaSlot == null) return content ?? const SizedBox.shrink();
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: mediaPosition == FluxMediaPosition.start
                ?[
              Flexible(flex: theme.flexMedia, child: mediaSlot),
              Expanded(flex: theme.flexContent, child: content ?? const SizedBox.shrink()),
            ]
                :[
              Expanded(flex: theme.flexContent, child: content ?? const SizedBox.shrink()),
              Flexible(flex: theme.flexMedia, child: mediaSlot),
            ],
          ),
        );

      case FluxLayoutMode.inline:
        final beforeEntries = mediaPosition == FluxMediaPosition.start
            ?[(FluxTarget.header, header)]
            : [(FluxTarget.header, header), (FluxTarget.body, body)];
        final afterEntries = mediaPosition == FluxMediaPosition.start
            ?[(FluxTarget.body, body), (FluxTarget.footer, footer)]
            : [(FluxTarget.footer, footer)];

        return SlotResolver.verticalGroup(
          slots:[
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