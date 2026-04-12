import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Sentinel color: transparent with a non-zero alpha value that no real design
// would intentionally use. When FluxCard sees this color on the borderSide, it
// replaces it with the ambient ColorScheme.outline, enabling the outlined
// preset to adapt to any theme automatically.
const Color _kThemeOutlineColor = Color(0x01000000);

/// Immutable theme token for [FluxCard].
///
/// Can be supplied in three ways (highest priority first):
/// 1. Directly via [FluxCard.theme].
/// 2. Via a [FluxCardTheme] InheritedWidget for subtree-level overrides.
/// 3. Via [ThemeExtension] in the ambient [ThemeData] for app-level defaults:
///    ```dart
///    MaterialApp(
///      theme: ThemeData(
///        extensions: [FluxCardThemeData.elevated],
///      ),
///    )
///    ```
@immutable
class FluxCardThemeData extends ThemeExtension<FluxCardThemeData> {
  const FluxCardThemeData({
    this.padding = const EdgeInsets.all(16.0),
    this.spacing = 12.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.borderSide = BorderSide.none,
    this.defaultShadows,
    this.defaultTitleStyle,
    this.defaultSubtitleStyle,
    this.cardColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation = 0.0,
    this.clipBehavior = Clip.antiAlias,
    this.flexMedia = 2,
    this.flexContent = 3,
    this.responsiveBreakpoint = 600.0,
    this.shape,
  });

  final EdgeInsetsGeometry padding;
  final double spacing;
  final BorderRadiusGeometry borderRadius;

  /// Border drawn around the card.
  ///
  /// Use [BorderSide.none] (the default) for no border.
  /// The [outlined] preset uses a sentinel color that is automatically
  /// replaced with [ColorScheme.outline] at build time.
  final BorderSide borderSide;

  final List<BoxShadow>? defaultShadows;
  final TextStyle? defaultTitleStyle;
  final TextStyle? defaultSubtitleStyle;
  final Color? cardColor;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final double elevation;
  final Clip clipBehavior;

  /// Flex factor for the media slot in [FluxLayoutMode.row].
  final int flexMedia;

  /// Flex factor for the content column in [FluxLayoutMode.row].
  final int flexContent;

  /// Width breakpoint used by [FluxLayoutMode.responsive] to switch between
  /// column and row layouts.
  final double responsiveBreakpoint;

  /// Optional custom [ShapeBorder] for the card surface.
  ///
  /// When null, [RoundedRectangleBorder] is constructed from [borderRadius]
  /// and [borderSide]. Use [FluxTicketShape] here for ticket-style cards.
  final ShapeBorder? shape;

  // ── Presets ──────────────────────────────────────────────────────────────

  /// Flat card with balanced spacing and radius.
  static const FluxCardThemeData standard = FluxCardThemeData();

  /// Tighter spacing for dense lists and dashboards.
  static const FluxCardThemeData compact = FluxCardThemeData(
    padding: EdgeInsets.all(12.0),
    spacing: 8.0,
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
  );

  /// Raised card with shadows and larger radius.
  static const FluxCardThemeData elevated = FluxCardThemeData(
    padding: EdgeInsets.all(16.0),
    spacing: 12.0,
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
    defaultShadows: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
    elevation: 4.0,
  );

  /// Flat card with a 1.5 dp border that adapts to the ambient
  /// [ColorScheme.outline] at build time.
  static const FluxCardThemeData outlined = FluxCardThemeData(
    borderSide: BorderSide(width: 1.5, color: _kThemeOutlineColor),
  );

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Resolves the [borderSide] color, replacing the sentinel value with the
  /// ambient [ColorScheme.outline] when appropriate.
  BorderSide resolveBorderSide(BuildContext context) {
    if (borderSide == BorderSide.none) return BorderSide.none;
    if (borderSide.color == _kThemeOutlineColor) {
      return borderSide.copyWith(color: Theme.of(context).colorScheme.outline);
    }
    return borderSide;
  }

  /// Resolves the effective [ShapeBorder] from [shape], [borderRadius], and
  /// the resolved [borderSide].
  ShapeBorder resolveShape(BuildContext context) {
    if (shape != null) return shape!;
    return RoundedRectangleBorder(borderRadius: borderRadius, side: resolveBorderSide(context));
  }

  // ── Theme lookup ──────────────────────────────────────────────────────────

  /// Finds the nearest [FluxCardThemeData] in [context].
  ///
  /// Priority: [FluxCardTheme] InheritedWidget → [ThemeExtension] → [standard].
  static FluxCardThemeData of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<FluxCardTheme>();
    if (inherited != null) return inherited.data;
    return Theme.of(context).extension<FluxCardThemeData>() ?? standard;
  }

  // ── ThemeExtension ────────────────────────────────────────────────────────

  @override
  FluxCardThemeData copyWith({
    EdgeInsetsGeometry? padding,
    double? spacing,
    BorderRadiusGeometry? borderRadius,
    BorderSide? borderSide,
    List<BoxShadow>? defaultShadows,
    TextStyle? defaultTitleStyle,
    TextStyle? defaultSubtitleStyle,
    Color? cardColor,
    Color? shadowColor,
    Color? surfaceTintColor,
    double? elevation,
    Clip? clipBehavior,
    int? flexMedia,
    int? flexContent,
    double? responsiveBreakpoint,
    ShapeBorder? shape,
  }) => FluxCardThemeData(
    padding: padding ?? this.padding,
    spacing: spacing ?? this.spacing,
    borderRadius: borderRadius ?? this.borderRadius,
    borderSide: borderSide ?? this.borderSide,
    defaultShadows: defaultShadows ?? this.defaultShadows,
    defaultTitleStyle: defaultTitleStyle ?? this.defaultTitleStyle,
    defaultSubtitleStyle: defaultSubtitleStyle ?? this.defaultSubtitleStyle,
    cardColor: cardColor ?? this.cardColor,
    shadowColor: shadowColor ?? this.shadowColor,
    surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    elevation: elevation ?? this.elevation,
    clipBehavior: clipBehavior ?? this.clipBehavior,
    flexMedia: flexMedia ?? this.flexMedia,
    flexContent: flexContent ?? this.flexContent,
    responsiveBreakpoint: responsiveBreakpoint ?? this.responsiveBreakpoint,
    shape: shape ?? this.shape,
  );

  @override
  FluxCardThemeData lerp(FluxCardThemeData? other, double t) {
    if (other == null) return this;
    return FluxCardThemeData(
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t) ?? padding,
      spacing: lerpDouble(spacing, other.spacing, t) ?? spacing,
      borderRadius: BorderRadiusGeometry.lerp(borderRadius, other.borderRadius, t) ?? borderRadius,
      borderSide: BorderSide.lerp(borderSide, other.borderSide, t),
      defaultShadows: t < 0.5 ? defaultShadows : other.defaultShadows,
      defaultTitleStyle: TextStyle.lerp(defaultTitleStyle, other.defaultTitleStyle, t),
      defaultSubtitleStyle: TextStyle.lerp(defaultSubtitleStyle, other.defaultSubtitleStyle, t),
      cardColor: Color.lerp(cardColor, other.cardColor, t),
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t),
      surfaceTintColor: Color.lerp(surfaceTintColor, other.surfaceTintColor, t),
      elevation: lerpDouble(elevation, other.elevation, t) ?? elevation,
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
      flexMedia: t < 0.5 ? flexMedia : other.flexMedia,
      flexContent: t < 0.5 ? flexContent : other.flexContent,
      responsiveBreakpoint:
          lerpDouble(responsiveBreakpoint, other.responsiveBreakpoint, t) ?? responsiveBreakpoint,
      shape: ShapeBorder.lerp(shape, other.shape, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is FluxCardThemeData &&
      other.padding == padding &&
      other.spacing == spacing &&
      other.borderRadius == borderRadius &&
      other.borderSide == borderSide &&
      listEquals(other.defaultShadows, defaultShadows) &&
      other.defaultTitleStyle == defaultTitleStyle &&
      other.defaultSubtitleStyle == defaultSubtitleStyle &&
      other.cardColor == cardColor &&
      other.shadowColor == shadowColor &&
      other.surfaceTintColor == surfaceTintColor &&
      other.elevation == elevation &&
      other.clipBehavior == clipBehavior &&
      other.flexMedia == flexMedia &&
      other.flexContent == flexContent &&
      other.responsiveBreakpoint == responsiveBreakpoint &&
      other.shape == shape;

  @override
  int get hashCode => Object.hash(
    padding,
    spacing,
    borderRadius,
    borderSide,
    Object.hashAll(defaultShadows ?? const <BoxShadow>[]),
    defaultTitleStyle,
    defaultSubtitleStyle,
    cardColor,
    shadowColor,
    surfaceTintColor,
    elevation,
    clipBehavior,
    flexMedia,
    flexContent,
    responsiveBreakpoint,
    shape,
  );
}

/// InheritedWidget for subtree-level [FluxCardThemeData] overrides.
///
/// Takes priority over [ThemeExtension] but is itself overridden by a
/// per-card [FluxCard.theme].
class FluxCardTheme extends InheritedTheme {
  const FluxCardTheme({super.key, required this.data, required super.child});

  final FluxCardThemeData data;

  @override
  Widget wrap(BuildContext context, Widget child) => FluxCardTheme(data: data, child: child);

  @override
  bool updateShouldNotify(FluxCardTheme oldWidget) => data != oldWidget.data;
}
