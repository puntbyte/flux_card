import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../demo/demo_product.dart';
import '../shared/preview_surface.dart';

@widgetbook.UseCase(
  name: 'Commerce Hero',
  type: FluxCard,
  path: '[Flux Card]/Cards/Advanced',
)
Widget buildAdvancedCommerceHeroUseCase(BuildContext context) {
  final product = demoProducts.first;

  final themeName = context.knobs.list<String>(
    label: 'Theme preset',
    options: const ['standard', 'compact', 'elevated', 'outlined'],
    initialOption: 'elevated',
  );

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
    label: 'Media span',
    options: FluxMediaSpan.values,
    labelBuilder: (m) => m.name,
  );

  final wideSurface = context.knobs.boolean(
    label: 'Wide surface',
    initialValue: true,
  );
  final loading = context.knobs.boolean(label: 'Loading');
  final showDiscount = context.knobs.boolean(
    label: 'Show discount badge',
    initialValue: true,
  );
  final showWishlist = context.knobs.boolean(
    label: 'Show wishlist button',
    initialValue: true,
  );
  final showFooter = context.knobs.boolean(
    label: 'Show footer',
    initialValue: true,
  );
  final showSpecs = context.knobs.boolean(
    label: 'Show spec chips',
    initialValue: true,
  );
  final useLongTitle = context.knobs.boolean(label: 'Long title');
  final useNotch = context.knobs.boolean(label: 'Use notch');
  final useUnderlay = context.knobs.boolean(
    label: 'Use decorative underlay',
    initialValue: true,
  );

  final effectiveTheme = switch (themeName) {
    'standard' => FluxCardThemeData.standard,
    'compact' => FluxCardThemeData.compact,
    'outlined' => FluxCardThemeData.outlined,
    _ => FluxCardThemeData.elevated,
  }.copyWith(
    padding: const EdgeInsets.all(16),
    spacing: 14,
  );

  final title = useLongTitle
      ? '${product.name} Premium Limited Edition with Extended Comfort Build'
      : product.name;

  return previewSurface(
    context,
    FluxCard(
      layout: layout,
      mediaPosition: mediaPosition,
      mediaSpan: mediaSpan,
      loading: loading,
      theme: effectiveTheme,
      notch: useNotch
          ? FluxNotch(
        boundary: FluxSlotBoundary.afterHeader,
        notchRadius: 12,
        // side: BorderSide(
        //   color: Theme.of(context).colorScheme.outlineVariant,
        //   width: 1,
        // ),
      )
          : null,
      underlays: [
        if (useUnderlay)
          FluxUnderlay(
            targets: const {FluxTarget.card},
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.03),
                ],
              ),
            ),
          ),
      ],
      overlays: [
        if (showDiscount && product.hasDiscount)
          FluxOverlay(
            targets: const {FluxTarget.media},
            alignment: Alignment.topLeft,
            children: [
              Chip(
                label: Text('-${product.discountPercent.round()}%'),
              ),
            ],
          ),
        if (showWishlist)
          FluxOverlay(
            targets: const {FluxTarget.media},
            alignment: Alignment.topRight,
            children: const [
              CircleAvatar(
                radius: 18,
                child: Icon(Icons.favorite_border, size: 18),
              ),
            ],
          ),
      ],
      media: FluxMedia(
        aspectRatio: layout == FluxLayoutMode.row ? null : 4 / 3,
        width: layout == FluxLayoutMode.row ? 180 : null,
        child: Ink.image(
          image: CachedNetworkImageProvider(product.image),
          fit: BoxFit.cover,
        ),
      ),
      header: FluxSection(
        leading: CircleAvatar(
          radius: 16,
          child: Text(product.brand.characters.first),
        ),
        title: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${product.brand} • ${product.rating.toStringAsFixed(1)} ★ • ${product.reviewCount} reviews',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const [
          Icon(Icons.more_horiz),
        ],
        padding: EdgeInsets.zero,
      ),
      body: FluxContent.column(
        spacing: 12,
        padding: EdgeInsets.zero,
        children: [
          Text(
            'A premium showcase card combining layered media, structured content, strong CTA hierarchy, and flexible layout controls.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (showSpecs)
            FluxContent.wrap(
              spacing: 8,
              runSpacing: 8,
              padding: EdgeInsets.zero,
              children: const [
                Chip(label: Text('Free shipping')),
                Chip(label: Text('Best seller')),
                Chip(label: Text('2-year warranty')),
              ],
            ),
        ],
      ),
      footer: showFooter
          ? FluxSection.footer(
        padding: EdgeInsets.zero,
        actions: [
          Text(
            product.priceLabel,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (product.hasDiscount)
            Text(
              product.formerPriceLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                decoration: TextDecoration.lineThrough,
              ),
            ),
          const Spacer(),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Buy now'),
          ),
        ],
      )
          : null,
      onTap: () {},
    ),
    maxWidth: wideSurface ? 900 : 460,
  );
}