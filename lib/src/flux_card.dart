import 'package:flutter/material.dart';

import 'components/flux_background.dart';
import 'components/flux_overlay.dart';
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
    this.backgrounds,
    this.foregroundColor,
    this.decoration,
    this.notch,
    this.divider,
    this.width,
    this.height,
    this.fullWidth = false,
    this.fullHeight = false,
    this.theme,
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
  final List<Widget>? backgrounds;
  final Color? foregroundColor;
  final BoxDecoration? decoration;
  final FluxNotch? notch;
  final FluxDivider? divider;
  final double? width;
  final double? height;
  final bool fullWidth;
  final bool fullHeight;
  final FluxCardThemeData? theme;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool loading;
  final Widget Function(BuildContext context, Widget skeleton)? loadingWrapper;

  @override
  State<FluxCard> createState() => _FluxCardState();
}

class _FluxCardState extends State<FluxCard> {
  // ── Boundary tracking (Zero-cost alternative to GlobalKey) ──────────────
  final _cardTracker = BoundaryTracker();
  final _afterMediaTracker = BoundaryTracker();
  final _afterHeaderTracker = BoundaryTracker();
  final _afterBodyTracker = BoundaryTracker();

  Map<FluxSlotBoundary, BoundaryTracker> get _trackers => {
    FluxSlotBoundary.afterMedia: _afterMediaTracker,
    FluxSlotBoundary.afterHeader: _afterHeaderTracker,
    FluxSlotBoundary.afterBody: _afterBodyTracker,
  };

  /// Dynamically resolves the exact rendering pixel coordinates of the targeted
  /// notch boundary during the paint phase without triggering a rebuild.
  double? _resolveNotchPosition(Rect cardRect) {
    final notch = widget.notch;
    if (notch == null || !notch.isTargeted) return null;

    final markerBox = _trackers[notch.boundary!]?.renderBox;
    final cardBox = _cardTracker.renderBox;

    if (markerBox == null || cardBox == null) return null;

    try {
      final offset = markerBox.localToGlobal(Offset.zero, ancestor: cardBox);
      if (notch.edge == FluxNotchEdge.vertical) {
        return ((offset.dy + notch.boundaryOffset) / cardRect.height).clamp(0.0, 1.0);
      } else {
        return ((offset.dx + notch.boundaryOffset) / cardRect.width).clamp(0.0, 1.0);
      }
    } catch (e) {
      // Graceful fallback if the tree is momentarily detached
      return null;
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = widget.theme ?? FluxCardThemeData.of(context);
    final td = Directionality.maybeOf(context);
    final resolvedPadding = effectiveTheme.padding.resolve(td);

    // Helper method to build the actual card
    Widget buildCard(BoxConstraints? parentConstraints) {
      final cardConstraints = FluxCardConstraints(
        parentConstraints: parentConstraints ?? const BoxConstraints(),
        explicitWidth: widget.width,
        explicitHeight: widget.height,
        fullWidth: widget.fullWidth,
        fullHeight: widget.fullHeight,
      );

      final resolvedLayout = widget.layout == FluxLayoutMode.responsive
          ? (cardConstraints.availableWidth >= effectiveTheme.responsiveBreakpoint
                ? FluxLayoutMode.row
                : FluxLayoutMode.column)
          : widget.layout;

      // ── Notch & Shape ──────────────────────────────────────────
      final notch = widget.notch;
      final resolvedNotchPos = notch?.fallbackPosition ?? 0.5;
      final notchBR =
          notch?.borderRadius ?? effectiveTheme.borderRadius.resolve(td ?? TextDirection.ltr);

      final ShapeBorder effectiveShape = notch != null
          ? FluxNotchShape(
              borderRadius: notchBR,
              notchRadius: notch.notchRadius,
              notchPosition: resolvedNotchPos,
              notchPositionResolver: _resolveNotchPosition,
              notchEdge: notch.edge,
              notchSide: notch.notchSide,
            )
          : effectiveTheme.resolveShape(context);

      // ── Card content ───────────────────────────────────────────
      final Widget cardContent = widget.loading
          ? FluxCardSkeleton(
              layout: resolvedLayout,
              mediaPosition: widget.mediaPosition,
              mediaSpan: widget.mediaSpan,
              theme: effectiveTheme,
              hasMedia: widget.media != null,
              hasHeader: widget.header != null,
              hasBody: widget.body != null,
              hasFooter: widget.footer != null,
              loadingWrapper: widget.loadingWrapper,
            )
          : _buildLayers(resolvedLayout, effectiveTheme, resolvedPadding, td, parentConstraints);

      // ── Stack layers ───────────────────────────────────────────
      final List<Widget> stackLayers = [
        DefaultTextStyle.merge(
          style: TextStyle(color: widget.foregroundColor),
          child: IconTheme.merge(
            data: IconThemeData(color: widget.foregroundColor),
            child: cardContent,
          ),
        ),
        if (notch != null && notch.side != BorderSide.none)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: notch.buildBorderPainter(
                  resolvedNotchPos,
                  notchBR,
                  td,
                  notchPositionResolver: _resolveNotchPosition,
                ),
              ),
            ),
          ),
      ];

      if (widget.decoration != null) {
        stackLayers.insert(
          0,
          Positioned.fill(
            child: IgnorePointer(child: DecoratedBox(decoration: widget.decoration!)),
          ),
        );
      }

      Widget contentTree = Stack(fit: StackFit.passthrough, children: stackLayers);
      if (widget.onTap != null || widget.onLongPress != null) {
        contentTree = InkWell(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          splashColor: Theme.of(context).splashColor,
          highlightColor: Theme.of(context).highlightColor,
          child: contentTree,
        );
      }

      final cardColor = effectiveTheme.cardColor ?? Theme.of(context).colorScheme.surface;
      final shadowColor = effectiveTheme.shadowColor ?? Theme.of(context).shadowColor;
      final elevation = effectiveTheme.elevation > 0
          ? effectiveTheme.elevation
          : (effectiveTheme.defaultShadows?.isNotEmpty == true ? 4.0 : 0.0);

      return BoundaryMarker(
        tracker: _cardTracker,
        child: SizedBox(
          width: cardConstraints.resolvedWidth,
          height: cardConstraints.resolvedHeight,
          child: Material(
            color: cardColor,
            elevation: elevation,
            shadowColor: shadowColor,
            surfaceTintColor: effectiveTheme.surfaceTintColor,
            shape: effectiveShape,
            clipBehavior: effectiveTheme.clipBehavior,
            child: contentTree,
          ),
        ),
      );
    }

    // OPTIMIZATION: Only use LayoutBuilder if we absolutely need to measure the parent.
    // If it's a fixed layout and not expanding to parent bounds, bypass LayoutBuilder entirely!
    final needsLayoutBuilder =
        widget.layout == FluxLayoutMode.responsive || widget.fullWidth || widget.fullHeight;

    return FluxCardTheme(
      data: effectiveTheme,
      child: needsLayoutBuilder
          ? LayoutBuilder(builder: (ctx, constraints) => buildCard(constraints))
          : buildCard(null),
    );
  }

  // ── Layer assembly (O(1) Slot Lookup Optimization) ──────────────────────

  Widget _buildLayers(
      FluxLayoutMode resolvedLayout,
      FluxCardThemeData theme,
      EdgeInsets resolvedPadding,
      TextDirection? td,
      BoxConstraints? parentConstraints,
      ) {
    final allBgs = widget.backgrounds ?? const [];
    final allOvs = widget.overlays ?? const[];

    final bgsByTarget = <FluxTarget, List<Widget>>{};
    final ovsByTarget = <FluxTarget, List<Widget>>{};
    final multiBgs = <Widget>[];
    final multiOvs = <Widget>[];
    final globalBgs = <Widget>[];
    final globalOvs = <Widget>[];

    for (final bg in allBgs) {
      if (bg is FluxBackground) {
        if (bg.isGlobal) {
          globalBgs.add(bg);
        } else if (bg.targets.length == 1) {
          (bgsByTarget[bg.targets.first] ??=[]).add(bg);
        } else {
          multiBgs.add(bg); // Caught for grouping
        }
      } else {
        globalBgs.add(bg);
      }
    }

    for (final ov in allOvs) {
      if (ov is FluxOverlay) {
        if (ov.isGlobal) {
          globalOvs.add(ov);
        } else if (ov.targets.length == 1) {
          (ovsByTarget[ov.targets.first] ??=[]).add(ov);
        } else {
          multiOvs.add(ov); // Caught for grouping
        }
      } else {
        globalOvs.add(ov);
      }
    }

    int getZIndex(Widget w) => w is FluxOverlay ? w.zIndex : 0;

    globalOvs.sort((a, b) => getZIndex(a).compareTo(getZIndex(b)));
    multiOvs.sort((a, b) => getZIndex(a).compareTo(getZIndex(b)));
    for (final list in ovsByTarget.values) {
      list.sort((a, b) => getZIndex(a).compareTo(getZIndex(b)));
    }

    final mainContent = FluxCardLayout(
      mode: resolvedLayout,
      mediaPosition: widget.mediaPosition,
      mediaSpan: widget.mediaSpan,
      theme: theme,
      resolvedPadding: resolvedPadding,
      divider: widget.divider,
      boundaryTrackers: widget.notch?.isTargeted == true ? _trackers : null,
      parentConstraints: parentConstraints,
    ).build(
      media: widget.media,
      header: widget.header,
      body: widget.body,
      footer: widget.footer,
      bgsByTarget: bgsByTarget,
      ovsByTarget: ovsByTarget,
      multiBgs: multiBgs, // Passed down
      multiOvs: multiOvs, // Passed down
    );

    if (globalBgs.isEmpty && globalOvs.isEmpty) return mainContent;

    return Stack(
      fit: StackFit.passthrough,
      children:[
        ...globalBgs.map((bg) => Positioned.fill(child: bg)),
        mainContent,
        ...globalOvs.map((ov) => Positioned.fill(child: ov)),
      ],
    );
  }
}
