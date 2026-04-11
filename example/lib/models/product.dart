enum ProductCategory { shoes, clothing, electronics, accessories, home, other }

extension ProductCategoryLabel on ProductCategory {
  String get label => name[0].toUpperCase() + name.substring(1);
}

String _formatCurrency(double value) {
  final hasFraction = value != value.roundToDouble();
  return hasFraction ? value.toStringAsFixed(2) : value.toStringAsFixed(0);
}

class ProductPricing {
  final double price;
  final double? discount;
  final double? formerPrice;

  const ProductPricing({
    required this.price,
    this.discount,
    this.formerPrice,
  });

  double get currentPrice => price;

  bool get hasDiscount => (discount ?? 0) > 0 || formerPrice != null;

  double get savings => formerPrice != null
      ? (formerPrice! - price).clamp(0, double.infinity)
      : (discount ?? 0);

  double get discountPercent {
    if (formerPrice == null || formerPrice! <= 0) {
      return 0;
    }
    return ((savings / formerPrice!) * 100).clamp(0, 100);
  }
}

class Product {
  final String id;
  final String name;
  final String brand;
  final String image;
  final ProductCategory category;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final List<String> tags;
  final ProductPricing pricing;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.image,
    required this.category,
    required this.pricing,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.inStock = true,
    this.tags = const [],
  });

  double get price => pricing.currentPrice;

  bool get hasDiscount => pricing.hasDiscount;

  double get savings => pricing.savings;

  double get discountPercent => pricing.discountPercent;

  String get priceLabel => '\$${_formatCurrency(price)}';

  String get formerPriceLabel =>
      pricing.formerPrice == null ? '' : '\$${_formatCurrency(pricing.formerPrice!)}';

  String get categoryLabel => category.label;
}

final mockProducts = <Product>[
  Product(
    id: 'p1',
    name: 'Air Max 270',
    brand: 'Nike',
    image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
    category: ProductCategory.shoes,
    rating: 4.7,
    reviewCount: 1284,
    tags: const ['running', 'sport'],
    pricing: const ProductPricing(price: 150, discount: 20, formerPrice: 170),
  ),
  Product(
    id: 'p2',
    name: 'UltraBoost 22',
    brand: 'Adidas',
    image: 'https://images.unsplash.com/photo-1587563871167-1ee9c731aefb?w=600',
    category: ProductCategory.shoes,
    rating: 4.8,
    reviewCount: 940,
    tags: const ['running', 'comfort'],
    pricing: const ProductPricing(price: 180),
  ),
  Product(
    id: 'p3',
    name: 'Classic Hoodie',
    brand: 'H&M',
    image: 'https://images.unsplash.com/photo-1520975922284-4d7f4f6c4c6d?w=600',
    category: ProductCategory.clothing,
    rating: 4.3,
    reviewCount: 312,
    tags: const ['casual', 'winter'],
    pricing: const ProductPricing(price: 45, discount: 5, formerPrice: 50),
  ),
  Product(
    id: 'p4',
    name: 'Slim Fit T-Shirt',
    brand: 'Uniqlo',
    image: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600',
    category: ProductCategory.clothing,
    rating: 4.5,
    reviewCount: 540,
    tags: const ['summer', 'basic'],
    pricing: const ProductPricing(price: 19.99),
  ),
  Product(
    id: 'p5',
    name: 'Wireless Noise Cancelling Headphones',
    brand: 'Sony',
    image: 'https://images.unsplash.com/photo-1518443895914-6b3f4c1a8c7e?w=600',
    category: ProductCategory.electronics,
    rating: 4.9,
    reviewCount: 2110,
    tags: const ['audio', 'premium'],
    pricing: const ProductPricing(price: 349, discount: 50, formerPrice: 399),
  ),
  Product(
    id: 'p6',
    name: 'Smart Watch Series 9',
    brand: 'Apple',
    image: 'https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b?w=600',
    category: ProductCategory.electronics,
    rating: 4.8,
    reviewCount: 1750,
    tags: const ['fitness', 'wearable'],
    pricing: const ProductPricing(price: 429),
  ),
  Product(
    id: 'p7',
    name: 'Leather Wallet',
    brand: 'Fossil',
    image: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=600',
    category: ProductCategory.accessories,
    rating: 4.4,
    reviewCount: 210,
    tags: const ['leather', 'minimal'],
    pricing: const ProductPricing(price: 60, discount: 10, formerPrice: 70),
  ),
  Product(
    id: 'p8',
    name: 'Polarized Sunglasses',
    brand: 'Ray-Ban',
    image: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=600',
    category: ProductCategory.accessories,
    rating: 4.6,
    reviewCount: 660,
    tags: const ['summer', 'fashion'],
    pricing: const ProductPricing(price: 155),
  ),
  Product(
    id: 'p9',
    name: 'Minimal Desk Lamp',
    brand: 'IKEA',
    image: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=600',
    category: ProductCategory.home,
    rating: 4.2,
    reviewCount: 150,
    tags: const ['lighting', 'desk'],
    pricing: const ProductPricing(price: 35),
  ),
  Product(
    id: 'p10',
    name: 'Ergonomic Office Chair',
    brand: 'Herman Miller',
    image: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=600',
    category: ProductCategory.home,
    rating: 4.9,
    reviewCount: 820,
    tags: const ['office', 'comfort'],
    pricing: const ProductPricing(price: 999, discount: 100, formerPrice: 1099),
  ),
];