import 'package:cached_network_image/cached_network_image.dart';
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
  final showDiscount = context.knobs.boolean(label: 'Show discount', initialValue: true);
  final loading = context.knobs.boolean(label: 'Loading');

  return previewSurface(
    context,
    FluxCard(
      loading: loading,
      media: FluxMedia(
        aspectRatio: 1,
        child: CachedNetworkImage(imageUrl: product.image, fit: BoxFit.cover),
      ),
      overlays: [
        if (showDiscount && product.hasDiscount)
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
      footer: FluxSection(
        actions: [
          Text(
            product.priceLabel,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          if (product.hasDiscount)
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
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated,
      onTap: inStock ? () {} : null,
    ),
    maxWidth: 360,
  );
}

@widgetbook.UseCase(name: 'Travel card', type: FluxCard, path: '[Flux Card]/Compositions')
Widget buildTravelCardUseCase(BuildContext context) {
  final destination = demoDestinations[1];
  final layout = context.knobs.object.segmented<FluxLayoutMode>(
    label: 'Layout',
    options: const [FluxLayoutMode.column, FluxLayoutMode.inColumn, FluxLayoutMode.row],
    labelBuilder: (m) => m.name,
  );
  final mediaPosition = context.knobs.object.segmented<FluxMediaPosition>(
    label: 'Media position',
    options: FluxMediaPosition.values,
    labelBuilder: (m) => m.name,
  );

  return previewSurface(
    context,
    FluxCard(
      layout: layout,
      mediaPosition: mediaPosition,
      media: FluxMedia(
        aspectRatio: layout == FluxLayoutMode.row ? 1.2 : 16 / 10,
        child: Image.network(destination.image, fit: BoxFit.cover),
      ),
      overlays: [
        FluxOverlay(
          targets: const {FluxTarget.media},
          alignment: Alignment.topRight,
          children: const [
            Chip(
              label: Text('Travel', style: TextStyle(fontSize: 10, color: Colors.white)),
              backgroundColor: Colors.black87,
              side: BorderSide.none,
            ),
          ],
        ),
      ],
      header: FluxSection(
        title: Text(destination.title),
        subtitle: Text('${destination.location} • City escape'),
        padding: EdgeInsets.zero,
      ),
      body: Text(destination.description),
      footer: FluxSection(
        actions: [
          Text(
            destination.priceLabel,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          Text('${destination.rating.toStringAsFixed(1)} ★'),
          ElevatedButton(onPressed: () {}, child: const Text('Reserve')),
        ],
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated,
      onTap: () {},
    ),
    maxWidth: layout == FluxLayoutMode.row ? 540 : 420,
  );
}

@widgetbook.UseCase(name: 'Blog card', type: FluxCard, path: '[Flux Card]/Compositions')
Widget buildBlogCardUseCase(BuildContext context) {
  final post = demoPosts.first;
  final preset = context.knobs.object.segmented<FluxCardThemeData>(
    label: 'Theme preset',
    options: const [
      FluxCardThemeData.standard,
      FluxCardThemeData.compact,
      FluxCardThemeData.elevated,
      FluxCardThemeData.outlined,
    ],
    labelBuilder: (t) {
      if (t == FluxCardThemeData.compact) return 'Compact';
      if (t == FluxCardThemeData.elevated) return 'Elevated';
      if (t == FluxCardThemeData.outlined) return 'Outlined';
      return 'Standard';
    },
  );

  return previewSurface(
    context,
    FluxCard(
      layout: FluxLayoutMode.responsive,
      backgrounds: const [
        FluxBackground.gradient(
          gradient: LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]),
          targets: {FluxTarget.body},
        ),
      ],
      media: FluxMedia(
        aspectRatio: 16 / 9,
        child: Image.network(post.image, fit: BoxFit.cover),
      ),
      overlays: [
        if (post.featured)
          const FluxOverlay(
            targets: {FluxTarget.media},
            alignment: Alignment.topLeft,
            children: [
              Chip(
                label: Text('Featured', style: TextStyle(fontSize: 10, color: Colors.white)),
                backgroundColor: Colors.deepPurple,
                side: BorderSide.none,
              ),
            ],
          ),
      ],
      header: FluxSection(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(post.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text('${post.category} • ${post.publishedLabel}'),
        trailing: [Text(post.readTime, style: const TextStyle(fontSize: 11))],
        padding: EdgeInsets.zero,
      ),
      body: const Text(
        'Explore how modern layout engines are changing the way we think about cross-platform UI development.',
      ),
      footer: FluxSection(
        actions: [
          TextButton(onPressed: () {}, child: const Text('READ STORY')),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        ],
        padding: EdgeInsets.zero,
      ),
      theme: preset.copyWith(
        padding: const EdgeInsets.all(16),
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      onTap: () {},
    ),
    maxWidth: 540,
  );
}

@widgetbook.UseCase(name: 'Event ticket', type: FluxCard, path: '[Flux Card]/Compositions')
Widget buildEventTicketUseCase(BuildContext context) {
  final loading = context.knobs.boolean(label: 'Loading');

  return previewSurface(
    context,
    FluxCard(
      loading: loading,
      media: FluxMedia(
        aspectRatio: 16 / 7,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=1200',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black54],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
      overlays: const [
        FluxOverlay(
          targets: {FluxTarget.media},
          alignment: Alignment.bottomLeft,
          children: [
            Chip(
              label: Text('LIVE', style: TextStyle(fontSize: 10, color: Colors.white)),
              backgroundColor: Colors.red,
              side: BorderSide.none,
            ),
          ],
        ),
      ],
      header: const FluxSection(
        title: Text('Flutter Dev Summit 2026', style: TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text('San Francisco Convention Center'),
        padding: EdgeInsets.zero,
      ),
      body: _TicketDividerLine(),
      footer:  FluxSection(
        actions: [
          Text('Sat 18 Apr 2026 • 9:00 AM', style: TextStyle(fontWeight: FontWeight.w600)),
          Chip(label: Text('General Admission')),
          Text('Gate C4'),
          
        ],
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.outlined.copyWith(
        borderSide: BorderSide(width: 2, color: Colors.black),
        shape: const FluxTicketShape(notchRadius: 14, notchPosition: 0.68),
        padding: const EdgeInsets.all(20),
      ),
      onTap: () {},
    ),
    maxWidth: 400,
  );
}

class _TicketDividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      child: Row(
        children: List.generate(
          26,
          (i) => Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              color: i.isEven ? Theme.of(context).dividerColor : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}

@widgetbook.UseCase(name: 'Speak Card', type: FluxCard, path: '[Flux Card]/Compositions')
Widget buildSpeakCardUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      backgrounds: const [
        FluxBackground.gradient(
          gradient: LinearGradient(
            colors: [Color(0xFFeeab24), Color(0xFFf5c561)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
      ],

      header: FluxSection(
        title: Text('Speak Premium Member'),
        trailing: [Icon(Icons.multitrack_audio)],
      ),

      body: FluxSection(
        title: Text('alexsmith.mobbin@gmail.com'),
        subtitle: Text('Member since Aug //2020'),
      ),

      footer: FluxSection(
        title: Text('Annual Subscription'),
        subtitle: Text('6 Day Free Trial'),
      ),

      theme: FluxCardThemeData.elevated,
    ),
  );
}
