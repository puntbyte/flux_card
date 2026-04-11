import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../shared/preview_surface.dart';

@widgetbook.UseCase(name: 'Color', type: FluxBackground, path: '[Flux Card]/Backgrounds')
Widget buildBackgroundColorUseCase(BuildContext context) {
  final color = context.knobs.object.segmented<Color>(
    label: 'Color',
    options: const [Color(0xFF0EA5E9), Color(0xFF22C55E), Color(0xFFF97316), Color(0xFF8B5CF6)],
    labelBuilder: (value) {
      if (value == const Color(0xFF0EA5E9)) return 'Sky';
      if (value == const Color(0xFF22C55E)) return 'Green';
      if (value == const Color(0xFFF97316)) return 'Orange';
      return 'Purple';
    },
  );

  return previewSurface(
    context,
    FluxCard(
      background: FluxBackground.color(color: color),
      header: const FluxHeader(title: Text('Color background')),
      content: const Text('Solid backgrounds are useful for brand colors and section placeholders.'),
      theme: FluxCardThemeData.elevated,
    ),
  );
}

@widgetbook.UseCase(name: 'Gradient', type: FluxBackground, path: '[Flux Card]/Backgrounds')
Widget buildBackgroundGradientUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      background: const FluxBackground.gradient(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4F46E5), Color(0xFF8B5CF6), Color(0xFFEC4899)],
        ),
      ),
      header: const FluxHeader(title: Text('Gradient background')),
      content: const Text('Gradients work well for hero sections and promotional cards.'),
      theme: FluxCardThemeData.elevated.copyWith(padding: const EdgeInsets.all(20)),
    ),
  );
}

@widgetbook.UseCase(name: 'Custom decoration', type: FluxBackground, path: '[Flux Card]/Backgrounds')
Widget buildBackgroundCustomUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      background: FluxBackground.custom(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(colors: [Color(0xFF111827), Color(0xFF1F2937)]),
        ),
      ),
      header: const FluxHeader(title: Text('Custom decoration')),
      content: const Text('Any BoxDecoration can be used through the custom constructor.'),
      theme: FluxCardThemeData.elevated,
    ),
  );
}
