import 'package:flutter/material.dart';

import '../components/flux_background.dart';
import '../components/flux_overlay.dart';
import '../core/enums.dart';
import '../divider/flux_divider.dart';
import 'boundary_tracker.dart';

class _SlotBlock {
  final Set<FluxTarget> targets;
  final Widget widget;

  _SlotBlock(this.targets, this.widget);
}

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
    final ovs = ovsByTarget[target] ?? const [];

    final Widget paddedChild = (contentPadding != null && contentPadding != EdgeInsets.zero)
        ? Padding(padding: contentPadding, child: child)
        : child;

    if (bgs.isEmpty && ovs.isEmpty) return paddedChild;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        ...bgs.map((bg) => Positioned.fill(child: bg)),
        paddedChild,
        ...ovs.map((ov) => Positioned.fill(child: ov)),
      ],
    );
  }

  static Widget verticalGroup({required List<Widget?> slots, required double spacing}) {
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

  /// Groups contiguous blocks and wraps them with multi-target decorations.
  static List<_SlotBlock> groupAndWrap(
    List<_SlotBlock> blocks,
    List<Widget> multiBgs,
    List<Widget> multiOvs,
  ) {
    var currentBlocks = List<_SlotBlock>.from(blocks);

    void applyDecoration(Widget decoration, Set<FluxTarget> targets, bool isBg) {
      int startIdx = -1;
      int endIdx = -1;

      // Find the start and end indices of the contiguous span
      for (int i = 0; i < currentBlocks.length; i++) {
        if (currentBlocks[i].targets.intersection(targets).isNotEmpty) {
          if (startIdx == -1) startIdx = i;
          endIdx = i;
        }
      }

      // If a span was found, wrap the sublist into a single Stack
      if (startIdx != -1 && endIdx != -1) {
        final sublist = currentBlocks.sublist(startIdx, endIdx + 1);
        final combinedTargets = sublist.expand((b) => b.targets).toSet();

        final column = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: sublist.map((b) => b.widget).toList(),
        );

        final stacked = Stack(
          fit: StackFit.passthrough,
          children: [
            if (isBg) Positioned.fill(child: decoration),
            column,
            if (!isBg) Positioned.fill(child: decoration),
          ],
        );

        currentBlocks.replaceRange(startIdx, endIdx + 1, [_SlotBlock(combinedTargets, stacked)]);
      }
    }

    for (final bg in multiBgs) {
      applyDecoration(bg, (bg as FluxBackground).targets, true);
    }
    for (final ov in multiOvs) {
      applyDecoration(ov, (ov as FluxOverlay).targets, false);
    }

    return currentBlocks;
  }

  static Widget? contentColumn({
    required List<(FluxTarget, Widget?)> entries,
    required Map<FluxTarget, List<Widget>> bgsByTarget,
    required Map<FluxTarget, List<Widget>> ovsByTarget,
    required List<Widget> multiBgs,
    required List<Widget> multiOvs,
    required EdgeInsets padding,
    required double spacing,
    FluxDivider? divider,
    Map<FluxSlotBoundary, BoundaryTracker>? boundaryTrackers,
  }) {
    final present = entries.where((e) => e.$2 != null).toList();
    if (present.isEmpty) return null;

    final blocks = <_SlotBlock>[];

    for (int i = 0; i < present.length; i++) {
      final target = present[i].$1;

      final slotPad = EdgeInsets.only(
        left: padding.left,
        right: padding.right,
        top: i == 0 ? padding.top : spacing / 2,
        bottom: i == present.length - 1 ? padding.bottom : spacing / 2,
      );

      final wrapped = wrapSlot(
        target: target,
        child: present[i].$2,
        bgsByTarget: bgsByTarget,
        ovsByTarget: ovsByTarget,
        contentPadding: slotPad,
      )!;

      // Group boundary markers and dividers with the gap so they are wrapped cleanly
      if (i > 0) {
        final prevTarget = present[i - 1].$1;
        final boundary = boundaryBetween(prevTarget, target);
        if (boundary != null) {
          final tracker = boundaryTrackers?[boundary];
          final div = divider?.widgetFor(boundary);
          if (tracker != null || div != null) {
            final boundaryWidget = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (tracker != null)
                  BoundaryMarker(
                    tracker: tracker,
                    child: const SizedBox(height: 0, width: double.infinity),
                  ),
                if (div != null) div,
              ],
            );
            blocks.add(_SlotBlock({prevTarget, target}, boundaryWidget));
          }
        }
      }

      blocks.add(_SlotBlock({target}, wrapped));
    }

    // Apply the grouping algorithm!
    final groupedBlocks = groupAndWrap(blocks, multiBgs, multiOvs);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: groupedBlocks.map((b) => b.widget).toList(),
    );
  }

  static FluxSlotBoundary? boundaryBetween(FluxTarget a, FluxTarget b) {
    if (a == FluxTarget.header && b == FluxTarget.body) return FluxSlotBoundary.afterHeader;
    if (a == FluxTarget.body && b == FluxTarget.footer) return FluxSlotBoundary.afterBody;
    if (a == FluxTarget.header && b == FluxTarget.footer) return FluxSlotBoundary.afterHeader;
    return null;
  }
}
