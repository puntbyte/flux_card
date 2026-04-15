import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../shared/preview_surface.dart';

@widgetbook.UseCase(name: 'Semantic .header', type: FluxSection, path: '[Flux Card]/Sections')
Widget buildSectionHeaderUseCase(BuildContext context) {
  return previewSurface(
    context,
    const Card(
      child: FluxSection.header(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text('FluxSection.header'),
        subtitle: Text('Clean autocomplete: no actions or child properties.'),
        trailing: [Chip(label: Text('PRO'))],
        padding: EdgeInsets.all(16),
      ),
    ),
    maxWidth: 420,
  );
}

@widgetbook.UseCase(name: 'Semantic .footer', type: FluxSection, path: '[Flux Card]/Sections')
Widget buildSectionFooterUseCase(BuildContext context) {
  final alignment = context.knobs.object.segmented<MainAxisAlignment>(
    label: 'Alignment',
    options: const [MainAxisAlignment.start, MainAxisAlignment.end, MainAxisAlignment.spaceBetween],
    labelBuilder: (a) => a.name,
  );

  return previewSurface(
    context,
    Card(
      child: FluxSection.footer(
        actionsAlignment: alignment,
        padding: const EdgeInsets.all(16),
        actions: [
          const Text('\$49.99', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ElevatedButton(onPressed: () {}, child: const Text('Checkout')),
        ],
      ),
    ),
    maxWidth: 420,
  );
}

@widgetbook.UseCase(name: 'Agnostic (Omni-tool)', type: FluxSection, path: '[Flux Card]/Sections')
Widget buildSectionAnatomyUseCase(BuildContext context) {
  final showLeading = context.knobs.boolean(label: 'Show leading', initialValue: true);
  final showTrailing = context.knobs.boolean(label: 'Show trailing', initialValue: true);
  final showChild = context.knobs.boolean(label: 'Show child', initialValue: true);
  final showActions = context.knobs.boolean(label: 'Show actions', initialValue: true);

  return previewSurface(
    context,
    FluxSection(
      leading: showLeading ? const CircleAvatar(child: Icon(Icons.widgets)) : null,
      title: const Text('Agnostic FluxSection'),
      subtitle: const Text('The default constructor allows everything.'),
      trailing: showTrailing ? const [Chip(label: Text('NEW'))] : null,
      actions: showActions
          ? [
              TextButton(onPressed: () {}, child: const Text('PRIMARY')),
              OutlinedButton(onPressed: () {}, child: const Text('SECONDARY')),
            ]
          : null,
      padding: const EdgeInsets.all(20),
      child: showChild
          ? const Text('Free-form body content placed between the header row and actions.')
          : null,
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
      header: FluxSection.header(
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
      body: const Text(
        'Use decoration to create visually distinct header and footer zones within the same card.',
      ),
      footer: FluxSection.footer(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(12),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          ),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [ElevatedButton(onPressed: () {}, child: const Text('Upgrade'))],
        padding: const EdgeInsets.all(16),
      ),
      theme: FluxCardThemeData.elevated.copyWith(padding: EdgeInsets.zero),
    ),
    maxWidth: 420,
  );
}

@widgetbook.UseCase(name: 'Full Bleed Override', type: FluxSection, path: '[Flux Card]/Sections')
Widget buildSectionFullBleedUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      // The card provides a global 20px padding
      theme: FluxCardThemeData.elevated.copyWith(padding: const EdgeInsets.all(20)),

      header: FluxSection.header(
        // Override the card padding to make this slot hit the edges
        margin: EdgeInsets.zero,
        // Re-apply 20px padding internally so the text stays aligned
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        title: const Text('Full Bleed Header'),
        subtitle: const Text('margin: EdgeInsets.zero overrides the card padding!'),
      ),

      body: const Text(
        'This standard Text widget is automatically padded by the card\'s default 20px padding '
        'because it doesn\'t provide an externalPaddingOverride. The gap above and below '
        'is purely controlled by the card\'s spacing property.',
      ),

      footer: FluxSection.footer(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [ElevatedButton(onPressed: () {}, child: const Text('Accept'))],
      ),
    ),
    maxWidth: 420,
  );
}
