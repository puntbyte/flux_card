import 'package:flutter/material.dart';

import '../core/enums.dart';

/// A declarative overlay injected above one or more [FluxCard] slots.
///
/// - [FluxOverlayBehavior.contained] renders inside the clipped card surface.
/// - [FluxOverlayBehavior.breakout] renders in an outer unclipped layer owned
///   by [FluxCard], so the card can stay rounded/clipped while the overlay
///   extrudes outside.
///
/// Alignment is always respected, even when the overlay child is larger than
/// the target slot. This is achieved by anchoring the child with [OverflowBox].
class FluxOverlay extends StatelessWidget {
  const FluxOverlay({
    super.key,
    required this.children,
    this.targets = const {FluxTarget.card},
    this.alignment = Alignment.topRight,
    this.padding = const EdgeInsets.all(12.0),
    this.offset,
    this.zIndex = 0,
    this.interactive = true,
    this.behavior = FluxOverlayBehavior.contained,
  });

  final List<Widget> children;
  final Set<FluxTarget> targets;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry padding;
  final Offset? offset;
  final int zIndex;
  final bool interactive;
  final FluxOverlayBehavior behavior;

  bool get isGlobal =>
      targets.contains(FluxTarget.card) ||
          targets.containsAll(const {
            FluxTarget.media,
            FluxTarget.header,
            FluxTarget.body,
            FluxTarget.footer,
          });

  bool get isBreakout => behavior == FluxOverlayBehavior.breakout;

  bool targetsSlot(FluxTarget slot) => !isGlobal && targets.contains(slot);

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget content = Padding(
      padding: padding,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: children,
      ),
    );

    if (!interactive) {
      content = IgnorePointer(
        ignoring: true,
        child: content,
      );
    }

    if (offset != null) {
      content = Transform.translate(
        offset: offset!,
        child: content,
      );
    }

    return OverflowBox(
      alignment: alignment,
      minWidth: 0,
      minHeight: 0,
      maxWidth: double.infinity,
      maxHeight: double.infinity,
      child: content,
    );
  }
}