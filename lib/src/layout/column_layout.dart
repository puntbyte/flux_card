import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'layout_delegate.dart';
import 'slot_resolver.dart';

class FluxColumnLayout extends FluxLayoutDelegate {
  const FluxColumnLayout({
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

    return SlotResolver.verticalGroup(
      slots: mediaPosition == FluxMediaPosition.start
          ? [mediaSlot, marker, mediaDivider, content]
          : [content, marker, mediaDivider, mediaSlot],
      spacing: 0,
    );
  }
}
