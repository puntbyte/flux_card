import 'package:flutter/material.dart';

import '../core/enums.dart';

/// A declarative, non-interactive background layer for a [FluxCard] slot.
///
/// Backgrounds are purely decorative — they never capture pointer events.
/// The [targets] set controls which slot(s) of the card the background is
/// injected into.
///
/// Use [FluxTarget.card] (or the default, which covers all slots) to paint a
/// background across the entire card surface. Use a single target such as
/// `{FluxTarget.body}` to tint only that slot.
///
/// Gradient alignment and positioning should be expressed inside the
/// [BoxDecoration] itself (e.g. via [LinearGradient.begin] / [LinearGradient.end]),
/// not as properties on this widget.
class FluxBackground extends StatelessWidget {
  final Set<FluxTarget> targets;
  final Color? color;
  final Gradient? gradient;
  final BoxDecoration? decoration;

  const FluxBackground.color({
    super.key,
    required this.color,
    this.targets = const {FluxTarget.card},
  }) : gradient = null,
       decoration = null;

  const FluxBackground.gradient({
    super.key,
    required this.gradient,
    this.targets = const {FluxTarget.card},
  }) : color = null,
       decoration = null;

  const FluxBackground.custom({
    super.key,
    required this.decoration,
    this.targets = const {FluxTarget.card},
  }) : color = null,
       gradient = null;

  /// Whether this background is scoped to the entire card surface.
  ///
  /// Returns true when [targets] contains [FluxTarget.card] or covers all
  /// four content slots.
  bool get isGlobal =>
      targets.contains(FluxTarget.card) ||
      targets.containsAll(const {
        FluxTarget.media,
        FluxTarget.header,
        FluxTarget.body,
        FluxTarget.footer,
      });

  /// Whether this background should be rendered inside [slot].
  bool targetsSlot(FluxTarget slot) => !isGlobal && targets.contains(slot);

  @override
  Widget build(BuildContext context) {
    final resolvedDecoration = decoration ?? BoxDecoration(color: color, gradient: gradient);
    return IgnorePointer(
      child: DecoratedBox(decoration: resolvedDecoration, child: const SizedBox.expand()),
    );
  }
}
