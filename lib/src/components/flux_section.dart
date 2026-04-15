import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../layout/slot_resolver.dart';

/// A structured content section used as the [FluxCard] header, footer, or
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

  /// Aligns the entire header row (leading, text column, trailing) vertically.
  /// Use [CrossAxisAlignment.center] to perfectly center text next to a large avatar.
  final CrossAxisAlignment headerCrossAxisAlignment;

  /// Aligns the text column (title, subtitle, description) horizontally.
  final CrossAxisAlignment textCrossAxisAlignment;

  /// Aligns the text column (title, subtitle, description) vertically.
  /// Useful if the section has a forced height and you want to space out the texts.
  final MainAxisAlignment textMainAxisAlignment;

  final MainAxisAlignment actionsAlignment;

  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? descriptionStyle;

  @override
  EdgeInsetsGeometry? get externalPaddingOverride => margin;

  WrapAlignment _wrapAlignment(MainAxisAlignment value) {
    switch (value) {
      case MainAxisAlignment.end: return WrapAlignment.end;
      case MainAxisAlignment.center: return WrapAlignment.center;
      case MainAxisAlignment.spaceBetween: return WrapAlignment.spaceBetween;
      case MainAxisAlignment.spaceAround: return WrapAlignment.spaceAround;
      case MainAxisAlignment.spaceEvenly: return WrapAlignment.spaceEvenly;
      default: return WrapAlignment.start;
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
        descriptionStyle ?? theme.defaultDescriptionStyle ?? textTheme.bodySmall ?? const TextStyle();

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

    final parts = <Widget>[];

    if (hasHeader) {
      final textChildren = <Widget>[];
      if (title != null) textChildren.add(DefaultTextStyle.merge(style: resolvedTitleStyle, child: title!));
      if (subtitle != null) textChildren.add(DefaultTextStyle.merge(style: resolvedSubtitleStyle, child: subtitle!));
      if (description != null) textChildren.add(DefaultTextStyle.merge(style: resolvedDescriptionStyle, child: description!));

      final spacedTextChildren = <Widget>[];
      for (int i = 0; i < textChildren.length; i++) {
        spacedTextChildren.add(textChildren[i]);
        if (i < textChildren.length - 1) {
          spacedTextChildren.add(SizedBox(height: spacing / 2));
        }
      }

      parts.add(
        Row(
          crossAxisAlignment: headerCrossAxisAlignment,
          children:[
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

    if (decoration != null) return Ink(decoration: decoration!, child: padded);

    return padded;
  }
}