import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../demo/demo_product.dart';
import '../shared/preview_surface.dart';

@widgetbook.UseCase(name: 'Commerce Hero', type: FluxCard, path: '[Flux Card]/Cards/Advanced')
Widget buildAdvancedCommerceHeroUseCase(BuildContext context) {
  final product = demoProducts.first;

  final themePreset = context.knobs.list<String>(
    label: 'Theme preset',
    options: const ['standard', 'compact', 'elevated', 'outlined'],
    initialOption: 'elevated',
  );

  final layout = context.knobs.object.segmented<FluxLayoutMode>(
    label: 'Layout',
    options: FluxLayoutMode.values,
    labelBuilder: (value) => value.name,
  );

  final mediaPosition = context.knobs.object.segmented<FluxMediaPosition>(
    label: 'Media position',
    options: FluxMediaPosition.values,
    labelBuilder: (value) => value.name,
  );

  final mediaSpan = context.knobs.object.segmented<FluxMediaSpan>(
    label: 'Media span',
    options: FluxMediaSpan.values,
    labelBuilder: (value) => value.name,
  );

  final wideSurface = context.knobs.boolean(label: 'Wide surface', initialValue: true);

  final loading = context.knobs.boolean(label: 'Loading');
  final showDiscount = context.knobs.boolean(label: 'Show discount badge', initialValue: true);
  final showWishlist = context.knobs.boolean(label: 'Show wishlist button', initialValue: true);
  final showFooter = context.knobs.boolean(label: 'Show footer', initialValue: true);
  final showSpecs = context.knobs.boolean(label: 'Show spec chips', initialValue: true);
  final useLongTitle = context.knobs.boolean(label: 'Long title');
  final useUnderlay = context.knobs.boolean(label: 'Decorative underlay', initialValue: true);

  // Notch knobs
  final notchMode = context.knobs.list<String>(
    label: 'Notch mode',
    options: const ['none', 'boundary', 'free'],
    initialOption: 'none',
  );

  final notchKind = context.knobs.object.segmented<FluxNotchKind>(
    label: 'Notch kind',
    options: FluxNotchKind.values,
    labelBuilder: (value) => value.name,
  );

  final notchBoundary = context.knobs.object.segmented<FluxSlotBoundary>(
    label: 'Notch boundary',
    options: FluxSlotBoundary.values,
    labelBuilder: (value) => value.name,
  );

  final notchEdge = context.knobs.object.segmented<FluxNotchEdge>(
    label: 'Notch edge',
    options: FluxNotchEdge.values,
    labelBuilder: (value) => value.name,
  );

  final notchSide = context.knobs.object.segmented<FluxNotchSide>(
    label: 'Notch side',
    options: FluxNotchSide.values,
    labelBuilder: (value) => value.name,
  );

  final notchDepth = context.knobs.list<double>(
    label: 'Notch depth',
    options: const [8, 10, 12, 14, 18],
    initialOption: 12,
    labelBuilder: (value) => value.toStringAsFixed(0),
  );

  final notchWidth = context.knobs.list<double>(
    label: 'Notch width',
    options: const [20, 24, 28, 32, 36],
    initialOption: 28,
    labelBuilder: (value) => value.toStringAsFixed(0),
  );

  final notchPosition = context.knobs.list<double>(
    label: 'Notch position',
    options: const [0.25, 0.4, 0.5, 0.6, 0.75],
    initialOption: 0.5,
    labelBuilder: (value) => value.toStringAsFixed(2),
  );

  final effectiveTheme = _resolveTheme(context, themePreset);

  final title = useLongTitle
      ? '${product.name} Premium Limited Edition with Extended Comfort Build'
      : product.name;

  final notch = _buildNotch(
    mode: notchMode,
    kind: notchKind,
    boundary: notchBoundary,
    edge: notchEdge,
    side: notchSide,
    depth: notchDepth,
    width: notchWidth,
    position: notchPosition,
  );

  final divider = _buildDividerForNotchMode(notchMode: notchMode, notchBoundary: notchBoundary);

  return previewSurface(
    context,
    FluxCard(
      layout: layout,
      mediaPosition: mediaPosition,
      mediaSpan: mediaSpan,
      loading: loading,
      theme: effectiveTheme,
      notch: notch,
      divider: divider,
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
            children: [Chip(label: Text('-${product.discountPercent.round()}%'))],
          ),
        if (showWishlist)
          FluxOverlay(
            targets: const {FluxTarget.media},
            alignment: Alignment.topRight,
            children: const [
              CircleAvatar(radius: 18, child: Icon(Icons.favorite_border, size: 18)),
            ],
          ),
      ],
      media: FluxMedia(
        aspectRatio: layout == FluxLayoutMode.row ? null : 4 / 3,
        width: layout == FluxLayoutMode.row ? 180 : null,
        child: Ink.image(image: CachedNetworkImageProvider(product.image), fit: BoxFit.cover),
      ),
      header: FluxSection(
        leading: CircleAvatar(radius: 16, child: Text(product.brand.characters.first)),
        title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${product.brand} • ${product.rating.toStringAsFixed(1)} ★ • ${product.reviewCount} reviews',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const [Icon(Icons.more_horiz)],
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
                Text(product.priceLabel, style: Theme.of(context).textTheme.titleLarge),
                if (product.hasDiscount)
                  Text(
                    product.formerPriceLabel,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(decoration: TextDecoration.lineThrough),
                  ),
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

FluxCardThemeData _resolveTheme(BuildContext context, String themePreset) {
  final theme = switch (themePreset) {
    'standard' => FluxCardThemeData.standard,
    'compact' => FluxCardThemeData.compact,
    'outlined' => FluxCardThemeData.outlined,
    _ => FluxCardThemeData.elevated,
  };

  return theme.copyWith(
    padding: const EdgeInsets.all(16),
    spacing: 14,
    borderSide: themePreset == 'outlined'
        ? BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 1.25)
        : theme.borderSide,
  );
}

FluxDivider? _buildDividerForNotchMode({
  required String notchMode,
  required FluxSlotBoundary notchBoundary,
}) {
  if (notchMode != 'boundary') {
    return null;
  }

  final divider = Divider(height: 1, thickness: 1);

  switch (notchBoundary) {
    case FluxSlotBoundary.afterMedia:
      return FluxDivider(afterMedia: divider);
    case FluxSlotBoundary.afterHeader:
      return FluxDivider(afterHeader: divider);
    case FluxSlotBoundary.afterBody:
      return FluxDivider(afterBody: divider);
  }
}

FluxNotch? _buildNotch({
  required String mode,
  required FluxNotchKind kind,
  required FluxSlotBoundary boundary,
  required FluxNotchEdge edge,
  required FluxNotchSide side,
  required double depth,
  required double width,
  required double position,
}) {
  if (mode == 'none') {
    return null;
  }

  final bool isFree = mode == 'free';

  switch (kind) {
    case FluxNotchKind.ticket:
      if (isFree) {
        return FluxNotch.ticketFree(
          position: position,
          notchDepth: depth,
          edge: edge,
          notchSide: side,
        );
      }

      return FluxNotch.ticket(
        boundary: boundary,
        fallbackPosition: position,
        notchDepth: depth,
        edge: edge,
        notchSide: side,
      );

    case FluxNotchKind.vShape:
      if (isFree) {
        return FluxNotch.vShapeFree(
          position: position,
          notchDepth: depth,
          notchWidth: width,
          edge: edge,
          notchSide: side,
        );
      }

      return FluxNotch.vShape(
        boundary: boundary,
        fallbackPosition: position,
        notchDepth: depth,
        notchWidth: width,
        edge: edge,
        notchSide: side,
      );

    case FluxNotchKind.slant:
      if (isFree) {
        return FluxNotch.slantFree(
          position: position,
          notchDepth: depth,
          notchWidth: width,
          edge: edge,
          notchSide: side,
        );
      }

      return FluxNotch.slant(
        boundary: boundary,
        fallbackPosition: position,
        notchDepth: depth,
        notchWidth: width,
        edge: edge,
        notchSide: side,
      );
  }
}

@widgetbook.UseCase(
  name: 'Onlysocial Promo Banner',
  type: FluxCard,
  path: '[Flux Card]/Cards/Advanced',
)
Widget buildOnlysocialPromoBannerUseCase(BuildContext context) {
  final wideSurface = context.knobs.boolean(label: 'Wide surface', initialValue: true);

  final showBrand = context.knobs.boolean(label: 'Show brand', initialValue: true);

  final showMeta = context.knobs.boolean(label: 'Show bottom meta', initialValue: true);

  final showTexture = context.knobs.boolean(label: 'Show panel gloss', initialValue: true);

  final useLongHeadline = context.knobs.boolean(label: 'Long headline', initialValue: true);

  final imageScale = context.knobs.double.slider(
    label: 'Image scale',
    min: 0.85,
    max: 1.35,
    divisions: 20,
    initialValue: 1.08,
  );

  final imageOffsetX = context.knobs.double.slider(
    label: 'Image offset X',
    min: -80,
    max: 80,
    divisions: 32,
    initialValue: 22,
  );

  final imageOffsetY = context.knobs.double.slider(
    label: 'Image offset Y',
    min: -50,
    max: 60,
    divisions: 22,
    initialValue: 6,
  );

  final panelRadius = context.knobs.double.slider(
    label: 'Panel radius',
    min: 20,
    max: 40,
    divisions: 10,
    initialValue: 30,
  );

  final ctaStyle = context.knobs.list<String>(
    label: 'CTA style',
    options: const ['filled', 'outlined'],
    initialOption: 'filled',
  );

  const panelColor = Color(0xFF8EA2F4);
  const pageBg = Color(0xFFF3F4F7);

  final headline = useLongHeadline
      ? 'Give your brand the\nreach it deserves\nwith Onlysocial'
      : 'Give your brand the\nreach it deserves';

  return previewSurface(
    context,
    FluxCard(
      clipBehavior: Clip.hardEdge,
      height: 300,
      width: 700,
      foregroundColor: Colors.blueAccent,
      theme: FluxCardThemeData.standard.copyWith(
        cardColor: panelColor,
        borderRadius: BorderRadius.circular(panelRadius),
        padding: const EdgeInsets.fromLTRB(30, 28, 30, 22),
        spacing: 16,
        clipBehavior: Clip.none,
      ),

      overlays: [
        FluxOverlay(
          targets: const {FluxTarget.card},
          behavior: .breakout,
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.zero,
          interactive: false,
          children: [
            IgnorePointer(
              child: Image.network(
                'https://images.prismic.io/airtimerewards/Z8hnrBsAHJWomJZI_AIRTIME_PEOPLE_02_NO_'
                'BLACKGROUND.png?auto=format%2Ccompress&fit=max&w=3840',
                height: 420,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ],

      body: SizedBox(
        width: wideSurface ? 390 : 320,
        child: Text(
          headline,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            height: 0.95,
            letterSpacing: -1.5,
          ),
        ),
      ),
      footer: Align(
        alignment: .centerStart,
        child: _PromoCtaButton(style: ctaStyle),
      ),

      onTap: () {},
    ),
    maxWidth: 600
  );
}

class _OnlysocialBrandMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF4E6DFF), Color(0xFF6E89FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'onlysocial',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
      ],
    );
  }
}

class _PromoCtaButton extends StatelessWidget {
  const _PromoCtaButton({required this.style});

  final String style;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      'Join Now',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: style == 'filled' ? const Color(0xFF5876E8) : Colors.white,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
      ),
    );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: style == 'outlined'
          ? BorderSide(color: Colors.white.withValues(alpha: 0.75), width: 1.4)
          : BorderSide.none,
    );

    if (style == 'outlined') {
      return OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: shape.side,
          shape: shape,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
          backgroundColor: Colors.white.withValues(alpha: 0.06),
        ),
        child: label,
      );
    }

    return FilledButton(
      onPressed: () {},
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF5876E8),
        shape: shape,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
      ),
      child: label,
    );
  }
}
