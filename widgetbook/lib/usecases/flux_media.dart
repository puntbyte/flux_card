import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../shared/preview_surface.dart';

Widget _mediaShell(BuildContext context, Widget child, {String? label}) =>
    previewSurface(
      context,
      FluxCard(
        media: child,
        header: FluxSection(
          title: Text(label ?? 'FluxMedia'),
          subtitle: const Text('Layout-only container — fit belongs on the child.'),
          padding: EdgeInsets.zero,
        ),
        theme: FluxCardThemeData.elevated,
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
      child: Image.network(
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=1200',
        fit: BoxFit.cover,
      ),
    ),
    label: 'Aspect ratio: ${ratio.toStringAsFixed(2)}',
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
        child: Image.network(
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
          fit: BoxFit.cover,
        ),
      ),
      header: const FluxSection(
        title: Text('Fixed-size media'),
        subtitle: Text('Useful for thumbnails in row layout.'),
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated,
    ),
    maxWidth: 420,
  );
}

@widgetbook.UseCase(name: 'Rounded corners', type: FluxMedia, path: '[Flux Card]/Media')
Widget buildMediaRoundedUseCase(BuildContext context) {
  final radius = context.knobs.double.slider(
    label: 'Border radius',
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
      child: Image.network(
        'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=1200',
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
