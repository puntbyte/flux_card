import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../shared/preview_surface.dart';

const _kThemeImageUrl =
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800';

Widget _themeCard(BuildContext context, FluxCardThemeData theme, String label, String description) =>
    previewSurface(
      context,
      FluxCard(
        media: FluxMedia(
          aspectRatio: 16 / 9,
          child: Ink.image(
            image: const CachedNetworkImageProvider(_kThemeImageUrl),
            fit: BoxFit.cover,
          ),
        ),
        header: FluxSection(
          title: Text(label),
          subtitle: Text(description),
          padding: EdgeInsets.zero,
        ),
        body: const Text('Combine with copyWith() to fine-tune any preset.'),
        footer: FluxSection(
          actions: [ElevatedButton(onPressed: () {}, child: const Text('Action'))],
          padding: EdgeInsets.zero,
        ),
        theme: theme,
        onTap: () {},
      ),
      maxWidth: 380,
    );

@widgetbook.UseCase(name: 'Standard', type: FluxCardThemeData, path: '[Flux Card]/Themes')
Widget buildThemeStandardUseCase(BuildContext context) =>
    _themeCard(context, FluxCardThemeData.standard, 'Standard', 'Flat with balanced spacing.');

@widgetbook.UseCase(name: 'Compact', type: FluxCardThemeData, path: '[Flux Card]/Themes')
Widget buildThemeCompactUseCase(BuildContext context) =>
    _themeCard(context, FluxCardThemeData.compact, 'Compact', 'Tighter spacing for dense UIs.');

@widgetbook.UseCase(name: 'Elevated', type: FluxCardThemeData, path: '[Flux Card]/Themes')
Widget buildThemeElevatedUseCase(BuildContext context) =>
    _themeCard(context, FluxCardThemeData.elevated, 'Elevated', 'Shadows and larger radius.');

@widgetbook.UseCase(name: 'Outlined', type: FluxCardThemeData, path: '[Flux Card]/Themes')
Widget buildThemeOutlinedUseCase(BuildContext context) {
  final width = context.knobs.double.slider(
    label: 'Border width',
    min: 0.5,
    max: 4,
    divisions: 7,
    initialValue: 1.5,
  );

  return previewSurface(
    context,
    FluxCard(
      media: FluxMedia(
        aspectRatio: 16 / 9,
        child: Ink.image(
          image: const CachedNetworkImageProvider(_kThemeImageUrl),
          fit: BoxFit.cover,
        ),
      ),
      header: const FluxSection(
        title: Text('Outlined'),
        subtitle: Text('Border adapts to ColorScheme.outline automatically.'),
        padding: EdgeInsets.zero,
      ),
      body: const Text('Set borderSide on any preset via copyWith.'),
      footer: FluxSection(
        actions: [ElevatedButton(onPressed: () {}, child: const Text('Action'))],
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.outlined.copyWith(
        borderSide: BorderSide(width: width, color: const Color(0x01000000)),
      ),
      onTap: () {},
    ),
    maxWidth: 380,
  );
}

@widgetbook.UseCase(name: 'Custom', type: FluxCardThemeData, path: '[Flux Card]/Themes')
Widget buildThemeCustomUseCase(BuildContext context) {
  final radius = context.knobs.double.slider(
    label: 'Border radius',
    min: 4,
    max: 40,
    divisions: 18,
    initialValue: 24,
  );
  final padding = context.knobs.double.slider(
    label: 'Padding',
    min: 8,
    max: 32,
    divisions: 12,
    initialValue: 20,
  );
  final spacing = context.knobs.double.slider(
    label: 'Spacing',
    min: 4,
    max: 24,
    divisions: 10,
    initialValue: 12,
  );

  return _themeCard(
    context,
    FluxCardThemeData.elevated.copyWith(
      borderRadius: BorderRadius.circular(radius),
      padding: EdgeInsets.all(padding),
      spacing: spacing,
    ),
    'Custom',
    'Knob-driven copyWith — instant feedback.',
  );
}

@widgetbook.UseCase(name: 'ThemeExtension', type: FluxCardThemeData, path: '[Flux Card]/Themes')
Widget buildThemeExtensionUseCase(BuildContext context) {
  return previewSurface(
    context,
    // Demonstrates app-level ThemeExtension registration.
    Theme(
      data: Theme.of(context).copyWith(
        extensions: [
          FluxCardThemeData.elevated.copyWith(
            cardColor: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(28)),
          ),
        ],
      ),
      child: FluxCard(
        // No explicit theme — picks up from ThemeData.extensions.
        header: const FluxSection(
          title: Text('ThemeExtension'),
          subtitle: Text('No per-card theme set — inherited from ThemeData.extensions.'),
          padding: EdgeInsets.zero,
        ),
        body: const Text(
          'Register FluxCardThemeData in MaterialApp.theme for app-wide defaults.',
        ),
        onTap: () {},
      ),
    ),
    maxWidth: 380,
  );
}