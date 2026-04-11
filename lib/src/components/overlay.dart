import 'package:flutter/material.dart';

class FluxOverlay extends StatelessWidget {
  final List<Widget> children;
  final Alignment alignment;
  final EdgeInsets padding;

  const FluxOverlay({
    super.key,
    required this.children,
    this.alignment = Alignment.topRight,
    this.padding = const EdgeInsets.all(12.0),
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: children,
        ),
      ),
    );
  }
}
