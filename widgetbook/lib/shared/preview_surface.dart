import 'package:flutter/material.dart';

class PreviewSurface extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final double minHeight;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

  const PreviewSurface({
    required this.child,
    this.maxWidth = 460,
    this.minHeight = 0,
    this.padding = const EdgeInsets.all(24),
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: SingleChildScrollView(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth, minHeight: minHeight),
            child: child,
          ),
        ),
      ),
    );
  }
}

@Deprecated('Use PreviewSurface instead')
Widget previewSurface(
  BuildContext context,
  Widget child, {
  double maxWidth = 460,
  double minHeight = 0,
  EdgeInsetsGeometry padding = const EdgeInsets.all(24),
  Color? backgroundColor,
}) => PreviewSurface(
  maxWidth: maxWidth,
  minHeight: minHeight,
  padding: padding,
  backgroundColor: backgroundColor,
  child: child,
);
