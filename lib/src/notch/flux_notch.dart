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
  /// Targeted constructor — snaps the notch to a named slot boundary.
  ///
  /// [FluxCard] measures the rendered Y position of [boundary] after the first
  /// frame and updates the clip and border painter automatically. Until
  /// measurement is available, [fallbackPosition] is used.
  const FluxNotch({
    required FluxSlotBoundary boundary,
    double fallbackPosition = 0.5,
    double boundaryOffset = 0.0,
    double notchRadius = 12.0,
    FluxNotchEdge edge = FluxNotchEdge.vertical,
    FluxNotchSide notchSide = FluxNotchSide.both,
    BorderRadius? borderRadius,
    BorderSide side = BorderSide.none,
  }) : this._(
         boundary: boundary,
         fallbackPosition: fallbackPosition,
         boundaryOffset: boundaryOffset,
         notchRadius: notchRadius,
         edge: edge,
         notchSide: notchSide,
         borderRadius: borderRadius,
         side: side,
       );

  /// Free-position constructor — places the notch at a fixed fraction of the
  /// card edge, with no post-layout measurement.
  ///
  /// [position] is a 0.0–1.0 fraction along the card's height (for vertical
  /// edges) or width (for horizontal edges).
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
         notchRadius: notchRadius,
         edge: edge,
         notchSide: notchSide,
         borderRadius: borderRadius,
         side: side,
       );

  // Private canonical constructor — holds all fields.
  const FluxNotch._({
    this.boundary,
    required this.fallbackPosition,
    required this.boundaryOffset,
    required this.notchRadius,
    required this.edge,
    required this.notchSide,
    this.borderRadius,
    required this.side,
  });

  // ── Fields ─────────────────────────────────────────────────────────────────

  /// Slot boundary to snap the notch to. `null` when using [FluxNotch.free].
  final FluxSlotBoundary? boundary;

  /// Notch position used before boundary measurement completes, or as the
  /// sole position for [FluxNotch.free].
  final double fallbackPosition;

  /// Pixel offset applied to the measured boundary Y position.
  ///
  /// Positive values move the notch downward. Useful when a [FluxDivider]
  /// widget adds visual height at the boundary and the notch should align with
  /// the widget's centre rather than its top edge.
  final double boundaryOffset;

  /// Radius of the semicircular notch, in logical pixels.
  final double notchRadius;

  /// Which edges of the card receive notches.
  final FluxNotchEdge edge;

  /// Which side(s) of the chosen [edge] are notched.
  final FluxNotchSide notchSide;

  /// Corner radius of the card shape.
  ///
  /// When null, [FluxCard] inherits [FluxCardThemeData.borderRadius]
  /// automatically.
  final BorderRadius? borderRadius;

  /// Border drawn around the notch outline.
  ///
  /// Rendered as a `CustomPaint` layer above all card content so it is never
  /// occluded by backgrounds, media, or overlays.
  final BorderSide side;

  // ── Derived ────────────────────────────────────────────────────────────────

  /// Whether this notch uses post-layout boundary measurement.
  bool get isTargeted => boundary != null;

  // ── Internal factory helpers ───────────────────────────────────────────────

  /// Builds the [CustomPainter] that draws [side] on top of the card content.
  ///
  /// [resolvedBorderRadius] must already incorporate the theme fallback.
  // Inside class FluxNotch:
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