import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../core/theme.dart';
import '../divider/flux_divider.dart';
import 'boundary_tracker.dart';
import 'slot_resolver.dart';

/// Base delegate for [FluxCard] layout strategies.
abstract class FluxLayoutDelegate {
  const FluxLayoutDelegate({
    required this.mediaPosition,
    required this.mediaSpan,
    required this.theme,
    required this.resolvedPadding,
    this.divider,
    this.boundaryTrackers,
    this.slotTrackers,
    this.parentConstraints,
  });

  final FluxMediaPosition mediaPosition;
  final FluxMediaSpan mediaSpan;
  final FluxCardThemeData theme;
  final EdgeInsets resolvedPadding;
  final FluxDivider? divider;
  final Map<FluxSlotBoundary, BoundaryTracker>? boundaryTrackers;
  final Map<FluxTarget, BoundaryTracker>? slotTrackers;
  final BoxConstraints? parentConstraints;

  Widget build(
    BuildContext context, {
    Widget? mediaSlot,
    Widget? header,
    Widget? body,
    Widget? footer,
    required Map<FluxTarget, List<Widget>> underlaysByTarget,
    required Map<FluxTarget, List<Widget>> ovsByTarget,
    required List<Widget> multiUnderlays,
    required List<Widget> multiOvs,
  });

  // ─── SHARED HELPERS ──────────────────────────────────────────────────────────

  Widget? buildFullContentColumn(
    BuildContext context,
    Widget? header,
    Widget? body,
    Widget? footer,
    Map<FluxTarget, List<Widget>> underlaysByTarget,
    Map<FluxTarget, List<Widget>> ovsByTarget,
    List<Widget> multiUnderlays,
    List<Widget> multiOvs,
  ) {
    return buildSubColumn(
      context,
      [(FluxTarget.header, header), (FluxTarget.body, body), (FluxTarget.footer, footer)],
      underlaysByTarget,
      ovsByTarget,
      multiUnderlays,
      multiOvs,
    );
  }

  Widget? buildSubColumn(
    BuildContext context,
    List<(FluxTarget, Widget?)> entries,
    Map<FluxTarget, List<Widget>> underlaysByTarget,
    Map<FluxTarget, List<Widget>> ovsByTarget,
    List<Widget> multiUnderlays,
    List<Widget> multiOvs,
  ) {
    final present = entries.where((e) => e.$2 != null).toList();
    if (present.isEmpty) return null;

    return SlotResolver.contentColumn(
      context,
      entries: present,
      underlaysByTarget: underlaysByTarget,
      ovsByTarget: ovsByTarget,
      multiUnderlays: multiUnderlays,
      multiOvs: multiOvs,
      padding: resolvedPadding,
      spacing: theme.spacing,
      divider: divider,
      boundaryTrackers: boundaryTrackers,
      slotTrackers: slotTrackers,
    );
  }

  Widget? afterMediaMarker() {
    final tracker = boundaryTrackers?[FluxSlotBoundary.afterMedia];
    if (tracker == null) return null;
    return BoundaryMarker(
      tracker: tracker,
      child: const SizedBox(height: 0, width: double.infinity),
    );
  }
}
