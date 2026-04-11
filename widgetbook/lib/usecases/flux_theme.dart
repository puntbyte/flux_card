import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../shared/preview_surface.dart';

@widgetbook.UseCase(name: 'Standard', type: FluxCardThemeData, path: '[Flux Card]/Themes')
Widget buildThemeStandardUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      background: const FluxBackground.color(color: Color(0xFFE2E8F0)),
      header: const FluxHeader(title: Text('Standard theme')),
      content: const Text('Default spacing and rounded corners.'),
      footer: const FluxFooter(actions: [Text('Preview')]),
      theme: FluxCardThemeData.standard,
    ),
  );
}

@widgetbook.UseCase(name: 'Compact', type: FluxCardThemeData, path: '[Flux Card]/Themes')
Widget buildThemeCompactUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      background: const FluxBackground.color(color: Color(0xFFCBD5E1)),
      header: const FluxHeader(title: Text('Compact theme')),
      content: const Text('Tighter padding and smaller spacing.'),
      footer: const FluxFooter(actions: [Text('Preview')]),
      theme: FluxCardThemeData.compact,
    ),
  );
}

@widgetbook.UseCase(name: 'Elevated', type: FluxCardThemeData, path: '[Flux Card]/Themes')
Widget buildThemeElevatedUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      background: const FluxBackground.gradient(
        gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFA855F7)]),
      ),
      header: const FluxHeader(title: Text('Elevated theme')),
      content: const Text('Adds a stronger radius and depth.'),
      footer: const FluxFooter(actions: [Text('Preview')]),
      theme: FluxCardThemeData.elevated,
    ),
  );
}

@widgetbook.UseCase(name: 'Custom', type: FluxCardThemeData, path: '[Flux Card]/Themes')
Widget buildThemeCustomUseCase(BuildContext context) {
  final padding = context.knobs.double.slider(label: 'Padding', min: 8, max: 32, divisions: 12, initialValue: 20);
  final spacing = context.knobs.double.slider(label: 'Spacing', min: 4, max: 24, divisions: 10, initialValue: 12);
  final radius = context.knobs.double.slider(label: 'Radius', min: 8, max: 32, divisions: 12, initialValue: 24);

  return previewSurface(
    context,
    FluxCard(
      background: const FluxBackground.custom(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF111827), Color(0xFF1F2937)]),
        ),
      ),
      header: const FluxHeader(title: Text('Custom theme')),
      content: const Text('Knobs change the theme values live.'),
      footer: const FluxFooter(actions: [Text('Preview')]),
      theme: FluxCardThemeData(
        padding: EdgeInsets.all(padding),
        spacing: spacing,
        borderRadius: BorderRadius.circular(radius),
        defaultShadows: const [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 8))],
        elevation: 6,
      ),
    ),
  );
}
