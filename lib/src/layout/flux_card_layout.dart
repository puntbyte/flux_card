import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../core/theme.dart';
import 'slot_resolver.dart';

/// Stateless layout engine for [FluxCard].
///
/// Receives raw (un-padded, un-wrapped) slot widgets along with the full
/// background / overlay lists and resolved padding, then assembles the card
/// body according to [mode] and [mediaPosition].
///
/// Slot wrapping (backgrounds, overlays, per-slot padding) is done here via
/// [SlotResolver.contentColumn] so that slot backgrounds extend behind their
/// own padding area rather than stopping at the content boundary.
class FluxCardLayout {
  const FluxCardLayout({
    required this.mode,
    required this.mediaPosition,
    required this.theme,
    required this.resolvedPadding,
  });

  final FluxLayoutMode mode;
  final FluxMediaPosition mediaPosition;
  final FluxCardThemeData theme;

  /// Resolved (LTR/RTL aware) padding from [FluxCardThemeData.padding].
  final EdgeInsets resolvedPadding;

  /// Assembles the card body.
  ///
  /// [mode] must already be resolved — [FluxLayoutMode.responsive] must have
  /// been converted to [FluxLayoutMode.column] or [FluxLayoutMode.row] by the
  /// caller.
  Widget build({
    // Raw slot widgets — no padding applied, no backgrounds injected yet.
    Widget? media,
    Widget? header,
    Widget? body,
    Widget? footer,
    required List<Widget> allBackgrounds,
    required List<Widget> allOverlays,
  }) {
    assert(
    mode != FluxLayoutMode.responsive,
    'FluxCardLayout.build() received mode=responsive. '
        'Resolve the responsive breakpoint before calling build().',
    );

    final p = resolvedPadding;
    final s = theme.spacing;

    // Media is never padded — it fills its slot edge-to-edge.
    final mediaSlot = SlotResolver.wrapSlot(
      target: FluxTarget.media,
      child: media,
      allBackgrounds: allBackgrounds,
      allOverlays: allOverlays,
    );

    // ── Content column helpers ─────────────────────────────────────────────

    // All three slots as a single group (column / row modes).
    Widget? fullContentColumn() => SlotResolver.contentColumn(
      entries: [
        (FluxTarget.header, header),
        (FluxTarget.body, body),
        (FluxTarget.footer, footer),
      ],
      allBackgrounds: allBackgrounds,
      allOverlays: allOverlays,
      padding: p,
      spacing: s,
    );

    // A sub-group used in inColumn mode.
    Widget? subColumn(List<(FluxTarget, Widget?)> entries) =>
        SlotResolver.contentColumn(
          entries: entries,
          allBackgrounds: allBackgrounds,
          allOverlays: allOverlays,
          padding: p,
          spacing: s,
        );

    // ── Layout switch ──────────────────────────────────────────────────────

    switch (mode) {
      case FluxLayoutMode.column:
        final content = fullContentColumn();
        if (mediaSlot == null) return content ?? const SizedBox.shrink();
        return SlotResolver.verticalGroup(
          slots: mediaPosition == FluxMediaPosition.start
              ? [mediaSlot, content]
              : [content, mediaSlot],
          spacing: 0,
        );

      case FluxLayoutMode.row:
        final content = fullContentColumn();
        if (mediaSlot == null) return content ?? const SizedBox.shrink();
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

      case FluxLayoutMode.inColumn:
        final beforeEntries = mediaPosition == FluxMediaPosition.start
            ? [(FluxTarget.header, header)]
            : [(FluxTarget.header, header), (FluxTarget.body, body)];

        final afterEntries = mediaPosition == FluxMediaPosition.start
            ? [(FluxTarget.body, body), (FluxTarget.footer, footer)]
            : [(FluxTarget.footer, footer)];

        return SlotResolver.verticalGroup(
          slots: [subColumn(beforeEntries), mediaSlot, subColumn(afterEntries)],
          spacing: 0,
        );

      case FluxLayoutMode.responsive:
        return fullContentColumn() ?? const SizedBox.shrink();
    }
  }
}