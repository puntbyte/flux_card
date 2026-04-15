import 'package:flutter/material.dart';

import '../layout/slot_resolver.dart';

/// A body-slot container for free-form [FluxCard] content.
class FluxContent extends StatelessWidget implements FluxSlotWrapper {
  /// Base constructor for custom or `const` content layouts.
  const FluxContent({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.decoration,
    this.scrollable = false,
    this.minHeight,
    this.maxHeight,
    this.alignment,
  });

  /// Convenience constructor for a vertical list of children with automatic spacing.
  FluxContent.column({
    super.key,
    required List<Widget> children,
    double spacing = 8.0,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    this.margin,
    this.padding,
    this.decoration,
    this.scrollable = false,
    this.minHeight,
    this.maxHeight,
    this.alignment,
  }) : child = Column(
         mainAxisSize: MainAxisSize.min,
         mainAxisAlignment: mainAxisAlignment,
         crossAxisAlignment: crossAxisAlignment,
         children: spacing > 0 ? _withSpacing(children, spacing, true) : children,
       );

  /// Convenience constructor for a horizontal list of children with automatic spacing.
  FluxContent.row({
    super.key,
    required List<Widget> children,
    double spacing = 8.0,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    this.margin,
    this.padding,
    this.decoration,
    this.scrollable = false,
    this.minHeight,
    this.maxHeight,
    this.alignment,
  }) : child = Row(
         mainAxisSize: MainAxisSize.min,
         mainAxisAlignment: mainAxisAlignment,
         crossAxisAlignment: crossAxisAlignment,
         children: spacing > 0 ? _withSpacing(children, spacing, false) : children,
       );

  /// Convenience constructor for wrapping children over multiple lines.
  FluxContent.wrap({
    super.key,
    required List<Widget> children,
    double spacing = 8.0,
    double runSpacing = 8.0,
    WrapAlignment wrapAlignment = WrapAlignment.start,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
    this.margin,
    this.padding,
    this.decoration,
    this.scrollable = false,
    this.minHeight,
    this.maxHeight,
    this.alignment,
  }) : child = Wrap(
         spacing: spacing,
         runSpacing: runSpacing,
         alignment: wrapAlignment,
         crossAxisAlignment: crossAxisAlignment,
         children: children,
       );

  final Widget child;

  /// Overrides the card's layout padding. Use `EdgeInsets.zero` to make this slot full-bleed.
  final EdgeInsetsGeometry? margin;

  /// Padding applied inside the decoration (or around the child when no
  /// decoration is provided).
  final EdgeInsetsGeometry? padding;

  /// Optional [BoxDecoration] painted behind the content.
  final BoxDecoration? decoration;

  final bool scrollable;
  final double? minHeight;
  final double? maxHeight;
  final AlignmentGeometry? alignment;

  @override
  EdgeInsetsGeometry? get externalPaddingOverride => margin;

  /// Helper to inject [SizedBox] gaps between children.
  static List<Widget> _withSpacing(List<Widget> items, double spacing, bool isVertical) {
    if (items.isEmpty) return items;
    final result = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i < items.length - 1) {
        result.add(isVertical ? SizedBox(height: spacing) : SizedBox(width: spacing));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Widget result = child;

    if (scrollable) result = SingleChildScrollView(child: result);

    if (alignment != null) result = Align(alignment: alignment!, child: result);

    if (padding != null) result = Padding(padding: padding!, child: result);

    if (minHeight != null || maxHeight != null) {
      result = ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight ?? 0.0,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: result,
      );
    }

    if (decoration != null) result = Ink(decoration: decoration!, child: result);

    return result;
  }
}
