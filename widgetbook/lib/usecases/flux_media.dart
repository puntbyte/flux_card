import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../demo/demo_content.dart';
import '../shared/preview_surface.dart';

class _MediaShell extends StatelessWidget {
  final Widget child;

  const _MediaShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) => PreviewSurface(
    maxWidth: 360,
    child: FluxCard(
      media: child,
      header: const FluxHeader(title: Text('FluxMedia')),
      content: const Text('A layout wrapper for pluggable widgets.'),
      theme: FluxCardThemeData.elevated,
    ),
  );
}

double _height(BuildContext context, {double? value}) => context.knobs.double.slider(
  label: 'Height',
  min: 120,
  max: 260,
  divisions: 28,
  initialValue: value ?? 200,
);

@widgetbook.UseCase(name: 'Cover', type: FluxMedia, path: '[Flux Card]/Media')
Widget buildMediaCoverUseCase(BuildContext context) {
  return _MediaShell(
    child: FluxMedia.cover(
      height: _height(context),
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFFEC4899)]),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: const FlutterLogo(size: 84),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Contain', type: FluxMedia, path: '[Flux Card]/Media')
Widget buildMediaContainUseCase(BuildContext context) {
  final size = context.knobs.double.slider(
    label: 'Size',
    min: 72,
    max: 160,
    divisions: 22,
    initialValue: 120,
  );
  return _MediaShell(
    child: FluxMedia.contain(
      width: double.infinity,
      height: 180,
      child: Icon(Icons.widgets_outlined, size: size),
    ),
  );
}

@widgetbook.UseCase(name: 'Fill', type: FluxMedia, path: '[Flux Card]/Media')
Widget buildMediaFillUseCase(BuildContext context) {
  return _MediaShell(
    child: FluxMedia.fill(
      height: 180,
      child: Container(
        color: const Color(0xFF0EA5E9),
        alignment: Alignment.center,
        child: const Text(
          'FILL',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Center', type: FluxMedia, path: '[Flux Card]/Media')
Widget buildMediaCenterUseCase(BuildContext context) => _MediaShell(
  child: FluxMedia.center(
    height: _height(context, value: 180),
    child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(999)),
      child: const Icon(Icons.play_circle_fill_outlined, size: 60),
    ),
  ),
);

@widgetbook.UseCase(name: 'Product media', type: FluxMedia, path: '[Flux Card]/Media')
Widget buildMediaProductUseCase(BuildContext context) {
  final product = demoProducts.first;
  return _MediaShell(
    child: FluxMedia.cover(
      aspectRatio: 1.4,
      height: _height(context, value: 180),
      child: CachedNetworkImage(imageUrl: product.image, fit: BoxFit.cover),
    ),
  );
}
