import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../core/enums.dart';

/// A [ShapeBorder] that draws a rounded rectangle with semicircular notches,
/// producing a ticket or coupon silhouette.
///
/// For full [FluxCard] integration — slot-boundary targeting, border painting
/// above content, and post-layout notch positioning — prefer [FluxNotch] on
/// [FluxCard.notch]. Use [FluxNotchShape] when you need a raw [ShapeBorder]
/// (e.g. for [FluxCardThemeData.shape] or animation with [ShapeBorder.lerp]).
class FluxNotchShape extends ShapeBorder {
  const FluxNotchShape({
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.notchRadius = 12.0,
    this.notchPosition = 0.5,
    this.notchEdge = FluxNotchEdge.vertical,
    this.notchSide = FluxNotchSide.both,
    this.side = BorderSide.none,
  });

  final BorderRadius borderRadius;
  final double notchRadius;

  /// Notch position as a 0.0–1.0 fraction of the edge length.
  final double notchPosition;
  final FluxNotchEdge notchEdge;
  final FluxNotchSide notchSide;
  final BorderSide side;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      NotchPathBuilder.build(
        rect: rect,
        borderRadius: borderRadius,
        notchPosition: notchPosition,
        notchRadius: notchRadius,
        notchEdge: notchEdge,
        notchSide: notchSide,
        textDirection: textDirection,
      );

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side == BorderSide.none) return;
    canvas.drawPath(getOuterPath(rect, textDirection: textDirection), side.toPaint());
  }

  @override
  ShapeBorder scale(double t) => FluxNotchShape(
    borderRadius: borderRadius * t,
    notchRadius: notchRadius * t,
    notchPosition: notchPosition,
    notchEdge: notchEdge,
    notchSide: notchSide,
    side: side.scale(t),
  );

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is FluxNotchShape) return FluxNotchShape._lerp(a, this, t);
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is FluxNotchShape) return FluxNotchShape._lerp(this, b, t);
    return super.lerpTo(b, t);
  }

  static FluxNotchShape _lerp(FluxNotchShape a, FluxNotchShape b, double t) =>
      FluxNotchShape(
        borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t) ?? a.borderRadius,
        notchRadius: lerpDouble(a.notchRadius, b.notchRadius, t) ?? a.notchRadius,
        notchPosition: lerpDouble(a.notchPosition, b.notchPosition, t) ?? a.notchPosition,
        notchEdge: t < 0.5 ? a.notchEdge : b.notchEdge,
        notchSide: t < 0.5 ? a.notchSide : b.notchSide,
        side: BorderSide.lerp(a.side, b.side, t),
      );
}

// ── Shared path builder ───────────────────────────────────────────────────────

/// Builds the notch contour path shared by [FluxNotchShape] and the internal
/// clipper and border painter used by [FluxCard].
///
/// The path is a single closed contour so notches are genuine concavities and
/// the shape clips and casts shadows correctly.
abstract final class NotchPathBuilder {
  static Path build({
    required Rect rect,
    required BorderRadius borderRadius,
    required double notchPosition,
    required double notchRadius,
    required FluxNotchEdge notchEdge,
    required FluxNotchSide notchSide,
    TextDirection? textDirection,
  }) {
    final rr = borderRadius.resolve(textDirection);
    final path = Path();
    if (notchEdge == FluxNotchEdge.vertical) {
      _buildVertical(path, rect, rr, notchPosition, notchRadius, notchSide);
    } else {
      _buildHorizontal(path, rect, rr, notchPosition, notchRadius, notchSide);
    }
    return path;
  }

  // ── Vertical (notches on left / right edges) ───────────────────────────────

  static void _buildVertical(
      Path path,
      Rect rect,
      BorderRadius rr,
      double pos,
      double nr,
      FluxNotchSide side,
      ) {
    final y = rect.top + rect.height * pos.clamp(0.0, 1.0);
    final hasLeft = side == FluxNotchSide.start || side == FluxNotchSide.both;
    final hasRight = side == FluxNotchSide.end || side == FluxNotchSide.both;

    // Path traversal is clockwise from top-left.
    path.moveTo(rect.left + rr.topLeft.x, rect.top);

    // ── Top edge → top-right corner ──
    path.lineTo(rect.right - rr.topRight.x, rect.top);
    path.arcToPoint(
      Offset(rect.right, rect.top + rr.topRight.y),
      radius: rr.topRight,
      clockwise: true,
    );

    // ── Right edge (going DOWN) + optional right notch ──
    if (hasRight) {
      path.lineTo(rect.right, y - nr);
      // Start: -π/2 (top of circle). Sweep: -π (CCW → bows LEFT into card). ✓
      path.arcTo(
        Rect.fromCircle(center: Offset(rect.right, y), radius: nr),
        -math.pi / 2,
        -math.pi,
        false,
      );
    }
    path.lineTo(rect.right, rect.bottom - rr.bottomRight.y);

    // ── Bottom-right corner → bottom edge → bottom-left corner ──
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

    // ── Left edge (going UP) + optional left notch ──
    if (hasLeft) {
      path.lineTo(rect.left, y + nr);
      // Start: π/2 (bottom of circle). Sweep: +π (CW → bows RIGHT into card). ✓
      // Previously -π which bowed LEFT (outward) — that was the bug.
      path.arcTo(
        Rect.fromCircle(center: Offset(rect.left, y), radius: nr),
        math.pi / 2,
        math.pi,
        false,
      );
    }
    path.lineTo(rect.left, rect.top + rr.topLeft.y);

    // ── Top-left corner → close ──
    path.arcToPoint(
      Offset(rect.left + rr.topLeft.x, rect.top),
      radius: rr.topLeft,
      clockwise: true,
    );
    path.close();
  }

  // ── Horizontal (notches on top / bottom edges) ────────────────────────────

  static void _buildHorizontal(
      Path path,
      Rect rect,
      BorderRadius rr,
      double pos,
      double nr,
      FluxNotchSide side,
      ) {
    final x = rect.left + rect.width * pos.clamp(0.0, 1.0);
    final hasTop = side == FluxNotchSide.start || side == FluxNotchSide.both;
    final hasBottom = side == FluxNotchSide.end || side == FluxNotchSide.both;

    path.moveTo(rect.left + rr.topLeft.x, rect.top);

    // ── Top edge (going RIGHT) + optional top notch ──
    if (hasTop) {
      path.lineTo(x - nr, rect.top);
      // Start: π (left of circle). Sweep: +π (CW → bows DOWN into card). ✓
      path.arcTo(
        Rect.fromCircle(center: Offset(x, rect.top), radius: nr),
        math.pi,
        math.pi,
        false,
      );
    }
    path.lineTo(rect.right - rr.topRight.x, rect.top);

    // ── Top-right corner → right edge → bottom-right corner ──
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

    // ── Bottom edge (going LEFT) + optional bottom notch ──
    if (hasBottom) {
      path.lineTo(x + nr, rect.bottom);
      // Start: 0 (right of circle). Sweep: -π (CCW → bows UP into card). ✓
      path.arcTo(
        Rect.fromCircle(center: Offset(x, rect.bottom), radius: nr),
        0,
        -math.pi,
        false,
      );
    }
    path.lineTo(rect.left + rr.bottomLeft.x, rect.bottom);

    // ── Bottom-left corner → left edge → top-left corner → close ──
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
}