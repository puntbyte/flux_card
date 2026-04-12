import 'package:flutter/widgets.dart';

/// Resolved sizing constraints for a [FluxCard].
///
/// Created once per build inside a [LayoutBuilder] and passed to the layout
/// engine, keeping all constraint logic in one place.
@immutable
class FluxCardConstraints {
  const FluxCardConstraints({
    required this.parentConstraints,
    this.explicitWidth,
    this.explicitHeight,
    this.fullWidth = false,
    this.fullHeight = false,
  });

  final BoxConstraints parentConstraints;

  /// Explicit pixel width set directly on the card.
  final double? explicitWidth;

  /// Explicit pixel height set directly on the card.
  final double? explicitHeight;

  /// Whether the card should expand to fill the available width.
  final bool fullWidth;

  /// Whether the card should expand to fill the available height.
  final bool fullHeight;

  /// Resolved width to pass to [SizedBox], or null to let the card shrink-wrap.
  double? get resolvedWidth {
    if (explicitWidth != null) return explicitWidth;
    if (fullWidth && parentConstraints.hasBoundedWidth) {
      return parentConstraints.maxWidth;
    }
    return null;
  }

  /// Resolved height to pass to [SizedBox], or null to let the card shrink-wrap.
  double? get resolvedHeight {
    if (explicitHeight != null) return explicitHeight;
    if (fullHeight && parentConstraints.hasBoundedHeight) {
      return parentConstraints.maxHeight;
    }
    return null;
  }

  /// Width available for responsive breakpoint evaluation.
  ///
  /// Falls back to [double.infinity] when the parent is unbounded.
  double get availableWidth {
    if (resolvedWidth != null) return resolvedWidth!;
    return parentConstraints.hasBoundedWidth
        ? parentConstraints.maxWidth
        : double.infinity;
  }
}
