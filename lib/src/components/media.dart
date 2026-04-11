import 'package:flutter/material.dart';

/// Layout-focused wrapper for arbitrary media widgets.
///
/// This widget does not know anything about images or assets.
/// It only controls how a pluggable child is sized and placed.
class FluxMedia extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final Alignment alignment;
  final BoxFit fit;
  final Clip clipBehavior;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry padding;

  const FluxMedia({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.aspectRatio,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
    this.clipBehavior = Clip.antiAlias,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
  });

  const FluxMedia.cover({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.aspectRatio,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.antiAlias,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
  }) : fit = BoxFit.cover;

  const FluxMedia.contain({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.aspectRatio,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.antiAlias,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
  }) : fit = BoxFit.contain;

  const FluxMedia.fill({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.aspectRatio,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.antiAlias,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
  }) : fit = BoxFit.fill;

  const FluxMedia.center({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.aspectRatio,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.antiAlias,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
  }) : fit = BoxFit.none;

  const FluxMedia.scaleDown({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.aspectRatio,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.antiAlias,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
  }) : fit = BoxFit.scaleDown;

  Widget _buildBody() {
    Widget result = child;

    if (aspectRatio != null) {
      result = AspectRatio(aspectRatio: aspectRatio!, child: result);
    }

    if (width != null || height != null) {
      result = SizedBox(width: width, height: height, child: result);
    }

    result = Padding(
      padding: padding,
      child: FittedBox(
        fit: fit,
        alignment: alignment,
        child: result,
      ),
    );

    if (borderRadius != null) {
      result = ClipRRect(
        borderRadius: borderRadius!,
        clipBehavior: clipBehavior,
        child: result,
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) => _buildBody();
}
