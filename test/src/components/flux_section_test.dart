import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flux_card/flux_card.dart';

void main() {
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: child));

  // ---------------------------------------------------------------------------
  // Default constructor
  // ---------------------------------------------------------------------------

  group('FluxSection — default constructor', () {
    testWidgets('renders title, subtitle, and description', (tester) async {
      await tester.pumpWidget(wrap(const FluxSection(
        title: Text('Title'),
        subtitle: Text('Subtitle'),
        description: Text('Description'),
        padding: EdgeInsets.all(8),
      )));
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('renders leading widget', (tester) async {
      await tester.pumpWidget(wrap(const FluxSection(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text('With leading'),
      )));
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('With leading'), findsOneWidget);
    });

    testWidgets('renders trailing widgets', (tester) async {
      await tester.pumpWidget(wrap(const FluxSection(
        title: Text('With trailing'),
        trailing: [Chip(label: Text('PRO')), Icon(Icons.star)],
      )));
      expect(find.byType(Chip), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('renders child between header and actions', (tester) async {
      await tester.pumpWidget(wrap(const FluxSection(
        title: Text('Header'),
        child: Text('free-form child'),
        actions: [Text('action')],
      )));
      expect(find.text('Header'), findsOneWidget);
      expect(find.text('free-form child'), findsOneWidget);
      expect(find.text('action'), findsOneWidget);
    });

    testWidgets('renders actions as Wrap', (tester) async {
      await tester.pumpWidget(wrap(FluxSection(
        actions: [
          ElevatedButton(onPressed: () {}, child: const Text('Primary')),
          OutlinedButton(onPressed: () {}, child: const Text('Secondary')),
        ],
        padding: const EdgeInsets.all(8),
      )));
      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('Secondary'), findsOneWidget);
    });

    testWidgets('returns SizedBox.shrink when all fields are null', (tester) async {
      await tester.pumpWidget(wrap(const FluxSection()));
      // SizedBox.shrink has size 0x0
      final size = tester.getSize(find.byType(FluxSection));
      expect(size, Size.zero);
    });

    testWidgets('applies padding', (tester) async {
      await tester.pumpWidget(wrap(const FluxSection(
        title: Text('padded'),
        padding: EdgeInsets.all(24),
      )));
      final padding = tester.widget<Padding>(
        find.ancestor(of: find.text('padded'), matching: find.byType(Padding)).first,
      );
      expect(padding.padding, const EdgeInsets.all(24));
    });

    testWidgets('applies decoration', (tester) async {
      await tester.pumpWidget(wrap(FluxSection(
        title: const Text('decorated'),
        decoration: BoxDecoration(color: Colors.blue.shade50),
        padding: const EdgeInsets.all(8),
      )));
      expect(find.byType(Ink), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // .header constructor
  // ---------------------------------------------------------------------------

  group('FluxSection.header', () {
    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpWidget(wrap(const FluxSection.header(
        title: Text('Header title'),
        subtitle: Text('Header subtitle'),
        padding: EdgeInsets.all(8),
      )));
      expect(find.text('Header title'), findsOneWidget);
      expect(find.text('Header subtitle'), findsOneWidget);
    });

    testWidgets('trailing chips appear in header row', (tester) async {
      await tester.pumpWidget(wrap(const FluxSection.header(
        title: Text('Pro Plan'),
        trailing: [Chip(label: Text('NEW'))],
      )));
      expect(find.byType(Chip), findsOneWidget);
    });

    testWidgets('implements FluxSlotWrapper — externalPaddingOverride matches margin', (tester) async {
      const section = FluxSection.header(
        title: Text('bleed'),
        margin: EdgeInsets.zero,
      );
      expect(section.externalPaddingOverride, EdgeInsets.zero);
    });
  });

  // ---------------------------------------------------------------------------
  // .footer constructor
  // ---------------------------------------------------------------------------

  group('FluxSection.footer', () {
    testWidgets('renders actions', (tester) async {
      await tester.pumpWidget(wrap(FluxSection.footer(
        actions: [
          const Text('\$49.99'),
          ElevatedButton(onPressed: () {}, child: const Text('Buy')),
        ],
        padding: const EdgeInsets.all(8),
      )));
      expect(find.text('\$49.99'), findsOneWidget);
      expect(find.text('Buy'), findsOneWidget);
    });

    testWidgets('actionsAlignment positions actions correctly', (tester) async {
      await tester.pumpWidget(wrap(FluxSection.footer(
        actionsAlignment: MainAxisAlignment.end,
        actions: [ElevatedButton(onPressed: () {}, child: const Text('End'))],
        padding: const EdgeInsets.all(8),
      )));
      expect(find.text('End'), findsOneWidget);
    });

    testWidgets('returns SizedBox.shrink when actions is empty', (tester) async {
      await tester.pumpWidget(wrap(const FluxSection.footer()));
      final size = tester.getSize(find.byType(FluxSection));
      expect(size, Size.zero);
    });

    testWidgets('implements FluxSlotWrapper — externalPaddingOverride matches margin', (tester) async {
      const section = FluxSection.footer(
        margin: EdgeInsets.symmetric(horizontal: 16),
      );
      expect(section.externalPaddingOverride, const EdgeInsets.symmetric(horizontal: 16));
    });
  });

  // ---------------------------------------------------------------------------
  // Full bleed pattern
  // ---------------------------------------------------------------------------

  group('FluxSection — full bleed via margin', () {
    testWidgets('margin: EdgeInsets.zero causes externalPaddingOverride to be zero', (tester) async {
      await tester.pumpWidget(wrap(FluxCard(
        theme: FluxCardThemeData.elevated.copyWith(
          padding: const EdgeInsets.all(20),
        ),
        header: const FluxSection.header(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.all(20),
          title: Text('Full bleed'),
        ),
        body: const Text('padded body'),
      )));
      expect(find.text('Full bleed'), findsOneWidget);
      expect(find.text('padded body'), findsOneWidget);
    });
  });
}