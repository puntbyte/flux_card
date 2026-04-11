import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../demo/demo_content.dart';
import '../shared/preview_surface.dart';

FluxCardThemeData _themeFromKnob(BuildContext context) {
  return context.knobs.object.segmented<FluxCardThemeData>(
    label: 'Theme',
    options: const [
      FluxCardThemeData.standard,
      FluxCardThemeData.compact,
      FluxCardThemeData.elevated,
    ],
    labelBuilder: (theme) {
      if (theme == FluxCardThemeData.compact) return 'Compact';
      if (theme == FluxCardThemeData.elevated) return 'Elevated';
      return 'Standard';
    },
  );
}

FluxLayoutMode _layoutModeFromKnob(BuildContext context) {
  return context.knobs.object.segmented<FluxLayoutMode>(
    label: 'Layout mode',
    options: FluxLayoutMode.values,
    labelBuilder: (mode) => mode.name,
  );
}

Widget _demoCardShell({
  required BuildContext context,
  required Widget card,
  double maxWidth = 460,
  Color? backgroundColor,
}) {
  return previewSurface(context, card, maxWidth: maxWidth, backgroundColor: backgroundColor);
}

@widgetbook.UseCase(name: 'Interactive card', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildInteractiveCardUseCase(BuildContext context) {
  final layoutMode = _layoutModeFromKnob(context);
  final theme = _themeFromKnob(context);
  final width = context.knobs.double.slider(label: 'Width', min: 280, max: 900, divisions: 62, initialValue: 460);
  final height = context.knobs.double.slider(label: 'Height', min: 220, max: 720, divisions: 50, initialValue: 360);
  final showHeader = context.knobs.boolean(label: 'Show header', initialValue: true);
  final showContent = context.knobs.boolean(label: 'Show content', initialValue: true);
  final showFooter = context.knobs.boolean(label: 'Show footer', initialValue: true);
  final featured = context.knobs.boolean(label: 'Featured badge', initialValue: true);
  final title = context.knobs.string(label: 'Title', initialValue: 'Flux Card with knobs', maxLines: 2);
  final subtitle = context.knobs.string(label: 'Subtitle', initialValue: 'A live playground for the package', maxLines: 2);
  final body = context.knobs.string(
    label: 'Body',
    initialValue: 'Try different layouts, themes, sizes, and states from the knobs panel.',
    maxLines: 5,
  );

  return _demoCardShell(
    context: context,
    maxWidth: width,
    card: FluxCard(
      layout: layoutMode == FluxLayoutMode.responsive ? const FluxCardLayout.responsive() : FluxCardLayout(mode: layoutMode),
      background: const FluxBackground.gradient(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4F46E5), Color(0xFF8B5CF6), Color(0xFFEC4899)],
        ),
      ),
      media: FluxMedia.cover(
        height: layoutMode == FluxLayoutMode.row ? height * 0.7 : height * 0.5,
        aspectRatio: 16 / 10,
        child: Container(
          alignment: Alignment.center,
          child: const FlutterLogo(size: 120),
        ),
      ),
      overlay: featured
          ? const FluxOverlay(
              alignment: Alignment.topLeft,
              children: [
                Chip(
                  label: Text('FEATURED', style: TextStyle(fontSize: 10, color: Colors.white)),
                  backgroundColor: Colors.black87,
                  side: BorderSide.none,
                ),
              ],
            )
          : null,
      header: showHeader
          ? FluxHeader(
              leading: const CircleAvatar(child: Icon(Icons.widgets_outlined)),
              title: Text(title),
              subtitle: Text(subtitle),
              trailing: const [Icon(Icons.more_horiz)],
            )
          : null,
      content: showContent ? Text(body, style: const TextStyle(height: 1.5)) : null,
      footer: showFooter
          ? FluxFooter(
              actions: [
                TextButton(onPressed: () {}, child: const Text('Primary')),
                TextButton(onPressed: () {}, child: const Text('Secondary')),
              ],
            )
          : null,
      fullWidth: layoutMode == FluxLayoutMode.row,
      width: layoutMode == FluxLayoutMode.row ? width : null,
      height: layoutMode == FluxLayoutMode.row ? height : null,
      theme: theme,
      onTap: () {},
    ),
  );
}

@widgetbook.UseCase(name: 'Column layout', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildColumnLayoutUseCase(BuildContext context) {
  return _demoCardShell(
    context: context,
    card: FluxCard(
      layout: const FluxCardLayout.column(),
      media: FluxMedia.cover(
        aspectRatio: 16 / 9,
        height: 220,
        child: Image.network(demoProducts.first.image, fit: BoxFit.cover),
      ),
      header: const FluxHeader(title: Text('Column layout'), subtitle: Text('Media on top, content below.')),
      content: const Text('This layout is ideal for feeds and cards that need a natural vertical stack.'),
      footer: const FluxFooter(actions: [Text('Learn more'), Icon(Icons.arrow_forward)]),
      theme: FluxCardThemeData.elevated,
    ),
  );
}

@widgetbook.UseCase(name: 'Row layout', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildRowLayoutUseCase(BuildContext context) {
  final product = demoProducts[1];
  return _demoCardShell(
    context: context,
    maxWidth: 820,
    card: FluxCard(
      layout: const FluxCardLayout.row(),
      media: FluxMedia.cover(
        width: 260,
        child: Image.network(product.image, fit: BoxFit.cover),
      ),
      header: FluxHeader(title: Text(product.name), subtitle: Text(product.brand)),
      content: const Text('Row cards work well when you want a strong visual beside concise details.'),
      footer: FluxFooter(
        actions: [
          Text(product.priceLabel, style: const TextStyle(fontWeight: FontWeight.w900)),
          Text(product.formerPriceLabel, style: const TextStyle(decoration: TextDecoration.lineThrough)),
          ElevatedButton(onPressed: () {}, child: const Text('Add to cart')),
        ],
      ),
      theme: FluxCardThemeData.elevated,
    ),
  );
}

@widgetbook.UseCase(name: 'Stack layout', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildStackLayoutUseCase(BuildContext context) {
  final destination = demoDestinations.first;
  return _demoCardShell(
    context: context,
    maxWidth: 560,
    card: FluxCard(
      layout: const FluxCardLayout.stack(),
      media: FluxMedia.cover(
        aspectRatio: 1.35,
        height: 320,
        child: Image.network(destination.image, fit: BoxFit.cover),
      ),
      overlay: const FluxOverlay(
        alignment: Alignment.topRight,
        children: [
          Chip(
            label: Text('TOP PICK', style: TextStyle(fontSize: 10, color: Colors.white)),
            backgroundColor: Colors.black87,
            side: BorderSide.none,
          ),
        ],
      ),
      header: const FluxHeader(
        title: Text('Stack layout'),
        subtitle: Text('Content sits over the media.'),
      ),
      content: const Text('Use stack mode for hero cards, featured destinations, and promotional cards.'),
      footer: FluxFooter(
        actions: [
          Text(destination.priceLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
          ElevatedButton(onPressed: () {}, child: const Text('Book now')),
        ],
      ),
      theme: FluxCardThemeData.elevated,
    ),
  );
}

@widgetbook.UseCase(name: 'Responsive card', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildResponsiveLayoutUseCase(BuildContext context) {
  final useWideSurface = context.knobs.boolean(label: 'Wide surface', initialValue: false);
  final width = useWideSurface ? 920.0 : 420.0;
  final product = demoProducts.last;

  return _demoCardShell(
    context: context,
    maxWidth: width,
    card: FluxCard(
      layout: const FluxCardLayout.responsive(),
      media: FluxMedia.cover(
        aspectRatio: 16 / 9,
        height: 260,
        child: Image.network(product.image, fit: BoxFit.cover),
      ),
      header: const FluxHeader(
        title: Text('Responsive layout'),
        subtitle: Text('Switches between column and row automatically.'),
      ),
      content: const Text('Resize the viewport addon or toggle the surface width knob to see the layout switch.'),
      footer: FluxFooter(
        actions: [
          Text(product.priceLabel, style: const TextStyle(fontWeight: FontWeight.w900)),
          ElevatedButton(onPressed: () {}, child: const Text('Checkout')),
        ],
      ),
      theme: FluxCardThemeData.elevated,
    ),
  );
}

@widgetbook.UseCase(name: 'Empty shell', type: FluxCard, path: '[Flux Card]/Cards')
Widget buildEmptyShellUseCase(BuildContext context) {
  return _demoCardShell(
    context: context,
    card: const FluxCard(
      background: ColoredBox(color: Color(0xFFE2E8F0)),
      theme: FluxCardThemeData.standard,
    ),
    maxWidth: 360,
  );
}
