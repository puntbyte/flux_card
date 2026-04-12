import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../core/enums.dart';

/// A [ShapeBorder] that draws a rounded rectangle with semicircular notches
/// cut from its edges, producing a ticket or coupon appearance.
///
/// The path is built as a single closed contour (no evenOdd tricks), so the
/// notches are genuine concavities in the outline. This means Material's clip,
/// shadow, and ink-ripple all respect the exact ticket silhouette.
///
/// ```dart
/// FluxCard(
///   theme: FluxCardThemeData.elevated.copyWith(
///     shape: FluxTicketShape(
///       notchRadius: 14,
///       notchPosition: 0.62,
///     ),
///   ),
/// )
/// ```
class FluxTicketShape extends ShapeBorder {
  const FluxTicketShape({
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.notchRadius = 12.0,
    this.notchPosition = 0.5,
    this.notchEdge = FluxNotchEdge.vertical,
    this.notchSide = FluxNotchSide.both,
    this.side = BorderSide.none,
  });

  /// Corner radius of the outer rounded rectangle.
  final BorderRadius borderRadius;

  /// Radius of each semicircular notch.
  final double notchRadius;

  /// Position of the notch centre along the notch edge, 0.0 = start, 1.0 = end.
  final double notchPosition;

  /// Which pair of edges receives notches.
  final FluxNotchEdge notchEdge;

  /// Whether to notch the start edge, end edge, or both.
  final FluxNotchSide notchSide;

  /// Optional border stroke.
  final BorderSide side;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final rr = borderRadius.resolve(textDirection);
    final path = Path();

    if (notchEdge == FluxNotchEdge.vertical) {
      _buildVerticalPath(path, rect, rr);
    } else {
      _buildHorizontalPath(path, rect, rr);
    }

    return path;
  }

  // ── Vertical ticket (notches on left / right edges) ───────────────────────

  void _buildVerticalPath(Path path, Rect rect, BorderRadius rr) {
    final y = rect.top + rect.height * notchPosition.clamp(0.0, 1.0);
    final nr = notchRadius;
    final hasLeft =
        notchSide == FluxNotchSide.start || notchSide == FluxNotchSide.both;
    final hasRight =
        notchSide == FluxNotchSide.end || notchSide == FluxNotchSide.both;

    // ── Start: top-left corner, moving clockwise ──
    path.moveTo(rect.left + rr.topLeft.x, rect.top);

    // Top edge → top-right corner
    path.lineTo(rect.right - rr.topRight.x, rect.top);
    path.arcToPoint(
      Offset(rect.right, rect.top + rr.topRight.y),
      radius: rr.topRight,
      clockwise: true,
    );

    // Right edge, top segment → right notch → bottom segment
    if (hasRight) {
      path.lineTo(rect.right, y - nr);
      // Concave arc: from top of notch circle (-π/2) going counter-clockwise
      // by -π, sweeping left (INTO the card) through to the bottom point.
      path.arcTo(
        Rect.fromCircle(center: Offset(rect.right, y), radius: nr),
        -math.pi / 2, // start: pointing up
        -math.pi, // sweep: CCW → goes left (inward) then down
        false,
      );
      path.lineTo(rect.right, rect.bottom - rr.bottomRight.y);
    } else {
      path.lineTo(rect.right, rect.bottom - rr.bottomRight.y);
    }

    // Bottom-right corner → bottom edge → bottom-left corner
    path.arcToPoint(
      Offset(rect.right - rr.bottomRight.x, rect.bottom),
      radius: rr.bottomRight,
      clockwise: true,
    );
    path.lineTo(rect.left + rr.bottomLeft.x, rect.bottom);
    path.arcToPoint(
      Offset(rect.left, rect.bottom - rr.bottomLeft.y),
      radius: rr.bottomLeft,
      clockwise: true,
    );

    // Left edge, bottom segment → left notch → top segment
    if (hasLeft) {
      path.lineTo(rect.left, y + nr);
      // Concave arc: from bottom of notch circle (π/2) going counter-clockwise
      // by -π, sweeping right (INTO the card) through to the top point.
      path.arcTo(
        Rect.fromCircle(center: Offset(rect.left, y), radius: nr),
        math.pi / 2, // start: pointing down
        -math.pi, // sweep: CCW → goes right (inward) then up
        false,
      );
      path.lineTo(rect.left, rect.top + rr.topLeft.y);
    } else {
      path.lineTo(rect.left, rect.top + rr.topLeft.y);
    }

    // Top-left corner → close
    path.arcToPoint(
      Offset(rect.left + rr.topLeft.x, rect.top),
      radius: rr.topLeft,
      clockwise: true,
    );
    path.close();
  }

  // ── Horizontal ticket (notches on top / bottom edges) ─────────────────────

  void _buildHorizontalPath(Path path, Rect rect, BorderRadius rr) {
    final x = rect.left + rect.width * notchPosition.clamp(0.0, 1.0);
    final nr = notchRadius;
    final hasTop =
        notchSide == FluxNotchSide.start || notchSide == FluxNotchSide.both;
    final hasBottom =
        notchSide == FluxNotchSide.end || notchSide == FluxNotchSide.both;

    // ── Start: top-left corner, moving clockwise ──
    path.moveTo(rect.left + rr.topLeft.x, rect.top);

    // Top edge: left segment → top notch → right segment → top-right corner
    if (hasTop) {
      path.lineTo(x - nr, rect.top);
      // Concave arc: from left of notch circle (π) going clockwise by +π,
      // sweeping down (INTO the card) through to the right point.
      path.arcTo(
        Rect.fromCircle(center: Offset(x, rect.top), radius: nr),
        math.pi, // start: pointing left
        math.pi, // sweep: CW → goes down (inward) then right
        false,
      );
      path.lineTo(rect.right - rr.topRight.x, rect.top);
    } else {
      path.lineTo(rect.right - rr.topRight.x, rect.top);
    }

    // Top-right corner → right edge → bottom-right corner
    path.arcToPoint(
      Offset(rect.right, rect.top + rr.topRight.y),
      radius: rr.topRight,
      clockwise: true,
    );
    path.lineTo(rect.right, rect.bottom - rr.bottomRight.y);
    path.arcToPoint(
      Offset(rect.right - rr.bottomRight.x, rect.bottom),
      radius: rr.bottomRight,
      clockwise: true,
    );

    // Bottom edge: right segment → bottom notch → left segment → bottom-left corner
    if (hasBottom) {
      path.lineTo(x + nr, rect.bottom);
      // Concave arc: from right of notch circle (0) going counter-clockwise
      // by -π, sweeping up (INTO the card) through to the left point.
      path.arcTo(
        Rect.fromCircle(center: Offset(x, rect.bottom), radius: nr),
        0, // start: pointing right
        -math.pi, // sweep: CCW → goes up (inward) then left
        false,
      );
      path.lineTo(rect.left + rr.bottomLeft.x, rect.bottom);
    } else {
      path.lineTo(rect.left + rr.bottomLeft.x, rect.bottom);
    }

    // Bottom-left corner → left edge → top-left corner → close
    path.arcToPoint(
      Offset(rect.left, rect.bottom - rr.bottomLeft.y),
      radius: rr.bottomLeft,
      clockwise: true,
    );
    path.lineTo(rect.left, rect.top + rr.topLeft.y);
    path.arcToPoint(
      Offset(rect.left + rr.topLeft.x, rect.top),
      radius: rr.topLeft,
      clockwise: true,
    );
    path.close();
  }

  // ── ShapeBorder overrides ─────────────────────────────────────────────────

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side == BorderSide.none) return;
    canvas.drawPath(getOuterPath(rect, textDirection: textDirection), side.toPaint());
  }

  @override
  ShapeBorder scale(double t) => FluxTicketShape(
    borderRadius: borderRadius * t,
    notchRadius: notchRadius * t,
    notchPosition: notchPosition,
    notchEdge: notchEdge,
    notchSide: notchSide,
    side: side.scale(t),
  );

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is FluxTicketShape) return FluxTicketShape._lerp(a, this, t);
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is FluxTicketShape) return FluxTicketShape._lerp(this, b, t);
    return super.lerpTo(b, t);
  }

  static FluxTicketShape _lerp(FluxTicketShape a, FluxTicketShape b, double t) =>
      FluxTicketShape(
        borderRadius:
        BorderRadius.lerp(a.borderRadius, b.borderRadius, t) ?? a.borderRadius,
        notchRadius: lerpDouble(a.notchRadius, b.notchRadius, t) ?? a.notchRadius,
        notchPosition:
        lerpDouble(a.notchPosition, b.notchPosition, t) ?? a.notchPosition,
        notchEdge: t < 0.5 ? a.notchEdge : b.notchEdge,
        notchSide: t < 0.5 ? a.notchSide : b.notchSide,
        side: BorderSide.lerp(a.side, b.side, t),
      );
}