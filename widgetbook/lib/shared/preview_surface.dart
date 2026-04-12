import 'package:flutter/material.dart';

Widget previewSurface(
  BuildContext context,
  Widget child, {
  double maxWidth = 460,
  double minHeight = 0,
  EdgeInsetsGeometry padding = const EdgeInsets.all(24),
  Color? backgroundColor,
}) {
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
