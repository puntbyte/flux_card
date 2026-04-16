import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../core/enums.dart';

class FluxNotchShape extends OutlinedBorder {
  const FluxNotchShape({
    this.borderRadius = BorderRadius.zero,
    this.kind = FluxNotchKind.ticket,
    this.notchDepth = 12.0,
    this.notchWidth,
    this.notchPosition = 0.5,
    this.notchPositionResolver,
    this.notchEdge = FluxNotchEdge.vertical,
    this.notchSide = FluxNotchSide.both,
    super.side = BorderSide.none,
  });

  final BorderRadius borderRadius;
  final FluxNotchKind kind;

  /// How far the notch cuts inward from the outer edge.
  final double notchDepth;

  /// Width of non-circular notch kinds.
  ///
  /// For [FluxNotchKind.ticket], this is ignored and the circular notch
  /// diameter is derived from [notchDepth].
  final double? notchWidth;

  /// 0.0–1.0 fraction of the edge where the notch is placed.
  final double notchPosition;

  /// Optional dynamic post-layout resolver used by boundary-targeted notches.
  final double? Function(Rect rect)? notchPositionResolver;

  final FluxNotchEdge notchEdge;
  final FluxNotchSide notchSide;

  double get effectiveNotchWidth {
    if (kind == FluxNotchKind.ticket) {
      return notchDepth * 2;
    }

    return notchWidth ?? (notchDepth * 2.25);
  }

  double _resolvedPosition(Rect rect) {
    final resolved = notchPositionResolver?.call(rect) ?? notchPosition;
    return resolved.clamp(0.0, 1.0);
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) {
    return FluxNotchShape(
      borderRadius: BorderRadius.lerp(BorderRadius.zero, borderRadius, t) ?? borderRadius,
      kind: kind,
      notchDepth: (notchDepth * t).clamp(0.0, double.infinity),
      notchWidth: notchWidth == null ? null : (notchWidth! * t).clamp(0.0, double.infinity),
      notchPosition: notchPosition,
      notchPositionResolver: notchPositionResolver,
      notchEdge: notchEdge,
      notchSide: notchSide,
      side: side.scale(t),
    );
  }

  @override
  FluxNotchShape copyWith({BorderSide? side}) {
    return FluxNotchShape(
      borderRadius: borderRadius,
      kind: kind,
      notchDepth: notchDepth,
      notchWidth: notchWidth,
      notchPosition: notchPosition,
      notchPositionResolver: notchPositionResolver,
      notchEdge: notchEdge,
      notchSide: notchSide,
      side: side ?? this.side,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return NotchPathBuilder.build(
      rect: rect,
      borderRadius: borderRadius,
      kind: kind,
      notchPosition: _resolvedPosition(rect),
      notchDepth: notchDepth,
      notchWidth: effectiveNotchWidth,
      notchEdge: notchEdge,
      notchSide: notchSide,
      textDirection: textDirection,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final deflatedRect = rect.deflate(side.width);
    final deflatedRadius = _deflateBorderRadius(borderRadius, side.width);

    return NotchPathBuilder.build(
      rect: deflatedRect,
      borderRadius: deflatedRadius,
      kind: kind,
      notchPosition: _resolvedPosition(rect),
      notchDepth: (notchDepth - side.width).clamp(0.0, double.infinity),
      notchWidth: (effectiveNotchWidth - side.width).clamp(0.0, double.infinity),
      notchEdge: notchEdge,
      notchSide: notchSide,
      textDirection: textDirection,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none || side.width == 0) {
      return;
    }

    final path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(path, side.toPaint());
  }

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

  static FluxNotchShape _lerp(FluxNotchShape a, FluxNotchShape b, double t) {
    return FluxNotchShape(
      borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t) ?? a.borderRadius,
      kind: t < 0.5 ? a.kind : b.kind,
      notchDepth: lerpDouble(a.notchDepth, b.notchDepth, t) ?? a.notchDepth,
      notchWidth: switch ((a.notchWidth, b.notchWidth)) {
        (null, null) => null,
        (final aw?, final bw?) => lerpDouble(aw, bw, t),
        (final aw?, null) => lerpDouble(aw, b.effectiveNotchWidth, t),
        (null, final bw?) => lerpDouble(a.effectiveNotchWidth, bw, t),
      },
      notchPosition: lerpDouble(a.notchPosition, b.notchPosition, t) ?? a.notchPosition,
      notchPositionResolver: t < 0.5 ? a.notchPositionResolver : b.notchPositionResolver,
      notchEdge: t < 0.5 ? a.notchEdge : b.notchEdge,
      notchSide: t < 0.5 ? a.notchSide : b.notchSide,
      side: BorderSide.lerp(a.side, b.side, t),
    );
  }

  static BorderRadius _deflateBorderRadius(BorderRadius radius, double amount) {
    Radius deflate(Radius r) => Radius.elliptical(
      (r.x - amount).clamp(0.0, double.infinity),
      (r.y - amount).clamp(0.0, double.infinity),
    );

    return BorderRadius.only(
      topLeft: deflate(radius.topLeft),
      topRight: deflate(radius.topRight),
      bottomLeft: deflate(radius.bottomLeft),
      bottomRight: deflate(radius.bottomRight),
    );
  }
}

abstract final class NotchPathBuilder {
  static Path build({
    required Rect rect,
    required BorderRadius borderRadius,
    required FluxNotchKind kind,
    required double notchPosition,
    required double notchDepth,
    required double notchWidth,
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

    if (notchDepth <= 0) {
      return outer;
    }

    final cuts = Path();
    bool hasCuts = false;
    final pos = notchPosition.clamp(0.0, 1.0);

    final bool startOnLeft = textDirection != TextDirection.rtl;

    void addStartCut(Path cut) {
      cuts.addPath(cut, Offset.zero);
      hasCuts = true;
    }

    void addEndCut(Path cut) {
      cuts.addPath(cut, Offset.zero);
      hasCuts = true;
    }

    if (notchEdge == FluxNotchEdge.vertical) {
      final y = rect.top + rect.height * pos;

      if (notchSide == FluxNotchSide.start || notchSide == FluxNotchSide.both) {
        addStartCut(
          _buildVerticalCut(
            rect: rect,
            kind: kind,
            y: y,
            depth: notchDepth,
            width: notchWidth,
            isStartSide: startOnLeft,
          ),
        );
      }

      if (notchSide == FluxNotchSide.end || notchSide == FluxNotchSide.both) {
        addEndCut(
          _buildVerticalCut(
            rect: rect,
            kind: kind,
            y: y,
            depth: notchDepth,
            width: notchWidth,
            isStartSide: !startOnLeft,
          ),
        );
      }
    } else {
      final x = rect.left + rect.width * pos;

      if (notchSide == FluxNotchSide.start || notchSide == FluxNotchSide.both) {
        addStartCut(
          _buildHorizontalCut(
            rect: rect,
            kind: kind,
            x: x,
            depth: notchDepth,
            width: notchWidth,
            isStartSide: true,
          ),
        );
      }

      if (notchSide == FluxNotchSide.end || notchSide == FluxNotchSide.both) {
        addEndCut(
          _buildHorizontalCut(
            rect: rect,
            kind: kind,
            x: x,
            depth: notchDepth,
            width: notchWidth,
            isStartSide: false,
          ),
        );
      }
    }

    if (!hasCuts) {
      return outer;
    }

    return Path.combine(PathOperation.difference, outer, cuts);
  }

  static Path _buildVerticalCut({
    required Rect rect,
    required FluxNotchKind kind,
    required double y,
    required double depth,
    required double width,
    required bool isStartSide,
  }) {
    switch (kind) {
      case FluxNotchKind.ticket:
        return _buildTicketVerticalCut(rect: rect, y: y, radius: depth, isStartSide: isStartSide);
      case FluxNotchKind.vShape:
        return _buildVVerticalCut(
          rect: rect,
          y: y,
          depth: depth,
          width: width,
          isStartSide: isStartSide,
        );
      case FluxNotchKind.slant:
        return _buildSlantVerticalCut(
          rect: rect,
          y: y,
          depth: depth,
          width: width,
          isStartSide: isStartSide,
        );
    }
  }

  static Path _buildHorizontalCut({
    required Rect rect,
    required FluxNotchKind kind,
    required double x,
    required double depth,
    required double width,
    required bool isStartSide,
  }) {
    switch (kind) {
      case FluxNotchKind.ticket:
        return _buildTicketHorizontalCut(rect: rect, x: x, radius: depth, isStartSide: isStartSide);
      case FluxNotchKind.vShape:
        return _buildVHorizontalCut(
          rect: rect,
          x: x,
          depth: depth,
          width: width,
          isStartSide: isStartSide,
        );
      case FluxNotchKind.slant:
        return _buildSlantHorizontalCut(
          rect: rect,
          x: x,
          depth: depth,
          width: width,
          isStartSide: isStartSide,
        );
    }
  }

  static Path _buildTicketVerticalCut({
    required Rect rect,
    required double y,
    required double radius,
    required bool isStartSide,
  }) {
    final edgeX = isStartSide ? rect.left : rect.right;
    return Path()..addOval(Rect.fromCircle(center: Offset(edgeX, y), radius: radius));
  }

  static Path _buildTicketHorizontalCut({
    required Rect rect,
    required double x,
    required double radius,
    required bool isStartSide,
  }) {
    final edgeY = isStartSide ? rect.top : rect.bottom;
    return Path()..addOval(Rect.fromCircle(center: Offset(x, edgeY), radius: radius));
  }

  static Path _buildVVerticalCut({
    required Rect rect,
    required double y,
    required double depth,
    required double width,
    required bool isStartSide,
  }) {
    final halfWidth = width / 2;
    final edgeX = isStartSide ? rect.left : rect.right;
    final innerX = isStartSide ? rect.left + depth : rect.right - depth;

    return Path()
      ..moveTo(edgeX, y - halfWidth)
      ..lineTo(innerX, y)
      ..lineTo(edgeX, y + halfWidth)
      ..close();
  }

  static Path _buildVHorizontalCut({
    required Rect rect,
    required double x,
    required double depth,
    required double width,
    required bool isStartSide,
  }) {
    final halfWidth = width / 2;
    final edgeY = isStartSide ? rect.top : rect.bottom;
    final innerY = isStartSide ? rect.top + depth : rect.bottom - depth;

    return Path()
      ..moveTo(x - halfWidth, edgeY)
      ..lineTo(x, innerY)
      ..lineTo(x + halfWidth, edgeY)
      ..close();
  }

  static Path _buildSlantVerticalCut({
    required Rect rect,
    required double y,
    required double depth,
    required double width,
    required bool isStartSide,
  }) {
    final halfWidth = width / 2;
    final edgeX = isStartSide ? rect.left : rect.right;
    final innerX = isStartSide ? rect.left + depth : rect.right - depth;
    final lowerInset = halfWidth * 0.35;

    return Path()
      ..moveTo(edgeX, y - halfWidth)
      ..lineTo(innerX, y - halfWidth * 0.10)
      ..lineTo(innerX, y + halfWidth)
      ..lineTo(edgeX, y + lowerInset)
      ..close();
  }

  static Path _buildSlantHorizontalCut({
    required Rect rect,
    required double x,
    required double depth,
    required double width,
    required bool isStartSide,
  }) {
    final halfWidth = width / 2;
    final edgeY = isStartSide ? rect.top : rect.bottom;
    final innerY = isStartSide ? rect.top + depth : rect.bottom - depth;
    final trailingInset = halfWidth * 0.35;

    return Path()
      ..moveTo(x - halfWidth, edgeY)
      ..lineTo(x - halfWidth * 0.10, innerY)
      ..lineTo(x + halfWidth, innerY)
      ..lineTo(x + trailingInset, edgeY)
      ..close();
  }
}
