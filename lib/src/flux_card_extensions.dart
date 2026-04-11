import 'package:flutter/material.dart';
import 'components/footer.dart';
import 'components/header.dart';
import 'core/contracts.dart';
import 'core/theme.dart';
import 'flux_card.dart';

class FluxCardBuilder {
  FluxCardLayout _layout = const FluxCardLayout.column();
  Widget? _background;
  Widget? _media;
  Widget? _header;
  Widget? _content;
  Widget? _footer;
  Widget? _overlay;
  double? _width;
  double? _height;
  bool _fullWidth = false;
  bool _fullHeight = false;
  FluxCardThemeData? _theme;
  VoidCallback? _onTap;
  VoidCallback? _onLongPress;
  Color? _foregroundColor;

  FluxCardBuilder layout(FluxCardLayout layout) {
    _layout = layout;
    return this;
  }

  /// Decorative background layer.
  FluxCardBuilder background(Widget? bg) {
    _background = bg;
    return this;
  }

  /// Media/content visual slot.
  FluxCardBuilder media(Widget? media) {
    _media = media;
    return this;
  }

  FluxCardBuilder header({
    Widget? title,
    Widget? subtitle,
    Widget? leading,
    List<Widget>? trailing,
  }) {
    _header = title != null
        ? FluxHeader(title: title, subtitle: subtitle, leading: leading, trailing: trailing)
        : null;
    return this;
  }

  FluxCardBuilder content(Widget child) {
    _content = child;
    return this;
  }

  FluxCardBuilder footer({required List<Widget> actions, Axis direction = Axis.horizontal}) {
    _footer = FluxFooter(actions: actions, direction: direction);
    return this;
  }

  FluxCardBuilder overlay(Widget child) {
    _overlay = child;
    return this;
  }

  FluxCardBuilder sizing({
    double? width,
    double? height,
    bool fullWidth = false,
    bool fullHeight = false,
  }) {
    _width = width;
    _height = height;
    _fullWidth = fullWidth;
    _fullHeight = fullHeight;
    return this;
  }

  FluxCardBuilder theme(FluxCardThemeData theme) {
    _theme = theme;
    return this;
  }

  FluxCardBuilder foregroundColor(Color? color) {
    _foregroundColor = color;
    return this;
  }

  FluxCardBuilder interactions({VoidCallback? onTap, VoidCallback? onLongPress}) {
    _onTap = onTap;
    _onLongPress = onLongPress;
    return this;
  }

  FluxCard build() => FluxCard(
        layout: _layout,
        background: _background,
        media: _media,
        foregroundColor: _foregroundColor,
        header: _header,
        content: _content,
        footer: _footer,
        overlay: _overlay,
        width: _width,
        height: _height,
        fullWidth: _fullWidth,
        fullHeight: _fullHeight,
        theme: _theme,
        onTap: _onTap,
        onLongPress: _onLongPress,
      );
}
