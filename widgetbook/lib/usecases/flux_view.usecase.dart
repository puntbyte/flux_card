import 'package:cached_network_image/cached_network_image.dart';
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
      image: CachedNetworkImageProvider(post.image),
      fit: BoxFit.cover,
      padding: EdgeInsets.all(8),
    ),

    header: FluxSection.header(
      title: Text(post.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(post.category),
      padding: EdgeInsets.zero,
    ),

    footer: FluxSection.footer(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Text('${post.author} • ${post.readTime}', style: const TextStyle(fontSize: 12)),
        const Icon(Icons.bookmark_border, size: 18),
      ],
      padding: EdgeInsets.zero,
    ),

    theme: FluxCardThemeData.elevated.copyWith(padding: EdgeInsets.zero),
    onTap: () {},
  );
}

Widget _buildProductCard(DemoProduct product) {
  return FluxCard(
    layout: FluxLayoutMode.column,

    media: FluxMedia.image(
      aspectRatio: .95,
      image: CachedNetworkImageProvider(product.image),
      fit: BoxFit.cover,
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      borderRadius: BorderRadius.circular(16),
    ),

    header: FluxSection.header(
      title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(product.brand, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      padding: EdgeInsets.zero,
      spacing: 0,
    ),

    footer: FluxSection.footer(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Text(product.priceLabel, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        const Icon(Icons.add_shopping_cart, size: 20),
      ],
    ),

    theme: FluxCardThemeData.elevated.copyWith(spacing: 2, padding: EdgeInsets.all(8)),
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
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 16,
        mainAxisExtent: 300,
        mainAxisSpacing: 16,
      ),
      itemCount: demoProducts.length,
      itemBuilder: (context, index) => _buildProductCard(demoProducts[index]),
    ),
  );
}

@widgetbook.UseCase(
  name: 'SliverList',
  type: CustomScrollView,
  path: '[Flux Card]/Views (Scrollables)',
)
Widget buildSliverListUseCase(BuildContext context) {
  final posts = [...demoPosts, ...demoPosts, ...demoPosts, ...demoPosts];
  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    body: CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('SliverList'),
          pinned: true,
          expandedHeight: 120,
          flexibleSpace: FlexibleSpaceBar(background: ColoredBox(color: Colors.blue)),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildPostCard(posts[index]),
            ),
          ),
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'SliverGrid',
  type: CustomScrollView,
  path: '[Flux Card]/Views (Scrollables)',
)
Widget buildSliverGridUseCase(BuildContext context) {
  final products = [...demoProducts, ...demoProducts, ...demoProducts, ...demoProducts];

  return Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    body: CustomScrollView(
      slivers: [
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
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisExtent: 276,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              //childAspectRatio: 0.64,
            ),

            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildProductCard(products[index]),
              childCount: products.length,
            ),
          ),
        ),
      ],
    ),
  );
}
