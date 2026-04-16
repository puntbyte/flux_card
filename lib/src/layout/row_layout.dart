import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'boundary_tracker.dart';
import 'layout_delegate.dart';
import 'match_height_row.dart';
import 'slot_resolver.dart';

class FluxRowLayout extends FluxLayoutDelegate {
  const FluxRowLayout({
    required super.mediaPosition,
    required super.mediaSpan,
    required super.theme,
    required super.resolvedPadding,
    super.divider,
    super.boundaryTrackers,
    super.slotTrackers,
    super.parentConstraints,
  });

  @override
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
  }) {
    if (mediaSlot == null) {
      return buildFullContentColumn(
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
      // FIX: Explicitly cast to FluxSlotWrapper to resolve the property
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
        underlaysByTarget: underlaysByTarget,
        ovsByTarget: ovsByTarget,
        contentPadding: slotPad,
        tracker: slotTrackers?[target],
      )!;

      final spanType = _getSpanType(target);

      if (spanType < 0) {
        beforeCol.add(slotWidget);
      } else if (spanType == 0) {
        inCol.add(slotWidget);
      } else {
        afterCol.add(slotWidget);
      }

      if (i < present.length - 1) {
        final nextTarget = present[i + 1].$1;
        final gapWidget = _buildRowGapBetween(target, nextTarget);
        final nextSpanType = _getSpanType(nextTarget);

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

    final inColWidget = inCol.isNotEmpty
        ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: inCol)
        : const SizedBox.shrink();

    final rowWidget = FluxMatchHeightRow(
      media: mediaSlot,
      content: inColWidget,
      flexMedia: theme.flexMedia,
      flexContent: theme.flexContent,
      mediaStart: mediaPosition == FluxMediaPosition.start,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [...beforeCol, rowWidget, ...afterCol],
    );
  }

  Widget _buildRowGapBetween(FluxTarget target, FluxTarget nextTarget) {
    final boundary = SlotResolver.boundaryBetween(target, nextTarget);
    if (boundary != null) {
      final tracker = boundaryTrackers?[boundary];
      final div = divider?.widgetFor(boundary);

      if (tracker != null || div != null) {
        Widget centerWidget = div ?? const SizedBox(height: 0, width: double.infinity);
        if (tracker != null) {
          centerWidget = BoundaryMarker(tracker: tracker, child: centerWidget);
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: theme.spacing / 2),
            centerWidget,
            SizedBox(height: theme.spacing / 2),
          ],
        );
      }
    }
    return SizedBox(height: theme.spacing);
  }

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
