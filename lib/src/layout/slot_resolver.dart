import 'package:flutter/material.dart';

import '../components/flux_background.dart';
import '../components/flux_overlay.dart';
import '../core/enums.dart';

/// Static helpers that compose individual card slots and content groups.
abstract final class SlotResolver {
  /// Wraps [child] in a [Stack] that injects targeted backgrounds and overlays.
  ///
  /// [contentPadding] is applied to [child] INSIDE the Stack, so that
  /// background layers (rendered via `Positioned.fill`) extend behind the
  /// padding area rather than stopping at the content boundary.
  ///
  /// Overlays are also wrapped in `Positioned.fill` so that [Align] inside
  /// [FluxOverlay] has a bounded box and all alignment values — including
  /// [Alignment.bottomLeft] and [Alignment.bottomRight] — work correctly.
  ///
  /// Returns null when [child] is null.
  /// Returns the (optionally padded) child directly when no backgrounds or
  /// overlays target this slot, avoiding unnecessary Stack allocation.
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

    // Apply padding to the content so backgrounds can cover the padding area.
    final Widget paddedChild = (contentPadding != null && contentPadding != EdgeInsets.zero)
        ? Padding(padding: contentPadding, child: child)
        : child;

    if (bgs.isEmpty && ovs.isEmpty) return paddedChild;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        // Backgrounds fill the full slot area (including padding).
        ...bgs.map((bg) => Positioned.fill(child: bg)),
        paddedChild,
        // Overlays are wrapped in Positioned.fill so their internal Align
        // widget has bounded dimensions, enabling bottom-edge alignments.
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

  /// Builds a padded content column where each slot's background extends
  /// behind its own padding area.
  ///
  /// Each slot gets individual padding:
  /// - **Horizontal**: full [padding] left/right on every slot.
  /// - **Vertical top**: full [padding.top] on the first present slot;
  ///   `spacing / 2` on subsequent slots.
  /// - **Vertical bottom**: full [padding.bottom] on the last present slot;
  ///   `spacing / 2` on preceding slots.
  ///
  /// The result is that adjacent slots have `spacing / 2 + spacing / 2 = spacing`
  /// between them — identical to the previous grouped-padding behaviour — while
  /// slot backgrounds now span the full padded area.
  ///
  /// Returns null when every slot in [entries] is null.
  static Widget? contentColumn({
    required List<(FluxTarget, Widget?)> entries,
    required List<Widget> allBackgrounds,
    required List<Widget> allOverlays,
    required EdgeInsets padding,
    required double spacing,
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
    }

    if (children.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}