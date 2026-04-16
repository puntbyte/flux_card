# Flux Card

A constraint-aware, domain-agnostic, composition-first card layout engine for Flutter.

`flux_card` provides a single `FluxCard` widget with named slots (media, header, body, footer), a
declarative layering system for overlays and backgrounds, responsive layout switching, ticket-shaped
notches, skeleton loading states, and a `ThemeExtension`-based theming system — all with zero
external dependencies.

---

## Table of contents

- [Installation](#installation)
- [Quick start](#quick-start)
- [Core concepts](#core-concepts)
- [Widget reference](#widget-reference)
    - [FluxCard](#fluxcard)
    - [FluxMedia](#fluxmedia)
    - [FluxSection](#fluxsection)
    - [FluxContent](#fluxcontent)
    - [FluxOverlay](#fluxoverlay)
    - [FluxUnderlay](#fluxunderlay)
    - [FluxDivider](#fluxdivider)
    - [FluxNotch / FluxNotchShape](#fluxnotch--fluxnotchshape)
    - [FluxCardSkeleton](#fluxcardskeleton)
    - [FluxCardThemeData](#fluxcardthemedata)
- [Layout modes](#layout-modes)
- [Layering system](#layering-system)
- [Theming](#theming)
- [Accessibility](#accessibility)
- [Composition examples](#composition-examples)
- [AI agent usage notes](#ai-agent-usage-notes)

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flux_card: ^0.1.0
```

Then import:

```dart
import 'package:flux_card/flux_card.dart';
```

No additional configuration is required. The package has no external dependencies beyond the Flutter
SDK.

---

## Quick start

```dart
FluxCard(
  media: FluxMedia(
    aspectRatio: 16 / 9,
    child: Ink.image(image: NetworkImage('https://example.com/image.jpg'), fit: BoxFit.cover),
  ),
  header: FluxSection.header(
    title: const Text('Card title'),
    subtitle: const Text('Supporting text'),
  ),
  body: const Text('Body content goes here.'),
  footer: FluxSection.footer(
    actions: [
      ElevatedButton(onPressed: () {}, child: const Text('Action')),
    ],
  ),
  theme: FluxCardThemeData.elevated,
  onTap: () {},
)
```

---

## Core concepts

`flux_card` is built around three ideas:

**Slots.** `FluxCard` has four named content slots: `media`, `header`, `body`, and `footer`. Each
slot accepts any widget. Slots that are `null` are omitted with no gap.

**Layers.** On top of the slot content, you can inject `FluxOverlay` widgets (interactive,
positioned over a slot) and `FluxUnderlay` widgets (decorative, rendered behind a slot). Both accept
a `targets` set that controls which slot(s) they appear in.

**Theme.** `FluxCardThemeData` is a Flutter `ThemeExtension`. You can set it app-wide via
`Theme.of(context).extensions`, pass it directly via the `theme` parameter on any `FluxCard`, or use
one of the four built-in presets.

---

## Widget reference

### FluxCard

The root widget. Manages layout, theming, constraints, loading state, notch shape, and interaction.

```dart
FluxCard({
  FluxLayoutMode layout = FluxLayoutMode.column,
  FluxMediaPosition mediaPosition = FluxMediaPosition.start,
  FluxMediaSpan mediaSpan = FluxMediaSpan.all,
  Widget? media,
  Widget? header,
  Widget? body,
  Widget? footer,
  List<Widget>? overlays,
  List<Widget>? underlays,
  Color? foregroundColor,
  BoxDecoration? decoration,
  FluxNotch? notch,
  FluxDivider? divider,
  double? width,
  double? height,
  bool fullWidth = false,
  bool fullHeight = false,
  FluxCardThemeData? theme,
  Clip? clipBehavior,
  String? semanticLabel,
  VoidCallback? onTap,
  VoidCallback? onLongPress,
  bool loading = false,
  Widget Function(BuildContext, Widget)? loadingWrapper,
})
```

| Parameter         | Type                                     | Description                                                                                                                                        |
|-------------------|------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|
| `layout`          | `FluxLayoutMode`                         | `column`, `row`, or `responsive`. In `responsive` mode the card switches between column and row based on `FluxCardThemeData.responsiveBreakpoint`. |
| `mediaPosition`   | `FluxMediaPosition`                      | `start` or `end`. In column layout: top or bottom. In row layout: left or right.                                                                   |
| `mediaSpan`       | `FluxMediaSpan`                          | Controls whether media spans the full card height in row layout (`all`, `header`, `headerAndBody`, etc.).                                          |
| `media`           | `Widget?`                                | Typically a `FluxMedia` widget. Any widget is accepted.                                                                                            |
| `header`          | `Widget?`                                | Typically a `FluxSection.header`. Any widget is accepted.                                                                                          |
| `body`            | `Widget?`                                | Typically a `FluxContent` or plain widget. Any widget is accepted.                                                                                 |
| `footer`          | `Widget?`                                | Typically a `FluxSection.footer`. Any widget is accepted.                                                                                          |
| `overlays`        | `List<Widget>?`                          | List of `FluxOverlay` widgets rendered above slot content.                                                                                         |
| `underlays`       | `List<Widget>?`                          | List of `FluxUnderlay` widgets rendered behind slot content.                                                                                       |
| `foregroundColor` | `Color?`                                 | Applies a default text and icon color across all slots via `DefaultTextStyle` and `IconTheme`.                                                     |
| `decoration`      | `BoxDecoration?`                         | Background decoration applied behind all content (supports gradients, images, etc.).                                                               |
| `notch`           | `FluxNotch?`                             | Applies a ticket-style semicircular notch to the card shape.                                                                                       |
| `divider`         | `FluxDivider?`                           | Inserts dividers between slots.                                                                                                                    |
| `fullWidth`       | `bool`                                   | Expands the card to the full available width via `LayoutBuilder`.                                                                                  |
| `fullHeight`      | `bool`                                   | Expands the card to the full available height.                                                                                                     |
| `theme`           | `FluxCardThemeData?`                     | Per-card theme override. Falls back to `FluxCardThemeData.of(context)`.                                                                            |
| `clipBehavior`    | `Clip?`                                  | Overrides the theme's clip behavior. Set `Clip.none` to allow overlays to break outside card bounds.                                               |
| `semanticLabel`   | `String?`                                | Wraps the card in a `Semantics` node. Automatically sets `button: true` when `onTap` is present.                                                   |
| `loading`         | `bool`                                   | When `true`, replaces the card content with `FluxCardSkeleton`.                                                                                    |
| `loadingWrapper`  | `Widget Function(BuildContext, Widget)?` | Custom wrapper for the skeleton — use this to integrate an external shimmer package.                                                               |

---

### FluxMedia

A slot wrapper for media content (images, video players, maps, etc.) with aspect ratio control,
scrims, and clip support.

```dart
// Widget child
FluxMedia({
  Widget? child,
  double? aspectRatio,
  double? width,
  double? height,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
  BorderRadiusGeometry? borderRadius,
  Clip clipBehavior = Clip.antiAlias,
  AlignmentGeometry alignment = Alignment.center,
  Color? color,
  Gradient? gradient,
  Color? foregroundColor,
  Gradient? foregroundGradient,
})

// ImageProvider shorthand
FluxMedia.image({
  required ImageProvider image,
  BoxFit? fit,
  AlignmentGeometry imageAlignment,
  ColorFilter? colorFilter,
  // ... same sizing and scrim parameters
})
```

| Parameter            | Description                                                                                           |
|----------------------|-------------------------------------------------------------------------------------------------------|
| `aspectRatio`        | Enforces a width-to-height ratio. Takes priority over `height`.                                       |
| `width` / `height`   | Explicit pixel dimensions. When both are set, the media is aligned within its slot using `alignment`. |
| `borderRadius`       | Clips the media content to this radius.                                                               |
| `gradient`           | Background gradient painted behind the media child.                                                   |
| `foregroundGradient` | Foreground gradient painted over the media child — useful for scrim effects.                          |

---

### FluxSection

A structured content section for headers, footers, or any slot needing a leading / title /
subtitle / trailing / actions layout.

Three constructors are provided:

```dart
// Generic — all fields available
FluxSection({
  Widget? leading,
  Widget? title,
  Widget? subtitle,
  Widget? description,
  List<Widget>? trailing,
  Widget? child,
  List<Widget>? actions,
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
  BoxDecoration? decoration,
  double spacing = 12,
  double runSpacing = 8,
  CrossAxisAlignment headerCrossAxisAlignment = CrossAxisAlignment.start,
  CrossAxisAlignment textCrossAxisAlignment = CrossAxisAlignment.start,
  MainAxisAlignment textMainAxisAlignment = MainAxisAlignment.start,
  MainAxisAlignment actionsAlignment = MainAxisAlignment.start,
  TextStyle? titleStyle,
  TextStyle? subtitleStyle,
  TextStyle? descriptionStyle,
})

// Semantic header — no actions or child (cleaner autocomplete)
FluxSection.header({ leading, title, subtitle, description, trailing, margin, padding, decoration, spacing, ... })

// Semantic footer — no leading, title, subtitle, description, or trailing
FluxSection.footer({ actions, actionsAlignment, margin, padding, decoration, spacing, ... })
```

**Full bleed override.** Pass `margin: EdgeInsets.zero` to a `FluxSection` to break out of the card's global padding, then use its own `padding` to re-apply spacing internally. This is the correct way to create visually distinct header/footer zones that touch the card edges.

```dart
FluxCard(
  theme: FluxCardThemeData.elevated.copyWith(padding: const EdgeInsets.all(20)),
  header: FluxSection.header(
    margin: EdgeInsets.zero,        // overrides card padding
    padding: const EdgeInsets.all(20), // re-applies spacing internally
    decoration: BoxDecoration(color: Colors.blue.shade50),
    title: const Text('Full bleed header'),
  ),
)
```

---

### FluxContent

A body-slot container for free-form content with optional spacing, constraints, decoration, and
scroll support.

```dart
// Generic
FluxContent({ Widget? child, EdgeInsetsGeometry? margin, EdgeInsetsGeometry padding, BoxDecoration? decoration, double? minHeight, double? maxHeight, bool scrollable = false })

// Auto-spacing column
FluxContent.column({ List<Widget> children, double spacing = 8, ... })

// Auto-spacing row
FluxContent.row({ List<Widget> children, double spacing = 8, ... })

// Wrap layout for chips and tags
FluxContent.wrap({ List<Widget> children, double spacing = 8, double runSpacing = 8, ... })
```

Like `FluxSection`, `FluxContent` implements `FluxSlotWrapper` and supports `margin` to override the
card's global padding.

---

### FluxOverlay

A positioned, interactive layer injected above one or more card slots.

```dart
FluxOverlay({
  required List<Widget> children,
  Set<FluxTarget> targets = const {FluxTarget.card},
  AlignmentGeometry alignment = Alignment.topRight,
  EdgeInsetsGeometry padding = const EdgeInsets.all(12.0),
  Offset? offset,
  int zIndex = 0,
  bool interactive = true,
})
```

| Parameter     | Description                                                                                                                                 |
|---------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| `targets`     | Which slot(s) to inject into. `{FluxTarget.card}` spans the whole card. `{FluxTarget.media}` constrains the overlay to the media slot only. |
| `alignment`   | Where inside the bounded slot area the overlay is anchored. All four corners and edges work correctly.                                      |
| `offset`      | Optional pixel nudge applied after alignment. Use with `clipBehavior: Clip.none` on the card to push badges outside bounds.                 |
| `zIndex`      | Rendering order when multiple overlays target the same slot. Higher values render on top.                                                   |
| `interactive` | Set to `false` for purely decorative overlays (e.g. watermarks). Empty space around the content is always transparent to pointer events.    |

**Target values:** `FluxTarget.card`, `FluxTarget.media`, `FluxTarget.header`, `FluxTarget.body`, `FluxTarget.footer`.

---

### FluxUnderlay

A declarative, non-interactive decoration layer injected behind one or more card slots.

```dart
FluxUnderlay({
  required BoxDecoration decoration,
  Set<FluxTarget> targets = const {FluxTarget.card},
  EdgeInsetsGeometry margin = EdgeInsets.zero,
  Offset? offset,
  int zIndex = 0,
})
```

Use negative `margin` values to extrude the underlay outside its target bounds — this is the correct
way to create overlapping decorative regions across adjacent slots.

---

### FluxDivider

Inserts dividers between named slot boundaries.

```dart
FluxDivider({
  Widget? afterMedia,
  Widget? afterHeader,
  Widget? afterBody,
})
```

Pass any widget as a divider — `Divider`, `FluxDashedDivider`, or a custom widget. Dividers are
wrapped in `BoundaryMarker` nodes so `FluxNotch` can align notch positions with them.

---

### FluxNotch / FluxNotchShape

Applies semicircular notches to the card shape, producing a ticket or coupon silhouette.

```dart
// Slot-boundary targeted (aligns notch with a FluxDivider)
FluxNotch({
  required FluxSlotBoundary boundary,
  double fallbackPosition = 0.5,
  double notchRadius = 12.0,
  FluxNotchEdge edge = FluxNotchEdge.vertical,
  FluxNotchSide notchSide = FluxNotchSide.both,
  BorderRadius? borderRadius,
  BorderSide side = BorderSide.none,
})

// Free position (0.0–1.0 fraction of the edge)
FluxNotch.free({
  double position = 0.5,
  double notchRadius = 12.0,
  FluxNotchEdge edge = FluxNotchEdge.vertical,
  FluxNotchSide notchSide = FluxNotchSide.both,
  BorderRadius? borderRadius,
  BorderSide side = BorderSide.none,
})
```

`FluxNotchShape` is the raw `ShapeBorder` form — use it when you need to assign the shape to
`FluxCardThemeData.shape` directly or animate between shapes via `ShapeBorder.lerp`.

**Boundary values:** `FluxSlotBoundary.afterMedia`, `FluxSlotBoundary.afterHeader`,
`FluxSlotBoundary.afterBody`.

**Edge values:** `FluxNotchEdge.vertical` (left and right edges), `FluxNotchEdge.horizontal` (top
and bottom edges).

**Side values:** `FluxNotchSide.both`, `FluxNotchSide.left`, `FluxNotchSide.right` (or top/bottom
for horizontal edges).

---

### FluxCardSkeleton

A shimmer loading placeholder that mirrors the card's slot structure.

```dart
FluxCardSkeleton({
  required FluxLayoutMode layout,
  required FluxMediaPosition mediaPosition,
  FluxMediaSpan mediaSpan = FluxMediaSpan.all,
  required FluxCardThemeData theme,
  bool hasMedia = true,
  bool hasHeader = true,
  bool hasBody = true,
  bool hasFooter = false,
  Widget Function(BuildContext, Widget)? loadingWrapper,
})
```

Usually accessed via the `loading` parameter on `FluxCard` rather than directly. Use
`loadingWrapper` to bridge an external shimmer package:

```dart
FluxCard(
  loading: isLoading,
  loadingWrapper: (context, skeleton) => Skeletonizer(enabled: true, child: skeleton),
  // ... slots
)
```

---

### FluxCardThemeData

A `ThemeExtension<FluxCardThemeData>` that controls all visual defaults for `FluxCard`.

```dart
FluxCardThemeData({
  Color? cardColor,
  double elevation = 0,
  Color? shadowColor,
  Color? surfaceTintColor,
  ShapeBorder? shape,
  BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(12)),
  BorderSide borderSide = BorderSide.none,
  EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  double spacing = 12,
  Clip clipBehavior = Clip.antiAlias,
  double responsiveBreakpoint = 600,
  List<BoxShadow>? defaultShadows,
  TextStyle? defaultTitleStyle,
  TextStyle? defaultSubtitleStyle,
  TextStyle? defaultDescriptionStyle,
})
```

**Built-in presets:**

| Preset                       | Description                                            |
|------------------------------|--------------------------------------------------------|
| `FluxCardThemeData.standard` | Flat, balanced spacing. No elevation.                  |
| `FluxCardThemeData.compact`  | Tighter padding and spacing for dense UIs.             |
| `FluxCardThemeData.elevated` | Box shadow, larger border radius.                      |
| `FluxCardThemeData.outlined` | Thin border using `ColorScheme.outline`. No elevation. |

All presets support `copyWith()`:

```dart
FluxCardThemeData.elevated.copyWith(
  borderRadius: BorderRadius.circular(28),
  padding: const EdgeInsets.all(20),
  spacing: 16,
)
```

**App-level registration:**

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      FluxCardThemeData.elevated.copyWith(
        cardColor: Colors.white,
      ),
    ],
  ),
)
```

---

## Layout modes

| Mode                        | Behavior                                                                                                                                                                                      |
|-----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `FluxLayoutMode.column`     | Slots stacked vertically. Media at top (start) or bottom (end). Default.                                                                                                                      |
| `FluxLayoutMode.row`        | Slots arranged horizontally. Media on the left (start) or right (end). `mediaSpan` controls how many content rows the media spans.                                                            |
| `FluxLayoutMode.responsive` | Switches between `column` and `row` based on `FluxCardThemeData.responsiveBreakpoint` (default 600 logical pixels). Requires `fullWidth: true` or a known parent width to function correctly. |

---

## Layering system

`FluxCard` builds a layered stack for each slot. From bottom to top:

1. **Underlays** (`FluxUnderlay`) — decorative, `IgnorePointer`, rendered first.
2. **Slot content** — media, header, body, footer widgets.
3. **Overlays** (`FluxOverlay`) — interactive by default, rendered last.

Both `FluxOverlay` and `FluxUnderlay` accept a `targets` set:

- `{FluxTarget.card}` — spans the entire card surface (global layer).
- `{FluxTarget.media}` — constrained to the media slot only.
- `{FluxTarget.header}` — constrained to the header slot only.
- `{FluxTarget.body}` — constrained to the body slot only.
- `{FluxTarget.footer}` — constrained to the footer slot only.
- Multiple targets — e.g. `{FluxTarget.header, FluxTarget.body}` — spans those slots as a combined
  region.

Within a target, `zIndex` controls render order. Higher values appear on top.

---

## Theming

Theme resolution order (highest to lowest priority):

1. `FluxCard.theme` parameter — per-card override.
2. `FluxCardThemeData.of(context)` — nearest `FluxCardTheme` ancestor (automatically wraps the card
   during build).
3. `Theme.of(context).extensions[FluxCardThemeData]` — app-level `ThemeExtension`.
4. `FluxCardThemeData()` — package defaults.

---

## Accessibility

- Set `semanticLabel` to describe the card's purpose for screen readers.
- When `onTap` or `onLongPress` is present and `semanticLabel` is set, the card is automatically
  marked as a button in the semantic tree.
- `foregroundColor` propagates through `DefaultTextStyle` and `IconTheme` to all slot content.

---

## Composition examples

### Product card

```dart
FluxCard(
  media: FluxMedia(
    aspectRatio: 4 / 3,
    child: Ink.image(image: NetworkImage(imageUrl), fit: BoxFit.cover),
  ),
  overlays: [
    FluxOverlay(
      targets: const {FluxTarget.media},
      alignment: Alignment.topLeft,
      children: [
        Chip(label: const Text('Sale'), backgroundColor: Colors.red),
      ],
    ),
  ],
  header: FluxSection.header(
    title: const Text('Product name'),
    subtitle: const Text('\$29.99'),
  ),
  footer: FluxSection.footer(
    actions: [
      ElevatedButton(onPressed: () {}, child: const Text('Add to cart')),
    ],
  ),
  theme: FluxCardThemeData.elevated,
  onTap: () {},
)
```

### Horizontal list card

```dart
FluxCard(
  layout: FluxLayoutMode.row,
  mediaPosition: FluxMediaPosition.start,
  media: FluxMedia(width: 100, child: Ink.image(image: NetworkImage(imageUrl), fit: BoxFit.cover)),
  header: FluxSection.header(
    title: const Text('Article title'),
    subtitle: const Text('5 min read'),
  ),
  body: const Text('A short description of the article content...', maxLines: 2),
  theme: FluxCardThemeData.standard,
  onTap: () {},
)
```

### Event ticket

```dart
FluxCard(
  media: FluxMedia(aspectRatio: 16 / 8, child: Ink.image(image: NetworkImage(imageUrl), fit: BoxFit.cover)),
  header: FluxSection.header(title: const Text('Concert name'), subtitle: const Text('Saturday, 8:00 PM')),
  divider: FluxDivider(
    afterHeader: const Divider(height: 1, thickness: 1),
  ),
  notch: FluxNotch(
    boundary: FluxSlotBoundary.afterHeader,
    notchRadius: 14,
    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
  ),
  body: const Text('Gate opens at 7:00 PM. Row A, Seat 12.'),
  theme: FluxCardThemeData.outlined,
)
```

### Full-bleed media with gradient scrim

```dart
FluxCard(
  media: FluxMedia(
    aspectRatio: 3 / 4,
    child: Ink.image(image: NetworkImage(imageUrl), fit: BoxFit.cover),
  ),
  underlays: [
    FluxUnderlay(
      targets: const {FluxTarget.media},
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black87],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.4, 1.0],
        ),
      ),
    ),
  ],
  header: FluxSection.header(
    title: const Text('Title', style: TextStyle(color: Colors.white)),
    subtitle: const Text('Subtitle', style: TextStyle(color: Colors.white70)),
  ),
  theme: const FluxCardThemeData(spacing: 0, padding: EdgeInsets.all(16)),
  onTap: () {},
)
```

### Skeleton loading

```dart
FluxCard(
  loading: isLoading,
  media: FluxMedia(aspectRatio: 16 / 9, child: ...),
  header: FluxSection.header(title: const Text('Title')),
  body: const Text('Content'),
  theme: FluxCardThemeData.elevated,
)
```

---

## AI agent usage notes

This section describes the package's API conventions in a structured format intended for
LLM-assisted code generation.

### Widget naming conventions

All public widgets and classes are prefixed with `Flux`. The main entry point is always `FluxCard`.
Supporting components are: `FluxMedia`, `FluxSection`, `FluxContent`, `FluxOverlay`, `FluxUnderlay`,
`FluxDivider`, `FluxNotch`, `FluxNotchShape`, `FluxCardSkeleton`, `FluxCardThemeData`.

### Enum types and their values

```dart
// Layout direction
FluxLayoutMode.column       // vertical stack (default)
FluxLayoutMode.row          // horizontal arrangement
FluxLayoutMode.responsive   // auto-switches at breakpoint

// Media position within layout
FluxMediaPosition.start     // top (column) or left (row) — default
FluxMediaPosition.end       // bottom (column) or right (row)

// Media height span in row layout
FluxMediaSpan.all           // full card height (default)
FluxMediaSpan.header        // aligns with header slot only
FluxMediaSpan.headerAndBody // aligns with header + body
FluxMediaSpan.body          // aligns with body slot only

// Overlay / underlay slot targets
FluxTarget.card     // entire card surface
FluxTarget.media    // media slot only
FluxTarget.header   // header slot only
FluxTarget.body     // body slot only
FluxTarget.footer   // footer slot only

// Notch boundary (aligns notch with a slot divider)
FluxSlotBoundary.afterMedia    // between media and header
FluxSlotBoundary.afterHeader   // between header and body
FluxSlotBoundary.afterBody     // between body and footer

// Notch edge (which card edges receive a notch)
FluxNotchEdge.vertical     // left and right edges
FluxNotchEdge.horizontal   // top and bottom edges

// Which side(s) of an edge receive the notch
FluxNotchSide.both
FluxNotchSide.left    // or top for horizontal
FluxNotchSide.right   // or bottom for horizontal
```

### Slot content — what each slot accepts

Every slot (`media`, `header`, `body`, `footer`) accepts any `Widget`. The following widgets are
purpose-built for each slot but are not required:

| Slot     | Purpose-built widget | Common alternatives                                  |
|----------|----------------------|------------------------------------------------------|
| `media`  | `FluxMedia`          | `Image`, `Stack`, `VideoPlayer`, custom `Widget`     |
| `header` | `FluxSection.header` | `FluxSection`, `ListTile`, any `Widget`              |
| `body`   | `FluxContent`        | `Text`, `Column`, `FluxContent.column`, any `Widget` |
| `footer` | `FluxSection.footer` | `FluxSection`, `Row` of buttons, any `Widget`        |

### Layering — rules for overlays and underlays

- `FluxOverlay` items go in the `overlays` list on `FluxCard`. They render above content.
- `FluxUnderlay` items go in the `underlays` list on `FluxCard`. They render below content.
- Setting `targets: const {FluxTarget.card}` on either makes it span the full card.
- Setting `targets: const {FluxTarget.media}` constrains it to the media slot only.
- Multiple targets can be combined: `targets: const {FluxTarget.header, FluxTarget.body}`.
- `zIndex` controls render order within the same target — default is `0`.
- To allow an overlay to render outside the card's clip boundary, set `clipBehavior: Clip.none` on
  `FluxCard` and use `offset` on the `FluxOverlay`.

### Theme — how to apply

```dart
// Option 1: per-card (highest priority)
FluxCard(theme: FluxCardThemeData.elevated)

// Option 2: app-wide via ThemeData.extensions
MaterialApp(theme: ThemeData(extensions: [FluxCardThemeData.elevated]))

// Option 3: preset + copyWith
FluxCard(theme: FluxCardThemeData.elevated.copyWith(padding: EdgeInsets.all(20)))
```

### Common patterns for code generation

When generating a card that needs a full-bleed header image with a gradient scrim:

- Place the image in `FluxMedia` as the `media` slot.
- Add a `FluxUnderlay` with `targets: const {FluxTarget.media}` and a gradient `BoxDecoration` as a
  foreground scrim.
- Set `foregroundColor: Colors.white` on `FluxCard` so all text slots read as white automatically.
- Set `theme: const FluxCardThemeData(spacing: 0)` to remove the gap between media and header when
  the design calls for overlapping text.

When generating a card with a badge or chip overlaying the media:

- Add a `FluxOverlay` with `targets: const {FluxTarget.media}` and the desired `alignment`.
- Place the badge widget inside `children` on the `FluxOverlay`.

When generating a loading skeleton:

- Set `loading: true` on `FluxCard`. All slots are automatically replaced by a shimmer placeholder.
- The skeleton mirrors the presence of `media`, `header`, `body`, and `footer` based on whether
  those slots are non-null.

When generating a ticket card:

- Add a `FluxDivider` with a divider widget at `afterHeader`.
- Add a `FluxNotch` with `boundary: FluxSlotBoundary.afterHeader` — the notch position automatically
  aligns with the divider after the first layout pass.
- Set `side` on `FluxNotch` to draw the notch border; set a matching `BorderSide` on
  `FluxCardThemeData` for the card outline.

---

## License

MIT