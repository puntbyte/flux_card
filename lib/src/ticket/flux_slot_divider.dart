import 'package:flutter/material.dart';

import '../core/enums.dart';

/// A visual separator inserted between two adjacent [FluxCard] slots.
///
/// Dividers are declared on [FluxCard.dividers] and rendered at the boundary
/// specified by [boundary]. They replace the plain spacing gap that would
/// normally appear between the two slots.
///
/// ```dart
/// // Standard Material divider between body and footer:
/// FluxSlotDivider(boundary: FluxSlotBoundary.afterBody)
///
/// // Perforated ticket line — indent matches the notch radius so the dashes
/// // start and end where the semicircular notch arcs begin:
/// FluxSlotDivider.dashed(
///   boundary: FluxSlotBoundary.afterBody,
///   indent: 14,
///   endIndent: 14,
/// )
///
/// // Fully custom divider widget:
/// FluxSlotDivider(
///   boundary: FluxSlotBoundary.afterHeader,
///   child: MyBrandedSeparator(),
/// )
/// ```
class FluxSlotDivider {
  const FluxSlotDivider({
    required this.boundary,
    this.child,
    this.color,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
  }) : _dashed = false,
       dashWidth = 5.0,
       gapWidth = 4.0;

  /// Perforated / dashed divider — common for ticket-style cards.
  ///
  /// Set [indent] and [endIndent] to `notchRadius` so the dashes begin and
  /// end exactly where the ticket notch arcs start, creating the illusion of
  /// a continuous perforated tear line.
  const FluxSlotDivider.dashed({
    required this.boundary,
    this.color,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.dashWidth = 5.0,
    this.gapWidth = 4.0,
  }) : _dashed = true,
       child = null;

  /// Which slot boundary this divider sits at.
  final FluxSlotBoundary boundary;

  /// Optional fully custom widget. When provided, all other visual properties
  /// ([color], [thickness], [indent], etc.) are ignored.
  final Widget? child;

  final Color? color;
  final double thickness;
  final double indent;
  final double endIndent;

  final bool _dashed;
  final double dashWidth;
  final double gapWidth;

  /// Builds the divider widget for rendering.
  Widget build(BuildContext context) {
    if (child != null) return child!;

    if (_dashed) {
      return _DashedDivider(
        color: color ?? Theme.of(context).dividerColor,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
        dashWidth: dashWidth,
        gapWidth: gapWidth,
      );
    }

    return Divider(
      color: color,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      height: thickness,
    );
  }
}

// ── Internal implementation ───────────────────────────────────────────────────

class _DashedDivider extends StatelessWidget {
  const _DashedDivider({
    required this.color,
    required this.thickness,
    required this.indent,
    required this.endIndent,
    required this.dashWidth,
    required this.gapWidth,
  });

  final Color color;
  final double thickness;
  final double indent;
  final double endIndent;
  final double dashWidth;
  final double gapWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: thickness,
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: color,
          thickness: thickness,
          indent: indent,
          endIndent: endIndent,
          dashWidth: dashWidth,
          gapWidth: gapWidth,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({
    required this.color,
    required this.thickness,
    required this.indent,
    required this.endIndent,
    required this.dashWidth,
    required this.gapWidth,
  });

  final Color color;
  final double thickness;
  final double indent;
  final double endIndent;
  final double dashWidth;
  final double gapWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    final y = size.height / 2;
    double x = indent;
    final endX = size.width - endIndent;

    while (x < endX) {
      final dashEnd = (x + dashWidth).clamp(x, endX);
      canvas.drawLine(Offset(x, y), Offset(dashEnd, y), paint);
      x += dashWidth + gapWidth;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) =>
      old.color != color ||
      old.thickness != thickness ||
      old.indent != indent ||
      old.endIndent != endIndent ||
      old.dashWidth != dashWidth ||
      old.gapWidth != gapWidth;
}
