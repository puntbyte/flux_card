import 'package:flutter/material.dart';
import '../core/theme.dart';

class FluxHeader extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final List<Widget>? trailing;
  final double? spacing;

  const FluxHeader({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FluxCardTheme.of(context);
    final textTheme = Theme.of(context).textTheme;

    final effectiveTitleStyle = theme.defaultTitleStyle ??
        textTheme.titleMedium ??
        const TextStyle(fontWeight: FontWeight.bold);

    final effectiveSubtitleStyle = theme.defaultSubtitleStyle ??
        textTheme.bodyMedium ??
        const TextStyle();

    final effectiveSpacing = spacing ?? theme.spacing;

    final localLeading = leading;
    final localSubtitle = subtitle;
    final localTrailing = trailing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (localLeading != null) ...[
          localLeading,
          SizedBox(width: effectiveSpacing),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DefaultTextStyle.merge(
                style: effectiveTitleStyle,
                child: title,
              ),
              if (localSubtitle != null) ...[
                SizedBox(height: effectiveSpacing / 2),
                DefaultTextStyle.merge(
                  style: effectiveSubtitleStyle,
                  child: localSubtitle,
                ),
              ],
            ],
          ),
        ),
        if (localTrailing != null && localTrailing.isNotEmpty) ...[
          SizedBox(width: effectiveSpacing),
          Wrap(
            spacing: 4,
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: localTrailing,
          ),
        ],
      ],
    );
  }
}
