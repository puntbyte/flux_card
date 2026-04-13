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
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => NotchPathBuilder.build(
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

  static FluxNotchShape _lerp(FluxNotchShape a, FluxNotchShape b, double t) => FluxNotchShape(
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
/// The path is a single closed contour with true cut-outs, so the shape clips
/// and casts shadows correctly.
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

    final outer = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: rr.topLeft,
          topRight: rr.topRight,
          bottomLeft: rr.bottomLeft,
          bottomRight: rr.bottomRight,
        ),
      );

    final cuts = Path();
    var hasCuts = false;

    final pos = notchPosition.clamp(0.0, 1.0);

    if (notchEdge == FluxNotchEdge.vertical) {
      final y = rect.top + rect.height * pos;

      if (notchSide == FluxNotchSide.start || notchSide == FluxNotchSide.both) {
        cuts.addOval(Rect.fromCircle(center: Offset(rect.left, y), radius: notchRadius));
        hasCuts = true;
      }

      if (notchSide == FluxNotchSide.end || notchSide == FluxNotchSide.both) {
        cuts.addOval(Rect.fromCircle(center: Offset(rect.right, y), radius: notchRadius));
        hasCuts = true;
      }
    } else {
      final x = rect.left + rect.width * pos;

      if (notchSide == FluxNotchSide.start || notchSide == FluxNotchSide.both) {
        cuts.addOval(Rect.fromCircle(center: Offset(x, rect.top), radius: notchRadius));
        hasCuts = true;
      }

      if (notchSide == FluxNotchSide.end || notchSide == FluxNotchSide.both) {
        cuts.addOval(Rect.fromCircle(center: Offset(x, rect.bottom), radius: notchRadius));
        hasCuts = true;
      }
    }

    if (!hasCuts) return outer;

    return Path.combine(PathOperation.difference, outer, cuts);
  }
}
