import 'package:flutter/material.dart';

import '../components/flux_background.dart';
import '../components/flux_overlay.dart';
import '../core/enums.dart';
import '../ticket/flux_slot_divider.dart';

/// Static helpers that compose individual card slots and content groups.
abstract final class SlotResolver {
  /// Wraps [child] in a [Stack] that injects targeted backgrounds and overlays.
  ///
  /// [contentPadding] is applied to [child] INSIDE the Stack so that background
  /// layers (via `Positioned.fill`) extend behind the padding area.
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
      if (children.isNotEmpty) children.add(SizedBox(height: spacing));
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
  /// Per-slot padding splits vertically so adjacent slots have [spacing] between
  /// them while slot backgrounds cover the full padded area. [dividers] are
  /// inserted (replacing the plain gap) at matching [FluxSlotBoundary] positions.
  /// [boundaryKeys] are zero-height markers inserted at boundaries for
  /// post-layout measurement (used by [FluxTicketDecoration]).
  static Widget? contentColumn({
    required List<(FluxTarget, Widget?)> entries,
    required List<Widget> allBackgrounds,
    required List<Widget> allOverlays,
    required EdgeInsets padding,
    required double spacing,
    List<FluxSlotDivider>? dividers,
    Map<FluxSlotBoundary, GlobalKey>? boundaryKeys,
  }) {
    final present = entries.where((e) => e.$2 != null).toList();
    if (present.isEmpty) return null;

    final children = <Widget>[];

    for (int i = 0; i < present.length; i++) {
      final (target, child) = present[i];
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
        final GlobalKey? key = boundary == null ? null : boundaryKeys?[boundary];
        final divider = boundary != null
            ? dividers
            ?.where((d) => d.boundary == boundary)
            .firstOrNull
            : null;

        if (key != null || divider != null) {
          // Zero-height keyed marker sits at the exact boundary Y position.
          if (key != null) {
            children.add(SizedBox(key: key, height: 0, width: double.infinity));
          }
          // Divider replaces the plain gap; plain gap added if no divider.
          if (divider != null) {
            children.add(Builder(
              builder: (context) => divider.build(context),
            ));
          }
          // If there's only a key (no divider), still add the regular spacing.
          if (divider == null && key != null) {
            children.add(SizedBox(height: spacing));
          }
        }
        // No key, no divider — regular spacing already handled by slotPad
        // (bottom: spacing/2 on this slot + top: spacing/2 on next = spacing).
      }
    }

    if (children.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  static FluxSlotBoundary? _boundaryBetween(FluxTarget a, FluxTarget b) {
    if (a == FluxTarget.header && b == FluxTarget.body) {
      return FluxSlotBoundary.afterHeader;
    }
    if (a == FluxTarget.body && b == FluxTarget.footer) {
      return FluxSlotBoundary.afterBody;
    }
    if (a == FluxTarget.header && b == FluxTarget.footer) {
      // body slot absent — treat header→footer as afterHeader boundary
      return FluxSlotBoundary.afterHeader;
    }
    return null;
  }
}