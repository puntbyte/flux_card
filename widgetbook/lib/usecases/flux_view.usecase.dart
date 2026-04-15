import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../demo/demo_post.dart';
import '../demo/demo_product.dart';

// ─── HELPER WIDGETS ──────────────────────────────────────────────────────────

Widget _buildPostCard(DemoPost post) {
  return FluxCard(
    layout: FluxLayoutMode.row,
    media: FluxMedia.image(
      aspectRatio: 1.0,
      image: NetworkImage(post.image),
      fit: BoxFit.cover,
    ),
    header: FluxSection.header(
      title: Text(post.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(post.category),
      padding: EdgeInsets.zero,
    ),
    footer: FluxSection.footer(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions:[
        Text('${post.author} • ${post.readTime}', style: const TextStyle(fontSize: 12)),
        const Icon(Icons.bookmark_border, size: 18),
      ],
      padding: EdgeInsets.zero,
    ),
    theme: FluxCardThemeData.elevated,
    onTap: () {},
  );
}

Widget _buildProductCard(DemoProduct product) {
  return FluxCard(
    layout: FluxLayoutMode.column,
    media: FluxMedia.image(
      aspectRatio: 1.0,
      image: NetworkImage(product.image),
      fit: BoxFit.cover,
    ),
    header: FluxSection.header(
      title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(product.brand, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      padding: EdgeInsets.zero,
    ),
    footer: FluxSection.footer(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions:[
        Text(product.priceLabel, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        const Icon(Icons.add_shopping_cart, size: 20),
      ],
      padding: EdgeInsets.zero,
    ),
    theme: FluxCardThemeData.elevated,
    onTap: () {},
  );
}

// ─── USE CASES ───────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'ListView', type: ListView, path: '[Flux Card]/Views (Scrollables)')
Widget buildListViewUseCase(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    appBar: AppBar(title: const Text('ListView.separated')),
    body: ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: demoPosts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _buildPostCard(demoPosts[index]),
    ),
  );
}

@widgetbook.UseCase(name: 'GridView', type: GridView, path: '[Flux Card]/Views (Scrollables)')
Widget buildGridViewUseCase(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    appBar: AppBar(title: const Text('GridView.builder')),
    body: GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.68, // Adjust based on your typography sizes
      ),
      itemCount: demoProducts.length,
      itemBuilder: (context, index) => _buildProductCard(demoProducts[index]),
    ),
  );
}

@widgetbook.UseCase(name: 'SliverList', type: CustomScrollView, path: '[Flux Card]/Views (Scrollables)')
Widget buildSliverListUseCase(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    body: CustomScrollView(
      slivers:[
        const SliverAppBar(
          title: Text('SliverList'),
          pinned: true,
          expandedHeight: 120,
          flexibleSpace: FlexibleSpaceBar(
            background: ColoredBox(color: Colors.blue),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildPostCard(demoPosts[index]),
                );
              },
              childCount: demoPosts.length,
            ),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'SliverGrid', type: CustomScrollView, path: '[Flux Card]/Views (Scrollables)')
Widget buildSliverGridUseCase(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    body: CustomScrollView(
      slivers:[
        SliverAppBar(
          title: const Text('SliverGrid'),
          pinned: true,
          expandedHeight: 120,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.purple, Colors.orange]),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.68,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildProductCard(demoProducts[index]),
              childCount: demoProducts.length,
            ),
          ),
        ),
      ],
    ),
  );
}