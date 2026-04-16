import 'package:flutter/material.dart';

import '../core/enums.dart';

/// Defines a notch cut into the outline of a [FluxCard].
///
/// [FluxNotch] only describes geometry and positioning.
/// The card outline is still owned by [FluxCardThemeData.borderSide]
/// or a custom [ShapeBorder].
class FluxNotch {
  const FluxNotch({
    FluxNotchKind kind = FluxNotchKind.ticket,
    required FluxSlotBoundary boundary,
    double fallbackPosition = 0.5,
    double boundaryOffset = 0.0,
    AlignmentGeometry boundaryAlignment = Alignment.center,
    double notchDepth = 12.0,
    double? notchWidth,
    FluxNotchEdge edge = FluxNotchEdge.vertical,
    FluxNotchSide notchSide = FluxNotchSide.both,
    BorderRadius? borderRadius,
  }) : this._(
         kind: kind,
         boundary: boundary,
         fallbackPosition: fallbackPosition,
         boundaryOffset: boundaryOffset,
         boundaryAlignment: boundaryAlignment,
         notchDepth: notchDepth,
         notchWidth: notchWidth,
         edge: edge,
         notchSide: notchSide,
         borderRadius: borderRadius,
       );

  const FluxNotch.free({
    FluxNotchKind kind = FluxNotchKind.ticket,
    double position = 0.5,
    double notchDepth = 12.0,
    double? notchWidth,
    FluxNotchEdge edge = FluxNotchEdge.vertical,
    FluxNotchSide notchSide = FluxNotchSide.both,
    BorderRadius? borderRadius,
  }) : this._(
         kind: kind,
         boundary: null,
         fallbackPosition: position,
         boundaryOffset: 0.0,
         boundaryAlignment: Alignment.center,
         notchDepth: notchDepth,
         notchWidth: notchWidth,
         edge: edge,
         notchSide: notchSide,
         borderRadius: borderRadius,
       );

  const FluxNotch.ticket({
    required FluxSlotBoundary boundary,
    double fallbackPosition = 0.5,
    double boundaryOffset = 0.0,
    AlignmentGeometry boundaryAlignment = Alignment.center,
    double notchDepth = 12.0,
    FluxNotchEdge edge = FluxNotchEdge.vertical,
    FluxNotchSide notchSide = FluxNotchSide.both,
    BorderRadius? borderRadius,
  }) : this(
         kind: FluxNotchKind.ticket,
         boundary: boundary,
         fallbackPosition: fallbackPosition,
         boundaryOffset: boundaryOffset,
         boundaryAlignment: boundaryAlignment,
         notchDepth: notchDepth,
         edge: edge,
         notchSide: notchSide,
         borderRadius: borderRadius,
       );

  const FluxNotch.ticketFree({
    double position = 0.5,
    double notchDepth = 12.0,
    FluxNotchEdge edge = FluxNotchEdge.vertical,
    FluxNotchSide notchSide = FluxNotchSide.both,
    BorderRadius? borderRadius,
  }) : this.free(
         kind: FluxNotchKind.ticket,
         position: position,
         notchDepth: notchDepth,
         edge: edge,
         notchSide: notchSide,
         borderRadius: borderRadius,
       );

  const FluxNotch.vShape({
    required FluxSlotBoundary boundary,
    double fallbackPosition = 0.5,
    double boundaryOffset = 0.0,
    AlignmentGeometry boundaryAlignment = Alignment.center,
    double notchDepth = 12.0,
    double? notchWidth,
    FluxNotchEdge edge = FluxNotchEdge.vertical,
    FluxNotchSide notchSide = FluxNotchSide.both,
    BorderRadius? borderRadius,
  }) : this(
         kind: FluxNotchKind.vShape,
         boundary: boundary,
         fallbackPosition: fallbackPosition,
         boundaryOffset: boundaryOffset,
         boundaryAlignment: boundaryAlignment,
         notchDepth: notchDepth,
         notchWidth: notchWidth,
         edge: edge,
         notchSide: notchSide,
         borderRadius: borderRadius,
       );

  const FluxNotch.vShapeFree({
    double position = 0.5,
    double notchDepth = 12.0,
    double? notchWidth,
    FluxNotchEdge edge = FluxNotchEdge.vertical,
    FluxNotchSide notchSide = FluxNotchSide.both,
    BorderRadius? borderRadius,
  }) : this.free(
         kind: FluxNotchKind.vShape,
         position: position,
         notchDepth: notchDepth,
         notchWidth: notchWidth,
         edge: edge,
         notchSide: notchSide,
         borderRadius: borderRadius,
       );

  const FluxNotch.slant({
    required FluxSlotBoundary boundary,
    double fallbackPosition = 0.5,
    double boundaryOffset = 0.0,
    AlignmentGeometry boundaryAlignment = Alignment.center,
    double notchDepth = 12.0,
    double? notchWidth,
    FluxNotchEdge edge = FluxNotchEdge.vertical,
    FluxNotchSide notchSide = FluxNotchSide.both,
    BorderRadius? borderRadius,
  }) : this(
         kind: FluxNotchKind.slant,
         boundary: boundary,
         fallbackPosition: fallbackPosition,
         boundaryOffset: boundaryOffset,
         boundaryAlignment: boundaryAlignment,
         notchDepth: notchDepth,
         notchWidth: notchWidth,
         edge: edge,
         notchSide: notchSide,
         borderRadius: borderRadius,
       );

  const FluxNotch.slantFree({
    double position = 0.5,
    double notchDepth = 12.0,
    double? notchWidth,
    FluxNotchEdge edge = FluxNotchEdge.vertical,
    FluxNotchSide notchSide = FluxNotchSide.both,
    BorderRadius? borderRadius,
  }) : this.free(
         kind: FluxNotchKind.slant,
         position: position,
         notchDepth: notchDepth,
         notchWidth: notchWidth,
         edge: edge,
         notchSide: notchSide,
         borderRadius: borderRadius,
       );

  const FluxNotch._({
    required this.kind,
    this.boundary,
    required this.fallbackPosition,
    required this.boundaryOffset,
    required this.boundaryAlignment,
    required this.notchDepth,
    required this.notchWidth,
    required this.edge,
    required this.notchSide,
    this.borderRadius,
  });

  final FluxNotchKind kind;
  final FluxSlotBoundary? boundary;
  final double fallbackPosition;

  /// Alignment inside the measured boundary marker rect.
  final AlignmentGeometry boundaryAlignment;

  final double boundaryOffset;

  /// How far the notch cuts inward from the card edge.
  final double notchDepth;

  /// Width of non-circular notch kinds.
  ///
  /// For [FluxNotchKind.ticket], this is ignored and the circle diameter
  /// is derived from [notchDepth].
  final double? notchWidth;

  final FluxNotchEdge edge;
  final FluxNotchSide notchSide;
  final BorderRadius? borderRadius;

  bool get isTargeted => boundary != null;

  double get effectiveNotchWidth {
    if (kind == FluxNotchKind.ticket) {
      return notchDepth * 2;
    }

    if (notchWidth != null) {
      return notchWidth!;
    }

    return notchDepth * 2.25;
  }
}
