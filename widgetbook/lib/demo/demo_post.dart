

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
      '${publishedAt.day} ${_month(publishedAt.month)} ${publishedAt.year}';
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
