import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../shared/preview_surface.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 1. Freelancer profile (image ref: Henrie Ekemezie)
//
//    Landscape media — avatar overlay at media bottom-left — bookmark at
//    top-right — name + tools badge in header — stats row + CTA in footer.
// ─────────────────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Freelancer profile', type: FluxCard, path: '[Flux Card]/Compositions')
Widget buildFreelancerProfileUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      media: FluxMedia(
        aspectRatio: 16 / 9,
        child: Ink.image(
          image: const NetworkImage(
            'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=900',
          ),
          fit: BoxFit.cover,
        ),
      ),
      overlays: [
        // Bookmark pill — top-right of photo.
        FluxOverlay(
          targets: const {FluxTarget.media},
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(7),
                    child: Icon(Icons.bookmark_border, size: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Avatar — bottom-left of photo.
        FluxOverlay(
          targets: const {FluxTarget.media},
          alignment: Alignment.bottomLeft,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14, bottom: 10),
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  color: Colors.grey.shade200,
                ),
                child: const Icon(Icons.person, size: 30, color: Colors.black45),
              ),
            ),
          ],
        ),
      ],
      header: FluxSection(
        title: const Text(
          'Henrie Ekemezie',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        subtitle: const Text('Web & UI/UX Designer', style: TextStyle(color: Colors.grey)),
        trailing: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 9,
                backgroundColor: Colors.blue.shade700,
                child: const Text(
                  'W',
                  style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 3),
              const CircleAvatar(
                radius: 9,
                backgroundColor: Color(0xFFFF7262),
                child: Text(
                  'F',
                  style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 6),
              const Text('Tools', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
        padding: EdgeInsets.zero,
      ),
      footer: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _StatCol(value: '★ 4.0', label: 'rating'),
                  VerticalDivider(width: 1, thickness: 1),
                  _StatCol(value: '8 Days', label: 'duration'),
                  VerticalDivider(width: 1, thickness: 1),
                  _StatCol(value: '\$40/hr', label: 'rate'),
                ],
              ),
            ),
            const SizedBox(width: 14),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Get in touch', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
      theme: FluxCardThemeData.elevated.copyWith(
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        padding: const EdgeInsets.all(16),
      ),
      onTap: () {},
    ),
    maxWidth: 400,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. Creator / dark profile (image ref: Natasha Romanoff)
//
//    Tall portrait fills the media slot — bottom-to-top gradient scrim as
//    FluxBackground — name / bio / stats overlaid at bottom of photo —
//    dark card — footer row with CTA + bookmark.
// ─────────────────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Creator profile', type: FluxCard, path: '[Flux Card]/Compositions')
Widget buildCreatorProfileUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      media: FluxMedia(
        aspectRatio: 0.72, // portrait
        child: Ink.image(
          image: const NetworkImage(
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=700',
          ),
          fit: BoxFit.cover,
        ),
      ),
      backgrounds: [
        // Gradient scrim over the lower ~65 % of the photo.
        FluxBackground.gradient(
          gradient: const LinearGradient(
            colors: [Colors.transparent, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.35, 1.0],
          ),
          targets: const {FluxTarget.media},
        ),
      ],
      overlays: [
        // Name / bio / stats block in the lower-left of the photo.
        FluxOverlay(
          targets: const {FluxTarget.media},
          alignment: Alignment.bottomLeft,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Natasha Romanoff',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.verified, color: Colors.blue, size: 19),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "I'm a Brand Designer who focuses on clarity\n& emotional connection.",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  IntrinsicHeight(
                    child: Row(
                      children: const [
                        _CreatorStat(value: '★ 4.8', label: 'Rating'),
                        VerticalDivider(color: Colors.white24, width: 20, thickness: 1),
                        _CreatorStat(value: '\$45k+', label: 'Earned'),
                        VerticalDivider(color: Colors.white24, width: 20, thickness: 1),
                        _CreatorStat(value: '\$50/hr', label: 'Rate'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      footer: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.email_outlined, size: 18),
              label: const Text('Get In Touch'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C36),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              icon: const Icon(Icons.bookmark_border, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
      theme: const FluxCardThemeData(
        cardColor: Color(0xFF16161E),
        borderRadius: BorderRadius.all(Radius.circular(28)),
        padding: EdgeInsets.all(16),
        spacing: 0,
      ),
      onTap: () {},
    ),
    maxWidth: 340,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. Pricing card (image ref: One-Off)
//
//    No media — FluxSection header with icon — feature list body —
//    FluxDivider between body and footer — footer has dark/golden bg via
//    FluxBackground.gradient targeting footer slot — price + Figma chip +
//    "Choose Design Only" CTA.  Knob: A (golden) vs B (dark) variant.
// ─────────────────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Pricing card', type: FluxCard, path: '[Flux Card]/Compositions')
Widget buildPricingCardUseCase(BuildContext context) {
  final dark = context.knobs.boolean(label: 'Dark variant (B)');

  const golden = Color(0xFFBE9656);
  const charcoal = Color(0xFF1C1C1E);

  final cardBg = dark ? charcoal : golden;
  final footerBg = dark ? golden : charcoal;
  final bodyText = dark ? Colors.white : Colors.black;
  final bodyMuted = dark ? Colors.white60 : Colors.black54;
  final footerText = dark ? Colors.black : Colors.white;
  final footerMuted = dark ? Colors.black54 : Colors.white60;
  final iconBg = dark ? golden : charcoal;
  final iconFg = dark ? Colors.black : Colors.white;

  return previewSurface(
    context,
    FluxCard(
      backgrounds: [
        // Solid contrast colour on the footer slot only — extends behind padding.
        FluxBackground.gradient(
          gradient: LinearGradient(colors: [footerBg, footerBg]),
          targets: const {FluxTarget.footer},
        ),
      ],
      header: FluxSection(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
          child: Icon(Icons.tv_outlined, color: iconFg, size: 22),
        ),
        title: Text(
          'One-Off',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: bodyText),
        ),
        subtitle: Text(
          'Launch your dream site in 7 days',
          style: TextStyle(color: bodyMuted, fontSize: 13),
        ),
        padding: EdgeInsets.zero,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PricingFeature(icon: Icons.web_outlined, text: 'Single page', color: bodyText),
          const SizedBox(height: 10),
          _PricingFeature(icon: Icons.palette_outlined, text: 'Design only', color: bodyText),
          const SizedBox(height: 10),
          _PricingFeature(
            icon: Icons.chat_bubble_outline,
            text: 'Slack communication',
            color: bodyText,
          ),
          const SizedBox(height: 10),
          _PricingFeature(
            icon: Icons.draw_outlined,
            text: 'Custom Graphics / Illustrations',
            color: bodyText,
          ),
        ],
      ),
      divider: const FluxDivider(afterBody: Divider(height: 1, thickness: 1)),
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$1300',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: footerText),
                  ),
                  Text('Billed one time', style: TextStyle(fontSize: 12, color: footerMuted)),
                ],
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.grid_view_rounded, size: 14, color: footerText),
                label: Text('Figma Project', style: TextStyle(color: footerText, fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: footerText.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Text(
              'Choose Design Only',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: footerText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
      theme: FluxCardThemeData(
        cardColor: cardBg,
        padding: const EdgeInsets.all(20),
        spacing: 16,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      onTap: () {},
    ),
    maxWidth: 340,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. Full-bleed product card (image ref: Alphonso Mango — right variant)
//
//    Tall portrait media — gradient scrim as FluxBackground — three overlays
//    (discount badge, price badge, product info block) — "Add to cart" footer
//    on orange card background.
// ─────────────────────────────────────────────────────────────────────────────

@widgetbook.UseCase(
  name: 'Product card (full bleed)',
  type: FluxCard,
  path: '[Flux Card]/Compositions',
)
Widget buildFullBleedProductUseCase(BuildContext context) {
  return previewSurface(
    context,
    FluxCard(
      media: FluxMedia(
        aspectRatio: 0.82,
        alignment: .topCenter,
        child: Ink.image(
          image: const NetworkImage(
            'https://static.vecteezy.com/system/resources/thumbnails/033/151/970/small/mango-in-woven-basket-png.png',
          ),
          fit: BoxFit.contain,
        ),
      ),
      backgrounds: [
        FluxBackground.gradient(
          gradient: const LinearGradient(
            colors: [Colors.transparent, Colors.black54],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.38, 1.0],
          ),
          targets: const {FluxTarget.media},
        ),
      ],
      overlays: [
        // "20% off" — top-left.
        FluxOverlay(
          targets: const {FluxTarget.media},
          alignment: Alignment.topLeft,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: _Pill(label: '20% off', bg: Colors.black45),
            ),
          ],
        ),
        // Price — top-right.
        FluxOverlay(
          targets: const {FluxTarget.media},
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: _Pill(label: '₹270', bg: Colors.black87, bold: true),
            ),
          ],
        ),
        // Product name + description + tags — bottom-left.
        FluxOverlay(
          targets: const {FluxTarget.media},
          alignment: Alignment.bottomLeft,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Alphonso',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Loved worldwide for their sweetness our\nAlphonso mangoes are a delicious delight.',
                    style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _Pill(label: 'Best Seller', bg: Colors.black38, border: Colors.white24),
                      const SizedBox(width: 8),
                      const Text('9 left', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      footer: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: const Text(
            'Add to cart',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
      theme: const FluxCardThemeData(
        cardColor: Color(0xFFE69520),
        borderRadius: BorderRadius.all(Radius.circular(26)),
        padding: EdgeInsets.all(14),
        spacing: 12,
      ),
      onTap: () {},
    ),
    maxWidth: 310,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. Property listing (image ref: Ubud Villa / Sakura Ryokan)
//
//    Landscape media — badge + rating + carousel-dots overlays — FluxSection
//    header + body description + footer price and action buttons —
//    knob to switch between two properties.
// ─────────────────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Property listing', type: FluxCard, path: '[Flux Card]/Compositions')
Widget buildPropertyListingUseCase(BuildContext context) {
  final idx = context.knobs.object.segmented<int>(
    label: 'Property',
    options: const [0, 1],
    labelBuilder: (i) => i == 0 ? 'Ubud Villa' : 'Sakura Ryokan',
  );

  const props = [
    _PropertyData(
      image: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=900',
      badge: 'Top Rated Host',
      rating: '9.2/10 ★',
      title: 'The Ubud Jungle Villa',
      location: 'Located in Ubud, Bali, Indonesia',
      description:
          'Perched above the lush tropical rainforest, this open-air Balinese villa features thatched roofs, bamboo, and breathtaking panoramic views.',
      price: 'From Rp3,200,000 / night',
      ctaLabel: 'Book Now',
    ),
    _PropertyData(
      image: 'https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=900',
      badge: null,
      rating: '9.2/10 ★',
      title: 'The Sakura Garden Ryokan',
      location: 'Located in Kyoto, Japan',
      description:
          'Experience timeless Japanese hospitality in this traditional ryokan surrounded by blooming sakura trees and peaceful zen gardens.',
      price: 'From ¥27,000 / night',
      ctaLabel: 'Reserve this place',
    ),
  ];

  final p = props[idx];

  return previewSurface(
    context,
    FluxCard(
      media: FluxMedia(
        aspectRatio: 16 / 11,
        borderRadius: BorderRadius.circular(16.0),
        padding: EdgeInsets.all(8.0),
        // child: CachedNetworkImage(
        //   imageUrl: p.image,
        //   placeholder: (context, url) => CircularProgressIndicator(),
        //   errorWidget: (context, url, error) => Icon(Icons.error),
        //   fit: BoxFit.cover,
        // ),
        child: Material(
          color: Colors.transparent,
          child: Ink.image(image: CachedNetworkImageProvider(p.image), fit: BoxFit.fill),
        ),
      ),
      overlays: [
        if (p.badge != null)
          FluxOverlay(
            targets: const {FluxTarget.media},
            alignment: Alignment.topLeft,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: _Pill(label: p.badge!, bg: Colors.black87),
              ),
            ],
          ),
        FluxOverlay(
          targets: const {FluxTarget.media},
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: _Pill(label: p.rating, bg: Colors.black87),
            ),
          ],
        ),
        // Carousel indicator dots — bottom-centre.
        const FluxOverlay(
          targets: {FluxTarget.media},
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: _CarouselDots(count: 4, active: 0),
            ),
          ],
        ),
      ],
      header: FluxSection(
        title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        subtitle: Text(p.location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        padding: EdgeInsets.zero,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p.description,
            style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 28),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Read more', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
      footer: FluxSection(
        title: Text(p.price, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        actions: [
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            child: const Text('Add to Favorites', style: TextStyle(fontSize: 13)),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            child: Text(p.ctaLabel, style: const TextStyle(fontSize: 13)),
          ),
        ],
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated.copyWith(
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        padding: const EdgeInsets.all(14),
      ),
      onTap: () {},
    ),
    maxWidth: 380,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. Event ticket — FluxNotch + FluxDivider API showcase
// ─────────────────────────────────────────────────────────────────────────────

@widgetbook.UseCase(name: 'Event ticket', type: FluxCard, path: '[Flux Card]/Compositions')
Widget buildEventTicketUseCase(BuildContext context) {
  final loading = context.knobs.boolean(label: 'Loading');

  return previewSurface(
    context,
    FluxCard(
      loading: loading,

      decoration: BoxDecoration(),

      media: FluxMedia(
        aspectRatio: 16 / 8,
        child: Ink.image(
          image: const NetworkImage(
            'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=1200',
          ),
          fit: BoxFit.cover,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black54],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ),

      overlays: [
        FluxOverlay(
          targets: const {FluxTarget.media},
          alignment: Alignment.bottomLeft,
          children: [_Pill(label: 'LIVE', bg: Colors.red)],
        ),
      ],

      backgrounds: [
        FluxBackground.color(color: Colors.green, targets: {.header}),
        FluxBackground.color(color: Colors.red, targets: {.footer}),
      ],

      // divider: FluxDivider(
      //   afterHeader: FluxDashedDivider()
      // ),

      header: const FluxSection(
        title: Text('Flutter Dev Summit 2026', style: TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text('San Francisco Convention Center'),
        decoration: BoxDecoration(color: Colors.amber),
        padding: EdgeInsets.zero,
      ),

      footer: const FluxSection(
        actions: [
          Text('Sat 18 Apr 2026 • 9:00 AM', style: TextStyle(fontWeight: FontWeight.w600)),
          Chip(label: Text('General Admission')),
          Text('Gate C4'),
        ],
        decoration: BoxDecoration(color: Colors.amber),
        padding: EdgeInsets.zero,
      ),

      notch: const FluxNotch(
        boundary: FluxSlotBoundary.afterHeader,
        notchRadius: 8,
        side: BorderSide(width: 2, color: Colors.black),
      ),

      //divider: const FluxDivider(afterHeader: FluxDashedDivider()),

      theme: FluxCardThemeData.outlined.copyWith(
        borderSide: const BorderSide(width: 2, color: Colors.black),
        padding: EdgeInsets.all(64),
      ),

      onTap: () {},
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared helper widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Small stat column used in the freelancer card footer.
class _StatCol extends StatelessWidget {
  const _StatCol({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }
}

/// Stat column used in the creator profile media overlay (white text).
class _CreatorStat extends StatelessWidget {
  const _CreatorStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
        ),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }
}

/// Icon + text row for the pricing card feature list.
class _PricingFeature extends StatelessWidget {
  const _PricingFeature({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color.withOpacity(0.65)),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(color: color, fontSize: 14)),
      ],
    );
  }
}

/// Rounded pill badge — used across multiple cards.
class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.bg, this.border, this.bold = false});

  final String label;
  final Color bg;
  final Color? border;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: border != null ? Border.all(color: border!) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
  }
}

/// Horizontal carousel dot indicator for the property listing card.
class _CarouselDots extends StatelessWidget {
  const _CarouselDots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final on = i == active;
        return Container(
          width: on ? 18 : 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: on ? Colors.white : Colors.white54,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data class
// ─────────────────────────────────────────────────────────────────────────────

class _PropertyData {
  const _PropertyData({
    required this.image,
    required this.badge,
    required this.rating,
    required this.title,
    required this.location,
    required this.description,
    required this.price,
    required this.ctaLabel,
  });

  final String image;
  final String? badge;
  final String rating;
  final String title;
  final String location;
  final String description;
  final String price;
  final String ctaLabel;
}
