import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../shared/preview_surface.dart';

@widgetbook.UseCase(name: 'Basic ticket', type: FluxNotchShape, path: '[Flux Card]/Ticket Shape')
Widget buildTicketBasicUseCase(BuildContext context) {
  final notchWidth = context.knobs.double.slider(
    label: 'Notch radius',
    min: 6,
    max: 28,
    divisions: 22,
    initialValue: 14,
  );
  final notchSide = context.knobs.object.segmented<FluxNotchSide>(
    label: 'Notch side',
    options: FluxNotchSide.values,
    labelBuilder: (s) => s.name,
  );

  // FluxNotch (targeted) snaps to the afterHeader boundary — no position knob
  // needed. The dashed divider aligns by matching its indent to notchWidth.
  return previewSurface(
    context,
    FluxCard(
      media: FluxMedia(
        aspectRatio: 16 / 7,
        child: Ink.image(
          image: const CachedNetworkImageProvider(
            'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=1200',
          ),
          fit: BoxFit.cover,
        ),
      ),
      header: const FluxSection(
        title: Text('Tokyo — Haneda Airport'),
        subtitle: Text('Boarding Gate B12 • 14:35'),
        padding: EdgeInsets.zero,
      ),
      footer: const FluxSection(
        actions: [
          Text('Seat 12A', style: TextStyle(fontWeight: FontWeight.w700)),
          Text('Economy'),
          Chip(label: Text('Confirmed')),
        ],
        padding: EdgeInsets.zero,
      ),
      notch: FluxNotch(
        boundary: FluxSlotBoundary.afterHeader,
        notchWidth: notchWidth,
        notchSide: notchSide,
      ),
      divider: FluxDivider(
        afterHeader: FluxDashedDivider(indent: notchWidth, endIndent: notchWidth),
      ),
      theme: FluxCardThemeData.elevated.copyWith(padding: const EdgeInsets.all(20)),
      onTap: () {},
    ),
    maxWidth: 400,
  );
}

@widgetbook.UseCase(
  name: 'Horizontal ticket',
  type: FluxNotchShape,
  path: '[Flux Card]/Ticket Shape',
)
Widget buildTicketHorizontalUseCase(BuildContext context) {
  final notchWidth = context.knobs.double.slider(
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

  // Horizontal notches live on top/bottom edges, not aligned to slot
  // boundaries, so FluxNotch.free with a position knob is the natural fit.
  return previewSurface(
    context,
    FluxCard(
      layout: FluxLayoutMode.column,

      header: const FluxSection(
        title: Text('CONCERT TICKET'),
        subtitle: Text('The Flutter Experience — Live'),
        padding: EdgeInsets.zero,
      ),

      footer: const FluxSection(
        actions: [
          Text('Fri 18 Apr 2026 • 8:00 PM', style: TextStyle(fontWeight: FontWeight.w600)),
          Text('General Admission'),
        ],
        padding: EdgeInsets.zero,
      ),

      notch: FluxNotch.free(
        position: notchPosition,
        notchWidth: notchWidth,
        borderRadius: BorderRadius.all(Radius.circular(notchWidth)),
        edge: FluxNotchEdge.horizontal,
        notchSide: FluxNotchSide.both,
      ),

      divider: const FluxDivider(afterHeader: FluxDashedDivider()),
      theme: FluxCardThemeData.elevated.copyWith(padding: const EdgeInsets.all(20)),
      onTap: () {},
    ),
    maxWidth: 360,
  );
}

@widgetbook.UseCase(
  name: 'Outlined ticket',
  type: FluxNotchShape,
  path: '[Flux Card]/Ticket Shape',
)
Widget buildTicketOutlinedUseCase(BuildContext context) {
  final notchWidth = context.knobs.double.slider(
    label: 'Notch radius/depth',
    min: 6,
    max: 24,
    divisions: 18,
    initialValue: 12,
  );

  return previewSurface(
    context,
    FluxCard(
      underlays: [
        FluxUnderlay(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ],
      foregroundColor: Colors.white,
      header: const FluxSection(
        title: Text('BOARDING PASS'),
        subtitle: Text('Singapore → London • SQ321'),
        padding: EdgeInsets.zero,
      ),
      footer: const FluxSection(
        actions: [
          Text('SQ 321', style: TextStyle(fontWeight: FontWeight.w700)),
          Text('Business Class'),
          Text('Seat 3K'),
        ],
        padding: EdgeInsets.zero,
      ),
      notch: FluxNotch(
        boundary: FluxSlotBoundary.afterHeader,
        notchWidth: notchWidth,
        notchDepth: notchWidth,
        notchSide: FluxNotchSide.both,
      ),
      divider: FluxDivider(
        afterHeader: FluxDashedDivider(
          color: Colors.white24,
          indent: notchWidth,
          endIndent: notchWidth,
        ),
      ),
      theme: FluxCardThemeData.standard.copyWith(
        cardColor: const Color(0xFF0F172A),
        padding: const EdgeInsets.all(20),
      ),
      onTap: () {},
    ),
    maxWidth: 380,
  );
}