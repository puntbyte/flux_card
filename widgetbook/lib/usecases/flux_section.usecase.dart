import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../shared/preview_surface.dart';

@widgetbook.UseCase(name: 'Full anatomy', type: FluxSection, path: '[Flux Card]/Sections')
Widget buildSectionAnatomyUseCase(BuildContext context) {
  final showLeading = context.knobs.boolean(label: 'Show leading', initialValue: true);
  final showTrailing = context.knobs.boolean(label: 'Show trailing', initialValue: true);
  final showChild = context.knobs.boolean(label: 'Show child', initialValue: true);
  final showActions = context.knobs.boolean(label: 'Show actions', initialValue: true);
  final spacing = context.knobs.double.slider(
    label: 'Spacing',
    min: 4,
    max: 24,
    divisions: 10,
    initialValue: 12,
  );

  return previewSurface(
    context,
    FluxSection(
      leading: showLeading ? const CircleAvatar(child: Icon(Icons.person)) : null,
      title: const Text('FluxSection'),
      subtitle: const Text('Header row + child + actions'),
      trailing: showTrailing ? const [Chip(label: Text('NEW'))] : null,
      child: showChild
          ? const Text('Free-form body content placed between the header row and actions.')
          : null,
      actions: showActions
          ? [
              TextButton(onPressed: () {}, child: const Text('PRIMARY')),
              OutlinedButton(onPressed: () {}, child: const Text('SECONDARY')),
            ]
          : null,
      spacing: spacing,
      padding: const EdgeInsets.all(20),
    ),
    maxWidth: 420,
  );
}

@widgetbook.UseCase(name: 'With decoration', type: FluxSection, path: '[Flux Card]/Sections')
Widget buildSectionDecorationUseCase(BuildContext context) {
  final radius = context.knobs.double.slider(
    label: 'Border radius',
    min: 0,
    max: 24,
    divisions: 12,
    initialValue: 12,
  );

  return previewSurface(
    context,
    FluxCard(
      header: FluxSection(
        title: const Text('Pro Plan'),
        subtitle: const Text('Everything you need at scale'),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
          ),
        ),
        padding: const EdgeInsets.all(16),
      ),
      body: const Text('Use decoration to create visually distinct header and footer zones within the same card.'),
      footer: FluxSection(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(12),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          ),
        ),
        actions: [
          ElevatedButton(onPressed: () {}, child: const Text('Upgrade')),
        ],
        padding: const EdgeInsets.all(16),
      ),
      theme: FluxCardThemeData.elevated.copyWith(padding: EdgeInsets.zero),
    ),
    maxWidth: 420,
  );
}

@widgetbook.UseCase(name: 'As standalone', type: FluxSection, path: '[Flux Card]/Sections')
Widget buildSectionStandaloneUseCase(BuildContext context) {
  return previewSurface(
    context,
    Card(
      child: FluxSection(
        leading: const Icon(Icons.notifications_outlined),
        title: const Text('FluxSection outside FluxCard'),
        subtitle: const Text('It works anywhere — not tied to FluxCard.'),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Dismiss')),
        ],
        padding: const EdgeInsets.all(16),
      ),
    ),
    maxWidth: 420,
  );
}
