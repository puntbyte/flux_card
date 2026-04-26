import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'layout_delegate.dart';
import 'slot_resolver.dart';

class FluxColumnLayout extends FluxLayoutDelegate {
  const FluxColumnLayout({
    required super.mediaPosition,
    required super.mediaSpan,
    required super.isMediaExpanded,
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
        double? fixedMediaWidth,
        Widget? header,
        Widget? body,
        Widget? footer,
        required Map<FluxTarget, List<Widget>> underlaysByTarget,
        required Map<FluxTarget, List<Widget>> ovsByTarget,
        required List<Widget> multiUnderlays,
        required List<Widget> multiOvs,
      }) {
    final content = buildFullContentColumn(
      context,
      header,
      body,
      footer,
      underlaysByTarget,
      ovsByTarget,
      multiUnderlays,
      multiOvs,
    );

    if (mediaSlot == null) return content ?? const SizedBox.shrink();

    final marker = afterMediaMarker();
    final mediaDivider = divider?.afterMedia;

    final actuallyExpand = isMediaExpanded;
    Widget effectiveMedia = mediaSlot;
    if (actuallyExpand) {
      effectiveMedia = Expanded(child: effectiveMedia);
    }

    return SlotResolver.verticalGroup(
      isExpanded: actuallyExpand,
      slots: mediaPosition == FluxMediaPosition.start
          ? [effectiveMedia, marker, mediaDivider, content]
          :[content, marker, mediaDivider, effectiveMedia],
      spacing: 0,
    );
  }
}