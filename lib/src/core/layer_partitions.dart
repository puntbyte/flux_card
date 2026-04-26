import 'package:flutter/widgets.dart';

import '../components/flux_overlay.dart';
import '../components/flux_underlay.dart';
import 'enums.dart';

/// Segregates and sorts [FluxCard] layers into buckets for the layout engine.
class FluxLayerPartitions {
  const FluxLayerPartitions({
    required this.underlaysByTarget,
    required this.overlaysByTarget,
    required this.multiUnderlays,
    required this.multiOverlays,
    required this.globalUnderlays,
    required this.globalOverlays,
    required this.breakoutOverlays,
  });

  final Map<FluxTarget, List<Widget>> underlaysByTarget;
  final Map<FluxTarget, List<Widget>> overlaysByTarget;
  final List<Widget> multiUnderlays;
  final List<Widget> multiOverlays;
  final List<Widget> globalUnderlays;
  final List<Widget> globalOverlays;
  final List<FluxOverlay> breakoutOverlays;

  /// Partitions raw layer arrays based on their targeting rules and [zIndex].
  static FluxLayerPartitions partition(List<Widget>? allUnderlays, List<Widget>? allOverlays) {
    final underlays = allUnderlays ?? const <Widget>[];
    final overlays = allOverlays ?? const <Widget>[];

    final underlaysByTarget = <FluxTarget, List<Widget>>{};
    final overlaysByTarget = <FluxTarget, List<Widget>>{};
    final multiUnderlays = <Widget>[];
    final multiOverlays = <Widget>[];
    final globalUnderlays = <Widget>[];
    final globalOverlays = <Widget>[];
    final breakoutOverlays = <FluxOverlay>[];

    for (final underlay in underlays) {
      if (underlay is FluxUnderlay) {
        if (underlay.isGlobal) {
          globalUnderlays.add(underlay);
        } else if (underlay.targets.length == 1) {
          (underlaysByTarget[underlay.targets.first] ??= <Widget>[]).add(underlay);
        } else {
          multiUnderlays.add(underlay);
        }
      } else {
        globalUnderlays.add(underlay);
      }
    }

    for (final overlay in overlays) {
      if (overlay is FluxOverlay) {
        if (overlay.isBreakout) {
          breakoutOverlays.add(overlay);
        } else if (overlay.isGlobal) {
          globalOverlays.add(overlay);
        } else if (overlay.targets.length == 1) {
          (overlaysByTarget[overlay.targets.first] ??= <Widget>[]).add(overlay);
        } else {
          multiOverlays.add(overlay);
        }
      } else {
        globalOverlays.add(overlay);
      }
    }

    int zIndexOf(Widget widget) {
      if (widget is FluxOverlay) return widget.zIndex;
      if (widget is FluxUnderlay) return widget.zIndex;
      return 0;
    }

    // Sort all buckets based on their explicit or implicit zIndex
    globalOverlays.sort((a, b) => zIndexOf(a).compareTo(zIndexOf(b)));
    multiOverlays.sort((a, b) => zIndexOf(a).compareTo(zIndexOf(b)));
    breakoutOverlays.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    for (final list in overlaysByTarget.values) {
      list.sort((a, b) => zIndexOf(a).compareTo(zIndexOf(b)));
    }

    globalUnderlays.sort((a, b) => zIndexOf(a).compareTo(zIndexOf(b)));
    for (final list in underlaysByTarget.values) {
      list.sort((a, b) => zIndexOf(a).compareTo(zIndexOf(b)));
    }

    multiUnderlays.sort((a, b) => zIndexOf(b).compareTo(zIndexOf(a)));

    return FluxLayerPartitions(
      underlaysByTarget: underlaysByTarget,
      overlaysByTarget: overlaysByTarget,
      multiUnderlays: multiUnderlays,
      multiOverlays: multiOverlays,
      globalUnderlays: globalUnderlays,
      globalOverlays: globalOverlays,
      breakoutOverlays: breakoutOverlays,
    );
  }
}
