enum DestinationCategory { beach, mountain, city, nature, historical, adventure }

extension DestinationCategoryLabel on DestinationCategory {
  String get label => name[0].toUpperCase() + name.substring(1);
}

String _formatCurrency(double value) {
  final hasFraction = value != value.roundToDouble();
  return hasFraction ? value.toStringAsFixed(2) : value.toStringAsFixed(0);
}

class Destination {
  final String id;
  final String title;
  final String location;
  final String image;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final DestinationCategory category;
  final String description;
  final bool featured;
  final List<String> tags;

  const Destination({
    required this.id,
    required this.title,
    required this.location,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    required this.category,
    required this.description,
    this.featured = false,
    this.tags = const [],
  });

  bool get isTopRated => rating >= 4.8;

  String get priceLabel => '\$${_formatCurrency(pricePerNight)} / night';

  String get categoryLabel => category.label;
}

final List<Destination> mockDestinations = [
  Destination(
    id: 'd1',
    title: 'Santorini Caldera',
    location: 'Greece',
    image: 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=800',
    rating: 4.9,
    reviewCount: 1840,
    pricePerNight: 260,
    category: DestinationCategory.beach,
    description: 'Iconic whitewashed cliffs, blue domes, and unforgettable sunsets.',
    featured: true,
    tags: const ['sunset', 'romantic', 'island'],
  ),

  Destination(
    id: 'd2',
    title: 'Kyoto Temples',
    location: 'Japan',
    image: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800',
    rating: 4.8,
    reviewCount: 1260,
    pricePerNight: 180,
    category: DestinationCategory.historical,
    description: 'A peaceful blend of ancient shrines, gardens, and rich culture.',
    featured: true,
    tags: const ['culture', 'temples', 'tradition'],
  ),

  Destination(
    id: 'd3',
    title: 'Banff National Park',
    location: 'Canada',
    image: 'https://images.unsplash.com/photo-1517059224940-d4af9eec41b7?w=800',
    rating: 4.7,
    reviewCount: 980,
    pricePerNight: 145,
    category: DestinationCategory.nature,
    description: 'Turquoise lakes, alpine peaks, and scenic hiking trails.',
    tags: const ['lake', 'hiking', 'mountains'],
  ),

  Destination(
    id: 'd4',
    title: 'Swiss Alps',
    location: 'Switzerland',
    image: 'https://images.unsplash.com/photo-1531310197839-ccf54634509e?w=800',
    rating: 5.0,
    reviewCount: 2140,
    pricePerNight: 320,
    category: DestinationCategory.mountain,
    description: 'Snowy peaks, luxury resorts, and world-class mountain views.',
    featured: true,
    tags: const ['skiing', 'luxury', 'snow'],
  ),

  Destination(
    id: 'd5',
    title: 'Paris City Lights',
    location: 'France',
    image: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800',
    rating: 4.8,
    reviewCount: 3010,
    pricePerNight: 210,
    category: DestinationCategory.city,
    description: 'A timeless city filled with art, cafés, fashion, and landmarks.',
    tags: const ['art', 'food', 'romantic'],
  ),

  Destination(
    id: 'd6',
    title: 'Bali Rice Terraces',
    location: 'Indonesia',
    image: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
    rating: 4.9,
    reviewCount: 1650,
    pricePerNight: 190,
    category: DestinationCategory.beach,
    description: 'Lush greenery, calm beaches, and a relaxing island atmosphere.',
    featured: true,
    tags: const ['tropical', 'wellness', 'nature'],
  ),

  Destination(
    id: 'd7',
    title: 'Machu Picchu',
    location: 'Peru',
    image: 'https://images.unsplash.com/photo-1526392060635-9d6019884377?w=800',
    rating: 4.9,
    reviewCount: 1425,
    pricePerNight: 230,
    category: DestinationCategory.historical,
    description: 'A breathtaking ancient citadel high in the Andes Mountains.',
    tags: const ['ancient', 'adventure', 'unesco'],
  ),

  Destination(
    id: 'd8',
    title: 'Reykjavik & Northern Lights',
    location: 'Iceland',
    image: 'https://images.unsplash.com/photo-1493246507139-91e8fad9978e?w=800',
    rating: 4.8,
    reviewCount: 890,
    pricePerNight: 240,
    category: DestinationCategory.adventure,
    description: 'Volcanic landscapes, hot springs, and aurora-filled nights.',
    tags: const ['aurora', 'cold', 'exploration'],
  ),
];
