import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';

import '../models/product.dart';

class ProductGridPage extends StatelessWidget {
  const ProductGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 1200
            ? 4
            : constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 600
            ? 2
            : 1;

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: crossAxisCount == 1 ? 1.65 : 0.72,
          ),
          itemCount: mockProducts.length,
          itemBuilder: (context, i) {
            final product = mockProducts[i];

            return FluxCard(
              layout: crossAxisCount == 1
                  ? const FluxCardLayout.row()
                  : const FluxCardLayout.column(),
              background: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(product.image, fit: BoxFit.cover),
                    if (!product.inStock)
                      Container(
                        color: Colors.black45,
                        alignment: Alignment.center,
                        child: const Text(
                          'OUT OF STOCK',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              overlay: FluxOverlay(
                alignment: Alignment.topLeft,
                children: [
                  if (product.hasDiscount)
                    Chip(
                      label: Text(
                        'SALE ${product.discountPercent.round()}%',
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                      side: BorderSide.none,
                    ),
                  if (!product.inStock)
                    const Chip(
                      label: Text(
                        'SOLD OUT',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                      backgroundColor: Colors.black87,
                      side: BorderSide.none,
                    ),
                ],
              ),
              header: FluxHeader(
                title: Text(
                  product.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${product.brand} • ${product.categoryLabel}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              content: Text(
                '${product.rating.toStringAsFixed(1)} ★ • ${product.reviewCount} reviews'
                    '${product.tags.isNotEmpty ? ' • ${product.tags.join(' · ')}' : ''}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              footer: FluxFooter(
                actions: [
                  Text(
                    product.priceLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  if (product.hasDiscount)
                    Text(
                      product.formerPriceLabel,
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: product.inStock ? () {} : null,
                    icon: const Icon(Icons.add_shopping_cart_outlined, size: 18),
                  ),
                ],
              ),
              theme: FluxCardThemeData.elevated.copyWith(
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(20),
              ),
              onTap: product.inStock ? () {} : null,
            );
          },
        );
      },
    );
  }
}