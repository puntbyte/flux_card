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
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, i) {
        final post = posts[i];

        return FluxCard(
          layout: FluxLayoutMode.responsive,
          mediaPosition: FluxMediaPosition.start,
          media: FluxMedia(
            aspectRatio: 16 / 9,
            child: Image.network(post.image, fit: BoxFit.cover),
          ),
          underlay: const [
            FluxUnderlay(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]),
              ),
              targets: {FluxTarget.body},
            ),
          ],
          overlays: [
            FluxOverlay(
              targets: const {FluxTarget.media},
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
          ],
          header: FluxSection(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(
              post.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${post.author} • ${post.publishedLabel}'),
            trailing: [Text(post.readTime, style: const TextStyle(fontSize: 12))],
            padding: EdgeInsets.zero,
          ),
          body: const Text(
            'Explore how modern layout engines are changing the way we think about cross-platform '
            'UI development.',
          ),
          footer: FluxSection(
            actions: [
              TextButton(onPressed: () {}, child: const Text('READ STORY')),
              IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
            ],
            padding: EdgeInsets.zero,
          ),
          theme: FluxCardThemeData.elevated.copyWith(
            padding: const EdgeInsets.all(24),
            borderRadius: BorderRadius.circular(24),
          ),
        );
      },
    );
  }
}
