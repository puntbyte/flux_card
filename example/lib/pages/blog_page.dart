import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';

import '../models/post.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, i) {
        final post = posts[i];

        return FluxCardBuilder()
            .layout(const FluxCardLayout.responsive())
            .background(
              FluxBackground.image(
                image: Image.network(post.image, fit: BoxFit.cover),
                aspectRatio: 16 / 9,
                height: 220,
              ),
            )
            .overlay(
              FluxOverlay(
                alignment: Alignment.topLeft,
                children: [
                  if (post.featured)
                    const Chip(
                      label: Text('Featured', style: TextStyle(fontSize: 10, color: Colors.white)),
                      backgroundColor: Colors.deepPurple,
                      side: BorderSide.none,
                    ),
                  Chip(label: Text(post.categoryLabel, style: const TextStyle(fontSize: 10))),
                ],
              ),
            )
            .header(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(
                post.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${post.author} • ${post.publishedLabel}'),
              trailing: [Text(post.readTime, style: const TextStyle(fontSize: 12))],
            )
            .content(
              const Text(
                'Explore how modern layout engines are changing the way we think about '
                'cross-platform UI development.',
              ),
            )
            .footer(
              actions: [
                TextButton(onPressed: () {}, child: const Text('READ STORY')),
                IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
              ],
            )
            .theme(
              FluxCardThemeData.elevated.copyWith(
                padding: const EdgeInsets.all(24),
                borderRadius: BorderRadius.circular(24),
              ),
            )
            .build();
      },
    );
  }
}
