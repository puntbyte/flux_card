import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../shared/preview_surface.dart';

@widgetbook.UseCase(name: 'Built-in skeleton', type: FluxCardSkeleton, path: '[Flux Card]/Loading')
Widget buildLoadingSkeletonUseCase(BuildContext context) {
  final layout = context.knobs.object.segmented<FluxLayoutMode>(
    label: 'Layout',
    options: const [FluxLayoutMode.column, FluxLayoutMode.row, FluxLayoutMode.inColumn],
    labelBuilder: (m) => m.name,
  );
  final hasMedia = context.knobs.boolean(label: 'Has media', initialValue: true);
  final hasFooter = context.knobs.boolean(label: 'Has footer');

  return previewSurface(
    context,
    FluxCard(
      loading: true,
      layout: layout,
      // Provide real slots so skeleton mirrors what the loaded card looks like.
      media: hasMedia ? const SizedBox() : null,
      header: const SizedBox(),
      body: const SizedBox(),
      footer: hasFooter ? const SizedBox() : null,
      theme: FluxCardThemeData.elevated,
    ),
    maxWidth: layout == FluxLayoutMode.row ? 480 : 380,
  );
}

@widgetbook.UseCase(
  name: 'Toggle loaded / loading', type: FluxCardSkeleton, path: '[Flux Card]/Loading',
)
Widget buildLoadingToggleUseCase(BuildContext context) {
  final loading = context.knobs.boolean(label: 'Loading', initialValue: true);

  return previewSurface(
    context,
    FluxCard(
      loading: loading,
      media: FluxMedia(
        aspectRatio: 16 / 9,
        child: Image.network(
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
          fit: BoxFit.cover,
        ),
      ),
      header: const FluxSection(
        title: Text('Air Max 270'),
        subtitle: Text('Nike • 4.7 ★'),
        padding: EdgeInsets.zero,
      ),
      body: const Text('Running • Sport'),
      footer: FluxSection(
        actions: [
          const Text('\$150', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          ElevatedButton(onPressed: () {}, child: const Text('Add to cart')),
        ],
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated,
      onTap: () {},
    ),
    maxWidth: 380,
  );
}

@widgetbook.UseCase(
  name: 'External shimmer bridge', type: FluxCardSkeleton, path: '[Flux Card]/Loading',
)
Widget buildLoadingExternalShimmerUseCase(BuildContext context) {
  // Demonstrates the loadingWrapper pattern for integrating packages like
  // 'shimmer' without depending on them here.
  // Replace the Container below with: Shimmer.fromColors(baseColor:..., child: skeleton)
  return previewSurface(
    context,
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'loadingWrapper simulates an external shimmer package.\n'
            'Replace the wrapper with Shimmer.fromColors(...) from the shimmer package.',
            style: TextStyle(fontSize: 12),
          ),
        ),
        FluxCard(
          loading: true,
          media: const SizedBox(),
          header: const SizedBox(),
          body: const SizedBox(),
          footer: const SizedBox(),
          theme: FluxCardThemeData.elevated,
          loadingWrapper: (context, skeleton) {
            // Simulated external wrapper — replace with actual shimmer package.
            return _FakeShimmerWrapper(child: skeleton);
          },
        ),
      ],
    ),
    maxWidth: 380,
  );
}

/// Stand-in for an external shimmer package in this demo.
/// In production, replace with `Shimmer.fromColors(...)` or similar.
class _FakeShimmerWrapper extends StatefulWidget {
  const _FakeShimmerWrapper({required this.child});
  final Widget child;

  @override
  State<_FakeShimmerWrapper> createState() => _FakeShimmerWrapperState();
}

class _FakeShimmerWrapperState extends State<_FakeShimmerWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(
        opacity: 0.4 + 0.6 * _ctrl.value,
        child: child,
      ),
      child: widget.child,
    );
  }
}
