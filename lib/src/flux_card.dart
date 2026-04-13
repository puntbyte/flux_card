import 'package:flutter/material.dart';

import 'components/flux_background.dart';
import 'components/flux_overlay.dart';
import 'core/constraints.dart';
import 'core/enums.dart';
import 'core/theme.dart';
import 'divider/flux_divider.dart';
import 'layout/flux_card_layout.dart';
import 'loading/flux_card_skeleton.dart';
import 'notch/flux_notch.dart';
import 'shapes/flux_notch_shape.dart';

/// A constraint-aware, domain-agnostic, composition-first card widget.
///
/// ## Slots
/// [FluxCard] arranges content in up to four named slots: [media], [header],
/// [body], and [footer].
///
/// ## Layout modes
/// [FluxLayoutMode.responsive] switches between column and row layouts at
/// [FluxCardThemeData.responsiveBreakpoint].
///
/// ## Backgrounds & overlays
/// Both support [FluxTarget] scoping. [FluxOverlay] children are fully
/// interactive and respect all [Alignment] values including bottom-edge.
///
/// ## Ripple
/// The [InkWell] wraps the card's content [Stack] as a direct child of the
/// card's [Material]. Child widgets (buttons, chips) still receive their own
/// taps — the ripple only fires on empty card space — and [Ink.image] paints
/// images on the Material ink layer so the ripple sweeps across them too.
///
/// ## Notch
/// [notch] clips the card to a rounded-rectangle-with-semicircular-notches
/// outline and optionally paints a border on top. Use [FluxNotch] (targeted)
/// to snap the notch to a slot boundary, or [FluxNotch.free] for a fixed
/// fractional position. When [notch] is set, [FluxCardThemeData.shape] is
/// ignored but all other theme tokens (borderRadius, elevation, etc.) apply.
///
/// ## Divider
/// [divider] places a widget at each named slot boundary. Use [FluxDivider]
/// with any child widget; [FluxDashedDivider] is the built-in choice for
/// notch-style perforated lines.
///
/// ## Decoration
/// [decoration] paints a [BoxDecoration] (gradient, border, etc.) as a layer
/// directly on the card surface, under all content.
///
/// ## Loading
/// [loading] replaces the card with a built-in shimmer skeleton. Supply
/// [loadingWrapper] to integrate an external shimmer package.
class FluxCard extends StatefulWidget {
  const FluxCard({
    super.key,
    this.layout = FluxLayoutMode.column,
    this.mediaPosition = FluxMediaPosition.start,
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

  // ── Layout ────────────────────────────────────────────────────────────────

  final FluxLayoutMode layout;
  final FluxMediaPosition mediaPosition;

  // ── Slots ─────────────────────────────────────────────────────────────────

  final Widget? media;
  final Widget? header;
  final Widget? body;
  final Widget? footer;

  // ── Decoration ────────────────────────────────────────────────────────────

  final List<Widget>? overlays;
  final List<Widget>? backgrounds;
  final Color? foregroundColor;

  /// Optional [BoxDecoration] painted directly on the card surface, under all
  /// slot content. Use for gradient fills, custom borders, or combined effects
  /// without a custom [ShapeBorder].
  final BoxDecoration? decoration;

  /// Notch geometry applied to the card — clips to a rounded-rectangle outline
  /// with semicircular notches, and optionally paints a border on top.
  ///
  /// When set, [FluxCardThemeData.shape] is ignored. Use [FluxNotch] to target
  /// a slot boundary, or [FluxNotch.free] for a fixed fractional position.
  final FluxNotch? notch;

  /// Optional divider widget(s) inserted at named slot boundaries.
  ///
  /// Each [FluxDivider] property corresponds to one boundary. Use
  /// [FluxDashedDivider] for the classic ticket perforated line.
  final FluxDivider? divider;

  // ── Sizing ────────────────────────────────────────────────────────────────

  final double? width;
  final double? height;
  final bool fullWidth;
  final bool fullHeight;

  // ── Theme & interaction ───────────────────────────────────────────────────

  final FluxCardThemeData? theme;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  // ── Loading ───────────────────────────────────────────────────────────────

  final bool loading;
  final Widget Function(BuildContext context, Widget skeleton)? loadingWrapper;

  @override
  State<FluxCard> createState() => _FluxCardState();
}

class _FluxCardState extends State<FluxCard> {
  // ── Boundary measurement keys ─────────────────────────────────────────────
  // When notch.isTargeted, zero-height keyed SizedBoxes are inserted at
  // boundary positions in the layout. Their Y offsets relative to the card
  // give the measured notch fraction after the first frame.

  final _cardKey = GlobalKey();
  final _afterMediaKey = GlobalKey();
  final _afterHeaderKey = GlobalKey();
  final _afterBodyKey = GlobalKey();

  // double? _measuredNotchFraction;

  Map<FluxSlotBoundary, GlobalKey> get _boundaryKeys => {
    FluxSlotBoundary.afterMedia: _afterMediaKey,
    FluxSlotBoundary.afterHeader: _afterHeaderKey,
    FluxSlotBoundary.afterBody: _afterBodyKey,
  };

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  // @override
  // void initState() {
  //   super.initState();
  //   _scheduleMeasurement();
  // }

  // @override
  // void didUpdateWidget(FluxCard old) {
  //   super.didUpdateWidget(old);
  //   if (widget.notch?.boundary != old.notch?.boundary ||
  //       widget.layout != old.layout ||
  //       widget.mediaPosition != old.mediaPosition) {
  //     _measuredNotchFraction = null;
  //     _scheduleMeasurement();
  //   }
  // }

  // void _scheduleMeasurement() {
  //   if (widget.notch?.isTargeted != true) return;
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (mounted) _measureAndUpdate();
  //   });
  // }

  double? _resolveNotchPosition(Rect cardRect) {
    final notch = widget.notch;
    if (notch == null || !notch.isTargeted) return null;

    final markerKey = _boundaryKeys[notch.boundary!];
    if (markerKey == null) return null;

    final markerBox = markerKey.currentContext?.findRenderObject() as RenderBox?;
    final cardBox = _cardKey.currentContext?.findRenderObject() as RenderBox?;

    if (markerBox == null || cardBox == null) return null;

    try {
      final offset = markerBox.localToGlobal(Offset.zero, ancestor: cardBox);
      if (notch.edge == FluxNotchEdge.vertical) {
        return ((offset.dy + notch.boundaryOffset) / cardRect.height).clamp(0.0, 1.0);
      } else {
        return ((offset.dx + notch.boundaryOffset) / cardRect.width).clamp(0.0, 1.0);
      }
    } catch (e) {
      // If the render tree is momentarily detached, silently fail back to the default position.
      return null;
    }
  }

  // void _measureAndUpdate() {
  //   final notch = widget.notch;
  //   if (notch == null || !notch.isTargeted) return;
  //
  //   final cardBox = _cardKey.currentContext?.findRenderObject() as RenderBox?;
  //   if (cardBox == null || cardBox.size.height == 0 || cardBox.size.width == 0) return;
  //
  //   final markerKey = _boundaryKeys[notch.boundary!]!;
  //   final markerBox = markerKey.currentContext?.findRenderObject() as RenderBox?;
  //   if (markerBox == null) return;
  //
  //   try {
  //     final offset = markerBox.localToGlobal(Offset.zero, ancestor: cardBox);
  //
  //     final fraction = notch.edge == FluxNotchEdge.vertical
  //         ? ((offset.dy + notch.boundaryOffset) / cardBox.size.height).clamp(0.0, 1.0)
  //         : ((offset.dx + notch.boundaryOffset) / cardBox.size.width).clamp(0.0, 1.0);
  //
  //     if ((fraction - (_measuredNotchFraction ?? -1)).abs() > 0.001) {
  //       setState(() => _measuredNotchFraction = fraction);
  //     }
  //   } catch (e) {
  //     // ignore
  //   }
  // }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = widget.theme ?? FluxCardThemeData.of(context);
    final td = Directionality.maybeOf(context);
    final resolvedPadding = effectiveTheme.padding.resolve(td);

    return FluxCardTheme(
      data: effectiveTheme,
      child: LayoutBuilder(
        builder: (context, parentConstraints) {
          final cardConstraints = FluxCardConstraints(
            parentConstraints: parentConstraints,
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

          final cardColor = effectiveTheme.cardColor ?? Theme.of(context).colorScheme.surface;
          final shadowColor = effectiveTheme.shadowColor ?? Theme.of(context).shadowColor;
          final elevation = effectiveTheme.elevation > 0
              ? effectiveTheme.elevation
              : (effectiveTheme.defaultShadows?.isNotEmpty == true ? 4.0 : 0.0);

          // ── Notch geometry ────────────────────────────────────────────────
          final notch = widget.notch;
          final hasTargetedNotch = notch?.isTargeted == true;

          // final resolvedNotchPos = notch == null
          //     ? 0.5
          //     : (hasTargetedNotch
          //     ? (_measuredNotchFraction ?? notch.fallbackPosition)
          //     : notch.fallbackPosition);

          final resolvedNotchPos = notch?.fallbackPosition ?? 0.5;

          final notchBR =
              notch?.borderRadius ?? effectiveTheme.borderRadius.resolve(td ?? TextDirection.ltr);

          // ── Shape ─────────────────────────────────────────────────────────
          // When notch is set, build FluxNotchShape for clipping + shadow.
          // theme.shape is used for other custom shapes; ignored when notch set.
          final ShapeBorder effectiveShape = notch != null
              ? FluxNotchShape(
            borderRadius: notchBR,
            notchRadius: notch.notchRadius,
            notchPosition: resolvedNotchPos,
            notchPositionResolver: _resolveNotchPosition,
            notchEdge: notch.edge,
            notchSide: notch.notchSide,
            // No border here — painted on a top layer instead.
          )
              : effectiveTheme.resolveShape(context);

          // ── Card content ──────────────────────────────────────────────────
          final Widget cardContent = widget.loading
              ? FluxCardSkeleton(
                  layout: resolvedLayout,
                  mediaPosition: widget.mediaPosition,
                  theme: effectiveTheme,
                  hasMedia: widget.media != null,
                  hasHeader: widget.header != null,
                  hasBody: widget.body != null,
                  hasFooter: widget.footer != null,
                  loadingWrapper: widget.loadingWrapper,
                )
              : _buildLayers(resolvedLayout, effectiveTheme, resolvedPadding, td);

          // ── Stack layers ──────────────────────────────────────────────────
          // Order (bottom to top):
          //   1. Material  — background color, elevation shadow, clip
          //   2. InkWell   — wraps the Stack; child widgets still handle taps
          //   3. BoxDecoration surface layer (optional, under content)
          //   4. Card content (slots, backgrounds, overlays)
          //   5. Notch border painter (always topmost, so never occluded)

          final List<Widget> stackLayers = [
            // ── 4. Content ──────────────────────────────────────────────────
            DefaultTextStyle.merge(
              style: TextStyle(color: widget.foregroundColor),
              child: IconTheme.merge(
                data: IconThemeData(color: widget.foregroundColor),
                child: cardContent,
              ),
            ),

            // ── 5. Notch border ─────────────────────────────────────────────
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

          // Insert decoration layer (3) at the bottom when present.
          if (widget.decoration != null) {
            stackLayers.insert(
              0,
              Positioned.fill(
                child: IgnorePointer(child: DecoratedBox(decoration: widget.decoration!)),
              ),
            );
          }

          // ── 2. InkWell ────────────────────────────────────────────────────
          // Sits inside the card Material as a direct child. The ripple fires
          // on empty card areas; interactive children still receive their taps.
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

          return SizedBox(
            key: _cardKey,
            width: cardConstraints.resolvedWidth,
            height: cardConstraints.resolvedHeight,
            // ── 1. Material ─────────────────────────────────────────────────
            child: Material(
              color: cardColor,
              elevation: elevation,
              shadowColor: shadowColor,
              surfaceTintColor: effectiveTheme.surfaceTintColor,
              shape: effectiveShape,
              clipBehavior: effectiveTheme.clipBehavior,
              child: contentTree,
            ),
          );
        },
      ),
    );
  }

  // ── Layer assembly ────────────────────────────────────────────────────────

  Widget _buildLayers(
    FluxLayoutMode resolvedLayout,
    FluxCardThemeData theme,
    EdgeInsets resolvedPadding,
    TextDirection? td,
  ) {
    final allBgs = widget.backgrounds ?? const [];
    final allOvs = widget.overlays ?? const [];

    final globalBgs = allBgs.whereType<FluxBackground>().where((b) => b.isGlobal).toList();
    final globalOvs = allOvs.whereType<FluxOverlay>().where((o) => o.isGlobal).toList()
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    final extraGlobalBgs = allBgs.where((w) => w is! FluxBackground).toList();
    final extraGlobalOvs = allOvs.where((w) => w is! FluxOverlay).toList();

    final mainContent =
        FluxCardLayout(
          mode: resolvedLayout,
          mediaPosition: widget.mediaPosition,
          theme: theme,
          resolvedPadding: resolvedPadding,
          divider: widget.divider,
          boundaryKeys: widget.notch?.isTargeted == true ? _boundaryKeys : null,
        ).build(
          media: widget.media,
          header: widget.header,
          body: widget.body,
          footer: widget.footer,
          allBackgrounds: allBgs,
          allOverlays: allOvs,
        );

    final allGlobalBgs = [...extraGlobalBgs, ...globalBgs];
    final allGlobalOvs = [...extraGlobalOvs, ...globalOvs];

    if (allGlobalBgs.isEmpty && allGlobalOvs.isEmpty) return mainContent;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        ...allGlobalBgs.map((bg) => Positioned.fill(child: bg)),
        mainContent,
        ...allGlobalOvs.map((ov) => Positioned.fill(child: ov)),
      ],
    );
  }
}
