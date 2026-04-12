/// Layout mode for a [FluxCard].
enum FluxLayoutMode {
  /// Media stacked above (or below) the content column.
  column,

  /// Media placed inline inside the content column — between header and body
  /// when [FluxMediaPosition.start], or between body and footer when
  /// [FluxMediaPosition.end].
  inline,

  /// Media placed beside the content in a row.
  row,

  /// Automatically switches between [column] and [row] based on
  /// [FluxCardThemeData.responsiveBreakpoint].
  responsive,
}

/// Where the media sits relative to the card's content flow.
enum FluxMediaPosition {
  /// Media comes first (top in column, left in row, after header in inline).
  start,

  /// Media comes last (bottom in column, right in row, before footer in inline).
  end,
}

/// Identifies a named slot inside a [FluxCard].
///
/// Used by [FluxBackground] and [FluxOverlay] to declare which part(s) of the
/// card they apply to.
enum FluxTarget {
  /// The media area.
  media,

  /// The header slot.
  header,

  /// The body slot.
  body,

  /// The footer slot.
  footer,

  /// The entire card surface (shorthand for all slots).
  ///
  /// A background or overlay with this target is rendered as a global layer
  /// covering the whole card, rather than being injected into a single slot.
  card,
}

/// Which edges of the card receive semicircular notches.
enum FluxNotchEdge {
  /// Notches are cut into the left and/or right edges.
  vertical,

  /// Notches are cut into the top and/or bottom edges.
  horizontal,
}

/// Which side(s) of the chosen [FluxNotchEdge] receive notches.
enum FluxNotchSide {
  /// Only the start edge (left for [FluxNotchEdge.vertical], top for horizontal).
  start,

  /// Only the end edge (right for [FluxNotchEdge.vertical], bottom for horizontal).
  end,

  /// Both edges.
  both,
}

/// Named boundary positions between [FluxCard] slots.
///
/// Used by [FluxNotch] and [FluxDivider] to target the exact rendered position
/// between two adjacent slots, regardless of padding values.
enum FluxSlotBoundary {
  /// Between the media slot and the content group (header / body / footer).
  afterMedia,

  /// Between the header slot and the body slot.
  afterHeader,

  /// Between the body slot and the footer slot.
  afterBody,
}
