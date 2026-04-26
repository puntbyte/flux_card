import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

const int itemCount = 1000;
const int scrollIterations = 80;
const int benchmarkRuns = 5;
const double scrollDelta = 260;

void main() {
  group('FluxCard vs vanilla layout benchmark', () {
    testWidgets(
      'ListView scroll benchmark',
          (tester) async {
        final fluxStats = await _measureScenario(
          tester,
          label: 'FluxCard ListView',
          runs: benchmarkRuns,
          childBuilder: () => _BenchmarkList(
            key: const Key('flux-list'),
            itemBuilder: _buildFluxListItem,
          ),
        );

        final vanillaStats = await _measureScenario(
          tester,
          label: 'Vanilla ListView',
          runs: benchmarkRuns,
          childBuilder: () => _BenchmarkList(
            key: const Key('vanilla-list'),
            itemBuilder: _buildVanillaListItem,
          ),
        );

        _printComparison(fluxStats, vanillaStats);

        expect(fluxStats.medianMs, greaterThanOrEqualTo(0));
        expect(vanillaStats.medianMs, greaterThanOrEqualTo(0));
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );

    testWidgets(
      'GridView scroll benchmark',
          (tester) async {
        final fluxStats = await _measureScenario(
          tester,
          label: 'FluxCard GridView',
          runs: benchmarkRuns,
          childBuilder: () => _BenchmarkGrid(
            key: const Key('flux-grid'),
            itemBuilder: _buildFluxGridItem,
          ),
        );

        final vanillaStats = await _measureScenario(
          tester,
          label: 'Vanilla GridView',
          runs: benchmarkRuns,
          childBuilder: () => _BenchmarkGrid(
            key: const Key('vanilla-grid'),
            itemBuilder: _buildVanillaGridItem,
          ),
        );

        _printComparison(fluxStats, vanillaStats);

        expect(fluxStats.medianMs, greaterThanOrEqualTo(0));
        expect(vanillaStats.medianMs, greaterThanOrEqualTo(0));
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );
  });
}

Future<_ScenarioStats> _measureScenario(
    WidgetTester tester, {
      required String label,
      required int runs,
      required Widget Function() childBuilder,
    }) async {
  final results = <_BenchmarkRunResult>[];

  for (var run = 0; run < runs; run++) {
    await _reset(tester);

    final result = await _measureSingleRun(
      tester,
      label: label,
      runNumber: run + 1,
      child: childBuilder(),
    );

    results.add(result);
  }

  return _ScenarioStats(
    label: label,
    results: results,
  );
}

Future<_BenchmarkRunResult> _measureSingleRun(
    WidgetTester tester, {
      required String label,
      required int runNumber,
      required Widget child,
    }) async {
  final scrollKey = UniqueKey();

  await tester.pumpWidget(
    _BenchmarkApp(
      child: KeyedSubtree(
        key: scrollKey,
        child: child,
      ),
    ),
  );

  await tester.pumpAndSettle();

  // Warm-up so first build/layout cost does not dominate the measurement.
  for (var i = 0; i < 8; i++) {
    await tester.drag(find.byKey(scrollKey), const Offset(0, -scrollDelta));
    await tester.pump();
  }

  final stopwatch = Stopwatch()..start();

  for (var i = 0; i < scrollIterations; i++) {
    // Alternate scroll direction every few iterations so we do not spend most
    // of the benchmark stuck at the bottom of the list/grid.
    final direction = (i ~/ 10).isEven ? -scrollDelta : scrollDelta;

    await tester.drag(find.byKey(scrollKey), Offset(0, direction));
    await tester.pump();
  }

  stopwatch.stop();

  return _BenchmarkRunResult(
    label: label,
    runNumber: runNumber,
    totalMs: stopwatch.elapsedMicroseconds / 1000.0,
    iterations: scrollIterations,
  );
}

Future<void> _reset(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}

void _printComparison(_ScenarioStats flux, _ScenarioStats vanilla) {
  final medianRatio = vanilla.medianMs == 0 ? 0.0 : flux.medianMs / vanilla.medianMs;
  final meanRatio = vanilla.meanMs == 0 ? 0.0 : flux.meanMs / vanilla.meanMs;

  debugPrint('');
  debugPrint('================ BENCHMARK ================');
  debugPrint(flux.summary);
  debugPrint(vanilla.summary);
  debugPrint('');
  debugPrint('Median ratio: ${medianRatio.toStringAsFixed(2)}x');
  debugPrint('Mean ratio:   ${meanRatio.toStringAsFixed(2)}x');
  debugPrint('===========================================');
  debugPrint('');
}

class _BenchmarkRunResult {
  const _BenchmarkRunResult({
    required this.label,
    required this.runNumber,
    required this.totalMs,
    required this.iterations,
  });

  final String label;
  final int runNumber;
  final double totalMs;
  final int iterations;

  double get averageMs => totalMs / iterations;
}

class _ScenarioStats {
  const _ScenarioStats({
    required this.label,
    required this.results,
  });

  final String label;
  final List<_BenchmarkRunResult> results;

  List<double> get totals => results.map((r) => r.totalMs).toList();

  double get medianMs => _median(totals);

  double get meanMs => totals.reduce((a, b) => a + b) / totals.length;

  double get minMs => totals.reduce(math.min);

  double get maxMs => totals.reduce(math.max);

  double get medianPerPumpMs => medianMs / scrollIterations;

  double get meanPerPumpMs => meanMs / scrollIterations;

  String get summary {
    final runText = results
        .map((r) => 'run ${r.runNumber}: ${r.totalMs.toStringAsFixed(2)}ms')
        .join(', ');

    return '''
$label
  runs:   $runText
  median: ${medianMs.toStringAsFixed(2)}ms total, ${medianPerPumpMs.toStringAsFixed(3)}ms / pump
  mean:   ${meanMs.toStringAsFixed(2)}ms total, ${meanPerPumpMs.toStringAsFixed(3)}ms / pump
  min:    ${minMs.toStringAsFixed(2)}ms
  max:    ${maxMs.toStringAsFixed(2)}ms''';
  }

  static double _median(List<double> values) {
    final sorted = [...values]..sort();

    final middle = sorted.length ~/ 2;

    if (sorted.length.isOdd) {
      return sorted[middle];
    }

    return (sorted[middle - 1] + sorted[middle]) / 2.0;
  }
}

double _median(List<double> values) => _ScenarioStats._median(values);

class _BenchmarkApp extends StatelessWidget {
  const _BenchmarkApp({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        extensions: const [
          FluxCardThemeData.elevated,
        ],
      ),
      home: Scaffold(
        body: SizedBox.expand(
          child: child,
        ),
      ),
    );
  }
}

class _BenchmarkList extends StatelessWidget {
  const _BenchmarkList({
    super.key,
    required this.itemBuilder,
  });

  final Widget Function(int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: itemBuilder(index),
        );
      },
    );
  }
}

class _BenchmarkGrid extends StatelessWidget {
  const _BenchmarkGrid({
    super.key,
    required this.itemBuilder,
  });

  final Widget Function(int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) => itemBuilder(index),
    );
  }
}

Widget _buildFluxListItem(int index) {
  return FluxCard(
    layout: FluxLayoutMode.row,
    media: _BenchmarkMedia(width: 96, height: 96, index: index),
    header: FluxSection(
      title: Text(
        'Flux item $index',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: const Text(
        'Structured card layout',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      padding: EdgeInsets.zero,
    ),
    body: const Text(
      'Reusable slots, media, content, and footer composition.',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    footer: FluxSection.footer(
      padding: EdgeInsets.zero,
      actions: const [
        Chip(label: Text('Tag')),
        Chip(label: Text('Fast')),
      ],
    ),
    overlays: const [
      FluxOverlay(
        targets: {FluxTarget.media},
        alignment: Alignment.topRight,
        padding: EdgeInsets.all(6),
        children: [
          _SmallBadge(label: '★'),
        ],
      ),
    ],
    theme: FluxCardThemeData.elevated.copyWith(
      padding: const EdgeInsets.all(12),
      spacing: 8,
    ),
  );
}

Widget _buildVanillaListItem(int index) {
  return Card(
    elevation: 4,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              _BenchmarkMediaBox(width: 96, height: 96, index: index),
              const Padding(
                padding: EdgeInsets.all(6),
                child: _SmallBadge(label: '★'),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vanilla item $index',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Manual card layout',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Reusable slots, media, content, and footer composition.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text('Tag')),
                    Chip(label: Text('Fast')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildFluxGridItem(int index) {
  return FluxCard(
    media: _BenchmarkMedia(aspectRatio: 4 / 3, index: index),
    header: FluxSection(
      title: Text(
        'Flux product $index',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: const Text(
        'Grid benchmark',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      padding: EdgeInsets.zero,
    ),
    body: const Text(
      'Slot-based product card with media and footer.',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    footer: const Row(
      children: [
        Text('\$49'),
        Spacer(),
        _SmallBadge(label: 'Buy'),
      ],
    ),
    overlays: const [
      FluxOverlay(
        targets: {FluxTarget.media},
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(8),
        children: [
          _SmallBadge(label: 'New'),
        ],
      ),
    ],
    theme: FluxCardThemeData.elevated.copyWith(
      padding: const EdgeInsets.all(12),
      spacing: 8,
    ),
  );
}

Widget _buildVanillaGridItem(int index) {
  return Card(
    elevation: 4,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: _BenchmarkMediaBox(index: index),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: _SmallBadge(label: 'New'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Vanilla product $index',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          const Text(
            'Grid benchmark',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          const Text(
            'Slot-based product card with media and footer.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          const Row(
            children: [
              Text('\$49'),
              Spacer(),
              _SmallBadge(label: 'Buy'),
            ],
          ),
        ],
      ),
    ),
  );
}

class _BenchmarkMedia extends StatelessWidget {
  const _BenchmarkMedia({
    this.width,
    this.height,
    this.aspectRatio,
    required this.index,
  });

  final double? width;
  final double? height;
  final double? aspectRatio;
  final int index;

  @override
  Widget build(BuildContext context) {
    return FluxMedia(
      width: width,
      height: height,
      aspectRatio: aspectRatio,
      child: _BenchmarkMediaBox(index: index),
    );
  }
}

class _BenchmarkMediaBox extends StatelessWidget {
  const _BenchmarkMediaBox({
    this.width,
    this.height,
    required this.index,
  });

  final double? width;
  final double? height;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFB4C6FF),
      const Color(0xFFFFC7A6),
      const Color(0xFFBFE8D4),
      const Color(0xFFE5C7FF),
    ];

    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(
        color: colors[index % colors.length],
        child: const Center(
          child: Icon(Icons.image_outlined),
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}