import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../demo/demo_content.dart';
import '../shared/preview_surface.dart';

@widgetbook.UseCase(name: 'Product card', type: FluxCard, path: '[Flux Card]/Compositions')
Widget buildProductCardUseCase(BuildContext context) {
  final product = demoProducts.first;
  final inStock = context.knobs.boolean(label: 'In stock', initialValue: true);
  final featured = context.knobs.boolean(label: 'Featured', initialValue: true);
  final showDiscount = context.knobs.boolean(label: 'Show discount', initialValue: true);

  return previewSurface(
    context,
    FluxCard(
      layout: const FluxCardLayout.column(),
      media: FluxMedia.cover(
        aspectRatio: 1,
        height: 240,
        child: Image.network(product.image, fit: BoxFit.cover),
      ),
      overlay: FluxOverlay(
        alignment: Alignment.topLeft,
        children: [
          if (featured)
            const Chip(
              label: Text('Featured', style: TextStyle(fontSize: 10, color: Colors.white)),
              backgroundColor: Colors.deepPurple,
              side: BorderSide.none,
            ),
          if (showDiscount)
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
      header: FluxHeader(
        title: Text(product.name),
        subtitle: Text('${product.brand} • ${product.rating.toStringAsFixed(1)} ★'),
        trailing: [Text('${product.reviewCount} reviews', style: const TextStyle(fontSize: 11))],
      ),
      content: Text(product.tags.join(' • '), maxLines: 2, overflow: TextOverflow.ellipsis),
      footer: FluxFooter(
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
            onPressed: inStock ? () {} : null,
            icon: Icon(
              inStock ? Icons.add_shopping_cart_outlined : Icons.do_not_disturb_on_outlined,
              size: 18,
            ),
          ),
        ],
      ),
      theme: FluxCardThemeData.elevated,
    ),
  );
}

@widgetbook.UseCase(name: 'Travel card', type: FluxCard, path: '[Flux Card]/Compositions')
Widget buildTravelCardUseCase(BuildContext context) {
  final destination = demoDestinations[1];
  final layout = context.knobs.object.segmented<FluxLayoutMode>(
    label: 'Layout',
    options: const [FluxLayoutMode.column, FluxLayoutMode.row, FluxLayoutMode.stack],
    labelBuilder: (mode) => mode.name,
  );

  final resolvedLayout = FluxCardLayout(mode: layout);

  return previewSurface(
    context,
    FluxCard(
      layout: resolvedLayout,
      media: FluxMedia.cover(
        aspectRatio: resolvedLayout.mode == FluxLayoutMode.row ? 1.2 : 16 / 10,
        height: 280,
        child: Image.network(destination.image, fit: BoxFit.cover),
      ),
      overlay: resolvedLayout.mode == FluxLayoutMode.stack
          ? FluxOverlay(
              alignment: Alignment.topRight,
              children: const [
                Chip(
                  label: Text('Travel', style: TextStyle(fontSize: 10, color: Colors.white)),
                  backgroundColor: Colors.black87,
                  side: BorderSide.none,
                ),
              ],
            )
          : null,
      header: FluxHeader(
        title: Text(destination.title),
        subtitle: Text('${destination.location} • City escape'),
      ),
      content: Text(destination.description),
      footer: FluxFooter(
        actions: [
          Text(
            destination.priceLabel,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          Text('${destination.rating.toStringAsFixed(1)} ★'),
          ElevatedButton(onPressed: () {}, child: const Text('Reserve')),
        ],
      ),
      theme: FluxCardThemeData.elevated,
    ),
  );
}

@widgetbook.UseCase(name: 'Blog card', type: FluxCard, path: '[Flux Card]/Compositions')
Widget buildBlogCardUseCase(BuildContext context) {
  final post = demoPosts.first;
  final theme = context.knobs.object.segmented<FluxCardThemeData>(
    label: 'Theme',
    options: const [
      FluxCardThemeData.standard,
      FluxCardThemeData.compact,
      FluxCardThemeData.elevated,
    ],
    labelBuilder: (value) => value == FluxCardThemeData.compact
        ? 'Compact'
        : value == FluxCardThemeData.elevated
        ? 'Elevated'
        : 'Standard',
  );

  return previewSurface(
    context,
    FluxCardBuilder()
        .layout(const FluxCardLayout.responsive())
        .background(
          const FluxBackground.gradient(
            gradient: LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]),
          ),
        )
        .media(
          FluxMedia.cover(
            aspectRatio: 16 / 9,
            height: 220,
            child: Image.network(post.image, fit: BoxFit.cover),
          ),
        )
        .overlay(
          const FluxOverlay(
            alignment: Alignment.topLeft,
            children: [
              Chip(
                label: Text('Editorial', style: TextStyle(fontSize: 10, color: Colors.white)),
                backgroundColor: Colors.deepPurple,
                side: BorderSide.none,
              ),
            ],
          ),
        )
        .header(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(
            post.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${post.category} • ${post.publishedLabel}'),
        )
        .content(
          const Text(
            'Explore how modern layout engines are changing the way we think about cross-platform UI development.',
          ),
        )
        .footer(
          actions: [
            TextButton(onPressed: () {}, child: const Text('READ STORY')),
            IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
          ],
        )
        .theme(theme)
        .build(),
  );
}
