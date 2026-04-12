import 'package:flutter/material.dart';

import '../core/enums.dart';

/// Declares which widget to render at each slot boundary inside a [FluxCard].
///
/// Pass one [FluxDivider] to [FluxCard.divider]. Each property corresponds to
/// one named slot boundary; set only the boundaries you need.
///
/// The divider widget is rendered between the half-padding of the slot above
/// and the half-padding of the slot below, so it sits centred in the gap.
///
/// ```dart
/// // Standard Divider between body and footer:
/// FluxCard(
///   divider: const FluxDivider(afterBody: Divider()),
/// )
///
/// // Perforated line aligned with a notch (indent = notchRadius):
/// FluxCard(
///   notch: FluxNotch(boundary: FluxSlotBoundary.afterHeader, notchRadius: 14),
///   divider: FluxDivider(
///     afterHeader: FluxDashedDivider(indent: 14, endIndent: 14),
///   ),
/// )
///
/// // Any widget works — custom branded separator:
/// FluxCard(
///   divider: const FluxDivider(afterBody: MyBrandedSeparator()),
/// )
/// ```
class FluxDivider {
  const FluxDivider({
    this.afterMedia,
    this.afterHeader,
    this.afterBody,
  });

  /// Widget rendered between the media slot and the content group.
  final Widget? afterMedia;

  /// Widget rendered between the header and body slots.
  final Widget? afterHeader;

  /// Widget rendered between the body and footer slots.
  final Widget? afterBody;

  /// Returns the widget configured for [boundary], or `null` if none is set.
  Widget? widgetFor(FluxSlotBoundary boundary) => switch (boundary) {
    FluxSlotBoundary.afterMedia => afterMedia,
    FluxSlotBoundary.afterHeader => afterHeader,
    FluxSlotBoundary.afterBody => afterBody,
  };
}

// ── FluxDashedDivider ─────────────────────────────────────────────────────────

/// A horizontal dashed (perforated) line — the canonical divider for
/// notch-style cards.
///
/// Set [indent] and [endIndent] to the notch radius so the dashes start and
/// end exactly where the notch semicircles begin, creating a continuous
/// perforated tear-line illusion.
///
/// ```dart
/// FluxDashedDivider(indent: 14, endIndent: 14)
/// ```
class FluxDashedDivider extends StatelessWidget {
  const FluxDashedDivider({
    super.key,
    this.color,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.dashWidth = 5.0,
    this.gapWidth = 4.0,
  });

  /// Dash colour. Defaults to [ThemeData.dividerColor].
  final Color? color;

  /// Height of the dash stroke in logical pixels.
  final double thickness;

  /// Leading inset from the left edge.
  final double indent;

  /// Trailing inset from the right edge.
  final double endIndent;

  /// Width of each dash segment.
  final double dashWidth;

  /// Width of each gap between segments.
  final double gapWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: thickness,
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: color ?? Theme.of(context).dividerColor,
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