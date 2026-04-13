import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../demo/demo_destination.dart';
import '../shared/preview_surface.dart';

@widgetbook.UseCase(name: 'Color', type: FluxBackground, path: '[Flux Card]/Backgrounds')
Widget buildBackgroundColorUseCase(BuildContext context) {
  final color = context.knobs.object.segmented<Color>(
    label: 'Color',
    options: const [Color(0xFFE2E8F0), Color(0xFFBFDBFE), Color(0xFFFBCFE8), Color(0xFFDDD6FE)],
    labelBuilder: (c) {
      if (c == const Color(0xFFE2E8F0)) return 'Slate';
      if (c == const Color(0xFFBFDBFE)) return 'Blue';
      if (c == const Color(0xFFFBCFE8)) return 'Pink';
      return 'Violet';
    },
  );

  return previewSurface(
    context,
    FluxCard(
      backgrounds: [FluxBackground.color(color: color)],
      header: const FluxSection.header(title: Text('Color background'), padding: EdgeInsets.zero),
      body: const Text('FluxTarget.card (default) paints the whole surface.'),
      theme: FluxCardThemeData.elevated,
      height: 160,
    ),
  );
}

@widgetbook.UseCase(name: 'Gradient', type: FluxBackground, path: '[Flux Card]/Backgrounds')
Widget buildBackgroundGradientUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      backgrounds: const [
        FluxBackground.gradient(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF4F46E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ],
      foregroundColor: Colors.white,
      header: const FluxSection.header(
        title: Text('Gradient background'),
        subtitle: Text('Gradient alignment lives in the LinearGradient itself.'),
        padding: EdgeInsets.zero,
      ),
      body: const Text('Compose with foregroundColor for full dark-card control.'),
      theme: FluxCardThemeData.elevated.copyWith(padding: const EdgeInsets.all(20)),
      height: 180,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multi-Target Image',
  type: FluxBackground,
  path: '[Flux Card]/Backgrounds',
)
Widget buildBackgroundImageUseCase(BuildContext context) {
  final targetHeader = context.knobs.boolean(label: 'Target Header', initialValue: true);
  final targetBody = context.knobs.boolean(label: 'Target Body', initialValue: true);
  final targetFooter = context.knobs.boolean(label: 'Target Footer', initialValue: false);

  final targets = <FluxTarget>{
    if (targetHeader) FluxTarget.header,
    if (targetBody) FluxTarget.body,
    if (targetFooter) FluxTarget.footer,
  };

  return previewSurface(
    context,
    FluxCard(
      backgrounds: [
        FluxBackground.custom(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(demoDestinations[0].image), // Santorini image
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.darken),
            ),
          ),
          targets: targets.isEmpty ? {FluxTarget.card} : targets,
        ),
      ],
      foregroundColor: Colors.white,
      header: const FluxSection.header(
        title: Text('Image background'),
        subtitle: Text('Using FluxBackground.custom()'),
        padding: EdgeInsets.all(20),
      ),
      body: const FluxContent(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Because the targets include multiple contiguous slots (e.g. Header + Body), FluxCard automatically wraps them in a single layout block. This means the image spans seamlessly behind both slots instead of repeating!',
        ),
      ),
      footer: FluxSection.footer(
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: const Text('Explore'),
          ),
        ],
        padding: const EdgeInsets.all(20),
      ),
      // We remove the padding from the card so the image goes edge-to-edge,
      // and let the slots handle their own internal padding.
      theme: FluxCardThemeData.elevated.copyWith(padding: EdgeInsets.zero),
    ),
    maxWidth: 380,
  );
}

@widgetbook.UseCase(name: 'Slot-targeted', type: FluxBackground, path: '[Flux Card]/Backgrounds')
Widget buildBackgroundSlotTargetedUseCase(BuildContext context) {
  final target = context.knobs.object.segmented<FluxTarget>(
    label: 'Target slot',
    options: const [FluxTarget.header, FluxTarget.body, FluxTarget.footer, FluxTarget.media],
    labelBuilder: (t) => t.name,
  );

  return previewSurface(
    context,
    FluxCard(
      media: FluxMedia(
        height: 120,
        child: ColoredBox(color: Theme.of(context).colorScheme.primaryContainer),
      ),
      backgrounds: [
        FluxBackground.color(
          color: Theme.of(context).colorScheme.tertiaryContainer.withAlpha(200),
          targets: {target},
        ),
      ],
      header: const FluxSection.header(title: Text('Slot background'), padding: EdgeInsets.zero),
      body: const Text('Only the selected slot gets the background tint.'),
      footer: const FluxSection.footer(
        actions: [Chip(label: Text('Action'))],
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated,
    ),
  );
}
