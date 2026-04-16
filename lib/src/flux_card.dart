import 'package:flutter/material.dart';

import 'components/flux_overlay.dart';
import 'components/flux_underlay.dart';
import 'core/constraints.dart';
import 'core/enums.dart';
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
    this.onTap,
    this.onLongPress,
    this.loading = false,
    this.loadingWrapper,
  });

  final FluxLayoutMode layout;
  final FluxMediaPosition mediaPosition;
  final FluxMediaSpan mediaSpan;
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

  /// Overrides the [FluxCardThemeData.clipBehavior].
  /// Set to [Clip.none] to allow [FluxOverlay] badges to break out of the
  /// card bounds.
  final Clip? clipBehavior;

  /// Semantic label for accessibility.
  /// Wraps the entire card in a [Semantics] node.
  final String? semanticLabel;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool loading;
  final Widget Function(BuildContext context, Widget skeleton)? loadingWrapper;

  @override
  State<FluxCard> createState() => _FluxCardState();
}

class _FluxCardState extends State<FluxCard> {
  final BoundaryTracker _cardTracker = BoundaryTracker();
  final BoundaryTracker _afterMediaTracker = BoundaryTracker();
  final BoundaryTracker _afterHeaderTracker = BoundaryTracker();
  final BoundaryTracker _afterBodyTracker = BoundaryTracker();

  Map<FluxSlotBoundary, BoundaryTracker> get _trackers => {
    FluxSlotBoundary.afterMedia: _afterMediaTracker,
    FluxSlotBoundary.afterHeader: _afterHeaderTracker,
    FluxSlotBoundary.afterBody: _afterBodyTracker,
  };

  bool get _needsLayoutBuilder =>
      widget.layout == FluxLayoutMode.responsive || widget.fullWidth || widget.fullHeight;

  @override
  Widget build(BuildContext context) {
    final FluxCardThemeData effectiveTheme = widget.theme ?? FluxCardThemeData.of(context);
    final TextDirection textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final EdgeInsets resolvedPadding = effectiveTheme.padding.resolve(textDirection);

    final themedChild = FluxCardTheme(
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

    return themedChild;
  }

  Widget _buildCard({
    required BuildContext context,
    required FluxCardThemeData theme,
    required TextDirection textDirection,
    required EdgeInsets resolvedPadding,
    required BoxConstraints? parentConstraints,
  }) {
    final FluxCardConstraints cardConstraints = FluxCardConstraints(
      parentConstraints: parentConstraints ?? const BoxConstraints(),
      explicitWidth: widget.width,
      explicitHeight: widget.height,
      fullWidth: widget.fullWidth,
      fullHeight: widget.fullHeight,
    );

    final bool isResponsiveUnboundedFallback = _isResponsiveUnboundedFallback(cardConstraints);

    final FluxLayoutMode resolvedLayout = _resolveLayout(
      theme: theme,
      cardConstraints: cardConstraints,
      isResponsiveUnboundedFallback: isResponsiveUnboundedFallback,
    );

    final ShapeBorder effectiveShape = _resolveShape(
      context: context,
      theme: theme,
      textDirection: textDirection,
    );

    final Widget cardContent = widget.loading
        ? _buildLoadingContent(layout: resolvedLayout, theme: theme)
        : _buildLiveContent(
            context: context,
            layout: resolvedLayout,
            theme: theme,
            resolvedPadding: resolvedPadding,
            textDirection: textDirection,
            parentConstraints: parentConstraints,
          );

    Widget contentTree = _buildContentTree(cardContent);

    Widget cardWidget = _buildMaterial(
      context: context,
      theme: theme,
      shape: effectiveShape,
      child: contentTree,
    );

    if (isResponsiveUnboundedFallback && cardConstraints.resolvedWidth == null) {
      cardWidget = IntrinsicWidth(child: cardWidget);
    }

    cardWidget = _wrapSemantics(cardWidget);

    return BoundaryMarker(
      tracker: _cardTracker,
      child: SizedBox(
        width: cardConstraints.resolvedWidth,
        height: cardConstraints.resolvedHeight,
        child: cardWidget,
      ),
    );
  }

  bool _isResponsiveUnboundedFallback(FluxCardConstraints cardConstraints) {
    if (widget.layout != FluxLayoutMode.responsive) {
      return false;
    }

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
    final FluxNotch? notch = widget.notch;

    if (notch == null) {
      return theme.resolveShape(context);
    }

    final BorderRadius borderRadius =
        notch.borderRadius ?? theme.borderRadius.resolve(textDirection);

    return FluxNotchShape(
      borderRadius: borderRadius,
      notchRadius: notch.notchRadius,
      notchPosition: notch.fallbackPosition,
      notchPositionResolver: notch.isTargeted ? _resolveNotchPosition : null,
      notchEdge: notch.edge,
      notchSide: notch.notchSide,
      side: theme.resolveBorderSide(context),
    );
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
    required TextDirection textDirection,
    required BoxConstraints? parentConstraints,
  }) {
    final _PartitionedLayers layers = _partitionLayers();

    final Widget mainContent =
        FluxCardLayout(
          mode: layout,
          mediaPosition: widget.mediaPosition,
          mediaSpan: widget.mediaSpan,
          theme: theme,
          resolvedPadding: resolvedPadding,
          divider: widget.divider,
          boundaryTrackers: widget.notch?.isTargeted == true ? _trackers : null,
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
      children: [
        ...layers.globalUnderlays.map(
          (underlay) => FluxUnderlay.buildPositioned(context, underlay),
        ),
        mainContent,
        ...layers.globalOverlays.map((overlay) => Positioned.fill(child: overlay)),
      ],
    );
  }

  Widget _buildContentTree(Widget cardContent) {
    final List<Widget> stackLayers = <Widget>[
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
    final Color cardColor = theme.cardColor ?? Theme.of(context).colorScheme.surface;
    final Color shadowColor = theme.shadowColor ?? Theme.of(context).shadowColor;

    final double elevation = theme.elevation > 0
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

  Widget _wrapSemantics(Widget child) {
    if (widget.semanticLabel == null) {
      return child;
    }

    return Semantics(
      container: true,
      button: widget.onTap != null || widget.onLongPress != null,
      label: widget.semanticLabel,
      child: child,
    );
  }

  _PartitionedLayers _partitionLayers() {
    final List<Widget> allUnderlays = widget.underlays ?? const <Widget>[];
    final List<Widget> allOverlays = widget.overlays ?? const <Widget>[];

    final Map<FluxTarget, List<Widget>> underlaysByTarget = <FluxTarget, List<Widget>>{};
    final Map<FluxTarget, List<Widget>> overlaysByTarget = <FluxTarget, List<Widget>>{};
    final List<Widget> multiUnderlays = <Widget>[];
    final List<Widget> multiOverlays = <Widget>[];
    final List<Widget> globalUnderlays = <Widget>[];
    final List<Widget> globalOverlays = <Widget>[];

    for (final Widget underlay in allUnderlays) {
      if (underlay is FluxUnderlay) {
        if (underlay.isGlobal) {
          globalUnderlays.add(underlay);
        } else if (underlay.targets.length == 1) {
          (underlaysByTarget[underlay.targets.first] ??= <Widget>[]).add(underlay);
        } else {
          multiUnderlays.add(underlay);
        }
      } else {
        globalUnderlays.add(underlay);
      }
    }

    for (final Widget overlay in allOverlays) {
      if (overlay is FluxOverlay) {
        if (overlay.isGlobal) {
          globalOverlays.add(overlay);
        } else if (overlay.targets.length == 1) {
          (overlaysByTarget[overlay.targets.first] ??= <Widget>[]).add(overlay);
        } else {
          multiOverlays.add(overlay);
        }
      } else {
        globalOverlays.add(overlay);
      }
    }

    int zIndexOf(Widget widget) {
      if (widget is FluxOverlay) return widget.zIndex;
      if (widget is FluxUnderlay) return widget.zIndex;
      return 0;
    }

    globalOverlays.sort((a, b) => zIndexOf(a).compareTo(zIndexOf(b)));
    multiOverlays.sort((a, b) => zIndexOf(a).compareTo(zIndexOf(b)));
    for (final List<Widget> list in overlaysByTarget.values) {
      list.sort((a, b) => zIndexOf(a).compareTo(zIndexOf(b)));
    }

    globalUnderlays.sort((a, b) => zIndexOf(a).compareTo(zIndexOf(b)));
    for (final List<Widget> list in underlaysByTarget.values) {
      list.sort((a, b) => zIndexOf(a).compareTo(zIndexOf(b)));
    }

    // Keep the original intended reverse ordering for multi-underlays.
    multiUnderlays.sort((a, b) => zIndexOf(b).compareTo(zIndexOf(a)));

    return _PartitionedLayers(
      underlaysByTarget: underlaysByTarget,
      overlaysByTarget: overlaysByTarget,
      multiUnderlays: multiUnderlays,
      multiOverlays: multiOverlays,
      globalUnderlays: globalUnderlays,
      globalOverlays: globalOverlays,
    );
  }

  double? _resolveNotchPosition(Rect cardRect) {
    final FluxNotch? notch = widget.notch;
    if (notch == null || !notch.isTargeted) {
      return null;
    }

    final RenderBox? markerBox = _trackers[notch.boundary!]?.renderBox;
    final RenderBox? cardBox = _cardTracker.renderBox;

    if (markerBox == null || cardBox == null) {
      return null;
    }

    try {
      final TextDirection textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
      final Alignment resolvedAlignment = notch.boundaryAlignment.resolve(textDirection);

      final Offset pointInMarker = resolvedAlignment.alongSize(markerBox.size);
      final Offset pointInCard = markerBox.localToGlobal(pointInMarker, ancestor: cardBox);

      if (notch.edge == FluxNotchEdge.vertical) {
        return ((pointInCard.dy + notch.boundaryOffset) / cardRect.height).clamp(0.0, 1.0);
      }

      return ((pointInCard.dx + notch.boundaryOffset) / cardRect.width).clamp(0.0, 1.0);
    } catch (_) {
      return null;
    }
  }
}

class _PartitionedLayers {
  const _PartitionedLayers({
    required this.underlaysByTarget,
    required this.overlaysByTarget,
    required this.multiUnderlays,
    required this.multiOverlays,
    required this.globalUnderlays,
    required this.globalOverlays,
  });

  final Map<FluxTarget, List<Widget>> underlaysByTarget;
  final Map<FluxTarget, List<Widget>> overlaysByTarget;
  final List<Widget> multiUnderlays;
  final List<Widget> multiOverlays;
  final List<Widget> globalUnderlays;
  final List<Widget> globalOverlays;
}
