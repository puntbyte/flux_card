import 'package:flutter/material.dart';

/// A layout-only container for the media slot of a [FluxCard].
///
/// [FluxMedia] controls the **size and clipping** of whatever widget is placed
/// in the card's media area. It intentionally does not control image rendering —
/// fit, scale, and color belong on the child (e.g. `Image.network(fit: BoxFit.cover)`).
class FluxMedia extends StatelessWidget {
  /// Default constructor for wrapping custom widgets (video players, maps, etc.)
  const FluxMedia({
    super.key,
    required Widget this.child,
    this.aspectRatio,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
    this.alignment = Alignment.center,
    this.color,
    this.gradient,
    this.foregroundColor,
    this.foregroundGradient,
  }) : _image = null,
       _imageFit = null,
       _imageAlignment = null,
       _colorFilter = null;

  /// Convenience constructor for images.
  ///
  /// Automatically wraps the image in an [Ink] layer so that card ripples
  /// wash seamlessly over the image, and handles [borderRadius] natively.
  const FluxMedia.image({
    super.key,
    required ImageProvider image,
    BoxFit? fit,
    AlignmentGeometry imageAlignment = Alignment.center,
    ColorFilter? colorFilter,
    this.aspectRatio,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
    this.alignment = Alignment.center,
    this.color,
    this.gradient,
    this.foregroundColor,
    this.foregroundGradient,
  }) : child = null,
       _image = image,
       _imageFit = fit,
       _imageAlignment = imageAlignment,
       _colorFilter = colorFilter;

  final Widget? child;

  final ImageProvider? _image;
  final BoxFit? _imageFit;
  final AlignmentGeometry? _imageAlignment;
  final ColorFilter? _colorFilter;

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

  /// Background color painted behind the media child.
  final Color? color;

  /// Background gradient painted behind the media child.
  final Gradient? gradient;

  /// Foreground color painted over the media child (useful for scrims).
  final Color? foregroundColor;

  /// Foreground gradient painted over the media child (useful for scrims).
  final Gradient? foregroundGradient;

  @override
  Widget build(BuildContext context) {
    Widget result;

    Decoration buildDecoration({Color? c, Gradient? g, DecorationImage? img}) {
      return BoxDecoration(color: c, gradient: g, image: img, borderRadius: borderRadius);
    }

    if (_image != null) {
      result = Ink(
        decoration: buildDecoration(
          img: DecorationImage(
            image: _image,
            fit: _imageFit,
            alignment: _imageAlignment ?? Alignment.center,
            colorFilter: _colorFilter,
          ),
        ),
      );
    } else {
      result = child!;
    }

    final hasBackground = color != null || gradient != null;
    final hasForeground = foregroundColor != null || foregroundGradient != null;

    if (hasBackground || hasForeground) {
      final double bleed = borderRadius == null ? -1.0 : 0.0;

      result = Stack(
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        children: [
          if (hasBackground)
            Positioned(
              top: bleed,
              bottom: bleed,
              left: bleed,
              right: bleed,
              child: IgnorePointer(
                child: Ink(
                  decoration: buildDecoration(c: color, g: gradient),
                ),
              ),
            ),
          result,
          if (hasForeground)
            Positioned(
              top: bleed,
              bottom: bleed,
              left: bleed,
              right: bleed,
              child: IgnorePointer(
                child: Ink(
                  decoration: buildDecoration(c: foregroundColor, g: foregroundGradient),
                ),
              ),
            ),
        ],
      );
    }

    // Primary explicit sizing rules.
    if (aspectRatio != null) {
      result = AspectRatio(aspectRatio: aspectRatio!, child: result);
    } else if (width != null || height != null) {
      result = SizedBox(width: width ?? double.infinity, height: height, child: result);

      if (width != null && height != null) {
        result = Align(alignment: alignment, child: result);
      }
    }

    // Fallback for row-layout / scrollable scenarios:
    // if height is unbounded and the caller did not provide an aspect ratio or
    // explicit height, cap greedy children (like Ink.image) to a finite height.
    if (aspectRatio == null && height == null) {
      final childForFallback = result;
      result = LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxHeight.isFinite) {
            return childForFallback;
          }

          final double? fallbackMaxHeight =
              width ?? (constraints.maxWidth.isFinite ? constraints.maxWidth : null);

          if (fallbackMaxHeight == null || fallbackMaxHeight <= 0) {
            return childForFallback;
          }

          return LimitedBox(maxHeight: fallbackMaxHeight, child: childForFallback);
        },
      );
    }

    if (borderRadius != null) {
      result = ClipRRect(borderRadius: borderRadius!, clipBehavior: clipBehavior, child: result);
    }

    if (padding != EdgeInsets.zero) {
      result = Padding(padding: padding, child: result);
    }

    return result;
  }
}
