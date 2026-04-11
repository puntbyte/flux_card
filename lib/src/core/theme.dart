import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class FluxCardThemeData {
  final EdgeInsetsGeometry padding;
  final double spacing;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow>? defaultShadows;
  final TextStyle? defaultTitleStyle;
  final TextStyle? defaultSubtitleStyle;
  final Color? cardColor;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final double elevation;
  final Clip clipBehavior;
  final int flexMedia;
  final int flexContent;
  final double responsiveBreakpoint;

  const FluxCardThemeData({
    this.padding = const EdgeInsets.all(16.0),
    this.spacing = 12.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
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
  });

  static const FluxCardThemeData standard = FluxCardThemeData();

  static const FluxCardThemeData compact = FluxCardThemeData(
    padding: EdgeInsets.all(12.0),
    spacing: 8.0,
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    elevation: 0.0,
  );

  static const FluxCardThemeData elevated = FluxCardThemeData(
    padding: EdgeInsets.all(16.0),
    spacing: 12.0,
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
    defaultShadows: [
      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
    ],
    elevation: 4.0,
  );

  FluxCardThemeData copyWith({
    EdgeInsetsGeometry? padding,
    double? spacing,
    BorderRadiusGeometry? borderRadius,
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
  }) {
    return FluxCardThemeData(
      padding: padding ?? this.padding,
      spacing: spacing ?? this.spacing,
      borderRadius: borderRadius ?? this.borderRadius,
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
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FluxCardThemeData &&
        other.padding == padding &&
        other.spacing == spacing &&
        other.borderRadius == borderRadius &&
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
        other.responsiveBreakpoint == responsiveBreakpoint;
  }

  @override
  int get hashCode => Object.hash(
        padding,
        spacing,
        borderRadius,
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
      );
}

class FluxCardTheme extends InheritedTheme {
  final FluxCardThemeData data;

  const FluxCardTheme({super.key, required this.data, required super.child});

  static FluxCardThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<FluxCardTheme>();
    return theme?.data ?? FluxCardThemeData.standard;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => FluxCardTheme(data: data, child: child);

  @override
  bool updateShouldNotify(FluxCardTheme oldWidget) => data != oldWidget.data;
}
