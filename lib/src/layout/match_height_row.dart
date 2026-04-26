import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum FluxRowSlot { media, content }

class FluxRowParentData extends BoxParentData {}

/// A high-performance Row replacement that forces its children to exactly
/// match the height of the tallest child in a single layout pass.
///
/// It correctly identifies explicitly sized `FluxMedia` widgets and grants them
/// their requested width, distributing the remaining space to the content.
class FluxMatchHeightRow extends SlottedMultiChildRenderObjectWidget<FluxRowSlot, RenderBox> {
  const FluxMatchHeightRow({
    super.key,
    required this.media,
    required this.content,
    required this.flexMedia,
    required this.flexContent,
    required this.mediaStart,
    this.fixedMediaWidth,
  });

  final Widget media;
  final Widget content;
  final int flexMedia;
  final int flexContent;
  final bool mediaStart;
  final double? fixedMediaWidth;

  @override
  Iterable<FluxRowSlot> get slots => FluxRowSlot.values;

  @override
  Widget? childForSlot(FluxRowSlot slot) {
    switch (slot) {
      case FluxRowSlot.media:
        return media;
      case FluxRowSlot.content:
        return content;
    }
  }

  @override
  SlottedContainerRenderObjectMixin<FluxRowSlot, RenderBox> createRenderObject(
      BuildContext context,
      ) {
    return RenderFluxMatchHeightRow(
      flexMedia: flexMedia,
      flexContent: flexContent,
      mediaStart: mediaStart,
      fixedMediaWidth: fixedMediaWidth,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderFluxMatchHeightRow renderObject) {
    renderObject
      ..flexMedia = flexMedia
      ..flexContent = flexContent
      ..mediaStart = mediaStart
      ..fixedMediaWidth = fixedMediaWidth;
  }
}

class RenderFluxMatchHeightRow extends RenderBox
    with SlottedContainerRenderObjectMixin<FluxRowSlot, RenderBox> {
  RenderFluxMatchHeightRow({
    required int flexMedia,
    required int flexContent,
    required bool mediaStart,
    double? fixedMediaWidth,
  }) : _flexMedia = flexMedia,
        _flexContent = flexContent,
        _mediaStart = mediaStart,
        _fixedMediaWidth = fixedMediaWidth;

  int _flexMedia;

  int get flexMedia => _flexMedia;

  set flexMedia(int value) {
    if (_flexMedia == value) return;
    _flexMedia = value;
    markNeedsLayout();
  }

  int _flexContent;

  int get flexContent => _flexContent;

  set flexContent(int value) {
    if (_flexContent == value) return;
    _flexContent = value;
    markNeedsLayout();
  }

  bool _mediaStart;

  bool get mediaStart => _mediaStart;

  set mediaStart(bool value) {
    if (_mediaStart == value) return;
    _mediaStart = value;
    markNeedsLayout();
  }

  double? _fixedMediaWidth;

  double? get fixedMediaWidth => _fixedMediaWidth;

  set fixedMediaWidth(double? value) {
    if (_fixedMediaWidth == value) return;
    _fixedMediaWidth = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! FluxRowParentData) {
      child.parentData = FluxRowParentData();
    }
  }

  double _getMediaMaxWidth(double totalAvailableWidth) {
    // If the media child has a strict, fixed width (e.g. FluxMedia(width: 120)),
    // respect it exactly instead of overriding it with flex ratios.
    if (_fixedMediaWidth != null && _fixedMediaWidth! > 0 && _fixedMediaWidth! < double.infinity) {
      return _fixedMediaWidth!;
    }

    final totalFlex = flexMedia + flexContent;
    return (totalAvailableWidth * flexMedia / totalFlex).floorToDouble();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final mediaChild = childForSlot(FluxRowSlot.media);
    final contentChild = childForSlot(FluxRowSlot.content);

    if (mediaChild == null && contentChild == null) {
      return constraints.smallest;
    }

    if (mediaChild == null || contentChild == null) {
      final child = mediaChild ?? contentChild!;
      return child.getDryLayout(constraints);
    }

    double totalAvailableWidth = constraints.maxWidth;
    if (totalAvailableWidth == double.infinity) {
      // For horizontal unbounded scroll views, allow the children to dictate the size.
      final intrinsicMedia = mediaChild.getMaxIntrinsicWidth(double.infinity);
      final intrinsicContent = contentChild.getMaxIntrinsicWidth(double.infinity);
      totalAvailableWidth = intrinsicMedia + intrinsicContent;
    }

    final mediaMaxWidth = _getMediaMaxWidth(totalAvailableWidth);
    final contentWidth = math.max(0.0, totalAvailableWidth - mediaMaxWidth);

    final mediaSize = mediaChild.getDryLayout(BoxConstraints.tightFor(width: mediaMaxWidth));
    final contentSize = contentChild.getDryLayout(BoxConstraints.tightFor(width: contentWidth));

    double maxHeight = math.max(mediaSize.height, contentSize.height);

    // Natively supports the Expanded wrapper in Column by forcing minimum constrained height.
    maxHeight = math.max(maxHeight, constraints.minHeight);

    return constraints.constrain(Size(totalAvailableWidth, maxHeight));
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final mediaChild = childForSlot(FluxRowSlot.media);
    final contentChild = childForSlot(FluxRowSlot.content);
    final mW = mediaChild?.getMinIntrinsicWidth(height) ?? 0.0;
    final cW = contentChild?.getMinIntrinsicWidth(height) ?? 0.0;
    return mW + cW;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final mediaChild = childForSlot(FluxRowSlot.media);
    final contentChild = childForSlot(FluxRowSlot.content);
    final mW = mediaChild?.getMaxIntrinsicWidth(height) ?? 0.0;
    final cW = contentChild?.getMaxIntrinsicWidth(height) ?? 0.0;
    return mW + cW;
  }

  @override
  double computeMinIntrinsicHeight(double width) =>
      computeDryLayout(BoxConstraints(maxWidth: width)).height;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      computeDryLayout(BoxConstraints(maxWidth: width)).height;

  @override
  void performLayout() {
    final mediaChild = childForSlot(FluxRowSlot.media);
    final contentChild = childForSlot(FluxRowSlot.content);

    if (mediaChild == null && contentChild == null) {
      size = constraints.smallest;
      return;
    }

    if (mediaChild == null || contentChild == null) {
      final child = mediaChild ?? contentChild!;
      child.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child.size);
      if (child.parentData is FluxRowParentData) {
        (child.parentData as FluxRowParentData).offset = Offset.zero;
      }
      return;
    }

    double totalAvailableWidth = constraints.maxWidth;
    if (totalAvailableWidth == double.infinity) {
      // In unbounded horizontal scenarios, we compute the maximum intrinsic sizes manually.
      final intrinsicMedia = mediaChild.getMaxIntrinsicWidth(double.infinity);
      final intrinsicContent = contentChild.getMaxIntrinsicWidth(double.infinity);
      totalAvailableWidth = intrinsicMedia + intrinsicContent;
    }

    final mediaMaxWidth = _getMediaMaxWidth(totalAvailableWidth);
    final contentWidth = math.max(0.0, totalAvailableWidth - mediaMaxWidth);

    // FIRST PASS: Calculate natural heights with loose height constraints
    mediaChild.layout(BoxConstraints.tightFor(width: mediaMaxWidth), parentUsesSize: true);
    contentChild.layout(BoxConstraints.tightFor(width: contentWidth), parentUsesSize: true);

    double maxHeight = math.max(mediaChild.size.height, contentChild.size.height);

    // If the parent forces a larger height (e.g. Expanded), respect it!
    maxHeight = math.max(maxHeight, constraints.minHeight);

    // SECOND PASS: ALWAYS force tight constraints on both children to ensure
    // framework layout contracts are strictly met!
    mediaChild.layout(
      BoxConstraints.tightFor(width: mediaMaxWidth, height: maxHeight),
      parentUsesSize: true,
    );
    contentChild.layout(
      BoxConstraints.tightFor(width: contentWidth, height: maxHeight),
      parentUsesSize: true,
    );

    size = constraints.constrain(Size(mediaMaxWidth + contentWidth, maxHeight));

    final mediaOffset = mediaStart ? Offset.zero : Offset(contentWidth, 0);
    final contentOffset = mediaStart ? Offset(mediaMaxWidth, 0) : Offset.zero;

    (mediaChild.parentData as FluxRowParentData).offset = mediaOffset;
    (contentChild.parentData as FluxRowParentData).offset = contentOffset;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final slot in FluxRowSlot.values) {
      final child = childForSlot(slot);
      if (child != null) {
        final childParentData = child.parentData as FluxRowParentData;
        context.paintChild(child, offset + childParentData.offset);
      }
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final slot in FluxRowSlot.values) {
      final child = childForSlot(slot);
      if (child != null) {
        final childParentData = child.parentData as FluxRowParentData;
        final isHit = result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset transformed) {
            return child.hitTest(result, position: transformed);
          },
        );
        if (isHit) return true;
      }
    }
    return false;
  }
}