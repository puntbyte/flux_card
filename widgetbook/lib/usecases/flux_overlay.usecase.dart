import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../shared/preview_surface.dart';

@widgetbook.UseCase(name: 'Interactive badges', type: FluxOverlay, path: '[Flux Card]/Overlays')
Widget buildOverlayInteractiveUseCase(BuildContext context) {
  final interactive = context.knobs.boolean(label: 'Interactive', initialValue: true);
  final tapped = ValueNotifier<String?>('');

  return previewSurface(
    context,
    Column(
      children: [
        FluxCard(
          media: FluxMedia(
            aspectRatio: 16 / 9,
            child: Ink.image(
              image: const CachedNetworkImageProvider(
                'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=1200',
              ),
              fit: BoxFit.cover,
            ),
          ),
          overlays: [
            FluxOverlay(
              targets: const {FluxTarget.media},
              alignment: Alignment.topLeft,
              interactive: interactive,
              children: [
                ActionChip(
                  label: const Text(
                    'Featured',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  backgroundColor: Colors.deepPurple,
                  side: BorderSide.none,
                  onPressed: () => tapped.value = 'Featured tapped!',
                ),
                ActionChip(
                  label: const Text(
                    'SALE 12%',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                  side: BorderSide.none,
                  onPressed: () => tapped.value = 'Sale tapped!',
                ),
              ],
            ),
          ],
          header: const FluxSection(
            title: Text('Interactive overlays'),
            subtitle: Text('Toggle the knob — chips are tappable when interactive=true.'),
            padding: EdgeInsets.zero,
          ),
          theme: FluxCardThemeData.elevated,
          onTap: () => tapped.value = 'Card tapped!',
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<String?>(
          valueListenable: tapped,
          builder: (_, msg, _) => Text(
            msg?.isEmpty == true ? 'Tap a chip or the card…' : msg ?? '',
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Slot targeting', type: FluxOverlay, path: '[Flux Card]/Overlays')
Widget buildOverlaySlotTargetingUseCase(BuildContext context) {
  final target = context.knobs.object.segmented<FluxTarget>(
    label: 'Target',
    options: const [FluxTarget.card, FluxTarget.media, FluxTarget.header, FluxTarget.footer],
    labelBuilder: (t) => t.name,
  );
  final alignment = context.knobs.object.segmented<Alignment>(
    label: 'Alignment',
    options: const [
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.bottomLeft,
      Alignment.bottomRight,
    ],
    labelBuilder: (a) {
      if (a == Alignment.topLeft) return 'topLeft';
      if (a == Alignment.topRight) return 'topRight';
      if (a == Alignment.bottomLeft) return 'bottomLeft';
      return 'bottomRight';
    },
  );

  return previewSurface(
    context,
    FluxCard(
      media: FluxMedia(
        aspectRatio: 16 / 9,
        child: Ink.image(
          image: const CachedNetworkImageProvider(
            'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=1200',
          ),
          fit: BoxFit.cover,
        ),
      ),
      overlays: [
        FluxOverlay(
          targets: {target},
          alignment: alignment,
          children: const [
            Chip(
              label: Text('★ 4.9', style: TextStyle(fontSize: 10, color: Colors.white)),
              backgroundColor: Colors.black87,
              side: BorderSide.none,
            ),
          ],
        ),
      ],
      header: const FluxSection(
        title: Text('Slot targeting'),
        subtitle: Text('Overlay is injected into the selected slot only.'),
        padding: EdgeInsets.zero,
      ),
      footer: const FluxSection(
        actions: [Chip(label: Text('Footer area'))],
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'zIndex ordering', type: FluxOverlay, path: '[Flux Card]/Overlays')
Widget buildOverlayZIndexUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      media: FluxMedia(height: 180, child: Container(color: const Color(0xFF0F172A))),
      overlays: [
        FluxOverlay(
          targets: const {FluxTarget.media},
          alignment: Alignment.center,
          zIndex: 0,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: Colors.blue.withAlpha(200),
              child: const Text(
                'zIndex 0 (bottom)',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ],
        ),
        FluxOverlay(
          targets: const {FluxTarget.media},
          alignment: Alignment.center,
          zIndex: 1,
          padding: const EdgeInsets.only(top: 48),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: Colors.purple.withAlpha(220),
              child: const Text(
                'zIndex 1 (top)',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ],
        ),
      ],
      header: const FluxSection(
        title: Text('zIndex ordering'),
        subtitle: Text('Higher zIndex renders on top within the same slot.'),
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated,
    ),
  );
}

@widgetbook.UseCase(name: 'Offset nudge', type: FluxOverlay, path: '[Flux Card]/Overlays')
Widget buildOverlayOffsetUseCase(BuildContext context) {
  final dx = context.knobs.double.slider(label: 'X offset', min: -32, max: 32, divisions: 16);
  final dy = context.knobs.double.slider(label: 'Y offset', min: -32, max: 32, divisions: 16);

  return previewSurface(
    context,
    FluxCard(
      media: FluxMedia(
        aspectRatio: 16 / 9,
        child: Ink.image(
          image: const CachedNetworkImageProvider(
            'https://fastly.picsum.photos/id/20/3670/2462.jpg?hmac=CmQ0ln-k5ZqkdtLvVO23LjVAEabZQx2wOaT4pyeG10I',
          ),
          fit: BoxFit.cover,
        ),
      ),
      overlays: [
        FluxOverlay(
          targets: const {FluxTarget.media},
          alignment: Alignment.topRight,
          offset: Offset(dx, dy),
          children: const [
            Chip(
              label: Text('4.9 ★', style: TextStyle(fontSize: 10, color: Colors.white)),
              backgroundColor: Colors.black87,
              side: BorderSide.none,
            ),
          ],
        ),
      ],
      header: const FluxSection(
        title: Text('Offset nudge'),
        subtitle: Text('Use offset to fine-tune badge placement.'),
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Breakout Overlays', type: FluxOverlay, path: '[Flux Card]/Overlays')
Widget buildOverlayBreakoutUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      // Setting Clip.none allows overlays to push beyond the card borders!
      clipBehavior: Clip.none,
      media: FluxMedia(
        aspectRatio: 16 / 9,
        // When using Clip.none on the card, you must provide a border radius
        // to the media if you want the image to match the card's top corners.
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Ink.image(
          image: const CachedNetworkImageProvider(
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
          ),
          fit: BoxFit.cover,
        ),
      ),
      overlays: [
        FluxOverlay(
          targets: const {FluxTarget.media},
          alignment: Alignment.topRight,
          // Push the badge completely outside the top-right corner
          offset: const Offset(24, -24),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.shade400,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: const Text('NEW', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ],
      header: const FluxSection(
        title: Text('Breakout Overlays'),
        subtitle: Text(
          'Set clipBehavior: Clip.none on the card to let badges break completely out of bounds.',
        ),
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated,
      onTap: () {},
    ),
  );
}
