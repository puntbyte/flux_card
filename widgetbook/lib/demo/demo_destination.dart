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