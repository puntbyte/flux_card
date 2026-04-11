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
    image: 'https://images.unsplash.com/photo-1518443895914-6b3f4c1a8c7e?w=1200',
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

class DemoDestination {
  final String title;
  final String location;
  final String image;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final String description;
  final bool featured;

  const DemoDestination({
    required this.title,
    required this.location,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    required this.description,
    this.featured = false,
  });

  String get priceLabel =>
      '\$${pricePerNight.toStringAsFixed(pricePerNight.truncateToDouble() == pricePerNight ? 0 : 2)} / night';
}

const demoDestinations = <DemoDestination>[
  DemoDestination(
    title: 'Santorini Caldera',
    location: 'Greece',
    image: 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=1200',
    rating: 4.9,
    reviewCount: 1840,
    pricePerNight: 260,
    description: 'Iconic whitewashed cliffs, blue domes, and unforgettable sunsets.',
    featured: true,
  ),
  DemoDestination(
    title: 'Kyoto Temples',
    location: 'Japan',
    image: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=1200',
    rating: 4.8,
    reviewCount: 1260,
    pricePerNight: 180,
    description: 'A peaceful blend of ancient shrines, gardens, and rich culture.',
    featured: true,
  ),
  DemoDestination(
    title: 'Swiss Alps',
    location: 'Switzerland',
    image: 'https://images.unsplash.com/photo-1531310197839-ccf54634509e?w=1200',
    rating: 5.0,
    reviewCount: 2140,
    pricePerNight: 320,
    description: 'Snowy peaks, luxury resorts, and world-class mountain views.',
    featured: true,
  ),
];

class DemoPost {
  final String title;
  final String author;
  final String category;
  final String readTime;
  final String image;
  final DateTime publishedAt;
  final bool featured;

  const DemoPost({
    required this.title,
    required this.author,
    required this.category,
    required this.readTime,
    required this.image,
    required this.publishedAt,
    this.featured = false,
  });

  String get publishedLabel =>
      '\${publishedAt.day} \${_month(publishedAt.month)} \${publishedAt.year}';
}

String _month(int month) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}

final demoPosts = <DemoPost>[
  DemoPost(
    title: 'The Future of Flutter Architecture',
    author: 'Jane Doe',
    category: 'Engineering',
    readTime: '12 min read',
    image: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=1200',
    publishedAt: DateTime(2026, 3, 14),
    featured: true,
  ),
  DemoPost(
    title: 'Design Systems That Scale Across Teams',
    author: 'Alex Kim',
    category: 'Design',
    readTime: '8 min read',
    image: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=1200',
    publishedAt: DateTime(2026, 3, 18),
  ),
  DemoPost(
    title: 'Building Better User Flows for Mobile Apps',
    author: 'Sara Ahmed',
    category: 'Design',
    readTime: '9 min read',
    image: 'https://images.unsplash.com/photo-1516321497487-e288fb19713f?w=1200',
    publishedAt: DateTime(2026, 3, 25),
    featured: true,
  ),
];
