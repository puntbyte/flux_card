## [0.1.0] - Initial release

First public release of `flux_card`.

### Added

#### Core card system

- Added `FluxCard` as the root card widget with named slots for `media`, `header`, `body`, and `footer`
- Added support for layout modes: `column`, `row`, `responsive`, and `inline`
- Added `mediaPosition` and `mediaSpan` controls for flexible slot arrangements
- Added support for `foregroundColor`, `decoration`, semantic labels, interactions, and explicit/full size constraints

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

- Added Widgetbook use cases for cards, overlays, underlays, loading, themes, notches, and advanced compositions
- Added example app patterns such as blog, product, and destination cards
- Added package tests covering components, layout behavior, shapes, and card interactions

---

[0.1.0]: https://github.com/your-org/flux_card/releases/tag/v0.1.0