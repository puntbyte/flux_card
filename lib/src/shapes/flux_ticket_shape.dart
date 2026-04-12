import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../ticket/flux_ticket_decoration.dart';

/// A [ShapeBorder] that draws a rounded rectangle with semicircular notches,
/// producing a ticket or coupon silhouette.
///
/// For full [FluxCard] integration — slot-boundary targeting, border painting
/// above content, and post-layout notch positioning — prefer
/// [FluxTicketDecoration] on [FluxCard.ticket]. Use [FluxTicketShape] when
/// you need a raw [ShapeBorder] (e.g. for [Material.shape] directly or for
/// animation with [ShapeBorder.lerp]).
class FluxTicketShape extends ShapeBorder {
  const FluxTicketShape({
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
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => TicketPathBuilder.build(
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

  static FluxTicketShape _lerp(FluxTicketShape a, FluxTicketShape b, double t) => FluxTicketShape(
    borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t) ?? a.borderRadius,
    notchRadius: lerpDouble(a.notchRadius, b.notchRadius, t) ?? a.notchRadius,
    notchPosition: lerpDouble(a.notchPosition, b.notchPosition, t) ?? a.notchPosition,
    notchEdge: t < 0.5 ? a.notchEdge : b.notchEdge,
    notchSide: t < 0.5 ? a.notchSide : b.notchSide,
    side: BorderSide.lerp(a.side, b.side, t),
  );
}
