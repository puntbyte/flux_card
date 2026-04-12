import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../core/enums.dart';

/// High-level ticket decoration for [FluxCard].
///
/// Unlike [FluxTicketShape] (a raw [ShapeBorder]), [FluxTicketDecoration] is
/// understood natively by [FluxCard] and adds:
///
/// - **Slot boundary targeting** via [notchAtBoundary] — the notch snaps to
///   the exact measured position between two slots, regardless of padding.
/// - **Pixel offset** via [notchBoundaryOffset] to nudge the notch from the
///   boundary (useful when a divider adds visual height at the boundary).
/// - **Correct border rendering** — the border is painted as a separate
///   `CustomPaint` layer on top of all card content, so it is always visible.
///
/// ### Usage
/// ```dart
/// FluxCard(
///   ticket: FluxTicketDecoration(
///     notchAtBoundary: FluxSlotBoundary.afterBody,
///     notchRadius: 14,
///     side: BorderSide(color: Colors.grey.shade300, width: 1.5),
///   ),
///   dividers: [
///     FluxSlotDivider.dashed(
///       boundary: FluxSlotBoundary.afterBody,
///       indent: 14,   // matches notchRadius
///       endIndent: 14,
///     ),
///   ],
///   ...
/// )
/// ```
class FluxTicketDecoration {
  const FluxTicketDecoration({
    this.notchAtBoundary,
    this.notchPosition = 0.5,
    this.notchBoundaryOffset = 0.0,
    this.notchRadius = 12.0,
    this.notchEdge = FluxNotchEdge.vertical,
    this.notchSide = FluxNotchSide.both,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.side = BorderSide.none,
  });

  /// Snaps the notch to a named slot boundary.
  ///
  /// [FluxCard] measures the rendered position of the boundary after the first
  /// layout and updates the clip and border painter automatically. Falls back
  /// to [notchPosition] until the measurement is available.
  final FluxSlotBoundary? notchAtBoundary;

  /// Fallback notch position as a 0.0–1.0 fraction of the card height.
  /// Used when [notchAtBoundary] is null or while the first frame is rendering.
  final double notchPosition;

  /// Pixel offset applied to the boundary Y position after measurement.
  ///
  /// Positive values move the notch downward. Useful when a [FluxSlotDivider]
  /// at the same boundary adds a few pixels of visual height.
  final double notchBoundaryOffset;

  final double notchRadius;
  final FluxNotchEdge notchEdge;
  final FluxNotchSide notchSide;

  /// Corner radius of the ticket rectangle. Should match
  /// [FluxCardThemeData.borderRadius] for a seamless look.
  final BorderRadius borderRadius;

  /// Border drawn around the ticket outline.
  ///
  /// Rendered as a `CustomPaint` layer above all card content so it is never
  /// occluded by backgrounds, media, or overlays.
  final BorderSide side;

  /// Creates the [CustomClipper] used by [FluxCard] to clip content to the
  /// ticket outline.
  FluxTicketClipper clipper(double resolvedPosition) => FluxTicketClipper(
    notchPosition: resolvedPosition,
    notchRadius: notchRadius,
    notchEdge: notchEdge,
    notchSide: notchSide,
    borderRadius: borderRadius,
  );

  /// Creates the [CustomPainter] that draws the ticket border on top of content.
  FluxTicketBorderPainter borderPainter(double resolvedPosition, TextDirection? td) =>
      FluxTicketBorderPainter(
        notchPosition: resolvedPosition,
        notchRadius: notchRadius,
        notchEdge: notchEdge,
        notchSide: notchSide,
        borderRadius: borderRadius,
        side: side,
        textDirection: td,
      );

  FluxTicketDecoration copyWith({
    FluxSlotBoundary? notchAtBoundary,
    double? notchPosition,
    double? notchBoundaryOffset,
    double? notchRadius,
    FluxNotchEdge? notchEdge,
    FluxNotchSide? notchSide,
    BorderRadius? borderRadius,
    BorderSide? side,
  }) => FluxTicketDecoration(
    notchAtBoundary: notchAtBoundary ?? this.notchAtBoundary,
    notchPosition: notchPosition ?? this.notchPosition,
    notchBoundaryOffset: notchBoundaryOffset ?? this.notchBoundaryOffset,
    notchRadius: notchRadius ?? this.notchRadius,
    notchEdge: notchEdge ?? this.notchEdge,
    notchSide: notchSide ?? this.notchSide,
    borderRadius: borderRadius ?? this.borderRadius,
    side: side ?? this.side,
  );
}

// ── Clipper ───────────────────────────────────────────────────────────────────

/// [CustomClipper] that clips a widget to a ticket outline.
class FluxTicketClipper extends CustomClipper<Path> {
  const FluxTicketClipper({
    required this.notchPosition,
    required this.notchRadius,
    required this.notchEdge,
    required this.notchSide,
    required this.borderRadius,
  });

  final double notchPosition;
  final double notchRadius;
  final FluxNotchEdge notchEdge;
  final FluxNotchSide notchSide;
  final BorderRadius borderRadius;

  @override
  Path getClip(Size size) => TicketPathBuilder.build(
    rect: Offset.zero & size,
    borderRadius: borderRadius,
    notchPosition: notchPosition,
    notchRadius: notchRadius,
    notchEdge: notchEdge,
    notchSide: notchSide,
  );

  @override
  bool shouldReclip(FluxTicketClipper old) =>
      old.notchPosition != notchPosition ||
      old.notchRadius != notchRadius ||
      old.notchEdge != notchEdge ||
      old.notchSide != notchSide ||
      old.borderRadius != borderRadius;
}

// ── Border painter ────────────────────────────────────────────────────────────

/// [CustomPainter] that draws a ticket border outline on top of card content.
class FluxTicketBorderPainter extends CustomPainter {
  const FluxTicketBorderPainter({
    required this.notchPosition,
    required this.notchRadius,
    required this.notchEdge,
    required this.notchSide,
    required this.borderRadius,
    required this.side,
    this.textDirection,
  });

  final double notchPosition;
  final double notchRadius;
  final FluxNotchEdge notchEdge;
  final FluxNotchSide notchSide;
  final BorderRadius borderRadius;
  final BorderSide side;
  final TextDirection? textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    if (side == BorderSide.none || side.width == 0) return;
    final path = TicketPathBuilder.build(
      rect: Offset.zero & size,
      borderRadius: borderRadius,
      notchPosition: notchPosition,
      notchRadius: notchRadius,
      notchEdge: notchEdge,
      notchSide: notchSide,
      textDirection: textDirection,
    );
    canvas.drawPath(path, side.toPaint());
  }

  @override
  bool shouldRepaint(FluxTicketBorderPainter old) =>
      old.notchPosition != notchPosition ||
      old.notchRadius != notchRadius ||
      old.notchEdge != notchEdge ||
      old.notchSide != notchSide ||
      old.borderRadius != borderRadius ||
      old.side != side;
}

// ── Shared path builder ───────────────────────────────────────────────────────

/// Builds the ticket contour path shared by [FluxTicketClipper],
/// [FluxTicketBorderPainter], and [FluxTicketShape].
///
/// The path is a single closed contour — no evenOdd tricks — so the notches
/// are genuine concavities and the shape clips/shadows correctly.
abstract final class TicketPathBuilder {
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

    path.moveTo(rect.left + rr.topLeft.x, rect.top);

    // Top edge → top-right corner
    path.lineTo(rect.right - rr.topRight.x, rect.top);
    path.arcToPoint(
      Offset(rect.right, rect.top + rr.topRight.y),
      radius: rr.topRight,
      clockwise: true,
    );

    // Right edge + optional notch
    if (hasRight) {
      path.lineTo(rect.right, y - nr);
      path.arcTo(
        Rect.fromCircle(center: Offset(rect.right, y), radius: nr),
        -math.pi / 2,
        -math.pi,
        false,
      );
    }
    path.lineTo(rect.right, rect.bottom - rr.bottomRight.y);

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

    // Left edge + optional notch
    if (hasLeft) {
      path.lineTo(rect.left, y + nr);
      path.arcTo(
        Rect.fromCircle(center: Offset(rect.left, y), radius: nr),
        math.pi / 2,
        -math.pi,
        false,
      );
    }
    path.lineTo(rect.left, rect.top + rr.topLeft.y);

    // Top-left corner → close
    path.arcToPoint(
      Offset(rect.left + rr.topLeft.x, rect.top),
      radius: rr.topLeft,
      clockwise: true,
    );
    path.close();
  }

  // ── Horizontal (notches on top / bottom edges) ─────────────────────────────

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

    // Top edge + optional notch
    if (hasTop) {
      path.lineTo(x - nr, rect.top);
      path.arcTo(Rect.fromCircle(center: Offset(x, rect.top), radius: nr), math.pi, math.pi, false);
    }
    path.lineTo(rect.right - rr.topRight.x, rect.top);

    // Top-right → right edge → bottom-right
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

    // Bottom edge + optional notch
    if (hasBottom) {
      path.lineTo(x + nr, rect.bottom);
      path.arcTo(Rect.fromCircle(center: Offset(x, rect.bottom), radius: nr), 0, -math.pi, false);
    }
    path.lineTo(rect.left + rr.bottomLeft.x, rect.bottom);

    // Bottom-left → left edge → top-left → close
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

// ── lerpDouble re-export for FluxTicketShape compatibility ────────────────────
// ignore: unused_element
double? _lerp(double? a, double? b, double t) => lerpDouble(a, b, t);
