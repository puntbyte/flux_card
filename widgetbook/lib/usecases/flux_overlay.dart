import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../shared/preview_surface.dart';

Alignment _alignment(BuildContext context) {
  return context.knobs.object.segmented<Alignment>(
    label: 'Alignment',
    options: const [Alignment.topLeft, Alignment.topRight, Alignment.bottomLeft, Alignment.bottomRight, Alignment.center],
    labelBuilder: (value) {
      if (value == Alignment.topLeft) return 'Top left';
      if (value == Alignment.topRight) return 'Top right';
      if (value == Alignment.bottomLeft) return 'Bottom left';
      if (value == Alignment.bottomRight) return 'Bottom right';
      return 'Center';
    },
  );
}

@widgetbook.UseCase(name: 'Badges', type: FluxOverlay, path: '[Flux Card]/Overlay')
Widget buildOverlayBadgesUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      media: const FluxMedia.fill(
        height: 260,
        child: ColoredBox(color: Color(0xFF1E293B)),
      ),
      overlay: FluxOverlay(
        alignment: _alignment(context),
        children: const [
          Chip(label: Text('SALE', style: TextStyle(fontSize: 10, color: Colors.white)), backgroundColor: Colors.red, side: BorderSide.none),
          Chip(label: Text('NEW', style: TextStyle(fontSize: 10, color: Colors.white)), backgroundColor: Colors.deepPurple, side: BorderSide.none),
        ],
      ),
      header: const FluxHeader(title: Text('Overlay badges')),
      content: const Text('Overlays are ideal for tags, status labels, and floating controls.'),
      theme: FluxCardThemeData.elevated,
    ),
  );
}

@widgetbook.UseCase(name: 'Rating chip', type: FluxOverlay, path: '[Flux Card]/Overlay')
Widget buildOverlayRatingUseCase(BuildContext context) {
  final rating = context.knobs.double.slider(label: 'Rating', min: 1, max: 5, divisions: 40, initialValue: 4.8);
  return previewSurface(
    context,
    FluxCard(
      media: const FluxMedia.cover(
        aspectRatio: 16 / 10,
        height: 260,
        child: ColoredBox(color: Color(0xFFCBD5E1)),
      ),
      overlay: FluxOverlay(
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('★ ${rating.toStringAsFixed(1)}', style: const TextStyle(fontSize: 12, color: Colors.white)),
          ),
        ],
      ),
      header: const FluxHeader(title: Text('Overlay rating')),
      content: const Text('Place ratings, metadata, and floating info on top of the media.'),
      theme: FluxCardThemeData.elevated,
    ),
  );
}
