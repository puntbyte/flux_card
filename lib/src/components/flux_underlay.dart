import 'package:flutter/material.dart';

import '../core/enums.dart';

/// A declarative, non-interactive underlay layer for a [FluxCard] slot.
///
/// Underlays are purely decorative — they never capture pointer events.
/// The [targets] set controls which slot(s) of the card the underlay is
/// injected into.
class FluxUnderlay extends StatelessWidget {
  /// Unified constructor for[FluxUnderlay].
  ///
  /// Use [margin] with negative values to extrude the underlay outside of its
  /// target bounds, and [offset] to shift it. This is perfect for overlapping
  /// rounded underlays across slots.
  const FluxUnderlay({
    super.key,
    this.targets = const {FluxTarget.card},
    this.decoration,
    this.margin = EdgeInsets.zero,
    this.offset = Offset.zero,
    this.zIndex = 0,
  });

  final Set<FluxTarget> targets;
  final Decoration? decoration;

  /// Controls rendering order when multiple underlays target the same slot.
  /// Higher values paint on top of lower values.
  final int zIndex;

  /// Insets or outsets the underlay relative to the target slot.
  ///
  /// Use negative margins (e.g. `EdgeInsets.all(-10)`) to expand the
  /// underlay so it overlaps adjacent slots.
  final EdgeInsetsGeometry margin;

  /// Shifts the underlay by the given X and Y pixels.
  final Offset offset;

  /// Whether this underlay is scoped to the entire card surface.
  bool get isGlobal =>
      targets.contains(FluxTarget.card) ||
      targets.containsAll(const {
        FluxTarget.media,
        FluxTarget.header,
        FluxTarget.body,
        FluxTarget.footer,
      });

  /// Whether this underlay should be rendered inside [slot].
  bool targetsSlot(FluxTarget slot) => !isGlobal && targets.contains(slot);

  /// Helper used by the layout engine to inject the underlay with its margins
  /// and offsets applied natively via [Positioned].
  static Widget buildPositioned(BuildContext context, Widget underlay) {
    if (underlay is FluxUnderlay) {
      final resolvedMargin = underlay.margin.resolve(Directionality.maybeOf(context));
      return Positioned(
        top: resolvedMargin.top + underlay.offset.dy,
        bottom: resolvedMargin.bottom - underlay.offset.dy,
        left: resolvedMargin.left + underlay.offset.dx,
        right: resolvedMargin.right - underlay.offset.dx,
        child: underlay,
      );
    }
    return Positioned.fill(child: underlay);
  }

  @override
  Widget build(BuildContext context) {
    if (decoration == null) return const SizedBox.expand();
    return IgnorePointer(
      child: Ink(decoration: decoration, child: const SizedBox.expand()),
    );
  }
}
