import 'package:flutter/material.dart';

import '../components/flux_underlay.dart';
import '../components/flux_overlay.dart';
import '../core/enums.dart';
import '../divider/flux_divider.dart';
import 'boundary_tracker.dart';

/// Interface for components that override the layout engine's default padding.
abstract class FluxSlotWrapper {
  /// If non-null, this padding completely overrides the card's default padding for this slot.
  EdgeInsetsGeometry? get externalPaddingOverride;
}

class _SlotBlock {
  final Set<FluxTarget> targets;
  final Widget widget;

  _SlotBlock(this.targets, this.widget);
}

abstract final class SlotResolver {
  static Widget? wrapSlot(
    BuildContext context, {
    required FluxTarget target,
    required Widget? child,
    required Map<FluxTarget, List<Widget>> bgsByTarget,
    required Map<FluxTarget, List<Widget>> ovsByTarget,
    EdgeInsetsGeometry? contentPadding,
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
      clipBehavior: Clip.none,
      children: [
        ...bgs.map((bg) => FluxUnderlay.buildPositioned(context, bg)),
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

  static List<_SlotBlock> groupAndWrap(
    BuildContext context,
    List<_SlotBlock> blocks,
    List<Widget> multiBgs,
    List<Widget> multiOvs,
  ) {
    var currentBlocks = List<_SlotBlock>.from(blocks);

    void applyDecoration(Widget layerWidget, Set<FluxTarget> targets, bool isBg) {
      int startIdx = -1;
      int endIdx = -1;

      for (int i = 0; i < currentBlocks.length; i++) {
        if (currentBlocks[i].targets.intersection(targets).isNotEmpty) {
          if (startIdx == -1) startIdx = i;
          endIdx = i;
        }
      }

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
          clipBehavior: Clip.none,
          children: [
            if (isBg) FluxUnderlay.buildPositioned(context, layerWidget),
            column,
            if (!isBg) Positioned.fill(child: layerWidget),
          ],
        );

        currentBlocks.replaceRange(startIdx, endIdx + 1, [_SlotBlock(combinedTargets, stacked)]);
      }
    }

    for (final bg in multiBgs) {
      applyDecoration(bg, (bg as FluxUnderlay).targets, true);
    }
    for (final ov in multiOvs) {
      applyDecoration(ov, (ov as FluxOverlay).targets, false);
    }

    return currentBlocks;
  }

  static Widget? contentColumn(
    BuildContext context, {
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
      final child = present[i].$2!;

      // 1. Insert structural layout gaps between slots
      if (i > 0) {
        final prevTarget = present[i - 1].$1;
        final boundary = boundaryBetween(prevTarget, target);

        // --- FIX #2: Make logic more explicit to avoid analyzer confusion ---
        BoundaryTracker? tracker;
        Widget? div;
        if (boundary != null) {
          tracker = boundaryTrackers?[boundary];
          div = divider?.widgetFor(boundary);
        }

        Widget gapWidget;
        if (tracker != null || div != null) {
          gapWidget = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: spacing / 2),
              if (tracker != null) BoundaryMarker(tracker: tracker, child: const SizedBox.shrink()),
              if (div != null) div,
              SizedBox(height: spacing / 2),
            ],
          );
        } else {
          gapWidget = SizedBox(height: spacing);
        }
        blocks.add(_SlotBlock({prevTarget, target}, gapWidget));
      }

      // 2. Check if the slot child wants to override the card-level padding
      EdgeInsetsGeometry? overridePad;
      // --- FIX #1: Explicitly cast to FluxSlotWrapper to access the property ---
      if (child is FluxSlotWrapper) {
        overridePad = (child as FluxSlotWrapper).externalPaddingOverride;
      }

      // 3. Apply override, otherwise fall back to card padding
      final slotPad =
          overridePad ??
          EdgeInsets.only(
            left: padding.left,
            right: padding.right,
            top: i == 0 ? padding.top : 0.0,
            bottom: i == present.length - 1 ? padding.bottom : 0.0,
          );

      final wrapped = wrapSlot(
        context,
        target: target,
        child: child,
        bgsByTarget: bgsByTarget,
        ovsByTarget: ovsByTarget,
        contentPadding: slotPad,
      )!;

      blocks.add(_SlotBlock({target}, wrapped));
    }

    final groupedBlocks = groupAndWrap(context, blocks, multiBgs, multiOvs);

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
