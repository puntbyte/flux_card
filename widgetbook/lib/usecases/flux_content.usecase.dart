import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../shared/preview_surface.dart';

const _loremLong =
    'Flutter is Google\'s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase. '
    'It uses the Dart programming language and provides a rich set of pre-built widgets. '
    'FluxCard\'s FluxContent gives you scroll, min/max height, alignment, and decoration for any body content without restructuring the card.';

@widgetbook.UseCase(name: 'Scrollable body', type: FluxContent, path: '[Flux Card]/Content')
Widget buildContentScrollableUseCase(BuildContext context) {
  final maxHeight = context.knobs.double.slider(
    label: 'Max height',
    min: 60,
    max: 240,
    divisions: 18,
    initialValue: 100,
  );

  return previewSurface(
    context,
    FluxCard(
      header: const FluxSection(
        title: Text('Scrollable body'),
        subtitle: Text('FluxContent with scrollable: true'),
        padding: EdgeInsets.zero,
      ),
      body: FluxContent(
        scrollable: true,
        maxHeight: maxHeight,
        child: const Text(_loremLong),
      ),
      theme: FluxCardThemeData.elevated,
    ),
    maxWidth: 380,
  );
}

@widgetbook.UseCase(name: 'With decoration', type: FluxContent, path: '[Flux Card]/Content')
Widget buildContentDecorationUseCase(BuildContext context) {
  final radius = context.knobs.double.slider(
    label: 'Radius',
    min: 0,
    max: 20,
    divisions: 10,
    initialValue: 8,
  );

  return previewSurface(
    context,
    FluxCard(
      header: const FluxSection(
        title: Text('Decorated body'),
        padding: EdgeInsets.zero,
      ),
      body: FluxContent(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: Colors.amber.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.amber.shade700, size: 18),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Use decoration to create callout boxes, code blocks, or highlighted sections.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
      theme: FluxCardThemeData.elevated,
    ),
    maxWidth: 380,
  );
}

@widgetbook.UseCase(name: 'Min / max height', type: FluxContent, path: '[Flux Card]/Content')
Widget buildContentConstraintsUseCase(BuildContext context) {
  final minHeight = context.knobs.double.slider(
    label: 'Min height',
    min: 0,
    max: 200,
    divisions: 20,
    initialValue: 80,
  );
  final useShortText = context.knobs.boolean(label: 'Short text', initialValue: false);

  return previewSurface(
    context,
    FluxCard(
      header: const FluxSection(
        title: Text('Min/max height'),
        padding: EdgeInsets.zero,
      ),
      body: FluxContent(
        minHeight: minHeight,
        alignment: Alignment.topLeft,
        child: Text(useShortText ? 'Short.' : _loremLong),
      ),
      theme: FluxCardThemeData.elevated,
    ),
    maxWidth: 380,
  );
}
