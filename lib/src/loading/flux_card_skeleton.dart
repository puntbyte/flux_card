import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../core/theme.dart';
import '../components/flux_media.dart';
import '../layout/flux_card_layout.dart';
import '../layout/slot_resolver.dart';

/// Built-in loading skeleton for [FluxCard].
///
/// Mirrors the card's slot structure with grey placeholder boxes and an
/// animated shimmer sweep — no external packages required.
///
/// ### Integrating external shimmer packages
///
/// Use the [loadingWrapper] callback on [FluxCard] to wrap the skeleton with
/// a package like `shimmer` or `skeletonizer`:
///
/// ```dart
/// // With the 'shimmer' package:
/// FluxCard(
///   loading: true,
///   loadingWrapper: (context, skeleton) => Shimmer.fromColors(
///     baseColor: Colors.grey.shade300,
///     highlightColor: Colors.grey.shade100,
///     child: skeleton,
///   ),
/// )
///
/// // With the 'skeletonizer' package (wrap the whole card instead):
/// Skeletonizer(
///   enabled: isLoading,
///   child: FluxCard(...),
/// )
/// ```
class FluxCardSkeleton extends StatefulWidget {
  const FluxCardSkeleton({
    super.key,
    required this.layout,
    required this.mediaPosition,
    required this.theme,
    this.hasMedia = true,
    this.hasHeader = true,
    this.hasBody = true,
    this.hasFooter = false,
    this.loadingWrapper,
  });

  final FluxLayoutMode layout;
  final FluxMediaPosition mediaPosition;
  final FluxCardThemeData theme;
  final bool hasMedia;
  final bool hasHeader;
  final bool hasBody;
  final bool hasFooter;

  /// Optional wrapper that receives the skeleton widget and can apply an
  /// external shimmer effect around it.
  final Widget Function(BuildContext context, Widget skeleton)? loadingWrapper;

  @override
  State<FluxCardSkeleton> createState() => _FluxCardSkeletonState();
}

class _FluxCardSkeletonState extends State<FluxCardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _animation = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skeleton = _buildSkeleton(context);
    if (widget.loadingWrapper != null) {
      return widget.loadingWrapper!(context, skeleton);
    }
    return _ShimmerLayer(animation: _animation, child: skeleton);
  }

  Widget _buildSkeleton(BuildContext context) {
    final p = widget.theme.padding;
    final s = widget.theme.spacing;

    Widget? mediaSlot;
    if (widget.hasMedia) {
      mediaSlot = FluxMedia(
        aspectRatio: 16 / 9,
        child: _SkeletonBox(borderRadius: 0, color: _baseColor(context)),
      );
    }

    Widget? headerSlot;
    if (widget.hasHeader) {
      headerSlot = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _SkeletonBox(
            height: 14,
            widthFraction: 0.6,
            color: _baseColor(context),
          ),
          SizedBox(height: s / 2),
          _SkeletonBox(
            height: 11,
            widthFraction: 0.4,
            color: _baseColor(context),
          ),
        ],
      );
    }

    Widget? bodySlot;
    if (widget.hasBody) {
      bodySlot = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _SkeletonBox(height: 11, color: _baseColor(context)),
          SizedBox(height: s / 3),
          _SkeletonBox(
            height: 11,
            widthFraction: 0.75,
            color: _baseColor(context),
          ),
        ],
      );
    }

    Widget? footerSlot;
    if (widget.hasFooter) {
      footerSlot = Row(
        children: [
          _SkeletonBox(
            height: 32,
            widthFraction: 0.35,
            borderRadius: 8,
            color: _baseColor(context),
          ),
          SizedBox(width: s),
          _SkeletonBox(
            height: 32,
            widthFraction: 0.25,
            borderRadius: 8,
            color: _baseColor(context),
          ),
        ],
      );
    }

    return FluxCardLayout(
      mode: widget.layout == FluxLayoutMode.responsive
          ? FluxLayoutMode.column
          : widget.layout,
      mediaPosition: widget.mediaPosition,
      theme: widget.theme,
      resolvedPadding: EdgeInsets.all(8),
    ).build(allBackgrounds: [], allOverlays: []);
    //     .build(
    //   mediaSlot: mediaSlot,
    //   headerSlot: headerSlot != null
    //       ? Padding(padding: p, child: headerSlot)
    //       : null,
    //   bodySlot: bodySlot != null ? Padding(padding: p, child: bodySlot) : null,
    //   footerSlot: footerSlot != null
    //       ? Padding(padding: p, child: footerSlot)
    //       : null,
    // );
  }

  Color _baseColor(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHighest;
}

// ── Internal helpers ──────────────────────────────────────────────────────────

/// A single placeholder rectangle with optional fractional width.
class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    this.height = 14,
    this.widthFraction,
    this.borderRadius = 4,
    required this.color,
  });

  final double height;
  final double? widthFraction;
  final double borderRadius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Widget box = Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    if (widthFraction != null) {
      box = FractionallySizedBox(widthFactor: widthFraction, child: box);
    }

    return box;
  }
}

/// Animates a shimmer gradient sweep over [child].
class _ShimmerLayer extends StatelessWidget {
  const _ShimmerLayer({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surface;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final v = animation.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [base, highlight, base],
            stops: [
              (v - 0.4).clamp(0.0, 1.0),
              v.clamp(0.0, 1.0),
              (v + 0.4).clamp(0.0, 1.0),
            ],
          ).createShader(bounds),
          child: child,
        );
      },
    );
  }
}
