import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../core/theme.dart';
import '../divider/flux_divider.dart';
import 'boundary_tracker.dart';
import 'slot_resolver.dart';

/// Stateless layout engine for [FluxCard].
///
/// Handles the complex composition of Media, Header, Body, and Footer slots
/// based on the chosen [FluxLayoutMode], while injecting dividers, tracking
/// boundaries, and respecting padding overrides.
class FluxCardLayout {
  const FluxCardLayout({
    required this.mode,
    required this.mediaPosition,
    required this.mediaSpan,
    required this.theme,
    required this.resolvedPadding,
    this.divider,
    this.boundaryTrackers,
    this.parentConstraints,
  });

  final FluxLayoutMode mode;
  final FluxMediaPosition mediaPosition;
  final FluxMediaSpan mediaSpan;
  final FluxCardThemeData theme;
  final EdgeInsets resolvedPadding;
  final FluxDivider? divider;
  final Map<FluxSlotBoundary, BoundaryTracker>? boundaryTrackers;
  final BoxConstraints? parentConstraints;

  // ─── MAIN ENTRY POINT ────────────────────────────────────────────────────────

  Widget build(
    BuildContext context, {
    Widget? media,
    Widget? header,
    Widget? body,
    Widget? footer,
    required Map<FluxTarget, List<Widget>> bgsByTarget,
    required Map<FluxTarget, List<Widget>> ovsByTarget,
    required List<Widget> multiBgs,
    required List<Widget> multiOvs,
  }) {
    assert(
      mode != FluxLayoutMode.responsive,
      'Resolve responsive layout before calling FluxCardLayout.build().',
    );

    // Prepare the media slot with its decorations once
    final mediaSlot = SlotResolver.wrapSlot(
      context,
      target: FluxTarget.media,
      child: media,
      bgsByTarget: bgsByTarget,
      ovsByTarget: ovsByTarget,
    );

    // Route to the specific layout mode builder
    switch (mode) {
      case FluxLayoutMode.column:
        return _buildColumnLayout(
          context,
          mediaSlot,
          header,
          body,
          footer,
          bgsByTarget,
          ovsByTarget,
          multiBgs,
          multiOvs,
        );
      case FluxLayoutMode.row:
        return _buildRowLayout(
          context,
          mediaSlot,
          header,
          body,
          footer,
          bgsByTarget,
          ovsByTarget,
          multiBgs,
          multiOvs,
        );
      case FluxLayoutMode.inline:
        return _buildInlineLayout(
          context,
          mediaSlot,
          header,
          body,
          footer,
          bgsByTarget,
          ovsByTarget,
          multiBgs,
          multiOvs,
        );
      case FluxLayoutMode.responsive:
        return _buildFullContentColumn(
              context,
              header,
              body,
              footer,
              bgsByTarget,
              ovsByTarget,
              multiBgs,
              multiOvs,
            ) ??
            const SizedBox.shrink();
    }
  }

  // ─── LAYOUT MODE BUILDERS ────────────────────────────────────────────────────

  /// Builds the standard vertically stacked layout.
  Widget _buildColumnLayout(
    BuildContext context,
    Widget? mediaSlot,
    Widget? header,
    Widget? body,
    Widget? footer,
    Map<FluxTarget, List<Widget>> bgsByTarget,
    Map<FluxTarget, List<Widget>> ovsByTarget,
    List<Widget> multiBgs,
    List<Widget> multiOvs,
  ) {
    final content = _buildFullContentColumn(
      context,
      header,
      body,
      footer,
      bgsByTarget,
      ovsByTarget,
      multiBgs,
      multiOvs,
    );

    if (mediaSlot == null) return content ?? const SizedBox.shrink();

    final marker = _afterMediaMarker();
    final mediaDivider = divider?.afterMedia;

    return SlotResolver.verticalGroup(
      slots: mediaPosition == FluxMediaPosition.start
          ? [mediaSlot, marker, mediaDivider, content]
          : [content, marker, mediaDivider, mediaSlot],
      spacing: 0,
    );
  }

  /// Builds the inline layout where media splits the content slots.
  Widget _buildInlineLayout(
    BuildContext context,
    Widget? mediaSlot,
    Widget? header,
    Widget? body,
    Widget? footer,
    Map<FluxTarget, List<Widget>> bgsByTarget,
    Map<FluxTarget, List<Widget>> ovsByTarget,
    List<Widget> multiBgs,
    List<Widget> multiOvs,
  ) {
    final beforeEntries = mediaPosition == FluxMediaPosition.start
        ? <(FluxTarget, Widget?)>[(FluxTarget.header, header)]
        : <(FluxTarget, Widget?)>[(FluxTarget.header, header), (FluxTarget.body, body)];

    final afterEntries = mediaPosition == FluxMediaPosition.start
        ? <(FluxTarget, Widget?)>[(FluxTarget.body, body), (FluxTarget.footer, footer)]
        : <(FluxTarget, Widget?)>[(FluxTarget.footer, footer)];

    return SlotResolver.verticalGroup(
      slots: [
        _buildSubColumn(context, beforeEntries, bgsByTarget, ovsByTarget, multiBgs, multiOvs),
        _afterMediaMarker(),
        divider?.afterMedia,
        mediaSlot,
        _buildSubColumn(context, afterEntries, bgsByTarget, ovsByTarget, multiBgs, multiOvs),
      ],
      spacing: 0,
    );
  }

  /// Builds the complex Row layout, handling spanned media and intrinsic heights.
  Widget _buildRowLayout(
    BuildContext context,
    Widget? mediaSlot,
    Widget? header,
    Widget? body,
    Widget? footer,
    Map<FluxTarget, List<Widget>> bgsByTarget,
    Map<FluxTarget, List<Widget>> ovsByTarget,
    List<Widget> multiBgs,
    List<Widget> multiOvs,
  ) {
    if (mediaSlot == null) {
      return _buildFullContentColumn(
            context,
            header,
            body,
            footer,
            bgsByTarget,
            ovsByTarget,
            multiBgs,
            multiOvs,
          ) ??
          const SizedBox.shrink();
    }

    final present = [
      (FluxTarget.header, header),
      (FluxTarget.body, body),
      (FluxTarget.footer, footer),
    ].where((e) => e.$2 != null).toList();

    if (present.isEmpty) return mediaSlot;

    final beforeCol = <Widget>[];
    final inCol = <Widget>[];
    final afterCol = <Widget>[];

    for (int i = 0; i < present.length; i++) {
      final target = present[i].$1;
      final child = present[i].$2!;

      EdgeInsetsGeometry? overridePad;
      // --- FIX #1: Explicitly cast to FluxSlotWrapper to access the property ---
      if (child is FluxSlotWrapper) {
        overridePad = (child as FluxSlotWrapper).externalPaddingOverride;
      }

      final slotPad =
          overridePad ??
          EdgeInsets.only(
            left: resolvedPadding.left,
            right: resolvedPadding.right,
            top: i == 0 ? resolvedPadding.top : 0.0,
            bottom: i == present.length - 1 ? resolvedPadding.bottom : 0.0,
          );

      final slotWidget = SlotResolver.wrapSlot(
        context,
        target: target,
        child: child,
        bgsByTarget: bgsByTarget,
        ovsByTarget: ovsByTarget,
        contentPadding: slotPad,
      )!;

      final spanType = _getSpanType(target);

      // Route the slot widget to the correct layout column based on span
      if (spanType < 0) {
        beforeCol.add(slotWidget);
      } else if (spanType == 0) {
        inCol.add(slotWidget);
      } else {
        afterCol.add(slotWidget);
      }

      // Inject the gap/divider between this slot and the next
      if (i < present.length - 1) {
        final nextTarget = present[i + 1].$1;
        final gapWidget = _buildRowGapBetween(target, nextTarget);
        final nextSpanType = _getSpanType(nextTarget);

        // Intelligently route the gap to the right column so layout doesn't break
        if (spanType < 0 && nextSpanType < 0) {
          beforeCol.add(gapWidget);
        } else if (spanType == 0 && nextSpanType == 0) {
          inCol.add(gapWidget);
        } else if (spanType > 0 && nextSpanType > 0) {
          afterCol.add(gapWidget);
        } else if (spanType < 0 && nextSpanType >= 0) {
          beforeCol.add(gapWidget);
        } else if (spanType == 0 && nextSpanType > 0) {
          afterCol.add(gapWidget);
        }
      }
    }

    final rowContent = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: mediaPosition == FluxMediaPosition.start
          ? [
              Flexible(flex: theme.flexMedia, child: mediaSlot),
              Expanded(
                flex: theme.flexContent,
                child: inCol.isNotEmpty
                    ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: inCol)
                    : const SizedBox.shrink(),
              ),
            ]
          : [
              Expanded(
                flex: theme.flexContent,
                child: inCol.isNotEmpty
                    ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: inCol)
                    : const SizedBox.shrink(),
              ),
              Flexible(flex: theme.flexMedia, child: mediaSlot),
            ],
    );

    // OPTIMIZATION: Only apply IntrinsicHeight if the vertical height is unbounded
    final needsIntrinsicHeight = parentConstraints == null || !parentConstraints!.hasBoundedHeight;
    final rowWidget = needsIntrinsicHeight ? IntrinsicHeight(child: rowContent) : rowContent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [...beforeCol, rowWidget, ...afterCol],
    );
  }

  // ─── PRIVATE HELPERS ─────────────────────────────────────────────────────────

  /// Resolves the layout column containing Header, Body, and Footer.
  Widget? _buildFullContentColumn(
    BuildContext context,
    Widget? header,
    Widget? body,
    Widget? footer,
    Map<FluxTarget, List<Widget>> bgsByTarget,
    Map<FluxTarget, List<Widget>> ovsByTarget,
    List<Widget> multiBgs,
    List<Widget> multiOvs,
  ) {
    return _buildSubColumn(
      context,
      [(FluxTarget.header, header), (FluxTarget.body, body), (FluxTarget.footer, footer)],
      bgsByTarget,
      ovsByTarget,
      multiBgs,
      multiOvs,
    );
  }

  /// Builds a partial content column (used heavily by Inline layouts).
  Widget? _buildSubColumn(
    BuildContext context,
    List<(FluxTarget, Widget?)> entries,
    Map<FluxTarget, List<Widget>> bgsByTarget,
    Map<FluxTarget, List<Widget>> ovsByTarget,
    List<Widget> multiBgs,
    List<Widget> multiOvs,
  ) {
    return SlotResolver.contentColumn(
      context,
      entries: entries,
      bgsByTarget: bgsByTarget,
      ovsByTarget: ovsByTarget,
      multiBgs: multiBgs,
      multiOvs: multiOvs,
      padding: resolvedPadding,
      spacing: theme.spacing,
      divider: divider,
      boundaryTrackers: boundaryTrackers,
    );
  }

  /// Builds the tracker reference for the boundary immediately after the media slot.
  Widget? _afterMediaMarker() {
    final tracker = boundaryTrackers?[FluxSlotBoundary.afterMedia];
    if (tracker == null) return null;
    return BoundaryMarker(
      tracker: tracker,
      child: const SizedBox(height: 0, width: double.infinity),
    );
  }

  /// Constructs the structural layout gap between slots in Row mode, injecting
  /// trackers and dividers if required.
  Widget _buildRowGapBetween(FluxTarget target, FluxTarget nextTarget) {
    final boundary = SlotResolver.boundaryBetween(target, nextTarget);
    if (boundary != null) {
      final tracker = boundaryTrackers?[boundary];
      final div = divider?.widgetFor(boundary);

      if (tracker != null || div != null) {
        // Wrap the tracker around the divider here as well
        Widget centerWidget = div ?? const SizedBox(height: 0, width: double.infinity);
        if (tracker != null) {
          centerWidget = BoundaryMarker(tracker: tracker, child: centerWidget);
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:[
            SizedBox(height: theme.spacing / 2),
            centerWidget,
            SizedBox(height: theme.spacing / 2),
          ],
        );
      }
    }
    return SizedBox(height: theme.spacing);
  }

  /// Evaluates where a specific slot should render relative to the Media Row.
  /// Returns `<0` (before), `0` (inside Row), or `>0` (after).
  int _getSpanType(FluxTarget target) {
    switch (mediaSpan) {
      case FluxMediaSpan.all:
        return 0;
      case FluxMediaSpan.header:
        return target == FluxTarget.header ? 0 : 1;
      case FluxMediaSpan.body:
        if (target == FluxTarget.header) return -1;
        if (target == FluxTarget.body) return 0;
        return 1;
      case FluxMediaSpan.footer:
        return target == FluxTarget.footer ? 0 : -1;
      case FluxMediaSpan.headerAndBody:
        return target == FluxTarget.footer ? 1 : 0;
      case FluxMediaSpan.bodyAndFooter:
        return target == FluxTarget.header ? -1 : 0;
    }
  }
}
