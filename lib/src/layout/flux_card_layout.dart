import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../core/theme.dart';
import '../ticket/flux_slot_divider.dart';
import 'slot_resolver.dart';

/// Stateless layout engine for [FluxCard].
class FluxCardLayout {
  const FluxCardLayout({
    required this.mode,
    required this.mediaPosition,
    required this.theme,
    required this.resolvedPadding,
    this.dividers,
    this.boundaryKeys,
  });

  final FluxLayoutMode mode;
  final FluxMediaPosition mediaPosition;
  final FluxCardThemeData theme;
  final EdgeInsets resolvedPadding;

  /// Dividers inserted between slot pairs.
  final List<FluxSlotDivider>? dividers;

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

    // Media fills its slot edge-to-edge — no padding, no slot wrapping needed
    // for backgrounds (global backgrounds cover it at the card Stack level).
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
      dividers: dividers,
      boundaryKeys: boundaryKeys,
    );

    Widget? subColumn(List<(FluxTarget, Widget?)> entries) => SlotResolver.contentColumn(
      entries: entries,
      allBackgrounds: allBackgrounds,
      allOverlays: allOverlays,
      padding: p,
      spacing: s,
      dividers: dividers,
      boundaryKeys: boundaryKeys,
    );

    // afterMedia boundary marker (not inside contentColumn — lives between
    // the media slot and the content group).
    Widget? afterMediaMarker() {
      final key = boundaryKeys?[FluxSlotBoundary.afterMedia];
      if (key == null) return null;
      return SizedBox(key: key, height: 0, width: double.infinity);
    }

    Widget buildColumnWithMedia(Widget? content) {
      final marker = afterMediaMarker();
      final slots = mediaPosition == FluxMediaPosition.start
          ? [mediaSlot, marker, content]
          : [content, marker, mediaSlot];
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
        // No IntrinsicHeight — Row with crossAxisAlignment.stretch determines
        // height from the content column. FluxMedia without explicit sizing
        // fills the row height directly, making BoxFit work correctly.
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: mediaPosition == FluxMediaPosition.start
              ? [
                  Flexible(flex: theme.flexMedia, child: mediaSlot),
                  Expanded(flex: theme.flexContent, child: content ?? const SizedBox.shrink()),
                ]
              : [
                  Expanded(flex: theme.flexContent, child: content ?? const SizedBox.shrink()),
                  Flexible(flex: theme.flexMedia, child: mediaSlot),
                ],
        );

      case FluxLayoutMode.inColumn:
        final beforeEntries = mediaPosition == FluxMediaPosition.start
            ? [(FluxTarget.header, header)]
            : [(FluxTarget.header, header), (FluxTarget.body, body)];
        final afterEntries = mediaPosition == FluxMediaPosition.start
            ? [(FluxTarget.body, body), (FluxTarget.footer, footer)]
            : [(FluxTarget.footer, footer)];

        return SlotResolver.verticalGroup(
          slots: [subColumn(beforeEntries), afterMediaMarker(), mediaSlot, subColumn(afterEntries)],
          spacing: 0,
        );

      case FluxLayoutMode.responsive:
        return fullContentColumn() ?? const SizedBox.shrink();
    }
  }
}
