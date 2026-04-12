import 'package:flutter/material.dart';

/// A body-slot container for free-form [FluxCard] content.
///
/// [FluxContent] wraps arbitrary content in the card's body area and provides
/// scroll behaviour, height constraints, alignment, and optional decoration —
/// things that [FluxSection] (which is structured around title/actions) does
/// not handle.
///
/// ```dart
/// FluxCard(
///   body: FluxContent(
///     minHeight: 80,
///     scrollable: true,
///     decoration: BoxDecoration(
///       color: Colors.grey.shade100,
///       borderRadius: BorderRadius.circular(8),
///     ),
///     padding: const EdgeInsets.all(12),
///     child: Text(longDescription),
///   ),
/// )
/// ```
class FluxContent extends StatelessWidget {
  const FluxContent({
    super.key,
    required this.child,
    this.padding,
    this.decoration,
    this.scrollable = false,
    this.minHeight,
    this.maxHeight,
    this.alignment,
  });

  final Widget child;

  /// Padding applied inside the decoration (or around the child when no
  /// decoration is provided).
  final EdgeInsetsGeometry? padding;

  /// Optional [BoxDecoration] painted behind the content.
  ///
  /// When set, the decoration fills the full content area. Combine with
  /// [padding] to add breathing room between the decoration edge and the
  /// child.
  final BoxDecoration? decoration;

  /// When true, wraps [child] in a [SingleChildScrollView] so that content
  /// that overflows the card's height can be scrolled.
  final bool scrollable;

  /// Minimum height of the content area.
  final double? minHeight;

  /// Maximum height of the content area. Content beyond this height scrolls
  /// if [scrollable] is true, or clips otherwise.
  final double? maxHeight;

  /// Aligns [child] within the content area.
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    if (scrollable) result = SingleChildScrollView(child: result);

    if (alignment != null) result = Align(alignment: alignment!, child: result);

    if (padding != null) result = Padding(padding: padding!, child: result);

    if (minHeight != null || maxHeight != null) {
      result = ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight ?? 0.0,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: result,
      );
    }

    if (decoration != null) result = DecoratedBox(decoration: decoration!, child: result);

    return result;
  }
}
