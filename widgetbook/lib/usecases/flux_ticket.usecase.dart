import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../shared/preview_surface.dart';

@widgetbook.UseCase(name: 'Basic ticket', type: FluxTicketShape, path: '[Flux Card]/Ticket Shape')
Widget buildTicketBasicUseCase(BuildContext context) {
  final notchRadius = context.knobs.double.slider(
    label: 'Notch radius',
    min: 6,
    max: 28,
    divisions: 22,
    initialValue: 14,
  );
  final notchPosition = context.knobs.double.slider(
    label: 'Notch position',
    min: 0.1,
    max: 0.9,
    divisions: 16,
    initialValue: 0.65,
  );
  final side = context.knobs.object.segmented<FluxNotchSide>(
    label: 'Notch side',
    options: FluxNotchSide.values,
    labelBuilder: (s) => s.name,
  );

  return previewSurface(
    context,
    FluxCard(
      media: FluxMedia(
        aspectRatio: 16 / 7,
        child: Image.network(
          'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=1200',
          fit: BoxFit.cover,
        ),
      ),
      header: const FluxSection(
        title: Text('Tokyo — Haneda Airport'),
        subtitle: Text('Boarding Gate B12 • 14:35'),
        padding: EdgeInsets.zero,
      ),
      body: _TicketDivider(notchRadius: notchRadius),
      footer: FluxSection(
        actions: const [
          Text('Seat 12A', style: TextStyle(fontWeight: FontWeight.w700)),
          Text('Economy'),
          Chip(label: Text('Confirmed')),
        ],
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated.copyWith(
        shape: FluxTicketShape(
          notchRadius: notchRadius,
          notchPosition: notchPosition,
          notchEdge: FluxNotchEdge.vertical,
          notchSide: side,
        ),
        padding: const EdgeInsets.all(20),
      ),
    ),
    maxWidth: 400,
  );
}

@widgetbook.UseCase(
  name: 'Horizontal ticket', type: FluxTicketShape, path: '[Flux Card]/Ticket Shape',
)
Widget buildTicketHorizontalUseCase(BuildContext context) {
  final notchRadius = context.knobs.double.slider(
    label: 'Notch radius',
    min: 6,
    max: 28,
    divisions: 22,
    initialValue: 14,
  );
  final notchPosition = context.knobs.double.slider(
    label: 'Notch position',
    min: 0.1,
    max: 0.9,
    divisions: 16,
    initialValue: 0.5,
  );

  return previewSurface(
    context,
    FluxCard(
      layout: FluxLayoutMode.column,
      header: const FluxSection(
        title: Text('CONCERT TICKET'),
        subtitle: Text('The Flutter Experience — Live'),
        padding: EdgeInsets.zero,
      ),
      body: _HorizontalTicketDivider(notchRadius: notchRadius),
      footer: FluxSection(
        actions: const [
          Text('Fri 18 Apr 2026 • 8:00 PM', style: TextStyle(fontWeight: FontWeight.w600)),
          Text('General Admission'),
        ],
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.elevated.copyWith(
        shape: FluxTicketShape(
          notchRadius: notchRadius,
          notchPosition: notchPosition,
          notchEdge: FluxNotchEdge.horizontal,
          notchSide: FluxNotchSide.both,
        ),
        padding: const EdgeInsets.all(20),
      ),
    ),
    maxWidth: 360,
  );
}

@widgetbook.UseCase(
  name: 'Outlined ticket', type: FluxTicketShape, path: '[Flux Card]/Ticket Shape',
)
Widget buildTicketOutlinedUseCase(BuildContext context) {
  final notchRadius = context.knobs.double.slider(
    label: 'Notch radius',
    min: 6,
    max: 24,
    divisions: 18,
    initialValue: 12,
  );

  return previewSurface(
    context,
    FluxCard(
      backgrounds: const [
        FluxBackground.gradient(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ],
      foregroundColor: Colors.white,
      header: const FluxSection(
        title: Text('BOARDING PASS'),
        subtitle: Text('Singapore → London • SQ321'),
        padding: EdgeInsets.zero,
      ),
      body: _TicketDivider(notchRadius: notchRadius, color: Colors.white24),
      footer: const FluxSection(
        actions: [
          Text('SQ 321', style: TextStyle(fontWeight: FontWeight.w700)),
          Text('Business Class'),
          Text('Seat 3K'),
        ],
        padding: EdgeInsets.zero,
      ),
      theme: FluxCardThemeData.standard.copyWith(
        cardColor: const Color(0xFF0F172A),
        shape: FluxTicketShape(
          notchRadius: notchRadius,
          notchSide: FluxNotchSide.both,
          side: const BorderSide(color: Colors.white24),
        ),
        padding: const EdgeInsets.all(20),
      ),
    ),
    maxWidth: 380,
  );
}

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Dotted divider that visually aligns with the ticket notches.
class _TicketDivider extends StatelessWidget {
  const _TicketDivider({required this.notchRadius, this.color});
  final double notchRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).dividerColor;
    return Padding(
      // Inset the dashes so they start/end where the notch circles begin.
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: notchRadius),
      child: Row(
        children: List.generate(
          24,
          (i) => Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              color: i.isEven ? c : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}

class _HorizontalTicketDivider extends StatelessWidget {
  const _HorizontalTicketDivider({required this.notchRadius});
  final double notchRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: notchRadius),
      child: Row(
        children: List.generate(
          24,
          (i) => Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              color: i.isEven ? Theme.of(context).dividerColor : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
