import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A lightweight reference holder to track rendering boxes without the
/// overhead of [GlobalKey], making the layout highly scalable in lists.
class BoundaryTracker {
  RenderBox? renderBox;
}

/// Injects a [BoundaryTracker] into the render tree to expose its layout geometry.
class BoundaryMarker extends SingleChildRenderObjectWidget {
  final BoundaryTracker tracker;

  const BoundaryMarker({
    super.key,
    required this.tracker,
    super.child,
  });

  @override
  RenderBoundaryMarker createRenderObject(BuildContext context) {
    return RenderBoundaryMarker(tracker);
  }

  @override
  void updateRenderObject(BuildContext context, RenderBoundaryMarker renderObject) {
    renderObject.tracker = tracker;
  }
}

class RenderBoundaryMarker extends RenderProxyBox {
  RenderBoundaryMarker(this._tracker) {
    _tracker.renderBox = this;
  }

  BoundaryTracker _tracker;

  set tracker(BoundaryTracker value) {
    if (_tracker == value) return;
    _tracker.renderBox = null;
    _tracker = value;
    _tracker.renderBox = this;
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _tracker.renderBox = this;
  }

  @override
  void detach() {
    _tracker.renderBox = null;
    super.detach();
  }
}