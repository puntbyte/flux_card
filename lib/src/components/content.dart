import 'package:flutter/material.dart';

class FluxContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const FluxContent({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      );
}
