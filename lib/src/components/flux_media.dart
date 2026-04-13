import 'package:flutter/material.dart';

/// A layout-only container for the media slot of a [FluxCard].
///
/// [FluxMedia] controls the **size and clipping** of whatever widget is placed
/// in the card's media area. It intentionally does not control image rendering —
/// fit, scale, and color belong on the child (e.g. `Image.network(fit: BoxFit.cover)`).
///
/// ### Sizing
/// - Set [aspectRatio] to maintain a ratio regardless of layout mode.
/// - Set [height] (column mode) or [width] (fixed thumbnails in row mode).
/// - Leave all three unset to let the child fill whatever constraints the slot provides.
///   In `row` mode this means the child fills the slot height correctly, so
///   `Image.network(fit: BoxFit.cover)` works as expected.
///
/// ```dart
/// // Column — aspect-ratio image:
/// FluxMedia(aspectRatio: 16 / 9, child: Image.network(url, fit: BoxFit.cover))
///
/// // Row — fill slot height, image covers:
/// FluxMedia(child: Image.network(url, fit: BoxFit.cover))
///
/// // Fixed square thumbnail:
/// FluxMedia(width: 80, height: 80, child: Image.network(url, fit: BoxFit.cover))
/// ```
class FluxMedia extends StatelessWidget {
  const FluxMedia({
    super.key,
    required this.child,
    this.aspectRatio,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
    this.alignment = Alignment.center,
  });

  final Widget child;

  /// Maintain this width-to-height ratio. Takes priority over [height].
  final double? aspectRatio;

  /// Explicit pixel width. Useful for fixed-size thumbnails in row layouts.
  final double? width;

  /// Explicit pixel height. Common in column layouts to cap media height.
  final double? height;

  /// Padding applied inside the (optional) clip.
  final EdgeInsetsGeometry padding;

  /// If set, the media is clipped to this radius.
  final BorderRadiusGeometry? borderRadius;

  final Clip clipBehavior;

  /// Alignment used only when both [width] and [height] are explicitly set,
  /// to position the fixed-size box within its slot.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    if (aspectRatio != null) {
      // AspectRatio gives the child tight constraints (width × width/ratio),
      // so BoxFit on the child image works correctly in every layout mode.
      result = AspectRatio(aspectRatio: aspectRatio!, child: result);
    } else if (width != null || height != null) {
      // SizedBox with double.infinity on the unconstrained axis lets the parent
      // slot determine that dimension (fills row-slot width, fills column-slot
      // width when height-only is set).
      result = SizedBox(width: width ?? double.infinity, height: height, child: result);
      // Align only when both dimensions are pinned so the fixed box can be
      // positioned within any extra slot space.
      if (width != null && height != null) {
        result = Align(alignment: alignment, child: result);
      }
    }
    // No explicit sizing → the child fills whatever constraints the slot
    // provides directly. In row mode (Row with crossAxisAlignment.stretch)
    // the child gets tight constraints and BoxFit.cover works correctly.

    if (borderRadius != null) {
      result = ClipRRect(borderRadius: borderRadius!, clipBehavior: clipBehavior, child: result);
    }

    if (padding != EdgeInsets.zero) {
      result = Padding(padding: padding, child: result);
    }

    return result;
  }
}
