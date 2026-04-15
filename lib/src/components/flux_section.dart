import 'package:flutter/material.dart';

import '../core/theme.dart';

/// A structured content section used as the [FluxCard] header, footer, or
/// any slot that needs a title/subtitle/leading/trailing/actions layout.
class FluxSection extends StatelessWidget {
  const FluxSection({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.child,
    this.actions,
    this.margin,
    this.padding = EdgeInsets.zero,
    this.decoration,
    this.spacing = 12,
    this.runSpacing = 8,
    this.actionsAlignment = MainAxisAlignment.start,
    this.titleStyle,
    this.subtitleStyle,
  });

  const FluxSection.header({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.margin,
    this.padding = EdgeInsets.zero,
    this.decoration,
    this.spacing = 12,
    this.titleStyle,
    this.subtitleStyle,
  }) : child = null,
        actions = null,
        actionsAlignment = MainAxisAlignment.start,
        runSpacing = 0;

  const FluxSection.footer({
    super.key,
    this.actions,
    this.actionsAlignment = MainAxisAlignment.start,
    this.margin,
    this.padding = EdgeInsets.zero,
    this.decoration,
    this.spacing = 12,
    this.runSpacing = 8,
  }) : leading = null,
        title = null,
        subtitle = null,
        trailing = null,
        child = null,
        titleStyle = null,
        subtitleStyle = null;

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final List<Widget>? trailing;
  final Widget? child;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final BoxDecoration? decoration;
  final double spacing;
  final double runSpacing;
  final MainAxisAlignment actionsAlignment;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  WrapAlignment _wrapAlignment(MainAxisAlignment value) {
    switch (value) {
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
      default:
        return WrapAlignment.start;
    }
  }

  @override
  EdgeInsetsGeometry? get externalPaddingOverride => margin;

  @override
  Widget build(BuildContext context) {
    final theme = FluxCardThemeData.of(context);
    final textTheme = Theme.of(context).textTheme;

    final resolvedTitleStyle =
        titleStyle ??
        theme.defaultTitleStyle ??
        textTheme.titleMedium ??
        const TextStyle(fontWeight: FontWeight.w700);

    final resolvedSubtitleStyle =
        subtitleStyle ?? theme.defaultSubtitleStyle ?? textTheme.bodyMedium ?? const TextStyle();

    final hasHeader =
        leading != null ||
        title != null ||
        subtitle != null ||
        (trailing != null && trailing!.isNotEmpty);
    final hasActions = actions != null && actions!.isNotEmpty;
    final hasChild = child != null;

    if (!hasHeader && !hasActions && !hasChild) return const SizedBox.shrink();

    final parts = <Widget>[];

    if (hasHeader) {
      parts.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null) ...[leading!, SizedBox(width: spacing)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    DefaultTextStyle.merge(style: resolvedTitleStyle, child: title!),

                  if (subtitle != null) ...[
                    SizedBox(height: spacing / 2),
                    DefaultTextStyle.merge(style: resolvedSubtitleStyle, child: subtitle!),
                  ],
                ],
              ),
            ),
            if (trailing != null && trailing!.isNotEmpty) ...[
              SizedBox(width: spacing),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: trailing!,
              ),
            ],
          ],
        ),
      );
    }

    if (hasChild) {
      if (parts.isNotEmpty) parts.add(SizedBox(height: spacing));
      parts.add(child!);
    }

    if (hasActions) {
      if (parts.isNotEmpty) parts.add(SizedBox(height: spacing));
      parts.add(
        Wrap(
          alignment: _wrapAlignment(actionsAlignment),
          spacing: spacing,
          runSpacing: runSpacing,
          children: actions!,
        ),
      );
    }

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: parts,
    );

    final padded = Padding(padding: padding, child: column);

    // Changed to Ink to ensure ripples are not obscured
    if (decoration != null) return Ink(decoration: decoration!, child: padded);

    return padded;
  }
}
