import 'package:flutter/material.dart';

import '../core/enums.dart';

/// A positioned overlay layer for a [FluxCard] slot.
///
/// Overlays are drawn on top of their target slot's content. Unlike
/// [FluxBackground], overlays are **interactive by default** — taps on the
/// overlay children (chips, buttons, badges) reach the widgets normally.
///
/// **Hit-test behaviour:**
/// Inside the card's Stack, each overlay is wrapped in `Positioned.fill` so
/// that [Align] has bounded dimensions and [alignment] works for all edges
/// including bottom. Empty space around the aligned content is transparent to
/// pointer events because [Align]'s render object only forwards hit-tests to
/// its single child. Set [interactive] to `false` to make the content area
/// itself non-interactive (purely decorative).
///
/// **Alignment:**
/// All four corners and edges work correctly — including [Alignment.bottomLeft],
/// [Alignment.bottomCenter], [Alignment.bottomRight] — because the overlay is
/// placed inside a bounded `Positioned.fill` region supplied by the layout engine.
class FluxOverlay extends StatelessWidget {
  const FluxOverlay({
    super.key,
    required this.children,
    this.targets = const {FluxTarget.card},
    this.alignment = Alignment.topRight,
    this.padding = const EdgeInsets.all(12.0),
    this.offset,
    this.zIndex = 0,
    this.interactive = true,
  });

  final List<Widget> children;

  /// Which card slot(s) this overlay is injected into.
  ///
  /// Use `{FluxTarget.card}` (the default) for a global overlay spanning the
  /// whole card. Use a single slot target such as `{FluxTarget.media}` to
  /// constrain the overlay to that area only.
  final Set<FluxTarget> targets;

  /// Where the overlay content is anchored within the bounded slot area.
  ///
  /// All standard alignments work, including [Alignment.bottomLeft] and
  /// [Alignment.bottomRight].
  final AlignmentGeometry alignment;

  /// Padding between the overlay content and the slot edges.
  final EdgeInsetsGeometry padding;

  /// Optional pixel nudge applied after alignment.
  final Offset? offset;

  /// Controls rendering order when multiple overlays target the same slot.
  final int zIndex;

  /// When `true` (default), overlay children receive pointer events.
  ///
  /// Set to `false` for purely decorative overlays such as watermarks.
  final bool interactive;

  bool get isGlobal =>
      targets.contains(FluxTarget.card) ||
      targets.containsAll(const {
        FluxTarget.media,
        FluxTarget.header,
        FluxTarget.body,
        FluxTarget.footer,
      });

  bool targetsSlot(FluxTarget slot) => !isGlobal && targets.contains(slot);

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    Widget content = Padding(
      padding: padding,
      child: Wrap(spacing: 8, runSpacing: 8, children: children),
    );

    // IgnorePointer wraps only the content Wrap, NOT the surrounding Align.
    // This means empty space around the aligned content remains transparent
    // to pointer events regardless of the interactive flag, which is the
    // correct behaviour for an overlay that shouldn't block the card body.
    if (!interactive) content = IgnorePointer(child: content);

    if (offset != null) {
      content = Transform.translate(offset: offset!, child: content);
    }

    // Return an Align so the content positions itself within the bounded
    // Positioned.fill box that SlotResolver and _buildLayers provide.
    // Align's render object only forwards hit-tests to its child, so all
    // empty space around the Wrap is automatically pass-through.
    return Align(alignment: alignment, child: content);
  }
}
