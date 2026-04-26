import 'package:flutter/material.dart';

import '../core/enums.dart';

class FluxDivider {
  const FluxDivider({this.afterMedia, this.afterHeader, this.afterBody});

  final Widget? afterMedia;
  final Widget? afterHeader;
  final Widget? afterBody;

  Widget? widgetFor(FluxSlotBoundary boundary) => switch (boundary) {
    FluxSlotBoundary.afterMedia => afterMedia,
    FluxSlotBoundary.afterHeader => afterHeader,
    FluxSlotBoundary.afterBody => afterBody,
  };
}

/// A horizontal dashed (perforated) line — the canonical divider for
/// notch-style cards.
class FluxDashedDivider extends StatelessWidget {
  const FluxDashedDivider({
    super.key,
    this.color,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.dashWidth = 5.0,
    this.gapWidth = 4.0,
    this.alignment = MainAxisAlignment.center,
  });

  final Color? color;
  final double thickness;
  final double indent;
  final double endIndent;
  final double dashWidth;
  final double gapWidth;

  /// Controls how the dashed line is aligned within the available space.
  ///
  /// Defaults to[MainAxisAlignment.center], which ensures the dashes are
  /// perfectly symmetrical on both the left and right edges.
  final MainAxisAlignment alignment;

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
          alignment: alignment,
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
    required this.alignment,
  });

  final Color color;
  final double thickness;
  final double indent;
  final double endIndent;
  final double dashWidth;
  final double gapWidth;
  final MainAxisAlignment alignment;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    final y = size.height / 2;
    final availableWidth = size.width - indent - endIndent;
    if (availableWidth <= 0) return;

    final cycleLength = dashWidth + gapWidth;
    final dashCount = ((availableWidth + gapWidth) / cycleLength).floor();
    if (dashCount <= 0) return;

    final drawnWidth = (dashCount * dashWidth) + ((dashCount - 1) * gapWidth);
    final remainingSpace = availableWidth - drawnWidth;

    double x = indent;
    double actualGap = gapWidth;

    // Distribute the remaining asymmetrical space based on alignment
    switch (alignment) {
      case MainAxisAlignment.center:
        x += remainingSpace / 2;
        break;
      case MainAxisAlignment.end:
        x += remainingSpace;
        break;
      case MainAxisAlignment.spaceBetween:
        if (dashCount > 1) {
          actualGap = (availableWidth - (dashCount * dashWidth)) / (dashCount - 1);
        }
        break;
      case MainAxisAlignment.spaceAround:
        if (dashCount > 0) {
          actualGap = (availableWidth - (dashCount * dashWidth)) / dashCount;
          x += actualGap / 2;
        }
        break;
      case MainAxisAlignment.spaceEvenly:
        if (dashCount > 0) {
          actualGap = (availableWidth - (dashCount * dashWidth)) / (dashCount + 1);
          x += actualGap;
        }
        break;
      case MainAxisAlignment.start:
        break;
    }

    for (int i = 0; i < dashCount; i++) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
      x += dashWidth + actualGap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) =>
      old.color != color ||
      old.thickness != thickness ||
      old.indent != indent ||
      old.endIndent != endIndent ||
      old.dashWidth != dashWidth ||
      old.gapWidth != gapWidth ||
      old.alignment != alignment;
}
