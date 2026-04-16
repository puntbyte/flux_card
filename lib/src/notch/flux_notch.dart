import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../shapes/flux_notch_shape.dart';

import 'package:flutter/material.dart';

import '../core/enums.dart';

/// Defines semicircular notches cut into the edges of a [FluxCard].
///
/// Two constructors cover the two positioning modes:
///
/// - **[FluxNotch]** (default) — snaps the notch to a named slot boundary
///   measured after the first layout. Use this when the notch should align
///   with a [FluxDivider] at the same boundary.
///
/// - **[FluxNotch.free]** — positions the notch at a fixed 0.0–1.0 fraction
///   of the card's height (vertical edge) or width (horizontal edge). Useful
///   for horizontal notches or when no slot boundary is relevant.
///
/// The card outline is owned by [FluxCardThemeData.borderSide] /
/// [FluxCardThemeData.shape]. [FluxNotch] only defines notch geometry
/// and positioning.
class FluxNotch {
  const FluxNotch({
    required FluxSlotBoundary boundary,
    double fallbackPosition = 0.5,
    double boundaryOffset = 0.0,
    AlignmentGeometry boundaryAlignment = Alignment.center,
    double notchRadius = 12.0,
    FluxNotchEdge edge = FluxNotchEdge.vertical,
    FluxNotchSide notchSide = FluxNotchSide.both,
    BorderRadius? borderRadius,
  }) : this._(
    boundary: boundary,
    fallbackPosition: fallbackPosition,
    boundaryOffset: boundaryOffset,
    boundaryAlignment: boundaryAlignment,
    notchRadius: notchRadius,
    edge: edge,
    notchSide: notchSide,
    borderRadius: borderRadius,
  );

  const FluxNotch.free({
    double position = 0.5,
    double notchRadius = 12.0,
    FluxNotchEdge edge = FluxNotchEdge.vertical,
    FluxNotchSide notchSide = FluxNotchSide.both,
    BorderRadius? borderRadius,
  }) : this._(
    boundary: null,
    fallbackPosition: position,
    boundaryOffset: 0.0,
    boundaryAlignment: Alignment.center,
    notchRadius: notchRadius,
    edge: edge,
    notchSide: notchSide,
    borderRadius: borderRadius,
  );

  const FluxNotch._({
    this.boundary,
    required this.fallbackPosition,
    required this.boundaryOffset,
    required this.boundaryAlignment,
    required this.notchRadius,
    required this.edge,
    required this.notchSide,
    this.borderRadius,
  });

  final FluxSlotBoundary? boundary;
  final double fallbackPosition;

  /// Controls where the notch aligns relative to the measured bounds of the
  /// tracked boundary widget (e.g. the divider).
  ///
  /// Defaults to [Alignment.center], meaning if the divider has a thickness
  /// of 10px, the notch will point to exactly 5px deep into the divider.
  final AlignmentGeometry boundaryAlignment;

  final double boundaryOffset;
  final double notchRadius;
  final FluxNotchEdge edge;
  final FluxNotchSide notchSide;
  final BorderRadius? borderRadius;

  bool get isTargeted => boundary != null;
}
