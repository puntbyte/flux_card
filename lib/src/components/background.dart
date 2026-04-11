import 'package:flutter/material.dart';

/// Decorative background layer for a Flux card.
class FluxBackground extends StatelessWidget {
  final Color? color;
  final Gradient? gradient;
  final BoxDecoration? decoration;
  final Alignment alignment;

  const FluxBackground.color({
    super.key,
    required this.color,
    this.alignment = Alignment.center,
  })  : gradient = null,
        decoration = null;

  const FluxBackground.gradient({
    super.key,
    required this.gradient,
    this.alignment = Alignment.center,
  })  : color = null,
        decoration = null;

  const FluxBackground.custom({
    super.key,
    required this.decoration,
    this.alignment = Alignment.center,
  })  : color = null,
        gradient = null;

  @override
  Widget build(BuildContext context) {
    final resolvedDecoration = decoration ?? BoxDecoration(color: color, gradient: gradient);
    if (resolvedDecoration == null) {
      return const SizedBox.shrink();
    }

    return SizedBox.expand(
      child: DecoratedBox(
        decoration: resolvedDecoration,
        child: Align(alignment: alignment, child: const SizedBox.shrink()),
      ),
    );
  }
}
