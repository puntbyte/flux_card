import 'package:flutter/material.dart';

class SlotResolver {
  static Widget resolve({
    Widget? header,
    Widget? content,
    Widget? footer,
    required EdgeInsetsGeometry padding,
    required double spacing,
    Axis direction = Axis.vertical,
  }) {
    final children = <Widget>[];

    if (header != null) children.add(header);
    if (header != null && content != null) {
      children.add(direction == Axis.vertical ? SizedBox(height: spacing) : SizedBox(width: spacing));
    }
    if (content != null) children.add(content);
    if (content != null && footer != null) {
      children.add(direction == Axis.vertical ? SizedBox(height: spacing) : SizedBox(width: spacing));
    }
    if (footer != null) children.add(footer);

    if (children.isEmpty) return const SizedBox.shrink();

    final layout = direction == Axis.vertical
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: children,
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children,
          );

    return Padding(padding: padding, child: layout);
  }
}
