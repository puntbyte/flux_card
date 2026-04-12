class DemoProduct {
  final String name;
  final String brand;
  final String image;
  final double price;
  final double formerPrice;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final bool inStock;

  const DemoProduct({
    required this.name,
    required this.brand,
    required this.image,
    required this.price,
    required this.formerPrice,
    required this.rating,
    required this.reviewCount,
    required this.tags,
    this.inStock = true,
  });

  String get priceLabel => '\$${price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2)}';

  String get formerPriceLabel =>
      '\$${formerPrice.toStringAsFixed(formerPrice.truncateToDouble() == formerPrice ? 0 : 2)}';

  double get discountPercent => ((formerPrice - price) / formerPrice * 100).clamp(0, 100);

  bool get hasDiscount => discountPercent > 0;
}

const demoProducts = <DemoProduct>[
  DemoProduct(
    name: 'Air Max 270',
    brand: 'Nike',
    image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=1200',
    price: 150,
    formerPrice: 170,
    rating: 4.7,
    reviewCount: 1284,
    tags: ['running', 'sport'],
  ),

  DemoProduct(
    name: 'Noise Cancelling Headphones',
    brand: 'Sony',
    image: 'https://www.canford.co.uk/Images/ItemImages/large/54-436_01.jpg',
    price: 349,
    formerPrice: 399,
    rating: 4.9,
    reviewCount: 2110,
    tags: ['audio', 'premium'],
  ),

  DemoProduct(
    name: 'Ergonomic Office Chair',
    brand: 'Herman Miller',
    image: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=1200',
    price: 999,
    formerPrice: 1099,
    rating: 4.9,
    reviewCount: 820,
    tags: ['office', 'comfort'],
  ),
];

