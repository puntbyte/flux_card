import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'app_themes.dart';
import 'widgetbook.directories.g.dart';

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final light = buildLightTheme();
    final dark = buildDarkTheme();

    return Widgetbook.material(
      directories: directories,
      lightTheme: light,
      darkTheme: dark,
      themeMode: ThemeMode.system,
      addons: [
        InspectorAddon(),
        SemanticsAddon(),
        ViewportAddon(const [
          ViewportData(
            name: 'Phone',
            width: 390,
            height: 844,
            pixelRatio: 3,
            platform: TargetPlatform.iOS,
          ),
          ViewportData(
            name: 'Tablet',
            width: 820,
            height: 1180,
            pixelRatio: 2,
            platform: TargetPlatform.iOS,
          ),
          ViewportData(
            name: 'Desktop',
            width: 1440,
            height: 1024,
            pixelRatio: 1,
            platform: TargetPlatform.macOS,
          ),
        ]),
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: light),
            WidgetbookTheme(name: 'Dark', data: dark),
          ],
        ),
      ],
    );
  }
}
