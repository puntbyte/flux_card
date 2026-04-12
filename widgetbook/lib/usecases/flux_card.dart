import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../demo/demo_content.dart';
import '../shared/preview_surface.dart';

@widgetbook.UseCase(name: 'Interactive', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildInteractiveCardUseCase(BuildContext context) {
  final layout = context.knobs.object.segmented<FluxLayoutMode>(
    label: 'Layout',
    options: FluxLayoutMode.values,
    labelBuilder: (m) => m.name,
  );
  final mediaPosition = context.knobs.object.segmented<FluxMediaPosition>(
    label: 'Media position',
    options: FluxMediaPosition.values,
    labelBuilder: (m) => m.name,
  );
  final useWideSurface = context.knobs.boolean(label: 'Wide surface');
  final showOverlay = context.knobs.boolean(label: 'Show overlay', initialValue: true);
  final showFooter = context.knobs.boolean(label: 'Show footer', initialValue: true);
  final loading = context.knobs.boolean(label: 'Loading');

  final product = demoProducts.first;

  return previewSurface(
    context,
    FluxCard(
      layout: layout,
      mediaPosition: mediaPosition,
      loading: loading,
      media: FluxMedia(
        aspectRatio: 16 / 9,
        child: CachedNetworkImage(imageUrl: product.image, fit: BoxFit.cover),
      ),
      overlays: [
        if (showOverlay && product.hasDiscount)
          FluxOverlay(
            targets: const {FluxTarget.media},
            alignment: Alignment.topLeft,
            children: [
              Chip(
                label: Text(
                  'SALE ${product.discountPercent.round()}%',
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
                backgroundColor: Colors.red,
                side: BorderSide.none,
              ),
            ],
          ),
      ],
      header: FluxSection(
        title: Text(product.name),
        subtitle: Text('${product.brand} • ${product.rating.toStringAsFixed(1)} ★'),
        trailing: [Text('${product.reviewCount} reviews', style: const TextStyle(fontSize: 11))],
        padding: EdgeInsets.zero,
      ),
      body: Text(product.tags.join(' • '), maxLines: 2, overflow: TextOverflow.ellipsis),
      footer: showFooter
          ? FluxSection(
              actions: [
                Text(
                  product.priceLabel,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                Text(
                  product.formerPriceLabel,
                  style: const TextStyle(decoration: TextDecoration.lineThrough),
                ),
                IconButton(
                  onPressed: product.inStock ? () {} : null,
                  icon: const Icon(Icons.add_shopping_cart_outlined, size: 18),
                ),
              ],
              padding: EdgeInsets.zero,
            )
          : null,
      theme: FluxCardThemeData.elevated,
      onTap: () {},
    ),
    maxWidth: useWideSurface ? 920 : 420,
  );
}

@widgetbook.UseCase(name: 'Column', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildColumnLayoutUseCase(BuildContext context) {
  final product = demoProducts[1];
  return previewSurface(
    context,
    FluxCard(
      layout: FluxLayoutMode.column,
      media: FluxMedia(
        aspectRatio: 1,
        child: CachedNetworkImage(imageUrl: product.image, fit: BoxFit.cover),
      ),
      header: FluxSection(
        title: Text(product.name),
        subtitle: Text(product.brand),
        padding: EdgeInsets.zero,
      ),
      body: const Text('Column layout works well for focused, editorial-style cards.'),
      footer: FluxSection(
        actions: [
          Text(product.priceLabel, style: const TextStyle(fontWeight: FontWeight.w900)),
          ElevatedButton(onPressed: () {}, child: const Text('Add')),
        ],
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated,
      onTap: () {},
    ),
    //maxWidth: 360,
  );
}

@widgetbook.UseCase(name: 'Row', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildRowLayoutUseCase(BuildContext context) {
  final flexMedia = context.knobs.double
      .slider(label: 'Media flex', min: 1, max: 5, divisions: 4, initialValue: 2)
      .round();
  final flexContent = context.knobs.double
      .slider(label: 'Content flex', min: 1, max: 5, divisions: 4, initialValue: 3)
      .round();

  final destination = demoDestinations.first;
  return previewSurface(
    context,
    FluxCard(
      layout: FluxLayoutMode.row,
      media: FluxMedia(
        aspectRatio: 0.8,
        child: CachedNetworkImage(imageUrl: destination.image, fit: BoxFit.cover),
      ),
      header: FluxSection(
        title: Text(destination.title),
        subtitle: Text(destination.location),
        padding: EdgeInsets.zero,
      ),
      body: Text(destination.description, maxLines: 2, overflow: TextOverflow.ellipsis),
      footer: FluxSection(
        actions: [
          Text(destination.priceLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated,
      // theme: FluxCardThemeData.elevated.copyWith(
      //   flexMedia: flexMedia,
      //   flexContent: flexContent,
      // ),
      onTap: () {},
    ),
    //maxWidth: 480,
  );
}

@widgetbook.UseCase(name: 'InColumn', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildInColumnLayoutUseCase(BuildContext context) {
  final mediaPosition = context.knobs.object.segmented<FluxMediaPosition>(
    label: 'Media position',
    options: FluxMediaPosition.values,
    labelBuilder: (m) => m.name,
  );

  final destination = demoDestinations.first;
  return previewSurface(
    context,
    FluxCard(
      layout: FluxLayoutMode.inColumn,
      mediaPosition: mediaPosition,
      media: FluxMedia(
        aspectRatio: 16 / 9,
        child: CachedNetworkImage(imageUrl: destination.image, fit: BoxFit.cover),
      ),
      header: FluxSection(
        title: Text(destination.title),
        subtitle: Text(destination.location),
        padding: EdgeInsets.zero,
      ),
      body: Text(destination.description),
      footer: FluxSection(
        actions: [
          Text(destination.priceLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
          ElevatedButton(onPressed: () {}, child: const Text('Book')),
        ],
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated,
      onTap: () {},
    ),
    maxWidth: 400,
  );
}

@widgetbook.UseCase(name: 'Responsive', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildResponsiveLayoutUseCase(BuildContext context) {
  final breakpoint = context.knobs.double.slider(
    label: 'Breakpoint (px)',
    min: 300,
    max: 800,
    divisions: 25,
    initialValue: 540,
  );

  final post = demoPosts.first;
  return previewSurface(
    context,
    FluxCard(
      layout: FluxLayoutMode.responsive,
      media: FluxMedia(
        aspectRatio: 16 / 9,
        child: CachedNetworkImage(imageUrl: post.image, fit: BoxFit.cover),
      ),
      header: FluxSection(
        title: Text(post.title),
        subtitle: Text('${post.author} • ${post.category}'),
        padding: EdgeInsets.zero,
      ),
      body: const Text('Resize the viewport addon to see the layout switch.'),
      footer: FluxSection(
        actions: [TextButton(onPressed: () {}, child: const Text('Read more'))],
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated.copyWith(responsiveBreakpoint: breakpoint),
      onTap: () {},
    ),
    maxWidth: 720,
  );
}

@widgetbook.UseCase(name: 'Empty shell', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildEmptyShellUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      backgrounds: const [FluxBackground.color(color: Color(0xFFE2E8F0))],
      theme: FluxCardThemeData.standard,
      height: 180,
    ),
    maxWidth: 360,
  );
}
