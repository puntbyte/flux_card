import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../shared/preview_surface.dart';

@widgetbook.UseCase(name: 'Horizontal actions', type: FluxFooter, path: '[Flux Card]/Footer')
Widget buildFooterHorizontalUseCase(BuildContext context) {
  return previewSurface(
    context,
    const FluxCard(
      footer: FluxFooter(
        actions: [Text('Edit'), Text('Share'), Text('Delete')],
      ),
      theme: FluxCardThemeData.elevated,
    ),
  );
}

@widgetbook.UseCase(name: 'Wrapped actions', type: FluxFooter, path: '[Flux Card]/Footer')
Widget buildFooterWrappedUseCase(BuildContext context) {
  return previewSurface(
    context,
    const FluxCard(
      footer: FluxFooter(
        actions: [
          Chip(label: Text('Flutter')),
          Chip(label: Text('Dart')),
          Chip(label: Text('UI')),
          Chip(label: Text('Widgets')),
          Chip(label: Text('Layout')),
        ],
      ),
      theme: FluxCardThemeData.elevated,
    ),
  );
}

@widgetbook.UseCase(name: 'Stacked actions', type: FluxFooter, path: '[Flux Card]/Footer')
Widget buildFooterStackedUseCase(BuildContext context) {
  final spacing = context.knobs.double.slider(label: 'Spacing', min: 6, max: 24, divisions: 9, initialValue: 12);
  return previewSurface(
    context,
    FluxCard(
      footer: FluxFooter(
        direction: Axis.vertical,
        spacing: spacing,
        actions: const [Text('Primary'), Text('Secondary'), Text('Tertiary')],
      ),
      theme: FluxCardThemeData.elevated,
    ),
  );
}
