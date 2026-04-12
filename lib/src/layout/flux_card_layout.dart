import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../core/theme.dart';
import '../divider/flux_divider.dart';
import 'slot_resolver.dart';

/// Stateless layout engine for [FluxCard].
class FluxCardLayout {
  const FluxCardLayout({
    required this.mode,
    required this.mediaPosition,
    required this.theme,
    required this.resolvedPadding,
    this.divider,
    this.boundaryKeys,
  });

  final FluxLayoutMode mode;
  final FluxMediaPosition mediaPosition;
  final FluxCardThemeData theme;
  final EdgeInsets resolvedPadding;

  /// Optional divider widgets for slot boundaries.
  final FluxDivider? divider;

  /// Zero-height keyed markers at slot boundaries for post-layout measurement.
  final Map<FluxSlotBoundary, GlobalKey>? boundaryKeys;

  Widget build({
    Widget? media,
    Widget? header,
    Widget? body,
    Widget? footer,
    required List<Widget> allBackgrounds,
    required List<Widget> allOverlays,
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
      allBackgrounds: allBackgrounds,
      allOverlays: allOverlays,
    );

    Widget? fullContentColumn() => SlotResolver.contentColumn(
      entries: [(FluxTarget.header, header), (FluxTarget.body, body), (FluxTarget.footer, footer)],
      allBackgrounds: allBackgrounds,
      allOverlays: allOverlays,
      padding: p,
      spacing: s,
      divider: divider,
      boundaryKeys: boundaryKeys,
    );

    Widget? subColumn(List<(FluxTarget, Widget?)> entries) => SlotResolver.contentColumn(
      entries: entries,
      allBackgrounds: allBackgrounds,
      allOverlays: allOverlays,
      padding: p,
      spacing: s,
      divider: divider,
      boundaryKeys: boundaryKeys,
    );

    // Zero-height keyed marker between the media slot and the content group.
    Widget? afterMediaMarker() {
      final key = boundaryKeys?[FluxSlotBoundary.afterMedia];
      if (key == null) return null;
      return SizedBox(key: key, height: 0, width: double.infinity);
    }

    // Builds a vertical stack of [mediaSlot] and [content] with the afterMedia
    // boundary marker and optional afterMedia divider widget between them.
    Widget buildColumnWithMedia(Widget? content) {
      final marker = afterMediaMarker();
      final mediaDivider = divider?.afterMedia;

      final List<Widget?> slots;
      if (mediaPosition == FluxMediaPosition.start) {
        slots = [mediaSlot, marker, mediaDivider, content];
      } else {
        slots = [content, marker, mediaDivider, mediaSlot];
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
        // IntrinsicHeight allows crossAxisAlignment.stretch to work even when
        // the parent provides unbounded height (e.g. inside a ScrollView).
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: mediaPosition == FluxMediaPosition.start
                ? [
              Flexible(flex: theme.flexMedia, child: mediaSlot),
              Expanded(
                flex: theme.flexContent,
                child: content ?? const SizedBox.shrink(),
              ),
            ]
                : [
              Expanded(
                flex: theme.flexContent,
                child: content ?? const SizedBox.shrink(),
              ),
              Flexible(flex: theme.flexMedia, child: mediaSlot),
            ],
          ),
        );

      case FluxLayoutMode.inline:
      // Media is embedded inside the content column between two sub-columns.
      // The afterMedia marker + divider sit between the before-media content
      // and the media slot itself.
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
      // Should have been resolved before reaching here.
        return fullContentColumn() ?? const SizedBox.shrink();
    }
  }
}