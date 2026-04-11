import 'package:flutter/material.dart';
import 'core/contracts.dart';
import 'core/theme.dart';
import 'layout/slot_resolver.dart';

class FluxCard extends StatelessWidget {
  final FluxCardLayout layout;
  final Widget? background;
  final Widget? media;
  final Color? foregroundColor;
  final Widget? header;
  final Widget? content;
  final Widget? footer;
  final Widget? overlay;
  final double? width;
  final double? height;
  final bool fullWidth;
  final bool fullHeight;
  final FluxCardThemeData? theme;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const FluxCard({
    super.key,
    this.layout = const FluxCardLayout.column(),
    this.background,
    this.media,
    this.foregroundColor,
    this.header,
    this.content,
    this.footer,
    this.overlay,
    this.width,
    this.height,
    this.fullWidth = false,
    this.fullHeight = false,
    this.theme,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final inheritedTheme = FluxCardTheme.of(context);
    final effectiveTheme = theme ?? inheritedTheme;

    return FluxCardTheme(
      data: effectiveTheme,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.hasBoundedWidth
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;

          final resolvedLayout = layout.mode == FluxLayoutMode.responsive
              ? (availableWidth >= effectiveTheme.responsiveBreakpoint
                  ? const FluxCardLayout.row()
                  : const FluxCardLayout.column())
              : layout;

          final resolvedWidth = width ?? (fullWidth ? constraints.maxWidth : null);
          final resolvedHeight = height ?? (fullHeight ? constraints.maxHeight : null);
          final cardColor = effectiveTheme.cardColor ?? Theme.of(context).colorScheme.surface;
          final shadowColor = effectiveTheme.shadowColor ?? Theme.of(context).shadowColor;
          final elevation = effectiveTheme.elevation > 0
              ? effectiveTheme.elevation
              : (effectiveTheme.defaultShadows?.isNotEmpty == true ? 4.0 : 0.0);

          Widget body = _buildLayout(context, resolvedLayout, effectiveTheme);

          if (background != null) {
            body = Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(child: background!),
                body,
              ],
            );
          }

          return SizedBox(
            width: resolvedWidth,
            height: resolvedHeight,
            child: Material(
              color: cardColor,
              elevation: elevation,
              shadowColor: shadowColor,
              surfaceTintColor: effectiveTheme.surfaceTintColor,
              shape: RoundedRectangleBorder(borderRadius: effectiveTheme.borderRadius),
              clipBehavior: effectiveTheme.clipBehavior,
              child: InkWell(
                onTap: onTap,
                onLongPress: onLongPress,
                child: DefaultTextStyle.merge(
                  style: TextStyle(color: foregroundColor),
                  child: IconTheme.merge(
                    data: IconThemeData(color: foregroundColor),
                    child: body,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _wrapMedia(Widget? media, Widget? overlay) {
    if (media == null && overlay == null) return const SizedBox.shrink();

    if (media == null) return overlay!;

    if (overlay == null) return media;

    return Stack(
      fit: StackFit.passthrough,
      children: [ media, Positioned.fill(child: overlay) ],
    );
  }

  Widget _buildLayout(BuildContext context, FluxCardLayout layout, FluxCardThemeData theme) {
    final inner = SlotResolver.resolve(
      header: header,
      content: content,
      footer: footer,
      padding: theme.padding,
      spacing: theme.spacing,
    );

    final mediaSection = _wrapMedia(media, layout.mode == FluxLayoutMode.stack ? overlay : null);

    if (layout.mode == FluxLayoutMode.stack) {
      return Stack(
        fit: StackFit.expand,
        children: [
          if (mediaSection is! SizedBox) Positioned.fill(child: mediaSection),
          inner,
          if (overlay != null) Positioned.fill(child: overlay!),
        ],
      );
    }

    if (layout.mode == FluxLayoutMode.row) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (media != null) Flexible(
            flex: theme.flexMedia,
            child: mediaSection,
          ),

          Expanded(
            flex: theme.flexContent,
            child: inner,
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (media != null) mediaSection,
        inner,
      ],
    );
  }
}
