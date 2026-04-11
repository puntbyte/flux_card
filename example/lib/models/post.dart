enum PostCategory {
  engineering,
  design,
  product,
  business,
  news,
  other,
}

extension PostCategoryLabel on PostCategory {
  String get label => name[0].toUpperCase() + name.substring(1);
}

String _formatDate(DateTime date) {
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

  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

class Post {
  final String id;
  final String title;
  final String author;
  final String readTime;
  final PostCategory category;
  final String image;
  final DateTime publishedAt;
  final bool featured;
  final List<String> tags;

  const Post({
    required this.id,
    required this.title,
    required this.author,
    required this.readTime,
    required this.category,
    required this.image,
    required this.publishedAt,
    this.featured = false,
    this.tags = const [],
  });

  bool get isFeatured => featured;

  String get categoryLabel => category.label;

  String get publishedLabel => _formatDate(publishedAt);
}

final List<Post> posts = [
  Post(
    id: 'post_1',
    title: 'The Future of Flutter Architecture',
    author: 'Jane Doe',
    readTime: '12 min read',
    category: PostCategory.engineering,
    image: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=600',
    publishedAt: DateTime(2026, 3, 14),
    featured: true,
    tags: const ['flutter', 'architecture', 'mobile'],
  ),
  Post(
    id: 'post_2',
    title: 'Design Systems That Scale Across Teams',
    author: 'Alex Kim',
    readTime: '8 min read',
    category: PostCategory.design,
    image: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=600',
    publishedAt: DateTime(2026, 3, 18),
    tags: const ['ui', 'design system', 'components'],
  ),
  Post(
    id: 'post_3',
    title: 'How Product Teams Ship Faster Without Losing Quality',
    author: 'Maya Patel',
    readTime: '10 min read',
    category: PostCategory.product,
    image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=600',
    publishedAt: DateTime(2026, 3, 20),
    tags: const ['product', 'delivery', 'workflow'],
  ),
  Post(
    id: 'post_4',
    title: 'Why Startup Metrics Matter More Than Vanity Numbers',
    author: 'Chris Johnson',
    readTime: '6 min read',
    category: PostCategory.business,
    image: 'https://images.unsplash.com/photo-1520607162513-77705c0f0d4a?w=600',
    publishedAt: DateTime(2026, 3, 22),
    tags: const ['metrics', 'startup', 'growth'],
  ),
  Post(
    id: 'post_5',
    title: 'Building Better User Flows for Mobile Apps',
    author: 'Sara Ahmed',
    readTime: '9 min read',
    category: PostCategory.design,
    image: 'https://images.unsplash.com/photo-1516321497487-e288fb19713f?w=600',
    publishedAt: DateTime(2026, 3, 25),
    featured: true,
    tags: const ['ux', 'mobile', 'flow'],
  ),
  Post(
    id: 'post_6',
    title: 'Lessons From Migrating a Large Codebase to Dart 3',
    author: 'Daniel Brooks',
    readTime: '14 min read',
    category: PostCategory.engineering,
    image: 'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?w=600',
    publishedAt: DateTime(2026, 3, 28),
    tags: const ['dart', 'migration', 'refactor'],
  ),
];