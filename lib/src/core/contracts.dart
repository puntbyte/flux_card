import 'package:flutter/material.dart';

/// Layout mode for a Flux card.
enum FluxLayoutMode {
  /// Media above the content.
  column,

  /// Media beside the content.
  row,

  /// Media/background behind the content.
  stack,

  /// Chooses column or row depending on width.
  responsive,
}

/// Configuration for card layout routing.
@immutable
class FluxCardLayout {
  final FluxLayoutMode mode;

  const FluxCardLayout({required this.mode});

  const FluxCardLayout.column() : mode = FluxLayoutMode.column;
  const FluxCardLayout.row() : mode = FluxLayoutMode.row;
  const FluxCardLayout.stack() : mode = FluxLayoutMode.stack;
  const FluxCardLayout.responsive() : mode = FluxLayoutMode.responsive;
}
