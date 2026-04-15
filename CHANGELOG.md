# Changelog

All notable changes to `flux_card` are documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [0.1.0] — 2026-04-15

Initial public release.

### Added

#### Core widget

- `FluxCard` — the root widget. Accepts named content slots (`media`, `header`, `body`, `footer`), a layering system via `overlays` and `underlays`, interaction callbacks (`onTap`, `onLongPress`), constraint controls (`width`, `height`, `fullWidth`, `fullHeight`), a `semanticLabel` for accessibility, and a `loading` flag that replaces content with `FluxCardSkeleton`.
- Three layout modes via `FluxLayoutMode`: `column` (vertical stack), `row` (horizontal), and `responsive` (auto-switches between column and row based on `FluxCardThemeData.responsiveBreakpoint`). Responsive mode uses `LayoutBuilder` only when needed.
- `FluxMediaPosition` (`start`, `end`) — controls whether media renders at the top/left or bottom/right.
- `FluxMediaSpan` — controls how many content rows the media spans in row layout (`all`, `header`, `headerAndBody`, `body`).
- `clipBehavior` parameter on `FluxCard` — setting `Clip.none` allows `FluxOverlay` badges to render outside the card's clip boundary.
- `foregroundColor` parameter — propagates a default text and icon color to all slots via `DefaultTextStyle` and `IconTheme`.
- `decoration` parameter — `BoxDecoration` applied as a full-card background layer with correct ripple support via `Ink`.

#### Components

- `FluxMedia` — media slot container with `aspectRatio`, explicit `width`/`height`, `borderRadius`, `clipBehavior`, background `color`/`gradient` layers, and foreground scrim layers (`foregroundColor`, `foregroundGradient`). Includes a `FluxMedia.image` factory for `ImageProvider`-based images with `BoxFit`, `alignment`, and `ColorFilter`.
- `FluxSection` — structured content section with `leading`, `title`, `subtitle`, `description`, `trailing`, `child`, `actions`, `margin`, `padding`, `decoration`, alignment controls, and per-field text style overrides. Includes `FluxSection.header` (no actions or child) and `FluxSection.footer` (actions only) semantic constructors. Implements `FluxSlotWrapper` to support full-bleed layout via `margin: EdgeInsets.zero`.
- `FluxContent` — body-slot container. Includes `FluxContent.column` (auto-spaced children), `FluxContent.row`, and `FluxContent.wrap` constructors. Supports `minHeight`, `maxHeight`, `scrollable`, and `decoration`. Implements `FluxSlotWrapper`.
- `FluxOverlay` — interactive positioned overlay. Targets specific card slots via `targets: Set<FluxTarget>`. Supports `alignment`, `padding`, `offset`, `zIndex`, and `interactive` flag. Empty space around aligned content is always transparent to pointer events.
- `FluxUnderlay` — non-interactive decorative background layer. Targets specific card slots. Supports `margin` (negative values extrude beyond slot bounds), `offset`, `zIndex`, and full `BoxDecoration`.
- `FluxDivider` — inserts dividers between named slot boundaries (`afterMedia`, `afterHeader`, `afterBody`). Accepts any widget. Dividers are wrapped in `BoundaryMarker` nodes for notch position tracking.

#### Layering system

- Overlay and underlay routing: `FluxTarget.card` (global, spans full card), single-slot targets (`FluxTarget.media`, `FluxTarget.header`, `FluxTarget.body`, `FluxTarget.footer`), and multi-target combinations. Global layers are separated from per-slot layers for efficient stack construction.
- `zIndex` sorting applied independently to global overlays, global underlays, per-slot overlays, per-slot underlays, and multi-target layers.
- `SlotResolver` — resolves `FluxSlotWrapper.externalPaddingOverride` to allow per-slot padding overrides from within slot content, enabling full-bleed patterns without requiring card-level configuration.

#### Notch / ticket system

- `FluxNotch` — declares a semicircular notch aligned to a named slot boundary (`FluxSlotBoundary`) or a free fractional position (`FluxNotch.free`). Parameters: `notchRadius`, `edge` (`FluxNotchEdge.vertical` / `FluxNotchEdge.horizontal`), `notchSide` (`FluxNotchSide.both` / `.left` / `.right`), `borderRadius`, `side` (for border painting), `boundaryAlignment`, `boundaryOffset`, `fallbackPosition`.
- `FluxNotchShape` — a `ShapeBorder` implementation of the notch shape. Supports `ShapeBorder.lerp` for animation. Accepts a `notchPositionResolver` callback for dynamic post-layout positioning. Use directly in `FluxCardThemeData.shape` when you need the shape without the full `FluxNotch` integration.
- `BoundaryTracker` / `BoundaryMarker` / `RenderBoundaryMarker` — lightweight render-tree hooks for tracking slot boundary positions without `GlobalKey`. Used internally by `FluxNotch` to resolve the notch position after the first layout pass.
- `NotchPathBuilder` — static utility that produces the `Path` for a rounded rectangle with semicircular notches on any edge.

#### Loading / skeleton

- `FluxCardSkeleton` — mirrors the card's slot structure with animated shimmer placeholders. Respects `layout`, `mediaPosition`, `mediaSpan`, and which slots are present (`hasMedia`, `hasHeader`, `hasBody`, `hasFooter`).
- Built-in shimmer animation using `ShaderMask` with `LinearGradient` and a repeating `AnimationController`. Wrapped in `RepaintBoundary` to isolate repaints.
- `loadingWrapper` callback — allows bridging an external shimmer package (e.g. `skeletonizer`) instead of the built-in animation.

#### Theming

- `FluxCardThemeData` — a `ThemeExtension<FluxCardThemeData>` that controls `cardColor`, `elevation`, `shadowColor`, `surfaceTintColor`, `shape`, `borderRadius`, `borderSide`, `padding`, `spacing`, `clipBehavior`, `responsiveBreakpoint`, `defaultShadows`, and text style defaults for title, subtitle, and description.
- `FluxCardTheme` — an `InheritedWidget` that propagates `FluxCardThemeData` down the tree. Automatically wraps each `FluxCard` during build.
- `FluxCardThemeData.of(context)` — resolves the nearest theme, falling back to `Theme.of(context).extensions` and finally to package defaults.
- Four built-in presets: `FluxCardThemeData.standard`, `FluxCardThemeData.compact`, `FluxCardThemeData.elevated`, `FluxCardThemeData.outlined`.
- `copyWith()` on all presets.

#### Accessibility

- `semanticLabel` parameter on `FluxCard` — wraps the card in a `Semantics` node with `container: true`. Automatically sets `button: true` when `onTap` or `onLongPress` is present.

#### Developer tooling

- Widgetbook project (`widgetbook/`) with annotated use cases for every public component.
- Use case categories: Cards (column, row, inline, responsive, hero animation, ripple over media, surface decoration), Compositions (creator profile, event ticket, freelancer profile, pricing card, product card full-bleed, property listing), Content, Loading, Media, Overlays, Sections, Themes, Ticket Shape, Views (scrollables), Backgrounds.
- Example app (`example/`) demonstrating blog, product grid, and destination list patterns.

---

[0.1.0]: https://github.com/your-org/flux_card/releases/tag/v0.1.0