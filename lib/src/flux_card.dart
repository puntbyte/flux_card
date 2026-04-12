import 'package:flutter/material.dart';

import 'components/flux_background.dart';
import 'components/flux_overlay.dart';
import 'core/constraints.dart';
import 'core/enums.dart';
import 'core/theme.dart';
import 'layout/flux_card_layout.dart';
import 'layout/slot_resolver.dart';
import 'loading/flux_card_skeleton.dart';

/// A constraint-aware, domain-agnostic, composition-first card widget.
///
/// ## Slots
/// [FluxCard] arranges content in up to four named slots:
/// - **media** — image, video frame, map, or any visual widget.
/// - **header** — typically a [FluxSection] with title/subtitle/trailing.
/// - **body** — free-form content; use [FluxContent] for scroll/constraints.
/// - **footer** — typically a [FluxSection] with action buttons.
///
/// ## Layout modes
/// Control how the media slot relates to the content column via [layout].
/// [FluxLayoutMode.responsive] automatically switches between column and row
/// at [FluxCardThemeData.responsiveBreakpoint].
///
/// ## Backgrounds and overlays
/// [backgrounds] and [overlays] can be scoped to the whole card
/// ([FluxTarget.card]) or injected into a single slot
/// (e.g. `{FluxTarget.media}`). Slot backgrounds extend behind the slot's
/// padding area so they cover the full allocated width. See [FluxBackground]
/// and [FluxOverlay].
///
/// ## Theming
/// Per-card: pass [theme]. Subtree: wrap with [FluxCardTheme]. App-level:
/// add [FluxCardThemeData] to [ThemeData.extensions].
///
/// ## Loading state
/// Set [loading] to `true` to show a built-in shimmer skeleton. Provide
/// [loadingWrapper] to integrate an external shimmer package.
class FluxCard extends StatelessWidget {
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

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? FluxCardThemeData.of(context);

    return FluxCardTheme(
      data: effectiveTheme,
      child: LayoutBuilder(
        builder: (context, parentConstraints) {
          final cardConstraints = FluxCardConstraints(
            parentConstraints: parentConstraints,
            explicitWidth: width,
            explicitHeight: height,
            fullWidth: fullWidth,
            fullHeight: fullHeight,
          );

          final resolvedLayout = layout == FluxLayoutMode.responsive
              ? (cardConstraints.availableWidth >=
              effectiveTheme.responsiveBreakpoint
              ? FluxLayoutMode.row
              : FluxLayoutMode.column)
              : layout;

          final cardColor =
              effectiveTheme.cardColor ?? Theme.of(context).colorScheme.surface;
          final shadowColor =
              effectiveTheme.shadowColor ?? Theme.of(context).shadowColor;
          final elevation = effectiveTheme.elevation > 0
              ? effectiveTheme.elevation
              : (effectiveTheme.defaultShadows?.isNotEmpty == true ? 4.0 : 0.0);

          final Widget cardContent = loading
              ? FluxCardSkeleton(
            layout: resolvedLayout,
            mediaPosition: mediaPosition,
            theme: effectiveTheme,
            hasMedia: media != null,
            hasHeader: header != null,
            hasBody: body != null,
            hasFooter: footer != null,
            loadingWrapper: loadingWrapper,
          )
              : _buildLayers(context, resolvedLayout, effectiveTheme);

          return SizedBox(
            width: cardConstraints.resolvedWidth,
            height: cardConstraints.resolvedHeight,
            child: Material(
              color: cardColor,
              elevation: elevation,
              shadowColor: shadowColor,
              surfaceTintColor: effectiveTheme.surfaceTintColor,
              shape: effectiveTheme.resolveShape(context),
              clipBehavior: effectiveTheme.clipBehavior,
              child: InkWell(
                onTap: onTap,
                onLongPress: onLongPress,
                child: DefaultTextStyle.merge(
                  style: TextStyle(color: foregroundColor),
                  child: IconTheme.merge(
                    data: IconThemeData(color: foregroundColor),
                    child: cardContent,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Layer assembly ────────────────────────────────────────────────────────

  Widget _buildLayers(
      BuildContext context,
      FluxLayoutMode resolvedLayout,
      FluxCardThemeData theme,
      ) {
    final allBgs = backgrounds ?? const [];
    final allOvs = overlays ?? const [];

    // Resolve EdgeInsetsGeometry → EdgeInsets once, here.
    final resolvedPadding =
    theme.padding.resolve(Directionality.maybeOf(context));

    // ── Global (card-level) decorations ──────────────────────────────────

    final globalBgs = allBgs
        .whereType<FluxBackground>()
        .where((b) => b.isGlobal)
        .toList();

    final globalOvs = allOvs
        .whereType<FluxOverlay>()
        .where((o) => o.isGlobal)
        .toList()
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    // Non-FluxBackground / non-FluxOverlay widgets are treated as global.
    final extraGlobalBgs = allBgs.where((w) => w is! FluxBackground).toList();
    final extraGlobalOvs = allOvs.where((w) => w is! FluxOverlay).toList();

    // ── Main content ──────────────────────────────────────────────────────

    // FluxCardLayout handles slot wrapping (backgrounds, overlays, per-slot
    // padding) internally via SlotResolver.contentColumn.
    final mainContent = FluxCardLayout(
      mode: resolvedLayout,
      mediaPosition: mediaPosition,
      theme: theme,
      resolvedPadding: resolvedPadding,
    ).build(
      media: media,
      header: header,
      body: body,
      footer: footer,
      allBackgrounds: allBgs,
      allOverlays: allOvs,
    );

    // ── Global layer stack ────────────────────────────────────────────────

    final allGlobalBgs = [...extraGlobalBgs, ...globalBgs];
    final allGlobalOvs = [...extraGlobalOvs, ...globalOvs];

    if (allGlobalBgs.isEmpty && allGlobalOvs.isEmpty) return mainContent;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        ...allGlobalBgs.map((bg) => Positioned.fill(child: bg)),
        mainContent,
        // Global overlays are wrapped in Positioned.fill so their internal
        // Align widget has bounded dimensions, enabling bottom-edge alignments.
        ...allGlobalOvs.map((ov) => Positioned.fill(child: ov)),
      ],
    );
  }
}