import 'package:flutter/material.dart';

import '../components/flux_background.dart';
import '../components/flux_overlay.dart';
import '../core/enums.dart';
import '../divider/flux_divider.dart';

/// Static helpers that compose individual card slots and content groups.
abstract final class SlotResolver {
  /// Wraps [child] in a [Stack] that injects targeted backgrounds and overlays.
  ///
  /// [contentPadding] is applied to [child] INSIDE the Stack so that
  /// background layers (via `Positioned.fill`) extend behind the padding area.
  ///
  /// Overlays are wrapped in `Positioned.fill` so that [Align] inside
  /// [FluxOverlay] has bounded dimensions, enabling bottom-edge alignments.
  static Widget? wrapSlot({
    required FluxTarget target,
    required Widget? child,
    required List<Widget> allBackgrounds,
    required List<Widget> allOverlays,
    EdgeInsets? contentPadding,
  }) {
    if (child == null) return null;

    final bgs = allBackgrounds
        .whereType<FluxBackground>()
        .where((b) => b.targetsSlot(target))
        .toList();

    final ovs = allOverlays
        .whereType<FluxOverlay>()
        .where((o) => o.targetsSlot(target))
        .toList()
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    final Widget paddedChild =
    (contentPadding != null && contentPadding != EdgeInsets.zero)
        ? Padding(padding: contentPadding, child: child)
        : child;

    if (bgs.isEmpty && ovs.isEmpty) return paddedChild;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        ...bgs.map((bg) => Positioned.fill(child: bg)),
        paddedChild,
        ...ovs.map((ov) => Positioned.fill(child: ov)),
      ],
    );
  }

  /// Arranges [slots] vertically with [spacing] between non-null entries.
  static Widget verticalGroup({
    required List<Widget?> slots,
    required double spacing,
  }) {
    final children = <Widget>[];
    for (final slot in slots) {
      if (slot == null) continue;
      if (children.isNotEmpty && spacing > 0) {
        children.add(SizedBox(height: spacing));
      }
      children.add(slot);
    }
    if (children.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  /// Builds the padded content column for header / body / footer slots.
  ///
  /// Per-slot padding splits vertically so adjacent slots always have
  /// [spacing] of breathing room between them while slot backgrounds cover the
  /// full padded area.
  ///
  /// If [divider] supplies a widget for a given boundary, that widget is
  /// inserted between the half-padding sections of the two adjacent slots,
  /// centring it inside the gap.
  ///
  /// [boundaryKeys] inserts zero-height keyed [SizedBox] markers at boundary
  /// positions for post-layout measurement (used by [FluxNotch]).
  static Widget? contentColumn({
    required List<(FluxTarget, Widget?)> entries,
    required List<Widget> allBackgrounds,
    required List<Widget> allOverlays,
    required EdgeInsets padding,
    required double spacing,
    FluxDivider? divider,
    Map<FluxSlotBoundary, GlobalKey>? boundaryKeys,
  }) {
    final present = entries.where((e) => e.$2 != null).toList();
    if (present.isEmpty) return null;

    final children = <Widget>[];

    for (int i = 0; i < present.length; i++) {
      final (target, child) = present[i];

      // Each slot gets half the spacing on its inner edges so adjacent slots
      // produce the full spacing gap (top_half + bottom_half = spacing).
      final slotPad = EdgeInsets.only(
        left: padding.left,
        right: padding.right,
        top: i == 0 ? padding.top : spacing / 2,
        bottom: i == present.length - 1 ? padding.bottom : spacing / 2,
      );

      final wrapped = wrapSlot(
        target: target,
        child: child,
        allBackgrounds: allBackgrounds,
        allOverlays: allOverlays,
        contentPadding: slotPad,
      );
      if (wrapped != null) children.add(wrapped);

      // Between this slot and the next, optionally insert a boundary marker
      // and/or a divider widget.
      if (i < present.length - 1) {
        final boundary = _boundaryBetween(present[i].$1, present[i + 1].$1);
        if (boundary != null) {
          // Zero-height keyed marker for boundary Y-position measurement.
          final key = boundaryKeys?[boundary];
          if (key != null) {
            children.add(SizedBox(key: key, height: 0, width: double.infinity));
          }
          // Visual divider widget at this boundary (sits in the gap centre).
          final dividerWidget = divider?.widgetFor(boundary);
          if (dividerWidget != null) {
            children.add(dividerWidget);
          }
        }
      }
    }

    if (children.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static FluxSlotBoundary? _boundaryBetween(FluxTarget a, FluxTarget b) {
    if (a == FluxTarget.header && b == FluxTarget.body) {
      return FluxSlotBoundary.afterHeader;
    }
    if (a == FluxTarget.body && b == FluxTarget.footer) {
      return FluxSlotBoundary.afterBody;
    }
    if (a == FluxTarget.header && b == FluxTarget.footer) {
      // body absent — header→footer gap uses the afterHeader boundary.
      return FluxSlotBoundary.afterHeader;
    }
    return null;
  }
}