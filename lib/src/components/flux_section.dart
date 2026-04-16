import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../layout/slot_resolver.dart';

/// A structured content section used as the[FluxCard] header, footer, or
/// any slot that needs a title/subtitle/leading/trailing/actions layout.
class FluxSection extends StatelessWidget implements FluxSlotWrapper {
  const FluxSection({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.description,
    this.trailing,
    this.child,
    this.actions,
    this.margin,
    this.padding = EdgeInsets.zero,
    this.decoration,
    this.spacing = 12,
    this.runSpacing = 8,
    this.headerCrossAxisAlignment = CrossAxisAlignment.start,
    this.textCrossAxisAlignment = CrossAxisAlignment.start,
    this.textMainAxisAlignment = MainAxisAlignment.start,
    this.actionsAlignment = MainAxisAlignment.start,
    this.titleStyle,
    this.subtitleStyle,
    this.descriptionStyle,
  });

  const FluxSection.header({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.description,
    this.trailing,
    this.margin,
    this.padding = EdgeInsets.zero,
    this.decoration,
    this.spacing = 12,
    this.headerCrossAxisAlignment = CrossAxisAlignment.start,
    this.textCrossAxisAlignment = CrossAxisAlignment.start,
    this.textMainAxisAlignment = MainAxisAlignment.start,
    this.titleStyle,
    this.subtitleStyle,
    this.descriptionStyle,
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
       description = null,
       trailing = null,
       child = null,
       headerCrossAxisAlignment = CrossAxisAlignment.start,
       textCrossAxisAlignment = CrossAxisAlignment.start,
       textMainAxisAlignment = MainAxisAlignment.start,
       titleStyle = null,
       subtitleStyle = null,
       descriptionStyle = null;

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? description;
  final List<Widget>? trailing;
  final Widget? child;
  final List<Widget>? actions;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final BoxDecoration? decoration;
  final double spacing;
  final double runSpacing;
  final CrossAxisAlignment headerCrossAxisAlignment;
  final CrossAxisAlignment textCrossAxisAlignment;
  final MainAxisAlignment textMainAxisAlignment;
  final MainAxisAlignment actionsAlignment;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? descriptionStyle;

  @override
  EdgeInsetsGeometry? get externalPaddingOverride => margin;

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
    final resolvedDescriptionStyle =
        descriptionStyle ??
        theme.defaultDescriptionStyle ??
        textTheme.bodySmall ??
        const TextStyle();

    final hasHeader =
        leading != null ||
        title != null ||
        subtitle != null ||
        description != null ||
        (trailing != null && trailing!.isNotEmpty);
    final hasActions = actions != null && actions!.isNotEmpty;
    final hasChild = child != null;

    if (!hasHeader && !hasActions && !hasChild) {
      return const SizedBox.shrink();
    }

    // OPTIMIZATION 1.B: Using Dart Collection Literals instead of successive .add() calls
    final textChildren = <Widget>[
      if (title != null) DefaultTextStyle.merge(style: resolvedTitleStyle, child: title!),
      if (subtitle != null) DefaultTextStyle.merge(style: resolvedSubtitleStyle, child: subtitle!),
      if (description != null)
        DefaultTextStyle.merge(style: resolvedDescriptionStyle, child: description!),
    ];

    final spacedTextChildren = <Widget>[
      for (int i = 0; i < textChildren.length; i++) ...[
        if (i > 0) SizedBox(height: spacing / 2),
        textChildren[i],
      ],
    ];

    final parts = <Widget>[
      if (hasHeader)
        Row(
          crossAxisAlignment: headerCrossAxisAlignment,
          children: [
            if (leading != null) ...[leading!, SizedBox(width: spacing)],
            if (spacedTextChildren.isNotEmpty)
              Expanded(
                child: Column(
                  mainAxisAlignment: textMainAxisAlignment,
                  crossAxisAlignment: textCrossAxisAlignment,
                  mainAxisSize: MainAxisSize.min,
                  children: spacedTextChildren,
                ),
              ),
            if (trailing != null && trailing!.isNotEmpty) ...[
              if (spacedTextChildren.isNotEmpty || leading != null) SizedBox(width: spacing),
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
      if (hasChild) ...[if (hasHeader) SizedBox(height: spacing), child!],
      if (hasActions) ...[
        if (hasHeader || hasChild) SizedBox(height: spacing),
        Wrap(
          alignment: _wrapAlignment(actionsAlignment),
          spacing: spacing,
          runSpacing: runSpacing,
          children: actions!,
        ),
      ],
    ];

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: parts,
    );

    final padded = Padding(padding: padding, child: column);

    if (decoration != null) return Ink(decoration: decoration!, child: padded);

    return padded;
  }
}
