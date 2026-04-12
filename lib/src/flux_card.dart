import 'package:flutter/material.dart';
import 'package:flux_card/src/shapes/flux_ticket_shape.dart';

import 'components/flux_background.dart';
import 'components/flux_overlay.dart';
import 'core/constraints.dart';
import 'core/enums.dart';
import 'core/theme.dart';
import 'layout/flux_card_layout.dart';
import 'loading/flux_card_skeleton.dart';
import 'ticket/flux_slot_divider.dart';
import 'ticket/flux_ticket_decoration.dart';

/// A constraint-aware, domain-agnostic, composition-first card widget.
///
/// ## Slots
/// [FluxCard] arranges content in up to four named slots: [media], [header],
/// [body], and [footer].
///
/// ## Layout modes
/// [FluxLayoutMode.responsive] switches between column and row at
/// [FluxCardThemeData.responsiveBreakpoint].
///
/// ## Backgrounds & overlays
/// Both support [FluxTarget] scoping. [FluxOverlay] children are fully
/// interactive and respect all [Alignment] values including bottom-edge.
///
/// ## Ripple
/// The ink ripple renders ABOVE all content (including media) because the
/// [InkWell] lives on a transparent [Material] at the top of the card Stack.
///
/// ## Decoration
/// [decoration] paints a [BoxDecoration] (gradient, border, etc.) as a layer
/// directly on the card surface, under all content.
///
/// ## Ticket cards
/// [ticket] applies a [FluxTicketDecoration] — semicircular notches, correct
/// clipping, and a top-layer border. Use [FluxSlotBoundary] targeting for
/// automatic notch positioning measured from the actual slot layout.
///
/// ## Dividers
/// [dividers] inserts [FluxSlotDivider] widgets between slots.
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
    this.ticket,
    this.dividers,
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

  /// Ticket-style card decoration with notch clipping, slot-boundary targeting,
  /// and a correctly rendered border.
  ///
  /// When set, [FluxCardThemeData.shape] is ignored — ticket shape takes over.
  final FluxTicketDecoration? ticket;

  /// Dividers inserted between slots at named [FluxSlotBoundary] positions.
  final List<FluxSlotDivider>? dividers;

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
  // Used when ticket.notchAtBoundary is set. Zero-height keyed markers are
  // inserted at boundary positions in the layout; their Y offset relative to
  // the card gives the notch fraction.

  final _cardKey = GlobalKey();
  final _afterMediaKey = GlobalKey();
  final _afterHeaderKey = GlobalKey();
  final _afterBodyKey = GlobalKey();

  double? _measuredNotchFraction;

  Map<FluxSlotBoundary, GlobalKey> get _boundaryKeys => {
    FluxSlotBoundary.afterMedia: _afterMediaKey,
    FluxSlotBoundary.afterHeader: _afterHeaderKey,
    FluxSlotBoundary.afterBody: _afterBodyKey,
  };

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _scheduleMeasurement();
  }

  @override
  void didUpdateWidget(FluxCard old) {
    super.didUpdateWidget(old);
    if (widget.ticket?.notchAtBoundary != old.ticket?.notchAtBoundary ||
        widget.layout != old.layout ||
        widget.mediaPosition != old.mediaPosition) {
      _scheduleMeasurement();
    }
  }

  void _scheduleMeasurement() {
    if (widget.ticket?.notchAtBoundary == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _measureAndUpdate();
    });
  }

  void _measureAndUpdate() {
    final boundary = widget.ticket?.notchAtBoundary;
    if (boundary == null) return;

    final cardBox = _cardKey.currentContext?.findRenderObject() as RenderBox?;
    if (cardBox == null || cardBox.size.height == 0) return;

    final markerKey = _boundaryKeys[boundary]!;
    final markerBox = markerKey.currentContext?.findRenderObject() as RenderBox?;
    if (markerBox == null) return;

    final markerY = markerBox.localToGlobal(Offset.zero, ancestor: cardBox).dy;
    final offset = widget.ticket?.notchBoundaryOffset ?? 0.0;
    final fraction = ((markerY + offset) / cardBox.size.height).clamp(0.0, 1.0);

    if ((fraction - (_measuredNotchFraction ?? -1)).abs() > 0.001) {
      setState(() => _measuredNotchFraction = fraction);
    }
  }

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

          // Resolved ticket notch position — measured if available, else fallback.
          final ticket = widget.ticket;
          final ticketPos = _measuredNotchFraction ?? (ticket?.notchPosition ?? 0.5);

          // ── Shape ──────────────────────────────────────────────────────────
          // Ticket: use FluxTicketShape for shadow + clip. Border is painted
          // separately above content. Other cases: use theme shape.
          final ShapeBorder effectiveShape = ticket != null
              ? FluxTicketShape(
                  borderRadius: ticket.borderRadius,
                  notchRadius: ticket.notchRadius,
                  notchPosition: ticketPos,
                  notchEdge: ticket.notchEdge,
                  notchSide: ticket.notchSide,
                  // No border here — painted on top instead.
                )
              : effectiveTheme.resolveShape(context);

          // ── Card content ───────────────────────────────────────────────────
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

          // ── Stack layers ───────────────────────────────────────────────────
          // Layer order (bottom to top):
          //   1. Material (background color + elevation shadow + clip)
          //   2. BoxDecoration surface layer (optional, under content)
          //   3. Card content (slots, backgrounds, overlays)
          //   4. Transparent Material + InkWell (ripple above content)
          //   5. Ticket border painter (always on top)

          final List<Widget> stackLayers = [
            // ── 3. Content ───────────────────────────────────────────────────
            DefaultTextStyle.merge(
              style: TextStyle(color: widget.foregroundColor),
              child: IconTheme.merge(
                data: IconThemeData(color: widget.foregroundColor),
                child: cardContent,
              ),
            ),

            // ── 4. Ripple layer ───────────────────────────────────────────────
            // Transparent Material hosts ink effects; being topmost in the Stack
            // ensures the ripple paints above media and all other content.
            if (widget.onTap != null || widget.onLongPress != null)
              Positioned.fill(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: widget.onTap,
                    onLongPress: widget.onLongPress,
                    // Transparent splash so the underlying Material's ripple
                    // colour is used correctly.
                    splashColor: Theme.of(context).splashColor,
                    highlightColor: Theme.of(context).highlightColor,
                  ),
                ),
              ),

            // ── 5. Ticket border ─────────────────────────────────────────────
            if (ticket != null && ticket.side != BorderSide.none)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: ticket.borderPainter(ticketPos, td)),
                ),
              ),
          ];

          // Insert decoration layer (item 2) at the bottom when present.
          if (widget.decoration != null) {
            stackLayers.insert(
              0,
              Positioned.fill(
                child: IgnorePointer(child: DecoratedBox(decoration: widget.decoration!)),
              ),
            );
          }

          return SizedBox(
            key: _cardKey,
            width: cardConstraints.resolvedWidth,
            height: cardConstraints.resolvedHeight,
            child: Material(
              color: cardColor,
              elevation: elevation,
              shadowColor: shadowColor,
              surfaceTintColor: effectiveTheme.surfaceTintColor,
              shape: effectiveShape,
              clipBehavior: effectiveTheme.clipBehavior,
              child: Stack(fit: StackFit.passthrough, children: stackLayers),
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
          dividers: widget.dividers,
          boundaryKeys: widget.ticket?.notchAtBoundary != null ? _boundaryKeys : null,
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
