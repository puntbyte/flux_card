import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../divider/flux_divider.dart';
import 'boundary_tracker.dart';

/// Static helpers that compose individual card slots and content groups.
abstract final class SlotResolver {

  static Widget? wrapSlot({
    required FluxTarget target,
    required Widget? child,
    required Map<FluxTarget, List<Widget>> bgsByTarget,
    required Map<FluxTarget, List<Widget>> ovsByTarget,
    EdgeInsets? contentPadding,
  }) {
    if (child == null) return null;

    final bgs = bgsByTarget[target] ?? const [];
    final ovs = ovsByTarget[target] ?? const[];

    final Widget paddedChild =
    (contentPadding != null && contentPadding != EdgeInsets.zero)
        ? Padding(padding: contentPadding, child: child)
        : child;

    if (bgs.isEmpty && ovs.isEmpty) return paddedChild;

    return Stack(
      fit: StackFit.passthrough,
      children:[
        ...bgs.map((bg) => Positioned.fill(child: bg)),
        paddedChild,
        ...ovs.map((ov) => Positioned.fill(child: ov)),
      ],
    );
  }

  static Widget verticalGroup({
    required List<Widget?> slots,
    required double spacing,
  }) {
    final children = <Widget>[];
    for (final slot in slots) {
      if (slot == null) continue;
      if (children.isNotEmpty && spacing > 0) {
        children.add(SizedBox(height: spacing));
      }
      children.add(slot);
    }
    if (children.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  static Widget? contentColumn({
    required List<(FluxTarget, Widget?)> entries,
    required Map<FluxTarget, List<Widget>> bgsByTarget,
    required Map<FluxTarget, List<Widget>> ovsByTarget,
    required EdgeInsets padding,
    required double spacing,
    FluxDivider? divider,
    Map<FluxSlotBoundary, BoundaryTracker>? boundaryTrackers,
  }) {
    final present = entries.where((e) => e.$2 != null).toList();
    if (present.isEmpty) return null;

    final children = <Widget>[];

    for (int i = 0; i < present.length; i++) {
      final (target, child) = present[i];

      final slotPad = EdgeInsets.only(
        left: padding.left,
        right: padding.right,
        top: i == 0 ? padding.top : spacing / 2,
        bottom: i == present.length - 1 ? padding.bottom : spacing / 2,
      );

      final wrapped = wrapSlot(
        target: target,
        child: child,
        bgsByTarget: bgsByTarget,
        ovsByTarget: ovsByTarget,
        contentPadding: slotPad,
      );
      if (wrapped != null) children.add(wrapped);

      if (i < present.length - 1) {
        final boundary = _boundaryBetween(present[i].$1, present[i + 1].$1);
        if (boundary != null) {
          final tracker = boundaryTrackers?[boundary];
          if (tracker != null) {
            children.add(BoundaryMarker(
                tracker: tracker,
                child: const SizedBox(height: 0, width: double.infinity)
            ));
          }
          final dividerWidget = divider?.widgetFor(boundary);
          if (dividerWidget != null) {
            children.add(dividerWidget);
          }
        }
      }
    }

    if (children.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  static FluxSlotBoundary? _boundaryBetween(FluxTarget a, FluxTarget b) {
    if (a == FluxTarget.header && b == FluxTarget.body) {
      return FluxSlotBoundary.afterHeader;
    }
    if (a == FluxTarget.body && b == FluxTarget.footer) {
      return FluxSlotBoundary.afterBody;
    }
    if (a == FluxTarget.header && b == FluxTarget.footer) {
      return FluxSlotBoundary.afterHeader;
    }
    return null;
  }
}