import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'layout_delegate.dart';
import 'slot_resolver.dart';

class FluxInlineLayout extends FluxLayoutDelegate {
  const FluxInlineLayout({
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
    final beforeEntries = mediaPosition == FluxMediaPosition.start
        ? <(FluxTarget, Widget?)>[(FluxTarget.header, header)]
        : <(FluxTarget, Widget?)>[(FluxTarget.header, header), (FluxTarget.body, body)];

    final afterEntries = mediaPosition == FluxMediaPosition.start
        ? <(FluxTarget, Widget?)>[(FluxTarget.body, body), (FluxTarget.footer, footer)]
        : <(FluxTarget, Widget?)>[(FluxTarget.footer, footer)];

    return SlotResolver.verticalGroup(
      slots: [
        buildSubColumn(
          context,
          beforeEntries,
          underlaysByTarget,
          ovsByTarget,
          multiUnderlays,
          multiOvs,
        ),
        afterMediaMarker(),
        divider?.afterMedia,
        mediaSlot,
        buildSubColumn(
          context,
          afterEntries,
          underlaysByTarget,
          ovsByTarget,
          multiUnderlays,
          multiOvs,
        ),
      ],
      spacing: 0,
    );
  }
}
