import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../demo/demo_destination.dart';
import '../demo/demo_product.dart';
import '../shared/preview_surface.dart';

Widget _mediaShell(BuildContext context, Widget child, {String? label}) => previewSurface(
  context,
  FluxCard(
    media: child,
    header: FluxSection(
      title: Text(label ?? 'FluxMedia'),
      subtitle: const Text('Layout-only container — fit belongs on the child.'),
      padding: EdgeInsets.zero,
    ),
    theme: FluxCardThemeData.elevated,
    onTap: () {},
  ),
  maxWidth: 360,
);

@widgetbook.UseCase(name: 'Aspect ratio', type: FluxMedia, path: '[Flux Card]/Media')
Widget buildMediaAspectRatioUseCase(BuildContext context) {
  final ratio = context.knobs.object.segmented<double>(
    label: 'Aspect ratio',
    options: const [16 / 9, 4 / 3, 1.0, 3 / 4],
    labelBuilder: (v) {
      if (v == 16 / 9) return '16:9';
      if (v == 4 / 3) return '4:3';
      if (v == 1.0) return '1:1';
      return '3:4';
    },
  );
  return _mediaShell(
    context,
    FluxMedia(
      aspectRatio: ratio,
      child: Ink.image(image: NetworkImage(demoProducts.first.image), fit: BoxFit.cover),
    ),
    label: 'Aspect ratio ${ratio.toStringAsFixed(2)}',
  );
}

@widgetbook.UseCase(name: 'Row — BoxFit fills slot', type: FluxMedia, path: '[Flux Card]/Media')
Widget buildMediaRowBoxFitUseCase(BuildContext context) {
  final fit = context.knobs.object.segmented<BoxFit>(
    label: 'BoxFit',
    options: const [BoxFit.cover, BoxFit.contain, BoxFit.fill, BoxFit.fitHeight],
    labelBuilder: (f) => f.name,
  );

  return previewSurface(
    context,
    FluxCard(
      layout: FluxLayoutMode.row,
      // No aspectRatio or height — child fills the row slot height.
      // BoxFit is applied to the full slot area, not a fixed-size sub-region.
      media: FluxMedia(
        child: Ink.image(image: CachedNetworkImageProvider(demoProducts[1].image), fit: fit),
      ),
      header: const FluxSection(
        title: Text('Row — no explicit size'),
        subtitle: Text('FluxMedia fills row slot height. BoxFit is respected.'),
        padding: EdgeInsets.zero,
      ),
      body: const Text('Switch the BoxFit knob to see cover, contain, fill, and fitHeight.'),
      theme: FluxCardThemeData.elevated,
      onTap: () {},
    ),
    maxWidth: 500,
  );
}

@widgetbook.UseCase(name: 'Fixed size', type: FluxMedia, path: '[Flux Card]/Media')
Widget buildMediaFixedSizeUseCase(BuildContext context) {
  final size = context.knobs.double.slider(
    label: 'Size (px)',
    min: 60,
    max: 200,
    divisions: 28,
    initialValue: 100,
  );
  return previewSurface(
    context,
    FluxCard(
      layout: FluxLayoutMode.row,
      media: FluxMedia(
        width: size,
        height: size,
        borderRadius: BorderRadius.circular(size / 4),
        child: Ink.image(
          image: CachedNetworkImageProvider(demoProducts.first.image),
          fit: BoxFit.cover,
        ),
      ),
      header: const FluxSection(
        title: Text('Fixed-size thumbnail'),
        subtitle: Text('Both width and height set — card drives the row height.'),
        padding: EdgeInsets.zero,
      ),
      body: const Text('borderRadius clips the thumbnail; tap to see the ripple over the image.'),
      theme: FluxCardThemeData.elevated,
      onTap: () {},
    ),
    maxWidth: 420,
  );
}

@widgetbook.UseCase(name: 'Rounded corners', type: FluxMedia, path: '[Flux Card]/Media')
Widget buildMediaRoundedUseCase(BuildContext context) {
  final radius = context.knobs.double.slider(
    label: 'Radius',
    min: 0,
    max: 40,
    divisions: 20,
    initialValue: 16,
  );
  return _mediaShell(
    context,
    FluxMedia(
      aspectRatio: 16 / 9,
      borderRadius: BorderRadius.circular(radius),
      child: Ink.image(
        image: CachedNetworkImageProvider(demoDestinations.first.image),
        fit: BoxFit.cover,
      ),
    ),
    label: 'borderRadius: ${radius.toStringAsFixed(0)}',
  );
}

@widgetbook.UseCase(name: 'Custom widget', type: FluxMedia, path: '[Flux Card]/Media')
Widget buildMediaCustomWidgetUseCase(BuildContext context) {
  return _mediaShell(
    context,
    FluxMedia(
      height: 160,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFFEC4899)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: const FlutterLogo(size: 72),
      ),
    ),
    label: 'Any widget works',
  );
}

@widgetbook.UseCase(name: 'Gradients & Scrims', type: FluxMedia, path: '[Flux Card]/Media')
Widget buildMediaGradientsUseCase(BuildContext context) {
  final useBackground = context.knobs.boolean(label: 'Background Gradient', initialValue: false);
  final useForeground = context.knobs.boolean(label: 'Foreground Scrim', initialValue: true);

  return previewSurface(
    context,
    FluxCard(
      media: FluxMedia(
        aspectRatio: 16 / 9,
        gradient: useBackground
            ? const LinearGradient(
                colors: [Colors.purple, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        foregroundGradient: useForeground
            ? const LinearGradient(
                colors: [Colors.transparent, Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.4, 1.0],
              )
            : null,
        // Using a semi-transparent image to show the background gradient if active
        child: Ink.image(
          image: const NetworkImage(
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
          ),
          fit: BoxFit.cover,
          colorFilter: useBackground
              ? ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.dstIn)
              : null,
        ),
      ),
      overlays: [
        if (useForeground)
          const FluxOverlay(
            targets: {FluxTarget.media},
            alignment: Alignment.bottomLeft,
            children: [
              Text(
                'Gradient Scrims',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
      ],
      header: const FluxSection(
        title: Text('Media Gradients'),
        subtitle: Text('Add gradients directly to FluxMedia without breaking the ripple effect.'),
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated,
      onTap: () {},
    ),
    maxWidth: 380,
  );
}
