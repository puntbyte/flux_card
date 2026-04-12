import 'package:flutter/material.dart';

/// A layout-only container for the media slot of a [FluxCard].
///
/// [FluxMedia] controls the **size and clipping** of whatever widget is placed
/// in the card's media area — an image, a video thumbnail, an icon, a map, or
/// any custom widget. It intentionally does not handle image fit or rendering;
/// those belong on the child (e.g. [Image.network] with [BoxFit.cover]).
///
/// ```dart
/// // Typical usage — image with cover fit:
/// FluxMedia(
///   aspectRatio: 16 / 9,
///   child: Image.network(url, fit: BoxFit.cover),
/// )
///
/// // Fixed square with rounded corners:
/// FluxMedia(
///   width: 80,
///   height: 80,
///   borderRadius: BorderRadius.circular(12),
///   child: Image.network(url, fit: BoxFit.cover),
/// )
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

  /// The media widget (image, video frame, icon, etc.).
  final Widget child;

  /// If set, forces the media to maintain this width-to-height ratio,
  /// overriding [height] when both are provided.
  final double? aspectRatio;

  /// Explicit pixel width. Useful for fixed-size thumbnails in row layouts.
  final double? width;

  /// Explicit pixel height. In column layouts this controls how tall the
  /// media appears.
  final double? height;

  /// Padding around the media, applied before clipping.
  final EdgeInsetsGeometry padding;

  /// If set, the media is clipped to this radius.
  final BorderRadiusGeometry? borderRadius;

  /// Clip quality when [borderRadius] is set.
  final Clip clipBehavior;

  /// How the child is aligned within the media area when it doesn't fill it.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    // Constrain size before alignment.
    if (aspectRatio != null) {
      result = AspectRatio(aspectRatio: aspectRatio!, child: result);
    } else if (width != null || height != null) {
      result = SizedBox(width: width, height: height, child: result);
    }

    // Center / align the sized child within whatever space is available.
    result = Align(alignment: alignment, child: result);

    if (padding != EdgeInsets.zero) {
      result = Padding(padding: padding, child: result);
    }

    if (borderRadius != null) {
      result = ClipRRect(
        borderRadius: borderRadius!,
        clipBehavior: clipBehavior,
        child: result,
      );
    }

    return result;
  }
}
