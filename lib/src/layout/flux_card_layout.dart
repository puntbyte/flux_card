import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../core/theme.dart';
import '../divider/flux_divider.dart';
import 'boundary_tracker.dart';
import 'column_layout.dart';
import 'inline_layout.dart';
import 'layout_delegate.dart';
import 'row_layout.dart';
import 'slot_resolver.dart';

/// Facade for the layout engine. Routes to specific strategies based on layout mode.
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

  Widget build(
    BuildContext context, {
    Widget? media,
    Widget? header,
    Widget? body,
    Widget? footer,
    required Map<FluxTarget, List<Widget>> underlaysByTarget,
    required Map<FluxTarget, List<Widget>> ovsByTarget,
    required List<Widget> multiUnderlays,
    required List<Widget> multiOvs,
  }) {
    final mediaSlot = SlotResolver.wrapSlot(
      context,
      target: FluxTarget.media,
      child: media,
      underlaysByTarget: underlaysByTarget,
      ovsByTarget: ovsByTarget,
    );

    final delegate = _getDelegate();

    if (mode == FluxLayoutMode.responsive) {
      return delegate.buildFullContentColumn(
            context,
            header,
            body,
            footer,
            underlaysByTarget,
            ovsByTarget,
            multiUnderlays,
            multiOvs,
          ) ??
          const SizedBox.shrink();
    }

    return delegate.build(
      context,
      mediaSlot: mediaSlot,
      header: header,
      body: body,
      footer: footer,
      underlaysByTarget: underlaysByTarget,
      ovsByTarget: ovsByTarget,
      multiUnderlays: multiUnderlays,
      multiOvs: multiOvs,
    );
  }

  FluxLayoutDelegate _getDelegate() {
    switch (mode) {
      case FluxLayoutMode.column:
      case FluxLayoutMode.responsive:
        return FluxColumnLayout(
          mediaPosition: mediaPosition,
          mediaSpan: mediaSpan,
          theme: theme,
          resolvedPadding: resolvedPadding,
          divider: divider,
          boundaryTrackers: boundaryTrackers,
          parentConstraints: parentConstraints,
        );
      case FluxLayoutMode.row:
        return FluxRowLayout(
          mediaPosition: mediaPosition,
          mediaSpan: mediaSpan,
          theme: theme,
          resolvedPadding: resolvedPadding,
          divider: divider,
          boundaryTrackers: boundaryTrackers,
          parentConstraints: parentConstraints,
        );
      case FluxLayoutMode.inline:
        return FluxInlineLayout(
          mediaPosition: mediaPosition,
          mediaSpan: mediaSpan,
          theme: theme,
          resolvedPadding: resolvedPadding,
          divider: divider,
          boundaryTrackers: boundaryTrackers,
          parentConstraints: parentConstraints,
        );
    }
  }
}
