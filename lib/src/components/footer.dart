import 'package:flutter/material.dart';

class FluxFooter extends StatelessWidget {
  final List<Widget> actions;
  final Axis direction;
  final MainAxisAlignment alignment;
  final double spacing;

  const FluxFooter({
    super.key,
    required this.actions,
    this.direction = Axis.horizontal,
    this.alignment = MainAxisAlignment.spaceBetween,
    this.spacing = 12.0,
  });

  WrapAlignment _wrapAlignment(MainAxisAlignment value) {
    switch (value) {
      case MainAxisAlignment.start:
        return WrapAlignment.start;
      case MainAxisAlignment.end:
        return WrapAlignment.end;
      case MainAxisAlignment.center:
        return WrapAlignment.center;
      case MainAxisAlignment.spaceBetween:
        return WrapAlignment.spaceBetween;
      case MainAxisAlignment.spaceAround:
        return WrapAlignment.spaceAround;
      case MainAxisAlignment.spaceEvenly:
        return WrapAlignment.spaceEvenly;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    return Wrap(
      direction: direction,
      alignment: _wrapAlignment(alignment),
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: spacing,
      runSpacing: spacing * 0.5,
      children: actions,
    );
  }
}
