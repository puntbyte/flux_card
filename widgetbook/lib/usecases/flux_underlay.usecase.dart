import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../demo/demo_destination.dart';
import '../shared/preview_surface.dart';

@widgetbook.UseCase(
  name: 'Color & Decoration',
  type: FluxUnderlay,
  path: '[Flux Card]/Backgrounds',
)
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
      // Unified decoration constructor!
      underlays: [FluxUnderlay(decoration: BoxDecoration(color: color))],
      header: const FluxSection.header(title: Text('Decoration'), padding: EdgeInsets.zero),
      body: const Text('FluxTarget.card (default) paints the whole surface.'),
      theme: FluxCardThemeData.elevated,
      height: 160,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multi-Target Image',
  type: FluxUnderlay,
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
      underlays: [
        FluxUnderlay(
          targets: targets.isEmpty ? {FluxTarget.card} : targets,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(demoDestinations[0].image), // Santorini image
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.darken),
            ),
          ),
        ),
      ],
      foregroundColor: Colors.white,
      header: const FluxSection.header(
        title: Text('Image background'),
        subtitle: Text('Contiguous slots combine seamlessly!'),
        padding: EdgeInsets.all(20),
      ),
      body: const FluxContent(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Because the targets include multiple contiguous slots, FluxCard automatically wraps '
          'them in a single layout block.',
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
      theme: FluxCardThemeData.elevated.copyWith(padding: EdgeInsets.zero),
    ),
    maxWidth: 380,
  );
}

@widgetbook.UseCase(
  name: 'Extruding & Overlapping',
  type: FluxUnderlay,
  path: '[Flux Card]/Backgrounds',
)
Widget buildBackgroundOverlappingUseCase(BuildContext context) {
  final extrude = context.knobs.double.slider(
    label: 'Extrude (Negative Margin)',
    min: 0,
    max: 24,
    initialValue: 12,
  );
  final offsetY = context.knobs.double.slider(
    label: 'Y Offset',
    min: -20,
    max: 20,
    initialValue: 6,
  );

  return previewSurface(
    context,
    FluxCard(
      clipBehavior: Clip.none,
      // Allow breaking out of the main card shape if necessary
      header: const FluxSection.header(
        title: Text('Layered Effects'),
        subtitle: Text('Extruding the body background'),
        padding: EdgeInsets.zero,
      ),
      body: const Text(
        'By using a negative margin, the body background expands outwards, '
        'creating a beautiful overlapping effect with the adjacent header and footer slots.',
      ),
      footer: FluxSection.footer(
        actionsAlignment: MainAxisAlignment.end,
        actions: [OutlinedButton(onPressed: () {}, child: const Text('Awesome'))],
        padding: EdgeInsets.zero,
      ),
      underlays: [
        FluxUnderlay(
          targets: const {FluxTarget.body},
          margin: EdgeInsets.all(-extrude), // Negative margin pushes the bounds outward
          offset: Offset(0, offsetY), // Shifts the entire background block
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
          ),
        ),
      ],
      theme: FluxCardThemeData.elevated,
    ),
    maxWidth: 380,
  );
}

@widgetbook.UseCase(name: 'zIndex ordering', type: FluxUnderlay, path: '[Flux Card]/Backgrounds')
Widget buildBackgroundZIndexUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      header: const FluxSection.header(
        title: Text('Background zIndex'),
        subtitle: Text('Higher zIndex paints on top within the same slot.'),
        padding: EdgeInsets.zero,
      ),
      body: const SizedBox(height: 140), // Provide some empty space for the backgrounds
      underlays:[
        // Background 1 (Base layer, zIndex 0)
        FluxUnderlay(
          targets: const {FluxTarget.body},
          zIndex: 0,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.shade300, width: 2),
          ),
        ),
        // Background 2 (Top layer, zIndex 1)
        FluxUnderlay(
          targets: const {FluxTarget.body},
          zIndex: 1, // Will paint ON TOP of the blue background
          margin: const EdgeInsets.only(top: 40, left: 40),
          decoration: BoxDecoration(
            color: Colors.purple.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.purple.shade400, width: 2),
            boxShadow: const[
              BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(-4, -4))
            ],
          ),
        ),
      ],
      theme: FluxCardThemeData.elevated,
    ),
    maxWidth: 380,
  );
}
