import 'package:example/models/destination.dart';
import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';

class DestinationListPage extends StatelessWidget {
  const DestinationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        if (isWide) {
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1.08,
            ),
            itemCount: mockDestinations.length,
            itemBuilder: (context, i) {
              return DestinationCard(
                destination: mockDestinations[i],
                isHorizontal: false,
              );
            },
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: mockDestinations.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, i) {
            return DestinationCard(
              destination: mockDestinations[i],
              isHorizontal: true,
            );
          },
        );
      },
    );
  }
}

class DestinationCard extends StatelessWidget {
  final Destination destination;
  final bool isHorizontal;

  const DestinationCard({
    super.key,
    required this.destination,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final background = FluxBackground.image(
      image: Image.network(destination.image, fit: BoxFit.cover),
      aspectRatio: isHorizontal ? 1.3 : 1.2,
      height: isHorizontal ? 180 : 220,
    );

    return FluxCard(
      layout: isHorizontal
          ? const FluxCardLayout.row()
          : const FluxCardLayout.stack(),
      background: background,
      overlay: isHorizontal
          ? null
          : FluxOverlay(
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '★ ${destination.rating.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          if (destination.featured)
            const Chip(
              label: Text(
                'Featured',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
              backgroundColor: Colors.deepPurple,
              side: BorderSide.none,
            ),
        ],
      ),
      header: FluxHeader(
        title: Text(
          destination.title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${destination.location} • ${destination.categoryLabel}',
        ),
        trailing: [
          if (destination.isTopRated)
            const Chip(
              label: Text(
                'Top rated',
                style: TextStyle(fontSize: 10),
              ),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
      content: isHorizontal
          ? Text(
        destination.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      )
          : null,
      footer: FluxFooter(
        alignment: MainAxisAlignment.spaceBetween,
        actions: [
          Text(
            destination.priceLabel,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Book now'),
          ),
        ],
      ),
      theme: FluxCardThemeData.elevated.copyWith(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(isHorizontal ? 18 : 24),
      ),
      onTap: () {},
    );
  }
}