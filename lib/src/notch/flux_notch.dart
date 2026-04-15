import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../shapes/flux_notch_shape.dart';

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
/// ### Usage
/// ```dart
/// FluxCard(
///   notch: FluxNotch(
///     boundary: FluxSlotBoundary.afterHeader,
///     notchRadius: 14,
///     side: BorderSide(color: Colors.grey.shade300, width: 1.5),
///   ),
///   divider: FluxDivider(
///     afterHeader: FluxDashedDivider(indent: 14, endIndent: 14),
///   ),
/// )
/// ```
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
    BorderSide side = BorderSide.none,
  }) : this._(
    boundary: boundary,
    fallbackPosition: fallbackPosition,
    boundaryOffset: boundaryOffset,
    boundaryAlignment: boundaryAlignment,
    notchRadius: notchRadius,
    edge: edge,
    notchSide: notchSide,
    borderRadius: borderRadius,
    side: side,
  );

  const FluxNotch.free({
    double position = 0.5,
    double notchRadius = 12.0,
    FluxNotchEdge edge = FluxNotchEdge.vertical,
    FluxNotchSide notchSide = FluxNotchSide.both,
    BorderRadius? borderRadius,
    BorderSide side = BorderSide.none,
  }) : this._(
    boundary: null,
    fallbackPosition: position,
    boundaryOffset: 0.0,
    boundaryAlignment: Alignment.center,
    notchRadius: notchRadius,
    edge: edge,
    notchSide: notchSide,
    borderRadius: borderRadius,
    side: side,
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
    required this.side,
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
  final BorderSide side;

  bool get isTargeted => boundary != null;

  CustomPainter buildBorderPainter(
      double position,
      BorderRadius resolvedBorderRadius,
      TextDirection? td, {
        NotchPositionResolver? notchPositionResolver,
      }) => _FluxNotchBorderPainter(
    notchPosition: position,
    notchPositionResolver: notchPositionResolver,
    notchRadius: notchRadius,
    notchEdge: edge,
    notchSide: notchSide,
    borderRadius: resolvedBorderRadius,
    side: side,
    textDirection: td,
  );
}

// ── Internal border painter ─────────────────────────────────────────────────

class _FluxNotchBorderPainter extends CustomPainter {
  const _FluxNotchBorderPainter({
    required this.notchPosition,
    this.notchPositionResolver,
    required this.notchRadius,
    required this.notchEdge,
    required this.notchSide,
    required this.borderRadius,
    required this.side,
    this.textDirection,
  });

  final double notchPosition;
  final NotchPositionResolver? notchPositionResolver;
  final double notchRadius;
  final FluxNotchEdge notchEdge;
  final FluxNotchSide notchSide;
  final BorderRadius borderRadius;
  final BorderSide side;
  final TextDirection? textDirection;

  double _resolvePosition(Size size) {
    if (notchPositionResolver != null) {
      final resolved = notchPositionResolver!(Offset.zero & size);
      if (resolved != null) return resolved;
    }
    return notchPosition;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (side == BorderSide.none || side.width == 0) return;
    final path = NotchPathBuilder.build(
      rect: Offset.zero & size,
      borderRadius: borderRadius,
      notchPosition: _resolvePosition(size),
      notchRadius: notchRadius,
      notchEdge: notchEdge,
      notchSide: notchSide,
      textDirection: textDirection,
    );
    canvas.drawPath(path, side.toPaint());
  }

  @override
  bool shouldRepaint(_FluxNotchBorderPainter old) =>
      old.notchPosition != notchPosition ||
          old.notchPositionResolver != notchPositionResolver ||
          old.notchRadius != notchRadius ||
          old.notchEdge != notchEdge ||
          old.notchSide != notchSide ||
          old.borderRadius != borderRadius ||
          old.side != side ||
          old.textDirection != textDirection;
}