import 'package:flutter/material.dart';

import 'components/flux_breakout_stack.dart';
import 'components/flux_section.dart';
import 'components/flux_underlay.dart';
import 'core/constraints.dart';
import 'core/enums.dart';
import 'core/layer_partitions.dart';
import 'core/theme.dart';
import 'divider/flux_divider.dart';
import 'layout/boundary_tracker.dart';
import 'layout/flux_card_layout.dart';
import 'loading/flux_card_skeleton.dart';
import 'notch/flux_notch.dart';
import 'shapes/flux_notch_shape.dart';

class FluxCard extends StatefulWidget {
  const FluxCard({
    super.key,
    this.layout = FluxLayoutMode.column,
    this.mediaPosition = FluxMediaPosition.start,
    this.mediaSpan = FluxMediaSpan.all,
    this.isMediaExpanded = false,
    this.media,
    this.header,
    this.body,
    this.footer,
    this.overlays,
    this.underlays,
    this.foregroundColor,
    this.decoration,
    this.notch,
    this.divider,
    this.width,
    this.height,
    this.fullWidth = false,
    this.fullHeight = false,
    this.theme,
    this.clipBehavior,
    this.semanticLabel,
    this.mergeSemantics,
    this.onTap,
    this.onLongPress,
    this.loading = false,
    this.loadingWrapper,
  });

  /// A convenient factory for creating a simple, standard card without boilerplate.
  factory FluxCard.simple({
    Key? key,
    String? title,
    String? subtitle,
    String? description,
    Widget? media,
    String? ctaLabel,
    VoidCallback? onCtaPressed,
    VoidCallback? onTap,
    FluxLayoutMode layout = FluxLayoutMode.column,
    bool isMediaExpanded = false,
    FluxCardThemeData? theme,
    bool? mergeSemantics,
  }) {
    return FluxCard(
      key: key,
      layout: layout,
      theme: theme,
      onTap: onTap,
      isMediaExpanded: isMediaExpanded,
      mergeSemantics: mergeSemantics,
      media: media,
      header: (title != null || subtitle != null || description != null)
          ? FluxSection.header(
        title: title != null ? Text(title) : null,
        subtitle: subtitle != null ? Text(subtitle) : null,
        description: description != null ? Text(description) : null,
        padding: EdgeInsets.zero,
      )
          : null,
      footer: (ctaLabel != null)
          ? FluxSection.footer(
        padding: EdgeInsets.zero,
        actions:[
          FilledButton(
            onPressed: onCtaPressed,
            child: Text(ctaLabel),
          ),
        ],
      )
          : null,
    );
  }

  final FluxLayoutMode layout;
  final FluxMediaPosition mediaPosition;
  final FluxMediaSpan mediaSpan;

  /// Whether the media slot should expand to fill remaining vertical space.
  ///
  /// Automatically ignored if the card is placed in an unbounded height
  /// context (like a `ListView`) to prevent layout exceptions.
  final bool isMediaExpanded;

  final Widget? media;
  final Widget? header;
  final Widget? body;
  final Widget? footer;
  final List<Widget>? overlays;
  final List<Widget>? underlays;
  final Color? foregroundColor;
  final BoxDecoration? decoration;
  final FluxNotch? notch;
  final FluxDivider? divider;
  final double? width;
  final double? height;
  final bool fullWidth;
  final bool fullHeight;
  final FluxCardThemeData? theme;
  final Clip? clipBehavior;
  final String? semanticLabel;
  final bool? mergeSemantics;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool loading;
  final Widget Function(BuildContext context, Widget skeleton)? loadingWrapper;

  @override
  State<FluxCard> createState() => _FluxCardState();
}

class _FluxCardState extends State<FluxCard> {
  final _cardTracker = BoundaryTracker();
  final _afterMediaTracker = BoundaryTracker();
  final _afterHeaderTracker = BoundaryTracker();
  final _afterBodyTracker = BoundaryTracker();

  final _mediaTracker = BoundaryTracker();
  final _headerTracker = BoundaryTracker();
  final _bodyTracker = BoundaryTracker();
  final _footerTracker = BoundaryTracker();

  Map<FluxSlotBoundary, BoundaryTracker> get _boundaryTrackers => {
    FluxSlotBoundary.afterMedia: _afterMediaTracker,
    FluxSlotBoundary.afterHeader: _afterHeaderTracker,
    FluxSlotBoundary.afterBody: _afterBodyTracker,
  };

  Map<FluxTarget, BoundaryTracker> get _slotTrackers => {
    FluxTarget.media: _mediaTracker,
    FluxTarget.header: _headerTracker,
    FluxTarget.body: _bodyTracker,
    FluxTarget.footer: _footerTracker,
  };

  bool get _needsLayoutBuilder =>
      widget.layout == FluxLayoutMode.responsive ||
          widget.fullWidth ||
          widget.fullHeight ||
          widget.isMediaExpanded;

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = widget.theme ?? FluxCardThemeData.of(context);
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final resolvedPadding = effectiveTheme.padding.resolve(textDirection);

    return FluxCardTheme(
      data: effectiveTheme,
      child: _needsLayoutBuilder
          ? LayoutBuilder(
        builder: (context, constraints) => _buildCard(
          context: context,
          theme: effectiveTheme,
          textDirection: textDirection,
          resolvedPadding: resolvedPadding,
          parentConstraints: constraints,
        ),
      )
          : _buildCard(
        context: context,
        theme: effectiveTheme,
        textDirection: textDirection,
        resolvedPadding: resolvedPadding,
        parentConstraints: null,
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required FluxCardThemeData theme,
    required TextDirection textDirection,
    required EdgeInsets resolvedPadding,
    required BoxConstraints? parentConstraints,
  }) {
    final cardConstraints = FluxCardConstraints(
      parentConstraints: parentConstraints ?? const BoxConstraints(),
      explicitWidth: widget.width,
      explicitHeight: widget.height,
      fullWidth: widget.fullWidth,
      fullHeight: widget.fullHeight,
    );

    final isResponsiveUnboundedFallback = _isResponsiveUnboundedFallback(cardConstraints);

    final resolvedLayout = _resolveLayout(
      theme: theme,
      cardConstraints: cardConstraints,
      isResponsiveUnboundedFallback: isResponsiveUnboundedFallback,
    );

    final effectiveShape = _resolveShape(
      context: context,
      theme: theme,
      textDirection: textDirection,
    );

    final layers = FluxLayerPartitions.partition(widget.underlays, widget.overlays);

    final cardContent = widget.loading
        ? _buildLoadingContent(layout: resolvedLayout, theme: theme)
        : _buildLiveContent(
      context: context,
      layout: resolvedLayout,
      theme: theme,
      resolvedPadding: resolvedPadding,
      parentConstraints: parentConstraints,
      layers: layers,
    );

    Widget contentTree = _buildContentTree(context: context, cardContent: cardContent);

    Widget cardWidget = _buildMaterial(
      context: context,
      theme: theme,
      shape: effectiveShape,
      child: contentTree,
    );

    if (isResponsiveUnboundedFallback && cardConstraints.resolvedWidth == null) {
      cardWidget = IntrinsicWidth(child: cardWidget);
    }

    cardWidget = _wrapSemantics(cardWidget, theme);

    final trackedCard = BoundaryMarker(
      tracker: _cardTracker,
      child: SizedBox(
        width: cardConstraints.resolvedWidth,
        height: cardConstraints.resolvedHeight,
        child: cardWidget,
      ),
    );

    return FluxBreakoutStack(
      cardTracker: _cardTracker,
      slotTrackers: _slotTrackers,
      overlays: layers.breakoutOverlays,
      child: trackedCard,
    );
  }

  bool _isResponsiveUnboundedFallback(FluxCardConstraints cardConstraints) {
    if (widget.layout != FluxLayoutMode.responsive) return false;
    final hasBoundedAvailableWidth =
        cardConstraints.resolvedWidth != null || cardConstraints.parentConstraints.hasBoundedWidth;
    return !hasBoundedAvailableWidth;
  }

  FluxLayoutMode _resolveLayout({
    required FluxCardThemeData theme,
    required FluxCardConstraints cardConstraints,
    required bool isResponsiveUnboundedFallback,
  }) {
    if (widget.layout != FluxLayoutMode.responsive) {
      return widget.layout;
    }
    if (isResponsiveUnboundedFallback) {
      return FluxLayoutMode.column;
    }
    return cardConstraints.availableWidth >= theme.responsiveBreakpoint
        ? FluxLayoutMode.row
        : FluxLayoutMode.column;
  }

  ShapeBorder _resolveShape({
    required BuildContext context,
    required FluxCardThemeData theme,
    required TextDirection textDirection,
  }) {
    final notch = widget.notch;
    if (notch == null) return theme.resolveShape(context);

    final borderRadius = notch.borderRadius ?? theme.borderRadius.resolve(textDirection);

    return FluxNotchShape(
      borderRadius: borderRadius,
      kind: notch.kind,
      notchDepth: notch.notchDepth,
      notchWidth: notch.notchWidth,
      notchPosition: notch.fallbackPosition,
      notchPositionResolver: notch.isTargeted ? _resolveNotchPosition : null,
      notchEdge: notch.edge,
      notchSide: notch.notchSide,
      side: theme.resolveBorderSide(context),
    );
  }

  double? _resolveNotchPosition(Rect cardRect) {
    final notch = widget.notch;
    if (notch == null || !notch.isTargeted) return null;

    final markerBox = _boundaryTrackers[notch.boundary!]?.renderBox;
    final cardBox = _cardTracker.renderBox;

    if (markerBox == null || cardBox == null) return null;

    try {
      final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
      final resolvedAlignment = notch.boundaryAlignment.resolve(textDirection);

      final pointInMarker = resolvedAlignment.alongSize(markerBox.size);
      final pointInCard = markerBox.localToGlobal(pointInMarker, ancestor: cardBox);

      if (notch.edge == FluxNotchEdge.vertical) {
        return ((pointInCard.dy + notch.boundaryOffset) / cardRect.height).clamp(0.0, 1.0);
      }
      return ((pointInCard.dx + notch.boundaryOffset) / cardRect.width).clamp(0.0, 1.0);
    } catch (_) {
      return null;
    }
  }

  Widget _buildLoadingContent({required FluxLayoutMode layout, required FluxCardThemeData theme}) {
    return FluxCardSkeleton(
      layout: layout,
      mediaPosition: widget.mediaPosition,
      mediaSpan: widget.mediaSpan,
      theme: theme,
      hasMedia: widget.media != null,
      hasHeader: widget.header != null,
      hasBody: widget.body != null,
      hasFooter: widget.footer != null,
      loadingWrapper: widget.loadingWrapper,
    );
  }

  Widget _buildLiveContent({
    required BuildContext context,
    required FluxLayoutMode layout,
    required FluxCardThemeData theme,
    required EdgeInsets resolvedPadding,
    required BoxConstraints? parentConstraints,
    required FluxLayerPartitions layers,
  }) {
    // Only permit expansion if we are in an explicitly bounded environment
    final canExpand = widget.isMediaExpanded &&
        (widget.height != null || (parentConstraints != null && parentConstraints.hasBoundedHeight));

    final mainContent = FluxCardLayout(
      mode: layout,
      mediaPosition: widget.mediaPosition,
      mediaSpan: widget.mediaSpan,
      isMediaExpanded: canExpand,
      theme: theme,
      resolvedPadding: resolvedPadding,
      divider: widget.divider,
      boundaryTrackers: widget.notch?.isTargeted == true ? _boundaryTrackers : null,
      slotTrackers: _slotTrackers,
      parentConstraints: parentConstraints,
    ).build(
      context,
      media: widget.media,
      header: widget.header,
      body: widget.body,
      footer: widget.footer,
      underlaysByTarget: layers.underlaysByTarget,
      ovsByTarget: layers.overlaysByTarget,
      multiUnderlays: layers.multiUnderlays,
      multiOvs: layers.multiOverlays,
    );

    if (layers.globalUnderlays.isEmpty && layers.globalOverlays.isEmpty) {
      return mainContent;
    }

    return Stack(
      fit: StackFit.passthrough,
      clipBehavior: Clip.none,
      children:[
        ...layers.globalUnderlays.map(
              (underlay) => FluxUnderlay.buildPositioned(context, underlay),
        ),
        mainContent,
        ...layers.globalOverlays.map((overlay) => Positioned.fill(child: overlay)),
      ],
    );
  }

  Widget _buildContentTree({required BuildContext context, required Widget cardContent}) {
    final stackLayers = <Widget>[
      DefaultTextStyle.merge(
        style: TextStyle(color: widget.foregroundColor),
        child: IconTheme.merge(
          data: IconThemeData(color: widget.foregroundColor),
          child: cardContent,
        ),
      ),
    ];

    if (widget.decoration != null) {
      stackLayers.insert(
        0,
        Positioned.fill(
          child: IgnorePointer(child: Ink(decoration: widget.decoration!)),
        ),
      );
    }

    Widget contentTree = Stack(
      fit: StackFit.passthrough,
      clipBehavior: Clip.none,
      children: stackLayers,
    );

    if (widget.onTap != null || widget.onLongPress != null) {
      contentTree = InkWell(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        splashColor: Theme.of(context).splashColor,
        highlightColor: Theme.of(context).highlightColor,
        child: contentTree,
      );
    }

    return contentTree;
  }

  Widget _buildMaterial({
    required BuildContext context,
    required FluxCardThemeData theme,
    required ShapeBorder shape,
    required Widget child,
  }) {
    final cardColor = theme.cardColor ?? Theme.of(context).colorScheme.surface;
    final shadowColor = theme.shadowColor ?? Theme.of(context).shadowColor;

    final elevation = theme.elevation > 0
        ? theme.elevation
        : (theme.defaultShadows?.isNotEmpty == true ? 4.0 : 0.0);

    return Material(
      color: cardColor,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: theme.surfaceTintColor,
      shape: shape,
      clipBehavior: widget.clipBehavior ?? theme.clipBehavior,
      child: child,
    );
  }

  Widget _wrapSemantics(Widget child, FluxCardThemeData theme) {
    Widget wrapped = child;

    if (widget.semanticLabel != null) {
      wrapped = Semantics(
        container: true,
        button: widget.onTap != null || widget.onLongPress != null,
        label: widget.semanticLabel,
        child: wrapped,
      );
    }

    if (widget.mergeSemantics ?? theme.mergeSemantics) {
      wrapped = MergeSemantics(child: wrapped);
    }

    return wrapped;
  }
}