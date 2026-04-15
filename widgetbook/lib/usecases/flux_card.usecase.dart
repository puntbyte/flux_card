import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../demo/demo_destination.dart';
import '../demo/demo_post.dart';
import '../demo/demo_product.dart';
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
  final mediaSpan = context.knobs.object.segmented<FluxMediaSpan>(
    label: 'Media span (Row only)',
    options: FluxMediaSpan.values,
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
      mediaSpan: mediaSpan,
      loading: loading,
      media: FluxMedia(
        aspectRatio: 16 / 9,
        child: Ink.image(image: CachedNetworkImageProvider(product.image), fit: BoxFit.cover),
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
      body: Text(product.tags.join(' • ')),
      footer: showFooter
          ? FluxSection(
              actions: [
                Text(
                  product.priceLabel,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
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

@widgetbook.UseCase(name: 'Row Spanning', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildRowSpanningUseCase(BuildContext context) {
  final mediaSpan = context.knobs.object.segmented<FluxMediaSpan>(
    label: 'Media span',
    options: FluxMediaSpan.values,
    labelBuilder: (m) => m.name,
  );

  final mediaPosition = context.knobs.object.segmented<FluxMediaPosition>(
    label: 'Media position',
    options: FluxMediaPosition.values,
    labelBuilder: (m) => m.name,
  );

  final post = demoPosts[1];

  return previewSurface(
    context,
    FluxCard(
      layout: FluxLayoutMode.row,
      mediaPosition: mediaPosition,
      mediaSpan: mediaSpan,

      media: FluxMedia.image(
        padding: EdgeInsets.all(8),
        aspectRatio: 1.0,
        image: CachedNetworkImageProvider(post.image),
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        fit: BoxFit.cover,
      ),

      // Use the new semantic .header!
      header: FluxSection.header(
        title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(post.category),
        padding: EdgeInsets.zero,
      ),

      body: const Text(
        'Change the Media Span knob to see the image wrap specifically next to the header, body, '
        'or footer, while the other slots seamlessly expand to full width.',
        style: TextStyle(fontSize: 13),
      ),

      // Use the new semantic .footer with spaceBetween!
      footer: FluxSection.footer(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          Text(
            '${post.author} • ${post.readTime}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          // Spacer() removed! spaceBetween handles the layout now.
          IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border, size: 20)),
        ],
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated.copyWith(flexMedia: 1, flexContent: 2),
      onTap: () {},
    ),
    maxWidth: 500,
  );
}

@widgetbook.UseCase(name: 'Ripple over media', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildRippleOverMediaUseCase(BuildContext context) {
  return previewSurface(
    context,
    Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Tap the card — the ripple sweeps over the image and all slots.',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
        FluxCard(
          media: FluxMedia(
            aspectRatio: 16 / 9,
            child: Ink.image(
              image: CachedNetworkImageProvider(demoDestinations.first.image),
              fit: BoxFit.cover,
            ),
          ),
          header: const FluxSection(
            title: Text('Tap anywhere'),
            subtitle: Text('Ink.image paints on the Material ink layer — ripple covers media too.'),
            padding: EdgeInsets.zero,
          ),
          footer: FluxSection(
            actions: [ElevatedButton(onPressed: () {}, child: const Text('Button still works'))],
            padding: EdgeInsets.zero,
          ),
          theme: FluxCardThemeData.elevated,
          onTap: () {},
        ),
      ],
    ),
    maxWidth: 420,
  );
}

@widgetbook.UseCase(name: 'Surface decoration', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildDecorationUseCase(BuildContext context) {
  final useGradient = context.knobs.boolean(label: 'Gradient', initialValue: true);
  final useBorder = context.knobs.boolean(label: 'Border');

  return previewSurface(
    context,
    FluxCard(
      media: FluxMedia(
        aspectRatio: 16 / 9,
        child: Ink.image(
          image: CachedNetworkImageProvider(demoPosts.first.image),
          fit: BoxFit.cover,
        ),
      ),
      decoration: useGradient
          ? BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: useBorder
                  ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
                  : null,
            )
          : useBorder
          ? BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1.5),
            )
          : null,
      header: const FluxSection(
        title: Text('Surface decoration'),
        subtitle: Text('BoxDecoration on the card surface, under content.'),
        padding: EdgeInsets.zero,
      ),
      body: const Text('Combine with transparent cardColor for full gradient control.'),
      theme: FluxCardThemeData.elevated.copyWith(
        cardColor: useGradient ? Colors.transparent : null,
      ),
      onTap: () {},
    ),
    maxWidth: 420,
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
        child: Ink.image(image: CachedNetworkImageProvider(product.image), fit: BoxFit.cover),
      ),
      header: FluxSection(
        title: Text(product.name),
        subtitle: Text(product.brand),
        padding: EdgeInsets.zero,
      ),
      body: const Text('Column layout is ideal for editorial and product cards.'),
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
    maxWidth: 360,
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
        //aspectRatio: 1,
        child: Ink.image(image: CachedNetworkImageProvider(destination.image), fit: BoxFit.cover),
      ),

      header: FluxSection(
        title: Text(destination.title),
        subtitle: Text(destination.location),
      ),

      body: Text(destination.description, maxLines: 2, overflow: TextOverflow.ellipsis),
      footer: FluxSection(
        actions: [
          Text(destination.priceLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),

      theme: FluxCardThemeData.elevated.copyWith(flexMedia: flexMedia, flexContent: flexContent),
      onTap: () {},
    ),
    //maxWidth: 500,
  );
}

@widgetbook.UseCase(name: 'Inline', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildInlineLayoutUseCase(BuildContext context) {
  final mediaPosition = context.knobs.object.segmented<FluxMediaPosition>(
    label: 'Media position',
    options: FluxMediaPosition.values,
    labelBuilder: (m) => m.name,
  );

  final post = demoPosts.first;
  return previewSurface(
    context,
    FluxCard(
      layout: FluxLayoutMode.inline,
      mediaPosition: mediaPosition,
      media: FluxMedia(
        aspectRatio: 16 / 9,
        child: Ink.image(image: CachedNetworkImageProvider(post.image), fit: BoxFit.cover),
      ),
      header: FluxSection(
        title: Text(post.title),
        subtitle: Text('${post.author} · ${post.category}'),
        padding: EdgeInsets.zero,
      ),
      body: const Text(
        'inline places media inside the content column — between header and body '
        'when position=start, or between body and footer when position=end.',
      ),
      footer: FluxSection(
        actions: [TextButton(onPressed: () {}, child: const Text('Read more'))],
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
        child: Ink.image(image: CachedNetworkImageProvider(post.image), fit: BoxFit.cover),
      ),
      header: FluxSection(
        title: Text(post.title),
        subtitle: Text('${post.author} • ${post.category}'),
        padding: EdgeInsets.zero,
      ),
      body: const Text('Resize the viewport addon to trigger the layout switch.'),
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

@widgetbook.UseCase(name: 'Hero Animation', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildHeroAnimationUseCase(BuildContext context) {
  return previewSurface(
    context,
    Builder(
      builder: (innerContext) => FluxCard(
        // Set to Clip.none to ensure the Hero doesn't get abruptly cut off during the flight.
        clipBehavior: Clip.none,
        media: Hero(
          tag: 'hero-product-image',
          child: FluxMedia.image(
            aspectRatio: 16 / 9,
            image: CachedNetworkImageProvider(
              'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
            ),
            fit: BoxFit.cover,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),
        header: const FluxSection(
          title: Text('Hero Animation Ready'),
          subtitle: Text('Tap to see the flight transition.'),
          padding: EdgeInsets.zero,
        ),
        theme: FluxCardThemeData.elevated,
        onTap: () {
          // Push a detail page to demonstrate the Hero transition
          Navigator.of(innerContext).push(
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Detail Page')),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Hero(
                      tag: 'hero-product-image',
                      child: Ink.image(
                        image: CachedNetworkImageProvider(
                          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
                        ),
                        fit: BoxFit.cover,
                        height: 300,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Because FluxMedia delegates the clipping behavior, '
                        'Hero widgets placed inside it animate perfectly across routes '
                        'without getting prematurely masked by layout bounds.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
    maxWidth: 320,
  );
}
