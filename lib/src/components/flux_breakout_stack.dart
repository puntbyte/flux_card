import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../layout/boundary_tracker.dart';
import 'flux_overlay.dart';

/// Wraps the main card and manages the rendering of unclipped breakout overlays.
///
/// Because breakout overlays need to know the rendered geometry of the targeted
/// internal card slots, this widget handles post-layout frame callbacks without
/// triggering a rebuild of the complex card content underneath.
class FluxBreakoutStack extends StatefulWidget {
  const FluxBreakoutStack({
    super.key,
    required this.cardTracker,
    required this.slotTrackers,
    required this.overlays,
    required this.child,
  });

  final BoundaryTracker cardTracker;
  final Map<FluxTarget, BoundaryTracker> slotTrackers;
  final List<FluxOverlay> overlays;
  final Widget child;

  @override
  State<FluxBreakoutStack> createState() => _FluxBreakoutStackState();
}

class _FluxBreakoutStackState extends State<FluxBreakoutStack> {
  bool _breakoutRebuildScheduled = false;

  void _scheduleBreakoutOverlayRebuild() {
    if (_breakoutRebuildScheduled) return;

    _breakoutRebuildScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _breakoutRebuildScheduled = false;
      if (mounted) setState(() {});
    });
  }

  Rect? _resolveTargetRect(FluxTarget target) {
    final cardBox = widget.cardTracker.renderBox;
    if (cardBox == null) return null;

    if (target == FluxTarget.card) {
      return Offset.zero & cardBox.size;
    }

    final tracker = widget.slotTrackers[target];
    final slotBox = tracker?.renderBox;
    if (slotBox == null) return null;

    final offset = slotBox.localToGlobal(Offset.zero, ancestor: cardBox);
    return offset & slotBox.size;
  }

  Rect? _resolveOverlayAnchorRect(FluxOverlay overlay) {
    final cardBox = widget.cardTracker.renderBox;
    if (cardBox == null) return null;

    if (overlay.isGlobal || overlay.targets.contains(FluxTarget.card)) {
      return Offset.zero & cardBox.size;
    }

    final rects = <Rect>[];

    for (final target in overlay.targets) {
      final rect = _resolveTargetRect(target);
      if (rect != null) rects.add(rect);
    }

    if (rects.isEmpty) return null;

    Rect union = rects.first;
    for (final rect in rects.skip(1)) {
      union = union.expandToInclude(rect);
    }

    return union;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.overlays.isEmpty) {
      return widget.child;
    }

    final entries = <Widget>[];
    var needsRetry = widget.cardTracker.renderBox == null;

    for (final overlay in widget.overlays) {
      final rect = _resolveOverlayAnchorRect(overlay);
      if (rect == null) {
        needsRetry = true;
        continue;
      }
      entries.add(Positioned.fromRect(rect: rect, child: overlay));
    }

    if (needsRetry) {
      _scheduleBreakoutOverlayRebuild();
    }

    return Stack(
      clipBehavior: Clip.none,
      children:[
        widget.child,
        ...entries,
      ],
    );
  }
}