## [0.2.0]

### Added

- **Simple Card Factory**: Added `FluxCard.simple()` boilerplate-reducing factory constructor for 
  quickly generating standard text-and-action cards without manually writing out `FluxSection` and 
  `FluxContent` primitives.
- **Expandable Media**: Added `isMediaExpanded` property to `FluxCard`. When `true`, the media slot 
  will dynamically stretch to fill remaining vertical space. Includes automatic safety-checks that 
  gracefully disable expansion when placed inside unbounded-height scrolling parents to prevent 
  layout crashes.
- **Semantic Merging**: Added `mergeSemantics` property to `FluxCard` and `FluxCardThemeData`. When 
  enabled, the card is wrapped in a `MergeSemantics` widget, allowing screen readers 
  (VoiceOver/TalkBack) to read the entire card as a single cohesive element.
- **New Widgetbook Use Cases**: Added interactive demos for `Expandable Media`, `Simple Card`, and 
  `Row — Fixed Width (Flex Content)`.

### Changed / Improved

- **Exact Pixel Widths in Row Layout**: Improved `FluxMatchHeightRow` layout algorithm. The row 
  layout now automatically detects if a `FluxMedia` slot has a strict pixel width 
  (e.g., `width: 120`) and prioritizes that exact size, dynamically distributing all remaining 
  horizontal space to the content block instead of strictly enforcing flex ratios.
- **Breakout Overlay Performance**: Extracted breakout overlay rendering into a dedicated 
  `FluxBreakoutStack` stateful widget. This massive performance win ensures that post-frame 
  geometry recalculations for extruding overlays no longer trigger a rebuild of the entire card and 
  its contents.
- **Internal Architecture**: Split `flux_card.dart` into smaller, single-responsibility files and 
  abstracted layer sorting into a dedicated `FluxLayerPartitions` utility for better 
  maintainability.

### Documentation

- **Gallery Layout**: Replaced the stacked image preview in the `README.md` with a visually 
  balanced, responsive grid layout grouped by aspect ratio to better highlight layout flexibility.

### Fixed

- **Intrinsic Layout Crash**: Replaced the internal `LayoutBuilder` inside `FluxMedia` with a 
  custom `_FallbackHeightBox` render object. This prevents framework-level `RenderFlex` assertion 
  crashes that occurred when rows queried the media slot for its intrinsic dimensions.

## [0.1.0]

First public release of `flux_card`.

### Added

#### Core card system

- Added `FluxCard` as the root card widget with named slots for `media`, `header`, `body`, and
  `footer`
- Added support for layout modes: `column`, `row`, `responsive`, and `inline`
- Added `mediaPosition` and `mediaSpan` controls for flexible slot arrangements
- Added support for `foregroundColor`, `decoration`, semantic labels, interactions, and
  explicit/full size constraints

#### Card building primitives

- Added `FluxMedia` for media-slot sizing, clipping, gradients, scrims, and image-based composition
- Added `FluxSection` for structured sections such as headers and footers
- Added `FluxContent` for flexible body layouts including column, row, and wrap patterns
- Added `FluxDivider` for inserting widgets between named slot boundaries

#### Layering system

- Added `FluxOverlay` with slot targeting and alignment support
- Added `FluxUnderlay` for decorative background layers behind specific slots or the full card
- Added support for contained and breakout overlay patterns
- Added layer ordering with `zIndex`

#### Notch system

- Added `FluxNotch` support for notched card layouts
- Added notch positioning by boundary and free-position modes
- Added multiple notch styles including ticket, v-shape, and slant variants
- Added `FluxNotchShape` for shape-based notch rendering and custom theme usage

#### Loading and theming

- Added `FluxCardSkeleton` for package-native loading states that mirror card structure
- Added `loadingWrapper` support for integrating external loading libraries
- Added `FluxCardThemeData` as a `ThemeExtension`
- Added built-in theme presets: `standard`, `compact`, `elevated`, and `outlined`
- Added `FluxCardTheme` and theme resolution helpers

#### Layout and rendering internals

- Added layout delegates and slot resolution utilities for composing slot-based card layouts
- Added boundary tracking infrastructure used by notch and overlay positioning logic
- Added breakout overlay rendering that preserves clipped rounded card surfaces
- Added responsive and unbounded-layout safeguards for more stable layout behavior

#### Tooling and examples

- Added Widgetbook use cases for cards, overlays, underlays, loading, themes, notches, and advanced
  compositions
- Added example app patterns such as blog, product, and destination cards
- Added package tests covering components, layout behavior, shapes, and card interactions

---

[0.1.0]: https://github.com/your-org/flux_card/releases/tag/v0.1.0