/// Layout mode for a [FluxCard].
enum FluxLayoutMode {
  /// Media stacked above (or below) the content column.
  column,

  /// Media placed inside the content column, between header and body/footer.
  inColumn,

  /// Media placed beside the content in a row.
  row,

  /// Automatically switches between [column] and [row] based on
  /// [FluxCardThemeData.responsiveBreakpoint].
  responsive,
}

/// Where the media sits relative to the card's content flow.
enum FluxMediaPosition {
  /// Media comes first (top in column, left in row, after header in inColumn).
  start,

  /// Media comes last (bottom in column, right in row, before footer in inColumn).
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

/// Which edges of a [FluxTicketShape] receive semicircular notches.
enum FluxNotchEdge {
  /// Notches are cut into the left and/or right edges (vertical ticket).
  vertical,

  /// Notches are cut into the top and/or bottom edges (horizontal ticket).
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
